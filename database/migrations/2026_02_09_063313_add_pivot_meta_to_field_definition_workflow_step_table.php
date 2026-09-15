<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('field_definition_workflow_step', function (Blueprint $table) {
            if (!Schema::hasColumn('field_definition_workflow_step', 'display_order')) {
                $table->unsignedInteger('display_order')->default(0)->after('workflow_step_id');
            }
            if (!Schema::hasColumn('field_definition_workflow_step', 'required_override')) {
                $table->boolean('required_override')->nullable()->after('display_order');
            }
        });
    }

    public function down(): void
    {
        Schema::table('field_definition_workflow_step', function (Blueprint $table) {
            if (Schema::hasColumn('field_definition_workflow_step', 'required_override')) {
                $table->dropColumn('required_override');
            }
            if (Schema::hasColumn('field_definition_workflow_step', 'display_order')) {
                $table->dropColumn('display_order');
            }
        });
    }
};
