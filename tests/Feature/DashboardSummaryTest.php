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
 * everything else by created date. Periods: last 4 weeks, or a Manila month.
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

    public function test_counts_each_status_in_the_last_four_weeks(): void
    {
        $this->tx($this->payroll, 3, ['enteredHoursAgo' => 30]);        // in process, overdue (30h > 24h)
        $this->tx($this->payroll, 2, ['enteredHoursAgo' => 5]);         // in process, on time
        $this->tx($this->procurement, 10, ['finalizedDaysAgo' => 1]);   // completed this period
        $this->tx($this->procurement, 60, ['finalizedDaysAgo' => 2]);   // created long ago, finalized now -> completed
        $this->tx($this->payroll, 50, ['finalizedDaysAgo' => 35]);      // finalized before the period: not counted
        $this->tx($this->payroll, 4, ['deleted' => true]);              // deleted
        $this->tx($this->payroll, 45, ['enteredHoursAgo' => 99]);       // created before period: not counted

        $this->summary()
            ->assertJsonPath('period.key', 'last_4_weeks')
            ->assertJsonPath('completed', 2)
            ->assertJsonPath('in_process', 2)
            ->assertJsonPath('overdue', 1)
            ->assertJsonPath('deleted', 1);
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

        $this->summary(['processes' => [$this->payroll->id]])->assertJsonPath('in_process', 2);
        $this->summary(['offices' => [$this->chrmo->id]])->assertJsonPath('in_process', 2);
        $this->summary(['processes' => [$this->payroll->id], 'offices' => [$this->chrmo->id]])
            ->assertJsonPath('in_process', 1);
    }

    public function test_by_process_ignores_process_filter_but_respects_office(): void
    {
        $this->tx($this->payroll, 2, ['office' => $this->chrmo->id]);
        $this->tx($this->payroll, 3, ['office' => $this->chrmo->id, 'finalizedDaysAgo' => 1]);
        $this->tx($this->procurement, 2);
        $this->tx($this->procurement, 2, ['deleted' => true]); // deleted: not in by_process

        // Process filter must not hide the other processes (the card fades them instead).
        $this->summary(['processes' => [$this->payroll->id]])
            ->assertJsonPath('by_process', [
                ['id' => $this->payroll->id, 'name' => 'Payroll', 'count' => 2],
                ['id' => $this->procurement->id, 'name' => 'Procurement', 'count' => 1],
            ]);

        $this->summary(['offices' => [$this->chrmo->id]])
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
