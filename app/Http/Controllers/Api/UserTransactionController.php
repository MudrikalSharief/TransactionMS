<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\ExecuteActionRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use App\Services\TransactionEngine;
use Illuminate\Http\Request;

class UserTransactionController extends Controller
{
    public function index(Request $request, RoutingEngine $routing)
    {
        $user = $request->user();

        $items = Transaction::query()
            ->with([
                'type',
                'office',
                'workflow',
                'workflow.stepRoles.role',
                'state.currentStep',
                'creator',
            ])
            ->oldest()
            ->get();

        $filtered = $items->filter(function (Transaction $tx) use ($routing, $user) {
            return $routing->userCanWorkOnCurrentStep($tx, $user);
        })->values();

        return TransactionResource::collection($filtered);
    }

    public function show(Transaction $transaction, Request $request, RoutingEngine $routing)
    {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->load([
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
            'requirementChecks.checker',
        ]);

        $actions = $routing->availableActions($transaction, $request->user());

        return (new TransactionResource($transaction))->additional([
            'meta' => [
                'available_actions' => $actions,
            ],
        ]);
    }

    public function execute(
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
            'requirementChecks',
            'fieldValues.fieldDefinition',
            'runs.fromStep',
            'runs.toStep',
            'runs.performer',
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
            is_array($fields) ? $fields : []
        );

        $actions = $routing->availableActions($tx, $request->user());

        return (new TransactionResource($tx))->additional([
            'meta' => [
                'available_actions' => $actions,
            ],
        ]);
    }
}
 