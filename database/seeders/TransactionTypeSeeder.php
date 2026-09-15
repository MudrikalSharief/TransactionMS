<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\TransactionType;

class TransactionTypeSeeder extends Seeder
{
    public function run(): void
    {
        TransactionType::updateOrCreate(
            ['code' => 'payroll'],
            ['name' => 'Payroll', 'description' => 'LGU payroll processing', 'is_active' => true]
        );

        TransactionType::updateOrCreate(
            ['code' => 'procurement'],
            ['name' => 'Procurement', 'description' => 'LGU procurement process (inventory-linked)', 'is_active' => true]
        );
    }
}
