<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UsernameAuthenticationTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->withHeader('Referer', 'http://localhost');
    }

    private function registration(array $overrides = []): array
    {
        $office = Office::firstOrCreate(['code' => 'AUTH'], ['name' => 'Authentication Office']);
        $role = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);

        return array_replace([
            'name' => 'Juan Dela Cruz',
            'username' => 'juan.delacruz',
            'contact_number' => '09171234567',
            'password' => 'password123',
            'office_id' => $office->id,
            'role_ids' => [$role->id],
        ], $overrides);
    }

    public function test_registration_needs_no_email_and_waits_for_approval(): void
    {
        $this->postJson('/api/auth/register', $this->registration(['username' => '  Juan.DelaCruz  ']))
            ->assertCreated();

        $user = User::where('username', 'juan.delacruz')->firstOrFail();
        $this->assertNull($user->email);
        $this->assertNull($user->approved_at);
        $this->assertFalse($user->is_active);
        $this->assertTrue(Hash::check('password123', $user->password));
        $this->assertGuest('web');
    }

    public function test_multiple_accounts_can_register_without_email(): void
    {
        $this->postJson('/api/auth/register', $this->registration())->assertCreated();
        $this->postJson('/api/auth/register', $this->registration(['username' => 'another.user']))->assertCreated();
        $this->assertSame(2, User::whereNull('email')->count());
    }

    public function test_duplicate_usernames_are_rejected_after_normalization(): void
    {
        User::factory()->create(['username' => 'juan.delacruz']);

        $this->postJson('/api/auth/register', $this->registration(['username' => ' JUAN.DELACRUZ ']))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('username')
            ->assertJsonMissingValidationErrors('email');
        $this->assertSame(1, User::where('username', 'juan.delacruz')->count());
    }

    public function test_registration_rejects_non_string_usernames_without_a_server_error(): void
    {
        $this->postJson('/api/auth/register', $this->registration(['username' => ['invalid']]))
            ->assertUnprocessable()
            ->assertJsonValidationErrors('username');
    }

    public function test_an_approved_user_can_sign_in_with_a_normalized_username(): void
    {
        $user = User::factory()->create(['username' => 'juan.delacruz', 'password' => Hash::make('password123')]);

        $this->postJson('/api/auth/login', ['login' => ' JUAN.DELACRUZ ', 'password' => 'password123'])
            ->assertOk()
            ->assertJsonPath('user.username', 'juan.delacruz');
        $this->assertAuthenticatedAs($user, 'web');
        $this->getJson('/api/auth/me')->assertOk()->assertJsonPath('user.username', 'juan.delacruz');
    }

    public function test_an_email_address_cannot_be_used_as_the_login_identifier(): void
    {
        $user = User::factory()->create(['username' => 'juan.delacruz', 'password' => Hash::make('password123')]);

        $this->postJson('/api/auth/login', ['login' => $user->email, 'password' => 'password123'])
            ->assertUnprocessable()->assertJsonValidationErrors('login');
        $this->assertGuest('web');
    }

    public function test_the_legacy_email_login_payload_is_rejected(): void
    {
        $user = User::factory()->create(['username' => 'juan.delacruz', 'password' => Hash::make('password123')]);

        $this->postJson('/api/auth/login', ['email' => $user->email, 'password' => 'password123'])
            ->assertUnprocessable()->assertJsonValidationErrors('login');
        $this->assertGuest('web');
    }

    public function test_unapproved_accounts_remain_blocked_with_the_correct_username_and_password(): void
    {
        User::factory()->create([
            'username' => 'pending.user', 'password' => Hash::make('password123'),
            'approved_at' => null, 'is_active' => false,
        ]);

        $this->postJson('/api/auth/login', ['login' => 'pending.user', 'password' => 'password123'])
            ->assertForbidden();
        $this->assertGuest('web');
    }

    public function test_internal_accounts_receive_distinct_usernames_when_their_names_match(): void
    {
        $first = User::factory()->create(['username' => null, 'name' => 'Juan Dela Cruz']);
        $second = User::factory()->create(['username' => null, 'name' => 'Juan Dela Cruz']);
        $this->assertSame('juan.dela.cruz', $first->username);
        $this->assertNotSame($first->username, $second->username);
        $this->assertMatchesRegularExpression('/^[a-z0-9][a-z0-9._]{1,28}[a-z0-9]$/', $second->username);
    }

    public function test_username_only_accounts_can_update_their_profile_without_email(): void
    {
        $user = User::factory()->create(['username' => 'profile.user', 'email' => null]);
        Sanctum::actingAs($user);

        $this->putJson('/api/profile', ['name' => 'Updated Name', 'contact_number' => '09171234567'])
            ->assertOk()->assertJsonPath('profile.username', 'profile.user');
        $this->assertNull($user->fresh()->email);
    }

    public function test_profile_updates_preserve_historical_email_when_it_is_not_sent(): void
    {
        $user = User::factory()->create(['username' => 'profile.user', 'email' => 'history@example.test']);
        Sanctum::actingAs($user);

        $this->putJson('/api/profile', ['name' => 'Updated Name'])
            ->assertOk()->assertJsonPath('profile.email', 'history@example.test');
    }

    public function test_superadmins_can_create_username_only_accounts(): void
    {
        $admin = User::factory()->create();
        $admin->roles()->attach(Role::firstOrCreate(['code' => 'superadmin'], ['name' => 'Super Admin']));
        Sanctum::actingAs($admin);

        $this->postJson('/api/admin/users', ['name' => 'New User', 'username' => 'new.user', 'password' => 'password123'])
            ->assertCreated()->assertJsonPath('data.username', 'new.user')->assertJsonPath('data.email', null);
    }

    public function test_office_admins_can_create_username_only_accounts(): void
    {
        $office = Office::create(['code' => 'AUTH', 'name' => 'Authentication Office']);
        $admin = User::factory()->create(['office_id' => $office->id]);
        $admin->roles()->attach(Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']));
        Sanctum::actingAs($admin);

        $this->postJson('/api/office/users', ['name' => 'New User', 'username' => 'new.user', 'password' => 'password123'])
            ->assertCreated()->assertJsonPath('data.username', 'new.user')->assertJsonPath('data.email', null);
    }

    public function test_database_rejects_duplicate_usernames_even_without_request_validation(): void
    {
        User::factory()->create(['username' => 'unique.user']);
        $this->expectException(QueryException::class);
        DB::table('users')->insert(['name' => 'Duplicate', 'username' => 'unique.user', 'password' => 'unused']);
    }

    public function test_database_requires_a_username_even_without_request_validation(): void
    {
        $this->expectException(QueryException::class);
        DB::table('users')->insert(['name' => 'Missing username', 'username' => null, 'email' => 'old@example.test', 'password' => 'unused']);
    }

    public function test_migration_backfills_colliding_names_and_preserves_existing_account_data(): void
    {
        $migrationPath = database_path('migrations/2026_11_09_000001_require_usernames_for_authentication.php');
        $this->assertFileExists($migrationPath);
        Schema::table('users', fn ($table) => $table->string('username', 30)->nullable()->change());
        DB::table('users')->insert([
            ['id' => 101, 'name' => 'Juan Dela Cruz', 'username' => 'juan.dela.cruz', 'email' => 'keep@example.test', 'password' => 'keep-hash'],
            ['id' => 102, 'name' => 'Juan Dela Cruz', 'username' => null, 'email' => 'old@example.test', 'password' => 'old-hash'],
            ['id' => 103, 'name' => 'Juan Dela Cruz', 'username' => '', 'email' => 'blank@example.test', 'password' => 'blank-hash'],
            ['id' => 104, 'name' => '李', 'username' => null, 'email' => 'unicode@example.test', 'password' => 'unicode-hash'],
        ]);

        (require $migrationPath)->up();

        $users = DB::table('users')->orderBy('id')->get();
        $this->assertSame([101, 102, 103, 104], $users->pluck('id')->all());
        $this->assertSame(4, $users->pluck('username')->unique()->count());
        $this->assertSame('juan.dela.cruz', $users[0]->username);
        $this->assertSame('keep@example.test', $users[0]->email);
        $this->assertSame('old-hash', $users[1]->password);
        foreach ($users as $user) {
            $this->assertMatchesRegularExpression('/^[a-z0-9][a-z0-9._]{1,28}[a-z0-9]$/', $user->username);
        }
    }
}
