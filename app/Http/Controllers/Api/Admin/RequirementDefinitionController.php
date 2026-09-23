<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Requirements\StoreRequirementDefinitionRequest;
use App\Http\Requests\Admin\Requirements\UpdateRequirementDefinitionRequest;
use App\Http\Resources\RequirementDefinitionResource;
use App\Models\RequirementDefinition;
use App\Models\TransactionRequirementCheck;
use App\Models\WorkflowDefinition;
use App\Services\ChecklistService;
use Illuminate\Http\Request;

class RequirementDefinitionController extends Controller
{
    public function __construct(private ChecklistService $checklists)
    {
    }

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

        if (empty($data['code'])) {
            $data['code'] = $this->makeUniqueCode($workflowDefinition->id, $data['name']);
        }

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
        $this->syncStepChecklists($requirementDefinition);

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

        $beforeStepIds = $requirementDefinition->steps()->pluck('workflow_steps.id')->map(fn ($id) => (int) $id)->all();
        $requirementDefinition->steps()->sync($sync);

        foreach (array_unique(array_merge($beforeStepIds, array_keys($sync))) as $sid) {
            $step = $workflowDefinition->steps()->find($sid);
            if ($step) {
                $this->checklists->syncFromRequirements($step);
            }
        }

        return response()->json(['message' => 'Saved']);
    }

    private function syncStepChecklists(RequirementDefinition $requirementDefinition): void
    {
        foreach ($requirementDefinition->steps as $step) {
            $this->checklists->syncFromRequirements($step);
        }
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

    /**
     * Auto code from the name, unique within this workflow definition
     * (falls back to a random suffix on collision).
     */
    private function makeUniqueCode(int $workflowDefinitionId, string $name): string
    {
        $base = strtolower(preg_replace('/[^a-z0-9]+/i', '_', $name));
        $base = trim($base, '_') ?: 'req';
        $base = substr($base, 0, 50);

        $code = $base;
        $i = 2;
        while (
            RequirementDefinition::withTrashed()
                ->where('workflow_definition_id', $workflowDefinitionId)
                ->where('code', $code)
                ->exists()
        ) {
            $code = $base . '_' . $i++;
        }

        return $code;
    }
}
