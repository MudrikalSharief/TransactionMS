<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Database\Eloquent\Builder;

/**
 * Visibility rules shared by the active Transactions list and the Archive.
 *
 * Superadmins see every row. Office admins see their office's papers
 * city-wide plus anything parked at their office. Regular users see their
 * own office's rows plus rows waiting on one of their roles at their office.
 */
class TransactionVisibility
{
    public function apply(Builder $query, User $user): Builder
    {
        $user->loadMissing('roles');
        $isSuperadmin = $user->roles->contains(fn ($r) => $r->code === 'superadmin');
        if ($isSuperadmin) {
            return $query;
        }

        $roleIds = $user->roles->pluck('id')->filter()->values()->all();

        if ($user->isOfficeAdmin()) {
            // Office admins track their own office's papers city-wide
            // (the dashboard summary counts them and their detail opens
            // from there), plus anything parked at their office. Legacy
            // no-origin stations stay role-only, even for admins.
            return $query->where(function ($w) use ($roleIds, $user) {
                $w->where('transactions.office_id', $user->office_id)
                    ->orWhereHas('state.currentStep', fn ($s) => $s
                        ->whereEffectiveOffice($user->office_id))
                    ->orWhereHas('state.currentStep', function ($s) use ($roleIds) {
                        $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                            ->whereLegacyNoOriginFallback();
                    });
            });
        }

        // Regular users: their own office's transactions, plus any row whose
        // current station lists one of their roles and has their office as
        // its effective office. Blank stations follow the transaction's
        // Originating Office; end-user stations do too. Legacy no-origin
        // stations stay role-only.
        if ($user->office_id === null) {
            return $query->whereRaw('1 = 0');
        }

        if (empty($roleIds)) {
            return $query->where('transactions.office_id', $user->office_id);
        }

        return $query->where(function ($w) use ($roleIds, $user) {
            $w->where('transactions.office_id', $user->office_id)
                ->orWhereHas('state.currentStep', function ($s) use ($roleIds, $user) {
                    $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                        ->where(function ($x) use ($user) {
                            $x->whereEffectiveOffice($user->office_id)
                                ->orWhere(fn ($y) => $y->whereLegacyNoOriginFallback());
                        });
                });
        });
    }
}
