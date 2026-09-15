<?php

namespace App\Http\Requests\Admin\Fields;

use Illuminate\Foundation\Http\FormRequest;

class SyncStepFieldsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'fields' => ['required', 'array'],
            'fields.*.field_definition_id' => ['required', 'integer', 'exists:field_definitions,id'],
            'fields.*.display_order' => ['nullable', 'integer', 'min:0'],
            'fields.*.required_override' => ['nullable', 'boolean'],
        ];
    }
}
