<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Hierarchy restored on transaction (workflow) steps.
        if (!Schema::hasColumn('workflow_steps', 'parent_id')) {
            Schema::table('workflow_steps', function (Blueprint $table) {
                $table->foreignId('parent_id')->nullable()->after('workflow_definition_id')->constrained('workflow_steps')->nullOnDelete();
            });
        }

        $indexes = collect(DB::select('SHOW INDEX FROM workflow_steps'))->pluck('Key_name');
        if (!$indexes->contains('wf_steps_def_parent_order_idx')) {
            Schema::table('workflow_steps', function (Blueprint $table) {
                $table->index(['workflow_definition_id', 'parent_id', 'order_number'], 'wf_steps_def_parent_order_idx');
            });
        }
    }

    public function down(): void
    {
        Schema::table('workflow_steps', function (Blueprint $table) {
            $table->dropIndex('wf_steps_def_parent_order_idx');
            $table->dropConstrainedForeignId('parent_id');
        });
    }
};
