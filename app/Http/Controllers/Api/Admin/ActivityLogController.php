<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Office;
use App\Models\TransactionStepRun;
use App\Models\User;
use App\Services\OfficeScope;
use App\Support\AuditAction;
use App\Support\ReportPeriod;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Activity log (read-only): who did what, and when.
 *   transactions  every step run (created, forwarded, returned, finalized…)
 *                 plus its receipt, from transaction_step_runs; office admins
 *                 see their office's scope (filed by or passing through it)
 *   setup         the audit log (accounts, roles, offices, workflows…),
 *                 superadmins only
 * Nothing is written.
 */
class ActivityLogController extends Controller
{
    /** Newest rows read per source; the page shows the latest activity. */
    private const LIMIT = 5000;

    private const ACTIONS = [
        'create' => 'Created',
        'submit' => 'Forwarded',
        'approve' => 'Approved',
        'return' => 'Returned',
        'resend' => 'Resent',
        'rewind' => 'Sent back',
        'revisit' => 'Revisited',
        'finalize' => 'Finalized',
    ];

    /** Human labels for modules whose plural does not singularise cleanly. */
    private const MODULE_LABELS = [
        'workflow_definitions' => 'Workflow',
        'workflow_steps' => 'Workflow Step',
        'workflow_routes' => 'Workflow Route',
        'workflow_step_data' => 'Step Data',
        'field_definitions' => 'Field',
        'step_fields' => 'Step Fields',
        'requirement_definitions' => 'Requirement',
        'step_requirements' => 'Step Requirements',
        'step_checklists' => 'Step Checklist',
        'government_references' => 'Government Reference',
        'transaction_types' => 'Transaction Type',
        'office_steps' => 'Office Step',
    ];

    public function __invoke(Request $request)
    {
        $data = $request->validate([
            'period' => ['nullable', ReportPeriod::RULE],
            'kind' => ['nullable', 'in:all,transactions,setup'],
            'q' => ['nullable', 'string', 'max:200'],
            'module' => ['nullable', 'string', 'max:50'],
            'action' => ['nullable', 'string', 'max:50'],
            'actor_user_id' => ['nullable', 'integer', 'min:1'],
            'office_id' => ['nullable', 'integer', 'min:1'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:200'],
        ]);
        [$from, $to, $label] = ReportPeriod::resolve($data['period'] ?? 'all');
        $kind = $data['kind'] ?? 'all';
        $user = $request->user();
        $isSuperadmin = $user->isSuperadmin();

        $scopeOfficeId = $isSuperadmin ? null : (int) $user->office_id;

        $rows = collect();
        if ($kind !== 'setup') {
            $rows = $rows->concat($this->transactionRows($from, $to, $scopeOfficeId));
        }
        if ($isSuperadmin || $kind !== 'setup') {
            $rows = $rows->concat($this->auditRows($from, $to, $kind, $isSuperadmin, $scopeOfficeId, $data));
        }

        if (!empty($data['module'])) {
            $rows = $rows->filter(fn ($r) => ($r['module'] ?? null) === $data['module']);
        }
        if (!empty($data['action'])) {
            $rows = $rows->filter(fn ($r) => ($r['action_key'] ?? null) === $data['action']);
        }
        if (!empty($data['actor_user_id'])) {
            $rows = $rows->filter(fn ($r) => (int) ($r['actor']['id'] ?? 0) === (int) $data['actor_user_id']);
        }
        if (!empty($data['office_id'])) {
            $rows = $rows->filter(fn ($r) => (int) ($r['office']['id'] ?? 0) === (int) $data['office_id']);
        }

        $q = mb_strtolower(trim($data['q'] ?? ''));
        if ($q !== '') {
            $rows = $rows->filter(fn ($r) => str_contains(mb_strtolower(implode(' ', [
                $r['action'], $r['summary'], $r['actor']['name'] ?? '', $r['reference_number'] ?? '', $r['office']['code'] ?? '', $r['remarks'] ?? '',
            ])), $q));
        }

        $rows = $rows->sortByDesc('at')->values();
        $perPage = (int) ($data['per_page'] ?? 50);
        $page = (int) ($data['page'] ?? 1);
        $paginator = new LengthAwarePaginator($rows->forPage($page, $perPage)->values(), $rows->count(), $perPage, $page);

        return response()->json([
            'period' => ['key' => $data['period'] ?? 'all', 'label' => $label],
            'can_see_setup' => $isSuperadmin,
            'data' => $paginator->items(),
            'meta' => [
                'total' => $paginator->total(),
                'per_page' => $perPage,
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    private function transactionRows($from, $to, ?int $scopeOfficeId): Collection
    {
        $runs = TransactionStepRun::query()
            ->whereHas('transaction', fn ($t) => $scopeOfficeId
                ? app(OfficeScope::class)->apply($t, $scopeOfficeId)
                : $t)
            ->when($from, fn ($q) => $q->where(fn ($w) => $w
                ->whereBetween('performed_at', [$from, $to])
                ->orWhereBetween('received_at', [$from, $to])))
            ->with([
                'transaction:id,reference_number,title,office_id,transaction_type_id',
                'transaction.office:id,code,name',
                'transaction.type:id,name',
                'fromStep:id,name',
                'toStep:id,name',
                'performer:id,name',
                'receiver:id,name',
                'receivedOffice:id,code,name',
            ])
            ->reorder()
            ->orderByDesc('performed_at')
            ->limit(self::LIMIT)
            ->get();

        $in = fn ($at) => ReportPeriod::contains($from, $to, $at);
        $out = [];
        foreach ($runs as $run) {
            $tx = $run->transaction;
            $base = [
                'kind' => 'transaction',
                'module' => 'transactions',
                'transaction_id' => $tx?->id,
                'reference_number' => $tx?->reference_number,
                'title' => $tx?->title,
                'process' => $tx?->type?->name,
            ];
            if ($in($run->performed_at)) {
                $action = self::ACTIONS[$run->action_code] ?? Str::headline((string) $run->action_code);
                $summary = match (true) {
                    $run->action_code === 'create' => "Started at {$run->toStep?->name}",
                    $run->action_code === 'finalize' => "Finished at {$run->fromStep?->name}",
                    default => trim("{$run->fromStep?->name} → {$run->toStep?->name}", ' →'),
                };
                $out[] = $base + [
                    'id' => "run-{$run->id}",
                    'at' => $run->performed_at?->toIso8601String(),
                    'action' => $action,
                    'action_key' => $run->action_code,
                    'summary' => $summary,
                    'actor' => $run->performer?->only(['id', 'name']),
                    'office' => Office::mini($tx?->office),
                    'remarks' => $run->action_code === 'create' ? null : $run->remarks,
                ];
            }
            // Forwarded papers: the receipt at the next station is its own entry.
            if ($run->action_code !== 'create' && $run->received_at && $in($run->received_at)) {
                $out[] = $base + [
                    'id' => "rcv-{$run->id}",
                    'at' => $run->received_at->toIso8601String(),
                    'action' => 'Received',
                    'action_key' => 'receive',
                    'summary' => "Received at {$run->toStep?->name}",
                    'actor' => $run->receiver?->only(['id', 'name']),
                    'office' => Office::mini($run->receivedOffice),
                    'remarks' => null,
                ];
            }
        }

        return collect($out);
    }

    private function auditRows($from, $to, string $kind, bool $isSuperadmin, ?int $officeScopeId, array $filters = []): Collection
    {
        $query = AuditLog::query()
            // The step-run feed already shows finalization; the old audit
            // row was a duplicate and is kept in the table for history only.
            ->where('event', '!=', 'transactions.finalize')
            ->when($from, fn ($q) => $q->whereBetween('created_at', [$from, $to]))
            ->when($filters['module'] ?? null, fn ($q, $module) => $q->where('module', $module))
            ->when($filters['action'] ?? null, fn ($q, $action) => $q->where('action', $action))
            ->when($filters['actor_user_id'] ?? null, fn ($q, $actor) => $q->where('actor_user_id', $actor))
            ->when($filters['office_id'] ?? null, fn ($q, $office) => $q->where('office_id', $office))
            ->with([
                'office:id,code,name',
                'transaction:id,reference_number,title',
            ]);

        if (!$isSuperadmin) {
            // Office admins see transaction data changes for the same scope
            // as the step-run feed: filed by their office or routed through
            // one of its stations. Setup/account changes stay superadmin-only.
            $query->where('module', 'transactions')
                ->where(function ($w) use ($officeScopeId) {
                    $w->where('office_id', $officeScopeId)
                        ->orWhereHas('transaction', fn ($t) => app(OfficeScope::class)->apply($t, (int) $officeScopeId));
                });
        } elseif ($kind === 'transactions') {
            $query->where('module', 'transactions');
        } elseif ($kind === 'setup') {
            $query->where('module', '!=', 'transactions');
        }

        $logs = $query
            ->orderByDesc('created_at')
            ->limit(self::LIMIT)
            ->get();

        $labels = $this->labelMaps($logs);

        $actors = User::whereIn('id', $logs->pluck('actor_user_id')->filter()->unique())
            ->get(['id', 'name'])
            ->keyBy('id');

        return $logs
            ->map(function (AuditLog $log) use ($actors, $labels) {
                [$eventModule, $eventAction] = AuditAction::splitEvent((string) $log->event);
                $module = $log->module ?: $eventModule;
                $actionKey = $log->action ?: $eventAction;
                $meta = is_array($log->meta) ? $log->meta : [];

                // Dynamic transaction field codes are user data, not internal
                // references, so never resolve them as entity IDs.
                $rowLabels = $log->event === 'transactions.fields_update' ? [] : $labels;
                $changes = AuditAction::changeSummary(
                    $log->old_values,
                    $log->new_values,
                    $log->changed_fields,
                    $rowLabels,
                    $module
                );
                $summary = $log->description ?: ($log->entity_label ?: ($log->entity_id ? '#' . $log->entity_id : ''));
                if ($changes) {
                    $summary = trim($summary . ' — ' . $changes);
                }

                $actorName = $log->actor_name ?: $actors->get($log->actor_user_id)?->name;
                $isTransaction = $module === 'transactions';
                $actionLabel = $isTransaction
                    ? Str::ucfirst(AuditAction::verb($actionKey))
                    : ((self::MODULE_LABELS[$module] ?? Str::headline(Str::singular($module ?: 'activity'))) . ' ' . AuditAction::verb($actionKey));

                return [
                    'kind' => $isTransaction ? 'transaction' : 'setup',
                    'id' => "log-{$log->id}",
                    'at' => $log->created_at?->toIso8601String(),
                    'action' => $actionLabel,
                    'summary' => $summary,
                    'actor' => $log->actor_user_id ? [
                        'id' => $log->actor_user_id,
                        'name' => $actorName,
                        'roles' => $log->actor_roles,
                        'is_superadmin' => (bool) $log->actor_is_superadmin,
                        'office_id' => $log->actor_office_id,
                        'office_code' => $log->actor_office_code,
                    ] : null,
                    'office' => Office::mini($log->office),
                    'remarks' => $meta['note'] ?? $meta['remarks'] ?? null,
                    'transaction_id' => $log->transaction_id,
                    'reference_number' => $log->transaction?->reference_number,
                    'title' => $log->transaction?->title,
                    'process' => null,
                    'event' => $log->event,
                    'module' => $module,
                    'action_key' => $actionKey,
                    'changes' => [
                        'old' => $log->old_values,
                        'new' => $log->new_values,
                        'fields' => $log->changed_fields,
                    ],
                ];
            });
    }

    /**
     * Batch-load display names for every entity ID referenced by the logs
     * being shown. This runs once per page/source, not once per row.
     */
    private function labelMaps(Collection $logs): array
    {
        $ids = [
            'office' => [],
            'role' => [],
            'user' => [],
            'transaction' => [],
            'transaction_type' => [],
            'workflow_definition' => [],
            'workflow_step' => [],
            'office_step' => [],
            'field_definition' => [],
            'requirement_definition' => [],
            'checklist_override' => [],
            'attachment' => [],
        ];

        foreach ($logs as $log) {
            foreach ([$log->old_values, $log->new_values] as $values) {
                if (!is_array($values)) {
                    continue;
                }

                foreach ($values as $field => $value) {
                    $this->collectLabelIds($ids, (string) $field, $value, $log->module);
                }
            }
        }

        $maps = [];
        foreach ($ids as $category => $set) {
            $list = array_keys($set);
            if (!$list) {
                continue;
            }

            $maps[$category] = match ($category) {
                'office' => DB::table('offices')
                    ->whereIn('id', $list)
                    ->get(['id', 'code', 'name'])
                    ->mapWithKeys(fn ($office) => [
                        (int) $office->id => trim(($office->code ?? '') . ' — ' . ($office->name ?? ''), ' —'),
                    ])
                    ->all(),
                'role' => DB::table('roles')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'user' => DB::table('users')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'transaction' => DB::table('transactions')->whereIn('id', $list)->pluck('reference_number', 'id')->all(),
                'transaction_type' => DB::table('transaction_types')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'workflow_definition' => DB::table('workflow_definitions')
                    ->whereIn('id', $list)
                    ->get(['id', 'name', 'version'])
                    ->mapWithKeys(fn ($workflow) => [
                        (int) $workflow->id => $workflow->name
                            ? $workflow->name . ' v' . $workflow->version
                            : ('v' . $workflow->version),
                    ])
                    ->all(),
                'workflow_step' => DB::table('workflow_steps')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'office_step' => DB::table('office_steps')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'field_definition' => DB::table('field_definitions')->whereIn('id', $list)->pluck('name', 'id')->all(),
                'requirement_definition' => DB::table('requirement_definitions')
                    ->whereIn('id', $list)
                    ->get(['id', 'name', 'code'])
                    ->mapWithKeys(fn ($requirement) => [
                        (int) $requirement->id => $requirement->name ?: $requirement->code,
                    ])
                    ->all(),
                'checklist_override' => DB::table('checklist_overrides')
                    ->whereIn('id', $list)
                    ->get(['id', 'name', 'code'])
                    ->mapWithKeys(fn ($item) => [
                        (int) $item->id => $item->name ?: $item->code,
                    ])
                    ->all(),
                'attachment' => DB::table('transaction_attachments')->whereIn('id', $list)->pluck('original_name', 'id')->all(),
                default => [],
            };
        }

        return $maps;
    }

    private function collectLabelIds(array &$ids, string $field, mixed $value, ?string $module): void
    {
        if ($field === 'parent_id') {
            $this->addIds($ids, $module === 'office_steps' ? 'office_step' : 'workflow_step', $value);
            return;
        }

        $category = AuditAction::labelCategory($field, $module);
        if ($category !== null) {
            $this->addIds($ids, $category, $value);
            return;
        }

        if (!is_array($value)) {
            return;
        }

        // Nested ID lists used by step assignment sync events.
        if ($field === 'fields') {
            foreach ($value as $item) {
                if (is_array($item) && isset($item['field_definition_id'])) {
                    $this->addIds($ids, 'field_definition', $item['field_definition_id']);
                }
            }
        }

        if ($field === 'requirements') {
            foreach ($value as $item) {
                if (is_array($item) && isset($item['requirement_definition_id'])) {
                    $this->addIds($ids, 'requirement_definition', $item['requirement_definition_id']);
                }
            }
        }

        if ($field === 'definitions') {
            foreach (array_keys($value) as $key) {
                if (is_numeric($key)) {
                    $this->addIds($ids, 'requirement_definition', $key);
                }
            }
        }
    }

    private function addIds(array &$ids, string $category, mixed $value): void
    {
        if (!array_key_exists($category, $ids)) {
            return;
        }

        if (is_array($value)) {
            foreach ($value as $id) {
                if (is_scalar($id) && $id !== '' && is_numeric($id)) {
                    $ids[$category][(int) $id] = true;
                }
            }

            return;
        }

        if (is_scalar($value) && $value !== '' && is_numeric($value)) {
            $ids[$category][(int) $value] = true;
        }
    }
}
