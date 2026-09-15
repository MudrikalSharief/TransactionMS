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
        ];
    }
}
