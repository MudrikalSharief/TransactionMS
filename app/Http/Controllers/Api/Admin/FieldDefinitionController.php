<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Fields\StoreFieldDefinitionRequest;
use App\Http\Requests\Admin\Fields\UpdateFieldDefinitionRequest;
use App\Http\Resources\FieldDefinitionResource;
use App\Models\FieldDefinition;
use App\Models\WorkflowDefinition;
use App\Services\AuditService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FieldDefinitionController extends Controller
{
    public function index(Request $request, WorkflowDefinition $workflowDefinition)
    {
        $fields = FieldDefinition::query()
            ->where('workflow_definition_id', $workflowDefinition->id)
            ->orderBy('order_number')
            ->orderBy('id')
            ->get();

        return FieldDefinitionResource::collection($fields);
    }

    public function store(StoreFieldDefinitionRequest $request, WorkflowDefinition $workflowDefinition, AuditService $audit)
    {
        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        $data = $request->validated();
        $assignStepIds = $data['assign_step_ids'] ?? null;
        unset($data['assign_step_ids']);

        return DB::transaction(function () use ($request, $workflowDefinition, $data, $assignStepIds, $audit) {
            $field = FieldDefinition::create(array_merge($data, [
                'workflow_definition_id' => $workflowDefinition->id,
            ]));

            if (is_array($assignStepIds) && count($assignStepIds)) {
                $steps = $workflowDefinition->steps()->whereIn('id', $assignStepIds)->get();
                $field->steps()->syncWithoutDetaching($steps->pluck('id')->all());
            }

            $audit->log($request, 'field_definitions.create', $field, [
                'new' => $field->only(['workflow_definition_id', 'order_number', 'code', 'name', 'type', 'step_scope', 'display_order', 'group', 'required', 'unique', 'sensitive', 'min_length', 'max_length', 'min_value', 'max_value', 'options', 'validation_rules'])
                    + ['step_ids' => $field->steps()->pluck('workflow_steps.id')->all()],
            ]);

            return new FieldDefinitionResource($field);
        });
    }

    public function update(UpdateFieldDefinitionRequest $request, WorkflowDefinition $workflowDefinition, FieldDefinition $fieldDefinition, AuditService $audit)
    {
        if ($workflowDefinition->id !== $fieldDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Field does not belong to this workflow definition.'], 404);
        }

        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        $fields = ['workflow_definition_id', 'order_number', 'code', 'name', 'type', 'step_scope', 'display_order', 'group', 'required', 'unique', 'sensitive', 'min_length', 'max_length', 'min_value', 'max_value', 'options', 'validation_rules'];
        $before = $fieldDefinition->only($fields);

        return DB::transaction(function () use ($request, $fieldDefinition, $fields, $before, $audit) {
            $fieldDefinition->update($request->validated());

            $audit->log($request, 'field_definitions.update', $fieldDefinition, [
                'before' => $before,
                'after' => $fieldDefinition->only($fields),
            ]);

            return new FieldDefinitionResource($fieldDefinition);
        });
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, FieldDefinition $fieldDefinition, AuditService $audit)
    {
        if ($workflowDefinition->id !== $fieldDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Field does not belong to this workflow definition.'], 404);
        }

        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        return DB::transaction(function () use ($request, $fieldDefinition, $audit) {
            $old = $fieldDefinition->only(['workflow_definition_id', 'order_number', 'code', 'name', 'type', 'step_scope', 'display_order', 'group', 'required', 'unique', 'sensitive', 'min_length', 'max_length', 'min_value', 'max_value', 'options', 'validation_rules']);
            $old['step_ids'] = $fieldDefinition->steps()->pluck('workflow_steps.id')->all();

            $fieldDefinition->delete();

            $audit->log($request, 'field_definitions.delete', $fieldDefinition, [
                'old' => $old,
            ]);

            return response()->noContent();
        });
    }
}
