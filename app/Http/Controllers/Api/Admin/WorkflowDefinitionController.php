<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\CreateDraftRequest;
use App\Http\Requests\Admin\Workflows\PublishWorkflowRequest;
use App\Http\Resources\WorkflowDefinitionResource;
use App\Models\FieldDefinition;
use App\Models\RequirementDefinition;
use App\Models\Transaction;
use App\Models\WorkflowDefinition;
use App\Services\AuditService;
use App\Services\WorkflowVersioningService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class WorkflowDefinitionController extends Controller
{
    public function index(Request $request)
    {
        $typeId = $request->query('transaction_type_id');

        $q = WorkflowDefinition::query()
            ->with(['steps.roles', 'routes'])
            ->orderByDesc('version');

        if ($typeId) $q->where('transaction_type_id', $typeId);

        return WorkflowDefinitionResource::collection($q->get());
    }

    public function show(WorkflowDefinition $workflowDefinition)
    {
        return new WorkflowDefinitionResource(
            $workflowDefinition->load(['steps.roles', 'routes'])
        );
    }

    public function store(CreateDraftRequest $request, WorkflowVersioningService $svc)
    {
        $draft = $svc->createDraft($request->validated(), $request->user()->id);
        return (new WorkflowDefinitionResource($draft))->response()->setStatusCode(201);
    }

    public function publish(PublishWorkflowRequest $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc)
    {
        $published = $svc->publish($workflowDefinition, $request->user()->id, $request->validated()['notes'] ?? null);
        return new WorkflowDefinitionResource($published);
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, AuditService $audit)
    {
        if ($workflowDefinition->status !== 'draft') {
            return response()->json(['message' => 'Only drafts can be deleted.'], 422);
        }

        if (Transaction::where('workflow_definition_id', $workflowDefinition->id)->exists()) {
            return response()->json(['message' => 'Cannot delete: transactions use this process.'], 422);
        }

        return DB::transaction(function () use ($request, $workflowDefinition, $audit) {
            $info = $workflowDefinition->only(['transaction_type_id', 'version', 'status', 'name']);

            // Hard-delete the whole draft tree (all SoftDeletes: rows must
            // vanish so codes/versions never collide with a fresh draft).
            $workflowDefinition->routes()->forceDelete();
            $workflowDefinition->steps()->forceDelete();
            RequirementDefinition::where('workflow_definition_id', $workflowDefinition->id)->forceDelete();
            FieldDefinition::where('workflow_definition_id', $workflowDefinition->id)->forceDelete();
            $workflowDefinition->forceDelete();

            $audit->log($request, 'workflow_definitions.delete_draft', $workflowDefinition, [
                'deleted' => $info,
            ]);

            return response()->json(['message' => 'Draft deleted.']);
        });
    }
}
