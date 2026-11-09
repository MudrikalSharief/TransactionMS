<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\UpsertWorkflowRouteRequest;
use App\Http\Resources\WorkflowRouteResource;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Services\AuditService;
use App\Services\ChecklistService;
use App\Services\WorkflowVersioningService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class WorkflowRouteController extends Controller
{
    public function store(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc, ChecklistService $checklists, AuditService $audit)
    {
        $svc->assertDraft($workflowDefinition);

        $data = $request->validated();
        // Backup guard (the form request already rejects these): return
        // routes are retired — going back is done via jump (Returned).
        if (!empty($data['is_return_route'])) {
            abort(422, 'Return routes are no longer allowed. Going back is done via jump to a visited station.');
        }
        $this->assertForwardUnique($workflowDefinition, (int) $data['from_step_id'], (int) $data['to_step_id']);

        return DB::transaction(function () use ($request, $workflowDefinition, $checklists, $data, $audit) {
            $route = $workflowDefinition->routes()->create($data);

            // A new link feeds the destination's checklist from its predecessors.
            if ($to = $workflowDefinition->steps()->find($route->to_step_id)) {
                $checklists->syncFromRequirements($to);
            }

            $audit->log($request, 'workflow_routes.create', $route, [
                'new' => $route->only(['workflow_definition_id', 'from_step_id', 'to_step_id', 'action_code', 'is_return_route', 'condition_expression', 'route_group', 'required_approvals_count']),
                'entity_label' => $this->routeLabel($workflowDefinition, $route),
            ]);

            return (new WorkflowRouteResource($route))->response()->setStatusCode(201);
        });
    }

    public function update(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc, ChecklistService $checklists, AuditService $audit)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        $oldToStepId = (int) $workflowRoute->to_step_id;
        $before = $workflowRoute->only(['workflow_definition_id', 'from_step_id', 'to_step_id', 'action_code', 'is_return_route', 'condition_expression', 'route_group', 'required_approvals_count']);
        $data = $request->validated();
        if (!empty($data['is_return_route'])) {
            abort(422, 'Return routes are no longer allowed. Going back is done via jump to a visited station.');
        }
        $this->assertForwardUnique($workflowDefinition, (int) $data['from_step_id'], (int) $data['to_step_id'], (int) $workflowRoute->id);
        return DB::transaction(function () use ($request, $workflowDefinition, $workflowRoute, $checklists, $data, $before, $oldToStepId, $audit) {
            $workflowRoute->update($data);

            // Re-derive every checklist that could have gained/lost a predecessor.
            foreach (array_unique([$oldToStepId, (int) $workflowRoute->to_step_id]) as $stepId) {
                if ($step = $workflowDefinition->steps()->find($stepId)) {
                    $checklists->syncFromRequirements($step);
                }
            }

            $audit->log($request, 'workflow_routes.update', $workflowRoute, [
                'before' => $before,
                'after' => $workflowRoute->only(['workflow_definition_id', 'from_step_id', 'to_step_id', 'action_code', 'is_return_route', 'condition_expression', 'route_group', 'required_approvals_count']),
                'entity_label' => $this->routeLabel($workflowDefinition, $workflowRoute),
            ]);

            return new WorkflowRouteResource($workflowRoute);
        });
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc, ChecklistService $checklists, AuditService $audit)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        return DB::transaction(function () use ($request, $workflowDefinition, $workflowRoute, $checklists, $audit) {
            $toStepId = (int) $workflowRoute->to_step_id;
            $old = $workflowRoute->only(['workflow_definition_id', 'from_step_id', 'to_step_id', 'action_code', 'is_return_route', 'condition_expression', 'route_group', 'required_approvals_count']);
            $workflowRoute->delete();

            if ($step = $workflowDefinition->steps()->find($toStepId)) {
                $checklists->syncFromRequirements($step);
            }

            $audit->log($request, 'workflow_routes.delete', $workflowRoute, [
                'old' => $old,
                'entity_label' => $this->routeLabel($workflowDefinition, $workflowRoute),
            ]);

            return response()->json(['message' => 'Deleted']);
        });
    }

    /**
     * Backup guard mirroring UpsertWorkflowRouteRequest: forward-only,
     * no self-loops, no duplicate From → To (regardless of action).
     * Grandfathered rows are untouched until edited.
     */
    /** Human label for the audit log, e.g. "Step 1 -> Step 2". */
    private function routeLabel(WorkflowDefinition $workflowDefinition, WorkflowRoute $route): string
    {
        $names = $workflowDefinition->steps()
            ->whereIn('id', [$route->from_step_id, $route->to_step_id])
            ->pluck('name', 'id');

        $from = $names[$route->from_step_id] ?? ('Step ' . $route->from_step_id);
        $to = $names[$route->to_step_id] ?? ('Step ' . $route->to_step_id);

        return "{$from} → {$to}";
    }

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
