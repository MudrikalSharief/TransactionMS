<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Admin area is role-gated: superadmin reaches every /api/admin route;
 * office admins (admin role + office) only reach Transaction Types and the
 * dashboard summary; everyone else is blocked. Guests are unauthorized.
 */
class AdminRoleAccessTest extends TestCase
{
    use RefreshDatabase;

    private function userWithRole(string $code, ?Office $office = null): User
    {
        $user = User::factory()->create(['office_id' => $office?->id]);
        $user->roles()->attach(
            Role::firstOrCreate(['code' => $code], ['name' => ucfirst($code)])->id
        );

        return $user;
    }

    public function test_superadmin_can_access_admin_routes(): void
    {
        Sanctum::actingAs($this->userWithRole('superadmin'));

        $this->getJson('/api/admin/users')->assertOk();
        $this->getJson('/api/admin/roles')->assertOk();
        $this->getJson('/api/admin/offices')->assertOk();
        $this->getJson('/api/admin/transaction-types')->assertOk();
        $this->getJson('/api/admin/dashboard/summary')->assertOk();
    }

    public function test_regular_user_is_blocked_from_master_data(): void
    {
        Sanctum::actingAs($this->userWithRole('clerk'));

        $this->getJson('/api/admin/users')->assertForbidden();
        $this->getJson('/api/admin/roles')->assertForbidden();
        $this->getJson('/api/admin/offices')->assertForbidden();
        $this->getJson('/api/admin/dashboard/summary')->assertForbidden();
    }

    public function test_office_admin_reaches_transaction_types_and_summary_only(): void
    {
        $office = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        Sanctum::actingAs($this->userWithRole('admin', $office));

        $this->getJson('/api/admin/transaction-types')->assertOk();
        $this->getJson('/api/admin/dashboard/summary')->assertOk();
        $this->getJson('/api/admin/users')->assertForbidden();
        $this->getJson('/api/admin/roles')->assertForbidden();
        $this->getJson('/api/admin/offices')->assertForbidden();
    }

    public function test_admin_role_without_office_is_blocked_from_writes(): void
    {
        TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);

        Sanctum::actingAs($this->userWithRole('admin'));

        $this->postJson('/api/admin/transaction-types', [
            'code' => 'new_type',
            'name' => 'New Type',
        ])->assertForbidden();
        $this->getJson('/api/admin/dashboard/summary')->assertForbidden();
    }

    public function test_roles_index_orders_superadmin_then_admin_then_seed_order(): void
    {
        // Created out of hierarchy order to prove the sort, not the ids.
        Role::create(['code' => 'clerk', 'name' => 'Clerk']);
        Role::create(['code' => 'admin', 'name' => 'Admin']);
        Role::create(['code' => 'superadmin', 'name' => 'Super Admin']);
        Role::create(['code' => 'approver', 'name' => 'Approver']);

        Sanctum::actingAs($this->userWithRole('superadmin'));

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
