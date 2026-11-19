<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Existing SLA values used 24-hour days: 1,440 minutes per day. The
     * system now counts an 8-hour working day (08:00-12:00, 13:00-17:00),
     * so values that were entered as whole days are converted to the same
     * number of working days: 2,880 -> 960, 4,320 -> 1,440.
     *
     * Values that were entered as hours/minutes are left alone.
     */
    private const OLD_DAY_MINUTES = 1440;
    private const NEW_DAY_MINUTES = 480;

    public function up(): void
    {
        $this->convert('workflow_steps', 'sla_minutes');
        $this->convert('transaction_step_runs', 'sla_minutes_snapshot');
    }

    public function down(): void
    {
        // The old value cannot be distinguished from a legitimate
        // 8/16/24-hour SLA after conversion. Restore the database backup
        // taken before this migration instead.
    }

    private function convert(string $table, string $column): void
    {
        DB::table($table)
            ->select(['id', $column])
            ->orderBy('id')
            ->chunkById(200, function ($rows) use ($table, $column) {
                foreach ($rows as $row) {
                    $value = (int) $row->{$column};
                    if ($value <= 0 || $value % self::OLD_DAY_MINUTES !== 0) continue;

                    DB::table($table)
                        ->where('id', $row->id)
                        ->update([$column => intdiv($value, self::OLD_DAY_MINUTES) * self::NEW_DAY_MINUTES]);
                }
            });
    }
};
