<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Permission;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Database\Seeders\PermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Admin transaction routes: viewing is open to every signed-in user. Regular
 * users are office + role bound (their office's transactions at a station
 * that lists one of their roles), office admins see their whole office, and
 * superadmin sees all. Creating stays behind the Create Transactions grant.
 */
class AdminTransactionsAccessTest extends TestCase
{
    use RefreshDatabase;

    private Office $gso;
    private Office $cbo;
    private Role $clerkRole;
    private Role $approverRole;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $gsoStep;
    private WorkflowStep $gsoReviewStep;
    private WorkflowStep $cboStep;
    private User $creator;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(PermissionsSeeder::class);

        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->cbo = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);

        $this->clerkRole = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $this->approverRole = Role::firstOrCreate(['code' => 'approver'], ['name' => 'Approver']);

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
        $this->gsoReviewStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 2,
            'code' => 'gso_review',
            'name' => 'GSO Review',
            'office_id' => $this->gso->id,
        ]);
        $this->cboStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 3,
            'code' => 'cbo_budget',
            'name' => 'CBO Budget',
            'office_id' => $this->cbo->id,
        ]);

        StepRole::create(['workflow_step_id' => $this->gsoStep->id, 'role_id' => $this->clerkRole->id]);
        StepRole::create(['workflow_step_id' => $this->gsoReviewStep->id, 'role_id' => $this->approverRole->id]);
        StepRole::create(['workflow_step_id' => $this->cboStep->id, 'role_id' => $this->clerkRole->id]);

        $this->creator = User::factory()->create();
    }

    private function userWithRole(string $roleCode, ?Office $office = null): User
    {
        $role = Role::firstOrCreate(['code' => $roleCode], ['name' => ucfirst($roleCode)]);
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

    public function test_regular_users_are_office_and_role_bound(): void
    {
        $clerk = $this->userWithRole('clerk', $this->gso);
        $gsoTx = $this->makeTransaction($this->gso, $this->gsoStep);
        $this->makeTransaction($this->gso, $this->gsoReviewStep);
        $cboTx = $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($clerk);

        $this->getJson('/api/admin/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $gsoTx->id);

        $this->getJson("/api/admin/transactions/{$gsoTx->id}")->assertOk();
        $this->getJson("/api/admin/transactions/{$cboTx->id}")->assertForbidden();
    }

    public function test_office_admin_sees_their_whole_office_regardless_of_role(): void
    {
        $admin = $this->userWithRole('admin', $this->gso);
        $gsoTx = $this->makeTransaction($this->gso, $this->gsoStep);
        $reviewTx = $this->makeTransaction($this->gso, $this->gsoReviewStep);
        $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($admin);

        $ids = collect($this->getJson('/api/admin/transactions')->assertOk()->json('data'))
            ->pluck('id')
            ->all();

        $this->assertEqualsCanonicalizing([$gsoTx->id, $reviewTx->id], $ids);
    }

    public function test_office_less_user_sees_an_empty_list(): void
    {
        $this->makeTransaction($this->gso, $this->gsoStep);
        $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($this->userWithRole('clerk'));

        $this->getJson('/api/admin/transactions')->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_superadmin_sees_all_transactions(): void
    {
        $this->makeTransaction($this->gso, $this->gsoStep);
        $this->makeTransaction($this->cbo, $this->cboStep);

        Sanctum::actingAs($this->userWithRole('superadmin'));

        $this->getJson('/api/admin/transactions')->assertOk()->assertJsonCount(2, 'data');
    }

    public function test_create_requires_the_create_transactions_grant(): void
    {
        Sanctum::actingAs($this->userWithRole('clerk', $this->gso));

        $this->postJson('/api/admin/transactions', [
            'transaction_type_id' => $this->type->id,
            'title' => 'Blocked',
        ])->assertForbidden();
    }

    public function test_granted_user_can_create_transactions(): void
    {
        $role = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $role->permissions()->attach(
            Permission::where('code', 'transactions.manage')->firstOrFail()->id
        );

        $user = User::factory()->create(['office_id' => $this->gso->id]);
        $user->roles()->attach($role->id);

        Sanctum::actingAs($user);

        $this->postJson('/api/admin/transactions', [
            'transaction_type_id' => $this->type->id,
            'office_id' => $this->gso->id,
            'title' => 'Granted create',
        ])->assertCreated();
    }
}
