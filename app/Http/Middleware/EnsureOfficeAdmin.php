<?php

namespace App\Http\Middleware;

use App\Models\Role;
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
            $hasOfficeAdminRole = $user->roles->contains(
                fn ($role) => in_array($role->code, Role::OFFICE_ADMIN_ROLE_CODES, true)
            );
            $message = $hasOfficeAdminRole
                ? 'Your account has an office-admin role but no office assigned. Ask a superadmin to set one.'
                : 'Forbidden.';

            return response()->json(['message' => $message], 403);
        }

        return $next($request);
    }
}
