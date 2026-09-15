<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateOfficeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $officeId = $this->route('office')?->id;

        return [
            'code' => ['required', 'string', 'max:50', 'regex:/^[a-z0-9_]+$/', Rule::unique('offices', 'code')->withoutTrashed()->ignore($officeId)],
            'name' => ['required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:2000'],
            'is_active' => ['sometimes', 'boolean'],
        ];
    }
}
