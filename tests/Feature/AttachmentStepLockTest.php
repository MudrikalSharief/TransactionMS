<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
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
 * Step-locked evidence: any current-step worker may remove a just-uploaded
 * file (wrong-file replace). Once the step is sent forward, the file is
 * locked for everyone — including superadmin.
 */
class AttachmentStepLockTest extends TestCase
{
    use RefreshDatabase;

    private Role $clerk;
    private Role $approver;
    private WorkflowDefinition $workflow;
    private TransactionType $type;
    private WorkflowStep $collect;
    private WorkflowStep $validate;

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
    }

    private function userWithRole(Role $role): User
    {
        $user = User::factory()->create();
        $user->roles()->attach($role->id);

        return $user;
    }

    private function makeTransactionAt(WorkflowStep $step, User $creator): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'September payroll',
            'created_by' => $creator->id,
        ]);
        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    private function makeFile(Transaction $tx, WorkflowStep $step, User $uploader, array $overrides = []): TransactionAttachment
    {
        return TransactionAttachment::create(array_merge([
            'transaction_id' => $tx->id,
            'workflow_step_id' => $step->id,
            'original_name' => 'dtr.pdf',
            'stored_path' => 'attachments/dtr-' . uniqid() . '.pdf',
            'disk' => 'local',
            'mime' => 'application/pdf',
            'size_bytes' => 2048,
            'uploaded_by' => $uploader->id,
        ], $overrides));
    }

    private function makeRun(Transaction $tx, User $performer): TransactionStepRun
    {
        return TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $this->collect->id,
            'to_step_id' => $this->validate->id,
            'action_code' => 'submit',
            'performed_by' => $performer->id,
            'performed_at' => now(),
        ]);
    }

    public function test_worker_can_delete_own_step_file_before_proceed(): void
    {
        $clerk = $this->userWithRole($this->clerk);
        $tx = $this->makeTransactionAt($this->collect, $clerk);
        $file = $this->makeFile($tx, $this->collect, $clerk);

        Sanctum::actingAs($clerk);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$file->id}")
            ->assertOk();

        $this->assertModelMissing($file);
    }

    public function test_file_on_previous_step_is_locked(): void
    {
        $worker = User::factory()->create();
        $worker->roles()->attach([$this->clerk->id, $this->approver->id]);
        $tx = $this->makeTransactionAt($this->validate, $worker);
        $file = $this->makeFile($tx, $this->collect, $worker);

        Sanctum::actingAs($worker);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$file->id}")
            ->assertStatus(422);

        $this->assertModelExists($file);
    }

    public function test_non_worker_cannot_delete(): void
    {
        $clerk = $this->userWithRole($this->clerk);
        $tx = $this->makeTransactionAt($this->validate, $clerk);
        $file = $this->makeFile($tx, $this->collect, $clerk);

        Sanctum::actingAs($clerk);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$file->id}")
            ->assertForbidden();

        $this->assertModelExists($file);
    }

    public function test_travelled_file_is_locked_even_for_superadmin(): void
    {
        $clerk = $this->userWithRole($this->clerk);
        $tx = $this->makeTransactionAt($this->validate, $clerk);
        $run = $this->makeRun($tx, $clerk);
        $file = $this->makeFile($tx, $this->collect, $clerk, ['step_run_id' => $run->id]);

        $superadmin = $this->userWithRole(Role::create(['code' => 'superadmin', 'name' => 'Superadmin']));
        Sanctum::actingAs($superadmin);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$file->id}")
            ->assertStatus(422);

        $this->assertModelExists($file);
    }

    public function test_unlink_current_step_reference_is_allowed(): void
    {
        $clerk = $this->userWithRole($this->clerk);
        $tx = $this->makeTransactionAt($this->collect, $clerk);
        $owner = $this->makeFile($tx, $this->collect, $clerk);
        $link = $this->makeFile($tx, $this->collect, $clerk, ['source_attachment_id' => $owner->id]);

        Sanctum::actingAs($clerk);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$link->id}/unlink")
            ->assertOk();

        $this->assertModelMissing($link);
        $this->assertModelExists($owner);
    }

    public function test_unlink_travelled_reference_is_locked(): void
    {
        $worker = User::factory()->create();
        $worker->roles()->attach([$this->clerk->id, $this->approver->id]);
        $tx = $this->makeTransactionAt($this->validate, $worker);
        $run = $this->makeRun($tx, $worker);
        $owner = $this->makeFile($tx, $this->collect, $worker, ['step_run_id' => $run->id]);
        $link = $this->makeFile($tx, $this->collect, $worker, [
            'source_attachment_id' => $owner->id,
            'step_run_id' => $run->id,
        ]);

        Sanctum::actingAs($worker);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$link->id}/unlink")
            ->assertStatus(422);

        $this->assertModelExists($link);
    }
}
