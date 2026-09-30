<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\UpsertWorkflowStepRequest;
use App\Http\Resources\WorkflowStepResource;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\WorkflowVersioningService;
use Illuminate\Http\Request;

class WorkflowStepController extends Controller
{
    /**
     * List steps for a workflow definition.
     * Needed because your routes/api.php calls WorkflowStepController@index.
     */
    public function index(Request $request, WorkflowDefinition $workflowDefinition)
    {
        $steps = $workflowDefinition->steps()
            ->with(['roles', 'office'])
            ->orderBy('order_number')
            ->get();

        return WorkflowStepResource::collection($steps);
    }

    /**
     * Optional: fetch a single step (handy for StepFields pages / sanity checks).
     * Not required by your current routes, but safe to include.
     */
    public function show(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        return new WorkflowStepResource($workflowStep->load(['roles', 'office']));
    }

    public function store(
        UpsertWorkflowStepRequest $request,
        WorkflowDefinition $workflowDefinition,
        WorkflowVersioningService $svc
    ) {
        $svc->assertDraft($workflowDefinition);

        $data = $request->validated();
        $this->assertValidParent($workflowDefinition, $data['parent_id'] ?? null, null);

        // Auto-code like office steps: {typecode}_{order}, generated once
        // at creation and frozen afterwards (route conditions may
        // reference step codes, so renumbers never rewrite them).
        if (empty($data['code'])) {
            $data['code'] = $this->nextCode($workflowDefinition, (int) $data['order_number']);
        }

        $step = $workflowDefinition->steps()->create($data);

        if (isset($data['role_ids'])) {
            $step->roles()->sync($data['role_ids']);
        }

        return (new WorkflowStepResource($step->load(['roles', 'office'])))->response()->setStatusCode(201);
    }

    public function update(
        UpsertWorkflowStepRequest $request,
        WorkflowDefinition $workflowDefinition,
        WorkflowStep $workflowStep,
        WorkflowVersioningService $svc
    ) {
        $svc->assertDraft($workflowDefinition);

        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        $data = $request->validated();
        if (array_key_exists('parent_id', $data)) {
            $this->assertValidParent($workflowDefinition, $data['parent_id'], $workflowStep->id);
        }
        // Codes stay frozen after creation (see store()).
        if (empty($data['code'])) {
            unset($data['code']);
        }
        $workflowStep->update($data);

        if (isset($data['role_ids'])) {
            $workflowStep->roles()->sync($data['role_ids']);
        }

        return new WorkflowStepResource($workflowStep->load(['roles', 'office']));
    }

    public function destroy(
        Request $request,
        WorkflowDefinition $workflowDefinition,
        WorkflowStep $workflowStep,
        WorkflowVersioningService $svc
    ) {
        $svc->assertDraft($workflowDefinition);

        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        // Safety net for one-click Save flow: never delete a station
        // that live papers are currently sitting on.
        $occupants = \App\Models\TransactionState::where('current_step_id', $workflowStep->id)->count();
        if ($occupants > 0) {
            return response()->json([
                'message' => "Cannot delete: {$occupants} transaction(s) are currently on this step.",
            ], 422);
        }

        $workflowStep->delete();

        return response()->json(['message' => 'Deleted']);
    }

    /**
     * Parent must live in the same transaction steps and must not create
     * a cycle (a step can never sit under itself or its own sub-step).
     */
    private function assertValidParent(WorkflowDefinition $workflowDefinition, ?int $parentId, ?int $selfId): void
    {
        if ($parentId === null) return;

        $seen = $selfId ? [$selfId] : [];
        $cursor = $parentId;

        while ($cursor !== null) {
            if (in_array($cursor, $seen, true)) {
                abort(422, 'Circular hierarchy detected: a step cannot sit under itself or its own sub-step.');
            }
            $ancestor = WorkflowStep::withTrashed()->find($cursor);
            if (!$ancestor || (int) $ancestor->workflow_definition_id !== (int) $workflowDefinition->id) {
                abort(422, 'Parent step must belong to the same transaction steps.');
            }
            $seen[] = $cursor;
            $cursor = $ancestor->parent_id;
        }
    }

    /**
     * Auto code in the form {typecode}_{order}, e.g. communication_1.
     * Suffixes (-2, -3…) on collision, trashed rows included
     * since codes stay unique per flow.
     */
    private function nextCode(WorkflowDefinition $workflowDefinition, int $order): string
    {
        $workflowDefinition->loadMissing('transactionType');
        $base = strtolower(preg_replace('/[^a-z0-9]+/', '_', $workflowDefinition->transactionType?->code ?? 'step'));
        $base = trim($base, '_') ?: 'step';

        $candidate = "{$base}_{$order}";
        $suffix = 2;
        while (
            WorkflowStep::withTrashed()
                ->where('workflow_definition_id', $workflowDefinition->id)
                ->where('code', $candidate)
                ->exists()
        ) {
            $candidate = "{$base}_{$order}-{$suffix}";
            $suffix++;
        }

        return $candidate;
    }
}
