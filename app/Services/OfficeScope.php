<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;

/**
 * The transactions an office admin oversees: those filed by their office,
 * plus any whose pinned workflow has a step assigned to their office.
 */
class OfficeScope
{
    public function apply(Builder $query, int $officeId): Builder
    {
        return $query->where(fn ($w) => $w
            ->where('transactions.office_id', $officeId)
            ->orWhereHas('workflow.steps', fn ($s) => $s->where('office_id', $officeId)));
    }

    public function covers(Transaction $tx, User $user): bool
    {
        if (!$user->isOfficeAdmin()) return false;

        $officeId = (int) $user->office_id;
        if ((int) $tx->office_id === $officeId) return true;

        $tx->loadMissing('workflow.steps');

        return (bool) $tx->workflow?->steps->contains(fn ($s) => (int) $s->office_id === $officeId);
    }
}
