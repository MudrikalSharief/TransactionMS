<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\RequirementDefinition;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\AuditService;
use App\Services\ChecklistService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StepRequirementController extends Controller
{
    public function __construct(private ChecklistService $checklists)
    {
    }

    public function index(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep)
    {
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        $items = $workflowStep->requirementDefinitions()
            ->orderBy('step_requirements.display_order')
            ->orderBy('requirement_definitions.order_number')
            ->get()
            ->map(function ($r) {
                return array_merge(
                    $r->only(['id','code','name','label','description','is_active','order_number']),
                    [
                        'pivot_meta' => [
                            'display_order' => (int) ($r->pivot?->display_order ?? 0),
                            'is_required' => (bool) ($r->pivot?->is_required ?? true),
                            'is_upload_required' => \App\Models\RequirementDefinition::pivotNeedsUpload($r->pivot),
                        ],
                    ]
                );
            });

        return response()->json(['data' => $items]);
    }

    public function sync(Request $request, WorkflowDefinition $workflowDefinition, WorkflowStep $workflowStep, AuditService $audit)
    {
        // Live-editable: assignment changes apply to running transactions immediately.
        if ((int) $workflowStep->workflow_definition_id !== (int) $workflowDefinition->id) {
            abort(404);
        }

        $payload = $request->validate([
            'requirements' => ['required','array'],
            'requirements.*.requirement_definition_id' => ['required','integer'],
            'requirements.*.display_order' => ['nullable','integer','min:0'],
            'requirements.*.is_required' => ['nullable','boolean'],
            'requirements.*.is_upload_required' => ['nullable','boolean'],
            // Optional inline edits of the definition itself (code/remarks).
            'requirements.*.code' => ['nullable','string','max:64'],
            'requirements.*.description' => ['nullable','string'],
        ]);

        return DB::transaction(function () use ($request, $workflowStep, $payload, $audit) {
            $beforeBindings = $workflowStep->requirementDefinitions()->get()->map(fn ($requirement) => [
                'requirement_definition_id' => (int) $requirement->id,
                'display_order' => (int) ($requirement->pivot?->display_order ?? 0),
                'is_required' => (bool) ($requirement->pivot?->is_required ?? true),
                'is_upload_required' => \App\Models\RequirementDefinition::pivotNeedsUpload($requirement->pivot),
            ])->values()->all();

            $definitionIds = collect($payload['requirements'])->pluck('requirement_definition_id')->map(fn ($id) => (int) $id)->all();
            $beforeDefinitions = RequirementDefinition::whereIn('id', $definitionIds)->get()->mapWithKeys(
                fn ($requirement) => [$requirement->id => $requirement->only(['code', 'description'])]
            )->all();

            $sync = [];
            foreach ($payload['requirements'] as $row) {
                $rid = (int) $row['requirement_definition_id'];
                $sync[$rid] = [
                    'display_order' => (int) ($row['display_order'] ?? 0),
                    'is_required' => array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true,
                    'is_upload_required' => array_key_exists('is_upload_required', $row)
                        ? (bool) $row['is_upload_required']
                        : (array_key_exists('is_required', $row) ? (bool) $row['is_required'] : true),
                ];
                // Required implies upload: a verified physical copy also needs its file.
                $sync[$rid]['is_upload_required'] = $sync[$rid]['is_upload_required'] || $sync[$rid]['is_required'];

                if (array_key_exists('code', $row) || array_key_exists('description', $row)) {
                    RequirementDefinition::whereKey($rid)->update(array_filter([
                        'code' => $row['code'] ?? null,
                        'description' => $row['description'] ?? null,
                    ], fn ($v, $k) => array_key_exists($k, $row), ARRAY_FILTER_USE_BOTH));
                }
            }

            $workflowStep->requirementDefinitions()->sync($sync);
            // This step's requirements feed its successors' checklists.
            $this->checklists->syncSuccessorsOf($workflowStep);

            $afterBindings = $workflowStep->requirementDefinitions()->get()->map(fn ($requirement) => [
                'requirement_definition_id' => (int) $requirement->id,
                'display_order' => (int) ($requirement->pivot?->display_order ?? 0),
                'is_required' => (bool) ($requirement->pivot?->is_required ?? true),
                'is_upload_required' => \App\Models\RequirementDefinition::pivotNeedsUpload($requirement->pivot),
            ])->values()->all();

            $afterDefinitions = RequirementDefinition::whereIn('id', $definitionIds)->get()->mapWithKeys(
                fn ($requirement) => [$requirement->id => $requirement->only(['code', 'description'])]
            )->all();

            $audit->log($request, 'step_requirements.sync', $workflowStep, [
                'before' => [
                    'requirements' => $beforeBindings,
                    'definitions' => $beforeDefinitions,
                ],
                'after' => [
                    'requirements' => $afterBindings,
                    'definitions' => $afterDefinitions,
                ],
                'entity_label' => $workflowStep->name,
                'description' => "Updated requirements for {$workflowStep->name}",
            ]);

            return response()->json(['message' => 'Saved']);
        });
    }
}
