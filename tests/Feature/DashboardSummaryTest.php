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
 * everything else by created date. Periods: this week (the current Mon–Sun
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
        $this->payrollStep = $this->stepFor($this->payroll, 480);      // 1 working day
        $this->procurementStep = $this->stepFor($this->procurement, 960); // 2 working days
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

        $enteredAt = isset($opts['finalizedDaysAgo'])
            ? $created
            : now()->subHours($opts['enteredHoursAgo'] ?? 1);

        $currentRunId = null;
        if (empty($opts['manualRuns'])) {
            $run = TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $step->id,
                'to_step_id' => $step->id,
                'action_code' => 'create',
                'performed_by' => $this->admin->id,
                'performed_at' => $enteredAt,
                // Creation is auto-received, so working time starts here.
                'received_at' => $enteredAt,
                'received_by' => $this->admin->id,
                'sla_minutes_snapshot' => (int) $step->sla_minutes,
            ]);
            $currentRunId = $run->id;
        }

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'current_run_id' => $currentRunId,
            'entered_at' => $enteredAt,
        ]);

        if (isset($opts['finalizedDaysAgo'])) {
            $finalizedAt = now()->subDays($opts['finalizedDaysAgo']);
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $step->id,
                'to_step_id' => $step->id,
                'action_code' => 'finalize',
                'performed_by' => $this->admin->id,
                'performed_at' => $finalizedAt,
                'received_at' => $finalizedAt,
                'received_by' => $this->admin->id,
                'sla_minutes_snapshot' => (int) $step->sla_minutes,
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

    public function test_counts_each_status_in_the_current_calendar_week(): void
    {
        // Now is Sat 26 Sep, 12:00 Manila, so this week is Mon 21 – Sun 27 Sep.
        $this->tx($this->payroll, 3, ['enteredHoursAgo' => 48]);        // in process, overdue (12 working hours > 8)
        $this->tx($this->payroll, 5, ['enteredHoursAgo' => 5]);         // created Mon 21: in process, on time
        $this->tx($this->procurement, 10, ['finalizedDaysAgo' => 1]);   // finalized this week: completed
        $this->tx($this->procurement, 60, ['finalizedDaysAgo' => 4]);   // created long ago, finalized Tue 22 -> completed
        $this->tx($this->payroll, 9, ['finalizedDaysAgo' => 6]);        // finalized Sun 20 (last week): not counted
        $this->tx($this->payroll, 50, ['finalizedDaysAgo' => 35]);      // finalized before the period: not counted
        $this->tx($this->payroll, 2, ['deleted' => true]);              // deleted
        $this->tx($this->payroll, 6, ['enteredHoursAgo' => 99]);        // created Sun 20 (last week): not counted

        $this->summary()
            ->assertJsonPath('period.key', 'this_week')
            ->assertJsonPath('period.label', 'This week (Sep 21–27)')
            ->assertJsonPath('completed', 2)
            ->assertJsonPath('in_process', 2)
            ->assertJsonPath('overdue', 1)
            ->assertJsonPath('deleted', 1);
    }

    public function test_summary_separates_pending_receipts_from_working_time(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-09-23 04:00:00', 'UTC')); // Wed 12:00 Manila

        // Received at the station one hour ago: 60 working minutes.
        $this->tx($this->payroll, 1);

        // Sent two hours ago and not received yet: 120 pending minutes,
        // no working clock and no SLA.
        $pending = $this->tx($this->payroll, 1, ['manualRuns' => true]);
        TransactionStepRun::create([
            'transaction_id' => $pending->id,
            'from_step_id' => $this->payrollStep->id,
            'to_step_id' => $this->payrollStep->id,
            'action_code' => 'create',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subHours(2),
            'received_at' => null,
            'sla_minutes_snapshot' => 480,
        ]);

        $this->summary()
            ->assertJsonPath('pending_transactions', 1)
            ->assertJsonPath('working_transactions', 1)
            ->assertJsonPath('pending_minutes', 120)
            ->assertJsonPath('oldest_pending_minutes', 120)
            ->assertJsonPath('working_minutes', 60)
            ->assertJsonPath('oldest_working_minutes', 60);
    }

    public function test_this_week_label_spans_two_months_when_the_week_does(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-09-30 04:00:00', 'UTC')); // Wed 30 Sep, Manila

        $this->summary()->assertJsonPath('period.label', 'This week (Sep 28–Oct 4)');
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

    public function test_monthly_status_series_covers_the_last_three_months(): void
    {
        // July: one open, on time.
        $this->tx($this->payroll, 70, ['enteredHoursAgo' => 1]);
        // August: one open overdue, one completed (created July, finalized August).
        $this->tx($this->payroll, 40, ['enteredHoursAgo' => 999]);
        $this->tx($this->procurement, 70, ['finalizedDaysAgo' => 40]);
        // September: one completed, one open.
        $this->tx($this->procurement, 2, ['finalizedDaysAgo' => 1]);
        $this->tx($this->payroll, 2, ['enteredHoursAgo' => 1]);

        $this->summary()
            ->assertJsonCount(3, 'monthly')
            ->assertJsonPath('monthly.0.month', '2026-07')
            ->assertJsonPath('monthly.0.label', 'Jul 2026')
            ->assertJsonPath('monthly.0.completed', 0)
            ->assertJsonPath('monthly.0.in_process', 1)
            ->assertJsonPath('monthly.0.overdue', 0)
            ->assertJsonPath('monthly.1.month', '2026-08')
            ->assertJsonPath('monthly.1.label', 'Aug 2026')
            ->assertJsonPath('monthly.1.completed', 1)
            ->assertJsonPath('monthly.1.in_process', 0)
            ->assertJsonPath('monthly.1.overdue', 1)
            ->assertJsonPath('monthly.2.month', '2026-09')
            ->assertJsonPath('monthly.2.label', 'Sep 2026')
            ->assertJsonPath('monthly.2.completed', 1)
            ->assertJsonPath('monthly.2.in_process', 1)
            ->assertJsonPath('monthly.2.overdue', 0);

        // The Period filter does not move this fixed graph window.
        $this->summary(['month' => '2026-07'])
            ->assertJsonCount(3, 'monthly')
            ->assertJsonPath('monthly.0.month', '2026-07')
            ->assertJsonPath('monthly.2.month', '2026-09');
    }

    public function test_monthly_status_series_respects_office_filters(): void
    {
        $this->tx($this->payroll, 2, ['office' => $this->chrmo->id]);
        $this->tx($this->payroll, 2);

        $this->summary()->assertJsonPath('monthly.2.in_process', 2);
        $this->summary(['offices' => [$this->chrmo->id]])
            ->assertJsonPath('monthly.2.in_process', 1);
        $this->summary(['office_code' => 'chrmo'])
            ->assertJsonPath('monthly.2.in_process', 1);
    }

    public function test_step_and_transaction_overdue_counts_use_different_rules(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-09-23 04:00:00', 'UTC')); // Wed 12:00 Manila

        $this->payrollStep->update(['sla_minutes' => 60]);
        $endStep = WorkflowStep::create([
            'workflow_definition_id' => $this->payrollStep->workflow_definition_id,
            'order_number' => 2,
            'code' => 'payroll_end',
            'name' => 'Payroll end',
            'is_end' => true,
            'sla_minutes' => 60,
        ]);
        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $addRun = function (Transaction $tx, int $fromStep, int $toStep, int $minutesAgo, string $action = 'proceed') {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $fromStep,
                'to_step_id' => $toStep,
                'action_code' => $action,
                'performed_by' => $this->admin->id,
                'performed_at' => now()->subMinutes($minutesAgo),
                'received_at' => now()->subMinutes($minutesAgo),
                'sla_minutes_snapshot' => 60,
            ]);
        };

        // Both visits are over 60 minutes: 120 + 120 = 240 actual vs 120 SLA.
        $bothOver = $this->tx($this->payroll, 1, ['office' => $this->chrmo->id, 'manualRuns' => true]);
        $addRun($bothOver, $this->payrollStep->id, $this->payrollStep->id, 300, 'create');
        $addRun($bothOver, $this->payrollStep->id, $endStep->id, 120);
        TransactionState::where('transaction_id', $bothOver->id)->update([
            'current_step_id' => $endStep->id,
            'entered_at' => now()->subMinutes(120),
        ]);

        // One visit over (90) and one under (30): total 120 actual vs 120 SLA.
        $onlyOneOver = $this->tx($this->payroll, 1, ['office' => $gso->id, 'manualRuns' => true]);
        $addRun($onlyOneOver, $this->payrollStep->id, $this->payrollStep->id, 120, 'create');
        $addRun($onlyOneOver, $this->payrollStep->id, $endStep->id, 30);
        TransactionState::where('transaction_id', $onlyOneOver->id)->update([
            'current_step_id' => $endStep->id,
            'entered_at' => now()->subMinutes(30),
        ]);

        // Completed paper: its step visit ran for a full day against a
        // 60-minute SLA, so its total exceeds the limit even though it is
        // finalized (the helper adds the finalize run one day ago).
        $doneOver = $this->tx($this->payroll, 3, ['office' => $this->chrmo->id, 'finalizedDaysAgo' => 1, 'manualRuns' => true]);
        $addRun($doneOver, $this->payrollStep->id, $this->payrollStep->id, 2 * 24 * 60, 'create');

        // Step visits: 2 from the first + 1 from the second + 1 from the
        // completed paper = 4. Transactions: the first open paper and the
        // completed paper both exceed their total SLA.
        $this->summary()
            ->assertJsonPath('overdue_steps', 4)
            ->assertJsonPath('overdue_transactions', 2)
            ->assertJsonCount(2, 'overdue_steps_by_office')
            ->assertJsonPath('overdue_steps_by_office.0.code', 'CHRMO')
            ->assertJsonPath('overdue_steps_by_office.0.count', 3)
            ->assertJsonPath('overdue_steps_by_office.1.code', 'GSO')
            ->assertJsonPath('overdue_steps_by_office.1.count', 1);

        $this->summary(['month' => '2026-09'])
            ->assertJsonPath('overdue_steps', 4)
            ->assertJsonPath('overdue_transactions', 2)
            ->assertJsonCount(2, 'overdue_steps_by_office');

        // August has no step visits and no transactions created/finalized in
        // that month, so both metrics are empty for that period.
        $this->summary(['month' => '2026-08'])
            ->assertJsonPath('overdue_steps', 0)
            ->assertJsonPath('overdue_transactions', 0)
            ->assertJsonCount(0, 'overdue_steps_by_office');
    }

    public function test_completed_overdue_transactions_follow_their_finalize_month(): void
    {
        // Created Aug 7, finalized Aug 27: 10 days at the station against a
        // one-day SLA, so the completed paper is overdue in August.
        $tx = $this->tx($this->payroll, 50, [
            'office' => $this->chrmo->id,
            'finalizedDaysAgo' => 30,
            'manualRuns' => true,
        ]);
        TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $this->payrollStep->id,
            'to_step_id' => $this->payrollStep->id,
            'action_code' => 'create',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subDays(40),
            'received_at' => now()->subDays(40),
            'received_by' => $this->admin->id,
            'sla_minutes_snapshot' => 60,
        ]);

        $this->summary(['month' => '2026-08'])
            ->assertJsonPath('overdue_transactions', 1)
            ->assertJsonPath('overdue_steps', 1);

        $this->summary(['month' => '2026-09'])
            ->assertJsonPath('overdue_transactions', 0)
            ->assertJsonPath('overdue_steps', 0);

        $this->summary(['month' => 'all'])->assertJsonPath('overdue_transactions', 1);
    }

    public function test_top_overdue_steps_rank_step_office_pairs_for_the_month(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-08-20 04:00:00', 'UTC')); // Aug 20, 12:00 Manila

        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $oct = Office::create(['code' => 'OCT', 'name' => 'Office of the City Treasurer']);
        $this->payrollStep->update(['office_id' => $this->chrmo->id, 'sla_minutes' => 60]);
        $endStep = WorkflowStep::create([
            'workflow_definition_id' => $this->payrollStep->workflow_definition_id,
            'order_number' => 2,
            'code' => 'payroll_end',
            'name' => 'Payroll end',
            'office_id' => $gso->id,
            'sla_minutes' => 60,
        ]);
        $thirdStep = WorkflowStep::create([
            'workflow_definition_id' => $this->payrollStep->workflow_definition_id,
            'order_number' => 3,
            'code' => 'payroll_third',
            'name' => 'Payroll third',
            'office_id' => $oct->id,
            'sla_minutes' => 60,
        ]);

        $addRun = function (Transaction $tx, int $fromStep, int $toStep, int $minutesAgo, string $action = 'proceed') {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $fromStep,
                'to_step_id' => $toStep,
                'action_code' => $action,
                'performed_by' => $this->admin->id,
                'performed_at' => now()->subMinutes($minutesAgo),
                'received_at' => now()->subMinutes($minutesAgo),
                'sla_minutes_snapshot' => 60,
            ]);
        };

        // Two transactions with both visits over SLA: CHRMO payroll step x2,
        // GSO end step x2.
        foreach (['a', 'b'] as $suffix) {
            $tx = $this->tx($this->payroll, 1, ['office' => $this->chrmo->id, 'manualRuns' => true]);
            $addRun($tx, $this->payrollStep->id, $this->payrollStep->id, 240, 'create');
            $addRun($tx, $this->payrollStep->id, $endStep->id, 120);
            TransactionState::where('transaction_id', $tx->id)->update([
                'current_step_id' => $endStep->id,
                'entered_at' => now()->subMinutes(120),
            ]);
        }

        // A third transaction adds one more CHRMO payroll visit and one at OCT.
        $third = $this->tx($this->payroll, 1, ['office' => $gso->id, 'manualRuns' => true]);
        $addRun($third, $this->payrollStep->id, $this->payrollStep->id, 240, 'create');
        $addRun($third, $this->payrollStep->id, $thirdStep->id, 120);
        TransactionState::where('transaction_id', $third->id)->update([
            'current_step_id' => $thirdStep->id,
            'entered_at' => now()->subMinutes(120),
        ]);

        Sanctum::actingAs($this->admin);

        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-08')
            ->assertOk()
            ->assertJsonPath('label', 'August 2026')
            ->assertJsonCount(3, 'months')
            ->assertJsonPath('months.0.month', '2026-06')
            ->assertJsonPath('months.1.month', '2026-07')
            ->assertJsonPath('months.2.month', '2026-08')
            ->assertJsonPath('months.2.completed_late', 0)
            ->assertJsonPath('months.2.completed_on_time', 0)
            ->assertJsonPath('months.2.in_process', 3)
            ->assertJsonCount(3, 'steps')
            ->assertJsonPath('steps.0.step', 'Payroll start')
            ->assertJsonPath('steps.0.order_number', 1)
            ->assertJsonPath('steps.0.transaction_type', 'Payroll')
            ->assertJsonPath('steps.0.office.code', 'CHRMO')
            ->assertJsonPath('steps.0.count', 3)
            ->assertJsonPath('steps.1.step', 'Payroll end')
            ->assertJsonPath('steps.1.office.code', 'GSO')
            ->assertJsonPath('steps.1.count', 2)
            ->assertJsonPath('steps.2.step', 'Payroll third')
            ->assertJsonPath('steps.2.office.code', 'OCT')
            ->assertJsonPath('steps.2.count', 1)
            ->assertJsonPath('overdue_by_office.0.code', 'CHRMO')
            ->assertJsonPath('overdue_by_office.0.count', 2)
            ->assertJsonPath('overdue_by_office.1.code', 'GSO')
            ->assertJsonPath('overdue_by_office.1.count', 1);

        // The office filter is by the office handling the step. Only the two
        // transactions with a GSO step count, and the same two rows rank.
        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-08&office_id='.$gso->id)
            ->assertOk()
            ->assertJsonPath('months.2.in_process', 2)
            ->assertJsonCount(1, 'steps')
            ->assertJsonPath('steps.0.office.code', 'GSO')
            ->assertJsonPath('steps.0.count', 2);

        // Several offices include every visit handled by any of them.
        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-08&office_ids[]='.$this->chrmo->id.'&office_ids[]='.$gso->id)
            ->assertOk()
            ->assertJsonPath('months.2.in_process', 3)
            ->assertJsonCount(2, 'steps')
            ->assertJsonPath('steps.0.office.code', 'CHRMO')
            ->assertJsonPath('steps.0.count', 3)
            ->assertJsonPath('steps.1.office.code', 'GSO')
            ->assertJsonPath('steps.1.count', 2);

        // Ending the window at July still has no visits in this setup.
        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-07')
            ->assertOk()
            ->assertJsonCount(3, 'months')
            ->assertJsonPath('months.2.in_process', 0)
            ->assertJsonCount(0, 'steps')
            ->assertJsonCount(0, 'overdue_by_office');

        // The same papers were not late in September.
        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-09')
            ->assertOk()
            ->assertJsonCount(0, 'overdue_by_office');
    }

    public function test_overdue_by_office_month_view_excludes_finished_papers(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-08-20 04:00:00', 'UTC'));

        $this->payrollStep->update(['office_id' => $this->chrmo->id, 'sla_minutes' => 60]);

        $addRun = function (Transaction $tx, int $minutesAgo, string $action = 'create') {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $this->payrollStep->id,
                'to_step_id' => $this->payrollStep->id,
                'action_code' => $action,
                'performed_by' => $this->admin->id,
                'performed_at' => now()->subMinutes($minutesAgo),
                'received_at' => now()->subMinutes($minutesAgo),
                'sla_minutes_snapshot' => 60,
            ]);
        };

        // Open paper: its current visit is four hours over the one-hour SLA.
        $open = $this->tx($this->payroll, 1, ['office' => $this->chrmo->id, 'manualRuns' => true]);
        $addRun($open, 240);

        // Finished paper: its step visit was late before it was finalized.
        $done = $this->tx($this->payroll, 3, ['office' => $this->chrmo->id, 'finalizedDaysAgo' => 1, 'manualRuns' => true]);
        $addRun($done, 2 * 24 * 60);

        Sanctum::actingAs($this->admin);

        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-08')
            ->assertOk()
            ->assertJsonCount(1, 'overdue_by_office')
            ->assertJsonPath('overdue_by_office.0.code', 'CHRMO')
            ->assertJsonPath('overdue_by_office.0.count', 1);
    }

    public function test_monthly_completed_series_splits_on_time_and_overdue(): void
    {
        // Finalized within its 480-minute total SLA.
        $this->tx($this->payroll, 0, [
            'office' => $this->chrmo->id,
            'finalizedDaysAgo' => 0,
        ]);

        // About 1,980 working minutes between creation and finalize against
        // the same 480-minute total SLA.
        $this->tx($this->payroll, 5, [
            'office' => $this->chrmo->id,
            'finalizedDaysAgo' => 1,
        ]);

        // A paper whose stations have no time limit cannot be classified.
        $this->payrollStep->update(['sla_minutes' => 0]);
        $this->tx($this->payroll, 0, [
            'office' => $this->chrmo->id,
            'finalizedDaysAgo' => 0,
        ]);

        Sanctum::actingAs($this->admin);

        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-09')
            ->assertOk()
            ->assertJsonPath('months.2.month', '2026-09')
            ->assertJsonPath('months.2.in_process', 0)
            ->assertJsonPath('months.2.completed_late', 1)
            ->assertJsonPath('months.2.completed_on_time', 1);

        // The office filter keeps both completed series.
        $this->getJson('/api/admin/dashboard/overdue-overview?month=2026-09&office_ids[]='.$this->chrmo->id)
            ->assertOk()
            ->assertJsonPath('months.2.completed_late', 1)
            ->assertJsonPath('months.2.completed_on_time', 1);
    }

    public function test_top_overdue_steps_office_admin_scope_cannot_be_overridden(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-08-20 04:00:00', 'UTC'));

        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->payrollStep->update(['office_id' => $this->chrmo->id, 'sla_minutes' => 60]);

        // CHRMO step visit.
        $chrmoTx = $this->tx($this->payroll, 1, ['office' => $this->chrmo->id, 'manualRuns' => true]);
        TransactionStepRun::create([
            'transaction_id' => $chrmoTx->id,
            'from_step_id' => $this->payrollStep->id,
            'to_step_id' => $this->payrollStep->id,
            'action_code' => 'create',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subHours(4),
            'received_at' => now()->subHours(4),
            'sla_minutes_snapshot' => 60,
        ]);
        TransactionState::where('transaction_id', $chrmoTx->id)->update([
            'current_step_id' => $this->payrollStep->id,
            'entered_at' => now()->subHours(4),
        ]);

        // A separate GSO workflow, so the CHRMO office admin's scope does not
        // include this transaction.
        $gsoType = TransactionType::create(['code' => 'gso_process', 'name' => 'GSO Process']);
        $gsoWf = WorkflowDefinition::create([
            'transaction_type_id' => $gsoType->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $gsoWf->id,
            'order_number' => 1,
            'code' => 'gso_start',
            'name' => 'GSO start',
            'office_id' => $gso->id,
            'is_start' => true,
            'sla_minutes' => 60,
        ]);
        $gsoTx = Transaction::create([
            'transaction_type_id' => $gsoType->id,
            'workflow_definition_id' => $gsoWf->id,
            'office_id' => $gso->id,
            'reference_number' => 'TX-GSO-'.uniqid(),
            'is_done' => false,
            'created_by' => $this->admin->id,
        ]);
        TransactionState::create([
            'transaction_id' => $gsoTx->id,
            'current_step_id' => $gsoStep->id,
            'entered_at' => now()->subHours(4),
        ]);
        TransactionStepRun::create([
            'transaction_id' => $gsoTx->id,
            'from_step_id' => $gsoStep->id,
            'to_step_id' => $gsoStep->id,
            'action_code' => 'create',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subHours(4),
            'received_at' => now()->subHours(4),
            'sla_minutes_snapshot' => 60,
        ]);

        $officeAdmin = User::factory()->create(['office_id' => $this->chrmo->id]);
        $officeAdmin->roles()->attach(Role::create(['code' => 'admin', 'name' => 'Admin'])->id);
        Sanctum::actingAs($officeAdmin);

        // The request tries to select GSO, but the office admin stays scoped
        // to CHRMO.
        $this->getJson('/api/office/dashboard/overdue-overview?month=2026-08&office_id='.$gso->id)
            ->assertOk()
            ->assertJsonPath('months.2.in_process', 1)
            ->assertJsonCount(1, 'steps')
            ->assertJsonPath('steps.0.office.code', 'CHRMO')
            ->assertJsonPath('steps.0.count', 1)
            ->assertJsonCount(1, 'overdue_by_office')
            ->assertJsonPath('overdue_by_office.0.code', 'CHRMO')
            ->assertJsonPath('overdue_by_office.0.count', 1);
    }

    public function test_top_overdue_steps_office_admin_ranks_only_own_office_steps(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-08-20 04:00:00', 'UTC'));

        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->payrollStep->update(['office_id' => $this->chrmo->id, 'sla_minutes' => 60]);
        $gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $this->payrollStep->workflow_definition_id,
            'order_number' => 2,
            'code' => 'gso_review',
            'name' => 'GSO review',
            'office_id' => $gso->id,
            'sla_minutes' => 60,
        ]);

        // Filed by CHRMO, with an overdue CHRMO visit followed by an overdue
        // GSO visit. Only the CHRMO step belongs on the CHRMO admin's card.
        $tx = $this->tx($this->payroll, 1, ['office' => $this->chrmo->id, 'manualRuns' => true]);

        TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $this->payrollStep->id,
            'to_step_id' => $this->payrollStep->id,
            'action_code' => 'create',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subHours(48),
            'received_at' => now()->subHours(48),
            'received_office_id' => $this->chrmo->id,
            'sla_minutes_snapshot' => 60,
        ]);

        $gsoRun = TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $this->payrollStep->id,
            'to_step_id' => $gsoStep->id,
            'action_code' => 'approve',
            'performed_by' => $this->admin->id,
            'performed_at' => now()->subHours(24),
            'received_at' => now()->subHours(24),
            'received_office_id' => $gso->id,
            'sla_minutes_snapshot' => 60,
        ]);

        TransactionState::where('transaction_id', $tx->id)->update([
            'current_step_id' => $gsoStep->id,
            'current_run_id' => $gsoRun->id,
            'entered_at' => $gsoRun->performed_at,
        ]);

        $officeAdmin = User::factory()->create(['office_id' => $this->chrmo->id]);
        $officeAdmin->roles()->attach(Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin'])->id);
        Sanctum::actingAs($officeAdmin);

        $this->getJson('/api/office/dashboard/overdue-overview?month=2026-08')
            ->assertOk()
            ->assertJsonCount(1, 'steps')
            ->assertJsonPath('steps.0.office.code', 'CHRMO')
            ->assertJsonPath('steps.0.count', 1);
    }

    public function test_office_step_cards_count_office_wide_activity(): void
    {
        $csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $csdOfficer = User::factory()->create(['office_id' => $csd->id]);
        $csdOfficer->roles()->attach($clerk->id);
        $gsoOfficer = User::factory()->create(['office_id' => $gso->id]);
        $gsoOfficer->roles()->attach($clerk->id);

        $type = TransactionType::create(['code' => 'office_cards', 'name' => 'Office cards']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $csdStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'csd_step',
            'name' => 'CSD step',
            'office_id' => $csd->id,
            'is_start' => true,
            'sla_minutes' => 60,
        ]);
        $gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 2,
            'code' => 'gso_step',
            'name' => 'GSO step',
            'office_id' => $gso->id,
            'sla_minutes' => 60,
        ]);

        $makeTx = function (Office $office, bool $archived = false, bool $done = false) use ($type, $workflow): Transaction {
            return Transaction::create([
                'transaction_type_id' => $type->id,
                'workflow_definition_id' => $workflow->id,
                'office_id' => $office->id,
                'reference_number' => 'TX-OC-'.uniqid(),
                'is_archive' => $archived,
                'is_done' => $done,
                'created_by' => $this->admin->id,
            ]);
        };
        $addRun = function (Transaction $tx, WorkflowStep $step, array $attrs = []): TransactionStepRun {
            return TransactionStepRun::create(array_merge([
                'transaction_id' => $tx->id,
                'from_step_id' => $step->id,
                'to_step_id' => $step->id,
                'action_code' => 'submit',
                'performed_by' => $this->admin->id,
                'performed_at' => now(),
                'received_at' => null,
                'received_by' => null,
                'received_office_id' => $step->office_id,
                'sla_minutes_snapshot' => 60,
            ], $attrs));
        };
        $makeCurrent = function (Transaction $tx, WorkflowStep $step, TransactionStepRun $run): void {
            TransactionState::create([
                'transaction_id' => $tx->id,
                'current_step_id' => $step->id,
                'current_run_id' => $run->id,
                'entered_at' => $run->performed_at,
            ]);
        };

        // Received in September at CSD: entered and received in the selected
        // month, and still in progress at the office.
        $arrived = $makeTx($csd);
        $arrivedRun = $addRun($arrived, $csdStep, [
            'performed_at' => now()->subDays(6),
            'received_at' => now()->subDays(5),
            'received_by' => $csdOfficer->id,
        ]);
        $makeCurrent($arrived, $csdStep, $arrivedRun);

        // Arrived in September but not received yet: only Entered.
        $pending = $makeTx($csd);
        $pendingRun = $addRun($pending, $csdStep, ['performed_at' => now()->subDays(4)]);
        $makeCurrent($pending, $csdStep, $pendingRun);

        // Arrived in August, received in September: Received and In progress
        // for September, but Entered belongs to August.
        $lateReceipt = $makeTx($csd);
        $lateRun = $addRun($lateReceipt, $csdStep, [
            'performed_at' => now()->subMonthNoOverflow()->subDays(6),
            'received_at' => now()->subDays(4),
            'received_by' => $csdOfficer->id,
        ]);
        $makeCurrent($lateReceipt, $csdStep, $lateRun);

        // Entirely in August: only August's cards count it.
        $augustReceipt = $makeTx($csd);
        $augustRun = $addRun($augustReceipt, $csdStep, [
            'performed_at' => now()->subMonthNoOverflow()->subDays(11),
            'received_at' => now()->subMonthNoOverflow()->subDays(10),
            'received_by' => $csdOfficer->id,
        ]);
        $makeCurrent($augustReceipt, $csdStep, $augustRun);

        // Received today: only today's cards count it.
        $todayReceipt = $makeTx($csd);
        $todayRun = $addRun($todayReceipt, $csdStep, [
            'performed_at' => now()->subMinutes(30),
            'received_at' => now()->subMinutes(20),
            'received_by' => $csdOfficer->id,
        ]);
        $makeCurrent($todayReceipt, $csdStep, $todayRun);

        // Received at another office: out of every CSD card.
        $elsewhere = $makeTx($csd);
        $gsoRun = $addRun($elsewhere, $gsoStep, [
            'performed_at' => now()->subDays(6),
            'received_at' => now()->subDays(5),
            'received_by' => $gsoOfficer->id,
            'received_office_id' => $gso->id,
        ]);
        $makeCurrent($elsewhere, $gsoStep, $gsoRun);

        // Finalize visits are not entries or receipts.
        $finalized = $makeTx($csd, done: true);
        $addRun($finalized, $csdStep, [
            'action_code' => 'finalize',
            'performed_at' => now()->subDays(1),
            'received_at' => now()->subDays(2),
            'received_by' => $csdOfficer->id,
        ]);

        // Archived transactions are out of every card.
        $archived = $makeTx($csd, archived: true);
        $archivedRun = $addRun($archived, $csdStep, [
            'performed_at' => now()->subDays(6),
            'received_at' => now()->subDays(5),
            'received_by' => $csdOfficer->id,
        ]);
        $makeCurrent($archived, $csdStep, $archivedRun);

        // Releases in September: one forward action by a CSD officer. The
        // destination is GSO, so these release runs are not CSD entries.
        // Create, return, resend and finalize are separate actions; another
        // office's officer and August's action do not count in September.
        $releaseAt = now()->subDays(10);
        $releaseForward = [
            'to_step_id' => $gsoStep->id,
            'received_office_id' => $gso->id,
        ];
        $addRun($makeTx($csd), $csdStep, [
            ...$releaseForward,
            'action_code' => 'approve',
            'performed_by' => $csdOfficer->id,
            'performed_at' => $releaseAt,
        ]);
        foreach (['create', 'return', 'resend', 'finalize'] as $action) {
            $addRun($makeTx($csd), $csdStep, [
                ...$releaseForward,
                'action_code' => $action,
                'performed_by' => $csdOfficer->id,
                'performed_at' => $releaseAt,
            ]);
        }
        $addRun($makeTx($gso), $gsoStep, [
            'action_code' => 'submit',
            'performed_by' => $gsoOfficer->id,
            'performed_at' => $releaseAt,
        ]);
        $addRun($makeTx($csd), $csdStep, [
            ...$releaseForward,
            'action_code' => 'submit',
            'performed_by' => $csdOfficer->id,
            'performed_at' => now()->subMonthNoOverflow(),
        ]);

        $officeAdmin = User::factory()->create(['office_id' => $csd->id]);
        $officeAdmin->roles()->attach(Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin'])->id);
        Sanctum::actingAs($officeAdmin);

        $this->getJson('/api/office/dashboard/summary?month=2026-09')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.entered', 3)
            ->assertJsonPath('office_step_metrics.received', 3)
            ->assertJsonPath('office_step_metrics.in_progress', 3)
            ->assertJsonPath('office_step_metrics.overdue_steps', 2)
            ->assertJsonPath('office_step_metrics.released', 1);

        // Every card follows the selected month, not the calendar day.
        $this->getJson('/api/office/dashboard/summary?month=2026-08')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.entered', 2)
            ->assertJsonPath('office_step_metrics.received', 1)
            ->assertJsonPath('office_step_metrics.in_progress', 1)
            ->assertJsonPath('office_step_metrics.overdue_steps', 1)
            ->assertJsonPath('office_step_metrics.released', 1);

        // Today and this week are also accepted and drive every card.
        $this->getJson('/api/office/dashboard/summary?month=today')
            ->assertOk()
            ->assertJsonPath('period.key', 'today')
            ->assertJsonPath('office_step_metrics.entered', 1)
            ->assertJsonPath('office_step_metrics.received', 1)
            ->assertJsonPath('office_step_metrics.in_progress', 1)
            ->assertJsonPath('office_step_metrics.overdue_steps', 0)
            ->assertJsonPath('office_step_metrics.released', 0);

        $this->getJson('/api/office/dashboard/summary?month=this_week')
            ->assertOk()
            ->assertJsonPath('period.key', 'this_week')
            ->assertJsonPath('office_step_metrics.entered', 2)
            ->assertJsonPath('office_step_metrics.received', 3)
            ->assertJsonPath('office_step_metrics.in_progress', 3)
            ->assertJsonPath('office_step_metrics.overdue_steps', 2)
            ->assertJsonPath('office_step_metrics.released', 0);

        // Office heads keep the system-wide summary but get their own office's
        // step cards.
        $headRole = Role::create(['code' => 'office_head', 'name' => 'Office Head', 'office_id' => $csd->id]);
        $head = User::factory()->create(['office_id' => $csd->id]);
        $head->roles()->attach($headRole->id);
        Sanctum::actingAs($head);

        $this->getJson('/api/office-head/dashboard/summary?month=2026-09')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.entered', 3)
            ->assertJsonPath('office_step_metrics.received', 3)
            ->assertJsonPath('office_step_metrics.in_progress', 3)
            ->assertJsonPath('office_step_metrics.overdue_steps', 2)
            ->assertJsonPath('office_step_metrics.released', 1);

        // Superadmins keep only the system-wide overdue cards.
        $this->summary()->assertJsonMissingPath('office_step_metrics');
    }

    public function test_office_step_cards_count_steps_returned_to_the_office(): void
    {
        $csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $type = TransactionType::create(['code' => 'returns_card', 'name' => 'Returns card']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $csdStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'csd_returns',
            'name' => 'CSD returns',
            'office_id' => $csd->id,
            'is_start' => true,
            'sla_minutes' => 60,
        ]);
        $gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 2,
            'code' => 'gso_returns',
            'name' => 'GSO returns',
            'office_id' => $gso->id,
            'sla_minutes' => 60,
        ]);

        $makeTx = function (Office $office, bool $archived = false) use ($type, $workflow): Transaction {
            return Transaction::create([
                'transaction_type_id' => $type->id,
                'workflow_definition_id' => $workflow->id,
                'office_id' => $office->id,
                'reference_number' => 'TX-RET-'.uniqid(),
                'is_archive' => $archived,
                'created_by' => $this->admin->id,
            ]);
        };
        $addReturn = function (Transaction $tx, WorkflowStep $step, Office $office, \DateTimeInterface $at): TransactionStepRun {
            return TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $step->id,
                'to_step_id' => $step->id,
                'action_code' => 'return',
                'performed_by' => $this->admin->id,
                'performed_at' => $at,
                'received_at' => null,
                'received_by' => null,
                'received_office_id' => $office->id,
                'sla_minutes_snapshot' => 60,
            ]);
        };

        // September: one return to CSD counts, one to GSO does not.
        $addReturn($makeTx($csd), $csdStep, $csd, now()->subDays(6));
        $addReturn($makeTx($gso), $gsoStep, $gso, now()->subDays(6));

        // August: counts only in August.
        $addReturn($makeTx($csd), $csdStep, $csd, now()->subMonthNoOverflow()->subDays(2));

        // Archived transactions stay out of every card.
        $addReturn($makeTx($csd, true), $csdStep, $csd, now()->subDays(6));

        $officeAdmin = User::factory()->create(['office_id' => $csd->id]);
        $officeAdmin->roles()->attach(Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin'])->id);
        Sanctum::actingAs($officeAdmin);

        $this->getJson('/api/office/dashboard/summary?month=2026-09')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.returned', 1);

        $this->getJson('/api/office/dashboard/summary?month=2026-08')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.returned', 1);
    }

    public function test_office_overdue_steps_exclude_steps_already_released(): void
    {
        $csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $type = TransactionType::create(['code' => 'open_overdue', 'name' => 'Open overdue']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $csdStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'open_csd',
            'name' => 'CSD step',
            'office_id' => $csd->id,
            'is_start' => true,
            'sla_minutes' => 60,
        ]);
        $gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 2,
            'code' => 'open_gso',
            'name' => 'GSO step',
            'office_id' => $gso->id,
            'sla_minutes' => 60,
        ]);

        $makeTx = function (Office $office) use ($type, $workflow): Transaction {
            return Transaction::create([
                'transaction_type_id' => $type->id,
                'workflow_definition_id' => $workflow->id,
                'office_id' => $office->id,
                'reference_number' => 'TX-OPEN-'.uniqid(),
                'created_by' => $this->admin->id,
            ]);
        };
        $addRun = function (Transaction $tx, WorkflowStep $from, WorkflowStep $to, array $attrs = []): TransactionStepRun {
            return TransactionStepRun::create(array_merge([
                'transaction_id' => $tx->id,
                'from_step_id' => $from->id,
                'to_step_id' => $to->id,
                'action_code' => 'submit',
                'performed_by' => $this->admin->id,
                'performed_at' => now(),
                'received_at' => null,
                'received_by' => null,
                'received_office_id' => $to->office_id,
                'sla_minutes_snapshot' => 60,
            ], $attrs));
        };
        $makeCurrent = function (Transaction $tx, WorkflowStep $step, TransactionStepRun $run): void {
            TransactionState::create([
                'transaction_id' => $tx->id,
                'current_step_id' => $step->id,
                'current_run_id' => $run->id,
                'entered_at' => $run->performed_at,
            ]);
        };

        // Still at CSD, received three days ago: overdue and counts.
        $open = $makeTx($csd);
        $openRun = $addRun($open, $csdStep, $csdStep, [
            'performed_at' => now()->subDays(3),
            'received_at' => now()->subDays(3),
        ]);
        $makeCurrent($open, $csdStep, $openRun);

        // Was at CSD long enough to be overdue, then released to GSO. It is
        // no longer work waiting at CSD, so the office card drops it.
        $released = $makeTx($csd);
        $addRun($released, $csdStep, $csdStep, [
            'performed_at' => now()->subDays(5),
            'received_at' => now()->subDays(5),
        ]);
        $gsoVisit = $addRun($released, $csdStep, $gsoStep, [
            'action_code' => 'approve',
            'performed_at' => now()->subDays(4),
            'received_at' => now()->subDays(4),
        ]);
        $makeCurrent($released, $gsoStep, $gsoVisit);

        $officeAdmin = User::factory()->create(['office_id' => $csd->id]);
        $officeAdmin->roles()->attach(Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin'])->id);
        Sanctum::actingAs($officeAdmin);

        $this->getJson('/api/office/dashboard/summary?month=2026-09')
            ->assertOk()
            ->assertJsonPath('office_step_metrics.in_progress', 1)
            ->assertJsonPath('office_step_metrics.overdue_steps', 1);
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
