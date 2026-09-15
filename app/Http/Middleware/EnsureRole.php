<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureRole
{
    public function handle(Request $request, Closure $next, string $roleCode): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        if (method_exists($user, 'hasRole') && $user->hasRole($roleCode)) {
            return $next($request);
        }

        return response()->json(['message' => 'Forbidden.'], 403);
    }
}
