<?php

namespace App\Http\Middleware;

use App\Models\Transaction;
use App\Models\User;
use App\Services\RoutingEngine;
use App\Services\OfficerAssignmentAccess;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureTransactionOffice
{
    public function __construct(private readonly RoutingEngine $routing) {}

    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        $transaction = $request->route('transaction');

        if ($user && $transaction instanceof Transaction) {
            $allowed = $this->canWrite($user, $transaction);
            if (!$allowed && $request->isMethodSafe()) {
                $allowed = app(OfficerAssignmentAccess::class)->canManage($transaction, $user)
                    || app(OfficerAssignmentAccess::class)->hasOfficeAssignment($transaction, $user);
            }

            if (!$allowed) {
                return response()->json(['message' => 'Forbidden.'], 403);
            }
        }

        return $next($request);
    }

    public function canWrite(User $user, Transaction $transaction): bool
    {
        $user->loadMissing('roles');
        if ($user->roles->contains(fn ($r) => $r->code === 'superadmin')) return true;

        $ownsTransaction = $user->office_id !== null
            && $transaction->office_id !== null
            && (int) $transaction->office_id === (int) $user->office_id;

        return $ownsTransaction || $this->routing->userCanWorkOnCurrentStep($transaction, $user);
    }
}
