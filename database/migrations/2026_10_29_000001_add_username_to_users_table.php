<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Optional sign-in name: people can sign in with their username or
     * email. Unique so it identifies exactly one account; stored lowercase.
     *
     * Some databases already have a `username` column added outside the
     * migrations (varchar(255) NOT NULL, every row ''). There it is reshaped:
     * 30 chars, nullable, '' becomes NULL (no username; the unique index
     * allows many NULLs but only one ''), then made unique. Existing
     * accounts keep signing in by email.
     */
    public function up(): void
    {
        if (Schema::hasColumn('users', 'username')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('username', 30)->nullable()->change();
            });
            DB::table('users')->where('username', '')->update(['username' => null]);
            Schema::table('users', function (Blueprint $table) {
                $table->unique('username');
            });

            return;
        }

        Schema::table('users', function (Blueprint $table) {
            $table->string('username', 30)->nullable()->unique()->after('name');
        });
    }

    /** Back to the earlier shape: no index, varchar(255) NOT NULL, '' for none. */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique(['username']);
        });
        DB::table('users')->whereNull('username')->update(['username' => '']);
        Schema::table('users', function (Blueprint $table) {
            $table->string('username', 255)->nullable(false)->change();
        });
    }
};
