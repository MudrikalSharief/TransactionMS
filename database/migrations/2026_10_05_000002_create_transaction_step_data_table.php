<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_step_data', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained('transactions')->cascadeOnDelete();
            $table->foreignId('workflow_step_data_id')->constrained('workflow_step_data')->cascadeOnDelete();
            $table->foreignId('transaction_step_run_id')->nullable()->constrained('transaction_step_runs')->cascadeOnDelete();
            $table->foreignId('workflow_step_id')->constrained('workflow_steps')->cascadeOnDelete();
            $table->text('data_value')->nullable();
            $table->foreignId('entered_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('entered_at')->nullable();
            $table->timestamps();

            $table->unique(['transaction_step_run_id', 'workflow_step_data_id'], 'uniq_run_stepdata');
            $table->index(['transaction_id', 'workflow_step_id'], 'idx_tx_stepdata_tx_step');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_step_data');
    }
};
