<?php

namespace Tests\Unit;

use App\Support\ReportPeriod;
use Illuminate\Support\Carbon;
use Tests\TestCase;

class ReportPeriodTest extends TestCase
{
    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    public function test_today_uses_the_manila_calendar_day(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-11-24 03:00:00', 'UTC')); // 11:00 Manila

        [$from, $to, $label] = ReportPeriod::resolve('today');

        $this->assertSame('Today', $label);
        $this->assertSame('2026-11-23 16:00:00', $from->utc()->format('Y-m-d H:i:s'));
        $this->assertSame('2026-11-24 16:00:00', $to->utc()->format('Y-m-d H:i:s'));
    }

    public function test_this_week_runs_monday_to_sunday_in_manila(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-11-24 03:00:00', 'UTC')); // Tuesday 11:00 Manila

        [$from, $to, $label] = ReportPeriod::resolve('this_week');

        $this->assertSame('This week (Nov 23–29)', $label);
        $this->assertSame('2026-11-22 16:00:00', $from->utc()->format('Y-m-d H:i:s'));
        $this->assertSame('2026-11-29 16:00:00', $to->utc()->format('Y-m-d H:i:s'));
    }
}
