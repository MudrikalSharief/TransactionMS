<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('step_roles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workflow_step_id')->constrained('workflow_steps')->cascadeOnDelete();
            $table->foreignId('role_id')->constrained('roles')->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['workflow_step_id', 'role_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('step_roles');
    }
};
