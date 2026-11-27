<?php

namespace App\Http\Middleware;

use App\Models\Transaction;
use App\Services\TransactionVisibility;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Management actions (archive, unarchive, privacy) follow the same office
 * visibility as the Transactions list. Unlike workflow actions, they do not
 * require the caller to hold the current station's role.
 */
class EnsureTransactionScope
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        $transaction = $request->route('transaction');

        if ($user && $transaction instanceof Transaction && !$user->isSuperadmin()) {
            $visible = Transaction::query()->whereKey($transaction->id);
            $allowed = app(TransactionVisibility::class)->apply($visible, $user)->exists();

            if (!$allowed) {
                return response()->json(['message' => 'Forbidden.'], 403);
            }
        }

        return $next($request);
    }
}
