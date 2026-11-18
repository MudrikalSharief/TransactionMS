<?php

namespace App\Http\Middleware;

use App\Models\Transaction;
use App\Services\OfficerAssignmentAccess;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class EnforceOfficerAssignment
{
    public function handle(Request $request, Closure $next): Response
    {
        $transaction = $request->route('transaction');
        $user = $request->user();
        if (!$transaction instanceof Transaction || !$user) return $next($request);

        $access = app(OfficerAssignmentAccess::class);
        if ($request->isMethodSafe()) {
            $access->assertAccess($transaction, $user);
            return $next($request);
        }

        // Serialize transaction mutations with reassignment, then recheck
        // permissions using fresh records rather than the bound snapshot.
        return DB::transaction(function () use ($request, $next, $transaction, $user, $access) {
            $fresh = Transaction::withoutGlobalScopes()
                ->whereKey($transaction->id)->whereNull('deleted_at')->lockForUpdate()->firstOrFail();
            $access->assertAccess($fresh, $user);
            $request->route()->setParameter('transaction', $fresh);
            return $next($request);
        });
    }
}
