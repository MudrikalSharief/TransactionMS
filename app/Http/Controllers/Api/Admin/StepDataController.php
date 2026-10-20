<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class StepDataController extends Controller
{
    public function index(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        return response()->json(
            $workflowStep->stepDataDefinitions()->orderBy('display_order')->get()
        );
    }

    public function store(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        $data = $request->validate([
            'code' => ['required', 'string', 'max:100', Rule::unique('workflow_step_data')->where(fn ($q) => $q->where('workflow_step_id', $workflowStep->id)->whereNull('deleted_at'))],
            'display_name' => ['required', 'string', 'max:255'],
            'type' => ['nullable', 'string', 'max:50'],
            'is_required' => ['nullable', 'boolean'],
            'display_order' => ['nullable', 'integer', 'min:0'],
            'min_length' => ['nullable', 'integer', 'min:0'],
            'max_length' => ['nullable', 'integer', 'min:0'],
        ]);

        $row = $workflowStep->stepDataDefinitions()->create([
            'code' => $data['code'],
            'display_name' => $data['display_name'],
            'type' => $data['type'] ?? 'text',
            'is_required' => (bool) ($data['is_required'] ?? false),
            'display_order' => (int) ($data['display_order'] ?? 0),
            'min_length' => $data['min_length'] ?? null,
            'max_length' => $data['max_length'] ?? null,
        ]);

        return response()->json($row, 201);
    }

    public function update(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, int $stepData)
    {
        $row = $workflowStep->stepDataDefinitions()->findOrFail($stepData);

        $data = $request->validate([
            'code' => ['sometimes', 'string', 'max:100', Rule::unique('workflow_step_data')->where(fn ($q) => $q->where('workflow_step_id', $workflowStep->id)->whereNull('deleted_at'))->ignore($row->id)],
            'display_name' => ['sometimes', 'string', 'max:255'],
            'type' => ['nullable', 'string', 'max:50'],
            'is_required' => ['nullable', 'boolean'],
            'display_order' => ['nullable', 'integer', 'min:0'],
            'min_length' => ['nullable', 'integer', 'min:0'],
            'max_length' => ['nullable', 'integer', 'min:0'],
        ]);

        $row->update($data);

        return response()->json($row->fresh());
    }

    public function destroy(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, int $stepData)
    {
        $row = $workflowStep->stepDataDefinitions()->findOrFail($stepData);
        $row->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
