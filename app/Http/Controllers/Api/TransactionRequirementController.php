<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\RequirementDefinition;
use App\Models\Transaction;
use App\Models\TransactionRequirementCheck;
use App\Services\AuditService;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionRequirementController extends Controller
{
    public function check(
        Request $request,
        Transaction $transaction,
        RequirementDefinition $requirementDefinition,
        RoutingEngine $routing,
        AuditService $audit
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

        DB::transaction(function () use ($request, $transaction, $requirementDefinition, $stepId, $audit) {
            $check = TransactionRequirementCheck::firstOrCreate(
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

            if ($check->wasRecentlyCreated) {
                $audit->log($request, 'transactions.requirement_check', $check, [
                    'new' => [
                        'requirement_definition_id' => $requirementDefinition->id,
                        'requirement' => $requirementDefinition->name ?: $requirementDefinition->code,
                        'workflow_step_id' => $stepId,
                    ],
                    'entity_label' => $requirementDefinition->name ?: $requirementDefinition->code,
                    'transaction_id' => $transaction->id,
                    'office_id' => $transaction->office_id,
                ]);
            }
        });

        $transaction->load([
            'type',
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
        RoutingEngine $routing,
        AuditService $audit
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

        DB::transaction(function () use ($request, $transaction, $check, $requirementDefinition, $stepId, $audit) {
            $old = [
                'requirement_definition_id' => $requirementDefinition->id,
                'requirement' => $requirementDefinition->name ?: $requirementDefinition->code,
                'workflow_step_id' => $stepId,
                'checked_by' => $check->checked_by,
                'checked_at' => $check->checked_at?->toIso8601String(),
            ];
            $check->delete();

            $audit->log($request, 'transactions.requirement_uncheck', $check, [
                'old' => $old,
                'entity_label' => $requirementDefinition->name ?: $requirementDefinition->code,
                'transaction_id' => $transaction->id,
                'office_id' => $transaction->office_id,
            ]);
        });

        $transaction->load([
            'type',
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

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }
}
