<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // is_private ON means PUBLIC: viewers can find and open the transaction
    // on Track (the column name is historical, see Transaction::$attributes).
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->boolean('is_private')->default(true)->change();
        });

        // Every existing transaction becomes public.
        DB::table('transactions')->where('is_private', false)->update(['is_private' => true]);
    }

    public function down(): void
    {
        // Only the column default goes back; rows stay public.
        Schema::table('transactions', function (Blueprint $table) {
            $table->boolean('is_private')->default(false)->change();
        });
    }
};
