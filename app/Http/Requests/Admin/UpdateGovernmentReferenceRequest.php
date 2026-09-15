<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class UpdateGovernmentReferenceRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'code' => ['required', 'string', 'max:80'],
            'title' => ['required', 'string', 'max:200'],
            'source' => ['nullable', 'string', 'max:80'],
            'url' => ['nullable', 'url', 'max:500'],
            'notes' => ['nullable', 'string', 'max:5000'],
            'is_verified' => ['sometimes', 'boolean'],
        ];
    }
}
