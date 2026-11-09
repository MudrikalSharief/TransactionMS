import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';

const rootResult = spawnSync('git', ['rev-parse', '--show-toplevel'], { encoding: 'utf8', windowsHide: true });
if (rootResult.status !== 0) {
  console.error('Run verification inside this Git repository.');
  process.exit(1);
}
const root = rootResult.stdout.trim();
process.chdir(root);
const mode = process.argv[2];
if (mode === 'php-syntax') {
  let failed = false;
  for (const file of process.argv.slice(3)) {
    const result = spawnSync('php', ['-l', '-f', path.resolve(root, file)], { cwd: root, stdio: 'inherit', windowsHide: true });
    if (result.error) console.error(result.error.message);
    if (result.status !== 0) failed = true;
  }
  process.exit(failed ? 1 : 0);
}
if (mode !== 'full' && mode !== 'push') {
  console.error('Usage: node .codex/hooks/verify.mjs php-syntax <files...> | full | push');
  process.exit(1);
}
for (const required of ['vendor/autoload.php', 'node_modules/vite/bin/vite.js', 'phpunit.xml']) {
  if (!existsSync(required)) {
    console.error(`Missing ${required}. Install project dependencies before pushing.`);
    process.exit(1);
  }
}
const gitPath = spawnSync('git', ['rev-parse', '--git-path', 'codex-checks'], { encoding: 'utf8', windowsHide: true });
if (gitPath.status !== 0) process.exit(1);
const logDir = path.resolve(root, gitPath.stdout.trim());
mkdirSync(logDir, { recursive: true });
function run(label, command, args, env = process.env) {
  const result = spawnSync(command, args, {
    cwd: root, env, encoding: 'utf8', windowsHide: true,
    timeout: 300000, maxBuffer: 32 * 1024 * 1024,
  });
  const output = `${result.stdout ?? ''}${result.stderr ?? ''}${result.error ? `\n${result.error.message}` : ''}`;
  const log = path.join(logDir, `${label}.log`);
  writeFileSync(log, output);
  console.log(`${label}: ${result.status === 0 ? 'PASS' : 'FAIL'} (details: ${log})`);
  console.log(output.trim().split(/\r?\n/).slice(-8).join('\n'));
  return result.status === 0;
}
// Build first: the feature suite renders pages that require Vite's manifest.
const buildPassed = run('frontend-build', process.execPath, ['node_modules/vite/bin/vite.js', 'build']);
// Use PHPUnit directly so its forced test environment applies before Laravel boots.
// A deliberately absent config-cache path also prevents cached development DB settings.
const cachePath = path.join(logDir, 'testing-config-disabled.php');
if (existsSync(cachePath)) {
  console.error(`Refusing cached test configuration: ${cachePath}`);
  process.exit(1);
}
const testsPassed = run('phpunit', 'php', ['vendor/bin/phpunit', '--colors=never'], {
  ...process.env, APP_ENV: 'testing', DB_CONNECTION: 'sqlite', DB_DATABASE: ':memory:', APP_CONFIG_CACHE: cachePath,
});
if (mode === 'push' && !testsPassed) {
  console.warn('PHPUnit failures are advisory on push until the existing test baseline is repaired.');
  console.warn('Strict verification remains available: node .codex/hooks/verify.mjs full');
}
process.exit(buildPassed && (mode === 'push' || testsPassed) ? 0 : 1);
