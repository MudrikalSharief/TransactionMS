<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Transaction types: the list is a shared lookup filtered to the user's own
 * office (unrestricted types stay visible to everyone); writes are limited
 * to superadmin or office admins (admin role + office), and office admins
 * can only touch types assigned to their office.
 */
class TransactionTypeOfficeAccessTest extends TestCase
{
    use RefreshDatabase;

    private Office $gso;
    private Office $cbo;
    private TransactionType $gsoType;
    private TransactionType $cboType;

    protected function setUp(): void
    {
        parent::setUp();

        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->cbo = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);

        TransactionType::create(['code' => 'any', 'name' => 'Anyone']);

        $this->gsoType = TransactionType::create(['code' => 'gso_only', 'name' => 'GSO only']);
        $this->gsoType->offices()->sync([$this->gso->id]);

        $this->cboType = TransactionType::create(['code' => 'cbo_only', 'name' => 'CBO only']);
        $this->cboType->offices()->sync([$this->cbo->id]);
    }

    private function userWithRole(string $roleCode, ?Office $office = null): User
    {
        $role = Role::firstOrCreate(['code' => $roleCode], ['name' => ucfirst($roleCode)]);
        $user = User::factory()->create(['office_id' => $office?->id]);
        $user->roles()->attach($role->id);

        return $user;
    }

    private function indexCodes(User $user): array
    {
        Sanctum::actingAs($user);

        return collect($this->getJson('/api/admin/transaction-types')->assertOk()->json('data'))
            ->pluck('code')
            ->sort()
            ->values()
            ->all();
    }

    public function test_index_shows_unrestricted_and_own_office_types_only(): void
    {
        $this->assertSame(
            ['any', 'gso_only'],
            $this->indexCodes($this->userWithRole('clerk', $this->gso))
        );
    }

    public function test_office_less_user_sees_only_unrestricted_types(): void
    {
        $this->assertSame(['any'], $this->indexCodes($this->userWithRole('clerk')));
    }

    public function test_superadmin_sees_every_type(): void
    {
        $this->assertSame(
            ['any', 'cbo_only', 'gso_only'],
            $this->indexCodes($this->userWithRole('superadmin'))
        );
    }

    public function test_office_admin_created_types_always_include_their_office(): void
    {
        $admin = $this->userWithRole('admin', $this->gso);
        Sanctum::actingAs($admin);

        $this->postJson('/api/admin/transaction-types', [
            'code' => 'gso_new',
            'name' => 'GSO New',
            'office_ids' => [],
        ])->assertCreated()->assertJsonPath('data.office_ids', [$this->gso->id]);

        $created = $this->postJson('/api/admin/transaction-types', [
            'code' => 'gso_shared',
            'name' => 'GSO Shared',
            'office_ids' => [$this->cbo->id],
        ])->assertCreated();

        $this->assertEqualsCanonicalizing(
            [$this->gso->id, $this->cbo->id],
            $created->json('data.office_ids')
        );
    }

    public function test_office_admin_can_update_and_delete_own_office_type(): void
    {
        $admin = $this->userWithRole('admin', $this->gso);
        Sanctum::actingAs($admin);

        $this->putJson("/api/admin/transaction-types/{$this->gsoType->id}", [
            'code' => 'gso_only',
            'name' => 'Renamed by GSO admin',
        ])->assertOk()->assertJsonPath('data.name', 'Renamed by GSO admin');

        $this->deleteJson("/api/admin/transaction-types/{$this->gsoType->id}")->assertOk();
        $this->assertSoftDeleted($this->gsoType);
    }

    public function test_office_admin_cannot_touch_other_offices_types(): void
    {
        $admin = $this->userWithRole('admin', $this->gso);
        Sanctum::actingAs($admin);

        $this->putJson("/api/admin/transaction-types/{$this->cboType->id}", [
            'code' => 'cbo_only',
            'name' => 'Hijacked',
        ])->assertForbidden();

        $this->deleteJson("/api/admin/transaction-types/{$this->cboType->id}")->assertForbidden();
    }

    public function test_non_office_admin_cannot_write_types(): void
    {
        $clerk = $this->userWithRole('clerk', $this->gso);
        Sanctum::actingAs($clerk);

        $this->postJson('/api/admin/transaction-types', [
            'code' => 'sneaky',
            'name' => 'Sneaky',
        ])->assertForbidden();

        $this->putJson("/api/admin/transaction-types/{$this->gsoType->id}", [
            'code' => 'gso_only',
            'name' => 'Nope',
        ])->assertForbidden();

        $this->deleteJson("/api/admin/transaction-types/{$this->gsoType->id}")->assertForbidden();
    }

    public function test_index_includes_ordered_steps_of_the_live_workflow(): void
    {
        // Older published version must lose to the live-flagged one.
        $older = WorkflowDefinition::create([
            'transaction_type_id' => $this->gsoType->id,
            'version' => 1,
            'status' => 'published',
            'is_live' => false,
            'name' => 'Old published',
        ]);
        WorkflowStep::create([
            'workflow_definition_id' => $older->id,
            'order_number' => 1,
            'code' => 'old_step',
            'name' => 'Old step',
        ]);

        $live = WorkflowDefinition::create([
            'transaction_type_id' => $this->gsoType->id,
            'version' => 2,
            'status' => 'published',
            'is_live' => true,
            'name' => 'Live',
        ]);
        $second = WorkflowStep::create([
            'workflow_definition_id' => $live->id,
            'order_number' => 2,
            'code' => 'second',
            'name' => 'Second step',
        ]);
        $second->roles()->attach(
            Role::firstOrCreate(['code' => 'end_user'], ['name' => 'End User'])->id
        );
        WorkflowStep::create([
            'workflow_definition_id' => $live->id,
            'order_number' => 1,
            'code' => 'first',
            'name' => 'First step',
            'office_id' => $this->gso->id,
            'is_start' => true,
        ]);

        Sanctum::actingAs($this->userWithRole('superadmin'));

        // The lookup is cached for 10 min; make this test see the rows it
        // just created instead of a previous test's cached collection.
        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types:v3');

        $rows = collect($this->getJson('/api/admin/transaction-types')->assertOk()->json('data'));
        $row = $rows->firstWhere('id', $this->gsoType->id);

        $this->assertSame(
            ['First step', 'Second step'],
            collect($row['workflow_steps'])->pluck('name')->all()
        );
        $this->assertSame($this->gso->code, $row['workflow_steps'][0]['office']['code']);
        $this->assertTrue($row['workflow_steps'][0]['is_start']);
        $this->assertFalse($row['workflow_steps'][0]['is_end_user']);
        $this->assertTrue($row['workflow_steps'][1]['is_end_user']);

        // A type with no published workflow still returns a list (empty).
        $any = $rows->firstWhere('code', 'any');
        $this->assertSame([], $any['workflow_steps']);
    }
}
