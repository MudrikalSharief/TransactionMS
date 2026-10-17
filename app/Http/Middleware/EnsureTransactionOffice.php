<?php

namespace App\Http\Middleware;

use App\Models\Transaction;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureTransactionOffice
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        $transaction = $request->route('transaction');

        if ($user && $transaction instanceof Transaction && !$user->hasRole('superadmin')) {
            if ($transaction->office_id === null
                || (int) $transaction->office_id !== (int) $user->office_id) {
                return response()->json(['message' => 'Forbidden.'], 403);
            }
        }

        return $next($request);
    }
}
