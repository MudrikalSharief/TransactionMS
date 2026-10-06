<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    public function toArray($request): array
    {
        $state = $this->whenLoaded('state');

        $currentStepFields = [];
        $currentStep = $state?->currentStep;

        if ($currentStep) {
            $this->loadMissing(['fieldValues.fieldDefinition']);

            $valuesByDefId = collect($this->fieldValues ?? [])
                ->keyBy('field_definition_id');

            $defs = $currentStep->fieldDefinitions()
                ->orderBy('field_definition_workflow_step.display_order')
                ->orderBy('field_definitions.order_number')
                ->get();

            foreach ($defs as $def) {
                $fv = $valuesByDefId->get($def->id);

                $val = null;
                if ($fv) {
                    if (is_array($fv->value_json) && array_key_exists('value', $fv->value_json)) {
                        $val = $fv->value_json['value'];
                    } elseif ($fv->value_number !== null) {
                        $val = is_numeric($fv->value_number) ? ($fv->value_number + 0) : $fv->value_number;
                    } elseif ($fv->value_text !== null) {
                        $val = $fv->value_text;
                    } else {
                        $val = $fv->value_json;
                    }
                }

                $currentStepFields[] = [
                    'definition' => [
                        'id' => $def->id,
                        'code' => $def->code,
                        'name' => $def->name,
                        'type' => $def->type,
                        'group' => $def->group,
                        'required' => (bool) ($def->pivot?->required_override ?? $def->required),
                        'options' => $def->options,
                        'min_length' => $def->min_length,
                        'max_length' => $def->max_length,
                        'min_value' => $def->min_value,
                        'max_value' => $def->max_value,
                    ],
                    'value' => $val,
                ];
            }
        }

        $currentStepRequirements = [];
        $currentStepChecklist = [];
        if ($currentStep) {
            $this->loadMissing(['requirementChecks.checker', 'checklistChecks.checker', 'attachments.uploader']);
            $checks = collect($this->requirementChecks ?? [])
                ->where('workflow_step_id', (int) $currentStep->id)
                ->keyBy('requirement_definition_id');
            $checklistChecks = collect($this->checklistChecks ?? [])
                ->where('workflow_step_id', (int) $currentStep->id)
                ->keyBy('checklist_override_id');
            $attsByReq = collect($this->relationLoaded('attachments') ? ($this->attachments ?? []) : [])
                ->where('workflow_step_id', (int) $currentStep->id)
                ->groupBy(fn ($a) => (int) ($a->requirement_definition_id ?? 0));

            $reqs = $currentStep->requirementDefinitions()
                ->orderBy('step_requirements.display_order')
                ->orderBy('requirement_definitions.order_number')
                ->get();

            // Previous-station ticks for the two-column verify layout: the
            // first column mirrors what the predecessor station(s) checked.
            // Matched by requirement CODE, not ID: every station owns its
            // own definitions (same names/codes, different IDs), so an ID
            // match across stations never hits. Keyed by step + requirement
            // so the current step's own checks (above) stay untouched.
            $checksByStepReq = collect($this->requirementChecks ?? [])
                ->keyBy(fn ($c) => ((int) $c->workflow_step_id) . ':' . ((int) $c->requirement_definition_id));
            $checklistServiceForPrev = \app(\App\Services\ChecklistService::class);
            $predSteps = $checklistServiceForPrev->predecessorsFor($currentStep)->values();
            $predReqIdsByCode = [];
            foreach ($predSteps as $pred) {
                foreach ($pred->requirementDefinitions()->get(['requirement_definitions.id', 'requirement_definitions.code']) as $pr) {
                    $predReqIdsByCode[strtolower(trim((string) $pr->code))][$pred->id] ??= (int) $pr->id;
                }
            }

            foreach ($reqs as $r) {
                $check = $checks->get($r->id);
                $reqAtts = $attsByReq->get((int) $r->id, collect())->values();

                $prevCheck = null;
                $prevStep = null;
                $codeKey = strtolower(trim((string) $r->code));
                foreach ($predSteps as $pred) {
                    $predReqId = $predReqIdsByCode[$codeKey][(int) $pred->id] ?? null;
                    if (!$predReqId) continue;
                    $candidate = $checksByStepReq->get(((int) $pred->id) . ':' . $predReqId);
                    if ($candidate) {
                        $prevCheck = $candidate;
                        $prevStep = $pred;
                        break;
                    }
                }
                // Predecessor owns a matching requirement but left it
                // unticked: still show the Prev column (empty box) so the
                // mirror is honest instead of collapsing to one column.
                if (!$prevStep && isset($predReqIdsByCode[$codeKey])) {
                    $prevStep = $predSteps->first(fn ($p) => isset($predReqIdsByCode[$codeKey][(int) $p->id]));
                }

                $currentStepRequirements[] = [
                    'definition' => [
                        'id' => $r->id,
                        'code' => $r->code,
                        'name' => $r->name,
                        'description' => $r->description,
                        'is_active' => (bool) $r->is_active,
                    ],
                    'pivot' => [
                        'display_order' => (int) ($r->pivot?->display_order ?? 0),
                        'is_required' => (bool) ($r->pivot?->is_required ?? true),
                        'is_upload_required' => (bool) ($r->pivot?->is_upload_required ?? $r->pivot?->is_required ?? true),
                    ],
                    'checked' => (bool) $check,
                    'checked_at' => $check?->checked_at?->toISOString(),
                    'checked_by' => $check?->checker?->only(['id','name','email']),
                    'prev_checked' => (bool) $prevCheck,
                    'prev_checked_by' => $prevCheck?->checker?->only(['id','name']),
                    'prev_step' => $prevStep ? $prevStep->only(['id','name','order_number']) : null,
                    'attachments' => $reqAtts->map(fn ($a) => [
                        'id' => $a->id,
                        'original_name' => $a->original_name,
                        'mime' => $a->mime,
                        'size_bytes' => (int) $a->size_bytes,
                        'step_run_id' => $a->step_run_id,
                        'requirement_definition_id' => $a->requirement_definition_id,
                        'requirement' => ['id' => $r->id, 'code' => $r->code, 'name' => $r->name],
                        'uploaded_by' => $a->uploader?->only(['id','name']),
                        'created_at' => $a->created_at?->toISOString(),
                        'download_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/download"),
                        'view_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/view"),
                    ])->all(),
                    'attachment_count' => $reqAtts->count(),
                ];
            }

            // Per-step checklist (seeded from requirements, then free-edited).
            // Required items block Proceed when unticked — same idea as the
            // old requirement ticks; uploads are a requirements-only concern.
            $checklistService = \app(\App\Services\ChecklistService::class);
            $checklistItems = $checklistService->ensureItems($currentStep);

            // Items mirrored from a predecessor's requirement carry that
            // station and the files it uploaded, so the reviewer can see
            // what they are validating (Approvals page).
            $sourceStepByReq = [];
            foreach ($checklistService->predecessorsFor($currentStep) as $pred) {
                foreach ($pred->requirementDefinitions()->pluck('requirement_definitions.id') as $reqId) {
                    $sourceStepByReq[(int) $reqId] ??= $pred;
                }
            }
            $attsByStepReq = collect($this->attachments ?? [])
                ->groupBy(fn ($a) => ((int) $a->workflow_step_id) . ':' . ((int) ($a->requirement_definition_id ?? 0)));

            // Checklist items mirror predecessor requirements, so their
            // files live on earlier steps. Group transaction-wide by
            // requirement so the wizard can offer a View button per file.
            $attsByReqTx = collect($this->relationLoaded('attachments') ? ($this->attachments ?? []) : [])
                ->groupBy(fn ($a) => (int) ($a->requirement_definition_id ?? 0));

            foreach ($checklistItems as $item) {
                $cCheck = $checklistChecks->get($item->id);
                $sourceStep = $sourceStepByReq[(int) ($item->requirement_definition_id ?? 0)] ?? null;
                // Previous-station requirement tick for the two-column
                // verify layout: direct ID match — the override stores its
                // predecessor requirement's own definition ID.
                $prevReqCheck = ($sourceStep && $item->requirement_definition_id)
                    ? $checksByStepReq->get(((int) $sourceStep->id) . ':' . ((int) $item->requirement_definition_id))
                    : null;
                $sourceAtts = $sourceStep
                    ? $attsByStepReq->get(((int) $sourceStep->id) . ':' . ((int) $item->requirement_definition_id), collect())->values()
                    : collect();
                $itemAtts = $attsByReqTx->get((int) ($item->requirement_definition_id ?? 0), collect())->values();
                $currentStepChecklist[] = [
                    'id' => $item->id,
                    'requirement_definition_id' => $item->requirement_definition_id,
                    'name' => $item->name,
                    'code' => $item->code,
                    'description' => $item->description,
                    'is_required' => (bool) $item->is_required,
                    'display_order' => (int) $item->display_order,
                    'checked' => (bool) $cCheck,
                    'checked_at' => $cCheck?->checked_at?->toISOString(),
                    'checked_by' => $cCheck?->checker?->only(['id', 'name']),
                    'prev_checked' => (bool) $prevReqCheck,
                    'prev_checked_by' => $prevReqCheck?->checker?->only(['id', 'name']),
                    'prev_step' => $sourceStep && $item->requirement_definition_id ? $sourceStep->only(['id', 'name', 'order_number']) : null,
                    'attachments' => ($sourceStep ? $sourceAtts : $itemAtts)->map(fn ($a) => [
                        'id' => $a->id,
                        'original_name' => $a->original_name,
                        'mime' => $a->mime,
                        'size_bytes' => (int) $a->size_bytes,
                        'requirement_definition_id' => $a->requirement_definition_id,
                        'uploaded_by' => $a->uploader?->only(['id', 'name']),
                        'created_at' => $a->created_at?->toISOString(),
                        'download_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/download"),
                        'view_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/view"),
                    ])->all(),
                    'attachment_count' => ($sourceStep ? $sourceAtts : $itemAtts)->count(),
                ];
            }
        }

        // Full station bind map for the Shopee-style tracking guide.
        // Built only when steps are already loaded (detail views) so list
        // responses stay light. Shows every station with its bound items
        // plus this transaction's check state per item.
        $stationChecklist = [];
        if ($this->relationLoaded('workflow') && $this->workflow?->relationLoaded('steps')) {
            $this->loadMissing(['workflow.steps.requirementDefinitions', 'workflow.steps.fieldDefinitions', 'requirementChecks.checker', 'fieldValues.fieldDefinition', 'attachments.uploader']);

            $valuesByDefId = collect($this->fieldValues ?? [])
                ->keyBy('field_definition_id');

            $extractValue = function ($fv) {
                if (!$fv) return null;
                if (is_array($fv->value_json) && array_key_exists('value', $fv->value_json)) {
                    return $fv->value_json['value'];
                } elseif ($fv->value_number !== null) {
                    return is_numeric($fv->value_number) ? ($fv->value_number + 0) : $fv->value_number;
                } elseif ($fv->value_text !== null) {
                    return $fv->value_text;
                }
                return $fv->value_json;
            };

            $allChecks = collect($this->requirementChecks ?? [])
                ->keyBy(fn ($c) => ((int) $c->workflow_step_id) . ':' . ((int) $c->requirement_definition_id));

            $allAtts = collect($this->relationLoaded('attachments') ? ($this->attachments ?? []) : [])
                ->groupBy(fn ($a) => ((int) $a->workflow_step_id) . ':' . ((int) ($a->requirement_definition_id ?? 0)));

            // Station -> roles map for role-aware dimming ("mine" vs waiting).
            // stepRoles is already eager-loaded on detail paths; fall back to
            // an empty map (all dimmed except current) when it is not.
            $this->loadMissing(['workflow.stepRoles.role']);
            $rolesByStep = collect($this->workflow->stepRoles ?? [])
                ->groupBy(fn ($sr) => (int) $sr->workflow_step_id)
                ->map(fn ($rows) => $rows
                    ->map(fn ($sr) => $sr->role?->only(['id', 'code', 'name']))
                    ->filter()
                    ->values()
                    ->all());

            $orderedSteps = collect($this->workflow->steps ?? [])
                ->sortBy(fn ($s) => (int) ($s->order_number ?? 0))
                ->values();

            foreach ($orderedSteps as $s) {
                $reqs = collect($s->requirementDefinitions ?? [])
                    ->sortBy(fn ($r) => (int) ($r->order_number ?? 0))
                    ->sortBy(fn ($r) => (int) ($r->pivot?->display_order ?? 0))
                    ->values();

                $rows = [];
                foreach ($reqs as $r) {
                    $check = $allChecks->get(((int) $s->id) . ':' . ((int) $r->id));
                    $reqAtts = $allAtts->get(((int) $s->id) . ':' . ((int) $r->id), collect())->values();

                    $rows[] = [
                        'definition' => [
                            'id' => $r->id,
                            'code' => $r->code,
                            'name' => $r->name,
                            'description' => $r->description,
                        ],
                        'pivot' => [
                            'display_order' => (int) ($r->pivot?->display_order ?? 0),
                            'is_required' => (bool) ($r->pivot?->is_required ?? true),
                            'is_upload_required' => (bool) ($r->pivot?->is_upload_required ?? $r->pivot?->is_required ?? true),
                        ],
                        'checked' => (bool) $check,
                        'checked_at' => $check?->checked_at?->toISOString(),
                        'checked_by' => $check?->checker?->only(['id', 'name']),
                        'attachment_count' => $reqAtts->count(),
                        'attachments' => $reqAtts->map(fn ($a) => [
                            'id' => $a->id,
                            'original_name' => $a->original_name,
                            'mime' => $a->mime,
                            'size_bytes' => (int) $a->size_bytes,
                            'step_run_id' => $a->step_run_id,
                            'requirement_definition_id' => $a->requirement_definition_id,
                            'requirement' => ['id' => $r->id, 'code' => $r->code, 'name' => $r->name],
                            'uploaded_by' => $a->uploader?->only(['id','name']),
                            'created_at' => $a->created_at?->toISOString(),
                            'download_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/download"),
                            'view_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/view"),
                        ])->all(),
                    ];
                }

                $stationChecklist[] = [
                    'step' => array_merge(
                        $s->only(['id', 'code', 'name', 'order_number', 'is_start', 'is_end', 'office_id']),
                        ['roles' => $rolesByStep->get((int) $s->id, [])],
                        ['office' => $s->office?->only(['id', 'code', 'name'])]
                    ),
                    'requirements' => $rows,
                    // Proceed-level files for this station (uploaded in the
                    // Proceed modal, not tied to one checklist item) so the
                    // station hover card can list every uploaded file.
                    'attachments' => $allAtts->get(((int) $s->id) . ':0', collect())->values()->map(fn ($a) => [
                        'id' => $a->id,
                        'original_name' => $a->original_name,
                        'mime' => $a->mime,
                        'size_bytes' => (int) $a->size_bytes,
                        'step_run_id' => $a->step_run_id,
                        'requirement_definition_id' => $a->requirement_definition_id,
                        'uploaded_by' => $a->uploader?->only(['id','name']),
                        'created_at' => $a->created_at?->toISOString(),
                        'download_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/download"),
                        'view_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/view"),
                    ])->all(),
                    'fields' => collect($s->fieldDefinitions ?? [])
                        ->sortBy(fn ($f) => (int) ($f->order_number ?? 0))
                        ->sortBy(fn ($f) => (int) ($f->pivot?->display_order ?? 0))
                        ->values()
                        ->map(fn ($f) => [
                            'definition' => [
                                'id' => $f->id,
                                'code' => $f->code,
                                'name' => $f->name,
                                'type' => $f->type,
                                'required' => (bool) ($f->pivot?->required_override ?? $f->required),
                            ],
                            'value' => $extractValue($valuesByDefId->get($f->id)),
                        ])
                        ->all(),
                ];
            }
        }

        return [
            'id' => $this->id,
            'reference_number' => $this->reference_number,
            'title' => $this->title,
            'is_done' => (bool) $this->is_done,

            'transaction_type' => $this->type?->only(['id','code','name']),
            'office' => $this->office?->only(['id','code','name']),
            // Office's own 1-2-3 steps, only when the office steps were
            // eager-loaded (detail views). Lists leave this null.
            'office_steps' => ($this->office && $this->office->relationLoaded('steps'))
                ? $this->office->steps->map(fn($s) => $s->only(['id','order_number','parent_id','code','name','description','is_active']))->values()
                : null,
            'workflow' => $this->workflow?->only(['id','version','status','name']),

            'created_by' => $this->creator?->only(['id','name','email']),
            'created_at' => $this->created_at?->toISOString(),

            'current_step' => $state?->currentStep ? array_merge(
                $state->currentStep->only(['id','order_number','code','name','stage','sla_minutes','is_start','is_end','office_id']),
                ['office' => $state->currentStep->office?->only(['id','code','name'])]
            ) : null,
            'entered_at' => $state?->entered_at?->toISOString(),

            'workflow_steps' => $this->workflow?->steps?->map(fn($s) => array_merge(
                $s->only(['id','order_number','parent_id','code','name','stage','is_start','is_end','office_id']),
                ['office' => $s->office?->only(['id','code','name'])]
            ))?->values(),
            'workflow_routes' => $this->workflow?->routes?->map(fn($r) => $r->only(['id','from_step_id','to_step_id','action_code','is_return_route','route_group','required_approvals_count','condition_expression']))?->values(),

            'current_step_fields' => $currentStepFields,

            'current_step_data' => $this->buildCurrentStepData($currentStep),

            'current_step_requirements' => $currentStepRequirements,

            'current_step_checklist' => $currentStepChecklist,

            'station_checklist' => $stationChecklist,

            'attachments' => TransactionAttachmentResource::collection($this->whenLoaded('attachments')),

            'runs' => TransactionStepRunResource::collection($this->whenLoaded('runs')),

            'pending_receipt' => $this->when(
                $this->relationLoaded('runs'),
                function () {
                    $pending = collect($this->runs ?? [])->firstWhere(fn ($r) => $r->received_at === null);
                    if (!$pending) return null;
                    return (new TransactionStepRunResource($pending))->toArray(request());
                }
            ),

            'previous_step_context' => $this->buildPreviousStepContext($stationChecklist ?? []),
        ];
    }

    /**
     * Previous station context for the Proceed Review page (last move only,
     * read-only): step identity + remarks/who/when + station field values +
     * station step-data values. Null when there is no previous move
     * (e.g. still at step 1).
     */
    private function buildPreviousStepContext(array $stationChecklist): ?array
    {
        if (!$this->relationLoaded('runs')) return null;
        $lastRun = collect($this->runs ?? [])->sortBy(fn ($r) => (int) ($r->id ?? 0))->last();
        if (!$lastRun) return null;
        $prevStepId = (int) ($lastRun->from_step_id ?? 0);
        if (!$prevStepId) return null;

        $fromStep = $lastRun->relationLoaded('fromStep') ? $lastRun->fromStep : null;
        if (!$fromStep && $this->relationLoaded('workflow')) {
            $fromStep = collect($this->workflow->steps ?? [])->firstWhere(fn ($s) => (int) $s->id === $prevStepId);
        }

        $station = collect($stationChecklist)->firstWhere(fn ($s) => (int) ($s['step']['id'] ?? 0) === $prevStepId);
        $fields = collect($station['fields'] ?? [])
            ->map(fn ($f) => [
                'code' => $f['definition']['code'] ?? null,
                'name' => $f['definition']['name'] ?? null,
                'value' => $f['value'] ?? null,
            ])
            ->filter(fn ($f) => $f['value'] !== null && $f['value'] !== '' && $f['value'] !== [])
            ->values()
            ->all();

        $this->loadMissing(['stepData.enterer']);
        $defs = \App\Models\WorkflowStepData::where('workflow_step_id', $prevStepId)
            ->orderBy('display_order')
            ->get();
        $latestByDef = collect($this->stepData ?? [])
            ->where('workflow_step_id', $prevStepId)
            ->sortByDesc(fn ($r) => $r->entered_at?->timestamp ?? $r->id)
            ->keyBy('workflow_step_data_id');
        $stepData = $defs->map(fn ($d) => [
            'code' => $d->code,
            'name' => $d->display_name,
            'value' => $latestByDef->get($d->id)?->data_value,
        ])
            ->filter(fn ($row) => $row['value'] !== null && $row['value'] !== '')
            ->values()
            ->all();

        $performer = $lastRun->relationLoaded('performer') ? $lastRun->performer : null;

        return [
            'step' => [
                'id' => $prevStepId,
                'name' => $fromStep?->name,
                'order_number' => $fromStep?->order_number,
                'office' => $fromStep?->office?->only(['id', 'code', 'name']),
            ],
            'run' => [
                'remarks' => $lastRun->remarks,
                'performed_by' => $performer?->only(['id', 'name']),
                'performed_at' => $lastRun->performed_at?->toISOString(),
            ],
            'fields' => $fields,
            'step_data' => $stepData,
        ];
    }

    private function buildCurrentStepData($currentStep): array
    {
        if (!$currentStep) {
            return [];
        }
        $this->loadMissing(['stepData.definition', 'stepData.enterer']);
        $defs = $currentStep->stepDataDefinitions()->orderBy('display_order')->get();
        // Latest value per definition for this transaction (history kept per run).
        $latestByDef = collect($this->stepData ?? [])
            ->sortByDesc(fn ($r) => $r->entered_at?->timestamp ?? $r->id)
            ->keyBy('workflow_step_data_id');

        return $defs->map(fn ($d) => [
            'definition' => $d->only(['id', 'code', 'display_name', 'type', 'is_required', 'display_order', 'min_length', 'max_length']),
            'value' => $latestByDef->get($d->id)?->data_value,
            'history' => collect($this->stepData ?? [])
                ->where('workflow_step_data_id', $d->id)
                ->sortByDesc(fn ($r) => $r->entered_at?->timestamp ?? $r->id)
                ->values()
                ->map(fn ($r) => [
                    'data_value' => $r->data_value,
                    'entered_at' => $r->entered_at?->toISOString(),
                    'entered_by' => $r->enterer?->only(['id', 'name']),
                    'step_run_id' => $r->transaction_step_run_id,
                ])->all(),
        ])->all();
    }
}
