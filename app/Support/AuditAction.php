<?php

namespace App\Support;

use Illuminate\Support\Str;

/**
 * Shared vocabulary and formatting for audit rows. Keeping the verb map in
 * one place means the writer (AuditService) and the reader (ActivityLog)
 * always render the same labels.
 */
class AuditAction
{
    /** Audit verbs as past tense, keyed by the action part of the event. */
    public const VERBS = [
        'create' => 'created',
        'update' => 'updated',
        'delete' => 'deleted',
        'deactivate' => 'deactivated',
        'activate' => 'activated',
        'approve' => 'approved',
        'reject' => 'rejected',
        'restore' => 'restored',
        'archive' => 'archived',
        'unarchive' => 'restored',
        'register' => 'registered',
        'publish' => 'published',
        'save_as' => 'saved as a new version',
        'apply_staged' => 'applied staged changes',
        'make_live' => 'made live',
        'delete_draft' => 'deleted draft',
        'reassign_office' => 'office reassigned',
        'privacy' => 'privacy changed',
        'finalize' => 'finalized',
        'password' => 'password changed',
        'sync' => 'saved',
        'resync' => 'resynced',
        'steps_sync' => 'steps updated',
        'check' => 'checked',
        'uncheck' => 'unchecked',
        'upload' => 'uploaded',
        'reuse' => 'linked',
        'unlink' => 'unlinked',
        'fields_update' => 'fields updated',
        'attachment_upload' => 'attachment uploaded',
        'attachment_reuse' => 'attachment linked',
        'attachment_unlink' => 'attachment unlinked',
        'attachment_delete' => 'attachment deleted',
        'requirement_check' => 'requirement checked',
        'requirement_uncheck' => 'requirement unchecked',
        'checklist_check' => 'checklist item checked',
        'checklist_uncheck' => 'checklist item unchecked',
    ];

    /** Sensitive keys that must never reach the audit table. */
    public const REDACTED_KEYS = [
        'password',
        'password_confirmation',
        'current_password',
        'remember_token',
        'token',
        'access_token',
        'refresh_token',
        'secret',
        'authorization',
    ];

    /**
     * Raw old/new keys mapped to a friendly label and the label category
     * used by the Activity Log resolver.
     *
     * @var array<string, array{0: string, 1: string}>
     */
    private const FIELD_LABELS = [
        'office_id' => ['office', 'office'],
        'office_ids' => ['offices', 'office'],
        'actor_office_id' => ['actor office', 'office'],
        'createdby_office' => ['created by office', 'office'],
        'role_id' => ['role', 'role'],
        'role_ids' => ['roles', 'role'],
        'user_id' => ['user', 'user'],
        'user_ids' => ['users', 'user'],
        'created_by' => ['created by', 'user'],
        'approved_by' => ['approved by', 'user'],
        'checked_by' => ['checked by', 'user'],
        'uploaded_by' => ['uploaded by', 'user'],
        'actor_user_id' => ['actor', 'user'],
        'transaction_id' => ['transaction', 'transaction'],
        'transaction_ids' => ['transactions', 'transaction'],
        'transaction_type_id' => ['process', 'transaction_type'],
        'workflow_definition_id' => ['workflow', 'workflow_definition'],
        'live_id' => ['live workflow', 'workflow_definition'],
        'source_id' => ['source workflow', 'workflow_definition'],
        'workflow_step_id' => ['step', 'workflow_step'],
        'workflow_step_ids' => ['steps', 'workflow_step'],
        'from_step_id' => ['from step', 'workflow_step'],
        'to_step_id' => ['to step', 'workflow_step'],
        'step_ids' => ['steps', 'workflow_step'],
        'field_definition_id' => ['field', 'field_definition'],
        'field_definition_ids' => ['fields', 'field_definition'],
        'requirement_definition_id' => ['requirement', 'requirement_definition'],
        'requirement_definition_ids' => ['requirements', 'requirement_definition'],
        'checklist_override_id' => ['item', 'checklist_override'],
        'checklist_override_ids' => ['items', 'checklist_override'],
        'attachment_id' => ['file', 'attachment'],
        'attachment_ids' => ['files', 'attachment'],
        'source_attachment_id' => ['source file', 'attachment'],
    ];

    public static function splitEvent(string $event): array
    {
        return array_pad(explode('.', $event, 2), 2, null);
    }

    public static function verb(?string $action): string
    {
        if (!$action) {
            return 'changed';
        }

        return self::VERBS[$action] ?? Str::lower(Str::headline($action));
    }

    public static function description(?string $action, ?string $label): ?string
    {
        if (!$action) {
            return $label;
        }

        $verb = Str::ucfirst(self::verb($action));

        return $label ? "{$verb} {$label}" : $verb;
    }

    public static function subjectLabel(object $entity): ?string
    {
        if (isset($entity->reference_number) && $entity->reference_number !== '') {
            return Str::limit((string) $entity->reference_number, 200);
        }

        if (isset($entity->name) && $entity->name !== '') {
            $name = (string) $entity->name;

            if (isset($entity->version) && $entity->version !== null && $entity->version !== '') {
                $name .= ' v' . $entity->version;
            }

            return Str::limit($name, 200);
        }

        foreach (['display_name', 'title', 'original_name', 'label', 'code'] as $attribute) {
            if (isset($entity->{$attribute}) && $entity->{$attribute} !== '') {
                return Str::limit((string) $entity->{$attribute}, 200);
            }
        }

        return null;
    }

    /**
     * The list of keys whose values differ between the two snapshots.
     * When only one side exists (create/delete) every key counts.
     */
    public static function changedFields(?array $old, ?array $new): array
    {
        if ($old === null && $new === null) {
            return [];
        }

        $keys = array_unique(array_merge(
            $old ? array_keys($old) : [],
            $new ? array_keys($new) : []
        ));

        $changed = [];
        foreach ($keys as $key) {
            if (($old[$key] ?? null) != ($new[$key] ?? null)) {
                $changed[] = $key;
            }
        }

        return array_values($changed);
    }

    public static function changeSummary(
        ?array $old,
        ?array $new,
        ?array $fields = null,
        array $labels = [],
        ?string $module = null
    ): ?string {
        $old = $old ?? [];
        $new = $new ?? [];
        $fields = $fields ?: self::changedFields($old, $new);

        if (!$fields) {
            return null;
        }

        $hasOld = count($old) > 0;
        $hasNew = count($new) > 0;

        $parts = [];
        foreach ($fields as $field) {
            [$label, $beforeValue] = self::displayField($field, $old[$field] ?? null, $module, $labels);
            if ($label === null) {
                continue;
            }

            // If the payload already contains the friendly key (for example
            // "requirement" beside "requirement_definition_id"), do not show
            // the same thing twice.
            if ($label !== $field && in_array($label, $fields, true)) {
                continue;
            }

            [, $afterValue] = self::displayField($field, $new[$field] ?? null, $module, $labels);

            $before = self::display($beforeValue);
            $after = self::display($afterValue);

            if ($before === $after) {
                continue;
            }

            if (!$hasOld && $hasNew) {
                // A create: list the values that were added.
                $parts[] = "{$label}: {$after}";
            } elseif ($hasOld && !$hasNew) {
                // A delete/archive/reject: list the values that were removed.
                $parts[] = "{$label}: {$before}";
            } elseif ($before === '(empty)') {
                $parts[] = "{$label}: {$after}";
            } elseif ($after === '(empty)') {
                $parts[] = "{$label}: {$before} → (empty)";
            } else {
                $parts[] = "{$label}: {$before} → {$after}";
            }
        }

        return $parts ? Str::limit(implode('; ', $parts), 400) : null;
    }

    /**
     * The label category used to resolve one raw old/new key.
     * Null means the key is not an entity reference.
     */
    public static function labelCategory(string $field, ?string $module = null): ?string
    {
        if ($field === 'parent_id') {
            return $module === 'office_steps' ? 'office_step' : 'workflow_step';
        }

        return self::FIELD_LABELS[$field][1] ?? null;
    }

    /**
     * Resolve one old/new value to its friendly display label.
     *
     * @return array{0: ?string, 1: mixed} [display label, display value]
     */
    private static function displayField(string $field, mixed $value, ?string $module, array $labels): array
    {
        // Internal correlation keys are not useful in the human summary.
        if ($field === 'step_run_id') {
            return [null, null];
        }

        $map = self::fieldMap($field, $module);
        if ($map === null) {
            return [$field, self::complexValue($field, $value, $labels)];
        }

        [$label, $category] = $map;

        if (!array_key_exists($category, $labels)) {
            return [$label, self::complexValue($field, $value, $labels)];
        }

        if (is_array($value)) {
            if (!$value) {
                return [$label, 'none'];
            }

            $names = [];
            foreach ($value as $id) {
                if (!is_scalar($id) || !is_numeric($id)) {
                    return [$label, self::complexValue($field, $value, $labels)];
                }
                $names[] = $labels[$category][(int) $id] ?? '(deleted)';
            }

            return [$label, implode(', ', $names)];
        }

        if ($value === null || $value === '') {
            return [$label, $value];
        }

        if (!is_scalar($value) || !is_numeric($value)) {
            return [$label, $value];
        }

        return [$label, $labels[$category][(int) $value] ?? '(deleted)'];
    }

    /** @return array{0: string, 1: string}|null */
    private static function fieldMap(string $field, ?string $module): ?array
    {
        if ($field === 'parent_id') {
            return $module === 'office_steps'
                ? ['parent', 'office_step']
                : ['parent', 'workflow_step'];
        }

        return self::FIELD_LABELS[$field] ?? null;
    }

    /**
     * Readable summaries for nested arrays that contain IDs but also carry
     * a human name (field assignments, requirement bindings, checklist items).
     */
    private static function complexValue(string $field, mixed $value, array $labels): mixed
    {
        if (!is_array($value)) {
            return $value;
        }

        if ($field === 'fields' && isset($labels['field_definition'])) {
            $names = [];
            foreach ($value as $item) {
                if (is_array($item) && isset($item['field_definition_id']) && is_numeric($item['field_definition_id'])) {
                    $names[] = $labels['field_definition'][(int) $item['field_definition_id']] ?? '(deleted)';
                }
            }
            if ($names) {
                return implode(', ', array_values(array_unique($names)));
            }
        }

        if ($field === 'requirements' && isset($labels['requirement_definition'])) {
            $names = [];
            foreach ($value as $item) {
                if (is_array($item) && isset($item['requirement_definition_id']) && is_numeric($item['requirement_definition_id'])) {
                    $names[] = $labels['requirement_definition'][(int) $item['requirement_definition_id']] ?? '(deleted)';
                }
            }
            if ($names) {
                return implode(', ', array_values(array_unique($names)));
            }
        }

        if ($field === 'items') {
            $names = [];
            foreach ($value as $item) {
                if (is_array($item) && isset($item['name'])) {
                    $names[] = (string) $item['name'];
                }
            }
            if ($names) {
                return implode(', ', array_values(array_unique($names)));
            }
        }

        if ($field === 'definitions' && isset($labels['requirement_definition'])) {
            $names = [];
            foreach (array_keys($value) as $key) {
                if (is_numeric($key)) {
                    $names[] = $labels['requirement_definition'][(int) $key] ?? '(deleted)';
                }
            }
            if ($names) {
                return implode(', ', array_values(array_unique($names)));
            }
        }

        if (!$value) {
            return 'none';
        }

        return $value;
    }

    /** Recursively replace sensitive values before storing a snapshot. */
    public static function redact(mixed $value): mixed
    {
        if (!is_array($value)) {
            return $value;
        }

        $clean = [];
        foreach ($value as $key => $item) {
            if (is_string($key) && in_array(strtolower($key), self::REDACTED_KEYS, true)) {
                $clean[$key] = '[redacted]';
                continue;
            }

            $clean[$key] = self::redact($item);
        }

        return $clean;
    }

    private static function display(mixed $value): string
    {
        if (is_bool($value)) {
            return $value ? 'true' : 'false';
        }

        if ($value === null || $value === '') {
            return '(empty)';
        }

        if (is_array($value) || is_object($value)) {
            $encoded = json_encode($value, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

            return Str::limit($encoded ?: '(empty)', 80);
        }

        return Str::limit((string) $value, 80);
    }
}
