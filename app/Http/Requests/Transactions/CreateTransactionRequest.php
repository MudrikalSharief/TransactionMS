<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class CreateTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'transaction_type_id' => ['required', 'integer', 'exists:transaction_types,id'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'title' => ['nullable', 'string', 'max:200'],
        ];
    }
}
