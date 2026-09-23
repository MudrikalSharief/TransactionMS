<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\CreateTransactionRequest;
use App\Http\Requests\Transactions\ExecuteActionRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\AuditService;
use App\Services\RoutingEngine;
use App\Services\TransactionEngine;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $items = Transaction::query()
            ->with([
                'type',
                'office',
                'workflow',
                'state.currentStep',
                'creator',
            ])
            ->latest()
            ->get();

        return TransactionResource::collection($items);
    }

    public function store(CreateTransactionRequest $request, TransactionEngine $engine)
    {
        $tx = $engine->create(
            (int) $request->validated()['transaction_type_id'],
            $request->validated()['title'] ?? null,
            $request->user()->id,
            $request->validated()['office_id'] ?? null
        );

        return (new TransactionResource($tx))->response()->setStatusCode(201);
    }

    public function updateOffice(Request $request, Transaction $transaction, RoutingEngine $routing, AuditService $audit)
    {
        $data = $request->validate([
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
        ]);

        $before = ['office_id' => $transaction->office_id];
        $transaction->office_id = $data['office_id'] ?? null;
        $transaction->save();

        $audit->log($request, 'transactions.reassign_office', $transaction, [
            'before' => $before,
            'after' => ['office_id' => $transaction->office_id],
        ]);

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

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }

    public function show(Transaction $transaction, Request $request, RoutingEngine $routing)
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

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ],
        ]);
    }

    public function destroy(Transaction $transaction, Request $request, AuditService $audit)
    {
        $audit->log($request, 'transactions.delete', $transaction, [
            'reference_number' => $transaction->reference_number,
            'transaction_type_id' => $transaction->transaction_type_id,
        ]);

        $transaction->delete();

        return response()->json(['message' => 'Deleted']);
    }

    public function executeAction(
        Transaction $transaction,
        ExecuteActionRequest $request,
        RoutingEngine $routing,
        TransactionEngine $engine
    ) {
        $transaction->load([
            'type',
            'workflow.steps',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
            'state.currentStep.requirementDefinitions',
            'fieldValues.fieldDefinition',
            'requirementChecks.checker',
            'checklistChecks.checker',
            'runs.fromStep',
            'runs.toStep',
            'runs.performer',
            'attachments',
        ]);

        $route = $routing->assertRouteExecutable(
            $transaction,
            (int) $request->validated()['route_id'],
            $request->user()
        );

        $fields = $request->validated()['field_values']
            ?? $request->validated()['fields']
            ?? [];

        $tx = $engine->transitionByRoute(
            $transaction,
            $route,
            $request->validated()['remarks'] ?? null,
            $request->user()->id,
            is_array($fields) ? $fields : [],
            $request->validated()['attachment_ids'] ?? []
        );

        $actions = $routing->availableActions($tx, $request->user());

        return (new TransactionResource($tx))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($tx),
            ],
        ]);
    }
}
