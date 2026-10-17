<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Database\Seeders\PermissionsSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Permission system: superadmin always passes; other roles only after the
 * Roles page grants them the Admin checklist (every module permission, with
 * manage implying view). The Roles index orders superadmin, admin, then the
 * rest in seed order.
 */
class PermissionsTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(PermissionsSeeder::class);
    }

    private function userWithRole(string $code, string $name = ''): User
    {
        $user = User::factory()->create();
        $user->roles()->attach(
            Role::firstOrCreate(['code' => $code], ['name' => $name !== '' ? $name : ucfirst($code)])->id
        );

        return $user;
    }

    public function test_superadmin_can_access_admin_routes_without_grants(): void
    {
        Sanctum::actingAs($this->userWithRole('superadmin', 'Super Admin'));

        $this->getJson('/api/admin/users')->assertOk();
        $this->getJson('/api/admin/roles')->assertOk();
        $this->getJson('/api/admin/dashboard/summary')->assertOk();
    }

    public function test_role_without_permissions_is_blocked(): void
    {
        Sanctum::actingAs($this->userWithRole('clerk'));

        $this->getJson('/api/admin/users')->assertForbidden();
        $this->getJson('/api/admin/roles')->assertForbidden();
        $this->getJson('/api/admin/dashboard/summary')->assertForbidden();
    }

    public function test_granting_admin_checklist_unlocks_admin_modules(): void
    {
        $super = $this->userWithRole('superadmin', 'Super Admin');
        $adminRole = Role::create(['code' => 'admin', 'name' => 'Admin']);
        $adminUser = User::factory()->create();
        $adminUser->roles()->attach($adminRole->id);

        $codes = \App\Models\Permission::query()->pluck('code')->all();

        Sanctum::actingAs($super);
        $this->putJson("/api/admin/roles/{$adminRole->id}/permissions", ['permission_codes' => $codes])
            ->assertOk();

        Sanctum::actingAs($adminUser);
        $this->getJson('/api/admin/users')->assertOk();
        $this->getJson('/api/admin/roles')->assertOk();
        $this->getJson('/api/admin/offices')->assertOk();
        $this->getJson('/api/admin/dashboard/summary')->assertOk();

        // /me carries the flat permission list the UI gates on.
        $this->getJson('/api/auth/me')
            ->assertOk()
            ->assertJsonPath('user.permissions', collect($codes)->sort()->values()->all());
    }

    public function test_manage_grant_implies_view(): void
    {
        $super = $this->userWithRole('superadmin', 'Super Admin');
        $role = Role::create(['code' => 'auditor', 'name' => 'Auditor']);

        Sanctum::actingAs($super);
        $this->putJson("/api/admin/roles/{$role->id}/permissions", [
            'permission_codes' => ['users.manage'],
        ])->assertOk();

        $role->refresh()->load('permissions');
        $this->assertEqualsCanonicalizing(
            ['users.view', 'users.manage'],
            $role->permissions->pluck('code')->all()
        );

        $user = User::factory()->create();
        $user->roles()->attach($role->id);
        Sanctum::actingAs($user);
        $this->getJson('/api/admin/users')->assertOk();
    }

    public function test_superadmin_permissions_cannot_be_changed(): void
    {
        Sanctum::actingAs($this->userWithRole('superadmin', 'Super Admin'));
        $superRole = Role::where('code', 'superadmin')->firstOrFail();

        $this->putJson("/api/admin/roles/{$superRole->id}/permissions", ['permission_codes' => []])
            ->assertStatus(422);
    }

    public function test_roles_index_orders_superadmin_then_admin_then_seed_order(): void
    {
        // Created out of hierarchy order to prove the sort, not the ids.
        Role::create(['code' => 'clerk', 'name' => 'Clerk']);
        Role::create(['code' => 'admin', 'name' => 'Admin']);
        Role::create(['code' => 'superadmin', 'name' => 'Super Admin']);
        Role::create(['code' => 'approver', 'name' => 'Approver']);

        Sanctum::actingAs($this->userWithRole('superadmin', 'Super Admin'));

        $codes = collect($this->getJson('/api/admin/roles')->assertOk()->json('data'))
            ->pluck('code')
            ->all();

        $this->assertSame(['superadmin', 'admin', 'clerk', 'approver'], $codes);
    }

    public function test_guest_is_rejected(): void
    {
        $this->getJson('/api/admin/users')->assertUnauthorized();
    }
}
