<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OfficeScopedAccessTest extends TestCase
{
    use RefreshDatabase;

    private Office $gso;
    private Office $cbo;
    private Role $adminRole;
    private Role $clerkRole;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $gsoStep;
    private WorkflowStep $cboStep;
    private WorkflowRoute $route;
    private User $creator;

    protected function setUp(): void
    {
        parent::setUp();

        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->cbo = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);

        $this->adminRole = Role::create(['code' => 'admin', 'name' => 'Admin']);
        $this->clerkRole = Role::create(['code' => 'clerk', 'name' => 'Clerk']);

        $this->type = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $this->gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'gso_process',
            'name' => 'GSO Processing',
            'is_start' => true,
            'office_id' => $this->gso->id,
        ]);
        $this->cboStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 2,
            'code' => 'cbo_budget',
            'name' => 'CBO Budget',
            'office_id' => $this->cbo->id,
        ]);

        StepRole::create(['workflow_step_id' => $this->gsoStep->id, 'role_id' => $this->clerkRole->id]);
        StepRole::create(['workflow_step_id' => $this->cboStep->id, 'role_id' => $this->clerkRole->id]);

        $this->route = WorkflowRoute::create([
            'workflow_definition_id' => $this->workflow->id,
            'from_step_id' => $this->gsoStep->id,
            'to_step_id' => $this->cboStep->id,
            'action_code' => 'submit',
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

        return $tx;
    }

    public function test_office_admin_sees_every_transaction_of_their_office(): void
    {
        $ramon = $this->userWithRole($this->adminRole, $this->gso);
        $gsoTx = $this->makeTransaction($this->gso, $this->gsoStep);
        $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($ramon);

        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $gsoTx->id);
    }

    public function test_office_admin_can_act_on_any_step_of_their_office_transactions(): void
    {
        $ramon = $this->userWithRole($this->adminRole, $this->gso);
        $tx = $this->makeTransaction($this->gso, $this->gsoStep);

        Sanctum::actingAs($ramon);

        $this->getJson("/api/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions.0.route_id', $this->route->id);

        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->cboStep->id);
    }

    public function test_office_admin_cannot_touch_other_offices_transactions(): void
    {
        $ramon = $this->userWithRole($this->adminRole, $this->gso);
        $tx = $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($ramon);

        $this->getJson("/api/transactions/{$tx->id}")->assertForbidden();
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();
    }

    public function test_admin_role_without_an_office_gets_no_office_powers(): void
    {
        $admin = $this->userWithRole($this->adminRole);
        $tx = $this->makeTransaction($this->gso, $this->gsoStep);

        Sanctum::actingAs($admin);

        $this->getJson('/api/transactions')->assertOk()->assertJsonCount(0, 'data');
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();
    }

    public function test_regular_user_needs_both_role_and_office_match(): void
    {
        $gsoClerk = $this->userWithRole($this->clerkRole, $this->gso);
        $cboClerk = $this->userWithRole($this->clerkRole, $this->cbo);
        $tx = $this->makeTransaction($this->gso, $this->gsoStep);

        Sanctum::actingAs($gsoClerk);
        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id);

        Sanctum::actingAs($cboClerk);
        $this->getJson('/api/transactions')->assertOk()->assertJsonCount(0, 'data');
        $this->postJson("/api/transactions/{$tx->id}/execute", ['route_id' => $this->route->id])
            ->assertForbidden();
    }

    public function test_step_without_office_keeps_role_only_access(): void
    {
        $freeStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 3,
            'code' => 'free_step',
            'name' => 'Office-agnostic Step',
        ]);
        StepRole::create(['workflow_step_id' => $freeStep->id, 'role_id' => $this->clerkRole->id]);

        $gsoClerk = $this->userWithRole($this->clerkRole, $this->gso);
        $tx = $this->makeTransaction($this->gso, $freeStep);

        Sanctum::actingAs($gsoClerk);

        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id);
    }

    public function test_approval_inbox_and_count_follow_the_same_office_scoping(): void
    {
        $ramon = $this->userWithRole($this->adminRole, $this->gso);
        $gsoTx = $this->makeTransaction($this->gso, $this->gsoStep);
        $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($ramon);

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $gsoTx->id);
    }
}
