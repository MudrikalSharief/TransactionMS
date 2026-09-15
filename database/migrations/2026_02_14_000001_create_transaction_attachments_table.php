<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_attachments', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('transaction_id');
            $table->unsignedBigInteger('workflow_step_id');
            $table->unsignedBigInteger('requirement_definition_id')->nullable();
            $table->unsignedBigInteger('step_run_id')->nullable();

            $table->string('original_name');
            $table->string('stored_path');
            $table->string('disk')->default('local');
            $table->string('mime')->nullable();
            $table->unsignedBigInteger('size_bytes')->default(0);
            $table->unsignedBigInteger('uploaded_by');

            $table->timestamps();

            $table->index(['transaction_id', 'workflow_step_id'], 'ix_ta_tx_step');
            $table->index(['transaction_id', 'requirement_definition_id'], 'ix_ta_tx_req');
            $table->index(['step_run_id'], 'ix_ta_run');

            $table->foreign('transaction_id', 'fk_ta_tx')
                ->references('id')->on('transactions')
                ->onDelete('cascade');

            $table->foreign('workflow_step_id', 'fk_ta_step')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('requirement_definition_id', 'fk_ta_reqdef')
                ->references('id')->on('requirement_definitions')
                ->onDelete('cascade');

            $table->foreign('step_run_id', 'fk_ta_run')
                ->references('id')->on('transaction_step_runs')
                ->onDelete('set null');

            $table->foreign('uploaded_by', 'fk_ta_user')
                ->references('id')->on('users')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_attachments');
    }
};
