<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\UpsertWorkflowRouteRequest;
use App\Http\Resources\WorkflowRouteResource;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Services\ChecklistService;
use App\Services\WorkflowVersioningService;
use Illuminate\Http\Request;

class WorkflowRouteController extends Controller
{
    public function store(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc, ChecklistService $checklists)
    {
        $svc->assertDraft($workflowDefinition);

        $data = $request->validated();
        // Backup guard (the form request already rejects these): return
        // routes are retired — going back is done via jump (Returned).
        if (!empty($data['is_return_route'])) {
            abort(422, 'Return routes are no longer allowed. Going back is done via jump to a visited station.');
        }
        $this->assertForwardUnique($workflowDefinition, (int) $data['from_step_id'], (int) $data['to_step_id']);
        $route = $workflowDefinition->routes()->create($data);

        // A new link feeds the destination's checklist from its predecessors.
        if ($to = $workflowDefinition->steps()->find($route->to_step_id)) {
            $checklists->syncFromRequirements($to);
        }

        return (new WorkflowRouteResource($route))->response()->setStatusCode(201);
    }

    public function update(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc, ChecklistService $checklists)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        $oldToStepId = (int) $workflowRoute->to_step_id;
        $data = $request->validated();
        if (!empty($data['is_return_route'])) {
            abort(422, 'Return routes are no longer allowed. Going back is done via jump to a visited station.');
        }
        $this->assertForwardUnique($workflowDefinition, (int) $data['from_step_id'], (int) $data['to_step_id'], (int) $workflowRoute->id);
        $workflowRoute->update($data);

        // Re-derive every checklist that could have gained/lost a predecessor.
        foreach (array_unique([$oldToStepId, (int) $workflowRoute->to_step_id]) as $stepId) {
            if ($step = $workflowDefinition->steps()->find($stepId)) {
                $checklists->syncFromRequirements($step);
            }
        }

        return new WorkflowRouteResource($workflowRoute);
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc, ChecklistService $checklists)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        $toStepId = (int) $workflowRoute->to_step_id;
        $workflowRoute->delete();

        if ($step = $workflowDefinition->steps()->find($toStepId)) {
            $checklists->syncFromRequirements($step);
        }

        return response()->json(['message' => 'Deleted']);
    }

    /**
     * Backup guard mirroring UpsertWorkflowRouteRequest: forward-only,
     * no self-loops, no duplicate From → To (regardless of action).
     * Grandfathered rows are untouched until edited.
     */
    private function assertForwardUnique(WorkflowDefinition $workflowDefinition, int $fromId, int $toId, int $selfId = 0): void
    {
        if ($fromId === $toId) {
            abort(422, 'From and To cannot be the same step.');
        }

        $steps = $workflowDefinition->steps()->whereIn('id', [$fromId, $toId])->get()->keyBy('id');
        $from = $steps->get($fromId);
        $to = $steps->get($toId);
        if (!$from || !$to) {
            abort(422, 'Both steps must belong to this workflow definition.');
        }
        if ((int) $to->order_number < (int) $from->order_number) {
            abort(422, "Routes must move forward: Step {$from->order_number} → Step {$to->order_number} is not allowed.");
        }

        $duplicate = $workflowDefinition->routes()
            ->where('from_step_id', $fromId)
            ->where('to_step_id', $toId)
            ->when($selfId > 0, fn ($q) => $q->where('id', '!=', $selfId))
            ->exists();
        if ($duplicate) {
            abort(422, 'This route already exists (same From → To), regardless of action.');
        }
    }
}
