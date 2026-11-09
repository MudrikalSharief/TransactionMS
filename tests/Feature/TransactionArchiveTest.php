<?php

namespace Tests\Feature;

use App\Models\AuditLog;
use App\Models\Office;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TransactionArchiveTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private Role $clerkRole;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $step;
    private User $creator;

    protected function setUp(): void
    {
        parent::setUp();

        $this->office = Office::create([
            'code' => 'GSO',
            'name' => 'General Services Office',
        ]);

        $this->clerkRole = Role::firstOrCreate(
            ['code' => 'clerk'],
            ['name' => 'Clerk']
        );

        $this->type = TransactionType::create([
            'code' => 'pr',
            'name' => 'Purchase Request',
        ]);

        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'gso_process',
            'name' => 'GSO Processing',
            'is_start' => true,
            'office_id' => $this->office->id,
        ]);

        StepRole::create([
            'workflow_step_id' => $this->step->id,
            'role_id' => $this->clerkRole->id,
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
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Test request',
            'is_done' => false,
            'created_by' => $this->creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $this->step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    public function test_superadmin_can_archive_a_transaction_and_it_is_audited(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();

        Sanctum::actingAs($superadmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertOk()
            ->assertJsonPath('data.is_archive', true);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => true,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.archive',
            'entity_type' => 'transaction',
            'entity_id' => $tx->id,
        ]);
    }

    public function test_office_admin_can_archive_a_transaction_in_their_scope(): void
    {
        $officeAdmin = $this->userWithRole('admin', $this->office);
        $tx = $this->makeTransaction();

        Sanctum::actingAs($officeAdmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertOk()
            ->assertJsonPath('data.is_archive', true);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => true,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.archive',
            'entity_type' => 'transaction',
            'entity_id' => $tx->id,
        ]);
    }

    public function test_office_admin_cannot_archive_another_offices_transaction(): void
    {
        $otherOffice = Office::create([
            'code' => 'CBO',
            'name' => 'City Budget Office',
        ]);
        $otherAdmin = $this->userWithRole('admin', $otherOffice);
        $tx = $this->makeTransaction();

        Sanctum::actingAs($otherAdmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => false,
        ]);
    }

    public function test_staff_cannot_archive_a_transaction(): void
    {
        $clerk = $this->userWithRole('clerk', $this->office);
        $tx = $this->makeTransaction();

        Sanctum::actingAs($clerk);

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => false,
        ]);
    }

    public function test_archived_transactions_are_hidden_from_active_list_and_shown_in_archive(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $active = $this->makeTransaction();
        $archived = $this->makeTransaction();
        $archived->update(['is_archive' => true]);

        Sanctum::actingAs($superadmin);

        $activeIds = collect(
            $this->getJson('/api/admin/transactions')->assertOk()->json('data')
        )->pluck('id')->all();

        $this->assertSame([$active->id], $activeIds);

        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $archived->id)
            ->assertJsonPath('data.0.is_archive', true);
    }

    public function test_office_admin_archive_list_is_scoped_to_their_office(): void
    {
        $otherOffice = Office::create([
            'code' => 'CBO',
            'name' => 'City Budget Office',
        ]);
        $archived = $this->makeTransaction();
        $archived->update(['is_archive' => true]);

        $otherAdmin = $this->userWithRole('admin', $otherOffice);
        Sanctum::actingAs($otherAdmin);
        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $officeAdmin = $this->userWithRole('admin', $this->office);
        Sanctum::actingAs($officeAdmin);
        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $archived->id);
    }

    public function test_staff_can_view_only_archived_transactions_in_their_visibility(): void
    {
        $archived = $this->makeTransaction();
        $archived->update(['is_archive' => true]);
        $this->makeTransaction();

        $clerk = $this->userWithRole('clerk', $this->office);
        Sanctum::actingAs($clerk);

        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $archived->id)
            ->assertJsonPath('data.0.is_archive', true);

        // Staff still cannot change the archive.
        $this->postJson("/api/admin/transactions/{$archived->id}/unarchive")
            ->assertForbidden();

        // Another office's staff do not see this row.
        $otherOffice = Office::create([
            'code' => 'CBO',
            'name' => 'City Budget Office',
        ]);
        $otherClerk = $this->userWithRole('clerk', $otherOffice);
        Sanctum::actingAs($otherClerk);

        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_archived_transaction_is_view_only(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($superadmin);

        $this->getJson("/api/admin/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonCount(0, 'meta.available_actions');

        $this->postJson("/api/admin/transactions/{$tx->id}/receive")
            ->assertStatus(422)
            ->assertJsonPath('message', 'Transaction is archived and view-only.');
    }

    public function test_archived_transactions_are_hidden_from_staff_lists(): void
    {
        $clerk = $this->userWithRole('clerk', $this->office);
        $tx = $this->makeTransaction();
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($clerk);

        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $this->getJson('/api/admin/transactions')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_archiving_is_idempotent(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();

        Sanctum::actingAs($superadmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertOk()
            ->assertJsonPath('message', 'Transaction archived.');

        $this->postJson("/api/admin/transactions/{$tx->id}/archive")
            ->assertOk()
            ->assertJsonPath('message', 'Transaction is already archived.');

        $this->assertSame(
            1,
            AuditLog::where('event', 'transactions.archive')
                ->where('entity_id', $tx->id)
                ->count()
        );
    }

    public function test_superadmin_can_unarchive_a_transaction_and_it_returns_to_active_list(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($superadmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/unarchive")
            ->assertOk()
            ->assertJsonPath('data.is_archive', false);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => false,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.unarchive',
            'entity_type' => 'transaction',
            'entity_id' => $tx->id,
        ]);

        $activeIds = collect(
            $this->getJson('/api/admin/transactions')->assertOk()->json('data')
        )->pluck('id')->all();

        $this->assertContains($tx->id, $activeIds);

        $this->getJson('/api/admin/transactions/archive')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_office_admin_can_unarchive_a_transaction_in_their_scope(): void
    {
        $officeAdmin = $this->userWithRole('admin', $this->office);
        $tx = $this->makeTransaction();
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($officeAdmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/unarchive")
            ->assertOk()
            ->assertJsonPath('data.is_archive', false);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => false,
        ]);
    }

    public function test_office_admin_cannot_unarchive_another_offices_transaction(): void
    {
        $otherOffice = Office::create([
            'code' => 'CBO',
            'name' => 'City Budget Office',
        ]);
        $otherAdmin = $this->userWithRole('admin', $otherOffice);
        $tx = $this->makeTransaction();
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($otherAdmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/unarchive")
            ->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_archive' => true,
        ]);
    }

    public function test_unarchiving_is_idempotent(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction();

        Sanctum::actingAs($superadmin);

        $this->postJson("/api/admin/transactions/{$tx->id}/unarchive")
            ->assertOk()
            ->assertJsonPath('message', 'Transaction is already active.');

        $this->assertSame(
            0,
            AuditLog::where('event', 'transactions.unarchive')
                ->where('entity_id', $tx->id)
                ->count()
        );
    }
}
