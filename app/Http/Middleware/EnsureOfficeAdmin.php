<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Office admin area (/api/office): admin role plus an assigned office.
 * An admin without an office has no scope, so they are turned away too.
 */
class EnsureOfficeAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        if (!$user->isSuperadmin() && !$user->isOfficeAdmin()) {
            $message = $user->hasRole('admin')
                ? 'Your admin account has no office assigned. Ask a superadmin to set one.'
                : 'Forbidden.';

            return response()->json(['message' => $message], 403);
        }

        return $next($request);
    }
}
