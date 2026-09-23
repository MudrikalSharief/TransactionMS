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
        array $fieldValuesByCode = [],
        array $attachmentIds = []
    ): Transaction {
        return DB::transaction(function () use ($tx, $route, $remarks, $userId, $fieldValuesByCode, $attachmentIds) {
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

            $run = TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $currentStepId,
                'to_step_id' => $toStepId,
                'action_code' => $route->action_code,
                'remarks' => $remarks,
                'performed_by' => $userId,
                'performed_at' => now(),
            ]);

            // Link proceed-modal uploads (keep-forever evidence) to this run.
            // Forward: only pending files of this tx + from-step qualify.
            // Return: previous-station files may come from other steps, so
            // scope to the transaction (not the step). Already-linked files
            // are left on their original run; only pending files move.
            // Return fallback: if the client sends no ids (e.g. stale UI
            // without return autofill), auto-attach all pending files of
            // the transaction so returning never orphans evidence.
            $isReturn = (bool) ($route->is_return_route ?? false);
            if (!empty($attachmentIds)) {
                $linkQuery = \App\Models\TransactionAttachment::query()
                    ->where('transaction_id', $tx->id)
                    ->whereIn('id', array_map('intval', $attachmentIds))
                    ->whereNull('step_run_id');
                if (!$isReturn) {
                    $linkQuery->where('workflow_step_id', $currentStepId);
                }
                $linkQuery->update(['step_run_id' => $run->id]);
            } elseif ($isReturn) {
                \App\Models\TransactionAttachment::query()
                    ->where('transaction_id', $tx->id)
                    ->whereNull('step_run_id')
                    ->update(['step_run_id' => $run->id]);
            }

            $tx->state->update([
                'current_step_id' => $toStepId,
                'entered_at' => now(),
            ]);

            // Every station arrival starts unchecked: clear the destination
            // station's checklist checks so its items must be verified fresh.
            // First visits are a no-op (nothing to clear); revisits (return
            // loops or forward loops) force re-verification.
            // Exception: a destination whose required checklist + required
            // fields are fully complete keeps its saved work. Stations with
            // gaps always reset.
            // On return, also clear the leaving station's checks so no stale
            // history lingers. The run above records who moved it and why.
            if (!$this->destinationArrivalIntact($tx, $toStepId)) {
                \App\Models\TransactionRequirementCheck::query()
                    ->where('transaction_id', $tx->id)
                    ->where('workflow_step_id', $toStepId)
                    ->delete();
            }
            if ($isReturn) {
                \App\Models\TransactionRequirementCheck::query()
                    ->where('transaction_id', $tx->id)
                    ->where('workflow_step_id', $currentStepId)
                    ->delete();
            }

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
                'runs.attachments',
                'fieldValues.fieldDefinition',
                'requirementChecks.checker',
                'attachments.step',
                'attachments.requirement',
                'attachments.uploader',
            ]);
        });
    }

    /**
     * Jump to an already-visited station (free navigation). No checklist
     * gating — callers validate the destination. Complete destinations
     * keep their saved work via the intact-arrival rule; gappy ones reset.
     */
    public function jumpToStep(Transaction $tx, int $toStepId, ?string $remarks, int $userId): Transaction
    {
        return DB::transaction(function () use ($tx, $toStepId, $remarks, $userId) {
            $tx->loadMissing(['state.currentStep', 'workflow', 'workflow.steps']);

            $currentStepId = (int) $tx->state?->current_step_id;
            if (!$currentStepId) {
                abort(422, 'Transaction has no current step.');
            }
            if ($currentStepId === $toStepId) {
                abort(422, 'Already at this station.');
            }

            $run = TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $currentStepId,
                'to_step_id' => $toStepId,
                'action_code' => 'revisit',
                'remarks' => $remarks ?? 'Jumped to a passed station',
                'performed_by' => $userId,
                'performed_at' => now(),
            ]);

            // Pending (unlinked) files travel with the jump so evidence
            // is never orphaned.
            \App\Models\TransactionAttachment::query()
                ->where('transaction_id', $tx->id)
                ->whereNull('step_run_id')
                ->update(['step_run_id' => $run->id]);

            $tx->state->update([
                'current_step_id' => $toStepId,
                'entered_at' => now(),
            ]);

            if (!$this->destinationArrivalIntact($tx, $toStepId)) {
                \App\Models\TransactionRequirementCheck::query()
                    ->where('transaction_id', $tx->id)
                    ->where('workflow_step_id', $toStepId)
                    ->delete();
            }

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
                'runs.attachments',
                'fieldValues.fieldDefinition',
                'requirementChecks.checker',
                'attachments.step',
                'attachments.requirement',
                'attachments.uploader',
            ]);
        });
    }

    /**
     * True when the destination station's saved work is complete — safe to
     * keep on arrival instead of reset. Missing required checks or empty
     * required fields mean the arrival must reset as before.
     */
    private function destinationArrivalIntact(Transaction $tx, int $stepId): bool
    {
        $tx->loadMissing([
            'workflow.steps.requirementDefinitions',
            'workflow.steps.fieldDefinitions',
            'fieldValues.fieldDefinition',
        ]);

        $step = $tx->workflow->steps->firstWhere('id', $stepId);
        if (!$step) return false;

        $requiredReqs = collect($step->requirementDefinitions ?? [])
            ->filter(fn ($r) => (bool) ($r->pivot?->is_required ?? true))
            ->values();
        if ($requiredReqs->isNotEmpty()) {
            $checkedIds = \App\Models\TransactionRequirementCheck::query()
                ->where('transaction_id', $tx->id)
                ->where('workflow_step_id', $stepId)
                ->pluck('requirement_definition_id')
                ->map(fn ($v) => (int) $v)
                ->unique()
                ->values();
            $allChecked = $requiredReqs->every(fn ($r) => $checkedIds->contains((int) $r->id));
            if (!$allChecked) return false;
        }

        $valuesByDefId = collect($tx->fieldValues ?? [])->keyBy('field_definition_id');
        $requiredFields = collect($step->fieldDefinitions ?? [])
            ->filter(fn ($f) => (bool) ($f->pivot?->required_override ?? $f->required))
            ->values();
        foreach ($requiredFields as $f) {
            $fv = $valuesByDefId->get($f->id);
            $v = null;
            if ($fv) {
                if (is_array($fv->value_json) && array_key_exists('value', $fv->value_json)) $v = $fv->value_json['value'];
                elseif ($fv->value_number !== null) $v = $fv->value_number;
                elseif ($fv->value_text !== null) $v = $fv->value_text;
                else $v = $fv->value_json;
            }
            if ($v === null || $v === '' || (is_array($v) && count($v) === 0)) return false;
        }

        return true;
    }

    private function makeReference(): string
    {
        return strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4));
    }
}
