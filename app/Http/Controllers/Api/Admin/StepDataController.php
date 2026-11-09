<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\AuditService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class StepDataController extends Controller
{
    public function index(WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        return response()->json(
            $workflowStep->stepDataDefinitions()->orderBy('display_order')->get()
        );
    }

    // Step Data Overview board: every step's step-data rows in one response,
    // ordered by step order then display_order.
    public function overview(WorkflowDefinition $workflowDefinition)
    {
        $steps = $workflowDefinition->steps()
            ->with('stepDataDefinitions')
            ->orderBy('order_number')
            ->orderBy('id')
            ->get();

        return response()->json(
            $steps->map(function (WorkflowStep $step) {
                return [
                    'step_id' => (int) $step->id,
                    'order_number' => $step->order_number,
                    'name' => $step->name,
                    'code' => $step->code,
                    'rows' => $step->stepDataDefinitions->map(function ($row) {
                        return [
                            'id' => (int) $row->id,
                            'code' => $row->code,
                            'name' => $row->display_name,
                            'type' => $row->type,
                            'is_required' => (bool) $row->is_required,
                            'display_order' => (int) $row->display_order,
                            'min_length' => $row->min_length,
                            'max_length' => $row->max_length,
                        ];
                    })->values()->all(),
                ];
            })->all()
        );
    }

    public function store(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, AuditService $audit)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            return response()->json(['message' => 'Step does not belong to this workflow definition.'], 404);
        }

        $data = $request->validate([
            'code' => ['required', 'string', 'max:100', Rule::unique('workflow_step_data')->where(fn ($q) => $q->where('workflow_step_id', $workflowStep->id)->whereNull('deleted_at'))],
            'display_name' => ['required', 'string', 'max:255'],
            'type' => ['nullable', 'string', 'max:50'],
            'is_required' => ['nullable', 'boolean'],
            'display_order' => ['nullable', 'integer', 'min:0'],
            'min_length' => ['nullable', 'integer', 'min:0'],
            'max_length' => ['nullable', 'integer', 'min:0'],
        ]);

        return DB::transaction(function () use ($request, $workflowStep, $data, $audit) {
            $row = $workflowStep->stepDataDefinitions()->create([
                'code' => $data['code'],
                'display_name' => $data['display_name'],
                'type' => $data['type'] ?? 'text',
                'is_required' => (bool) ($data['is_required'] ?? false),
                'display_order' => (int) ($data['display_order'] ?? 0),
                'min_length' => $data['min_length'] ?? null,
                'max_length' => $data['max_length'] ?? null,
            ]);

            $audit->log($request, 'workflow_step_data.create', $row, [
                'new' => $row->only(['workflow_step_id', 'code', 'display_name', 'type', 'is_required', 'display_order', 'min_length', 'max_length']),
                'entity_label' => $workflowStep->name . ' — ' . $row->display_name,
                'office_id' => $workflowStep->office_id,
            ]);

            return response()->json($row, 201);
        });
    }

    public function update(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, int $stepData, AuditService $audit)
    {
        $row = $workflowStep->stepDataDefinitions()->findOrFail($stepData);

        $data = $request->validate([
            'code' => ['sometimes', 'string', 'max:100', Rule::unique('workflow_step_data')->where(fn ($q) => $q->where('workflow_step_id', $workflowStep->id)->whereNull('deleted_at'))->ignore($row->id)],
            'display_name' => ['sometimes', 'string', 'max:255'],
            'type' => ['nullable', 'string', 'max:50'],
            'is_required' => ['nullable', 'boolean'],
            'display_order' => ['nullable', 'integer', 'min:0'],
            'min_length' => ['nullable', 'integer', 'min:0'],
            'max_length' => ['nullable', 'integer', 'min:0'],
        ]);

        $fields = ['code', 'display_name', 'type', 'is_required', 'display_order', 'min_length', 'max_length'];
        $before = $row->only($fields);

        return DB::transaction(function () use ($request, $row, $data, $fields, $before, $workflowStep, $audit) {
            $row->update($data);

            $audit->log($request, 'workflow_step_data.update', $row, [
                'before' => $before,
                'after' => $row->only($fields),
                'entity_label' => $workflowStep->name . ' — ' . $row->display_name,
                'office_id' => $workflowStep->office_id,
            ]);

            return response()->json($row->fresh());
        });
    }

    public function destroy(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, int $stepData, AuditService $audit)
    {
        return DB::transaction(function () use ($request, $workflowStep, $stepData, $audit) {
            $row = $workflowStep->stepDataDefinitions()->findOrFail($stepData);
            $old = $row->only(['workflow_step_id', 'code', 'display_name', 'type', 'is_required', 'display_order', 'min_length', 'max_length']);
            $row->delete();

            $audit->log($request, 'workflow_step_data.delete', $row, [
                'old' => $old,
                'entity_label' => $workflowStep->name . ' — ' . ($old['display_name'] ?? $old['code'] ?? ''),
                'office_id' => $workflowStep->office_id,
            ]);

            return response()->json(['message' => 'Deleted']);
        });
    }
}
