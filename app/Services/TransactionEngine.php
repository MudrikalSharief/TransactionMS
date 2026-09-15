<?php

namespace App\Services;

use App\Models\FieldValue;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionStepRun;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class TransactionEngine
{
    public function __construct(
        private readonly FieldValidationService $fieldValidation
    ) {}

    public function create(int $transactionTypeId, ?string $title, int $userId, ?int $officeId = null): Transaction
    {
        return DB::transaction(function () use ($transactionTypeId, $title, $userId, $officeId) {
            $workflow = WorkflowDefinition::where('transaction_type_id', $transactionTypeId)
                ->where('status', 'published')
                ->orderByDesc('version')
                ->with('steps')
                ->first();

            if (!$workflow) {
                throw ValidationException::withMessages([
                    'transaction_type_id' => 'No published workflow exists for this transaction type yet.',
                ]);
            }

            $startStep = $workflow->steps()
                ->where('is_start', true)
                ->orderBy('order_number')
                ->first();

            if (!$startStep) {
                throw ValidationException::withMessages([
                    'workflow' => 'Published workflow has no start step.',
                ]);
            }

            $tx = Transaction::create([
                'transaction_type_id' => $transactionTypeId,
                'workflow_definition_id' => $workflow->id,
                'office_id' => $officeId,
                'reference_number' => $this->makeReference(),
                'title' => $title,
                'created_by' => $userId,
            ]);

            TransactionState::create([
                'transaction_id' => $tx->id,
                'current_step_id' => $startStep->id,
                'entered_at' => now(),
            ]);

            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $startStep->id,
                'to_step_id' => $startStep->id,
                'action_code' => 'create',
                'remarks' => 'Transaction created',
                'performed_by' => $userId,
                'performed_at' => now(),
            ]);

            return $tx->load([
                'type',
                'office',
                'office.steps',
                'workflow.steps',
                'workflow.routes',
                'state.currentStep',
                'creator',
                'runs.fromStep',
                'runs.toStep',
                'runs.performer',
                'fieldValues.fieldDefinition',
            ]);
        });
    }

    public function transitionByRoute(
        Transaction $tx,
        WorkflowRoute $route,
        ?string $remarks,
        int $userId,
        array $fieldValuesByCode = []
    ): Transaction {
        return DB::transaction(function () use ($tx, $route, $remarks, $userId, $fieldValuesByCode) {
            $tx->loadMissing([
                'state.currentStep',
                'workflow',
                'workflow.steps',
                'workflow.routes',
                'fieldValues.fieldDefinition',
            ]);

            $currentStep = $tx->state?->currentStep;
            if (!$currentStep) {
                abort(422, 'Transaction has no current step.');
            }

            if (is_array($fieldValuesByCode) && count($fieldValuesByCode)) {
                $stepFields = $currentStep->fieldDefinitions()
                    ->orderBy('field_definition_workflow_step.display_order')
                    ->orderBy('field_definitions.order_number')
                    ->get();

                $normalized = $this->fieldValidation->validateForStep($stepFields->all(), $fieldValuesByCode);

                foreach ($normalized as $fieldDefId => $payload) {
                    $value = $payload['value'];

                    FieldValue::updateOrCreate(
                        [
                            'transaction_id' => $tx->id,
                            'field_definition_id' => $fieldDefId,
                        ],
                        [
                            'value_json' => ['value' => $value],
                            'value_text' => $this->fieldValidation->toValueText($value),
                            'updated_by' => $userId,
                        ]
                    );
                }
            }

            $currentStepId = (int) $tx->state->current_step_id;
            $toStepId = (int) $route->to_step_id;

            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $currentStepId,
                'to_step_id' => $toStepId,
                'action_code' => $route->action_code,
                'remarks' => $remarks,
                'performed_by' => $userId,
                'performed_at' => now(),
            ]);

            $tx->state->update([
                'current_step_id' => $toStepId,
                'entered_at' => now(),
            ]);

            return $tx->fresh()->load([
                'type',
                'office',
                'office.steps',
                'workflow.steps',
                'workflow.routes',
                'workflow.stepRoles.role',
                'state.currentStep',
                'creator',
                'runs.fromStep',
                'runs.toStep',
                'runs.performer',
                'fieldValues.fieldDefinition',
            ]);
        });
    }

    private function makeReference(): string
    {
        return strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4));
    }
}
