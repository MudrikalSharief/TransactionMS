<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Requirements\StoreRequirementDefinitionRequest;
use App\Http\Requests\Admin\Requirements\UpdateRequirementDefinitionRequest;
use App\Http\Resources\RequirementDefinitionResource;
use App\Models\RequirementDefinition;
use App\Models\TransactionRequirementCheck;
use App\Models\WorkflowDefinition;
use Illuminate\Http\Request;

class RequirementDefinitionController extends Controller
{
    public function index(Request $request, WorkflowDefinition $workflowDefinition)
    {
        $items = RequirementDefinition::query()
            ->where('workflow_definition_id', $workflowDefinition->id)
            ->with('steps')
            ->orderBy('order_number')
            ->orderBy('id')
            ->get();

        return RequirementDefinitionResource::collection($items);
    }

    public function store(StoreRequirementDefinitionRequest $request, WorkflowDefinition $workflowDefinition)
    {
        // Live-editable: changes apply to running transactions immediately.
        $data = $request->validated();

        if (!array_key_exists('is_active', $data)) $data['is_active'] = true;
        if (!array_key_exists('order_number', $data)) $data['order_number'] = 0;

        $item = RequirementDefinition::create(array_merge($data, [
            'workflow_definition_id' => $workflowDefinition->id,
        ]));

        return (new RequirementDefinitionResource($item))->response()->setStatusCode(201);
    }

    public function update(UpdateRequirementDefinitionRequest $request, WorkflowDefinition $workflowDefinition, RequirementDefinition $requirementDefinition)
    {
        if ((int) $workflowDefinition->id !== (int) $requirementDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Requirement does not belong to this workflow definition.'], 404);
        }

        // Live-editable: changes apply to running transactions immediately.
        $requirementDefinition->update($request->validated());

        return new RequirementDefinitionResource($requirementDefinition);
    }

    public function syncSteps(Request $request, WorkflowDefinition $workflowDefinition, RequirementDefinition $requirementDefinition)
    {
        if ((int) $workflowDefinition->id !== (int) $requirementDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Requirement does not belong to this workflow definition.'], 404);
        }

        // Live-editable: assignment changes apply to running transactions immediately.
        $payload = $request->validate([
            'steps' => ['required', 'array'],
            'steps.*.workflow_step_id' => ['required', 'integer'],
            'steps.*.display_order' => ['nullable', 'integer', 'min:0'],
            'steps.*.is_required' => ['nullable', 'boolean'],
        ]);

        $sync = [];
        foreach ($payload['steps'] as $row) {
            $sid = (int) $row['workflow_step_id'];
            $sync[$sid] = [
                'display_order' => (int) ($row['display_order'] ?? 0),
                'is_required' => array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true,
            ];
        }

        if (!empty($sync)) {
            $validStepIds = $workflowDefinition->steps()->whereIn('id', array_keys($sync))->pluck('id')->map(fn ($id) => (int) $id)->all();
            $invalid = array_diff(array_keys($sync), $validStepIds);
            if (!empty($invalid)) {
                return response()->json(['message' => 'Steps do not belong to this workflow definition: ' . implode(', ', $invalid)], 422);
            }
        }

        $requirementDefinition->steps()->sync($sync);

        return response()->json(['message' => 'Saved']);
    }

    public function destroy(WorkflowDefinition $workflowDefinition, RequirementDefinition $requirementDefinition)
    {
        if ((int) $workflowDefinition->id !== (int) $requirementDefinition->workflow_definition_id) {
            return response()->json(['message' => 'Requirement does not belong to this workflow definition.'], 404);
        }

        // Safety: deleting an item workers already checked would orphan
        // compliance history. Unassign it from steps instead, or delete
        // only items with no checks yet.
        if (TransactionRequirementCheck::where('requirement_definition_id', $requirementDefinition->id)->exists()) {
            return response()->json([
                'message' => 'Cannot delete: workers already checked this item. Set it inactive instead.',
            ], 422);
        }

        $requirementDefinition->delete();

        return response()->noContent();
    }
}
