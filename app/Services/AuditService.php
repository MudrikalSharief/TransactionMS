<?php

namespace App\Services;

use App\Models\AuditLog;
use Illuminate\Http\Request;

class AuditService
{
    public function log(Request $request, string $event, ?object $entity = null, array $meta = []): void
    {
        AuditLog::create([
            'actor_user_id' => $request->user()?->id,
            'event' => $event,
            'entity_type' => $entity ? get_class($entity) : null,
            'entity_id' => $entity?->id ?? null,
            'meta' => $meta,
            'ip' => $request->ip(),
            'user_agent' => substr((string) $request->userAgent(), 0, 512),
            'created_at' => now(),
        ]);
    }
}
