<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Viewer-only accounts may only use the read-only tracking API
 * (/api/viewer/*). Everything that exposes files or lets a user act on a
 * transaction answers 403 for them.
 */
class BlockViewer
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user && $user->isViewerOnly()) {
            return response()->json(['message' => 'Viewers have read-only tracking access.'], 403);
        }

        return $next($request);
    }
}
