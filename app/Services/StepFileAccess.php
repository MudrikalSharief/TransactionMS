<?php

namespace App\Services;

use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Models\TransactionStepRun;
use App\Models\User;
use Illuminate\Support\Facades\DB;

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
 * Superadmin and office admins keep access to every step for oversight.
 */
class StepFileAccess
{
    private const UNRESTRICTED_ROLES = [...Role::OFFICE_ADMIN_ROLE_CODES, 'superadmin'];

    /** @return int[]|null step ids the user may open files from; null = all. */
    public function allowedStepIds(Transaction $tx, ?User $user): ?array
    {
        if (!$user) return null;
        if (!app(OfficerAssignmentAccess::class)->canAccess($tx, $user)) return [];

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

        $lastRun = TransactionStepRun::query()
            ->where('transaction_id', $tx->id)
            ->where('to_step_id', $current->id)
            ->orderByDesc('performed_at')
            ->orderByDesc('id')
            ->first(['from_step_id', 'action_code', 'flagged_items']);
        if ($lastRun?->from_step_id) $ids[] = (int) $lastRun->from_step_id;

        // Returned items must be readable at the station that has to fix
        // them. Flags may point at a requirement owned by an earlier
        // station (not the station that returned the paper), so include
        // every owning step of the latest return's flagged requirements.
        if ($lastRun?->action_code === 'return') {
            $flaggedReqIds = collect($lastRun->flagged_items ?? [])
                ->pluck('requirement_definition_id')
                ->filter()
                ->map(fn ($id) => (int) $id)
                ->unique()
                ->values()
                ->all();
            if ($flaggedReqIds) {
                $ownerStepIds = DB::table('step_requirements')
                    ->whereIn('requirement_definition_id', $flaggedReqIds)
                    ->whereIn('workflow_step_id', collect($tx->workflow?->steps ?? [])->pluck('id'))
                    ->pluck('workflow_step_id')
                    ->map(fn ($id) => (int) $id)
                    ->all();
                $ids = array_merge($ids, $ownerStepIds);
            }
        }

        return array_values(array_unique($ids));
    }

    public function canOpen(Transaction $tx, ?User $user, TransactionAttachment $attachment): bool
    {
        $allowed = $this->allowedStepIds($tx, $user);

        return $allowed === null || in_array((int) $attachment->workflow_step_id, $allowed, true);
    }
}
