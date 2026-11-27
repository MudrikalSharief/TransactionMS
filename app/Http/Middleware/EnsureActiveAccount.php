<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Deactivated accounts keep no access through a session or API token that
 * was issued before the account was disabled.
 */
class EnsureActiveAccount
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user && $user->is_active === false) {
            return response()->json(['message' => 'Your account is inactive.'], 401);
        }

        return $next($request);
    }
}
