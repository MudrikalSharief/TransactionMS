<?php

namespace App\Http\Middleware;

use App\Models\Transaction;
use App\Services\RoutingEngine;
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
            $user->loadMissing('roles');

            $isSuperadmin = $user->roles->contains(fn ($r) => $r->code === 'superadmin');
            $allowed = $isSuperadmin;

            if (!$allowed) {
                // Their own office's paper, wherever it currently sits —
                // staff and office admins alike: the dashboard summary
                // lists these rows, so the detail must open from there.
                // Otherwise a station they can work: their roles at their
                // office, or (office admins) any station parked at their
                // office. Write routes keep their own deeper gates
                // (assertUserCanExecute).
                $ownsTransaction = $user->office_id !== null
                    && $transaction->office_id !== null
                    && (int) $transaction->office_id === (int) $user->office_id;

                $allowed = $ownsTransaction
                    || $this->routing->userCanWorkOnCurrentStep($transaction, $user);
            }

            if (!$allowed) {
                return response()->json(['message' => 'Forbidden.'], 403);
            }
        }

        return $next($request);
    }
}
