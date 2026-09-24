<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\RequirementDefinition;
use App\Models\Transaction;
use App\Models\TransactionRequirementCheck;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

class TransactionRequirementController extends Controller
{
    public function check(
        Request $request,
        Transaction $transaction,
        RequirementDefinition $requirementDefinition,
        RoutingEngine $routing
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing([
            'state.currentStep',
            'workflow',
        ]);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        if ((int) $requirementDefinition->workflow_definition_id !== (int) $transaction->workflow_definition_id) {
            abort(422, 'Requirement does not belong to this transaction workflow version.');
        }

        $stepId = $currentStepId;
        $isAssigned = $transaction->state->currentStep
            ->requirementDefinitions()
            ->where('requirement_definitions.id', $requirementDefinition->id)
            ->exists();

        if (!$isAssigned) {
            abort(422, 'Requirement is not assigned to the current step.');
        }

        TransactionRequirementCheck::firstOrCreate(
            [
                'transaction_id' => $transaction->id,
                'workflow_step_id' => $stepId,
                'requirement_definition_id' => $requirementDefinition->id,
            ],
            [
                'checked_by' => $request->user()->id,
                'checked_at' => now(),
            ]
        );

        $transaction->load([
            'type',
            'workflow.steps',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
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

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }
    public function uncheck(
        Request $request,
        Transaction $transaction,
        RequirementDefinition $requirementDefinition,
        RoutingEngine $routing
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing([
            'state.currentStep',
        ]);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        if ((int) $requirementDefinition->workflow_definition_id !== (int) $transaction->workflow_definition_id) {
            abort(422, 'Requirement does not belong to this transaction workflow version.');
        }

        $stepId = $currentStepId;
        $isAssigned = $transaction->state->currentStep
            ->requirementDefinitions()
            ->where('requirement_definitions.id', $requirementDefinition->id)
            ->exists();

        if (!$isAssigned) {
            abort(422, 'Requirement is not assigned to the current step.');
        }

        $check = TransactionRequirementCheck::query()
            ->where('transaction_id', $transaction->id)
            ->where('workflow_step_id', $stepId)
            ->where('requirement_definition_id', $requirementDefinition->id)
            ->first();

        if (!$check) {
            abort(422, 'Requirement is not checked yet.');
        }

        $user = $request->user();
        $user->loadMissing('roles');

        $isSuperadmin = $user->roles?->contains(fn($r) => $r->code === 'superadmin') ?? false;

        if (!$isSuperadmin && (int) $check->checked_by !== (int) $user->id) {
            abort(403, 'Only the user who checked this item can uncheck it.');
        }

        $check->delete();

        $transaction->load([
            'type',
            'workflow.steps',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
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

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }
}
