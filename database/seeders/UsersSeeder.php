<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Role;
use App\Models\Office;
use Illuminate\Support\Facades\Hash;

class UsersSeeder extends Seeder
{
    public function run(): void
    {
        $users = [
            ['name' => 'End User',           'email' => 'enduser@lgu.test',     'roles' => ['end_user'],       'office' => 'csd'],
            ['name' => 'GSO Officer',        'email' => 'gso@lgu.test',         'roles' => ['gso'],            'office' => 'gso'],
            ['name' => 'City Administrator', 'email' => 'cityadmin@lgu.test',   'roles' => ['city_admin'],     'office' => 'city_admin'],
            ['name' => 'CTO',                'email' => 'cto@lgu.test',         'roles' => ['cto'],            'office' => 'cto'],
            ['name' => 'City Treasurer',     'email' => 'treasurer@lgu.test',   'roles' => ['city_treasurer'], 'office' => 'city_treasurer'],
            ['name' => 'CAdmin',             'email' => 'cadmin@lgu.test',      'roles' => ['cadmin'],         'office' => 'cadmin'],
            ['name' => 'CBO',                'email' => 'cbo@lgu.test',         'roles' => ['cbo'],            'office' => 'cbo'],
            ['name' => 'BAC-PAAD',           'email' => 'bac@lgu.test',         'roles' => ['bac_paad'],       'office' => 'bac_paad'],
        ];

        $officeIds = Office::pluck('id', 'code')->all();

        foreach ($users as $u) {
            $user = User::updateOrCreate(
                ['email' => $u['email']],
                [
                    'name' => $u['name'],
                    'password' => Hash::make('admin123'),
                    'office_id' => $officeIds[$u['office']] ?? null,
                ]
            );

            $roleIds = Role::whereIn('code', $u['roles'])->pluck('id')->all();
            if (!empty($roleIds)) {
                $user->roles()->syncWithoutDetaching($roleIds);
            }
        }
    }
}
