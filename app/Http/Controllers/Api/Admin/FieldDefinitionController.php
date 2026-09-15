<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Fields\StoreFieldDefinitionRequest;
use App\Http\Requests\Admin\Fields\UpdateFieldDefinitionRequest;
use App\Http\Resources\FieldDefinitionResource;
use App\Models\FieldDefinition;
use App\Models\WorkflowDefinition;
use Illuminate\Http\Request;

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

    public function store(StoreFieldDefinitionRequest $request, WorkflowDefinition $workflowDefinition)
    {
        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        $data = $request->validated();
        $assignStepIds = $data['assign_step_ids'] ?? null;
        unset($data['assign_step_ids']);

        $field = FieldDefinition::create(array_merge($data, [
            'workflow_definition_id' => $workflowDefinition->id,
        ]));

        if (is_array($assignStepIds) && count($assignStepIds)) {
            $steps = $workflowDefinition->steps()->whereIn('id', $assignStepIds)->get();
            $field->steps()->syncWithoutDetaching($steps->pluck('id')->all());
        }

        return new FieldDefinitionResource($field);
    }

    public function update(UpdateFieldDefinitionRequest $request, WorkflowDefinition $workflowDefinition, FieldDefinition $fieldDefinition)
    {
        if ($workflowDefinition->id !== $fieldDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Field does not belong to this workflow definition.'], 404);
        }

        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        $fieldDefinition->update($request->validated());

        return new FieldDefinitionResource($fieldDefinition);
    }

    public function destroy(WorkflowDefinition $workflowDefinition, FieldDefinition $fieldDefinition)
    {
        if ($workflowDefinition->id !== $fieldDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Field does not belong to this workflow definition.'], 404);
        }

        if ($workflowDefinition->isPublished()) {
            return response()->json(['message' => 'Cannot modify a published workflow definition. Create a new draft version.'], 422);
        }

        $fieldDefinition->delete();

        return response()->noContent();
    }
}
