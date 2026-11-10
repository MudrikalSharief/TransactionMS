<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * The original privacy feature stored the toggle backwards relative to its
 * name: is_private = true meant "searchable on Track" and false meant hidden.
 * The UI now uses the natural meaning (true = private/hidden, false = public).
 *
 * Flip existing rows once so their current Track visibility does not change:
 * rows that were visible become public (false), rows that were hidden become
 * private (true). New rows default to false, i.e. public/searchable.
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::table('transactions')->update([
            'is_private' => DB::raw('CASE WHEN is_private = 1 THEN 0 ELSE 1 END'),
        ]);
    }

    public function down(): void
    {
        DB::table('transactions')->update([
            'is_private' => DB::raw('CASE WHEN is_private = 1 THEN 0 ELSE 1 END'),
        ]);
    }
};
