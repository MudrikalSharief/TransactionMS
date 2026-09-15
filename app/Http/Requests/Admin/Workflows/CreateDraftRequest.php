<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

class CreateDraftRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'transaction_type_id' => ['required', 'integer', 'exists:transaction_types,id'],
            'name' => ['nullable', 'string', 'max:200'],
            'notes' => ['nullable', 'string', 'max:5000'],
            // if true, clone from latest published version; else create empty v1 draft
            'clone_latest_published' => ['sometimes', 'boolean'],
        ];
    }
}
