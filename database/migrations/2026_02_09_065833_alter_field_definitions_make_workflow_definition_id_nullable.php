<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('field_definitions', function (Blueprint $table) {
            $table->unsignedBigInteger('workflow_definition_id')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('field_definitions', function (Blueprint $table) {
            // WARNING: this will fail if any rows have NULL workflow_definition_id
            $table->unsignedBigInteger('workflow_definition_id')->nullable(false)->change();
        });
    }
};
