<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_requirement_checks', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('transaction_id');
            $table->unsignedBigInteger('workflow_step_id');
            $table->unsignedBigInteger('requirement_definition_id');

            $table->unsignedBigInteger('checked_by');
            $table->timestamp('checked_at');

            $table->timestamps();

            // Immutable: one row only, never updated/un-checked
            $table->unique(
                ['transaction_id', 'workflow_step_id', 'requirement_definition_id'],
                'uq_trc_tx_step_req'
            );

            $table->foreign('transaction_id', 'fk_trc_tx')
                ->references('id')->on('transactions')
                ->onDelete('cascade');

            $table->foreign('workflow_step_id', 'fk_trc_step')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('requirement_definition_id', 'fk_trc_reqdef')
                ->references('id')->on('requirement_definitions')
                ->onDelete('cascade');

            $table->foreign('checked_by', 'fk_trc_user')
                ->references('id')->on('users')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_requirement_checks');
    }
};
