<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Models\TransactionStepRun;
use App\Services\AuditService;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionFinalizeController extends Controller
{
    /**
     * Mark the transaction done. Only on the end step, only once, no
     * checklist gating. After this the transaction is view-only —
     * RoutingEngine::assertUserCanExecute rejects all further writes.
     */
    public function finalize(
        Transaction $transaction,
        Request $request,
        RoutingEngine $routing,
        AuditService $audit
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

        $tx = DB::transaction(function () use ($transaction, $request, $current) {
            $transaction->update(['is_done' => true]);

            TransactionStepRun::create([
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
                'received_office_id' => $current->office_id,
                'sla_minutes_snapshot' => (int) ($current->sla_minutes ?? 0),
            ]);

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
