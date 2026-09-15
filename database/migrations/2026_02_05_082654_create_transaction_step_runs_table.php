<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_step_runs', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_id')->constrained('transactions')->cascadeOnDelete();
            $table->foreignId('from_step_id')->constrained('workflow_steps');
            $table->foreignId('to_step_id')->nullable()->constrained('workflow_steps');

            $table->string('action_code'); // submit, approve, return, reject (later enforced)
            $table->text('remarks')->nullable();

            $table->foreignId('performed_by')->constrained('users')->cascadeOnDelete();
            $table->timestamp('performed_at');

            $table->timestamps();

            $table->index(['transaction_id', 'performed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_step_runs');
    }
};
