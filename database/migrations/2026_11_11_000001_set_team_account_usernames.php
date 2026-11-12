<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    // Shared team passwords, stored scrambled (the team's admin and clerk
    // passwords are listed in docs/09-setup.md).
    private const ADMIN_PASSWORD = '$2y$12$0qYrVEsSWeB1IRG9q7pAYefTu456iEGLGc26EfllLoZprYDLUTLX2';
    private const CLERK_PASSWORD = '$2y$12$ltoKX1HY3cj9SpdCRVgFS.LgjKGN7WsEqvFHIoNu5HFmCiaJMd7YK';

    // Accounts found by email: username from role and office, and the
    // password to set (null leaves it as it is).
    private const ACCOUNTS = [
        'vinzmuloc@gmail.com' => ['superadmin', self::ADMIN_PASSWORD],
        'admin@gmail.com' => ['csdadmin', self::ADMIN_PASSWORD],
        'johnrey.wee.csd@gmail.com' => ['csdclerk', self::CLERK_PASSWORD],
        'juandela@gmail.com' => ['csdclerk2', self::CLERK_PASSWORD],
        'mtclimaco.ocm@gmail.com' => ['ocmclerk', self::CLERK_PASSWORD],
        'ramon.enriquez.zc@gmail.com' => ['ocasclerk', self::CLERK_PASSWORD],
        'angelicamae.navarro@gmail.com' => ['chrmoclerk', self::CLERK_PASSWORD],
        'rhealyn.francisco.gso@gmail.com' => ['gsoclerk', self::CLERK_PASSWORD],
        'cmsaavedra.budget@gmail.com' => ['ocbclerk', self::CLERK_PASSWORD],
        'awdjawjkdn@gmail.occm' => ['ocbclerk2', self::CLERK_PASSWORD],
        'arnel.go.paad@gmail.com' => ['paadclerk', self::CLERK_PASSWORD],
        'enduser@lgu.test' => ['enduser', null],
        'viewer@lgu.test' => ['viewer', null],
    ];

    public function up(): void
    {
        $ids = [];
        foreach (self::ACCOUNTS as $email => [$username]) {
            $id = DB::table('users')->whereRaw('LOWER(email) = ?', [$email])->value('id');
            if ($id !== null) {
                $ids[$email] = $id;
            }
        }
        if (!$ids) {
            return;
        }

        DB::transaction(function () use ($ids) {
            // Free the names first, so two accounts can swap names safely.
            foreach ($ids as $id) {
                DB::table('users')->where('id', $id)->update(['username' => 'tmp.' . $id]);
            }
            foreach ($ids as $email => $id) {
                [$username, $password] = self::ACCOUNTS[$email];
                // Another account already holds this name: keep a unique one.
                if (DB::table('users')->where('username', $username)->where('id', '!=', $id)->exists()) {
                    $username = $username . '.' . $id;
                }
                $set = ['username' => $username, 'updated_at' => now()];
                if ($password !== null) {
                    $set['password'] = $password;
                }
                DB::table('users')->where('id', $id)->update($set);
            }
        });
    }

    public function down(): void
    {
        // Old usernames and passwords are not kept; nothing to undo.
    }
};
