<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_checklist_checks', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('transaction_id');
            $table->unsignedBigInteger('workflow_step_id');
            // null = the checklist row was deleted; keep the tick history.
            $table->unsignedBigInteger('checklist_override_id')->nullable();

            $table->unsignedBigInteger('checked_by');
            $table->timestamp('checked_at');

            $table->timestamps();

            $table->unique(
                ['transaction_id', 'workflow_step_id', 'checklist_override_id'],
                'uq_tcc_tx_step_item'
            );

            $table->foreign('transaction_id', 'fk_tcc_tx')
                ->references('id')->on('transactions')
                ->onDelete('cascade');

            $table->foreign('workflow_step_id', 'fk_tcc_step')
                ->references('id')->on('workflow_steps')
                ->onDelete('cascade');

            $table->foreign('checklist_override_id', 'fk_tcc_item')
                ->references('id')->on('checklist_overrides')
                ->onDelete('set null');

            $table->foreign('checked_by', 'fk_tcc_user')
                ->references('id')->on('users')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_checklist_checks');
    }
};
