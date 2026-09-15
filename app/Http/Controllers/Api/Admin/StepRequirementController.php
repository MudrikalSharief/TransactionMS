<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Http\Request;

class StepRequirementController extends Controller
{
    public function index(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        $items = $workflowStep->requirementDefinitions()
            ->orderBy('step_requirements.display_order')
            ->orderBy('requirement_definitions.order_number')
            ->get()
            ->map(function ($r) {
                return array_merge(
                    $r->only(['id','code','name','description','is_active','order_number']),
                    [
                        'pivot_meta' => [
                            'display_order' => (int) ($r->pivot?->display_order ?? 0),
                            'is_required' => (bool) ($r->pivot?->is_required ?? true),
                        ],
                    ]
                );
            });

        return response()->json(['data' => $items]);
    }

    public function sync(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        // Live-editable: assignment changes apply to running transactions immediately.
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        $payload = $request->validate([
            'requirements' => ['required','array'],
            'requirements.*.requirement_definition_id' => ['required','integer'],
            'requirements.*.display_order' => ['nullable','integer','min:0'],
            'requirements.*.is_required' => ['nullable','boolean'],
        ]);

        $sync = [];
        foreach ($payload['requirements'] as $row) {
            $rid = (int) $row['requirement_definition_id'];
            $sync[$rid] = [
                'display_order' => (int) ($row['display_order'] ?? 0),
                'is_required' => array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true,
            ];
        }

        $workflowStep->requirementDefinitions()->sync($sync);

        return response()->json(['message' => 'Saved']);
    }
}
