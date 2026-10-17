<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsurePermission
{
    /**
     * Accepts one permission code or several pipe-separated codes
     * ("roles.view|users.view"): the request passes when the user holds
     * any of them. Superadmin always passes (User::hasPermission).
     */
    public function handle(Request $request, Closure $next, string $permissions): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        foreach (array_filter(array_map('trim', explode('|', $permissions))) as $code) {
            if (method_exists($user, 'hasPermission') && $user->hasPermission($code)) {
                return $next($request);
            }
        }

        return response()->json(['message' => 'Forbidden.'], 403);
    }
}
