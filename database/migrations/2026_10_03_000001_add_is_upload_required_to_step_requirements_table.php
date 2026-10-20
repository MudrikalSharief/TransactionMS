<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('step_requirements', function (Blueprint $table) {
            // Sits right below is_required: required-ness vs must-attach-file
            // are independent per step x requirement.
            $table->boolean('is_upload_required')->default(false)->after('is_required');
        });

        // Preserve current behavior: everything required before also required a file.
        DB::table('step_requirements')
            ->where('is_required', true)
            ->update(['is_upload_required' => true]);
    }

    public function down(): void
    {
        Schema::table('step_requirements', function (Blueprint $table) {
            $table->dropColumn('is_upload_required');
        });
    }
};
