<?php

namespace App\Http\Requests\Admin\Requirements;

use Illuminate\Foundation\Http\FormRequest;

class StoreRequirementDefinitionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; 
    }

    public function rules(): array
    {
        return [
            'order_number' => ['nullable','integer','min:0'],
            'code' => ['required','string','max:64'],
            'name' => ['required','string','max:255'],
            'description' => ['nullable','string'],
            'is_active' => ['nullable','boolean'],
        ];
    }
}
