<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

class UpsertWorkflowRouteRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'from_step_id' => ['required', 'integer', 'exists:workflow_steps,id', 'different:to_step_id'],
            'to_step_id' => ['required', 'integer', 'exists:workflow_steps,id', 'different:from_step_id'],
            'action_code' => ['required', 'string', 'max:50'],
            // Return routes are retired: going back is done via jump to a
            // visited station (recorded as Returned). Old workflow versions
            // keep their existing return rows untouched.
            'is_return_route' => [
                'sometimes',
                'boolean',
                function ($attribute, $value, $fail) {
                    if (filter_var($value, FILTER_VALIDATE_BOOLEAN)) {
                        $fail('Return routes are no longer allowed. Going back is done via jump to a visited station.');
                    }
                },
            ],
            'condition_expression' => ['nullable', 'array'], // JSON logic-ish
            'route_group' => ['nullable', 'string', 'max:120'],
            'required_approvals_count' => ['nullable', 'integer', 'min:1'],
        ];
    }

    /**
     * Cross-field route guards (routes are forward-only):
     * - both steps must belong to the definition being edited
     * - strictly-backward links (to.order < from.order) are rejected
     * - duplicate from → to links are rejected regardless of action_code
     * Applies to store and update; grandfathered rows stay executable
     * as-is but cannot be edited without conforming.
     */
    public function withValidator($validator): void
    {
        $validator->after(function ($validator) {
            $fromId = (int) $this->input('from_step_id');
            $toId = (int) $this->input('to_step_id');
            if (!$fromId || !$toId || $fromId === $toId) {
                return;
            }

            $definition = $this->route('workflowDefinition');
            $definitionId = $definition instanceof \App\Models\WorkflowDefinition
                ? (int) $definition->id
                : (int) $definition;

            $steps = \App\Models\WorkflowStep::query()
                ->where('workflow_definition_id', $definitionId)
                ->whereIn('id', [$fromId, $toId])
                ->get()
                ->keyBy('id');

            $from = $steps->get($fromId);
            $to = $steps->get($toId);
            if (!$from || !$to) {
                $validator->errors()->add(
                    'to_step_id',
                    'Both steps must belong to this workflow definition.'
                );
                return;
            }

            if ((int) $to->order_number < (int) $from->order_number) {
                $validator->errors()->add(
                    'to_step_id',
                    "Routes must move forward: Step {$from->order_number} → Step {$to->order_number} is not allowed."
                );
                return;
            }

            $self = $this->route('workflowRoute');
            $selfId = $self instanceof \App\Models\WorkflowRoute ? (int) $self->id : (int) $self;

            $duplicate = \App\Models\WorkflowRoute::query()
                ->where('workflow_definition_id', $definitionId)
                ->where('from_step_id', $fromId)
                ->where('to_step_id', $toId)
                ->when($selfId > 0, fn ($q) => $q->where('id', '!=', $selfId))
                ->exists();

            if ($duplicate) {
                $validator->errors()->add(
                    'to_step_id',
                    'This route already exists (same From → To), regardless of action.'
                );
            }
        });
    }
}
