<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('checklist_overrides', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('workflow_step_id');
            // null = custom checklist-only row (not tied to a requirement).
            $table->unsignedBigInteger('requirement_definition_id')->nullable();

            $table->string('name');
            $table->string('label', 120)->nullable();
            $table->text('description')->nullable();
            $table->boolean('is_required')->default(true);
            $table->unsignedInteger('display_order')->default(0);

            $table->timestamps();

            $table->index('workflow_step_id', 'idx_chk_step');
            $table->index('requirement_definition_id', 'idx_chk_reqdef');

            $table->foreign('workflow_step_id', 'fk_chk_step')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('requirement_definition_id', 'fk_chk_reqdef')
                ->references('id')->on('requirement_definitions')
                ->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('checklist_overrides');
    }
};
