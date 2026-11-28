<?php

namespace Tests\Feature;

use App\Models\AuditLog;
use App\Models\Office;
use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ViewerTrackingPrivacyTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $step;

    protected function setUp(): void
    {
        parent::setUp();

        $this->office = Office::create([
            'code' => 'GSO',
            'name' => 'General Services Office',
        ]);

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

    private function makeTransaction(
        User $creator,
        string $reference,
        bool $isPrivate = false,
    ): Transaction {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'office_id' => $this->office->id,
            'reference_number' => $reference,
            'title' => 'Test request',
            'is_done' => false,
            'is_private' => $isPrivate,
            'created_by' => $creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $this->step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    public function test_superadmin_can_toggle_track_privacy_and_it_is_audited(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'PRIVACY-TOGGLE-1',
        );

        Sanctum::actingAs($superadmin);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => true,
        ])
            ->assertOk()
            ->assertJsonPath('data.is_private', true)
            ->assertJsonPath('message', 'Transaction is now private (hidden from Track search).');

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => true,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.privacy',
            'entity_type' => 'transaction',
            'entity_id' => $tx->id,
        ]);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => false,
        ])
            ->assertOk()
            ->assertJsonPath('data.is_private', false)
            ->assertJsonPath('message', 'Transaction is now public (searchable on Track).');

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => false,
        ]);
    }

    public function test_office_admin_can_toggle_track_privacy_in_their_scope(): void
    {
        $officeAdmin = $this->userWithRole('admin', $this->office);
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'PRIVACY-TOGGLE-2',
        );

        Sanctum::actingAs($officeAdmin);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => true,
        ])
            ->assertOk()
            ->assertJsonPath('data.is_private', true);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => true,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.privacy',
            'entity_type' => 'transaction',
            'entity_id' => $tx->id,
        ]);
    }

    public function test_office_admin_cannot_toggle_another_offices_track_privacy(): void
    {
        $otherOffice = Office::create([
            'code' => 'CBO',
            'name' => 'City Budget Office',
        ]);
        $otherAdmin = $this->userWithRole('admin', $otherOffice);
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'PRIVACY-TOGGLE-3',
        );

        Sanctum::actingAs($otherAdmin);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => true,
        ])->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => false,
        ]);
    }

    public function test_staff_cannot_toggle_track_privacy(): void
    {
        $clerk = $this->userWithRole('clerk', $this->office);
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'PRIVACY-TOGGLE-4',
        );

        Sanctum::actingAs($clerk);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => true,
        ])->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => false,
        ]);
    }

    public function test_archived_public_transaction_is_visible_in_track_search_and_detail(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-ARCHIVED-SHARED-1',
            false,
        );
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-ARCHIVED-SHARED-1')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $tx->id);

        $this->getJson("/api/viewer/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('data.id', $tx->id);
    }

    public function test_archived_private_transaction_is_hidden_even_from_its_creator(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction($viewer, 'TRACK-ARCHIVED-OWN-1', true);
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $this->getJson('/api/viewer/transactions?q=TRACK-ARCHIVED-OWN-1')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $this->getJson("/api/viewer/transactions/{$tx->id}")
            ->assertNotFound();
    }

    public function test_public_transactions_are_searchable_on_track(): void
    {
        $viewer = $this->userWithRole('viewer');
        $creator = User::factory()->create();
        $public = $this->makeTransaction($creator, 'TRACK-PUBLIC-1', false);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-PUBLIC-1')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $public->id);
    }

    public function test_private_transactions_are_hidden_from_other_viewers(): void
    {
        $viewer = $this->userWithRole('viewer');
        $creator = User::factory()->create();
        $this->makeTransaction($creator, 'TRACK-HIDDEN-1', true);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-HIDDEN-1')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_viewer_cannot_search_or_open_their_own_private_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $own = $this->makeTransaction($viewer, 'TRACK-OWN-1', true);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-OWN-1')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        $this->getJson("/api/viewer/transactions/{$own->id}")
            ->assertNotFound();
    }

    public function test_archived_transaction_can_be_made_public_and_filtered_in_archive_history(): void
    {
        $admin = $this->userWithRole('superadmin');
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(User::factory()->create(), 'TRACK-ARCHIVE-TOGGLE-1', true);
        $tx->update(['is_archive' => true]);

        Sanctum::actingAs($admin);
        $this->getJson('/api/admin/transactions/archive?access=private')
            ->assertOk()
            ->assertJsonFragment(['id' => $tx->id, 'is_private' => true]);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", ['is_private' => false])
            ->assertOk()
            ->assertJsonPath('data.is_private', false);

        $this->getJson('/api/admin/transactions/archive?access=public')
            ->assertOk()
            ->assertJsonFragment(['id' => $tx->id, 'is_private' => false]);
        $this->getJson('/api/admin/transactions/archive?access=private')
            ->assertOk()
            ->assertJsonCount(0, 'data');

        Sanctum::actingAs($viewer);
        $this->getJson('/api/viewer/transactions?q=TRACK-ARCHIVE-TOGGLE-1')
            ->assertOk()
            ->assertJsonPath('data.0.id', $tx->id);
    }

    public function test_viewer_cannot_open_another_viewers_private_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-SHOW-HIDDEN-1',
            true,
        );

        Sanctum::actingAs($viewer);

        $this->getJson("/api/viewer/transactions/{$tx->id}")
            ->assertNotFound();
    }

    public function test_viewer_can_open_a_public_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-SHOW-PRIVATE-1',
            false,
        );

        Sanctum::actingAs($viewer);

        $this->getJson("/api/viewer/transactions/{$tx->id}")
            ->assertOk()
            ->assertJsonPath('data.id', $tx->id);
    }

    public function test_is_private_is_exposed_in_admin_resources(): void
    {
        $superadmin = $this->userWithRole('superadmin');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-RESOURCE-1',
            true,
        );

        Sanctum::actingAs($superadmin);

        $this->getJson('/api/admin/transactions')
            ->assertOk()
            ->assertJsonFragment([
                'id' => $tx->id,
                'is_private' => true,
            ]);
    }

    public function test_admin_can_change_privacy_of_multiple_current_and_archived_transactions(): void
    {
        $admin = $this->userWithRole('admin', $this->office);
        $current = $this->makeTransaction(User::factory()->create(), 'BULK-CURRENT-1', true);
        $archived = $this->makeTransaction(User::factory()->create(), 'BULK-ARCHIVED-1', true);
        $archived->update(['is_archive' => true]);

        Sanctum::actingAs($admin);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$current->id, $archived->id],
            'action' => 'privacy',
            'is_private' => false,
        ])->assertOk()->assertJsonPath('data.updated', 2);

        $this->assertDatabaseHas('transactions', ['id' => $current->id, 'is_private' => false]);
        $this->assertDatabaseHas('transactions', ['id' => $archived->id, 'is_private' => false]);
        $this->assertSame(2, AuditLog::where('event', 'transactions.privacy')->count());
    }

    public function test_bulk_archive_moves_current_transactions_to_history_without_deleting_them(): void
    {
        $admin = $this->userWithRole('admin', $this->office);
        $first = $this->makeTransaction(User::factory()->create(), 'BULK-ARCHIVE-1');
        $second = $this->makeTransaction(User::factory()->create(), 'BULK-ARCHIVE-2');

        Sanctum::actingAs($admin);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id, $second->id],
            'action' => 'archive',
        ])->assertOk()->assertJsonPath('data.archived', 2);

        $this->assertDatabaseHas('transactions', ['id' => $first->id, 'is_archive' => true, 'deleted_at' => null]);
        $this->assertDatabaseHas('transactions', ['id' => $second->id, 'is_archive' => true, 'deleted_at' => null]);
        $this->assertDatabaseHas('transaction_states', ['transaction_id' => $first->id]);
        $this->assertSame(2, AuditLog::where('event', 'transactions.archive')->count());
    }

    public function test_bulk_unarchive_restores_archived_transactions(): void
    {
        $admin = $this->userWithRole('admin', $this->office);
        $first = $this->makeTransaction(User::factory()->create(), 'BULK-RESTORE-1');
        $second = $this->makeTransaction(User::factory()->create(), 'BULK-RESTORE-2');
        $first->update(['is_archive' => true]);
        $second->update(['is_archive' => true]);

        Sanctum::actingAs($admin);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id, $second->id],
            'action' => 'unarchive',
        ])->assertOk()->assertJsonPath('data.unarchived', 2);

        $this->assertDatabaseHas('transactions', ['id' => $first->id, 'is_archive' => false]);
        $this->assertDatabaseHas('transactions', ['id' => $second->id, 'is_archive' => false]);
        $this->assertSame(2, AuditLog::where('event', 'transactions.unarchive')->count());
    }

    public function test_bulk_action_rejects_out_of_scope_ids_without_changing_any_row(): void
    {
        $otherOffice = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);
        $admin = $this->userWithRole('admin', $otherOffice);
        $allowed = $this->makeTransaction(User::factory()->create(), 'BULK-ALLOWED-1', true);
        $allowed->update(['office_id' => $otherOffice->id]);
        $denied = $this->makeTransaction(User::factory()->create(), 'BULK-DENIED-1', true);

        Sanctum::actingAs($admin);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$allowed->id, $denied->id],
            'action' => 'privacy',
            'is_private' => false,
        ])->assertForbidden();

        $this->assertDatabaseHas('transactions', ['id' => $allowed->id, 'is_private' => true]);
        $this->assertDatabaseHas('transactions', ['id' => $denied->id, 'is_private' => true]);
    }

    public function test_bulk_action_requires_two_distinct_rows_and_admin_role(): void
    {
        $clerk = $this->userWithRole('clerk', $this->office);
        $admin = $this->userWithRole('admin', $this->office);
        $first = $this->makeTransaction(User::factory()->create(), 'BULK-VALIDATE-1');
        $second = $this->makeTransaction(User::factory()->create(), 'BULK-VALIDATE-2');

        Sanctum::actingAs($clerk);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id, $second->id],
            'action' => 'archive',
        ])->assertForbidden();

        Sanctum::actingAs($admin);
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id],
            'action' => 'archive',
        ])->assertUnprocessable();
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id, $first->id],
            'action' => 'archive',
        ])->assertUnprocessable();
        $this->postJson('/api/admin/transactions/bulk', [
            'ids' => [$first->id, $second->id],
            'action' => 'delete',
        ])->assertUnprocessable();
        $this->assertDatabaseHas('transactions', ['id' => $first->id, 'is_archive' => false, 'deleted_at' => null]);
    }
}
