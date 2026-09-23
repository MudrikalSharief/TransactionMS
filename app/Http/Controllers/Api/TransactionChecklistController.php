<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChecklistOverride;
use App\Models\Transaction;
use App\Models\TransactionChecklistCheck;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

class TransactionChecklistController extends Controller
{
    public function check(
        Request $request,
        Transaction $transaction,
        ChecklistOverride $checklistOverride,
        RoutingEngine $routing
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing(['state.currentStep']);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        if ((int) $checklistOverride->workflow_step_id !== $currentStepId) {
            abort(422, 'Checklist item is not on the current step.');
        }

        TransactionChecklistCheck::firstOrCreate(
            [
                'transaction_id' => $transaction->id,
                'workflow_step_id' => $currentStepId,
                'checklist_override_id' => $checklistOverride->id,
            ],
            [
                'checked_by' => $request->user()->id,
                'checked_at' => now(),
            ]
        );

        return $this->refresh($transaction, $routing);
    }

    public function uncheck(
        Request $request,
        Transaction $transaction,
        ChecklistOverride $checklistOverride,
        RoutingEngine $routing
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing(['state.currentStep']);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        $check = TransactionChecklistCheck::query()
            ->where('transaction_id', $transaction->id)
            ->where('workflow_step_id', $currentStepId)
            ->where('checklist_override_id', $checklistOverride->id)
            ->first();

        if (!$check) {
            abort(422, 'Checklist item is not checked yet.');
        }

        $user = $request->user();
        $user->loadMissing('roles');

        $isSuperadmin = $user->roles?->contains(fn ($r) => $r->code === 'superadmin') ?? false;

        if (!$isSuperadmin && (int) $check->checked_by !== (int) $user->id) {
            abort(403, 'Only the user who checked this item can uncheck it.');
        }

        $check->delete();

        return $this->refresh($transaction, $routing);
    }

    private function refresh(Transaction $transaction, RoutingEngine $routing)
    {
        $transaction->load([
            'type',
            'office',
            'office.steps',
            'workflow.steps',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
            'state.currentStep.requirementDefinitions',
            'creator',
            'runs.fromStep',
            'runs.toStep',
            'runs.performer',
            'runs.attachments.requirement',
            'fieldValues.fieldDefinition',
            'requirementChecks.checker',
            'checklistChecks.checker',
            'attachments.step',
            'attachments.requirement',
            'attachments.uploader',
        ]);

        $actions = $routing->availableActions($transaction, request()->user());

        return (new \App\Http\Resources\TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }
}
