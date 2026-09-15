<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class SuperAdminSeeder extends Seeder
{
    public function run(): void 
    {
        $user = User::updateOrCreate(
            ['email' => 'vinzmuloc@gmail.com'],
            [
                'name' => 'Super Admin',
                'password' => Hash::make('admin123'),
                'is_active' => true,
            ]
        );

        $super = Role::where('code', 'superadmin')->firstOrFail();
        $user->roles()->syncWithoutDetaching([$super->id]);
    }
}
