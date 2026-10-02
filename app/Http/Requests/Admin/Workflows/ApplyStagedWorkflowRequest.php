<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Single-shot staged save for workflow content.
 *
 * Keys: integer ids reference existing rows (resolved in the target draft
 * by id, else by code within the same transaction type); any non-numeric
 * key (convention: "tmp_…") means "create new". Mirrors the per-endpoint
 * rules (UpsertWorkflowStepRequest, UpsertWorkflowRouteRequest, store/update
 * requirement requests, step sync payloads) so staged validation matches
 * what the dialogs enforce today.
 */
class ApplyStagedWorkflowRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'mode' => ['required', 'string', 'in:overwrite,create-new'],
            'name' => ['nullable', 'string', 'max:200', 'required_if:mode,create-new'],
            'notes' => ['nullable', 'string', 'max:5000'],
            'source_updated_at' => ['nullable', 'date'],

            'steps_upsert' => ['nullable', 'array'],
            'steps_upsert.*.key' => ['required'],
            'steps_upsert.*.code' => ['nullable', 'string', 'max:80', 'regex:/^[a-z0-9_]+$/'],
            'steps_upsert.*.parent_key' => ['nullable'],
            'steps_upsert.*.order_number' => ['required', 'integer', 'min:1'],
            'steps_upsert.*.name' => ['required', 'string', 'max:200'],
            'steps_upsert.*.stage' => ['nullable', 'string', 'max:120'],
            'steps_upsert.*.office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'steps_upsert.*.sla_minutes' => ['required', 'integer', 'min:0'],
            'steps_upsert.*.is_start' => ['sometimes', 'boolean'],
            'steps_upsert.*.is_end' => ['sometimes', 'boolean'],
            'steps_upsert.*.role_ids' => ['sometimes', 'array'],
            'steps_upsert.*.role_ids.*' => ['integer', 'exists:roles,id'],

            'steps_delete' => ['nullable', 'array'],
            'steps_delete.*.id' => ['nullable', 'integer'],
            'steps_delete.*.code' => ['nullable', 'string', 'max:80'],

            'routes_upsert' => ['nullable', 'array'],
            'routes_upsert.*.key' => ['required'],
            'routes_upsert.*.from_key' => ['required'],
            'routes_upsert.*.to_key' => ['required'],
            'routes_upsert.*.action_code' => ['required', 'string', 'max:50'],
            'routes_upsert.*.is_return_route' => ['sometimes', 'boolean', function ($attribute, $value, $fail) {
                if (filter_var($value, FILTER_VALIDATE_BOOLEAN)) {
                    $fail('Return routes are no longer allowed. Going back is done via jump to a visited station.');
                }
            }],
            'routes_upsert.*.condition_expression' => ['nullable', 'array'],
            'routes_upsert.*.route_group' => ['nullable', 'string', 'max:120'],
            'routes_upsert.*.required_approvals_count' => ['nullable', 'integer', 'min:1'],

            'routes_delete' => ['nullable', 'array'],
            'routes_delete.*.id' => ['required', 'integer'],

            'requirements_upsert' => ['nullable', 'array'],
            'requirements_upsert.*.key' => ['required'],
            'requirements_upsert.*.code' => ['nullable', 'string', 'max:64'],
            'requirements_upsert.*.name' => ['required', 'string', 'max:255'],
            'requirements_upsert.*.label' => ['nullable', 'string', 'max:120'],
            'requirements_upsert.*.description' => ['nullable', 'string'],
            'requirements_upsert.*.is_active' => ['nullable', 'boolean'],
            'requirements_upsert.*.order_number' => ['nullable', 'integer', 'min:0'],

            'requirements_delete' => ['nullable', 'array'],
            'requirements_delete.*.id' => ['nullable', 'integer'],
            'requirements_delete.*.code' => ['nullable', 'string', 'max:64'],

            'step_requirements' => ['nullable', 'array'],
            'step_requirements.*' => ['array'],
            'step_requirements.*.*.req_key' => ['required'],
            'step_requirements.*.*.display_order' => ['nullable', 'integer', 'min:0'],
            'step_requirements.*.*.is_required' => ['nullable', 'boolean'],
            'step_requirements.*.*.is_upload_required' => ['nullable', 'boolean'],
            'step_requirements.*.*.code' => ['nullable', 'string', 'max:64'],
            'step_requirements.*.*.description' => ['nullable', 'string'],

            'step_checklist' => ['nullable', 'array'],
            'step_checklist.*' => ['array'],
            'step_checklist.*.*.id' => ['nullable', 'integer'],
            'step_checklist.*.*.requirement_key' => ['nullable'],
            'step_checklist.*.*.name' => ['required', 'string', 'max:255'],
            'step_checklist.*.*.code' => ['nullable', 'string', 'max:64'],
            'step_checklist.*.*.description' => ['nullable', 'string'],
            'step_checklist.*.*.is_required' => ['nullable', 'boolean'],
            'step_checklist.*.*.display_order' => ['nullable', 'integer', 'min:0'],

            'resync_checklist_steps' => ['nullable', 'array'],
            'resync_checklist_steps.*' => ['required'],

            'step_fields' => ['nullable', 'array'],
            'step_fields.*' => ['array'],
            'step_fields.*.*.field_definition_id' => ['required', 'integer', 'exists:field_definitions,id'],
            'step_fields.*.*.display_order' => ['nullable', 'integer', 'min:0'],
            'step_fields.*.*.required_override' => ['nullable', 'boolean'],
        ];
    }
}
