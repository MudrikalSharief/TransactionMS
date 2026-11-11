<?php

namespace App\Support;

use Illuminate\Support\Carbon;

/**
 * The Period filter shared with the dashboards: 'all', 'this_week'
 * (Monday–Sunday) or a month 'YYYY-MM', on the Manila calendar.
 */
final class ReportPeriod
{
    public const RULE = 'regex:/^(all|this_week|\d{4}-(0[1-9]|1[0-2]))$/';

    /** @return array{0: ?Carbon, 1: ?Carbon, 2: string} [from, to) in UTC (null = all time) and a label. */
    public static function resolve(?string $period): array
    {
        $period = $period ?: 'all';
        if ($period === 'all') return [null, null, 'All time'];

        if ($period === 'this_week') {
            $start = now(WorkingTime::TZ)->startOfWeek(Carbon::MONDAY);
            $end = $start->copy()->addWeek();
            $sunday = $end->copy()->subDay();
            $label = sprintf('This week (%s–%s)', $start->format('M j'), $sunday->format($sunday->isSameMonth($start) ? 'j' : 'M j'));
        } else {
            $start = Carbon::parse("{$period}-01 00:00:00", WorkingTime::TZ);
            $end = $start->copy()->addMonthNoOverflow();
            $label = $start->format('F Y');
        }

        return [$start->copy()->utc(), $end->copy()->utc(), $label];
    }

    public static function contains(?Carbon $from, ?Carbon $to, $at): bool
    {
        if (!$at) return false;
        if (!$from) return true;

        return $at >= $from && $at < $to;
    }
}
