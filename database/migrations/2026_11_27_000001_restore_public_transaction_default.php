<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * is_private keeps its natural meaning: true = private/hidden from Track,
     * false = public/searchable. A prior migration inverted the default and
     * marked every existing row private; restore the public default.
     */
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->boolean('is_private')->default(false)->change();
        });

        // The 2026_11_11 migration marked every existing row private.
        DB::table('transactions')->update(['is_private' => false]);
    }

    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->boolean('is_private')->default(true)->change();
        });
    }
};
