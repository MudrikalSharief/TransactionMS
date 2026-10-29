@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "BASE=%~dp0"
set "XAMPP=C:\xampp"
set "MYSQL_HOME=%XAMPP%\mysql"
set "MYSQLD=%MYSQL_HOME%\bin\mysqld.exe"
set "MYSQLADMIN=%MYSQL_HOME%\bin\mysqladmin.exe"
set "MYSQLCHECK=%MYSQL_HOME%\bin\mysqlcheck.exe"
set "ARIA_CHK=%MYSQL_HOME%\bin\aria_chk.exe"
set "MYSQL_INI=%MYSQL_HOME%\bin\my.ini"
set "DATA=%MYSQL_HOME%\data"
set "HTTPD=%XAMPP%\apache\bin\httpd.exe"
set "LOG=%BASE%logs\watchdog.log"
set "LOCK=%BASE%watchdog.running"
set "PAUSE_FILE=%BASE%watchdog.pause"
set "ALERT_FILE=%BASE%WATCHDOG-ALERT.txt"
set "REPAIR_BACKUP=%BASE%logs\repair-backup"
set "MYSQL_USER=root"
set "MYSQL_DB=transaction"
set "CHECK_INTERVAL=10"
set "START_TIMEOUT=30"
set "STABLE_CHECKS=30"
set "MAX_CRASHES=3"
set "MONITOR_APACHE=1"

if not exist "%BASE%logs" mkdir "%BASE%logs" >nul 2>&1

if /I "%~1"=="install" goto :install
if /I "%~1"=="uninstall" goto :uninstall
if /I "%~1"=="pause" goto :pause
if /I "%~1"=="resume" goto :resume
if /I "%~1"=="status" goto :status
if /I "%~1"=="repair" goto :manual_repair
if /I "%~1"=="--help" goto :usage
if /I "%~1"=="-h" goto :usage
if /I "%~1"=="run" goto :main

start "XAMPP Watchdog" /MIN "%COMSPEC%" /c ""%~f0" run"
exit /b 0

:usage
echo Usage:
echo   xampp-watchdog.bat            Start watchdog
echo   xampp-watchdog.bat install    Add watchdog to current user Startup
echo   xampp-watchdog.bat uninstall  Remove from Startup and stop watchdog
echo   xampp-watchdog.bat pause      Pause automatic restarts
echo   xampp-watchdog.bat resume     Resume automatic restarts
echo   xampp-watchdog.bat status     Show watchdog and service state
echo   xampp-watchdog.bat repair     Stop MySQL and run Aria repair now
exit /b 0

:main
title XAMPP Watchdog
call :rotate_log
call :log "Watchdog starting."

if not exist "%MYSQLD%" (
    call :log "mysqld.exe not found at %MYSQLD%; exiting."
    exit /b 1
)

sc query MySQL >nul 2>&1
if not errorlevel 1 (
    call :log "MySQL is installed as a Windows service; watchdog exiting to avoid conflict."
    exit /b 0
)

sc query Apache2.4 >nul 2>&1
if not errorlevel 1 (
    call :log "Apache2.4 Windows service detected; Apache monitoring disabled."
    set "MONITOR_APACHE=0"
)

if exist "%LOCK%" (
    call :log "Existing lock found; checking for another watchdog instance."
    powershell -NoProfile -Command "$p=@(Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'cmd.exe' -and $_.CommandLine -match 'xampp-watchdog' }); if($p.Count -gt 1){exit 1}" >nul 2>&1
    if errorlevel 1 (
        call :log "Another watchdog is already running; exiting."
        exit /b 0
    )
    rmdir /s /q "%LOCK%" >nul 2>&1
)
mkdir "%LOCK%" >nul 2>&1
if errorlevel 1 (
    call :log "Could not create watchdog lock; exiting."
    exit /b 1
)

set /a CRASHES=0
set /a HEALTHY=0
set /a PING_FAILS=0
set /a APACHE_FAILS=0
set /a PAUSED=0

:loop
if exist "%PAUSE_FILE%" (
    if !PAUSED! EQU 0 (
        call :log "Paused. Remove %PAUSE_FILE% or run resume to re-enable restarts."
        set /a PAUSED=1
    )
    call :sleep %CHECK_INTERVAL%
    goto :loop
)
if !PAUSED! EQU 1 (
    call :log "Resumed."
    set /a PAUSED=0
)

if not exist "%MYSQLD%" (
    call :log "mysqld.exe disappeared; exiting."
    goto :cleanup
)

tasklist /FI "IMAGENAME eq mysqld.exe" /NH 2>nul | find /I "mysqld.exe" >nul
if errorlevel 1 (
    set /a CRASHES+=1
    set /a HEALTHY=0
    set /a PING_FAILS=0
    call :log "MySQL is not running. Crash count: !CRASHES!."
    call :crash_tail
    if !CRASHES! GEQ %MAX_CRASHES% (
        call :auto_repair
        if errorlevel 1 (
            call :alert "MySQL auto-repair failed. Manual recovery required. See %LOG%"
            goto :cleanup
        )
        set /a CRASHES=0
    )
    call :start_mysql
    if errorlevel 1 call :log "MySQL did not become ready after start."
) else (
    "%MYSQLADMIN%" --user=%MYSQL_USER% --connect-timeout=5 ping >nul 2>&1
    if errorlevel 1 (
        set /a PING_FAILS+=1
        set /a HEALTHY=0
        call :log "MySQL process exists but is not responding. Ping failures: !PING_FAILS!."
        if !PING_FAILS! GEQ 3 (
            call :log "MySQL appears hung; attempting graceful shutdown."
            call :stop_mysql
            set /a PING_FAILS=0
            set /a CRASHES+=1
            if !CRASHES! GEQ %MAX_CRASHES% (
                call :auto_repair
                if errorlevel 1 (
                    call :alert "MySQL auto-repair failed. Manual recovery required. See %LOG%"
                    goto :cleanup
                )
                set /a CRASHES=0
            )
            call :start_mysql
        )
    ) else (
        set /a PING_FAILS=0
        set /a HEALTHY+=1
        if !HEALTHY! GEQ %STABLE_CHECKS% (
            if !CRASHES! GTR 0 call :log "MySQL stable; resetting crash counter."
            set /a CRASHES=0
        )
    )
)

if "%MONITOR_APACHE%"=="1" (
    tasklist /FI "IMAGENAME eq httpd.exe" /NH 2>nul | find /I "httpd.exe" >nul
    if errorlevel 1 (
        set /a APACHE_FAILS+=1
        call :log "Apache is not running. Start attempt: !APACHE_FAILS!."
        call :start_apache
        if !APACHE_FAILS! GEQ 5 (
            call :log "Apache failed 5 times; waiting 5 minutes before retrying."
            set /a APACHE_FAILS=0
            call :sleep 300
        )
    ) else (
        set /a APACHE_FAILS=0
    )
)

call :sleep %CHECK_INTERVAL%
goto :loop

:start_mysql
call :log "Starting MySQL."
powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%MYSQLD%' -ArgumentList '--defaults-file=%MYSQL_INI%','--standalone' -WindowStyle Hidden" >>"%LOG%" 2>&1
call :wait_mysql %START_TIMEOUT%
if errorlevel 1 (
    call :log "MySQL did not respond within %START_TIMEOUT% seconds."
    exit /b 1
)
call :log "MySQL is up."
set /a HEALTHY=0
set /a PING_FAILS=0
exit /b 0

:wait_mysql
set /a W=0
:wait_mysql_loop
"%MYSQLADMIN%" --user=%MYSQL_USER% --connect-timeout=5 ping >nul 2>&1
if not errorlevel 1 exit /b 0
call :sleep 1
set /a W+=1
if !W! LSS %~1 goto :wait_mysql_loop
exit /b 1

:stop_mysql
call :log "Stopping MySQL."
powershell -NoProfile -WindowStyle Hidden -Command "$p=Start-Process -FilePath '%MYSQLADMIN%' -ArgumentList '--user=%MYSQL_USER%','--connect-timeout=5','shutdown' -PassThru -WindowStyle Hidden; if(-not $p.WaitForExit(20000)){try{$p.Kill()}catch{}; exit 1}" >>"%LOG%" 2>&1
if errorlevel 1 call :log "mysqladmin shutdown timed out; forcing."
set /a W=0
:stop_mysql_loop
tasklist /FI "IMAGENAME eq mysqld.exe" /NH 2>nul | find /I "mysqld.exe" >nul
if errorlevel 1 exit /b 0
call :sleep 1
set /a W+=1
if !W! LSS 20 goto :stop_mysql_loop
call :log "MySQL did not stop gracefully; forcing process stop."
taskkill /IM mysqld.exe /F >nul 2>&1
call :sleep 2
exit /b 0

:auto_repair
call :log "AUTO-REPAIR: repeated crashes detected."
call :stop_mysql
for /f %%T in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set "TS=%%T"
set "RB=%REPAIR_BACKUP%\mysql-%TS%"
if not exist "%REPAIR_BACKUP%" mkdir "%REPAIR_BACKUP%" >nul 2>&1
robocopy "%DATA%\mysql" "%RB%" /E /R:1 /W:1 /NFL /NDL /NJH /NJS >nul 2>&1
if errorlevel 8 call :log "Warning: could not copy system tables before repair."
call :log "Checking Aria system tables."
pushd "%DATA%"
for %%F in ("mysql\*.MAI") do (
    "%ARIA_CHK%" --datadir="%DATA%" --check "%%~dpnF" >nul 2>&1
    if errorlevel 1 (
        call :log "Repairing %%~nxF"
        "%ARIA_CHK%" --datadir="%DATA%" --safe-recover "%%~dpnF" >>"%LOG%" 2>&1
    )
)
popd
call :start_mysql
if errorlevel 1 exit /b 1
call :log "Running mysqlcheck auto-repair on database %MYSQL_DB%."
"%MYSQLCHECK%" --user=%MYSQL_USER% --connect-timeout=5 --auto-repair --databases %MYSQL_DB% >>"%LOG%" 2>&1
call :log "AUTO-REPAIR finished."
exit /b 0

:start_apache
if not exist "%HTTPD%" (
    call :log "httpd.exe not found; disabling Apache monitoring."
    set "MONITOR_APACHE=0"
    exit /b 1
)
powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%HTTPD%' -WindowStyle Hidden" >>"%LOG%" 2>&1
call :sleep 3
tasklist /FI "IMAGENAME eq httpd.exe" /NH 2>nul | find /I "httpd.exe" >nul
if errorlevel 1 (
    call :log "Apache failed to start."
    exit /b 1
)
call :log "Apache is up."
exit /b 0

:crash_tail
if exist "%DATA%\mysql_error.log" (
    >>"%LOG%" echo ----- mysql_error.log tail -----
    powershell -NoProfile -Command "Get-Content '%DATA%\mysql_error.log' -Tail 40" >>"%LOG%" 2>&1
    >>"%LOG%" echo -------------------------------
)
exit /b

:sleep
set /a S=%~1+1
ping -n !S! 127.0.0.1 >nul
exit /b

:log
set "MSG=%~1"
>>"%LOG%" echo [%date% %time%] %MSG%
exit /b

:rotate_log
if exist "%LOG%" for %%A in ("%LOG%") do if %%~zA GTR 5242880 (
    move /Y "%LOG%" "%LOG%.old" >nul 2>&1
)
exit /b

:alert
call :log "ALERT: %~1"
>>"%ALERT_FILE%" echo [%date% %time%] %~1
powershell -NoProfile -Command "[console]::beep(1200,600)" >nul 2>&1
where msg >nul 2>&1 && msg * /TIME:60 "XAMPP Watchdog: %~1" >nul 2>&1
exit /b

:install
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%STARTUP%\XAMPP Watchdog.lnk'); $s.TargetPath='%BASE%xampp-watchdog.bat'; $s.Arguments='run'; $s.WorkingDirectory='%BASE%'; $s.WindowStyle=7; $s.Save()"
if exist "%STARTUP%\XAMPP Watchdog.lnk" (
    echo Installed: %STARTUP%\XAMPP Watchdog.lnk
) else (
    echo Failed to create Startup shortcut.
)
exit /b 0

:uninstall
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP%\XAMPP Watchdog.lnk" del /F /Q "%STARTUP%\XAMPP Watchdog.lnk" >nul 2>&1
call :pause
taskkill /FI "WINDOWTITLE eq XAMPP Watchdog*" /T /F >nul 2>&1
del /F /Q "%PAUSE_FILE%" >nul 2>&1
if exist "%LOCK%" rmdir /s /q "%LOCK%" >nul 2>&1
echo Watchdog removed from Startup and stopped.
exit /b 0

:pause
> "%PAUSE_FILE%" echo paused
echo Watchdog paused. Restarts will not run until resumed.
exit /b 0

:resume
if exist "%PAUSE_FILE%" del /F /Q "%PAUSE_FILE%" >nul 2>&1
echo Watchdog resumed.
exit /b 0

:status
if exist "%PAUSE_FILE%" (echo State: PAUSED) else (echo State: ACTIVE)
tasklist /FI "WINDOWTITLE eq XAMPP Watchdog*" /NH 2>nul | find /I "cmd.exe" >nul
if errorlevel 1 (echo Watchdog process: not running) else (echo Watchdog process: running)
tasklist /FI "IMAGENAME eq mysqld.exe" /NH 2>nul | find /I "mysqld.exe" >nul
if errorlevel 1 (echo MySQL: not running) else (echo MySQL: running)
tasklist /FI "IMAGENAME eq httpd.exe" /NH 2>nul | find /I "httpd.exe" >nul
if errorlevel 1 (echo Apache: not running) else (echo Apache: running)
if exist "%LOG%" (
    echo Recent watchdog log:
    powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 10"
)
exit /b 0

:manual_repair
echo This will stop MySQL and run Aria safe-recover on its system tables.
set /p "CONFIRM=Continue? [y/N] "
if /I not "%CONFIRM%"=="y" exit /b 0
call :auto_repair
if errorlevel 1 (
    echo Auto-repair failed. See "%LOG%".
    exit /b 1
)
echo Repair finished.
exit /b 0

:cleanup
rmdir "%LOCK%" >nul 2>&1
exit /b 0
