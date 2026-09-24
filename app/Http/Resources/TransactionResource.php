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

            foreach ($reqs as $r) {
                $check = $checks->get($r->id);
                $reqAtts = $attsByReq->get((int) $r->id, collect())->values();

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
                    ],
                    'checked' => (bool) $check,
                    'checked_at' => $check?->checked_at?->toISOString(),
                    'checked_by' => $check?->checker?->only(['id','name','email']),
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

            foreach ($checklistItems as $item) {
                $cCheck = $checklistChecks->get($item->id);
                $sourceStep = $sourceStepByReq[(int) ($item->requirement_definition_id ?? 0)] ?? null;
                $sourceAtts = $sourceStep
                    ? $attsByStepReq->get(((int) $sourceStep->id) . ':' . ((int) $item->requirement_definition_id), collect())->values()
                    : collect();
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
                    'source_step' => $sourceStep?->only(['id', 'code', 'name', 'order_number']),
                    'attachments' => $sourceAtts->map(fn ($a) => [
                        'id' => $a->id,
                        'original_name' => $a->original_name,
                        'mime' => $a->mime,
                        'size_bytes' => (int) $a->size_bytes,
                        'uploaded_by' => $a->uploader?->only(['id', 'name']),
                        'created_at' => $a->created_at?->toISOString(),
                        'download_url' => url("/api/transactions/{$this->id}/attachments/{$a->id}/download"),
                    ])->all(),
                    'attachment_count' => $sourceAtts->count(),
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
                        ])->all(),
                    ];
                }

                $stationChecklist[] = [
                    'step' => array_merge(
                        $s->only(['id', 'code', 'name', 'order_number', 'is_start', 'is_end']),
                        ['roles' => $rolesByStep->get((int) $s->id, [])]
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

            'current_step' => $state?->currentStep?->only(['id','order_number','code','name','stage','sla_minutes','is_start','is_end']),
            'entered_at' => $state?->entered_at?->toISOString(),

            'workflow_steps' => $this->workflow?->steps?->map(fn($s) => $s->only(['id','order_number','parent_id','code','name','stage','is_start','is_end']))?->values(),
            'workflow_routes' => $this->workflow?->routes?->map(fn($r) => $r->only(['id','from_step_id','to_step_id','action_code','is_return_route','route_group','required_approvals_count','condition_expression']))?->values(),

            'current_step_fields' => $currentStepFields,

            'current_step_requirements' => $currentStepRequirements,

            'current_step_checklist' => $currentStepChecklist,

            'station_checklist' => $stationChecklist,

            'attachments' => TransactionAttachmentResource::collection($this->whenLoaded('attachments')),

            'runs' => TransactionStepRunResource::collection($this->whenLoaded('runs')),
        ];
    }
}
