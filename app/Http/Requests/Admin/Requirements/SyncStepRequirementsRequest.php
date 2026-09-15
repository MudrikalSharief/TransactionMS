<?php

namespace App\Http\Requests\Admin\Requirements;

use Illuminate\Foundation\Http\FormRequest;

class SyncStepRequirementsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'requirements' => ['required', 'array'],
            'requirements.*.requirement_definition_id' => ['required', 'integer', 'min:1'],
            'requirements.*.display_order' => ['nullable', 'integer', 'min:0'],
            'requirements.*.is_required' => ['nullable', 'boolean'],
        ];
    }
}
