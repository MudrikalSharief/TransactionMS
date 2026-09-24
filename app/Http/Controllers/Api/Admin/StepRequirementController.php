<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\RequirementDefinition;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\ChecklistService;
use Illuminate\Http\Request;

class StepRequirementController extends Controller
{
    public function __construct(private ChecklistService $checklists)
    {
    }

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
                    $r->only(['id','code','name','label','description','is_active','order_number']),
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
            // Optional inline edits of the definition itself (code/remarks).
            'requirements.*.code' => ['nullable','string','max:64'],
            'requirements.*.description' => ['nullable','string'],
        ]);

        $sync = [];
        foreach ($payload['requirements'] as $row) {
            $rid = (int) $row['requirement_definition_id'];
            $sync[$rid] = [
                'display_order' => (int) ($row['display_order'] ?? 0),
                'is_required' => array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true,
            ];

            if (array_key_exists('code', $row) || array_key_exists('description', $row)) {
                RequirementDefinition::whereKey($rid)->update(array_filter([
                    'code' => $row['code'] ?? null,
                    'description' => $row['description'] ?? null,
                ], fn ($v, $k) => array_key_exists($k, $row), ARRAY_FILTER_USE_BOTH));
            }
        }

        $workflowStep->requirementDefinitions()->sync($sync);
        // This step's requirements feed its successors' checklists.
        $this->checklists->syncSuccessorsOf($workflowStep);

        return response()->json(['message' => 'Saved']);
    }
}
