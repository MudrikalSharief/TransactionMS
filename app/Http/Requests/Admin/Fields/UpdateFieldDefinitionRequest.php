<?php

namespace App\Http\Requests\Admin\Fields;

use Illuminate\Foundation\Http\FormRequest;

class UpdateFieldDefinitionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'order_number' => ['nullable', 'integer', 'min:0'],
            'code' => ['sometimes', 'string', 'regex:/^[a-z0-9_]+$/'],
            'name' => ['sometimes', 'string', 'max:255'],
            'type' => ['sometimes', 'string', 'in:text,textarea,number,date,select,multiselect,boolean'],
            'group' => ['nullable', 'string', 'max:255'],
            'display_order' => ['nullable', 'integer', 'min:0'],

            'required' => ['boolean'],
            'unique' => ['boolean'],
            'sensitive' => ['boolean'],

            'min_length' => ['nullable', 'integer', 'min:0'],
            'max_length' => ['nullable', 'integer', 'min:0'],
            'min_value' => ['nullable', 'numeric'],
            'max_value' => ['nullable', 'numeric'],

            'options' => ['nullable', 'array'],
            'validation_rules' => ['nullable', 'array'],
        ];
    }
}
