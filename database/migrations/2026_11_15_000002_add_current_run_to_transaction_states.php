<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transaction_states', function (Blueprint $table) {
            // The run that brought the paper into the current step. Its
            // received_at is when the current worker started handling it.
            $table->foreignId('current_run_id')
                ->nullable()
                ->after('current_step_id')
                ->constrained('transaction_step_runs')
                ->nullOnDelete();
        });

        DB::table('transaction_states')
            ->select(['id', 'transaction_id', 'current_step_id'])
            ->orderBy('id')
            ->chunkById(200, function ($states) {
                foreach ($states as $state) {
                    $runId = DB::table('transaction_step_runs')
                        ->where('transaction_id', $state->transaction_id)
                        ->where('to_step_id', $state->current_step_id)
                        ->orderByDesc('performed_at')
                        ->orderByDesc('id')
                        ->value('id');

                    if ($runId) {
                        DB::table('transaction_states')
                            ->where('id', $state->id)
                            ->update(['current_run_id' => $runId]);
                    }
                }
            });
    }

    public function down(): void
    {
        Schema::table('transaction_states', function (Blueprint $table) {
            $table->dropConstrainedForeignId('current_run_id');
        });
    }
};
