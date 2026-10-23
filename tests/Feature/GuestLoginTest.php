<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class GuestLoginTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        // Same-site request, as from the SPA: Sanctum then starts a session.
        $this->withHeader('Referer', 'http://localhost');
    }

    public function test_guest_account_is_created_on_first_use(): void
    {
        $this->postJson('/api/auth/guest')
            ->assertOk()
            ->assertJsonPath('user.email', config('auth.guest_email'));

        $guest = User::where('email', config('auth.guest_email'))->firstOrFail();
        $this->assertTrue($guest->is_active);
        $this->assertTrue($guest->isViewerOnly());
        $this->assertAuthenticatedAs($guest, 'web');
    }

    public function test_existing_guest_account_is_reused(): void
    {
        $viewer = Role::create(['code' => 'viewer', 'name' => 'Viewer']);
        $guest = User::factory()->create(['email' => config('auth.guest_email'), 'is_active' => true]);
        $guest->roles()->attach($viewer->id);

        $this->postJson('/api/auth/guest')->assertOk()->assertJsonPath('user.id', $guest->id);
        $this->assertSame(1, User::where('email', config('auth.guest_email'))->count());
    }

    public function test_deactivated_guest_account_stays_blocked(): void
    {
        $viewer = Role::create(['code' => 'viewer', 'name' => 'Viewer']);
        $guest = User::factory()->create(['email' => config('auth.guest_email'), 'is_active' => false]);
        $guest->roles()->attach($viewer->id);

        $this->postJson('/api/auth/guest')->assertStatus(503);
        $this->assertGuest('web');
    }

    public function test_guest_account_with_extra_roles_is_never_used(): void
    {
        $viewer = Role::create(['code' => 'viewer', 'name' => 'Viewer']);
        $admin = Role::create(['code' => 'admin', 'name' => 'Admin']);
        $guest = User::factory()->create(['email' => config('auth.guest_email'), 'is_active' => true]);
        $guest->roles()->attach([$viewer->id, $admin->id]);

        $this->postJson('/api/auth/guest')->assertStatus(503);
        $this->assertGuest('web');
        $this->assertSame(['admin', 'viewer'], $guest->roles()->orderBy('code')->pluck('code')->all());
    }
}
