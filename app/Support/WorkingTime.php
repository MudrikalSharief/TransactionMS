<?php

namespace App\Support;

use Carbon\CarbonInterface;
use Illuminate\Support\Carbon;

/**
 * Time against a station's time limit counts only office working hours:
 * Monday-Friday, 08:00-12:00 and 13:00-17:00 (Asia/Manila). Weekends and
 * configured holidays are skipped. Only the arithmetic changes; the stored
 * limits (sla_minutes) and timestamps stay as they are.
 */
final class WorkingTime
{
    public const TZ = 'Asia/Manila';

    public static function timezone(): string
    {
        return (string) config('working_time.timezone', self::TZ);
    }

    /** Working minutes between two timestamps inside the configured windows. */
    public static function minutesBetween(?CarbonInterface $from, ?CarbonInterface $to): int
    {
        if (!$from || !$to) return 0;

        $tz = self::timezone();
        $start = Carbon::instance($from)->setTimezone($tz);
        $end = Carbon::instance($to)->setTimezone($tz);
        if ($end <= $start) return 0;

        $windows = self::windows();
        $days = array_map('intval', (array) config('working_time.days', [1, 2, 3, 4, 5]));
        $holidays = array_flip((array) config('working_time.holidays', []));

        $seconds = 0;
        $day = $start->copy()->startOfDay();
        $last = $end->copy()->startOfDay();

        while ($day <= $last) {
            $date = $day->format('Y-m-d');
            if (in_array((int) $day->dayOfWeekIso, $days, true) && !isset($holidays[$date])) {
                foreach ($windows as [$open, $close]) {
                    $windowStart = $day->copy()->setTimeFromTimeString($open);
                    $windowEnd = $day->copy()->setTimeFromTimeString($close);
                    if ($windowEnd <= $windowStart) continue;

                    $segmentStart = $windowStart->greaterThan($start) ? $windowStart : $start;
                    $segmentEnd = $windowEnd->lessThan($end) ? $windowEnd : $end;
                    if ($segmentEnd > $segmentStart) {
                        $seconds += $segmentStart->diffInSeconds($segmentEnd, true);
                    }
                }
            }
            $day->addDay();
        }

        return intdiv((int) $seconds, 60);
    }

    /** Minutes in one configured working day (480 with the default windows). */
    public static function workdayMinutes(): int
    {
        $minutes = 0;
        foreach (self::windows() as [$open, $close]) {
            $start = Carbon::parse('2000-01-03 '.$open, self::timezone());
            $end = Carbon::parse('2000-01-03 '.$close, self::timezone());
            if ($end > $start) $minutes += (int) $start->diffInMinutes($end);
        }

        return $minutes;
    }

    /** @return array<int, array{0:string,1:string}> */
    private static function windows(): array
    {
        $windows = [];
        foreach ((array) config('working_time.windows', []) as $window) {
            if (!is_array($window) || count($window) < 2) continue;
            $windows[] = [(string) $window[0], (string) $window[1]];
        }

        return $windows ?: [['08:00', '12:00'], ['13:00', '17:00']];
    }
}
