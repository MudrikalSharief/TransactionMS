<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\ExecuteActionRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use App\Services\TransactionEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class UserTransactionController extends Controller
{
    /**
     * Lightweight change signal for 20s smart-polling.
     * Returns aggregate stamps only (no rows, no eager loads) so open
     * tabs can check cheaply and only full-fetch when something changed.
     * Covers moves (transactions/states/runs) as well as ticks/uploads
     * (checks/attachments) which don't touch the transaction row itself.
     */
    public function version()
    {
        $maxOf = function (string $table, array $columns) {
            try {
                if (!Schema::hasTable($table)) return null;
                $max = null;
                foreach ($columns as $col) {
                    try {
                        $v = DB::table($table)->max($col);
                    } catch (\Throwable $e) {
                        continue;
                    }
                    if ($v !== null && ($max === null || $v > $max)) $max = $v;
                }
                return $max;
            } catch (\Throwable $e) {
                return null;
            }
        };

        $txMax = $maxOf('transactions', ['updated_at']);
        $stateMax = $maxOf('transaction_states', ['updated_at']);
        $runMax = $maxOf('transaction_step_runs', ['updated_at', 'performed_at', 'received_at']);
        $attachMax = $maxOf('transaction_attachments', ['updated_at', 'created_at']);
        $reqCheckMax = $maxOf('transaction_requirement_checks', ['updated_at', 'checked_at', 'created_at']);
        $checkMax = $maxOf('transaction_checklist_checks', ['updated_at', 'checked_at', 'created_at']);

        $stamps = array_filter([$txMax, $stateMax, $runMax, $attachMax, $reqCheckMax, $checkMax]);
        rsort($stamps);
        $latest = $stamps[0] ?? null;

        try {
            $count = Schema::hasTable('transactions') ? (int) DB::table('transactions')->count() : 0;
        } catch (\Throwable $e) {
            $count = 0;
        }

        return response()->json([
            'version' => implode('|', [$latest ?? 'none', $count]),
            'updated_at' => $latest,
            'count' => $count,
        ]);
    }

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
            ->latest()
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

    public function execute(
        Transaction $transaction,
        ExecuteActionRequest $request,
        RoutingEngine $routing,
        TransactionEngine $engine
    ) {
        $transaction->load([
            'type',
            'workflow.steps',
            'workflow.steps.office',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
            'state.currentStep.office',
            'state.currentStep.requirementDefinitions',
            'requirementChecks',
            'checklistChecks',
            'fieldValues.fieldDefinition',
            'runs.fromStep',
            'runs.fromStep.office',
            'runs.fromStep.roles',
            'runs.toStep',
            'runs.toStep.office',
            'runs.toStep.roles',
            'runs.performer',
            'runs.receiver',
            'runs.receivedOffice',
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
 