<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Contact_number was added to some databases by hand as a NOT NULL float:
     * a float drops the leading 0 of "09..." and rounds an 11-digit number,
     * and NOT NULL without a default breaks every insert that leaves it out.
     * Make it a nullable string everywhere (adding it where it is missing)
     * and clear the 0 placeholders.
     */
    public function up(): void
    {
        if (!Schema::hasColumn('users', 'Contact_number')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('Contact_number', 20)->nullable()->after('office_id');
            });

            return;
        }

        Schema::table('users', function (Blueprint $table) {
            $table->string('Contact_number', 20)->nullable()->change();
        });

        DB::table('users')->whereIn('Contact_number', ['0', '0.0', ''])->update(['Contact_number' => null]);
    }

    public function down(): void
    {
        // Leaves the column in place: on databases where it was added by
        // hand, dropping it would remove data this migration never owned.
    }
};
