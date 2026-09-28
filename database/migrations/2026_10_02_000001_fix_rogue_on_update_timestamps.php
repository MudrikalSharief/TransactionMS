<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Release-time corruption fix.
 *
 * Root causes:
 *  1. Several TIMESTAMP columns carried an implicit
 *     `DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`
 *     (first-TIMESTAMP-column behavior from tables built outside
 *     migrations). Every row UPDATE — e.g. clicking Receive —
 *     silently rewrote performed_at/entered_at/checked_at to NOW().
 *  2. App works in UTC while MySQL sessions ran at SYSTEM (+08:00),
 *     stamping written instants -8h and shifting readouts +8h.
 *     (Session normalized separately via config/database.php.)
 *
 * This migration drops the auto-props and repairs rows whose
 * performed_at was clobbered: for user-received rows running
 * backwards (performed_at > received_at), the clobbered
 * performed_at value ~= true receive instant (same UPDATE event),
 * and created_at ~= true forward instant (same INSERT).
 */
return new class extends Migration {
    public function up(): void
    {
        // 1. Drop implicit DEFAULT + ON UPDATE from all rogue columns.
        DB::statement('ALTER TABLE `transaction_step_runs` MODIFY `performed_at` TIMESTAMP NULL DEFAULT NULL');
        DB::statement('ALTER TABLE `transaction_states` MODIFY `entered_at` TIMESTAMP NULL DEFAULT NULL');
        DB::statement('ALTER TABLE `transaction_requirement_checks` MODIFY `checked_at` TIMESTAMP NULL DEFAULT NULL');
        DB::statement('ALTER TABLE `transaction_checklist_checks` MODIFY `checked_at` TIMESTAMP NULL DEFAULT NULL');
        if (Schema::hasTable('transaction_station_touches')) {
            DB::statement('ALTER TABLE `transaction_station_touches` MODIFY `touched_at` TIMESTAMP NULL DEFAULT NULL');
        }

        // 2. Repair clobbered rows. Backfill-only rows (received_by NULL)
        //    and pending rows (received_at NULL) are intentionally untouched.
        DB::statement("
            UPDATE `transaction_step_runs`
            SET `received_at` = `performed_at`,
                `performed_at` = `created_at`
            WHERE `received_by` IS NOT NULL
              AND `received_at` IS NOT NULL
              AND `performed_at` > `received_at`
        ");
    }

    public function down(): void
    {
        // Data repair is not reversible; schema restores the original
        // nullability of performed_at WITHOUT re-adding the rogue
        // auto-props (re-adding them would reintroduce the bug).
        DB::statement('ALTER TABLE `transaction_step_runs` MODIFY `performed_at` TIMESTAMP NOT NULL');
    }
};
