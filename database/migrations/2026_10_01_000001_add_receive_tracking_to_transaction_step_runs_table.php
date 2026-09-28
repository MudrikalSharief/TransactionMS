<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('transaction_step_runs', function (Blueprint $table) {
            // #2 To (Receiving) timestamp — NULL = in-transit / pending receipt
            $table->timestamp('received_at')->nullable()->after('performed_at');
            // #4 To user — first-claimer with destination role, NULL until received
            $table->foreignId('received_by')->nullable()->after('received_at')->constrained('users')->nullOnDelete();
            // Denormalized destination office for easy table display / inbox queries
            $table->foreignId('received_office_id')->nullable()->after('received_by')->constrained('offices')->nullOnDelete();
            // #5 Duration (estimated) — snapshot of destination workflow_steps.sla_minutes at forward time
            $table->unsignedInteger('sla_minutes_snapshot')->default(0)->after('received_office_id');

            $table->index(['transaction_id', 'received_at']);
            $table->index(['to_step_id', 'received_at']);
        });

        // Backfill existing history so old rows read as "auto-received" (no pending inbox shock):
        // received_at = performed_at, snapshot + office copied from destination step.
        try {
            $steps = DB::table('workflow_steps')->select('id', 'office_id', 'sla_minutes')->get()->keyBy('id');
            $runs = DB::table('transaction_step_runs')->select('id', 'to_step_id', 'performed_at')->get();
            foreach ($runs as $run) {
                $step = $run->to_step_id ? ($steps->get($run->to_step_id) ?? null) : null;
                DB::table('transaction_step_runs')->where('id', $run->id)->update([
                    'received_at' => $run->performed_at,
                    'received_office_id' => $step?->office_id,
                    'sla_minutes_snapshot' => (int) ($step?->sla_minutes ?? 0),
                ]);
            }
        } catch (\Throwable $e) {
            // Backfill is best-effort; columns still usable for new forwards.
            report($e);
        }
    }

    public function down(): void
    {
        Schema::table('transaction_step_runs', function (Blueprint $table) {
            $table->dropIndex(['transaction_step_runs_transaction_id_received_at_index'] ?? ['transaction_id', 'received_at']);
            $table->dropIndex(['transaction_step_runs_to_step_id_received_at_index'] ?? ['to_step_id', 'received_at']);
            $table->dropConstrainedForeignId('received_office_id');
            $table->dropConstrainedForeignId('received_by');
            $table->dropColumn(['received_at', 'sla_minutes_snapshot']);
        });
    }
};
