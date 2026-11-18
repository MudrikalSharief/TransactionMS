<?php

namespace Tests\Unit;

use App\Support\WorkingTime;
use Illuminate\Support\Carbon;
use Tests\TestCase;

class WorkingTimeTest extends TestCase
{
    private function manila(string $dateTime): Carbon
    {
        return Carbon::parse($dateTime, 'Asia/Manila');
    }

    public function test_a_working_day_is_eight_hours_with_a_lunch_break(): void
    {
        $this->assertSame(480, WorkingTime::workdayMinutes());
        $this->assertSame(
            480,
            WorkingTime::minutesBetween(
                $this->manila('2026-10-28 08:00:00'),
                $this->manila('2026-10-28 17:00:00'),
            ),
        );
    }

    public function test_lunch_and_time_outside_office_hours_are_not_counted(): void
    {
        $this->assertSame(
            0,
            WorkingTime::minutesBetween(
                $this->manila('2026-10-28 12:00:00'),
                $this->manila('2026-10-28 13:00:00'),
            ),
        );
        $this->assertSame(
            0,
            WorkingTime::minutesBetween(
                $this->manila('2026-10-28 17:00:00'),
                $this->manila('2026-10-28 20:00:00'),
            ),
        );
    }

    public function test_weekends_are_skipped(): void
    {
        // Friday 16:00-17:00 plus Monday 08:00-09:00 = 2 working hours.
        $this->assertSame(
            120,
            WorkingTime::minutesBetween(
                $this->manila('2026-10-30 16:00:00'),
                $this->manila('2026-11-02 09:00:00'),
            ),
        );
    }

    public function test_receive_to_send_time_uses_office_hours(): void
    {
        // Friday 10:00-12:00 + 13:00-15:00 = 4 working hours.
        $this->assertSame(
            240,
            WorkingTime::minutesBetween(
                $this->manila('2026-10-30 10:00:00'),
                $this->manila('2026-10-30 15:00:00'),
            ),
        );
    }
}
