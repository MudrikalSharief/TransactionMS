<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use Database\Seeders\PermissionsSeeder;
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

        $this->seed(PermissionsSeeder::class);

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
}
