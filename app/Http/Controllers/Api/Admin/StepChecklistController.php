<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\ChecklistOverride;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\ChecklistService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StepChecklistController extends Controller
{
    public function __construct(private ChecklistService $checklists)
    {
    }

    public function index(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        $this->assertStepInDefinition($workflowDefinition, $workflowStep);

        // Mirrors the step's requirements (auto-add/remove) plus custom items.
        $items = $this->checklists->ensureItems($workflowStep);

        return response()->json(['data' => $this->mapRows($items)]);
    }

    public function sync(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        $this->assertStepInDefinition($workflowDefinition, $workflowStep);

        $payload = $request->validate([
            'items' => ['required', 'array'],
            'items.*.id' => ['nullable', 'integer'],
            'items.*.requirement_definition_id' => ['nullable', 'integer'],
            'items.*.name' => ['required', 'string', 'max:255'],
            'items.*.code' => ['nullable', 'string', 'max:64'],
            'items.*.description' => ['nullable', 'string'],
            'items.*.is_required' => ['nullable', 'boolean'],
            'items.*.display_order' => ['nullable', 'integer', 'min:0'],
        ]);

        DB::transaction(function () use ($workflowStep, $payload) {
            // Full replace of the submitted rows, then re-mirror requirements
            // so a linked item deleted in the UI comes back if the requirement
            // is still on the step.
            $workflowStep->checklistOverrides()->delete();

            $rows = [];
            foreach ($payload['items'] as $i => $row) {
                $rows[] = [
                    'workflow_step_id' => $workflowStep->id,
                    'requirement_definition_id' => $row['requirement_definition_id'] ?? null,
                    'name' => $row['name'],
                    'code' => $row['code'] ?? null,
                    'description' => $row['description'] ?? null,
                    'is_required' => array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true,
                    'display_order' => (int) ($row['display_order'] ?? $i),
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }

            if ($rows) {
                ChecklistOverride::insert($rows);
            }

            $this->checklists->syncFromRequirements($workflowStep);
        });

        return response()->json([
            'message' => 'Saved',
            'data' => $this->mapRows($this->checklists->itemsFor($workflowStep)),
        ]);
    }

    // Optional hard reset: wipe custom rows and re-mirror requirements.
    public function resync(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        $this->assertStepInDefinition($workflowDefinition, $workflowStep);

        $workflowStep->checklistOverrides()->delete();
        $this->checklists->syncFromRequirements($workflowStep);
        $items = $this->checklists->itemsFor($workflowStep);

        return response()->json(['data' => $this->mapRows($items)]);
    }

    private function assertStepInDefinition(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep): void
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }
    }

    private function mapRows($items)
    {
        return $items->map(fn ($r) => $r->only([
            'id',
            'requirement_definition_id',
            'name',
            'code',
            'description',
            'is_required',
            'display_order',
        ]));
    }
}
