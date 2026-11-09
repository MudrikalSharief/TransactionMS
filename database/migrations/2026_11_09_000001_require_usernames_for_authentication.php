<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        // Preserve assigned usernames, account IDs, passwords, and email history.
        // Work directly with rows so future model events cannot alter this migration.
        $occupied = [];
        foreach (DB::table('users')->whereNotNull('username')->pluck('username') as $username) {
            $occupied[strtolower($username)] = true;
        }

        DB::table('users')->where(function ($query) {
            $query->whereNull('username')->orWhereRaw("TRIM(username) = ''");
        })->orderBy('id')->chunkById(200, function ($users) use (&$occupied) {
            foreach ($users as $user) {
                $base = trim(preg_replace('/[^a-z0-9]+/', '.', Str::lower(Str::ascii($user->name))), '.');
                $base = strlen($base) < 3 ? 'user' : rtrim(substr($base, 0, 30), '.');
                $candidate = $base;
                $number = 1;
                while (isset($occupied[$candidate])) {
                    $suffix = '.' . $user->id . ($number > 1 ? '.' . $number : '');
                    $candidate = rtrim(substr($base, 0, 30 - strlen($suffix)), '.') . $suffix;
                    $number++;
                }
                DB::table('users')->where('id', $user->id)->update(['username' => $candidate]);
                $occupied[$candidate] = true;
            }
        });

        Schema::table('users', function (Blueprint $table) {
            $table->string('username', 30)->nullable(false)->change();
            $table->string('email')->nullable()->change();
        });

        if (!Schema::hasIndex('users', ['username'], 'unique')) {
            Schema::table('users', fn (Blueprint $table) => $table->unique('username'));
        }
    }

    public function down(): void
    {
        // Restoring required email must never invent addresses or delete users.
        if (DB::table('users')->whereNull('email')->exists()) {
            throw new RuntimeException('Cannot restore required email while accounts without email exist.');
        }

        Schema::table('users', function (Blueprint $table) {
            $table->string('username', 30)->nullable()->change();
            $table->string('email')->nullable(false)->change();
        });
    }
};
