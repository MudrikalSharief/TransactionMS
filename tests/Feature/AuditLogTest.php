<?php

namespace Tests\Feature;

use App\Models\AuditLog;
use App\Models\ChecklistOverride;
use App\Models\FieldDefinition;
use App\Models\Office;
use App\Models\RequirementDefinition;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use App\Services\AuditService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuditLogTest extends TestCase
{
    use RefreshDatabase;

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

    public function test_role_update_records_actor_snapshot_and_changed_fields(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $role = Role::create([
            'code' => 'auditor',
            'name' => 'Auditor',
            'description' => 'Old description',
        ]);

        Sanctum::actingAs($superadmin);

        $this->putJson("/api/admin/roles/{$role->id}", [
            'code' => 'auditor',
            'name' => 'Auditor Updated',
            'description' => 'New description',
        ])->assertOk();

        $log = AuditLog::where('event', 'roles.update')->latest('id')->firstOrFail();

        $this->assertSame('roles', $log->module);
        $this->assertSame('update', $log->action);
        $this->assertSame('role', $log->entity_type);
        $this->assertSame($role->id, $log->entity_id);
        $this->assertSame('Auditor Updated', $log->entity_label);
        $this->assertSame($superadmin->name, $log->actor_name);
        $this->assertSame($superadmin->email, $log->actor_email);
        $this->assertTrue($log->actor_is_superadmin);
        $this->assertContains('superadmin', collect($log->actor_roles)->pluck('code')->all());
        $this->assertSame(['name', 'description'], $log->changed_fields);
        $this->assertSame('Old description', $log->old_values['description']);
        $this->assertSame('New description', $log->new_values['description']);
        $this->assertSame('PUT', $log->request_method);
        $this->assertSame('/api/admin/roles/' . $role->id, $log->request_path);
        $this->assertNotNull($log->request_id);
    }

    public function test_create_payload_is_stored_as_new_values(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        Sanctum::actingAs($superadmin);

        $this->postJson('/api/admin/roles', [
            'code' => 'new_role',
            'name' => 'New Role',
        ])->assertCreated();

        $log = AuditLog::where('event', 'roles.create')->latest('id')->firstOrFail();

        $this->assertSame(['code', 'name'], $log->changed_fields);
        $this->assertSame('new_role', $log->new_values['code']);
        $this->assertSame('New Role', $log->new_values['name']);
        $this->assertNull($log->old_values);
    }

    public function test_check_and_uncheck_are_both_audited(): void
    {
        $office = Office::create(['code' => 'TST', 'name' => 'Test Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'test', 'name' => 'Test Process']);

        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'test_step',
            'name' => 'Test Step',
            'is_start' => true,
            'office_id' => $office->id,
        ]);

        StepRole::create([
            'workflow_step_id' => $step->id,
            'role_id' => $clerk->id,
        ]);

        $requirement = RequirementDefinition::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'test_req',
            'name' => 'Test Requirement',
            'is_active' => true,
        ]);

        $step->requirementDefinitions()->attach($requirement->id, [
            'display_order' => 1,
            'is_required' => true,
            'is_upload_required' => true,
        ]);

        $user = $this->userWithRole('clerk', $office);
        $creator = User::factory()->create(['office_id' => $office->id]);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'AUDIT-TEST-1',
            'title' => 'Audit test',
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $this->postJson("/api/transactions/{$tx->id}/requirements/{$requirement->id}/check")
            ->assertOk();

        $checkLog = AuditLog::where('event', 'transactions.requirement_check')->latest('id')->firstOrFail();
        $this->assertSame($user->id, $checkLog->actor_user_id);
        $this->assertSame($tx->id, $checkLog->transaction_id);
        $this->assertSame($office->id, $checkLog->office_id);
        $this->assertSame('transaction_requirement_check', $checkLog->entity_type);
        $this->assertSame('Test Requirement', $checkLog->entity_label);

        $superadmin = $this->userWithRole('superadmin');
        Sanctum::actingAs($superadmin);

        $summary = $this->getJson('/api/admin/activity?kind=all&module=transactions&action=requirement_check')
            ->assertOk()
            ->json('data.0.summary');

        $this->assertStringContainsString('requirement: Test Requirement', $summary);
        $this->assertStringContainsString('step: Test Step', $summary);
        $this->assertStringNotContainsString('requirement_definition_id', $summary);
        $this->assertStringNotContainsString('workflow_step_id', $summary);

        Sanctum::actingAs($user);

        $this->deleteJson("/api/transactions/{$tx->id}/requirements/{$requirement->id}/check")
            ->assertOk();

        $uncheckLog = AuditLog::where('event', 'transactions.requirement_uncheck')->latest('id')->firstOrFail();
        $this->assertSame($user->id, $uncheckLog->actor_user_id);
        $this->assertSame($tx->id, $uncheckLog->transaction_id);
        $this->assertSame('Test Requirement', $uncheckLog->entity_label);
        $this->assertSame('Test Requirement', $uncheckLog->old_values['requirement'] ?? null);

        $this->assertDatabaseMissing('transaction_requirement_checks', [
            'transaction_id' => $tx->id,
            'requirement_definition_id' => $requirement->id,
        ]);
    }

    public function test_checklist_check_and_uncheck_are_both_audited(): void
    {
        $office = Office::create(['code' => 'CHK', 'name' => 'Checklist Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'checklist_test', 'name' => 'Checklist Test']);

        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'checklist_step',
            'name' => 'Checklist Step',
            'is_start' => true,
            'office_id' => $office->id,
        ]);

        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $clerk->id]);

        $item = ChecklistOverride::create([
            'workflow_step_id' => $step->id,
            'name' => 'Verify signature',
            'is_required' => true,
            'display_order' => 1,
        ]);

        $user = $this->userWithRole('clerk', $office);
        $creator = User::factory()->create(['office_id' => $office->id]);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'AUDIT-CHK-1',
            'title' => 'Checklist audit test',
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $this->postJson("/api/transactions/{$tx->id}/checklist/{$item->id}/check")
            ->assertOk();

        $checkLog = AuditLog::where('event', 'transactions.checklist_check')->latest('id')->firstOrFail();
        $this->assertSame($tx->id, $checkLog->transaction_id);
        $this->assertSame('transaction_checklist_check', $checkLog->entity_type);
        $this->assertSame('Verify signature', $checkLog->entity_label);

        $this->deleteJson("/api/transactions/{$tx->id}/checklist/{$item->id}/check")
            ->assertOk();

        $uncheckLog = AuditLog::where('event', 'transactions.checklist_uncheck')->latest('id')->firstOrFail();
        $this->assertSame($tx->id, $uncheckLog->transaction_id);
        $this->assertSame('Verify signature', $uncheckLog->entity_label);

        $this->assertDatabaseMissing('transaction_checklist_checks', [
            'transaction_id' => $tx->id,
            'checklist_override_id' => $item->id,
        ]);
    }

    public function test_transaction_field_edits_are_audited_with_old_and_new_values(): void
    {
        $office = Office::create(['code' => 'FLD', 'name' => 'Field Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'field_test', 'name' => 'Field Test']);

        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $first = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'field_first',
            'name' => 'Field First',
            'is_start' => true,
            'office_id' => $office->id,
        ]);

        $second = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 2,
            'code' => 'field_second',
            'name' => 'Field Second',
            'is_end' => true,
            'office_id' => $office->id,
        ]);

        foreach ([$first, $second] as $step) {
            StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $clerk->id]);
        }

        $route = WorkflowRoute::create([
            'workflow_definition_id' => $workflow->id,
            'from_step_id' => $first->id,
            'to_step_id' => $second->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);

        $field = FieldDefinition::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'amount',
            'name' => 'Amount',
            'type' => 'text',
        ]);
        $first->fieldDefinitions()->attach($field->id, [
            'display_order' => 1,
            'required_override' => false,
        ]);

        $user = $this->userWithRole('clerk', $office);
        $creator = User::factory()->create(['office_id' => $office->id]);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'AUDIT-FIELD-1',
            'title' => 'Field audit test',
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $first->id,
            'entered_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $this->postJson("/api/transactions/{$tx->id}/execute", [
            'route_id' => $route->id,
            'field_values' => ['amount' => '125.50'],
        ])->assertOk();

        $log = AuditLog::where('event', 'transactions.fields_update')->latest('id')->firstOrFail();

        $this->assertSame($user->id, $log->actor_user_id);
        $this->assertSame($tx->id, $log->transaction_id);
        $this->assertSame($office->id, $log->office_id);
        $this->assertNotNull($log->step_run_id);
        $this->assertSame(['amount'], $log->changed_fields);
        $this->assertArrayHasKey('amount', $log->old_values);
        $this->assertNull($log->old_values['amount']);
        $this->assertSame('125.50', $log->new_values['amount']);
    }

    public function test_finalize_field_edit_is_audited(): void
    {
        $office = Office::create(['code' => 'FIN', 'name' => 'Finalize Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'finalize_test', 'name' => 'Finalize Test']);

        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'finalize_step',
            'name' => 'Finalize Step',
            'is_start' => true,
            'is_end' => true,
            'office_id' => $office->id,
        ]);

        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $clerk->id]);

        $field = FieldDefinition::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'amount',
            'name' => 'Amount',
            'type' => 'text',
        ]);
        $step->fieldDefinitions()->attach($field->id, [
            'display_order' => 1,
            'required_override' => false,
        ]);

        $user = $this->userWithRole('clerk', $office);
        $creator = User::factory()->create(['office_id' => $office->id]);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'AUDIT-FIN-1',
            'title' => 'Finalize audit test',
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $this->postJson("/api/transactions/{$tx->id}/finalize", [
            'field_values' => ['amount' => '99.00'],
        ])->assertOk();

        $log = AuditLog::where('event', 'transactions.fields_update')->latest('id')->firstOrFail();
        $this->assertSame($tx->id, $log->transaction_id);
        $this->assertNotNull($log->step_run_id);
        $this->assertSame('99.00', $log->new_values['amount']);
        $this->assertDatabaseHas('transactions', ['id' => $tx->id, 'is_done' => true]);
    }

    public function test_attachment_upload_and_delete_are_audited(): void
    {
        Storage::fake('local');

        $office = Office::create(['code' => 'ATT', 'name' => 'Attachment Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'attachment_test', 'name' => 'Attachment Test']);

        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'attachment_step',
            'name' => 'Attachment Step',
            'is_start' => true,
            'office_id' => $office->id,
        ]);

        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $clerk->id]);

        $user = $this->userWithRole('clerk', $office);
        $creator = User::factory()->create(['office_id' => $office->id]);

        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'AUDIT-ATT-1',
            'title' => 'Attachment audit test',
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'entered_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $attachment = $this->postJson("/api/transactions/{$tx->id}/attachments", [
            'file' => UploadedFile::fake()->create('evidence.pdf', 20, 'application/pdf'),
            'label' => 'Evidence',
        ])->assertCreated()->json('data');

        $uploadLog = AuditLog::where('event', 'transactions.attachment_upload')->latest('id')->firstOrFail();
        $this->assertSame($user->id, $uploadLog->actor_user_id);
        $this->assertSame($tx->id, $uploadLog->transaction_id);
        $this->assertSame($office->id, $uploadLog->office_id);
        $this->assertSame('transaction_attachment', $uploadLog->entity_type);
        $this->assertSame('evidence.pdf', $uploadLog->entity_label);

        $this->deleteJson("/api/transactions/{$tx->id}/attachments/{$attachment['id']}")
            ->assertOk();

        $deleteLog = AuditLog::where('event', 'transactions.attachment_delete')->latest('id')->firstOrFail();
        $this->assertSame($user->id, $deleteLog->actor_user_id);
        $this->assertSame($tx->id, $deleteLog->transaction_id);
        $this->assertSame('evidence.pdf', $deleteLog->entity_label);
        $this->assertSame('evidence.pdf', $deleteLog->old_values['original_name']);
    }

    public function test_superadmin_reject_is_only_audited_after_it_succeeds(): void
    {
        $superadmin = $this->userWithRole('superadmin');

        $notPending = User::factory()->create(['approved_at' => now()]);
        Sanctum::actingAs($superadmin);
        $this->deleteJson("/api/admin/users/{$notPending->id}/reject")->assertStatus(422);
        $this->assertDatabaseHas('users', ['id' => $notPending->id]);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'users.reject',
            'entity_id' => $notPending->id,
        ]);

        $pending = User::factory()->create(['approved_at' => null]);
        $pendingId = $pending->id;
        $pendingEmail = $pending->email;
        $pendingName = $pending->name;

        $this->deleteJson("/api/admin/users/{$pendingId}/reject")->assertOk();

        $this->assertDatabaseMissing('users', ['id' => $pendingId]);
        $this->assertSame(
            1,
            AuditLog::where('event', 'users.reject')->where('entity_id', $pendingId)->count()
        );

        $log = AuditLog::where('event', 'users.reject')->where('entity_id', $pendingId)->firstOrFail();
        $this->assertSame($superadmin->id, $log->actor_user_id);
        $this->assertSame('user', $log->entity_type);
        $this->assertSame($pendingEmail, $log->old_values['email']);
        $this->assertSame($pendingName, $log->old_values['name']);
    }

    public function test_reject_rolls_back_when_the_audit_write_fails(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $pending = User::factory()->create(['approved_at' => null]);
        $pendingId = $pending->id;

        $this->app->instance(AuditService::class, new class extends AuditService {
            public function log(
                ?\Illuminate\Http\Request $request,
                string $event,
                ?object $entity = null,
                array $meta = []
            ): void {
                throw new \RuntimeException('Simulated audit failure.');
            }
        });

        Sanctum::actingAs($superadmin);

        $this->deleteJson("/api/admin/users/{$pendingId}/reject")->assertStatus(500);

        $this->assertDatabaseHas('users', ['id' => $pendingId]);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'users.reject',
            'entity_id' => $pendingId,
        ]);
    }

    public function test_office_admin_reject_is_only_audited_after_it_succeeds(): void
    {
        $office = Office::create(['code' => 'REJ', 'name' => 'Reject Office']);
        $admin = $this->userWithRole('admin', $office);

        $notPending = User::factory()->create([
            'office_id' => $office->id,
            'approved_at' => now(),
        ]);
        Sanctum::actingAs($admin);
        $this->deleteJson("/api/office/users/{$notPending->id}/reject")->assertStatus(422);
        $this->assertDatabaseHas('users', ['id' => $notPending->id]);
        $this->assertDatabaseMissing('audit_logs', [
            'event' => 'office.users.reject',
            'entity_id' => $notPending->id,
        ]);

        $pending = User::factory()->create([
            'office_id' => $office->id,
            'approved_at' => null,
        ]);
        $pendingId = $pending->id;
        $pendingEmail = $pending->email;
        $pendingName = $pending->name;

        $this->deleteJson("/api/office/users/{$pendingId}/reject")->assertOk();

        $this->assertDatabaseMissing('users', ['id' => $pendingId]);
        $this->assertSame(
            1,
            AuditLog::where('event', 'office.users.reject')->where('entity_id', $pendingId)->count()
        );

        $log = AuditLog::where('event', 'office.users.reject')->where('entity_id', $pendingId)->firstOrFail();
        $this->assertSame($admin->id, $log->actor_user_id);
        $this->assertSame('user', $log->entity_type);
        $this->assertSame($pendingEmail, $log->old_values['email']);
        $this->assertSame($pendingName, $log->old_values['name']);
    }

    public function test_sensitive_values_are_redacted(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        Sanctum::actingAs($superadmin);

        app(AuditService::class)->log(request(), 'test.redact', null, [
            'new' => ['password' => 'secret', 'name' => 'safe'],
            'payload' => ['token' => 'abc'],
        ]);

        $log = AuditLog::where('event', 'test.redact')->firstOrFail();

        $this->assertSame('[redacted]', $log->new_values['password']);
        $this->assertSame('safe', $log->new_values['name']);
        $this->assertSame('[redacted]', $log->meta['payload']['token']);
    }

    public function test_audit_logs_are_append_only(): void
    {
        $log = AuditLog::create([
            'event' => 'test.event',
            'module' => 'test',
            'action' => 'event',
            'created_at' => now(),
        ]);

        try {
            $log->forceFill(['event' => 'changed'])->save();
            $this->fail('Expected an append-only update to be rejected.');
        } catch (\RuntimeException $e) {
            $this->assertStringContainsString('append-only', $e->getMessage());
        }

        try {
            $log->delete();
            $this->fail('Expected an append-only delete to be rejected.');
        } catch (\RuntimeException $e) {
            $this->assertStringContainsString('append-only', $e->getMessage());
        }

        $this->assertDatabaseHas('audit_logs', [
            'id' => $log->id,
            'event' => 'test.event',
        ]);
    }

    public function test_office_admin_only_sees_transaction_audit_rows_for_their_office(): void
    {
        $officeA = Office::create(['code' => 'OFA', 'name' => 'Office A']);
        $officeB = Office::create(['code' => 'OFB', 'name' => 'Office B']);
        $adminA = $this->userWithRole('admin', $officeA);

        AuditLog::create([
            'event' => 'transactions.requirement_check',
            'module' => 'transactions',
            'action' => 'requirement_check',
            'description' => 'Office A event',
            'office_id' => $officeA->id,
            'actor_user_id' => $adminA->id,
            'actor_name' => $adminA->name,
            'created_at' => now(),
        ]);

        AuditLog::create([
            'event' => 'transactions.requirement_check',
            'module' => 'transactions',
            'action' => 'requirement_check',
            'description' => 'Office B event',
            'office_id' => $officeB->id,
            'actor_user_id' => $adminA->id,
            'actor_name' => $adminA->name,
            'created_at' => now(),
        ]);

        AuditLog::create([
            'event' => 'roles.update',
            'module' => 'roles',
            'action' => 'update',
            'description' => 'Setup event',
            'created_at' => now(),
        ]);

        Sanctum::actingAs($adminA);

        $this->getJson('/api/admin/activity?kind=all&module=transactions&action=requirement_check')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.summary', 'Office A event')
            ->assertJsonPath('can_see_setup', false);
    }

    public function test_office_admin_sees_audit_rows_for_transactions_passing_through_their_office(): void
    {
        $origin = Office::create(['code' => 'ORG', 'name' => 'Origin Office']);
        $passing = Office::create(['code' => 'PASS', 'name' => 'Passing Office']);
        $admin = $this->userWithRole('admin', $passing);

        $type = TransactionType::create(['code' => 'scope_test', 'name' => 'Scope Test']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'passing_step',
            'name' => 'Passing Step',
            'is_start' => true,
            'office_id' => $passing->id,
        ]);

        $creator = User::factory()->create(['office_id' => $origin->id]);
        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $origin->id,
            'reference_number' => 'AUDIT-SCOPE-1',
            'title' => 'Pass-through audit test',
            'created_by' => $creator->id,
        ]);

        AuditLog::create([
            'event' => 'transactions.requirement_check',
            'module' => 'transactions',
            'action' => 'requirement_check',
            'description' => 'Pass-through event',
            'office_id' => $origin->id,
            'transaction_id' => $tx->id,
            'created_at' => now(),
        ]);

        Sanctum::actingAs($admin);

        $this->getJson('/api/admin/activity?kind=all&module=transactions&action=requirement_check')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.summary', 'Pass-through event')
            ->assertJsonPath('data.0.reference_number', 'AUDIT-SCOPE-1');
    }

    public function test_activity_log_shows_names_instead_of_ids(): void
    {
        $office = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $admin = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);

        $registered = User::factory()->create(['office_id' => $office->id]);
        $registered->roles()->attach([$clerk->id, $admin->id]);

        $superadmin = $this->userWithRole('superadmin');
        Sanctum::actingAs($superadmin);

        app(AuditService::class)->log(request(), 'users.register', $registered, [
            'new' => [
                'name' => $registered->name,
                'username' => $registered->username,
                'email' => $registered->email,
                'office_id' => $office->id,
                'role_ids' => [$clerk->id, $admin->id],
            ],
        ]);

        $summary = $this->getJson('/api/admin/activity?kind=setup&module=users&action=register')
            ->assertOk()
            ->json('data.0.summary');

        $this->assertStringContainsString('office: CSD — Computer Service Division', $summary);
        $this->assertStringContainsString('roles: Clerk, Admin', $summary);
        $this->assertStringNotContainsString('office_id', $summary);
        $this->assertStringNotContainsString('role_ids', $summary);
        $this->assertStringNotContainsString('[17]', $summary);
    }

    public function test_activity_log_surfaces_data_changes(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $role = Role::create([
            'code' => 'auditor2',
            'name' => 'Auditor Two',
            'description' => 'Before',
        ]);

        Sanctum::actingAs($superadmin);

        $this->putJson("/api/admin/roles/{$role->id}", [
            'code' => 'auditor2',
            'name' => 'Auditor Two',
            'description' => 'After',
        ])->assertOk();

        $this->getJson('/api/admin/activity?kind=setup&module=roles&action=update')
            ->assertOk()
            ->assertJsonPath('data.0.module', 'roles')
            ->assertJsonPath('data.0.action_key', 'update')
            ->assertJsonPath('data.0.actor.name', $superadmin->name)
            ->assertJsonPath('data.0.changes.old.description', 'Before')
            ->assertJsonPath('data.0.changes.new.description', 'After');
    }
}
