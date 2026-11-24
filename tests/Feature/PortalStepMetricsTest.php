<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowStep};
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Staff-portal step cards: Received today, Entered today for the user's role,
 * and the open work they currently hold.
 */
class PortalStepMetricsTest extends TestCase
{
    use RefreshDatabase;

    private User $user;
    private Office $office;
    private Office $otherOffice;
    private TransactionType $type;
    private WorkflowStep $startStep;
    private WorkflowStep $otherRoleStep;
    private WorkflowStep $otherOfficeStep;

    protected function setUp(): void
    {
        parent::setUp();
        Carbon::setTestNow(Carbon::parse('2026-11-24 03:00:00', 'UTC')); // 11:00 Manila

        $this->office = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->otherOffice = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $otherRole = Role::firstOrCreate(['code' => 'processor'], ['name' => 'Processor']);
        $this->user = User::factory()->create(['office_id' => $this->office->id]);
        $this->user->roles()->attach($clerk->id);

        $this->type = TransactionType::create(['code' => 'service', 'name' => 'Service']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $this->startStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'office_id' => $this->office->id,
            'is_start' => true,
            'sla_minutes' => 480,
        ]);
        StepRole::create(['workflow_step_id' => $this->startStep->id, 'role_id' => $clerk->id]);
        $this->otherRoleStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 2,
            'code' => 'processor',
            'name' => 'Processor',
            'office_id' => $this->office->id,
            'sla_minutes' => 480,
        ]);
        StepRole::create(['workflow_step_id' => $this->otherRoleStep->id, 'role_id' => $otherRole->id]);
        $this->otherOfficeStep = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 3,
            'code' => 'other_office',
            'name' => 'Other office',
            'office_id' => $this->otherOffice->id,
            'sla_minutes' => 480,
        ]);
        StepRole::create(['workflow_step_id' => $this->otherOfficeStep->id, 'role_id' => $clerk->id]);
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }

    private function tx(array $opts = []): Transaction
    {
        return Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->startStep->workflow_definition_id,
            'office_id' => $opts['office'] ?? $this->office->id,
            'reference_number' => 'TX-' . uniqid(),
            'is_done' => (bool) ($opts['done'] ?? false),
            'is_archive' => (bool) ($opts['archived'] ?? false),
            'created_by' => $this->user->id,
        ]);
    }

    private function addRun(Transaction $tx, WorkflowStep $step, array $opts = []): TransactionStepRun
    {
        $performedAt = $opts['performed_at'] ?? now();
        $run = TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $step->id,
            'to_step_id' => $step->id,
            'action_code' => $opts['action'] ?? 'proceed',
            'performed_by' => $opts['performed_by'] ?? $this->user->id,
            'performed_at' => $performedAt,
            'received_at' => $opts['received_at'] ?? $performedAt,
            'received_by' => $opts['received_by'] ?? null,
            'assigned_to' => $opts['assigned_to'] ?? null,
            'received_office_id' => $opts['received_office_id'] ?? $step->office_id,
            'sla_minutes_snapshot' => 480,
        ]);

        if (!empty($opts['current'])) {
            TransactionState::create([
                'transaction_id' => $tx->id,
                'current_step_id' => $step->id,
                'current_run_id' => $run->id,
                'entered_at' => $performedAt,
            ]);
        }

        return $run;
    }

    public function test_step_cards_follow_the_selected_period(): void
    {
        $today = now();
        $yesterday = now()->subDay();
        $october = Carbon::parse('2026-10-15 03:00:00', 'UTC');

        // Counts in all three cards: received in the period, entered for the
        // user's role, and still open.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'received_by' => $this->user->id,
            'assigned_to' => $this->user->id,
        ]);

        // Received/entered yesterday, still open: Overdue Work also counts it
        // for November.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'performed_at' => $yesterday,
            'received_at' => $yesterday,
            'received_by' => $this->user->id,
            'assigned_to' => $this->user->id,
        ]);

        // Colleague received it today; it still entered the office for the
        // user's role, but it is not the user's receipt or open work.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'performed_by' => $this->user->id,
            'received_by' => User::factory()->create(['office_id' => $this->office->id])->id,
            'assigned_to' => null,
        ]);

        // Arrived today at the office, but for a role the user does not hold.
        $this->addRun($this->tx(), $this->otherRoleStep, ['current' => true, 'received_by' => null]);

        // Arrived today, but at another office.
        $this->addRun($this->tx(), $this->otherOfficeStep, ['current' => true, 'received_by' => null]);

        // Received today by the user, but assigned to a colleague: Received
        // counts it, Overdue Work does not.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'received_by' => $this->user->id,
            'assigned_to' => User::factory()->create(['office_id' => $this->office->id])->id,
        ]);

        // Assigned to the user but received by a colleague: Entered and
        // Overdue Work count it, Received does not.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'received_by' => User::factory()->create(['office_id' => $this->office->id])->id,
            'assigned_to' => $this->user->id,
        ]);

        // Finished today: not open work, and finalize runs are not entries.
        $done = $this->tx(['done' => true]);
        $this->addRun($done, $this->startStep, [
            'performed_at' => $yesterday,
            'received_at' => $yesterday,
            'received_by' => $this->user->id,
        ]);
        $this->addRun($done, $this->startStep, [
            'action' => 'finalize',
            'received_by' => $this->user->id,
            'received_at' => $today,
        ]);

        // Archived transactions are out of every card.
        $this->addRun($this->tx(['archived' => true]), $this->startStep, [
            'current' => true,
            'received_by' => $this->user->id,
            'assigned_to' => $this->user->id,
        ]);

        // Yesterday's completed receipt still counts as activity this month.
        $this->addRun($this->tx(['done' => true]), $this->startStep, [
            'performed_at' => $yesterday,
            'received_at' => $yesterday,
            'received_by' => $this->user->id,
        ]);

        // October activity is outside the selected November window.
        $this->addRun($this->tx(), $this->startStep, [
            'current' => true,
            'performed_at' => $october,
            'received_at' => $october,
            'received_by' => $this->user->id,
            'assigned_to' => $this->user->id,
        ]);

        Sanctum::actingAs($this->user);

        $this->getJson('/api/portal/summary?period=2026-11')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 5)
            ->assertJsonPath('step_metrics.entered', 7)
            ->assertJsonPath('step_metrics.overdue_work', 3);

        $this->getJson('/api/portal/summary?period=today')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 2)
            ->assertJsonPath('step_metrics.entered', 4)
            ->assertJsonPath('step_metrics.overdue_work', 2);

        $this->getJson('/api/portal/summary?period=this_week')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 5)
            ->assertJsonPath('step_metrics.entered', 7)
            ->assertJsonPath('step_metrics.overdue_work', 3);

        $this->getJson('/api/portal/summary?period=2026-10')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 1)
            ->assertJsonPath('step_metrics.entered', 1)
            ->assertJsonPath('step_metrics.overdue_work', 1);

        $this->getJson('/api/portal/summary?period=all')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 6)
            ->assertJsonPath('step_metrics.entered', 8)
            ->assertJsonPath('step_metrics.overdue_work', 4);
    }

    public function test_release_counts_only_forward_actions_in_the_selected_period(): void
    {
        $october = Carbon::parse('2026-10-15 03:00:00', 'UTC');
        $november = Carbon::parse('2026-11-10 03:00:00', 'UTC');

        // Forward actions done by the user: submit, approve, and a step on a
        // transaction that was later archived.
        $this->addRun($this->tx(), $this->startStep, ['action' => 'submit', 'performed_at' => $october]);
        $this->addRun($this->tx(), $this->startStep, ['action' => 'approve', 'performed_at' => $october]);
        $this->addRun($this->tx(['archived' => true]), $this->startStep, ['action' => 'submit', 'performed_at' => $october]);

        // Creating, returning, resending, and finalizing are separate actions.
        foreach (['create', 'return', 'resend', 'finalize'] as $action) {
            $this->addRun($this->tx(), $this->startStep, ['action' => $action, 'performed_at' => $october]);
        }

        // Another user's action is not the signed-in user's release.
        $colleague = User::factory()->create(['office_id' => $this->office->id]);
        $this->addRun($this->tx(), $this->startStep, [
            'action' => 'submit',
            'performed_at' => $october,
            'performed_by' => $colleague->id,
        ]);

        // Outside the selected October window.
        $this->addRun($this->tx(), $this->startStep, ['action' => 'submit', 'performed_at' => $november]);

        Sanctum::actingAs($this->user);

        $this->getJson('/api/portal/summary?period=2026-10')
            ->assertOk()
            ->assertJsonPath('step_metrics.released', 3);

        $this->getJson('/api/portal/summary?period=all')
            ->assertOk()
            ->assertJsonPath('step_metrics.released', 4);
    }

    public function test_step_cards_are_empty_without_an_office(): void
    {
        $this->user->update(['office_id' => null]);
        Sanctum::actingAs($this->user);

        $this->getJson('/api/portal/summary')
            ->assertOk()
            ->assertJsonPath('step_metrics.received', 0)
            ->assertJsonPath('step_metrics.entered', 0)
            ->assertJsonPath('step_metrics.overdue_work', 0)
            ->assertJsonPath('step_metrics.released', 0);
    }
}
