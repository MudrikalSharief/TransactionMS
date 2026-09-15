<?php

namespace App\Http\Requests\Admin\Fields;

use Illuminate\Foundation\Http\FormRequest;

class StoreFieldDefinitionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; 
    }

    public function rules(): array
    {
        return [
            'order_number' => ['nullable', 'integer', 'min:0'],
            'code' => ['required', 'string', 'regex:/^[a-z0-9_]+$/'],
            'name' => ['required', 'string', 'max:255'],
            'type' => ['required', 'string', 'in:text,textarea,number,date,select,multiselect,boolean'],
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

            'assign_step_ids' => ['nullable', 'array'],
            'assign_step_ids.*' => ['integer'],
        ];
    }
}
