<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('step_requirements', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('workflow_step_id');
            $table->unsignedBigInteger('requirement_definition_id');

            $table->unsignedInteger('display_order')->default(0);
            $table->boolean('is_required')->default(true);

            $table->timestamps();

            $table->unique(['workflow_step_id', 'requirement_definition_id'], 'uq_step_req');

            $table->foreign('workflow_step_id', 'fk_sr_step')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('requirement_definition_id', 'fk_sr_reqdef')
                ->references('id')->on('requirement_definitions')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('step_requirements');
    }
};
