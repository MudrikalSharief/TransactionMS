<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Role;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * Creates the read-only account behind the login page's "Track your Document
 * Process" button (auth.guest_email). Run on its own:
 *   php artisan db:seed --class=ViewerGuestSeeder
 * It is not part of DatabaseSeeder. An existing account is left as it is,
 * apart from gaining the viewer role if it lacks it.
 */
class ViewerGuestSeeder extends Seeder
{
    public function run(): void
    {
        $viewerRole = Role::where('code', 'viewer')->first();

        if (!$viewerRole) {
            $this->command?->error('Viewer role is missing. Run RolesSeeder first.');
            return;
        }

        // Guests sign in without a password, so this one is random and never shown.
        $user = User::firstOrCreate(
            ['email' => config('auth.guest_email')],
            [
                'name' => 'Guest Viewer',
                'password' => Hash::make(Str::random(40)),
                'is_active' => true,
            ]
        );

        $user->roles()->syncWithoutDetaching([$viewerRole->id]);
    }
}
