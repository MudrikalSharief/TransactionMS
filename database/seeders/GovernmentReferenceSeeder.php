<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\GovernmentReference;

class GovernmentReferenceSeeder extends Seeder
{
    public function run(): void
    {
        GovernmentReference::create([
            'code' => 'RA-9184',
            'title' => 'Government Procurement Reform Act (placeholder record)',
            'source' => 'Republic Act',
            'url' => null,
            'notes' => 'TO VERIFY — admin must encode official URL/sections. Do not hardcode legal text.',
            'is_verified' => false,
        ]);

        GovernmentReference::create([
            'code' => 'IRR-RA-9184',
            'title' => 'IRR for RA 9184 (placeholder record)',
            'source' => 'IRR',
            'url' => null,
            'notes' => 'TO VERIFY — admin must encode official URL/sections.',
            'is_verified' => false,
        ]);

        GovernmentReference::create([
            'code' => 'COA-CIRCULAR-TO-VERIFY',
            'title' => 'COA Circular (placeholder record)',
            'source' => 'COA',
            'url' => null,
            'notes' => 'TO VERIFY — replace with exact COA circular code + official link.',
            'is_verified' => false,
        ]);

        GovernmentReference::create([
            'code' => 'DBM-GUIDANCE-TO-VERIFY',
            'title' => 'DBM Guidance (placeholder record)',
            'source' => 'DBM',
            'url' => null,
            'notes' => 'TO VERIFY — replace with exact DBM issuance + official link.',
            'is_verified' => false,
        ]);
    }
}
