<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('audit_logs', function (Blueprint $table) {
            // Actor snapshot: the log stays readable even after a rename,
            // role change, office move or account deactivation.
            $table->string('actor_name')->nullable();
            $table->string('actor_email')->nullable();
            $table->json('actor_roles')->nullable();
            $table->unsignedBigInteger('actor_office_id')->nullable()->index();
            $table->string('actor_office_code', 50)->nullable();
            $table->boolean('actor_is_superadmin')->default(false);

            // What happened, in a form that is easy to filter and display.
            $table->string('module', 50)->nullable()->index();
            $table->string('action', 50)->nullable()->index();
            $table->string('description', 500)->nullable();

            // What was affected.
            $table->string('entity_label')->nullable();
            $table->unsignedBigInteger('office_id')->nullable()->index();
            $table->unsignedBigInteger('transaction_id')->nullable()->index();
            $table->unsignedBigInteger('step_run_id')->nullable()->index();

            // Before/after values. Only changed fields are kept.
            $table->json('old_values')->nullable();
            $table->json('new_values')->nullable();
            $table->json('changed_fields')->nullable();

            // Request context (method/path only, never the query string).
            $table->string('request_method', 10)->nullable();
            $table->string('request_path')->nullable();
            $table->uuid('request_id')->nullable()->index();

            $table->index(['actor_user_id', 'created_at']);
            $table->index(['module', 'action', 'created_at']);
            $table->index(['office_id', 'created_at']);
            $table->index(['transaction_id', 'created_at']);
            $table->index('created_at');
        });

        $this->backfillExistingRows();
    }

    public function down(): void
    {
        // Restore the class-name shape used by the previous AuditService.
        $aliases = [
            'user' => 'App\\Models\\User',
            'role' => 'App\\Models\\Role',
            'office' => 'App\\Models\\Office',
            'office_step' => 'App\\Models\\OfficeStep',
            'transaction_type' => 'App\\Models\\TransactionType',
            'government_reference' => 'App\\Models\\GovernmentReference',
            'workflow_definition' => 'App\\Models\\WorkflowDefinition',
            'workflow_step' => 'App\\Models\\WorkflowStep',
            'workflow_route' => 'App\\Models\\WorkflowRoute',
            'field_definition' => 'App\\Models\\FieldDefinition',
            'requirement_definition' => 'App\\Models\\RequirementDefinition',
            'workflow_step_data' => 'App\\Models\\WorkflowStepData',
            'transaction' => 'App\\Models\\Transaction',
            'transaction_attachment' => 'App\\Models\\TransactionAttachment',
            'transaction_requirement_check' => 'App\\Models\\TransactionRequirementCheck',
            'transaction_checklist_check' => 'App\\Models\\TransactionChecklistCheck',
        ];

        foreach ($aliases as $alias => $class) {
            DB::table('audit_logs')->where('entity_type', $alias)->update(['entity_type' => $class]);
        }

        Schema::table('audit_logs', function (Blueprint $table) {
            $table->dropIndex(['actor_user_id', 'created_at']);
            $table->dropIndex(['module', 'action', 'created_at']);
            $table->dropIndex(['office_id', 'created_at']);
            $table->dropIndex(['transaction_id', 'created_at']);
            $table->dropIndex(['created_at']);

            $table->dropColumn([
                'actor_name',
                'actor_email',
                'actor_roles',
                'actor_office_id',
                'actor_office_code',
                'actor_is_superadmin',
                'module',
                'action',
                'description',
                'entity_label',
                'office_id',
                'transaction_id',
                'step_run_id',
                'old_values',
                'new_values',
                'changed_fields',
                'request_method',
                'request_path',
                'request_id',
            ]);
        });
    }

    /**
     * Best-effort enrichment of rows written before this migration. The
     * original meta is left untouched; only the new query/display columns
     * are filled in.
     */
    private function backfillExistingRows(): void
    {
        if (DB::table('audit_logs')->count() === 0) {
            return;
        }

        $users = DB::table('users')
            ->get(['id', 'name', 'email', 'office_id'])
            ->keyBy('id');

        $offices = DB::table('offices')
            ->get(['id', 'code', 'name'])
            ->keyBy('id');

        $roleRows = DB::table('role_user')
            ->join('roles', 'roles.id', '=', 'role_user.role_id')
            ->get(['role_user.user_id', 'roles.id', 'roles.code', 'roles.name'])
            ->groupBy('user_id');

        $transactionOffices = DB::table('transactions')->pluck('office_id', 'id');
        $userOffices = DB::table('users')->pluck('office_id', 'id');
        $officeStepOffices = DB::table('office_steps')->pluck('office_id', 'id');

        $labels = [
            'user' => DB::table('users')->get(['id', 'name'])->pluck('name', 'id')->all(),
            'transaction' => DB::table('transactions')->get(['id', 'reference_number'])->pluck('reference_number', 'id')->all(),
            'role' => DB::table('roles')->get(['id', 'name'])->pluck('name', 'id')->all(),
            'office' => DB::table('offices')->get(['id', 'code', 'name'])->mapWithKeys(
                fn ($office) => [$office->id => trim($office->code . ' — ' . $office->name, ' —')]
            )->all(),
            'transaction_type' => DB::table('transaction_types')->get(['id', 'name'])->pluck('name', 'id')->all(),
            'workflow_definition' => DB::table('workflow_definitions')->get(['id', 'name', 'version'])->mapWithKeys(
                fn ($workflow) => [$workflow->id => $workflow->name ?: ('v' . $workflow->version)]
            )->all(),
            'office_step' => DB::table('office_steps')->get(['id', 'name'])->pluck('name', 'id')->all(),
            'government_reference' => DB::table('government_references')->get(['id', 'code', 'title'])->mapWithKeys(
                fn ($ref) => [$ref->id => trim($ref->code . ' — ' . $ref->title, ' —')]
            )->all(),
        ];

        DB::table('audit_logs')->orderBy('id')->chunkById(500, function ($logs) use ($users, $offices, $roleRows, $transactionOffices, $userOffices, $officeStepOffices, $labels) {
            foreach ($logs as $log) {
                $event = (string) $log->event;
                [$module, $action] = array_pad(explode('.', $event, 2), 2, null);
                $module = $module ?: null;
                $action = $action ?: null;

                $meta = json_decode((string) $log->meta, true);
                if (!is_array($meta)) {
                    $meta = [];
                }

                $old = $meta['before'] ?? $meta['old'] ?? null;
                $new = $meta['after'] ?? $meta['new'] ?? null;

                if (array_key_exists('payload', $meta)) {
                    if ($new === null && in_array($action, ['create', 'register', 'restore'], true)) {
                        $new = $meta['payload'];
                    }
                    if ($old === null && in_array($action, ['delete', 'deactivate', 'reject'], true)) {
                        $old = $meta['payload'];
                    }
                }

                $old = $this->arrayOrNull($old);
                $new = $this->arrayOrNull($new);
                $changed = $this->changedFields($old, $new);

                $alias = $this->entityAlias($log->entity_type);
                $entityId = $log->entity_id !== null ? (int) $log->entity_id : null;
                $label = $this->entityLabel($meta, $alias, $entityId, $labels);

                $actor = $log->actor_user_id !== null ? $users->get($log->actor_user_id) : null;
                $roles = $actor ? ($roleRows->get($actor->id) ?? collect()) : collect();
                $actorRoles = $roles->map(fn ($role) => [
                    'id' => (int) $role->id,
                    'code' => $role->code,
                    'name' => $role->name,
                ])->values()->all();
                $actorOffice = $actor?->office_id ? $offices->get($actor->office_id) : null;
                $isSuperadmin = collect($actorRoles)->contains(fn ($role) => $role['code'] === 'superadmin');

                $officeId = match ($alias) {
                    'transaction' => $entityId ? ($transactionOffices[$entityId] ?? null) : null,
                    'user' => $entityId ? ($userOffices[$entityId] ?? null) : null,
                    'office_step' => $entityId ? ($officeStepOffices[$entityId] ?? null) : null,
                    'office' => $entityId,
                    default => null,
                };

                DB::table('audit_logs')->where('id', $log->id)->update([
                    'actor_name' => $actor?->name,
                    'actor_email' => $actor?->email,
                    'actor_roles' => $actorRoles ? json_encode($actorRoles) : null,
                    'actor_office_id' => $actor?->office_id,
                    'actor_office_code' => $actorOffice?->code ? Str::limit($actorOffice->code, 50, '') : null,
                    'actor_is_superadmin' => $isSuperadmin,
                    'module' => $module,
                    'action' => $action,
                    'description' => $this->description($action, $label),
                    'entity_type' => $alias,
                    'entity_label' => $label,
                    'office_id' => $officeId,
                    'transaction_id' => $alias === 'transaction' ? $entityId : null,
                    'old_values' => $old !== null ? json_encode($old) : null,
                    'new_values' => $new !== null ? json_encode($new) : null,
                    'changed_fields' => $changed ? json_encode($changed) : null,
                ]);
            }
        });
    }

    private function arrayOrNull(mixed $value): ?array
    {
        return is_array($value) ? $value : null;
    }

    private function changedFields(?array $old, ?array $new): array
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

        return $changed;
    }

    private function entityAlias(?string $class): ?string
    {
        if (!$class) {
            return null;
        }

        if (!str_contains($class, '\\')) {
            return $class;
        }

        return Str::snake(class_basename($class));
    }

    private function entityLabel(array $meta, ?string $alias, ?int $entityId, array $labels): ?string
    {
        $payload = $meta['after'] ?? $meta['payload'] ?? $meta['before'] ?? [];
        if (is_array($payload)) {
            foreach (['name', 'title', 'reference_number', 'code', 'label'] as $key) {
                if (!empty($payload[$key]) && is_scalar($payload[$key])) {
                    return Str::limit((string) $payload[$key], 200);
                }
            }
        }

        if ($alias && $entityId && isset($labels[$alias][$entityId])) {
            return Str::limit((string) $labels[$alias][$entityId], 200);
        }

        return null;
    }

    private function description(?string $action, ?string $label): ?string
    {
        if (!$action) {
            return $label;
        }

        $verb = match ($action) {
            'create' => 'Created',
            'update' => 'Updated',
            'delete' => 'Deleted',
            'deactivate' => 'Deactivated',
            'approve' => 'Approved',
            'reject' => 'Rejected',
            'restore' => 'Restored',
            'archive' => 'Archived',
            'unarchive' => 'Restored',
            'register' => 'Registered',
            'publish' => 'Published',
            'save_as' => 'Saved as new version',
            'apply_staged' => 'Applied staged changes',
            'make_live' => 'Made live',
            'delete_draft' => 'Deleted draft',
            'reassign_office' => 'Office reassigned',
            'privacy' => 'Privacy changed',
            'finalize' => 'Finalized',
            'password' => 'Password changed',
            default => Str::headline($action),
        };

        return $label ? "{$verb} {$label}" : $verb;
    }
};
