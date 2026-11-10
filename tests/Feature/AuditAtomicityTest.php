<?php

namespace Tests\Feature;

use App\Models\AuditLog;
use App\Models\Office;
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
use App\Services\AuditService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuditAtomicityTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private Role $clerk;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $step;
    private User $creator;

    protected function setUp(): void
    {
        parent::setUp();

        $this->office = Office::create(['code' => 'TST', 'name' => 'Test Office']);
        $this->clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $this->type = TransactionType::create(['code' => 'atomic_test', 'name' => 'Atomic Test']);

        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'atomic_step',
            'name' => 'Atomic Step',
            'is_start' => true,
            'office_id' => $this->office->id,
        ]);

        StepRole::create([
            'workflow_step_id' => $this->step->id,
            'role_id' => $this->clerk->id,
        ]);

        $this->creator = User::factory()->create(['office_id' => $this->office->id]);
    }

    private function userWithRole(string $roleCode, ?Office $office = null): User
    {
        $role = Role::firstOrCreate(
            ['code' => $roleCode],
            ['name' => ucfirst($roleCode)]
        );

        $user = User::factory()->create(['office_id' => $office?->id]);
        $user->roles()->attach($role->id);

        return $user;
    }

    private function makeTransaction(): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'office_id' => $this->office->id,
            'reference_number' => 'ATOMIC-' . uniqid(),
            'title' => 'Atomicity test',
            'created_by' => $this->creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $this->step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    private function failAudits(): void
    {
        $this->app->instance(AuditService::class, new class extends AuditService {
            public function log(
                ?Request $request,
                string $event,
                ?object $entity = null,
                array $meta = []
            ): void {
                throw new \RuntimeException('Simulated audit failure.');
            }
        });
    }

    public function test_role_update_rolls_back_when_audit_fails(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $role = Role::create(['code' => 'atomic_role', 'name' => 'Original']);

        Sanctum::actingAs($superadmin);
        $this->failAudits();

        $this->putJson("/api/admin/roles/{$role->id}", [
            'code' => 'atomic_role',
            'name' => 'Changed',
        ])->assertStatus(500);

        $this->assertSame('Original', $role->fresh()->name);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'roles.update',
            'entity_id' => $role->id,
        ]);
    }

    public function test_transaction_archive_rolls_back_when_audit_fails(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();

        Sanctum::actingAs($superadmin);
        $this->failAudits();

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")->assertStatus(500);

        $this->assertFalse((bool) $tx->fresh()->is_archive);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'transactions.archive',
            'entity_id' => $tx->id,
        ]);
    }

    public function test_requirement_check_rolls_back_when_audit_fails(): void
    {
        $requirement = RequirementDefinition::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'atomic_req',
            'name' => 'Atomic Requirement',
            'is_active' => true,
        ]);

        $this->step->requirementDefinitions()->attach($requirement->id, [
            'display_order' => 1,
            'is_required' => true,
            'is_upload_required' => true,
        ]);

        $tx = $this->makeTransaction();
        $user = $this->userWithRole('clerk', $this->office);

        Sanctum::actingAs($user);
        $this->failAudits();

        $this->postJson("/api/transactions/{$tx->id}/requirements/{$requirement->id}/check")
            ->assertStatus(500);

        $this->assertDatabaseMissing('transaction_requirement_checks', [
            'transaction_id' => $tx->id,
            'requirement_definition_id' => $requirement->id,
        ]);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'transactions.requirement_check',
            'transaction_id' => $tx->id,
        ]);
    }

    public function test_attachment_upload_removes_file_when_audit_fails(): void
    {
        Storage::fake('local');

        $tx = $this->makeTransaction();
        $user = $this->userWithRole('clerk', $this->office);

        Sanctum::actingAs($user);
        $this->failAudits();

        $this->postJson("/api/transactions/{$tx->id}/attachments", [
            'file' => UploadedFile::fake()->create('evidence.pdf', 20, 'application/pdf'),
        ])->assertStatus(500);

        $this->assertDatabaseMissing('transaction_attachments', [
            'transaction_id' => $tx->id,
        ]);
        $this->assertCount(0, Storage::disk('local')->allFiles());
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'transactions.attachment_upload',
            'transaction_id' => $tx->id,
        ]);
    }

    public function test_attachment_delete_keeps_row_and_file_when_audit_fails(): void
    {
        Storage::fake('local');
        Storage::disk('local')->put('attachments/atomic.pdf', 'content');

        $tx = $this->makeTransaction();
        $user = $this->userWithRole('clerk', $this->office);

        $attachment = TransactionAttachment::create([
            'transaction_id' => $tx->id,
            'workflow_step_id' => $this->step->id,
            'original_name' => 'atomic.pdf',
            'stored_path' => 'attachments/atomic.pdf',
            'disk' => 'local',
            'mime' => 'application/pdf',
            'size_bytes' => 7,
            'uploaded_by' => $user->id,
        ]);

        Sanctum::actingAs($user);
        $this->failAudits();

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$attachment->id}")
            ->assertStatus(500);

        $this->assertDatabaseHas('transaction_attachments', ['id' => $attachment->id]);
        $this->assertTrue(Storage::disk('local')->exists('attachments/atomic.pdf'));
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'transactions.attachment_delete',
            'transaction_id' => $tx->id,
        ]);
    }

    public function test_workflow_save_as_rolls_back_when_audit_fails(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $type = TransactionType::create(['code' => 'atomic_wf', 'name' => 'Atomic Workflow']);

        $live = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
            'is_live' => true,
        ]);

        $start = WorkflowStep::create([
            'workflow_definition_id' => $live->id,
            'order_number' => 1,
            'code' => 'atomic_start',
            'name' => 'Atomic Start',
            'is_start' => true,
            'office_id' => $this->office->id,
        ]);

        $end = WorkflowStep::create([
            'workflow_definition_id' => $live->id,
            'order_number' => 2,
            'code' => 'atomic_end',
            'name' => 'Atomic End',
            'is_end' => true,
            'office_id' => $this->office->id,
        ]);

        WorkflowRoute::create([
            'workflow_definition_id' => $live->id,
            'from_step_id' => $start->id,
            'to_step_id' => $end->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);

        Sanctum::actingAs($superadmin);
        $this->failAudits();

        $this->postJson("/api/admin/workflow-definitions/{$live->id}/save-as", [
            'name' => 'New Version',
        ])->assertStatus(500);

        $this->assertSame(1, WorkflowDefinition::where('transaction_type_id', $type->id)->count());
        $this->assertTrue((bool) $live->fresh()->is_live);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'workflow_definitions.save_as',
        ]);
    }

    public function test_workflow_step_update_rolls_back_when_audit_fails(): void
    {
        $superadmin = $this->userWithRole('superadmin');

        $draft = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 2,
            'status' => 'draft',
        ]);

        $step = WorkflowStep::create([
            'workflow_definition_id' => $draft->id,
            'order_number' => 1,
            'code' => 'atomic_draft_step',
            'name' => 'Original Step',
            'is_start' => true,
            'sla_minutes' => 60,
        ]);

        Sanctum::actingAs($superadmin);
        $this->failAudits();

        $this->putJson("/api/admin/workflow-definitions/{$draft->id}/steps/{$step->id}", [
            'order_number' => 1,
            'code' => 'atomic_draft_step',
            'name' => 'Changed Step',
            'sla_minutes' => 60,
            'is_start' => true,
        ])->assertStatus(500);

        $this->assertSame('Original Step', $step->fresh()->name);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'workflow_steps.update',
            'entity_id' => $step->id,
        ]);
    }
}
