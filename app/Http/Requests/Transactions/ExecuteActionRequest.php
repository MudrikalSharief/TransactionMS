<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class ExecuteActionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'route_id' => ['required', 'integer'],
            'remarks' => ['nullable', 'string', 'max:2000'],
            'field_values' => ['nullable', 'array'],
            'fields' => ['nullable', 'array'],
            'attachment_ids' => ['nullable', 'array'],
            'attachment_ids.*' => ['integer', 'exists:transaction_attachments,id'],
            'step_data' => ['nullable', 'array'],
            'step_data.*' => ['nullable', 'string', 'max:2000'],
            // Structured return flags: checklist items flagged by the sender.
            // Stored on the run (not in remarks text) so they cannot be
            // erased and can highlight the receiver's checklist.
            'flagged_items' => ['nullable', 'array', 'max:50'],
            'flagged_items.*.requirement_definition_id' => ['nullable', 'integer', 'exists:requirement_definitions,id'],
            'flagged_items.*.code' => ['nullable', 'string', 'max:120'],
            'flagged_items.*.name' => ['nullable', 'string', 'max:255'],
        ];
    }
}
