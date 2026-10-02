<?php

namespace App\Services;

use App\Models\ChecklistOverride;
use App\Models\FieldDefinition;
use App\Models\RequirementDefinition;
use App\Models\TransactionRequirementCheck;
use App\Models\TransactionState;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Applies a client-staged workflow diff in ONE atomic transaction.
 *
 * Nothing is written until Save: the frontend stages steps/routes/
 * requirements/checklists/field-assignments locally (new rows keyed by
 * "tmp_…" client ids), then POSTs the whole diff here.
 *
 * Keys: integers reference existing rows — resolved in the target draft
 * directly, else by code within the same transaction type (covers staging
 * against a published version before any draft exists). Non-numeric keys
 * ("tmp_…") always mean "create new".
 */
class WorkflowStagingService
{
    public function __construct(private WorkflowVersioningService $versions) {}

    /**
     * @return array{definition: WorkflowDefinition, published: bool, message: ?string, applied: array}
     */
    public function apply(WorkflowDefinition $source, int $userId, array $data, ChecklistService $checklists): array
    {
        $mode = $data['mode'];
        $typeId = (int) $source->transaction_type_id;
        $applied = [
            'steps_created' => 0, 'steps_updated' => 0, 'steps_deleted' => 0,
            'routes_created' => 0, 'routes_updated' => 0, 'routes_deleted' => 0,
            'requirements_created' => 0, 'requirements_updated' => 0, 'requirements_deleted' => 0,
            'steps_bound' => 0, 'steps_checklisted' => 0, 'steps_resynced' => 0, 'steps_fields_synced' => 0,
        ];

        $draft = null;

        DB::transaction(function () use ($source, $userId, $data, $typeId, $checklists, &$draft, &$applied) {
            // Target is always the open draft (one-draft-max); create the
            // shell (cloned from latest published) when none exists yet.
            $draft = WorkflowDefinition::where('transaction_type_id', $typeId)
                ->where('status', 'draft')
                ->orderByDesc('version')
                ->first();
            $preexisted = (bool) $draft;
            if (!$draft) {
                $draft = $this->versions->createDraft([
                    'transaction_type_id' => $typeId,
                    'clone_latest_published' => true,
                ], $userId);
                $draft = $draft->fresh();
            }
            $this->versions->assertDraft($draft);

            // Conflict token: someone saved underneath while staging.
            if ($preexisted && !empty($data['source_updated_at']) && $draft->updated_at) {
                $token = Carbon::parse($data['source_updated_at'])->timestamp;
                if ((int) $draft->updated_at->timestamp !== (int) $token) {
                    abort(409, 'This draft changed since you loaded it (another admin saved). Reload to get the latest, then re-apply your changes.');
                }
            }

            // ---- requirement definitions (bindings reference them) ----
            $tmpReqMap = [];
            foreach ($data['requirements_upsert'] ?? [] as $row) {
                $existing = $this->findReq($draft, $typeId, $row['key'] ?? null, $row['code'] ?? null);
                if ($existing) {
                    if (!empty($row['code']) && strtolower($row['code']) !== strtolower($existing->code)) {
                        abort(422, "Requirement codes are frozen once created ({$existing->code}).");
                    }
                    $existing->update(array_filter([
                        'order_number' => $row['order_number'] ?? null,
                        'name' => $row['name'] ?? null,
                        'label' => $row['label'] ?? null,
                        'description' => $row['description'] ?? null,
                        'is_active' => array_key_exists('is_active', $row) ? (bool) $row['is_active'] : null,
                    ], fn ($v) => $v !== null));
                    $applied['requirements_updated']++;
                } else {
                    if (!is_string($row['key'] ?? null) || is_numeric($row['key'])) {
                        abort(422, 'Unknown requirement reference: ' . json_encode($row['key'] ?? null));
                    }
                    $code = $row['code'] ?? $this->uniqueReqCode($draft->id, $row['name']);
                    $this->assertReqCodeFree($draft->id, $code, null);
                    $created = RequirementDefinition::create([
                        'workflow_definition_id' => $draft->id,
                        'order_number' => (int) ($row['order_number'] ?? 0),
                        'code' => $code,
                        'name' => $row['name'],
                        'label' => $row['label'] ?? null,
                        'description' => $row['description'] ?? null,
                        'is_active' => array_key_exists('is_active', $row) ? (bool) $row['is_active'] : true,
                    ]);
                    $tmpReqMap[(string) $row['key']] = $created->id;
                    $applied['requirements_created']++;
                }
            }
            foreach ($data['requirements_delete'] ?? [] as $row) {
                $existing = $this->findReq($draft, $typeId, $row['id'] ?? null, $row['code'] ?? null);
                if (!$existing) abort(422, 'Unknown requirement reference in delete list.');
                if (TransactionRequirementCheck::where('requirement_definition_id', $existing->id)->exists()) {
                    abort(422, "Cannot delete '{$existing->name}': workers already checked this item. Set it inactive instead.");
                }
                $existing->delete();
                $applied['requirements_deleted']++;
            }

            // ---- steps, two passes (creates first so parents/ids exist) ----
            $tmpStepMap = [];
            $toUpdate = [];
            foreach ($data['steps_upsert'] ?? [] as $row) {
                $existing = $this->findStep($draft, $typeId, $row['key'] ?? null, $row['code'] ?? null);
                if ($existing) {
                    if (!empty($row['code']) && strtolower($row['code']) !== strtolower($existing->code)) {
                        abort(422, "Step codes are frozen once created ({$existing->code}).");
                    }
                    $toUpdate[] = [$existing, $row];
                } else {
                    if (isset($row['key']) && is_numeric($row['key'])) {
                        abort(422, 'Unknown step reference: ' . json_encode($row['key']));
                    }
                    $code = $row['code'] ?? $this->nextStepCode($draft, (int) $row['order_number']);
                    $this->assertStepCodeFree($draft->id, $code, null);
                    $created = $draft->steps()->create([
                        'parent_id' => null,
                        'order_number' => (int) $row['order_number'],
                        'code' => $code,
                        'name' => $row['name'],
                        'stage' => $row['stage'] ?? null,
                        'office_id' => $row['office_id'] ?? null,
                        'sla_minutes' => (int) $row['sla_minutes'],
                        'is_start' => (bool) ($row['is_start'] ?? false),
                        'is_end' => (bool) ($row['is_end'] ?? false),
                    ]);
                    if (array_key_exists('role_ids', $row)) {
                        $created->roles()->sync(array_map('intval', (array) $row['role_ids']));
                    }
                    $tmpStepMap[(string) $row['key']] = $created->id;
                    $applied['steps_created']++;
                }
            }
            $resolveStepOrFail = function ($key, ?string $code = null) use ($draft, $typeId, $tmpStepMap) {
                $hit = $this->findStep($draft, $typeId, $key, $code, $tmpStepMap);
                if (!$hit) abort(422, 'Unknown step reference: ' . json_encode($key));
                return $hit;
            };
            // Updates (existing rows) + parent links for every upserted row.
            $allUpserts = [];
            foreach ($data['steps_upsert'] ?? [] as $row) {
                $allUpserts[] = $row;
            }
            foreach ($allUpserts as $row) {
                $step = isset($tmpStepMap[(string) ($row['key'] ?? '')])
                    ? WorkflowStep::whereKey($tmpStepMap[(string) $row['key']])->first()
                    : $this->findStep($draft, $typeId, $row['key'] ?? null, $row['code'] ?? null);
                if (!$step) abort(422, 'Unknown step reference: ' . json_encode($row['key'] ?? null));
                if (!isset($tmpStepMap[(string) ($row['key'] ?? '')])) {
                    $step->update([
                        'order_number' => (int) $row['order_number'],
                        'name' => $row['name'],
                        'stage' => $row['stage'] ?? null,
                        'office_id' => $row['office_id'] ?? null,
                        'sla_minutes' => (int) $row['sla_minutes'],
                        'is_start' => (bool) ($row['is_start'] ?? false),
                        'is_end' => (bool) ($row['is_end'] ?? false),
                    ]);
                    if (array_key_exists('role_ids', $row)) {
                        $step->roles()->sync(array_map('intval', (array) $row['role_ids']));
                    }
                    $applied['steps_updated']++;
                }
                if (array_key_exists('parent_key', $row) && $row['parent_key'] !== null && $row['parent_key'] !== '') {
                    $parent = $resolveStepOrFail($row['parent_key']);
                    $this->assertValidParent($draft, (int) $parent->id, (int) $step->id);
                    $step->update(['parent_id' => $parent->id]);
                } elseif (array_key_exists('parent_key', $row)) {
                    $step->update(['parent_id' => null]);
                }
            }
            // Full-cycle sweep (catches A↔B style cycles across the batch).
            $this->assertNoCycles($draft);
            foreach ($data['steps_delete'] ?? [] as $row) {
                $existing = $this->findStep($draft, $typeId, $row['id'] ?? null, $row['code'] ?? null);
                if (!$existing) abort(422, 'Unknown step reference in delete list.');
                if (TransactionState::where('current_step_id', $existing->id)->count() > 0) {
                    abort(422, "Cannot delete step '{$existing->name}': transactions are currently sitting on it.");
                }
                $existing->delete();
                $applied['steps_deleted']++;
            }

            // ---- routes (forward-only: return routes retired, jumps handle going back) ----
            $routeToSteps = [];
            $seenPairs = [];
            foreach ($data['routes_upsert'] ?? [] as $row) {
                $from = $resolveStepOrFail($row['from_key']);
                $to = $resolveStepOrFail($row['to_key']);
                if (!empty($row['is_return_route'])) {
                    abort(422, 'Return routes are no longer allowed. Going back is done via jump to a visited station.');
                }
                if ((int) $from->id === (int) $to->id) {
                    abort(422, 'From and To cannot be the same step.');
                }
                if ((int) $to->order_number < (int) $from->order_number) {
                    abort(422, "Routes must move forward: Step {$from->order_number} → Step {$to->order_number} is not allowed.");
                }
                $existing = $this->findRoute($draft, $typeId, $row['key'] ?? null, (int) $from->id, (int) $to->id, $row['action_code']);
                $pairKey = (int) $from->id . '→' . (int) $to->id;
                $clash = WorkflowRoute::where('workflow_definition_id', $draft->id)
                    ->where('from_step_id', (int) $from->id)
                    ->where('to_step_id', (int) $to->id)
                    ->when($existing, fn ($q) => $q->where('id', '!=', (int) $existing->id))
                    ->exists();
                if ($clash || isset($seenPairs[$pairKey])) {
                    abort(422, 'This route already exists (same From → To), regardless of action.');
                }
                $seenPairs[$pairKey] = true;
                $payload = [
                    'from_step_id' => $from->id,
                    'to_step_id' => $to->id,
                    'action_code' => $row['action_code'],
                    'is_return_route' => (bool) ($row['is_return_route'] ?? false),
                    'condition_expression' => $row['condition_expression'] ?? null,
                    'route_group' => $row['route_group'] ?? null,
                    'required_approvals_count' => array_key_exists('required_approvals_count', $row) && $row['required_approvals_count'] !== null
                        ? (int) $row['required_approvals_count'] : null,
                ];
                if ($existing) {
                    $routeToSteps[] = [(int) $existing->to_step_id, (int) $to->id];
                    $existing->update($payload);
                    $applied['routes_updated']++;
                } else {
                    if (isset($row['key']) && is_numeric($row['key'])) {
                        abort(422, 'Unknown route reference: ' . json_encode($row['key']));
                    }
                    $draft->routes()->create($payload);
                    $routeToSteps[] = [null, (int) $to->id];
                    $applied['routes_created']++;
                }
            }
            foreach ($data['routes_delete'] ?? [] as $row) {
                $existing = $this->findRouteById($draft, $typeId, (int) $row['id']);
                if (!$existing) abort(422, 'Unknown route reference in delete list.');
                $routeToSteps[] = [(int) $existing->to_step_id, null];
                $existing->delete();
                $applied['routes_deleted']++;
            }

            // ---- per-step requirement bindings (full replace, mirrors sync) ----
            $boundSteps = [];
            foreach ($data['step_requirements'] ?? [] as $stepKey => $rows) {
                $step = $resolveStepOrFail($stepKey);
                $sync = [];
                foreach ((array) $rows as $r) {
                    $req = $this->findReq($draft, $typeId, $r['req_key'] ?? null, null, $tmpReqMap);
                    if (!$req) abort(422, 'Unknown requirement reference: ' . json_encode($r['req_key'] ?? null));
                    if (array_key_exists('code', $r) || array_key_exists('description', $r)) {
                        $req->update(array_filter([
                            'code' => $r['code'] ?? null,
                            'description' => $r['description'] ?? null,
                        ], fn ($v, $k) => array_key_exists($k, $r), ARRAY_FILTER_USE_BOTH));
                    }
                    $sync[(int) $req->id] = [
                        'display_order' => (int) ($r['display_order'] ?? 0),
                        'is_required' => array_key_exists('is_required', $r) ? (bool) $r['is_required'] : true,
                        'is_upload_required' => array_key_exists('is_upload_required', $r)
                            ? (bool) $r['is_upload_required']
                            : (array_key_exists('is_required', $r) ? (bool) $r['is_required'] : true),
                    ];
                }
                $step->requirementDefinitions()->sync($sync);
                $boundSteps[] = $step;
                $applied['steps_bound']++;
            }

            // ---- checklist: re-mirror affected steps, then apply staged rows ----
            $resyncIds = [];
            foreach ((array) ($data['resync_checklist_steps'] ?? []) as $stepKey) {
                $resyncIds[] = (int) $resolveStepOrFail($stepKey)->id;
            }
            $mirrorSteps = [];
            foreach ($routeToSteps as [$oldTo, $newTo]) {
                foreach (array_filter([$oldTo, $newTo]) as $sid) {
                    if ($s = $draft->steps()->find($sid)) $mirrorSteps[$s->id] = $s;
                }
            }
            foreach ($boundSteps as $s) {
                foreach ($this->successorSteps($s) as $succ) $mirrorSteps[$succ->id] = $succ;
            }
            $payloadSteps = [];
            foreach ($data['step_checklist'] ?? [] as $stepKey => $rows) {
                $payloadSteps[(int) $resolveStepOrFail($stepKey)->id] = $rows;
            }
            foreach ($mirrorSteps as $sid => $s) {
                if (isset($payloadSteps[$sid]) || in_array($sid, $resyncIds, true)) continue;
                $checklists->syncFromRequirements($s);
            }
            foreach ($resyncIds as $sid) {
                if ($s = $draft->steps()->find($sid)) {
                    $s->checklistOverrides()->delete();
                    $checklists->syncFromRequirements($s);
                    $applied['steps_resynced']++;
                }
            }
            foreach ($payloadSteps as $sid => $rows) {
                if (in_array($sid, $resyncIds, true)) continue; // resync wins
                $step = $draft->steps()->find($sid);
                if (!$step) abort(422, 'Unknown step reference in checklist payload.');
                $step->checklistOverrides()->delete();
                $insert = [];
                foreach ((array) $rows as $i => $r) {
                    $reqId = null;
                    if (array_key_exists('requirement_key', $r) && $r['requirement_key'] !== null && $r['requirement_key'] !== '') {
                        $req = $this->findReq($draft, $typeId, $r['requirement_key'], null, $tmpReqMap);
                        if (!$req) abort(422, 'Unknown requirement reference in checklist payload.');
                        $reqId = $req->id;
                    }
                    $insert[] = [
                        'workflow_step_id' => $step->id,
                        'requirement_definition_id' => $reqId,
                        'name' => $r['name'],
                        'code' => $r['code'] ?? null,
                        'description' => $r['description'] ?? null,
                        'is_required' => array_key_exists('is_required', $r) ? (bool) $r['is_required'] : true,
                        'display_order' => (int) ($r['display_order'] ?? $i),
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                }
                if ($insert) ChecklistOverride::insert($insert);
                $applied['steps_checklisted']++;
            }

            // ---- per-step field assignments (full replace, mirrors sync) ----
            foreach ($data['step_fields'] ?? [] as $stepKey => $rows) {
                $step = $resolveStepOrFail($stepKey);
                $payload = [];
                foreach ((array) $rows as $r) {
                    $fid = $this->resolveField($draft, $typeId, (int) $r['field_definition_id']);
                    $payload[$fid] = [
                        'display_order' => (int) ($r['display_order'] ?? 0),
                        'required_override' => array_key_exists('required_override', $r) ? $r['required_override'] : null,
                    ];
                }
                $step->fieldDefinitions()->sync($payload);
                $applied['steps_fields_synced']++;
            }

            // ---- name/notes ----
            if ($mode === 'overwrite') {
                $patch = [];
                if (!empty($data['name'])) $patch['name'] = $data['name'];
                if (array_key_exists('notes', $data)) $patch['notes'] = $data['notes'];
                if ($patch) $draft->update($patch);
            }

            $draft = $draft->fresh();
        });

        // Create-new publishes in its own pass so a start/end validation
        // failure still keeps the staged content as a draft (same courtesy
        // as today's go-live fallback).
        $published = false;
        $message = null;
        if ($mode === 'create-new') {
            $draft->update(['name' => $data['name'], 'notes' => $data['notes'] ?? $draft->notes]);
            $draft = $draft->fresh();
            try {
                $draft = $this->versions->publish($draft, $userId);
                $published = true;
            } catch (ValidationException $e) {
                $message = 'Saved as draft — ' . collect($e->errors())->flatten()->first();
                $draft = $draft->fresh();
            }
        }

        $draft->load(['steps.roles', 'steps.office', 'routes']);

        return ['definition' => $draft, 'published' => $published, 'message' => $message, 'applied' => $applied];
    }

    // ---- key resolution ----------------------------------------------------

    private function findStep(WorkflowDefinition $draft, int $typeId, $key, ?string $code = null, array $tmpMap = []): ?WorkflowStep
    {
        if ($key !== null && isset($tmpMap[(string) $key])) {
            return WorkflowStep::whereKey($tmpMap[(string) $key])->first();
        }
        if (is_numeric($key)) {
            $row = WorkflowStep::whereKey($key)->first();
            if ($row && (int) $row->workflow_definition_id === (int) $draft->id) return $row;
            if ($row) {
                $def = WorkflowDefinition::whereKey($row->workflow_definition_id)->first();
                if ($def && (int) $def->transaction_type_id === $typeId && $row->code) {
                    $hit = WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $row->code)->first();
                    if ($hit) return $hit;
                }
            }
            if ($code) {
                return WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $code)->first();
            }
            return null;
        }
        return null;
    }

    private function findReq(WorkflowDefinition $draft, int $typeId, $key, ?string $code = null, array $tmpMap = []): ?RequirementDefinition
    {
        if ($key !== null && isset($tmpMap[(string) $key])) {
            return RequirementDefinition::whereKey($tmpMap[(string) $key])->first();
        }
        if (is_numeric($key)) {
            $row = RequirementDefinition::whereKey($key)->first();
            if ($row && (int) $row->workflow_definition_id === (int) $draft->id) return $row;
            if ($row) {
                $def = WorkflowDefinition::whereKey($row->workflow_definition_id)->first();
                if ($def && (int) $def->transaction_type_id === $typeId && $row->code) {
                    $hit = RequirementDefinition::where('workflow_definition_id', $draft->id)->where('code', $row->code)->first();
                    if ($hit) return $hit;
                }
            }
            if ($code) {
                return RequirementDefinition::where('workflow_definition_id', $draft->id)->where('code', $code)->first();
            }
            return null;
        }
        return null;
    }

    private function findRoute(WorkflowDefinition $draft, int $typeId, $key, int $fromId, int $toId, string $action): ?WorkflowRoute
    {
        if (is_numeric($key)) {
            $r = WorkflowRoute::whereKey($key)->first();
            if ($r && (int) $r->workflow_definition_id === (int) $draft->id) return $r;
            if ($r) {
                // Same logical route in another version? Match by the source
                // triple (from/to codes + action) against the draft.
                $def = WorkflowDefinition::whereKey($r->workflow_definition_id)->first();
                if ($def && (int) $def->transaction_type_id === $typeId) {
                    $fromCode = $r->fromStep?->code;
                    $toCode = $r->toStep?->code;
                    if ($fromCode && $toCode) {
                        $fromDraft = WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $fromCode)->first();
                        $toDraft = WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $toCode)->first();
                        if ($fromDraft && $toDraft) {
                            $hit = WorkflowRoute::where('workflow_definition_id', $draft->id)
                                ->where('from_step_id', $fromDraft->id)
                                ->where('to_step_id', $toDraft->id)
                                ->where('action_code', $r->action_code)
                                ->first();
                            if ($hit) return $hit;
                        }
                    }
                }
            }
            return null;
        }
        // Tmp key, but maybe this exact link already exists in the draft.
        return WorkflowRoute::where('workflow_definition_id', $draft->id)
            ->where('from_step_id', $fromId)
            ->where('to_step_id', $toId)
            ->where('action_code', $action)
            ->first();
    }

    private function findRouteById(WorkflowDefinition $draft, int $typeId, int $id): ?WorkflowRoute
    {
        $r = WorkflowRoute::whereKey($id)->first();
        if (!$r) return null;
        if ((int) $r->workflow_definition_id === (int) $draft->id) return $r;
        $def = WorkflowDefinition::whereKey($r->workflow_definition_id)->first();
        if (!$def || (int) $def->transaction_type_id !== $typeId) return null;
        $fromCode = $r->fromStep?->code;
        $toCode = $r->toStep?->code;
        if (!$fromCode || !$toCode) return null;
        $fromDraft = WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $fromCode)->first();
        $toDraft = WorkflowStep::where('workflow_definition_id', $draft->id)->where('code', $toCode)->first();
        if (!$fromDraft || !$toDraft) return null;
        return WorkflowRoute::where('workflow_definition_id', $draft->id)
            ->where('from_step_id', $fromDraft->id)
            ->where('to_step_id', $toDraft->id)
            ->where('action_code', $r->action_code)
            ->first();
    }

    private function resolveField(WorkflowDefinition $draft, int $typeId, int $fieldId): int
    {
        $field = FieldDefinition::whereKey($fieldId)->first();
        if (!$field) abort(422, 'Unknown field reference: ' . $fieldId);
        if ((int) ($field->workflow_definition_id ?? 0) === (int) $draft->id) return $field->id;
        if (empty($field->workflow_definition_id)) return $field->id; // global catalog: reuse
        $def = WorkflowDefinition::whereKey($field->workflow_definition_id)->first();
        if ($def && (int) $def->transaction_type_id === $typeId && $field->code) {
            $hit = FieldDefinition::where('workflow_definition_id', $draft->id)->where('code', $field->code)->first();
            if ($hit) return $hit->id;
        }
        abort(422, 'Unknown field reference: ' . $fieldId);
    }

    private function successorSteps(WorkflowStep $step): array
    {
        $targets = $step->outgoingRoutes()
            ->where('is_return_route', false)
            ->where('to_step_id', '!=', (int) $step->id)
            ->pluck('to_step_id')
            ->map(fn ($id) => (int) $id)
            ->unique()
            ->values()
            ->all();
        if (!$targets) return [];
        return WorkflowStep::whereIn('id', $targets)->get()->all();
    }

    // ---- code helpers (mirror the single-endpoint rules) ----

    private function nextStepCode(WorkflowDefinition $draft, int $order): string
    {
        $draft->loadMissing('transactionType');
        $base = strtolower(preg_replace('/[^a-z0-9]+/', '_', $draft->transactionType?->code ?? 'step'));
        $base = trim($base, '_') ?: 'step';
        $candidate = "{$base}_{$order}";
        $suffix = 2;
        while (
            WorkflowStep::withTrashed()
                ->where('workflow_definition_id', $draft->id)
                ->where('code', $candidate)
                ->exists()
        ) {
            $candidate = "{$base}_{$order}-{$suffix}";
            $suffix++;
        }
        return $candidate;
    }

    private function assertStepCodeFree(int $draftId, string $code, ?int $exceptId): void
    {
        $q = WorkflowStep::withTrashed()->where('workflow_definition_id', $draftId)->where('code', $code);
        if ($exceptId) $q->where('id', '!=', $exceptId);
        if ($q->exists()) abort(422, "Step code '{$code}' is already used in this flow.");
    }

    private function uniqueReqCode(int $draftId, string $name): string
    {
        $base = strtolower(preg_replace('/[^a-z0-9]+/i', '_', $name));
        $base = trim($base, '_') ?: 'req';
        $base = substr($base, 0, 50);
        $code = $base;
        $i = 2;
        while (
            RequirementDefinition::withTrashed()
                ->where('workflow_definition_id', $draftId)
                ->where('code', $code)
                ->exists()
        ) {
            $code = $base . '_' . $i++;
        }
        return $code;
    }

    private function assertReqCodeFree(int $draftId, string $code, ?int $exceptId): void
    {
        $q = RequirementDefinition::withTrashed()->where('workflow_definition_id', $draftId)->where('code', $code);
        if ($exceptId) $q->where('id', '!=', $exceptId);
        if ($q->exists()) abort(422, "Requirement code '{$code}' is already used in this flow.");
    }

    private function assertValidParent(WorkflowDefinition $draft, ?int $parentId, ?int $selfId): void
    {
        if ($parentId === null) return;
        $seen = $selfId ? [$selfId] : [];
        $cursor = $parentId;
        while ($cursor !== null) {
            if (in_array($cursor, $seen, true)) {
                abort(422, 'Circular hierarchy detected: a step cannot sit under itself or its own sub-step.');
            }
            $ancestor = WorkflowStep::withTrashed()->find($cursor);
            if (!$ancestor || (int) $ancestor->workflow_definition_id !== (int) $draft->id) {
                abort(422, 'Parent step must belong to the same transaction steps.');
            }
            $seen[] = $cursor;
            $cursor = $ancestor->parent_id;
        }
    }

    private function assertNoCycles(WorkflowDefinition $draft): void
    {
        $steps = WorkflowStep::where('workflow_definition_id', $draft->id)->get(['id', 'parent_id']);
        $parentOf = [];
        foreach ($steps as $s) $parentOf[(int) $s->id] = $s->parent_id === null ? null : (int) $s->parent_id;
        foreach (array_keys($parentOf) as $start) {
            $seen = [];
            $cursor = $start;
            while ($cursor !== null) {
                if (isset($seen[$cursor])) {
                    abort(422, 'Circular hierarchy detected: a step cannot sit under itself or its own sub-step.');
                }
                $seen[$cursor] = true;
                $cursor = $parentOf[$cursor] ?? null;
            }
        }
    }
}
