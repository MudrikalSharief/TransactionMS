<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Office codes are uppercase by convention (OCM, GSO, LEGAL, ...).
     * A couple of older rows were created in lowercase; normalize them so
     * the new form/API rule matches every existing record.
     */
    public function up(): void
    {
        DB::table('offices')
            ->select('id', 'code')
            ->orderBy('id')
            ->chunkById(100, function ($offices) {
                foreach ($offices as $office) {
                    $code = strtoupper(trim((string) $office->code));

                    if ($code === '' || $code === $office->code) {
                        continue;
                    }

                    // Never let a case-only duplicate break the unique index.
                    $taken = DB::table('offices')
                        ->where('id', '!=', $office->id)
                        ->whereRaw('UPPER(code) = ?', [$code])
                        ->exists();

                    if ($taken) {
                        continue;
                    }

                    DB::table('offices')
                        ->where('id', $office->id)
                        ->update([
                            'code' => $code,
                            'updated_at' => now(),
                        ]);
                }
            });

        try {
            Cache::forget('lookup:offices');
        } catch (\Throwable $e) {
            // Cache can be cleared separately; don't fail the data migration.
        }
    }

    public function down(): void
    {
        // Data-only normalization: the original casing cannot be recovered
        // reliably, so leave the uppercase codes in place.
    }
};
