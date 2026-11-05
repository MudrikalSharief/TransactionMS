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

    public function test_superadmin_can_toggle_track_visibility_and_it_is_audited(): void
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
            ->assertJsonPath('data.is_private', true);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => true,
        ]);

        $this->assertDatabaseHas('audit_logs', [
            'event' => 'transactions.privacy',
            'entity_type' => Transaction::class,
            'entity_id' => $tx->id,
        ]);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => false,
        ])
            ->assertOk()
            ->assertJsonPath('data.is_private', false);

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => false,
        ]);
    }

    public function test_non_superadmin_cannot_toggle_track_visibility(): void
    {
        $officeAdmin = $this->userWithRole('admin', $this->office);
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'PRIVACY-TOGGLE-2',
        );

        Sanctum::actingAs($officeAdmin);

        $this->patchJson("/api/admin/transactions/{$tx->id}/privacy", [
            'is_private' => true,
        ])->assertForbidden();

        $this->assertDatabaseHas('transactions', [
            'id' => $tx->id,
            'is_private' => false,
        ]);
    }

    public function test_private_transactions_are_searchable_on_track(): void
    {
        $viewer = $this->userWithRole('viewer');
        $creator = User::factory()->create();
        $private = $this->makeTransaction($creator, 'TRACK-PRIVATE-1', true);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-PRIVATE-1')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $private->id);
    }

    public function test_non_private_transactions_are_hidden_from_other_viewers(): void
    {
        $viewer = $this->userWithRole('viewer');
        $creator = User::factory()->create();
        $this->makeTransaction($creator, 'TRACK-HIDDEN-1', false);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-HIDDEN-1')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_viewer_can_still_search_their_own_non_private_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $own = $this->makeTransaction($viewer, 'TRACK-OWN-1', false);

        Sanctum::actingAs($viewer);

        $this->getJson('/api/viewer/transactions?q=TRACK-OWN-1')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $own->id);
    }

    public function test_viewer_cannot_open_another_viewers_non_private_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-SHOW-HIDDEN-1',
            false,
        );

        Sanctum::actingAs($viewer);

        $this->getJson("/api/viewer/transactions/{$tx->id}")
            ->assertNotFound();
    }

    public function test_viewer_can_open_a_private_transaction(): void
    {
        $viewer = $this->userWithRole('viewer');
        $tx = $this->makeTransaction(
            User::factory()->create(),
            'TRACK-SHOW-PRIVATE-1',
            true,
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
}
