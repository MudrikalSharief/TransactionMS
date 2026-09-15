<?php

namespace App\Services;

use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use App\Models\FieldDefinition;
use App\Models\RequirementDefinition;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class WorkflowVersioningService
{
    public function createDraft(array $data, int $userId): WorkflowDefinition
    {
        return DB::transaction(function () use ($data, $userId) {
            $typeId = (int) $data['transaction_type_id'];

            // One-draft-max: a type can never pile up redundant drafts.
            // Reuse the open draft no matter how often this is called.
            $existing = WorkflowDefinition::where('transaction_type_id', $typeId)
                ->where('status', 'draft')
                ->orderByDesc('version')
                ->first();

            if ($existing) {
                return $existing->load(['steps.roles', 'routes']);
            }

            $clone = (bool)($data['clone_latest_published'] ?? true);

            $latest = WorkflowDefinition::where('transaction_type_id', $typeId)
                ->orderByDesc('version')
                ->first();

            $nextVersion = $latest ? ($latest->version + 1) : 1;

            $draft = WorkflowDefinition::create([
                'transaction_type_id' => $typeId,
                'version' => $nextVersion,
                'status' => 'draft',
                'name' => $data['name'] ?? null,
                'notes' => $data['notes'] ?? null,
            ]);

            if ($clone) {
                $published = WorkflowDefinition::where('transaction_type_id', $typeId)
                    ->where('status', 'published')
                    ->orderByDesc('version')
                    ->first();

                if ($published) {
                    $this->cloneFrom($published, $draft);
                }
            }

            return $draft->load(['steps.roles', 'routes']);
        });
    }

    public function publish(WorkflowDefinition $definition, int $userId, ?string $notes = null): WorkflowDefinition
    {
        if ($definition->status !== 'draft') {
            throw ValidationException::withMessages(['status' => 'Only draft workflows can be published.']);
        }

        return DB::transaction(function () use ($definition, $userId, $notes) {
            $startCount = $definition->steps()->where('is_start', true)->count();
            $endCount = $definition->steps()->where('is_end', true)->count();

            if ($startCount < 1 || $endCount < 1) {
                throw ValidationException::withMessages([
                    'steps' => 'Process Version must have at least one start step and one end step before publishing.',
                ]);
            }

            $definition->update([
                'status' => 'published',
                'notes' => $notes ?? $definition->notes,
                'published_at' => now(),
                'published_by' => $userId,
            ]);

            return $definition->fresh()->load(['steps.roles', 'routes']);
        });
    }

    public function assertDraft(WorkflowDefinition $definition): void
    {
        if ($definition->status !== 'draft') {
            throw ValidationException::withMessages(['status' => 'Published workflows are immutable. Create a new draft version.']);
        }
    }

    private function cloneFrom(WorkflowDefinition $from, WorkflowDefinition $to): void
    {
        $map = [];
        foreach ($from->steps()->with('roles')->orderBy('order_number')->get() as $step) {
            $new = WorkflowStep::create([
                'workflow_definition_id' => $to->id,
                'order_number' => $step->order_number,
                'code' => $step->code,
                'name' => $step->name,
                'stage' => $step->stage,
                'sla_minutes' => $step->sla_minutes,
                'is_start' => $step->is_start,
                'is_end' => $step->is_end,
            ]);

            $new->roles()->sync($step->roles->pluck('id')->all());
            $map[$step->id] = $new->id;
        }

        foreach ($from->routes()->get() as $route) {
            WorkflowRoute::create([
                'workflow_definition_id' => $to->id,
                'from_step_id' => $map[$route->from_step_id] ?? null,
                'to_step_id' => $map[$route->to_step_id] ?? null,
                'action_code' => $route->action_code,
                'is_return_route' => $route->is_return_route,
                'condition_expression' => $route->condition_expression,
                'route_group' => $route->route_group,
                'required_approvals_count' => $route->required_approvals_count,
            ]);
        }

        // Carry checklist + form config so clones never go blank:
        // requirement definitions are version-scoped (clone rows),
        // field definitions may be global (reuse) or version-scoped (clone rows).
        $reqMap = [];
        foreach ($from->requirementDefinitions()->get() as $req) {
            $new = RequirementDefinition::create([
                'workflow_definition_id' => $to->id,
                'order_number' => $req->order_number,
                'code' => $req->code,
                'name' => $req->name,
                'description' => $req->description,
                'is_active' => $req->is_active,
            ]);
            $reqMap[$req->id] = $new->id;
        }

        $fieldMap = [];
        $fromSteps = $from->steps()->with('fieldDefinitions')->get();
        foreach ($fromSteps as $step) {
            $newStepId = $map[$step->id] ?? null;
            if (!$newStepId) continue;

            $fieldPayload = [];
            foreach ($step->fieldDefinitions as $field) {
                $fieldId = $field->id;
                if ((int) $field->workflow_definition_id === (int) $from->id) {
                    if (!isset($fieldMap[$field->id])) {
                        $clone = FieldDefinition::create(array_merge(
                            $field->only([
                                'order_number', 'code', 'name', 'type', 'step_scope',
                                'display_order', 'group', 'required', 'unique', 'sensitive',
                                'min_length', 'max_length', 'min_value', 'max_value',
                                'options', 'validation_rules',
                            ]),
                            ['workflow_definition_id' => $to->id]
                        ));
                        $fieldMap[$field->id] = $clone->id;
                    }
                    $fieldId = $fieldMap[$field->id];
                }
                $fieldPayload[$fieldId] = [
                    'display_order' => $field->pivot->display_order ?? 0,
                    'required_override' => $field->pivot->required_override,
                ];
            }
            if (count($fieldPayload)) {
                WorkflowStep::find($newStepId)->fieldDefinitions()->sync($fieldPayload);
            }

            $reqPayload = [];
            foreach ($step->requirementDefinitions()->get() as $req) {
                if (!isset($reqMap[$req->id])) continue;
                $reqPayload[$reqMap[$req->id]] = [
                    'display_order' => $req->pivot->display_order ?? 0,
                    'is_required' => (bool) ($req->pivot->is_required ?? true),
                ];
            }
            if (count($reqPayload)) {
                WorkflowStep::find($newStepId)->requirementDefinitions()->sync($reqPayload);
            }
        }
    }
}
