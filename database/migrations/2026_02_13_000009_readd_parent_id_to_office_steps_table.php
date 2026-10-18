<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Hierarchy restored on office steps (flat 1-2-3 + sub-steps).
        if (!Schema::hasColumn('office_steps', 'parent_id')) {
            Schema::table('office_steps', function (Blueprint $table) {
                $table->foreignId('parent_id')->nullable()->after('office_id')->constrained('office_steps')->nullOnDelete();
            });
        }

        if (!Schema::hasIndex('office_steps', 'office_steps_office_id_parent_id_order_number_index')) {
            Schema::table('office_steps', function (Blueprint $table) {
                $table->index(['office_id', 'parent_id', 'order_number']);
            });
        }
    }

    public function down(): void
    {
        Schema::table('office_steps', function (Blueprint $table) {
            $table->dropIndex(['office_id', 'parent_id', 'order_number']);
            $table->dropConstrainedForeignId('parent_id');
        });
    }
};
