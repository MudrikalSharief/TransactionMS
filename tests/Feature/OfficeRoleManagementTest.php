<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OfficeRoleManagementTest extends TestCase
{
    use RefreshDatabase;

    private Office $csd;
    private Office $gso;
    private Role $clerk;
    private Role $adminRole;
    private Role $superRole;
    private User $admin;

    protected function setUp(): void
    {
        parent::setUp();
        $this->csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Service Office']);
        $this->clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $this->adminRole = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $this->superRole = Role::firstOrCreate(['code' => 'superadmin'], ['name' => 'Superadmin']);
        $this->admin = $this->account($this->csd, $this->adminRole);
    }

    private function account(?Office $office, Role ...$roles): User
    {
        $user = User::factory()->create(['office_id' => $office?->id, 'approved_at' => now(), 'is_active' => true]);
        $user->roles()->sync(collect($roles)->pluck('id')->all());

        return $user;
    }

    private function ownedRole(Office $office, string $code = 'csd_records'): Role
    {
        return Role::forceCreate(['code' => $code, 'name' => ucfirst($code), 'office_id' => $office->id]);
    }

    private function payload(Role $role, array $overrides = []): array
    {
        return [...$role->only(['code', 'name', 'description']), ...$overrides];
    }

    public function test_office_role_catalogue_includes_shared_and_owned_roles_with_editability(): void
    {
        $own = $this->ownedRole($this->csd);
        $other = $this->ownedRole($this->gso, 'gso_records');
        Sanctum::actingAs($this->admin);
        $data = collect($this->getJson('/api/office/roles')->assertOk()->json('data'))->keyBy('id');
        $this->assertTrue($data->has($own->id));
        $this->assertFalse($data->has($other->id));
        $this->assertFalse($data->has($this->superRole->id));
        $this->assertFalse($data[$this->clerk->id]['can_manage']);
        $this->assertFalse($data[$this->adminRole->id]['can_manage']);
        $this->assertTrue($data[$own->id]['can_manage']);
        $this->assertSame($this->csd->id, $data[$own->id]['office_id']);
        $this->assertSame('CSD', $data[$own->id]['office']['code']);
    }

    public function test_office_admin_creates_edits_deletes_and_restores_own_role_without_changing_ownership(): void
    {
        Sanctum::actingAs($this->admin);
        $created = $this->postJson('/api/office/roles', [
            'code' => 'csd_records', 'name' => 'Records Officer', 'description' => 'Receives records',
            'office_id' => $this->gso->id,
        ])->assertCreated()->assertJsonPath('data.office_id', $this->csd->id)->assertJsonPath('data.can_manage', true);
        $role = Role::findOrFail($created->json('data.id'));
        $member = $this->account($this->csd, $role);

        $this->putJson("/api/office/roles/{$role->id}", $this->payload($role, [
            'code' => 'csd_records_review', 'name' => 'Records Reviewer', 'description' => 'Reviews records',
            'office_id' => null,
        ]))->assertOk()->assertJsonPath('data.office_id', $this->csd->id)
            ->assertJsonPath('data.name', 'Records Reviewer');
        $this->deleteJson("/api/office/roles/{$role->id}")->assertOk();
        $this->assertSoftDeleted('roles', ['id' => $role->id]);
        $this->postJson('/api/office/users', [
            'name' => 'Deleted role member', 'username' => 'deleted.role.member', 'password' => 'password123',
            'role_ids' => [$role->id],
        ])->assertUnprocessable()->assertJsonValidationErrors('role_ids.0');
        $this->postJson('/api/office/roles', [
            'code' => 'csd_records_review', 'name' => 'Restored Reviewer',
        ])->assertCreated()->assertJsonPath('data.id', $role->id)->assertJsonPath('data.office_id', $this->csd->id);
        $this->assertTrue($member->fresh()->roles->contains('id', $role->id));
        foreach (['roles.create', 'roles.update', 'roles.delete', 'roles.restore'] as $event) {
            $this->assertDatabaseHas('audit_logs', [
                'event' => $event, 'entity_id' => $role->id,
                'actor_user_id' => $this->admin->id, 'office_id' => $this->csd->id,
            ]);
        }
    }

    public function test_shared_foreign_and_reserved_role_definitions_are_protected_from_office_admins(): void
    {
        $shared = Role::create(['code' => 'shared_records', 'name' => 'Shared Records']);
        $foreign = $this->ownedRole($this->gso, 'gso_records');
        Sanctum::actingAs($this->admin);
        foreach ([$shared, $foreign] as $role) {
            $this->putJson("/api/office/roles/{$role->id}", $this->payload($role, ['name' => 'Stolen']))->assertNotFound();
            $this->deleteJson("/api/office/roles/{$role->id}")->assertNotFound();
            $role->delete();
            $this->postJson('/api/office/roles', $this->payload($role))->assertUnprocessable();
            $this->assertSoftDeleted('roles', ['id' => $role->id]);
        }
        $own = $this->ownedRole($this->csd);
        foreach (['admin', 'superadmin', 'clerk', 'viewer', 'end_user'] as $code) {
            $this->postJson('/api/office/roles', ['code' => $code, 'name' => 'Privileged'])->assertUnprocessable()->assertJsonValidationErrors('code');
            $this->putJson("/api/office/roles/{$own->id}", $this->payload($own, ['code' => $code]))->assertUnprocessable()->assertJsonValidationErrors('code');
        }
        foreach ([$this->adminRole, $this->superRole] as $role) {
            $this->deleteJson("/api/office/roles/{$role->id}")->assertNotFound();
            $this->assertNotNull($role->fresh());
        }
    }

    public function test_office_user_assignment_accepts_only_shared_or_own_office_roles(): void
    {
        $own = $this->ownedRole($this->csd);
        $foreign = $this->ownedRole($this->gso, 'gso_records');
        $member = $this->account($this->csd, $this->clerk);
        $other = $this->account($this->gso, $foreign);
        Sanctum::actingAs($this->admin);
        $this->postJson('/api/office/users', [
            'name' => 'Records Member', 'username' => 'records.member', 'password' => 'password123',
            'office_id' => $this->gso->id, 'role_ids' => [$own->id, $this->adminRole->id],
        ])->assertCreated()->assertJsonPath('data.office_id', $this->csd->id);
        $this->postJson('/api/office/users', [
            'name' => 'Wrong office', 'username' => 'wrong.office', 'password' => 'password123', 'role_ids' => [$foreign->id],
        ])->assertUnprocessable()->assertJsonValidationErrors('role_ids.0');
        $this->putJson("/api/office/users/{$member->id}", [
            'name' => $member->name, 'office_id' => $this->gso->id, 'role_ids' => [$foreign->id],
        ])->assertUnprocessable()->assertJsonValidationErrors('role_ids.0');
        $this->putJson("/api/office/users/{$other->id}", ['name' => $other->name, 'role_ids' => [$own->id]])->assertNotFound();
        $this->assertTrue($member->fresh()->hasRole('clerk'));
    }

    public function test_superadmin_retains_all_role_management_and_restoration_preserves_office_scope(): void
    {
        $own = $this->ownedRole($this->csd);
        $foreign = $this->ownedRole($this->gso, 'gso_records');
        Sanctum::actingAs($this->account(null, $this->superRole));
        $data = collect($this->getJson('/api/admin/roles')->assertOk()->json('data'))->keyBy('id');
        $this->assertTrue($data[$own->id]['can_manage']);
        $this->assertTrue($data[$foreign->id]['can_manage']);
        $this->postJson('/api/admin/roles', ['code' => 'shared_review', 'name' => 'Shared Reviewer'])->assertCreated()->assertJsonPath('data.office_id', null);
        $this->putJson("/api/admin/roles/{$foreign->id}", $this->payload($foreign, ['name' => 'Renamed by Superadmin']))->assertOk();
        $this->deleteJson("/api/admin/roles/{$foreign->id}")->assertOk();
        $this->postJson('/api/admin/roles', ['code' => 'gso_records', 'name' => 'Restored by Superadmin'])
            ->assertCreated()->assertJsonPath('data.id', $foreign->id)->assertJsonPath('data.office_id', $this->gso->id);
        $this->deleteJson("/api/admin/roles/{$this->superRole->id}")->assertUnprocessable();
    }

    public function test_superadmin_account_assignment_and_transfers_respect_custom_role_ownership(): void
    {
        $own = $this->ownedRole($this->csd);
        $member = $this->account($this->csd, $own);
        Sanctum::actingAs($this->account(null, $this->superRole));
        $this->postJson('/api/admin/users', [
            'name' => 'Wrong office', 'username' => 'super.wrong.office', 'password' => 'password123',
            'office_id' => $this->gso->id, 'role_ids' => [$own->id],
        ])->assertUnprocessable()->assertJsonValidationErrors('role_ids.0');
        $this->postJson('/api/admin/users', [
            'name' => 'Right office', 'username' => 'super.right.office', 'password' => 'password123',
            'office_id' => $this->csd->id, 'role_ids' => [$own->id],
        ])->assertCreated();
        $this->putJson("/api/admin/users/{$member->id}", ['name' => $member->name, 'office_id' => $this->gso->id])
            ->assertUnprocessable()->assertJsonValidationErrors('role_ids');
        $this->assertSame($this->csd->id, $member->fresh()->office_id);
        $own->delete();
        $this->putJson("/api/admin/users/{$member->id}", ['name' => $member->name, 'office_id' => $this->gso->id])
            ->assertUnprocessable()->assertJsonValidationErrors('role_ids');
        $this->putJson("/api/admin/users/{$member->id}", [
            'name' => $member->name, 'office_id' => $this->gso->id, 'role_ids' => [$this->clerk->id],
        ])->assertOk()->assertJsonPath('data.office_id', $this->gso->id);
        $this->assertDatabaseMissing('role_user', ['user_id' => $member->id, 'role_id' => $own->id]);
    }

    public function test_registration_exposes_scope_and_rejects_roles_from_a_different_selected_office(): void
    {
        $own = $this->ownedRole($this->csd);
        $foreign = $this->ownedRole($this->gso, 'gso_records');
        $roles = collect($this->getJson('/api/auth/register/options')->assertOk()->json('roles'))->keyBy('id');
        $this->assertSame($this->csd->id, $roles[$own->id]['office_id']);
        $this->assertSame($this->gso->id, $roles[$foreign->id]['office_id']);
        $this->assertNull($roles[$this->clerk->id]['office_id']);
        $this->assertFalse($roles->has($this->adminRole->id));
        $payload = ['name' => 'Applicant', 'username' => 'records.applicant', 'contact_number' => '09171234567',
            'password' => 'password123', 'office_id' => $this->csd->id, 'role_ids' => [$foreign->id]];
        $this->postJson('/api/auth/register', $payload)->assertUnprocessable()->assertJsonValidationErrors('role_ids.0');
        $this->postJson('/api/auth/register', [...$payload, 'role_ids' => [$own->id]])->assertCreated();
        $this->assertDatabaseHas('users', ['username' => 'records.applicant', 'office_id' => $this->csd->id, 'approved_at' => null]);
    }

    public function test_regular_staff_cannot_manage_role_definitions(): void
    {
        $role = $this->ownedRole($this->csd);
        Sanctum::actingAs($this->account($this->csd, $this->clerk));
        $this->getJson('/api/office/roles')->assertForbidden();
        $this->postJson('/api/office/roles', ['code' => 'unauthorized', 'name' => 'Unauthorized'])->assertForbidden();
        $this->putJson("/api/office/roles/{$role->id}", $this->payload($role))->assertForbidden();
        $this->deleteJson("/api/office/roles/{$role->id}")->assertForbidden();
    }

    public function test_office_deletion_removes_active_and_deleted_owned_roles_but_preserves_shared_roles(): void
    {
        $active = $this->ownedRole($this->csd);
        $deleted = $this->ownedRole($this->csd, 'csd_deleted_records');
        $member = $this->account($this->csd, $this->clerk, $active, $deleted);
        $foreign = $this->ownedRole($this->gso, 'gso_records');
        $other = $this->account($this->gso, $foreign);
        $deleted->delete();
        Sanctum::actingAs($this->account(null, $this->superRole));

        $this->deleteJson("/api/admin/offices/{$this->csd->id}")->assertOk();
        $this->assertNull($member->fresh()->office_id);
        $this->assertTrue($member->fresh()->hasRole('clerk'));
        foreach ([$active, $deleted] as $role) {
            $this->assertDatabaseMissing('role_user', ['user_id' => $member->id, 'role_id' => $role->id]);
            $this->assertSame($this->csd->id, $role->fresh()->office_id);
        }
        $this->assertSame($this->gso->id, $other->fresh()->office_id);
        $this->assertTrue($other->fresh()->hasRole('gso_records'));
    }
}
