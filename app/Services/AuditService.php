<?php

namespace App\Services;

use App\Models\AuditLog;
use App\Models\Transaction;
use App\Support\AuditAction;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class AuditService
{
    /**
     * Write one append-only audit row.
     *
     * Existing callers keep the original signature. New callers may pass
     * "before"/"after" (or "old"/"new") snapshots in $meta; the service
     * normalises them into the dedicated columns and keeps any remaining
     * keys in meta for extra context.
     */
    public function log(?Request $request, string $event, ?object $entity = null, array $meta = []): void
    {
        $request ??= request();
        $request ??= new Request();

        [$eventModule, $eventAction] = AuditAction::splitEvent($event);
        $module = $meta['module'] ?? $eventModule;
        $action = $meta['action'] ?? $eventAction;

        $old = $meta['before'] ?? $meta['old'] ?? null;
        $new = $meta['after'] ?? $meta['new'] ?? null;
        $payload = $meta['payload'] ?? null;
        $payloadUsedAsChange = false;

        if ($payload !== null) {
            if ($new === null && in_array($action, ['create', 'register', 'restore'], true)) {
                $new = $payload;
                $payloadUsedAsChange = true;
            } elseif ($old === null && in_array($action, ['delete', 'deactivate', 'reject'], true)) {
                $old = $payload;
                $payloadUsedAsChange = true;
            }
        }

        $old = $this->arrayOrNull(AuditAction::redact($old));
        $new = $this->arrayOrNull(AuditAction::redact($new));

        if ($old !== null && $new !== null) {
            $changed = AuditAction::changedFields($old, $new);
            $old = array_intersect_key($old, array_flip($changed));
            $new = array_intersect_key($new, array_flip($changed));

            if (!$changed) {
                $old = null;
                $new = null;
            }
        } else {
            $changed = AuditAction::changedFields($old, $new);
        }

        $actor = $request->user() ?? auth()->user();
        $actor?->loadMissing(['roles', 'office']);

        $actorRoles = $actor?->roles?->map(fn ($role) => [
            'id' => (int) $role->id,
            'code' => $role->code,
            'name' => $role->name,
        ])->values()->all() ?? [];

        $actorOffice = $actor?->office;

        $entityType = $entity ? Str::snake(class_basename($entity)) : ($meta['entity_type'] ?? null);
        $entityId = $entity?->id ?? ($meta['entity_id'] ?? null);
        $entityLabel = $meta['entity_label'] ?? ($entity ? AuditAction::subjectLabel($entity) : null);
        $entityLabel = $entityLabel !== null ? Str::limit((string) $entityLabel, 255, '') : null;

        $transactionId = $meta['transaction_id'] ?? null;
        if ($transactionId === null && $entity instanceof Transaction) {
            $transactionId = $entity->id;
        } elseif ($transactionId === null && isset($entity->transaction_id)) {
            $transactionId = $entity->transaction_id;
        }

        $officeId = $meta['office_id'] ?? null;
        if ($officeId === null && isset($entity->office_id)) {
            $officeId = $entity->office_id;
        }

        $stepRunId = $meta['step_run_id'] ?? null;
        $description = $meta['description'] ?? AuditAction::description($action, $entityLabel);
        $description = $description !== null ? Str::limit((string) $description, 500, '') : null;
        $module = $module !== null ? Str::limit((string) $module, 50, '') : null;
        $action = $action !== null ? Str::limit((string) $action, 50, '') : null;

        // Keep extra context only; the moved keys have their own columns.
        unset(
            $meta['before'],
            $meta['after'],
            $meta['old'],
            $meta['new'],
            $meta['module'],
            $meta['action'],
            $meta['description'],
            $meta['entity_type'],
            $meta['entity_id'],
            $meta['entity_label'],
            $meta['office_id'],
            $meta['transaction_id'],
            $meta['step_run_id'],
        );

        if ($payload !== null && !$payloadUsedAsChange) {
            $meta['payload'] = $payload;
        }

        $meta = AuditAction::redact($meta);

        AuditLog::create([
            'actor_user_id' => $actor?->id,
            'actor_name' => $actor?->name,
            'actor_email' => $actor?->email,
            'actor_roles' => $actorRoles ?: null,
            'actor_office_id' => $actor?->office_id,
            'actor_office_code' => $actorOffice?->code ? Str::limit($actorOffice->code, 50, '') : null,
            'actor_is_superadmin' => (bool) $actor?->isSuperadmin(),
            'event' => $event,
            'module' => $module,
            'action' => $action,
            'description' => $description,
            'entity_type' => $entityType,
            'entity_id' => $entityId,
            'entity_label' => $entityLabel,
            'office_id' => $officeId,
            'transaction_id' => $transactionId,
            'step_run_id' => $stepRunId,
            'old_values' => $old,
            'new_values' => $new,
            'changed_fields' => $changed ?: null,
            'meta' => $meta ?: null,
            'ip' => $request->ip(),
            'user_agent' => $request->userAgent() ? Str::limit($request->userAgent(), 512, '') : null,
            'request_method' => $request->method(),
            'request_path' => Str::limit('/' . ltrim($request->path(), '/'), 255, ''),
            'request_id' => $this->requestId($request),
            'created_at' => now(),
        ]);
    }

    private function requestId(Request $request): string
    {
        $id = $request->attributes->get('audit_request_id');

        if (!$id) {
            $id = $request->header('X-Request-ID') ?: (string) Str::uuid();
            $request->attributes->set('audit_request_id', $id);
        }

        return $id;
    }

    private function arrayOrNull(mixed $value): ?array
    {
        return is_array($value) ? $value : null;
    }
}
