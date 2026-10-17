<?php

namespace Database\Seeders;

use App\Models\Permission;
use Illuminate\Database\Seeder;

class PermissionsSeeder extends Seeder
{
    /**
     * Module-based permission catalog: "<module>.<view|manage>".
     * Idempotent; grants are made per role on the Roles admin page.
     */
    public function run(): void
    {
        $permissions = [
            ['code' => 'dashboard.view', 'name' => 'View dashboard summary', 'description' => 'See the Transaction Summary card on the dashboard.'],
            ['code' => 'transactions.manage', 'name' => 'Create transactions', 'description' => 'Create new transactions (the Transactions list itself is open to everyone, office-scoped).'],
            ['code' => 'users.view', 'name' => 'View users', 'description' => 'Open the Users page and see user accounts.'],
            ['code' => 'users.manage', 'name' => 'Manage users', 'description' => 'Create, edit, and delete users, assign their roles and office.'],
            ['code' => 'roles.view', 'name' => 'View roles', 'description' => 'Open the Roles page and see permission checklists.'],
            ['code' => 'roles.manage', 'name' => 'Manage roles', 'description' => 'Create, edit, and delete roles and change their permission checklists.'],
            ['code' => 'offices.view', 'name' => 'View offices', 'description' => 'Open the Offices page and see their step hierarchy.'],
            ['code' => 'offices.manage', 'name' => 'Manage offices', 'description' => 'Create, edit, and delete offices and their step hierarchy.'],
            ['code' => 'workflows.view', 'name' => 'View workflows', 'description' => 'Open the Workflows page and inspect versions, steps, and routes.'],
            ['code' => 'workflows.manage', 'name' => 'Manage workflows', 'description' => 'Edit workflow versions, steps, and routes, and publish them.'],
            ['code' => 'fields.view', 'name' => 'View fields', 'description' => 'Open the Fields page and see per-step field assignments.'],
            ['code' => 'fields.manage', 'name' => 'Manage fields', 'description' => 'Create, edit, and delete field definitions and per-step assignments.'],
            ['code' => 'requirements.view', 'name' => 'View requirements', 'description' => 'See requirement definitions, per-step requirements, and checklists.'],
            ['code' => 'requirements.manage', 'name' => 'Manage requirements', 'description' => 'Create, edit, and delete requirement definitions, per-step requirements, and checklists.'],
            ['code' => 'government_references.view', 'name' => 'View government references', 'description' => 'Open the Government References page.'],
            ['code' => 'government_references.manage', 'name' => 'Manage government references', 'description' => 'Create, edit, and delete government references.'],
        ];

        foreach ($permissions as $permission) {
            Permission::updateOrCreate(['code' => $permission['code']], $permission);
        }

        // Retire codes dropped from the catalog (soft delete; pivot rows stay).
        Permission::whereNotIn('code', array_column($permissions, 'code'))->delete();
    }
}
