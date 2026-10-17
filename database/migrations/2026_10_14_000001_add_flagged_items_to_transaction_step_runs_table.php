<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Structured return flags: checklist items the sender flagged when
     * returning work (persisted separately from free-text remarks so they
     * cannot be erased and can highlight the receiver's checklist).
     */
    public function up(): void
    {
        Schema::table('transaction_step_runs', function (Blueprint $table) {
            $table->json('flagged_items')->nullable()->after('remarks');
        });
    }

    public function down(): void
    {
        Schema::table('transaction_step_runs', function (Blueprint $table) {
            $table->dropColumn('flagged_items');
        });
    }
};
