<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('workflow_definitions', function (Blueprint $table) {
            $table->boolean('is_live')->default(false)->after('status');
        });

        // Backfill: the highest-version published def per type becomes live.
        // Types with no published workflow get no live version. Old versions
        // are kept — only the flag moves.
        $typeIds = DB::table('workflow_definitions')
            ->select('transaction_type_id')
            ->distinct()
            ->pluck('transaction_type_id');

        foreach ($typeIds as $typeId) {
            $liveId = DB::table('workflow_definitions')
                ->where('transaction_type_id', $typeId)
                ->where('status', 'published')
                ->orderByDesc('version')
                ->value('id');

            if ($liveId) {
                DB::table('workflow_definitions')
                    ->where('id', $liveId)
                    ->update(['is_live' => true]);
            }
        }
    }

    public function down(): void
    {
        Schema::table('workflow_definitions', function (Blueprint $table) {
            $table->dropColumn('is_live');
        });
    }
};
