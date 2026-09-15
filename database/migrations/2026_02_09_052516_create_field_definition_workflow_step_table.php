<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('field_definition_workflow_step', function (Blueprint $table) {
            $table->id();

            $table->foreignId('workflow_step_id')->constrained('workflow_steps')->cascadeOnDelete();
            $table->foreignId('field_definition_id')->constrained('field_definitions')->cascadeOnDelete();

            $table->unsignedInteger('display_order')->default(0);
            $table->boolean('required_override')->nullable(); 

            $table->timestamps();

            $table->unique(['workflow_step_id', 'field_definition_id'], 'uniq_step_field');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('field_definition_workflow_step');
    }
};
