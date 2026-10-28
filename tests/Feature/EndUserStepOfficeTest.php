<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionStepRun;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * End-user stations (explicit toggle) and blank assignments always follow
 * the transaction's Originating Office - for access and display - even when
 * the workflow template assigns a different office to an end-user station.
 * Legacy transactions with no origin keep role-only access to those stations.
 */
class EndUserStepOfficeTest extends TestCase
{
    use RefreshDatabase;

    private Office $csd;
    private Office $gso;
    private Office $hr;
    private Role $endUserRole;
    private Role $adminRole;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $endUserStep;
    private WorkflowStep $gsoStep;
    private WorkflowStep $intakeStep;
    private WorkflowRoute $route;
    private WorkflowRoute $intakeRoute;
    private User $creator;

    protected function setUp(): void
    {
        parent::setUp();

        $this->csd = Office::create(['code' => 'CSD', 'name' => 'City Social Development']);
        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->hr = Office::create(['code' => 'HR', 'name' => 'Human Resources']);

        $this->endUserRole = Role::create(['code' => 'end_user', 'name' => 'End User']);
        $this->adminRole = Role::create(['code' => 'admin', 'name' => 'Admin']);

        $this->type = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        // Template says GSO; the transaction says CSD. The transaction must win.
        $this->endUserStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'create_pr',
            'name' => 'Create Purchase Request',
            'is_start' => true,
            'is_end_user' => true,
            'office_id' => $this->gso->id,
        ]);
        $this->gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 2,
            'code' => 'gso_process',
            'name' => 'GSO Processing',
            'office_id' => $this->gso->id,
        ]);
        // No workflow office: the station follows the transaction's office.
        $this->intakeStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 3,
            'code' => 'intake',
            'name' => 'Intake',
            'office_id' => null,
        ]);

        StepRole::create(['workflow_step_id' => $this->endUserStep->id, 'role_id' => $this->endUserRole->id]);
        StepRole::create(['workflow_step_id' => $this->gsoStep->id, 'role_id' => $this->adminRole->id]);
        StepRole::create(['workflow_step_id' => $this->intakeStep->id, 'role_id' => $this->adminRole->id]);

        $this->route = WorkflowRoute::create([
            'workflow_definition_id' => $this->workflow->id,
            'from_step_id' => $this->endUserStep->id,
            'to_step_id' => $this->gsoStep->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);
        $this->intakeRoute = WorkflowRoute::create([
            'workflow_definition_id' => $this->workflow->id,
            'from_step_id' => $this->gsoStep->id,
            'to_step_id' => $this->intakeStep->id,
            'action_code' => 'forward',
            'is_return_route' => false,
        ]);

        $this->creator = User::factory()->create();
    }

    private function userWithRole(Role $role, ?Office $office = null): User
    {
        $user = User::factory()->create(['office_id' => $office?->id]);
        $user->roles()->attach($role->id);

        return $user;
    }

    private function makeTransaction(Office $office, WorkflowStep $step): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Test request',
            'is_done' => false,
            'created_by' => $this->creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $step->id,
            'to_step_id' => $step->id,
            'action_code' => 'create',
            'remarks' => 'Transaction created',
            'performed_by' => $this->creator->id,
            'performed_at' => now(),
            'received_at' => now(),
            'received_by' => $this->creator->id,
            'received_office_id' => $tx->effectiveStepOfficeId($step),
            'sla_minutes_snapshot' => 0,
        ]);

        return $tx;
    }

    public function test_end_user_station_follows_the_transactions_office(): void
    {
        $csdEndUser = $this->userWithRole($this->endUserRole, $this->csd);
        $gsoEndUser = $this->userWithRole($this->endUserRole, $this->gso);
        $tx = $this->makeTransaction($this->csd, $this->endUserStep);

        Sanctum::actingAs($csdEndUser);
        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id);
        $this->getJson("/api/transactions/{$tx->id}")->assertOk();

        Sanctum::actingAs($gsoEndUser);
        $this->getJson('/api/transactions')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();
    }

    public function test_end_user_station_office_overrides_the_template_office(): void
    {
        $gsoEndUser = $this->userWithRole($this->endUserRole, $this->gso);
        $gsoAdmin = $this->userWithRole($this->adminRole, $this->gso);
        $csdAdmin = $this->userWithRole($this->adminRole, $this->csd);
        $tx = $this->makeTransaction($this->csd, $this->endUserStep);

        // The GSO template office does not grant GSO users the end-user station.
        Sanctum::actingAs($gsoEndUser);
        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();

        // GSO admins may view it (the workflow routes through GSO) but cannot
        // act at the end-user station, which follows the CSD transaction office.
        Sanctum::actingAs($gsoAdmin);
        $this->getJson('/api/transactions')->assertOk()->assertJsonCount(1, 'data');
        $this->getJson("/api/transactions/{$tx->id}")->assertOk();
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();

        // CSD admins govern the station through the transaction's office.
        Sanctum::actingAs($csdAdmin);
        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id);

        // Moving on, the non-end-user station keeps its stored office.
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->gsoStep->id);

        Sanctum::actingAs($gsoAdmin);
        $this->getJson("/api/transactions/{$tx->id}")->assertOk();
    }

    public function test_end_user_can_execute_from_an_overridden_station(): void
    {
        $csdEndUser = $this->userWithRole($this->endUserRole, $this->csd);
        $gsoEndUser = $this->userWithRole($this->endUserRole, $this->gso);
        $tx = $this->makeTransaction($this->csd, $this->endUserStep);

        Sanctum::actingAs($gsoEndUser);
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();

        Sanctum::actingAs($csdEndUser);
        $this->getJson("/api/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions.0.route_id', $this->route->id);

        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->gsoStep->id);
    }

    public function test_end_user_station_displays_under_the_transactions_office(): void
    {
        $csdEndUser = $this->userWithRole($this->endUserRole, $this->csd);
        $tx = $this->makeTransaction($this->csd, $this->endUserStep);

        Sanctum::actingAs($csdEndUser);

        $this->getJson("/api/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('data.current_step.office_id', $this->csd->id)
            ->assertJsonPath('data.current_step.office.id', $this->csd->id)
            ->assertJsonPath('data.runs.0.to_step.office.id', $this->csd->id)
            ->assertJsonPath('data.runs.0.received_office.id', $this->csd->id);

        $steps = collect($this->getJson("/api/transactions/{$tx->id}")->json('data.workflow_steps'))
            ->keyBy('id');

        $this->assertSame($this->csd->id, $steps[$this->endUserStep->id]['office_id']);
        $this->assertSame($this->csd->id, $steps[$this->endUserStep->id]['office']['id']);
        $this->assertSame($this->gso->id, $steps[$this->gsoStep->id]['office_id']);

        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonPath('data.0.current_step.office.id', $this->csd->id);
    }

    public function test_blank_station_follows_the_transactions_office(): void
    {
        $csdEndUser = $this->userWithRole($this->endUserRole, $this->csd);
        $csdAdmin = $this->userWithRole($this->adminRole, $this->csd);
        $gsoAdmin = $this->userWithRole($this->adminRole, $this->gso);
        $hrAdmin = $this->userWithRole($this->adminRole, $this->hr);
        $tx = $this->makeTransaction($this->csd, $this->endUserStep);

        Sanctum::actingAs($csdEndUser);
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->gsoStep->id)
            ->assertJsonPath('data.current_step.office.id', $this->gso->id);

        Sanctum::actingAs($gsoAdmin);
        $this->postJson("/api/transactions/{$tx->id}/receive")->assertOk();
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->intakeRoute->id])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->intakeStep->id)
            ->assertJsonPath('data.current_step.office_id', $this->csd->id)
            ->assertJsonPath('data.current_step.office.id', $this->csd->id);

        Sanctum::actingAs($csdAdmin);
        $runs = collect($this->getJson("/api/transactions/{$tx->id}")->assertOk()->json('data.runs'));
        $intakeRun = $runs->firstWhere('to_step.id', $this->intakeStep->id);
        $this->assertNotNull($intakeRun);
        $this->assertSame($this->csd->id, $intakeRun['to_step']['office']['id']);
        $this->assertSame($this->csd->id, $intakeRun['received_office']['id']);

        $steps = collect($this->getJson("/api/transactions/{$tx->id}")->json('data.workflow_steps'))
            ->keyBy('id');
        $this->assertSame($this->csd->id, $steps[$this->intakeStep->id]['office_id']);
        $this->assertSame($this->csd->id, $steps[$this->intakeStep->id]['office']['id']);

        $superadminRole = Role::create(['code' => 'superadmin', 'name' => 'Superadmin']);
        Sanctum::actingAs($this->userWithRole($superadminRole));
        $this->getJson('/api/admin/transactions')
            ->assertOk()
            ->assertJsonPath('data.0.current_step.id', $this->intakeStep->id)
            ->assertJsonPath('data.0.current_step.office_id', $this->csd->id)
            ->assertJsonPath('data.0.current_step.office.id', $this->csd->id);

        // A blank station belongs to the transaction's originating office.
        Sanctum::actingAs($hrAdmin);
        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();
        $this->postJson("/api/transactions/{$tx->id}/receive")->assertForbidden();

        Sanctum::actingAs($csdAdmin);
        $this->getJson("/api/transactions/{$tx->id}")->assertOk();
        $this->postJson("/api/transactions/{$tx->id}/receive")->assertOk();
    }

    public function test_end_user_toggle_overrides_office_without_the_end_user_role(): void
    {
        $toggleStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 4,
            'code' => 'toggle_station',
            'name' => 'Toggle Station',
            'is_end_user' => true,
            'office_id' => $this->gso->id,
        ]);
        StepRole::create(['workflow_step_id' => $toggleStep->id, 'role_id' => $this->adminRole->id]);

        $csdAdmin = $this->userWithRole($this->adminRole, $this->csd);
        $gsoAdmin = $this->userWithRole($this->adminRole, $this->gso);
        $tx = $this->makeTransaction($this->csd, $toggleStep);

        Sanctum::actingAs($csdAdmin);
        $this->getJson("/api/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('data.current_step.office.id', $this->csd->id)
            ->assertJsonPath('data.runs.0.to_step.office.id', $this->csd->id);

        // The template office no longer grants access for a toggled step.
        Sanctum::actingAs($gsoAdmin);
        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();
    }

    public function test_superadmin_creation_uses_the_selected_office_for_an_end_user_start_step(): void
    {
        $superadminRole = Role::create(['code' => 'superadmin', 'name' => 'Superadmin']);
        $superadmin = $this->userWithRole($superadminRole);

        Sanctum::actingAs($superadmin);

        $created = $this->postJson('/api/admin/transactions', [
            'transaction_type_id' => $this->type->id,
            'office_id' => $this->csd->id,
            'title' => 'Selected office request',
        ])->assertCreated();

        $id = $created->json('data.id');

        $this->assertDatabaseHas('transactions', [
            'id' => $id,
            'office_id' => $this->csd->id,
        ]);
        $this->assertDatabaseHas('transaction_step_runs', [
            'transaction_id' => $id,
            'action_code' => 'create',
            'received_office_id' => $this->csd->id,
        ]);

        $created
            ->assertJsonPath('data.office.id', $this->csd->id)
            ->assertJsonPath('data.current_step.office_id', $this->csd->id)
            ->assertJsonPath('data.current_step.office.id', $this->csd->id)
            ->assertJsonPath('data.runs.0.received_office.id', $this->csd->id)
            ->assertJsonPath('data.runs.0.to_step.office.id', $this->csd->id);

        // The history feed reads the same pinned workflow: the end-user
        // start step must display the selected office, not the template's.
        $this->getJson("/api/admin/transactions/{$id}")
            ->assertOk()
            ->assertJsonPath('data.runs.0.to_step.office.id', $this->csd->id);
    }

    public function test_end_user_role_without_the_toggle_keeps_the_template_office(): void
    {
        $roleOnlyStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 5,
            'code' => 'role_only_station',
            'name' => 'Role-only Station',
            'is_end_user' => false,
            'office_id' => $this->gso->id,
        ]);
        StepRole::create(['workflow_step_id' => $roleOnlyStep->id, 'role_id' => $this->endUserRole->id]);

        $csdEndUser = $this->userWithRole($this->endUserRole, $this->csd);
        $gsoEndUser = $this->userWithRole($this->endUserRole, $this->gso);
        $tx = $this->makeTransaction($this->csd, $roleOnlyStep);

        Sanctum::actingAs($csdEndUser);
        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();

        Sanctum::actingAs($gsoEndUser);
        $this->getJson("/api/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('data.current_step.office.id', $this->gso->id);
    }
}
