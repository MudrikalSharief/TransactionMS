<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class TransitionTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'to_step_id' => ['required', 'integer', 'exists:workflow_steps,id'],
            'action_code' => ['required', 'string', 'max:50'],
            'remarks' => ['nullable', 'string', 'max:5000'],
        ];
    }
}
