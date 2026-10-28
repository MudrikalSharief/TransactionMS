<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\FieldValue;
use App\Models\Transaction;
use App\Models\TransactionStepData;
use App\Models\TransactionStepRun;
use App\Services\AuditService;
use App\Services\ChecklistService;
use App\Services\FieldValidationService;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class TransactionFinalizeController extends Controller
{
    /**
     * Mark the transaction done. Only on the end step, only once.
     * Checklist gating is dynamic: an item is required on Complete only
     * when its predecessor requirement was ticked (prev_checked).
     * After this the transaction is view-only —
     * RoutingEngine::assertUserCanExecute rejects all further writes.
     */
    public function finalize(
        Transaction $transaction,
        Request $request,
        RoutingEngine $routing,
        AuditService $audit,
        ChecklistService $checklists,
        FieldValidationService $fieldValidation
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        if ((bool) $transaction->is_done) {
            abort(422, 'Transaction is already finalized.');
        }

        if ($routing->hasPendingReceipt($transaction)) {
            abort(422, 'Please receive the step first before finalizing.');
        }

        $transaction->loadMissing(['state.currentStep']);
        $current = $transaction->state?->currentStep;
        if (!$current) abort(422, 'Transaction has no current step.');
        if (!(bool) $current->is_end) {
            abort(422, 'Only the last station can finalize the transaction.');
        }

        // Dynamic Complete gating: required = predecessor ticked (prev_checked).
        // Items the previous station left unticked stay optional here.
        // Plus same required uploads + ticks as Proceed so Complete cannot
        // bypass required files.
        $transaction->loadMissing(['requirementChecks', 'checklistChecks', 'attachments']);
        $stepId = (int) $current->id;
        $reqs = $current->requirementDefinitions()->get();
        $attCounts = collect($transaction->attachments ?? [])
            ->where('workflow_step_id', $stepId)
            ->groupBy(fn ($a) => (int) ($a->requirement_definition_id ?? 0))
            ->map(fn ($g) => $g->count());
        $missingUploads = $reqs
            ->filter(fn ($r) => (bool) ($r->pivot?->is_upload_required ?? $r->pivot?->is_required ?? true))
            ->filter(fn ($r) => ($attCounts->get((int) $r->id, 0) ?? 0) < 1)
            ->pluck('name')
            ->values();
        if ($missingUploads->isNotEmpty()) {
            abort(422, 'Upload-required items missing files: ' . $missingUploads->implode(', '));
        }
        $checkedReqIds = collect($transaction->requirementChecks ?? [])
            ->where('workflow_step_id', $stepId)
            ->map(fn ($c) => (int) $c->requirement_definition_id)
            ->unique()
            ->values()
            ->all();
        $missingTicks = $reqs
            ->filter(fn ($r) => (bool) ($r->pivot?->is_required ?? true))
            ->filter(fn ($r) => !in_array((int) $r->id, $checkedReqIds, true))
            ->pluck('name')
            ->values();
        if ($missingTicks->isNotEmpty()) {
            abort(422, 'Required hard-copy items not ticked: ' . $missingTicks->implode(', '));
        }
        $items = $checklists->itemsFor($current);
        $checksByStepReq = collect($transaction->requirementChecks ?? [])
            ->keyBy(fn ($c) => ((int) $c->workflow_step_id) . ':' . ((int) $c->requirement_definition_id));
        $sourceStepByReq = [];
        foreach ($checklists->predecessorsFor($current) as $pred) {
            foreach ($pred->requirementDefinitions()->pluck('requirement_definitions.id') as $reqId) {
                $sourceStepByReq[(int) $reqId] ??= $pred;
            }
        }
        $checkedIds = collect($transaction->checklistChecks ?? [])
            ->where('workflow_step_id', (int) $current->id)
            ->map(fn ($c) => (int) $c->checklist_override_id)
            ->unique()
            ->values()
            ->all();
        $missing = [];
        foreach ($items as $item) {
            $sourceStep = $sourceStepByReq[(int) ($item->requirement_definition_id ?? 0)] ?? null;
            $prevReqCheck = ($sourceStep && $item->requirement_definition_id)
                ? $checksByStepReq->get(((int) $sourceStep->id) . ':' . ((int) $item->requirement_definition_id))
                : null;
            if ($prevReqCheck && !in_array((int) $item->id, $checkedIds, true)) {
                $missing[] = $item->name;
            }
        }
        if (!empty($missing)) {
            abort(422, 'Required checklist items not completed: ' . collect($missing)->implode(', '));
        }

        $tx = DB::transaction(function () use ($transaction, $request, $current, $fieldValidation) {
            // Save staged station info with Complete (same as Proceed does),
            // so required fields cannot be bypassed on the last station.
            $fieldValuesByCode = $request->input('field_values', []);
            if (is_array($fieldValuesByCode) && count($fieldValuesByCode)) {
                $stepFields = $current->fieldDefinitions()
                    ->orderBy('field_definition_workflow_step.display_order')
                    ->orderBy('field_definitions.order_number')
                    ->get();
                $normalized = $fieldValidation->validateForStep($stepFields->all(), $fieldValuesByCode);
                foreach ($normalized as $fieldDefId => $payload) {
                    $value = $payload['value'];
                    FieldValue::updateOrCreate(
                        [
                            'transaction_id' => $transaction->id,
                            'field_definition_id' => $fieldDefId,
                        ],
                        [
                            'value_json' => ['value' => $value],
                            'value_text' => $fieldValidation->toValueText($value),
                            'updated_by' => $request->user()->id,
                        ]
                    );
                }
            } else {
                // No payload but required fields exist: fail like Proceed does.
                $hasRequired = $current->fieldDefinitions()
                    ->get()
                    ->contains(fn ($d) => (bool) ($d->pivot?->required_override ?? $d->required));
                if ($hasRequired) {
                    $stepFields = $current->fieldDefinitions()->get();
                    $fieldValidation->validateForStep($stepFields->all(), []);
                }
            }

            // Validate required step-data (receipt number, etc.) before completing.
            $stepDataDefs = $current->stepDataDefinitions()->orderBy('display_order')->get();
            $stepDataByCode = $request->input('step_data', []);
            if (!is_array($stepDataByCode)) $stepDataByCode = [];
            $errors = [];
            foreach ($stepDataDefs as $def) {
                $raw = $stepDataByCode[$def->code] ?? null;
                $val = is_string($raw) ? trim($raw) : $raw;
                if ($val === '') $val = null;
                if ((bool) $def->is_required && ($val === null || $val === '')) {
                    $errors[$def->code] = $def->display_name . ' is required.';
                }
            }
            if (count($errors)) {
                throw ValidationException::withMessages($errors);
            }

            $transaction->update(['is_done' => true]);

            $run = TransactionStepRun::create([
                'transaction_id' => $transaction->id,
                'from_step_id' => $current->id,
                'to_step_id' => $current->id,
                'action_code' => 'finalize',
                'remarks' => 'Transaction finalized',
                'performed_by' => $request->user()->id,
                'performed_at' => now(),
                // Finalizing closes the loop — auto-received so the row
                // never dangles as Pending in History.
                'received_at' => now(),
                'received_by' => $request->user()->id,
                'received_office_id' => $transaction->effectiveStepOfficeId($current),
                'sla_minutes_snapshot' => (int) ($current->sla_minutes ?? 0),
            ]);

            foreach ($stepDataDefs as $def) {
                $code = $def->code;
                if (!array_key_exists($code, $stepDataByCode)) continue;
                $val = $stepDataByCode[$code];
                $val = is_string($val) ? trim($val) : (is_null($val) ? null : (string) $val);
                if ($val === '') $val = null;
                TransactionStepData::create([
                    'transaction_id' => $transaction->id,
                    'workflow_step_data_id' => $def->id,
                    'transaction_step_run_id' => $run->id,
                    'workflow_step_id' => (int) $current->id,
                    'data_value' => $val,
                    'entered_by' => $request->user()->id,
                    'entered_at' => now(),
                ]);
            }

            return $transaction->fresh();
        });

        $audit->log($request, 'transactions.finalize', $tx, [
            'reference_number' => $tx->reference_number,
            'current_step_id' => $current->id,
        ]);

        $tx->load([
            'type',
            'office',
            'office.steps',
            'workflow.steps',
            'workflow.steps.office',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
            'state.currentStep.office',
            'creator',
            'runs.fromStep',
            'runs.fromStep.office',
            'runs.fromStep.roles',
            'runs.toStep',
            'runs.toStep.office',
            'runs.toStep.roles',
            'runs.performer',
            'runs.receiver',
            'runs.receivedOffice',
            'runs.attachments.requirement',
            'fieldValues.fieldDefinition',
            'requirementChecks.checker',
            'checklistChecks.checker',
            'attachments.step',
            'attachments.requirement',
            'attachments.uploader',
        ]);

        $actions = $routing->availableActions($tx, $request->user());

        return (new TransactionResource($tx))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($tx),
            ],
        ]);
    }
}
