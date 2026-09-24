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
            // Jumps always go back to a passed station, so the reason
            // for going back is required.
            'remarks' => ['required', 'string', 'max:2000'],
        ];
    }
}
