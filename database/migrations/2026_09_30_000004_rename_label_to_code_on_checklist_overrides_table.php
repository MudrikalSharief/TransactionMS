<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('checklist_overrides', function (Blueprint $table) {
            $table->renameColumn('label', 'code');
        });
    }

    public function down(): void
    {
        Schema::table('checklist_overrides', function (Blueprint $table) {
            $table->renameColumn('code', 'label');
        });
    }
};
