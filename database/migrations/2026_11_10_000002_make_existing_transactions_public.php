<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Normalize every existing transaction to Public (is_private = false).
 *
 * The earlier semantics migration preserved old visibility, which left most
 * existing rows Private because the old default (false) meant hidden. The
 * product now treats is_private = false as Public/searchable, so this one-time
 * reset makes all existing transactions Public. New rows already default to
 * false.
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::table('transactions')->update([
            'is_private' => false,
        ]);
    }

    public function down(): void
    {
        // One-way data normalization: the previous per-row privacy mix cannot
        // be reconstructed after every row is made Public.
    }
};
