<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

class UpsertWorkflowRouteRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'from_step_id' => ['required', 'integer', 'exists:workflow_steps,id'],
            'to_step_id' => ['required', 'integer', 'exists:workflow_steps,id'],
            'action_code' => ['required', 'string', 'max:50'],
            'is_return_route' => ['sometimes', 'boolean'],
            'condition_expression' => ['nullable', 'array'], // JSON logic-ish
            'route_group' => ['nullable', 'string', 'max:120'],
            'required_approvals_count' => ['nullable', 'integer', 'min:1'],
        ];
    }
}
