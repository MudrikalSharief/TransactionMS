<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Models\TransactionStepRun;
use App\Models\User;

/**
 * Which steps' files a user may open on a transaction.
 *
 * Rule: a step only works with the files of the step before it, so a
 * station sees the previous step's files (plus its own current-step
 * uploads), never earlier ones. Example: at step 3 you can open step 2's
 * files but not step 1's.
 *
 * "Previous step" = the step one order number lower (the same rule file
 * reuse uses) and, when it differs, the step the transaction was actually
 * sent from (e.g. after a return).
 *
 * Superadmin and admins keep access to every step for oversight.
 */
class StepFileAccess
{
    private const UNRESTRICTED_ROLES = ['superadmin', 'admin'];

    /** @return int[]|null step ids the user may open files from; null = all. */
    public function allowedStepIds(Transaction $tx, ?User $user): ?array
    {
        if (!$user) return null;

        $user->loadMissing('roles');
        if ($user->roles->contains(fn ($r) => in_array($r->code, self::UNRESTRICTED_ROLES, true))) {
            return null;
        }

        $tx->loadMissing(['state.currentStep', 'workflow.steps']);
        $current = $tx->state?->currentStep;
        if (!$current) return [];

        $ids = [(int) $current->id];

        $previous = collect($tx->workflow?->steps ?? [])
            ->firstWhere(fn ($s) => (int) $s->order_number === (int) $current->order_number - 1);
        if ($previous) $ids[] = (int) $previous->id;

        $sentFrom = TransactionStepRun::query()
            ->where('transaction_id', $tx->id)
            ->where('to_step_id', $current->id)
            ->orderByDesc('performed_at')
            ->orderByDesc('id')
            ->value('from_step_id');
        if ($sentFrom) $ids[] = (int) $sentFrom;

        return array_values(array_unique($ids));
    }

    public function canOpen(Transaction $tx, ?User $user, TransactionAttachment $attachment): bool
    {
        $allowed = $this->allowedStepIds($tx, $user);

        return $allowed === null || in_array((int) $attachment->workflow_step_id, $allowed, true);
    }
}
