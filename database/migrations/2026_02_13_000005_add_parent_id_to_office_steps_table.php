<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('office_steps', function (Blueprint $table) {
            // Hierarchical sub-steps: a step may sit under a parent step
            // of the same office (e.g. 1 → 1.1, 1.2). Null = top level.
            $table->foreignId('parent_id')->nullable()->after('office_id')->constrained('office_steps')->nullOnDelete();
            $table->index(['office_id', 'parent_id', 'order_number']);
        });
    }

    public function down(): void
    {
        Schema::table('office_steps', function (Blueprint $table) {
            $table->dropConstrainedForeignId('parent_id');
            $table->dropIndex(['office_id', 'parent_id', 'order_number']);
        });
    }
};
