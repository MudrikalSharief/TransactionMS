<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('requirement_definition_workflow_step', function (Blueprint $table) {
            $table->id();

            $table->foreignId('workflow_step_id');
            $table->foreignId('requirement_definition_id');

            $table->boolean('is_required')->default(true);
            $table->unsignedInteger('display_order')->default(0);

            $table->timestamps();

            $table->foreign('workflow_step_id', 'rdws_step_fk')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('requirement_definition_id', 'rdws_req_fk')
                ->references('id')->on('requirement_definitions')
                ->onDelete('cascade');

            $table->unique(
                ['workflow_step_id', 'requirement_definition_id'],
                'rdws_step_req_uk'
            );
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('requirement_definition_workflow_step');
    }
};
