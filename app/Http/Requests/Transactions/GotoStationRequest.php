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
<<<<<<< HEAD
            // Why it went back; drives the history label. Omitted = plain revisit.
            'reason' => ['nullable', 'string', 'in:missing_requirements'],
=======
            // Structured return flags (jump-back returns): stored on the
            // run so the receiver's checklist can highlight them.
            'flagged_items' => ['nullable', 'array', 'max:50'],
            'flagged_items.*.requirement_definition_id' => ['nullable', 'integer', 'exists:requirement_definitions,id'],
            'flagged_items.*.code' => ['nullable', 'string', 'max:120'],
            'flagged_items.*.name' => ['nullable', 'string', 'max:255'],
>>>>>>> Adustment-Temporary
        ];
    }
}
