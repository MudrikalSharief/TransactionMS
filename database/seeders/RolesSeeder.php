<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;

class RolesSeeder extends Seeder
{
    public function run(): void
    {
        $roles = [
            ['code' => 'superadmin', 'name' => 'Super Admin', 'description' => 'Full access (local-only).'],
            ['code' => 'admin',      'name' => 'Admin',       'description' => 'Manages master data and workflows.'],
            ['code' => 'clerk',      'name' => 'Clerk',       'description' => 'Processes assigned steps.'],
            ['code' => 'approver',   'name' => 'Approver',    'description' => 'Approves steps routed to them.'],
            ['code' => 'viewer',     'name' => 'Viewer',      'description' => 'Read-only access.'],

            // Procurement Roles
            ['code' => 'end_user',        'name' => 'End User',        'description' => 'Creates and forwards PR documents.'],
            ['code' => 'gso',             'name' => 'GSO',             'description' => 'General Services Office processor.'],
            ['code' => 'city_admin',      'name' => 'City Administrator','description' => 'Signs/approves as City Admin.'],
            ['code' => 'cto',             'name' => 'CTO',             'description' => 'City Treasurer Office reviewer.'],
            ['code' => 'city_treasurer',  'name' => 'City Treasurer',  'description' => 'Signs/approves as Treasurer.'],
            ['code' => 'cadmin',          'name' => 'CAdmin',          'description' => 'City Admin office processor.'],
            ['code' => 'cbo',             'name' => 'CBO',             'description' => 'City Budget Office processor.'],
            ['code' => 'bac_paad',        'name' => 'BAC-PAAD',        'description' => 'Receives final submitted documents.'],
        ];

        foreach ($roles as $r) {
            Role::updateOrCreate(['code' => $r['code']], $r);
        }
    }
}