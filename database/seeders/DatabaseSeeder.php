<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            RolesSeeder::class,
            SuperAdminSeeder::class,
            OfficeSeeder::class,
            UsersSeeder::class,

            TransactionTypeSeeder::class,
            GovernmentReferenceSeeder::class,

            WorkflowSeeder::class,
            PurchaseRequestSetupSeeder::class,
        ]);
    }
}
