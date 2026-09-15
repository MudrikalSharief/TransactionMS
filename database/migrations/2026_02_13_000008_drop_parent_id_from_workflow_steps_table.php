<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('workflow_steps', function (Blueprint $table) {
            // Hierarchy reverted: transaction steps stay a flat 1-2-3 list.
            $table->dropIndex('wf_steps_def_parent_order_idx');
            $table->dropConstrainedForeignId('parent_id');
        });
    }

    public function down(): void
    {
        Schema::table('workflow_steps', function (Blueprint $table) {
            $table->foreignId('parent_id')->nullable()->after('workflow_definition_id')->constrained('workflow_steps')->nullOnDelete();
            $table->index(['workflow_definition_id', 'parent_id', 'order_number'], 'wf_steps_def_parent_order_idx');
        });
    }
};
