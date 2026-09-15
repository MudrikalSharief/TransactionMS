<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\UpsertWorkflowRouteRequest;
use App\Http\Resources\WorkflowRouteResource;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Services\WorkflowVersioningService;
use Illuminate\Http\Request;

class WorkflowRouteController extends Controller
{
    public function store(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc)
    {
        $svc->assertDraft($workflowDefinition);

        $data = $request->validated();
        $route = $workflowDefinition->routes()->create($data);

        return (new WorkflowRouteResource($route))->response()->setStatusCode(201);
    }

    public function update(UpsertWorkflowRouteRequest $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        $workflowRoute->update($request->validated());
        return new WorkflowRouteResource($workflowRoute);
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, WorkflowRoute $workflowRoute, WorkflowVersioningService $svc)
    {
        $svc->assertDraft($workflowDefinition);

        if ($workflowRoute->workflow_definition_id !== $workflowDefinition->id) {
            abort(404);
        }

        $workflowRoute->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
