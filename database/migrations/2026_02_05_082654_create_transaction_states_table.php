<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transaction_states', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_id')->constrained('transactions')->cascadeOnDelete();

            $table->foreignId('current_step_id')->constrained('workflow_steps');

            $table->timestamp('entered_at');
            $table->timestamps();

            $table->unique('transaction_id'); 
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_states');
    }
};
