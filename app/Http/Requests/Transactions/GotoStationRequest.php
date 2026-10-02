<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class GotoStationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'to_step_id' => ['required', 'integer', 'exists:workflow_steps,id'],
            // Jumps go to an already-passed station (backward return or
            // forward resend), so the reason is always required.
            'remarks' => ['required', 'string', 'max:2000'],
        ];
    }
}
