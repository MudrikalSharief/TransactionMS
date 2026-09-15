<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('requirement_checks', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_id')
                ->constrained('transactions')
                ->cascadeOnDelete();

            $table->foreignId('workflow_step_id')
                ->constrained('workflow_steps')
                ->cascadeOnDelete();

            $table->foreignId('requirement_definition_id')
                ->constrained('requirement_definitions')
                ->cascadeOnDelete();

            $table->foreignId('checked_by')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->timestamp('checked_at')->useCurrent();

            $table->timestamps();

            $table->unique(
                ['transaction_id', 'workflow_step_id', 'requirement_definition_id'],
                'req_checks_unique'
            );

            $table->index(['transaction_id', 'workflow_step_id'], 'req_checks_tx_step_idx');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('requirement_checks');
    }
};
