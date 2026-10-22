<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('workflow_steps', function (Blueprint $table) {
            $table->boolean('is_end_user')->default(false)->after('is_end');
        });

        // Preserve the old implicit rule (end_user role = follow the
        // transaction's office) when the explicit toggle is introduced.
        DB::table('workflow_steps')
            ->whereIn('id', function ($query) {
                $query->select('workflow_step_id')
                    ->from('step_roles')
                    ->join('roles', 'roles.id', '=', 'step_roles.role_id')
                    ->where('roles.code', 'end_user');
            })
            ->update(['is_end_user' => true]);
    }

    public function down(): void
    {
        Schema::table('workflow_steps', function (Blueprint $table) {
            $table->dropColumn('is_end_user');
        });
    }
};
