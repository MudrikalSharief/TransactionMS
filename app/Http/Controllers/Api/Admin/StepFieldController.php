<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\Fields\SyncStepFieldsRequest;
use App\Http\Resources\FieldDefinitionResource;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Http\Request;

class StepFieldController extends Controller
{
    public function index(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        $fields = $workflowStep->fieldDefinitions()->get();

        return FieldDefinitionResource::collection($fields);
    }

    public function sync(SyncStepFieldsRequest $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        if (method_exists($workflowDefinition, 'isPublished') && $workflowDefinition->isPublished()) {
            return response()->json([
                'message' => 'Cannot modify a published workflow definition. Create a new draft version.',
            ], 422);
        }

        $payload = [];
        foreach ($request->validated()['fields'] as $row) {
            $payload[(int) $row['field_definition_id']] = [
                'display_order' => (int) ($row['display_order'] ?? 0),
                'required_override' => array_key_exists('required_override', $row) ? $row['required_override'] : null,
            ];
        }

        $workflowStep->fieldDefinitions()->sync($payload);

        $fields = $workflowStep->fieldDefinitions()->get();

        return FieldDefinitionResource::collection($fields);
    }
}
