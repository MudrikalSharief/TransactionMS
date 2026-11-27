<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class SwitchRoleTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->withHeader('Referer', 'http://localhost');
    }

    public function test_assigned_roles_can_be_selected_and_selection_survives_me_requests(): void
    {
        $admin = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $user = User::factory()->create();
        $user->roles()->attach([$admin->id, $clerk->id]);
        $this->actingAs($user);

        $this->getJson('/api/auth/me')->assertOk()
            ->assertJsonCount(2, 'user.available_roles')
            ->assertJsonPath('user.roles.0.code', 'admin');

        $this->putJson('/api/auth/role', ['role_id' => $clerk->id])->assertOk()
            ->assertJsonPath('user.active_role_id', $clerk->id)
            ->assertJsonPath('user.roles.0.code', 'clerk');
        $this->getJson('/api/auth/me')->assertOk()
            ->assertJsonPath('user.active_role_id', $clerk->id)
            ->assertJsonCount(2, 'user.available_roles')
            ->assertJsonCount(1, 'user.roles');
    }

    public function test_unassigned_or_removed_role_cannot_be_selected(): void
    {
        $admin = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $user = User::factory()->create();
        $user->roles()->attach($admin);
        $this->actingAs($user);

        $this->putJson('/api/auth/role', ['role_id' => $clerk->id])->assertUnprocessable();
        $this->putJson('/api/auth/role', ['role_id' => $admin->id])->assertUnprocessable();

        $user->roles()->attach($clerk);
        $this->putJson('/api/auth/role', ['role_id' => $clerk->id])->assertOk();
        $user->roles()->detach($clerk);
        $this->getJson('/api/auth/me')->assertOk()
            ->assertJsonPath('user.active_role_id', $admin->id)
            ->assertJsonCount(1, 'user.available_roles');
    }

    public function test_first_assigned_role_is_the_default_even_when_admin_was_added_later(): void
    {
        $admin = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $user = User::factory()->create();
        $user->roles()->attach($clerk->id, ['created_at' => now()->subDay()]);
        $user->roles()->attach($admin->id);
        $this->actingAs($user);

        $this->getJson('/api/auth/me')->assertOk()
            ->assertJsonPath('user.available_roles.0.id', $clerk->id)
            ->assertJsonPath('user.active_role_id', $clerk->id)
            ->assertJsonPath('user.roles.0.code', 'clerk');
    }

    public function test_login_starts_with_first_assigned_role_even_if_session_has_an_old_selection(): void
    {
        $admin = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $user = User::factory()->create([
            'password' => Hash::make('test-password'),
            'approved_at' => now(),
        ]);
        $user->roles()->attach($clerk->id, ['created_at' => now()->subDay()]);
        $user->roles()->attach($admin->id);

        $this->withSession(['active_role_id' => $admin->id])
            ->postJson('/api/auth/login', ['login' => $user->username, 'password' => 'test-password'])
            ->assertOk();
        $this->getJson('/api/auth/me')->assertOk()
            ->assertJsonPath('user.active_role_id', $clerk->id);
    }
}
