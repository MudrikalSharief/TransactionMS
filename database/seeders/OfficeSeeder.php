<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class OfficeSeeder extends Seeder
{
    public function run(): void
    {
        // Intentionally empty: offices are managed by superadmins
        // via Admin -> Offices (code + office name + ordered steps).
        // Seeding is disabled so demo rows never repopulate real data.
    }
}
