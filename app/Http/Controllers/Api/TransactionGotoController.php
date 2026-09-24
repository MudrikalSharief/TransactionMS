<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\GotoStationRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use App\Services\TransactionEngine;

class TransactionGotoController extends Controller
{
    /**
     * Jump to an already-visited station. No checklist gating — jumps are
     * free navigation across passed stations. The destination keeps its
     * saved work when complete (intact-arrival rule in the engine).
     */
    public function goto(
        Transaction $transaction,
        GotoStationRequest $request,
        RoutingEngine $routing,
        TransactionEngine $engine
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing(['state', 'workflow.steps']);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        $toStepId = (int) $request->validated()['to_step_id'];
        if ($toStepId === $currentStepId) abort(422, 'Already at this station.');

        $target = $transaction->workflow->steps->firstWhere('id', $toStepId);
        if (!$target || (int) $target->workflow_definition_id !== (int) $transaction->workflow_definition_id) {
            abort(422, 'Target station does not belong to this transaction workflow version.');
        }

        if (!in_array($toStepId, $routing->visitedStepIds($transaction), true)) {
            abort(422, 'You can only jump to stations the paper has already passed.');
        }

        // Backward jumps only: the target must sit behind the current
        // station in workflow order. Forward moves always go step by
        // step through the assigned routes.
        $current = $transaction->workflow->steps->firstWhere('id', $currentStepId);
        if (!$current || (int) $target->order_number >= (int) $current->order_number) {
            abort(422, 'You can only go back to a passed station; move forward step by step.');
        }

        $tx = $engine->jumpToStep(
            $transaction,
            $toStepId,
            $request->validated()['remarks'] ?? null,
            (int) $request->user()->id
        );

        $tx->load([
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

        $actions = $routing->availableActions($tx, $request->user());

        return (new TransactionResource($tx))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($tx),
            ],
        ]);
    }
}
