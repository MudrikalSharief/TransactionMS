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
 * Staff-portal Transaction Status chart. It uses the admin chart's status
 * rules but counts only papers filed by the signed-in user's own office.
 */
class PortalTransactionStatusTest extends TestCase
{
    use RefreshDatabase;

    private User $user;
    private Office $office;
    private Office $otherOffice;
    private TransactionType $type;
    private WorkflowStep $step;

    protected function setUp(): void
    {
        parent::setUp();
        Carbon::setTestNow(Carbon::parse('2026-09-26 04:00:00', 'UTC')); // Sat 12:00 Manila

        $this->office = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->otherOffice = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $role = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $this->user = User::factory()->create(['office_id' => $this->office->id]);
        $this->user->roles()->attach($role);

        $this->type = TransactionType::create(['code' => 'service', 'name' => 'Service']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        // The step belongs to the user's office, so a paper filed elsewhere
        // can still pass through it without being the office's own paper.
        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'office_id' => $this->office->id,
            'is_start' => true,
            'sla_minutes' => 480,
        ]);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    private function tx(int $officeId, int $createdDaysAgo, array $opts = []): Transaction
    {
        $created = now()->subDays($createdDaysAgo);

        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->step->workflow_definition_id,
            'office_id' => $officeId,
            'reference_number' => 'TX-' . uniqid(),
            'is_done' => (bool) ($opts['done'] ?? false),
            'created_by' => $this->user->id,
        ]);
        $tx->forceFill(['created_at' => $created, 'updated_at' => $created])->saveQuietly();

        $sla = $opts['sla'] ?? 480;
        $run = TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $this->step->id,
            'to_step_id' => $this->step->id,
            'action_code' => 'create',
            'performed_by' => $this->user->id,
            'performed_at' => $created,
            'received_at' => $created,
            'received_by' => $this->user->id,
            'sla_minutes_snapshot' => $sla,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $this->step->id,
            'current_run_id' => $run->id,
            'entered_at' => $created,
        ]);

        if (!empty($opts['done'])) {
            $finalizedAt = now()->subDays($opts['finalizedDaysAgo'] ?? 0);
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $this->step->id,
                'to_step_id' => $this->step->id,
                'action_code' => 'finalize',
                'performed_by' => $this->user->id,
                'performed_at' => $finalizedAt,
                'received_at' => $finalizedAt,
                'received_by' => $this->user->id,
                'sla_minutes_snapshot' => $sla,
            ]);
        }

        if (!empty($opts['archived'])) $tx->update(['is_archive' => true]);

        return $tx;
    }

    public function test_chart_counts_only_the_users_office_and_splits_completed(): void
    {
        // Filed by the user's office: one on-time, one late, one still open.
        $this->tx($this->office->id, 0, ['done' => true, 'finalizedDaysAgo' => 0]);
        $this->tx($this->office->id, 5, ['done' => true, 'finalizedDaysAgo' => 1]);
        $this->tx($this->office->id, 2);

        // Another office's paper is out of scope even though it passes
        // through this office's step.
        $this->tx($this->otherOffice->id, 0, ['done' => true, 'finalizedDaysAgo' => 0]);

        // Archived papers stay out of the chart.
        $this->tx($this->office->id, 0, ['done' => true, 'finalizedDaysAgo' => 0, 'archived' => true]);

        // Completed papers with no SLA cannot be classified.
        $this->step->update(['sla_minutes' => 0]);
        $this->tx($this->office->id, 0, ['done' => true, 'finalizedDaysAgo' => 0, 'sla' => 0]);

        Sanctum::actingAs($this->user);

        $this->getJson('/api/portal/transaction-status?month=2026-09')
            ->assertOk()
            ->assertJsonCount(3, 'months')
            ->assertJsonPath('month', '2026-09')
            ->assertJsonPath('label', 'September 2026')
            ->assertJsonPath('months.2.month', '2026-09')
            ->assertJsonPath('months.2.in_process', 1)
            ->assertJsonPath('months.2.completed_late', 1)
            ->assertJsonPath('months.2.completed_on_time', 1)
            ->assertJsonPath('months.0.in_process', 0)
            ->assertJsonPath('months.0.completed_late', 0)
            ->assertJsonPath('months.0.completed_on_time', 0);
    }

    public function test_user_without_an_office_gets_empty_months(): void
    {
        $this->user->update(['office_id' => null]);
        Sanctum::actingAs($this->user);

        $this->getJson('/api/portal/transaction-status?month=2026-09')
            ->assertOk()
            ->assertJsonCount(3, 'months')
            ->assertJsonPath('months.2.in_process', 0)
            ->assertJsonPath('months.2.completed_late', 0)
            ->assertJsonPath('months.2.completed_on_time', 0);
    }
}
