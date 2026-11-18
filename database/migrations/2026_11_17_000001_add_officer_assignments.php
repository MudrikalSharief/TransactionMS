<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transaction_step_runs', function (Blueprint $table) {
            $table->foreignId('assigned_to')->nullable()->constrained('users')->nullOnDelete();
        });
        Schema::create('transaction_officer_assignments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained('transactions')->cascadeOnDelete();
            $table->foreignId('transaction_step_run_id')->constrained('transaction_step_runs')->cascadeOnDelete();
            $table->foreignId('from_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('to_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('assigned_by')->nullable()->constrained('users')->nullOnDelete();
            $table->string('from_user_name')->nullable();
            $table->string('to_user_name');
            $table->string('assigned_by_name');
            $table->timestamp('assigned_at');
            $table->text('reason');
            $table->index(['transaction_id', 'id']);
            $table->index(['transaction_step_run_id', 'id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaction_officer_assignments');
        Schema::table('transaction_step_runs', fn (Blueprint $table) => $table->dropConstrainedForeignId('assigned_to'));
    }
};
