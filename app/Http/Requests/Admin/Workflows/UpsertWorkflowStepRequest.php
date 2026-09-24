<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

class UpsertWorkflowStepRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'parent_id' => ['nullable', 'integer', 'exists:workflow_steps,id'],
            'order_number' => ['required', 'integer', 'min:1'],
            'code' => ['nullable', 'string', 'max:80', 'regex:/^[a-z0-9_]+$/'],
            'name' => ['required', 'string', 'max:200'],
            'stage' => ['nullable', 'string', 'max:120'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'sla_minutes' => ['required', 'integer', 'min:0'],
            'is_start' => ['sometimes', 'boolean'],
            'is_end' => ['sometimes', 'boolean'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', 'exists:roles,id'],
        ];
    }
}
