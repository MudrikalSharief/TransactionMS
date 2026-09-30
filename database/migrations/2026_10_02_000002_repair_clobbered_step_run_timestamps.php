<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Release-time data repair, part 2.
 *
 * Context: the app writes UTC literals while MySQL sessions run at
 * SYSTEM (+08:00), so stored instants sit -8h and readouts shift +8h —
 * a twisted but self-consistent loop in which every displayed wall
 * time is TRUE. The only corruption was performed_at being rewritten
 * by the (now removed) ON UPDATE CURRENT_TIMESTAMP:
 *
 * R2 — user-received rows (ids known: 110, 112-115 pattern): the
 * previous repair swapped the clobbered performed_at into
 * received_at, which now displays +8h late. Shift it back -8h so it
 * displays the true receive wall time. Tight signature (exactly
 * ~480 min gap, user-claimed, non-create) so no genuine row can
 * match: real turnaround diffs are minutes, never exactly 8h00.
 *
 * R3 — legacy rows whose received_at was backfilled (received_by
 * NULL) and whose performed_at was later clobbered to a uniform
 * migration-time stamp: restore performed_at from received_at,
 * which still holds the true forward wall time. Post-feature rows
 * always set received_by, so they can never match.
 */
return new class extends Migration {
    public function up(): void
    {
        DB::statement("
            UPDATE `transaction_step_runs`
            SET `received_at` = `received_at` - INTERVAL 8 HOUR
            WHERE `received_by` IS NOT NULL
              AND `action_code` != 'create'
              AND TIMESTAMPDIFF(MINUTE, `performed_at`, `received_at`) BETWEEN 470 AND 490
        ");

        DB::statement("
            UPDATE `transaction_step_runs`
            SET `performed_at` = `received_at`
            WHERE `received_by` IS NULL
              AND `received_at` IS NOT NULL
              AND `performed_at` > `received_at`
        ");
    }

    public function down(): void
    {
        // Timestamp repair is not reversible.
    }
};
