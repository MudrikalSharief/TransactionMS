<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Workflows\ApplyStagedWorkflowRequest;
use App\Http\Requests\Admin\Workflows\CreateDraftRequest;
use App\Http\Requests\Admin\Workflows\PublishWorkflowRequest;
use App\Http\Requests\Admin\Workflows\SaveAsVersionRequest;
use App\Http\Resources\WorkflowDefinitionResource;
use App\Services\WorkflowStagingService;
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
            ->with(['steps.roles', 'steps.office', 'routes'])
            ->orderByDesc('version');

        if ($typeId) $q->where('transaction_type_id', $typeId);

        return WorkflowDefinitionResource::collection($q->get());
    }

    public function show(WorkflowDefinition $workflowDefinition)
    {
        return new WorkflowDefinitionResource(
            $workflowDefinition->load(['steps.roles', 'steps.office', 'routes'])
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

    public function saveAs(SaveAsVersionRequest $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc, AuditService $audit)
    {
        $saved = $svc->saveAs(
            $workflowDefinition,
            $request->user()->id,
            $request->validated()['name'],
            $request->validated()['notes'] ?? null
        );

        $audit->log($request, 'workflow_definitions.save_as', $saved, [
            'source_id' => $workflowDefinition->id,
            'source_version' => $workflowDefinition->version,
            'to_version' => $saved->version,
            'name' => $saved->name,
        ]);

        return (new WorkflowDefinitionResource($saved))->response()->setStatusCode(201);
    }

    /**
     * Staged save: apply a client-staged diff (steps/routes/requirements/
     * checklists/field-assignments) onto the open draft in ONE atomic
     * transaction — nothing persists until this is called.
     *
     * Modes: overwrite (stay draft) vs create-new (name required, publishes;
     * a start/end validation failure still keeps the staged content as draft).
     */
    public function applyStaged(
        ApplyStagedWorkflowRequest $request,
        WorkflowDefinition $workflowDefinition,
        WorkflowStagingService $staging,
        \App\Services\ChecklistService $checklists,
        AuditService $audit
    ) {
        $result = $staging->apply(
            $workflowDefinition,
            $request->user()->id,
            $request->validated(),
            $checklists
        );

        $audit->log($request, 'workflow_definitions.apply_staged', $result['definition'], [
            'mode' => $request->validated()['mode'],
            'published' => $result['published'],
            'applied' => $result['applied'],
        ]);

        return (new WorkflowDefinitionResource($result['definition']))->additional([
            'meta' => [
                'mode' => $request->validated()['mode'],
                'published' => $result['published'],
                'message' => $result['message'],
                'applied' => $result['applied'],
            ],
        ])->response()->setStatusCode($result['published'] ? 201 : 200);
    }

    public function makeLive(Request $request, WorkflowDefinition $workflowDefinition, WorkflowVersioningService $svc, AuditService $audit)
    {
        $from = WorkflowDefinition::where('transaction_type_id', $workflowDefinition->transaction_type_id)
            ->where('is_live', true)
            ->first();

        $live = $svc->makeLive($workflowDefinition);

        $audit->log($request, 'workflow_definitions.make_live', $live, [
            'from_version' => $from?->version,
            'from_id' => $from?->id,
            'to_version' => $live->version,
            'to_id' => $live->id,
        ]);

        return new WorkflowDefinitionResource($live);
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, AuditService $audit)
    {
        if ($workflowDefinition->status !== 'draft') {
            return response()->json(['message' => 'Only drafts can be deleted.'], 422);
        }

        if (Transaction::where('workflow_definition_id', $workflowDefinition->id)->exists()) {
            return response()->json(['message' => 'Cannot delete: transactions use this transaction type.'], 422);
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
