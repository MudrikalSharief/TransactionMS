<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transaction_officer_assignments', function (Blueprint $table) {
            $table->boolean('is_automatic')->default(false);
        });
    }

    public function down(): void
    {
        Schema::table('transaction_officer_assignments', fn (Blueprint $table) => $table->dropColumn('is_automatic'));
    }
};
