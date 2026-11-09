<?php

namespace App\Support;

use Carbon\CarbonInterface;
use Illuminate\Support\Carbon;

/**
 * Time measured against a station's time limit counts working days only:
 * Saturdays and Sundays (Manila calendar) are skipped, so a paper received
 * Friday afternoon is not overdue by Monday morning. Only the arithmetic
 * changes; the stored limits (sla_minutes) and timestamps stay as they are.
 */
final class WorkingTime
{
    public const TZ = 'Asia/Manila';

    /** Weekday minutes from $from to $to (0 when $to is not after $from). */
    public static function minutesBetween(?CarbonInterface $from, ?CarbonInterface $to): int
    {
        if (!$from || !$to) return 0;

        $cursor = Carbon::instance($from)->setTimezone(self::TZ);
        $end = Carbon::instance($to)->setTimezone(self::TZ);
        if ($end <= $cursor) return 0;

        $seconds = 0;
        while ($cursor < $end) {
            $nextDay = $cursor->copy()->startOfDay()->addDay();
            $segmentEnd = $nextDay < $end ? $nextDay : $end;
            if (!$cursor->isWeekend()) {
                $seconds += $cursor->diffInSeconds($segmentEnd, true);
            }
            $cursor = $segmentEnd;
        }

        return intdiv((int) $seconds, 60);
    }
}
