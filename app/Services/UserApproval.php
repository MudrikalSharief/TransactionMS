<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\DB;

/**
 * Accounts created from "Create an account" on the login page wait here
 * until a superadmin (any office) or an office admin (their own office)
 * approves or rejects them.
 */
class UserApproval
{
    /** Privileged roles cannot be requested through public signup. */
    public const PROTECTED_ROLES = ['superadmin', 'admin', 'office_head'];

    public function approve(User $user, User $approver): User
    {
        abort_unless($user->isPendingApproval(), 422, 'This account is already approved.');

        $user->forceFill([
            'approved_at' => now(),
            'approved_by' => $approver->id,
            'is_active' => true,
        ])->save();

        return $user;
    }

    /** Rejecting removes the request; the person can sign up again. */
    public function reject(User $user): void
    {
        abort_unless($user->isPendingApproval(), 422, 'Only accounts waiting for approval can be rejected.');

        DB::transaction(function () use ($user) {
            $user->roles()->detach();
            $user->delete();
        });
    }
}
