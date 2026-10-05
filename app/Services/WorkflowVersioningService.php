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
                return $existing->load(['steps.roles', 'steps.office', 'routes']);
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

            return $draft->load(['steps.roles', 'steps.office', 'routes']);
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
                    'steps' => 'Transaction Type Version must have at least one start step and one end step before publishing.',
                ]);
            }

            // Publishing goes live: the flag moves here, old versions kept.
            WorkflowDefinition::where('transaction_type_id', $definition->transaction_type_id)
                ->where('id', '!=', $definition->id)
                ->update(['is_live' => false]);

            $definition->update([
                'status' => 'published',
                'is_live' => true,
                'notes' => $notes ?? $definition->notes,
                'published_at' => now(),
                'published_by' => $userId,
            ]);

            return $definition->fresh()->load(['steps.roles', 'steps.office', 'routes']);
        });
    }

    /**
     * Switch the live version to an older published def ("change from and
     * to"). Old versions are kept — only the is_live flag moves. Running
     * transactions stay pinned to their own workflow_definition_id; only
     * new transactions use the newly-live version.
     */
    public function makeLive(WorkflowDefinition $definition): WorkflowDefinition
    {
        if ($definition->status !== 'published') {
            throw ValidationException::withMessages([
                'status' => 'Only published versions can be made live. Publish the draft first.',
            ]);
        }

        if ($definition->is_live) {
            return $definition->load(['steps.roles', 'steps.office', 'routes']);
        }

        return DB::transaction(function () use ($definition) {
            $draftExists = WorkflowDefinition::where('transaction_type_id', $definition->transaction_type_id)
                ->where('status', 'draft')
                ->exists();

            if ($draftExists) {
                throw ValidationException::withMessages([
                    'status' => 'There is an open draft for this transaction type. Publish or delete it first.',
                ]);
            }

            WorkflowDefinition::where('transaction_type_id', $definition->transaction_type_id)
                ->where('id', '!=', $definition->id)
                ->update(['is_live' => false]);

            $definition->update(['is_live' => true]);

            return $definition->fresh()->load(['steps.roles', 'steps.office', 'routes']);
        });
    }

    /**
     * Save the viewed version under a user-typed name as a brand-new live
     * version ("Save version" button). Pressing it again with another name
     * creates yet another live version — old ones are always kept.
     * Running transactions stay pinned; only new ones use the new live.
     *
     * - Published source → cloned as version max+1 with the given name,
     *   published, and made live.
     * - Draft source → renamed and published (goes live).
     */
    public function saveAs(WorkflowDefinition $source, int $userId, string $name, ?string $notes = null): WorkflowDefinition
    {
        if ($source->status === 'draft') {
            return DB::transaction(function () use ($source, $userId, $name, $notes) {
                $source->update([
                    'name' => $name,
                    'notes' => $notes ?? $source->notes,
                ]);

                return $this->publish($source->fresh(), $userId);
            });
        }

        if ($source->status !== 'published') {
            throw ValidationException::withMessages([
                'status' => 'Only draft or published versions can be saved as a new version.',
            ]);
        }

        return DB::transaction(function () use ($source, $userId, $name, $notes) {
            $draftExists = WorkflowDefinition::where('transaction_type_id', $source->transaction_type_id)
                ->where('status', 'draft')
                ->exists();

            if ($draftExists) {
                throw ValidationException::withMessages([
                    'status' => 'There is an open draft for this transaction type. Publish or delete it first.',
                ]);
            }

            $nextVersion = (int) (WorkflowDefinition::where('transaction_type_id', $source->transaction_type_id)
                ->max('version') ?? 0) + 1;

            $draft = WorkflowDefinition::create([
                'transaction_type_id' => $source->transaction_type_id,
                'version' => $nextVersion,
                'status' => 'draft',
                'name' => $name,
                'notes' => $notes,
            ]);

            $this->cloneFrom($source, $draft);

            return $this->publish($draft, $userId);
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
                'office_id' => $step->office_id,
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
                    'is_upload_required' => (bool) ($req->pivot->is_upload_required ?? $req->pivot->is_required ?? true),
                ];
            }
            if (count($reqPayload)) {
                WorkflowStep::find($newStepId)->requirementDefinitions()->sync($reqPayload);
            }

            // Carry the free-edited checklist so publish never blanks a step.
            $newStep = WorkflowStep::find($newStepId);
            foreach ($step->checklistOverrides()->get() as $item) {
                $newStep->checklistOverrides()->create([
                    'requirement_definition_id' => isset($reqMap[$item->requirement_definition_id])
                        ? $reqMap[$item->requirement_definition_id]
                        : null,
                    'name' => $item->name,
                    'code' => $item->code,
                    'description' => $item->description,
                    'is_required' => (bool) $item->is_required,
                    'display_order' => (int) $item->display_order,
                ]);
            }
        }
    }
}
