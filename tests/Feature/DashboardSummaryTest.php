<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionStepRun;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Dashboard "Transaction Summary" card. Completed counts by finalize date;
 * everything else by created date. Periods: last week (the previous Mon–Sun
 * calendar week in Manila), or a Manila month.
 */
class DashboardSummaryTest extends TestCase
{
    use RefreshDatabase;

    private User $admin;
    private TransactionType $payroll;
    private TransactionType $procurement;
    private WorkflowStep $payrollStep;
    private WorkflowStep $procurementStep;
    private Office $chrmo;

    protected function setUp(): void
    {
        parent::setUp();
        Carbon::setTestNow(Carbon::parse('2026-09-26 04:00:00', 'UTC')); // 12:00 Manila

        $this->admin = User::factory()->create();
        $this->admin->roles()->attach(Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])->id);

        $this->payroll = TransactionType::create(['code' => 'payroll', 'name' => 'Payroll']);
        $this->procurement = TransactionType::create(['code' => 'procurement', 'name' => 'Procurement']);
        $this->payrollStep = $this->stepFor($this->payroll, 60 * 24);      // 1-day SLA
        $this->procurementStep = $this->stepFor($this->procurement, 60 * 48); // 2-day SLA
        $this->chrmo = Office::create(['code' => 'CHRMO', 'name' => 'City Human Resource Management Office']);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    private function stepFor(TransactionType $type, int $sla): WorkflowStep
    {
        $wf = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);

        return WorkflowStep::create([
            'workflow_definition_id' => $wf->id,
            'order_number' => 1,
            'code' => $type->code . '_start',
            'name' => $type->name . ' start',
            'is_start' => true,
            'sla_minutes' => $sla,
        ]);
    }

    /** Transaction created $createdDaysAgo, waiting at its step since $enteredHoursAgo. */
    private function tx(TransactionType $type, int $createdDaysAgo, array $opts = []): Transaction
    {
        $step = $type->is($this->payroll) ? $this->payrollStep : $this->procurementStep;
        $created = now()->subDays($createdDaysAgo);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $step->workflow_definition_id,
            'office_id' => $opts['office'] ?? null,
            'reference_number' => 'TX-' . uniqid(),
            'is_done' => isset($opts['finalizedDaysAgo']),
            'created_by' => $this->admin->id,
        ]);
        $tx->forceFill(['created_at' => $created, 'updated_at' => $created])->saveQuietly();

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now()->subHours($opts['enteredHoursAgo'] ?? 1),
        ]);

        if (isset($opts['finalizedDaysAgo'])) {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $step->id,
                'to_step_id' => $step->id,
                'action_code' => 'finalize',
                'performed_by' => $this->admin->id,
                'performed_at' => now()->subDays($opts['finalizedDaysAgo']),
            ]);
        }

        if (!empty($opts['deleted'])) $tx->delete();

        return $tx;
    }

    private function summary(array $query = [])
    {
        Sanctum::actingAs($this->admin);

        return $this->getJson('/api/admin/dashboard/summary?' . http_build_query($query))->assertOk();
    }

    public function test_counts_each_status_in_the_previous_calendar_week(): void
    {
        // Now is Sat 26 Sep, 12:00 Manila, so last week is Mon 14 – Sun 20 Sep.
        $this->tx($this->payroll, 7, ['enteredHoursAgo' => 30]);        // in process, overdue (30h > 24h)
        $this->tx($this->payroll, 12, ['enteredHoursAgo' => 5]);        // created Mon 14: in process, on time
        $this->tx($this->procurement, 10, ['finalizedDaysAgo' => 6]);   // finalized Sun 20: completed
        $this->tx($this->procurement, 60, ['finalizedDaysAgo' => 8]);   // created long ago, finalized last week -> completed
        $this->tx($this->payroll, 9, ['finalizedDaysAgo' => 2]);        // finalized this week: not counted
        $this->tx($this->payroll, 50, ['finalizedDaysAgo' => 35]);      // finalized before the period: not counted
        $this->tx($this->payroll, 8, ['deleted' => true]);              // deleted
        $this->tx($this->payroll, 5, ['enteredHoursAgo' => 99]);        // created Mon 21 (this week): not counted
        $this->tx($this->payroll, 13, ['enteredHoursAgo' => 99]);       // created Sun 13 (week before): not counted

        $this->summary()
            ->assertJsonPath('period.key', 'last_week')
            ->assertJsonPath('period.label', 'Last week (Sep 14–20)')
            ->assertJsonPath('completed', 2)
            ->assertJsonPath('in_process', 2)
            ->assertJsonPath('overdue', 1)
            ->assertJsonPath('deleted', 1);
    }

    public function test_last_week_label_spans_two_months_when_the_week_does(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-10-07 04:00:00', 'UTC')); // Wed 7 Oct, Manila

        $this->summary()->assertJsonPath('period.label', 'Last week (Sep 28–Oct 4)');
    }

    public function test_month_period_uses_manila_month_boundaries(): void
    {
        // 2026-08-31 17:00 UTC is already Sept 1 in Manila (UTC+8).
        $sep1Manila = $this->tx($this->payroll, 0, ['enteredHoursAgo' => 1]);
        $sep1Manila->forceFill(['created_at' => Carbon::parse('2026-08-31 17:00:00', 'UTC')])->saveQuietly();
        // 2026-08-31 15:00 UTC is still Aug 31 in Manila.
        $aug31Manila = $this->tx($this->payroll, 0, ['enteredHoursAgo' => 1]);
        $aug31Manila->forceFill(['created_at' => Carbon::parse('2026-08-31 15:00:00', 'UTC')])->saveQuietly();

        $this->summary(['month' => '2026-09'])
            ->assertJsonPath('period.key', '2026-09')
            ->assertJsonPath('in_process', 1);

        $this->summary(['month' => '2026-08'])->assertJsonPath('in_process', 1);
    }

    public function test_process_and_office_filters_narrow_the_counts(): void
    {
        $this->tx($this->payroll, 2, ['office' => $this->chrmo->id]);
        $this->tx($this->payroll, 2);
        $this->tx($this->procurement, 2, ['office' => $this->chrmo->id]);

        $month = ['month' => '2026-09'];
        $this->summary($month + ['processes' => [$this->payroll->id]])->assertJsonPath('in_process', 2);
        $this->summary($month + ['offices' => [$this->chrmo->id]])->assertJsonPath('in_process', 2);
        $this->summary($month + ['processes' => [$this->payroll->id], 'offices' => [$this->chrmo->id]])
            ->assertJsonPath('in_process', 1);
    }

    public function test_office_code_limits_every_count_to_that_office(): void
    {
        $csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->tx($this->payroll, 2, ['office' => $csd->id]);
        $this->tx($this->procurement, 3, ['office' => $csd->id, 'finalizedDaysAgo' => 1]);
        $this->tx($this->payroll, 2, ['office' => $csd->id, 'deleted' => true]);
        $this->tx($this->payroll, 2, ['office' => $this->chrmo->id]);
        $this->tx($this->procurement, 2);

        // The code matches in any letter case.
        $this->summary(['month' => '2026-09', 'office_code' => 'csd'])
            ->assertJsonPath('in_process', 1)
            ->assertJsonPath('completed', 1)
            ->assertJsonPath('deleted', 1)
            ->assertJsonPath('by_process', [
                ['id' => $this->payroll->id, 'name' => 'Payroll', 'count' => 1],
                ['id' => $this->procurement->id, 'name' => 'Procurement', 'count' => 1],
            ]);

        $this->getJson('/api/admin/dashboard/summary/in_process?month=2026-09&office_code=CSD')
            ->assertOk()
            ->assertJsonPath('count', 1)
            ->assertJsonPath('rows.0.office.code', 'CSD');

        // An unknown office matches nothing; it never falls back to every office.
        $this->summary(['month' => '2026-09', 'office_code' => 'NOPE'])
            ->assertJsonPath('in_process', 0)
            ->assertJsonPath('by_process', []);
    }

    public function test_by_process_ignores_process_filter_but_respects_office(): void
    {
        $this->tx($this->payroll, 2, ['office' => $this->chrmo->id]);
        $this->tx($this->payroll, 3, ['office' => $this->chrmo->id, 'finalizedDaysAgo' => 1]);
        $this->tx($this->procurement, 2);
        $this->tx($this->procurement, 2, ['deleted' => true]); // deleted: not in by_process

        // Process filter must not hide the other processes (the card fades them instead).
        $this->summary(['month' => '2026-09', 'processes' => [$this->payroll->id]])
            ->assertJsonPath('by_process', [
                ['id' => $this->payroll->id, 'name' => 'Payroll', 'count' => 2],
                ['id' => $this->procurement->id, 'name' => 'Procurement', 'count' => 1],
            ]);

        $this->summary(['month' => '2026-09', 'offices' => [$this->chrmo->id]])
            ->assertJsonPath('by_process', [
                ['id' => $this->payroll->id, 'name' => 'Payroll', 'count' => 2],
            ]);
    }

    public function test_invalid_month_is_rejected(): void
    {
        Sanctum::actingAs($this->admin);

        $this->getJson('/api/admin/dashboard/summary?month=2026-13')->assertUnprocessable();
    }

    public function test_non_superadmin_is_forbidden(): void
    {
        $user = User::factory()->create();
        $user->roles()->attach(Role::create(['code' => 'gso', 'name' => 'GSO'])->id);
        Sanctum::actingAs($user);

        $this->getJson('/api/admin/dashboard/summary')->assertForbidden();
    }
}
