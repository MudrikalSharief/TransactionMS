<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Dedicated read-only office-head dashboard (/api/office-head).
 * Admin and superadmin accounts are intentionally excluded: they keep their
 * full admin area instead.
 */
class EnsureOfficeHead
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        if (!$user->isOfficeHead()) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        return $next($request);
    }
}
