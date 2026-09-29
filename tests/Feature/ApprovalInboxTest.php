<?php

namespace Tests\Feature;

use App\Models\RequirementDefinition;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Approvals inbox: the station after Station 1 validates Station 1's
 * requirements (its checklist mirrors the previous station's requirements).
 */
class ApprovalInboxTest extends TestCase
{
    use RefreshDatabase;

    private Role $clerk;
    private Role $approver;
    private WorkflowDefinition $workflow;
    private TransactionType $type;
    private WorkflowStep $collect;
    private WorkflowStep $validate;
    private RequirementDefinition $dtr;

    protected function setUp(): void
    {
        parent::setUp();

        $this->type = TransactionType::create(['code' => 'payroll', 'name' => 'Payroll']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $this->clerk = Role::create(['code' => 'clerk', 'name' => 'Clerk']);
        $this->approver = Role::create(['code' => 'approver', 'name' => 'Approver']);

        $this->collect = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'collect_dtr',
            'name' => 'Collect DTR',
            'is_start' => true,
        ]);
        $this->validate = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 2,
            'code' => 'validate_dtr',
            'name' => 'Validate DTR',
        ]);
        StepRole::create(['workflow_step_id' => $this->collect->id, 'role_id' => $this->clerk->id]);
        StepRole::create(['workflow_step_id' => $this->validate->id, 'role_id' => $this->approver->id]);

        WorkflowRoute::create([
            'workflow_definition_id' => $this->workflow->id,
            'from_step_id' => $this->collect->id,
            'to_step_id' => $this->validate->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);

        $this->dtr = RequirementDefinition::create([
            'workflow_definition_id' => $this->workflow->id,
            'code' => 'dtr_collected',
            'name' => 'DTR collected',
        ]);
        $this->collect->requirementDefinitions()->attach($this->dtr->id, [
            'display_order' => 1,
            'is_required' => true,
        ]);
    }

    private function makeTransactionAt(WorkflowStep $step, User $creator, bool $isDone = false): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'September payroll',
            'is_done' => $isDone,
            'created_by' => $creator->id,
        ]);
        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    private function userWithRole(Role $role): User
    {
        $user = User::factory()->create();
        $user->roles()->attach($role->id);

        return $user;
    }

    public function test_station_two_sees_station_one_requirements_with_files(): void
    {
        $approver = $this->userWithRole($this->approver);
        $tx = $this->makeTransactionAt($this->validate, $approver);

        TransactionAttachment::create([
            'transaction_id' => $tx->id,
            'workflow_step_id' => $this->collect->id,
            'requirement_definition_id' => $this->dtr->id,
            'original_name' => 'dtr.pdf',
            'stored_path' => 'attachments/dtr.pdf',
            'disk' => 'local',
            'mime' => 'application/pdf',
            'size_bytes' => 2048,
            'uploaded_by' => $approver->id,
        ]);

        Sanctum::actingAs($approver);

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id)
            ->assertJsonPath('data.0.current_step_checklist.0.name', 'DTR collected')
            ->assertJsonPath('data.0.current_step_checklist.0.is_required', true)
            ->assertJsonPath('data.0.current_step_checklist.0.checked', false)
            ->assertJsonPath('data.0.current_step_checklist.0.source_step.id', $this->collect->id)
            ->assertJsonPath('data.0.current_step_checklist.0.source_step.name', 'Collect DTR')
            ->assertJsonPath('data.0.current_step_checklist.0.attachment_count', 1)
            ->assertJsonPath('data.0.current_step_checklist.0.attachments.0.original_name', 'dtr.pdf');
    }

    public function test_start_station_transactions_are_not_listed(): void
    {
        $clerk = $this->userWithRole($this->clerk);
        $this->makeTransactionAt($this->collect, $clerk);

        Sanctum::actingAs($clerk);

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_user_without_station_role_sees_nothing(): void
    {
        $approver = $this->userWithRole($this->approver);
        $this->makeTransactionAt($this->validate, $approver);

        Sanctum::actingAs($this->userWithRole($this->clerk));

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_finalized_transactions_are_excluded(): void
    {
        $approver = $this->userWithRole($this->approver);
        $this->makeTransactionAt($this->validate, $approver, isDone: true);

        Sanctum::actingAs($approver);

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_end_user_is_forbidden(): void
    {
        $endUser = $this->userWithRole(Role::create(['code' => 'end_user', 'name' => 'End User']));

        Sanctum::actingAs($endUser);

        $this->getJson('/api/approvals')->assertForbidden();
    }

    public function test_user_without_any_role_is_forbidden(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->getJson('/api/approvals')->assertForbidden();
    }

    public function test_superadmin_keeps_access_even_with_end_user_role(): void
    {
        $admin = $this->userWithRole(Role::create(['code' => 'superadmin', 'name' => 'Super Admin']));
        $admin->roles()->attach(Role::create(['code' => 'end_user', 'name' => 'End User'])->id);
        $this->makeTransactionAt($this->validate, $admin);

        Sanctum::actingAs($admin);

        $this->getJson('/api/approvals')
            ->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_count_reports_unvalidated_required_requirements(): void
    {
        $approver = $this->userWithRole($this->approver);
        $ar = RequirementDefinition::create([
            'workflow_definition_id' => $this->workflow->id,
            'code' => 'ar',
            'name' => 'AR',
        ]);
        $this->collect->requirementDefinitions()->attach($ar->id, ['display_order' => 2, 'is_required' => true]);

        $first = $this->makeTransactionAt($this->validate, $approver);
        $this->makeTransactionAt($this->validate, $approver);
        $this->makeTransactionAt($this->collect, $approver); // start station: never counted

        Sanctum::actingAs($approver);

        // 2 transactions x 2 required items (DTR collected, AR)
        $this->getJson('/api/approvals/count')
            ->assertOk()
            ->assertExactJson(['pending_requirements' => 4, 'transactions' => 2]);

        // Validating one item on the first transaction lowers the count.
        $dtrItem = app(\App\Services\ChecklistService::class)
            ->ensureItems($this->validate)
            ->firstWhere('requirement_definition_id', $this->dtr->id);
        $this->postJson("/api/transactions/{$first->id}/checklist/{$dtrItem->id}/check")->assertOk();

        $this->getJson('/api/approvals/count')
            ->assertOk()
            ->assertExactJson(['pending_requirements' => 3, 'transactions' => 2]);
    }

    public function test_count_is_forbidden_for_end_users(): void
    {
        Sanctum::actingAs($this->userWithRole(Role::create(['code' => 'end_user', 'name' => 'End User'])));

        $this->getJson('/api/approvals/count')->assertForbidden();
    }

    public function test_guest_is_rejected(): void
    {
        $this->getJson('/api/approvals')->assertUnauthorized();
    }
}
