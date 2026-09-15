<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class UploadAttachmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'file' => ['required', 'file', 'max:20480'],
            'requirement_definition_id' => ['nullable', 'integer', 'exists:requirement_definitions,id'],
        ];
    }

    public function messages(): array
    {
        return [
            'file.max' => 'File must not exceed 20MB.',
        ];
    }
}
