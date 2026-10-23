<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/** Gate for the viewer tracking API: viewer-only accounts only. */
class EnsureViewer
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user || !$user->isViewerOnly()) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        return $next($request);
    }
}
