<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\CreateTransactionRequest;
use App\Http\Requests\Transactions\ExecuteActionRequest;
use App\Http\Resources\TransactionListResource;
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
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');

        $query = Transaction::query()
            // Slim eager loads only: everything TransactionListResource reads.
            // No fieldValues/checks/attachments/runs on lists (detail only).
            ->with([
                'type:id,code,name',
                'office:id,code,name,icon_path',
                'workflow.steps.office:id,code,name,icon_path',
                'workflow.stepRoles.role',
                'state.currentStep.office:id,code,name,icon_path',
                'creator:id,name,email',
            ])
            ->latest();

        $user = $request->user();
        $user->loadMissing('roles');
        $isSuperadmin = $user->roles->contains(fn ($r) => $r->code === 'superadmin');
        $roleIds = $user->roles->pluck('id')->filter()->values()->all();

        if (!$isSuperadmin) {
            if ($user->isOfficeAdmin()) {
                // Office admins track their own office's papers city-wide
                // (the dashboard summary counts them and their detail opens
                // from there), plus anything parked at their office. Legacy
                // no-origin stations stay role-only, even for admins.
                $query->where(function ($w) use ($roleIds, $user) {
                    $w->where('transactions.office_id', $user->office_id)
                        ->orWhereHas('state.currentStep', fn ($s) => $s
                            ->whereEffectiveOffice($user->office_id))
                        ->orWhereHas('state.currentStep', function ($s) use ($roleIds) {
                            $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                                ->whereLegacyNoOriginFallback();
                        });
                });
            } else {
                // Regular users: their own office's transactions, plus any
                // row whose current station lists one of their roles and has
                // their office as its effective office. Blank stations follow
                // the transaction's Originating Office; end-user stations do
                // too. Legacy no-origin stations stay role-only.
                if ($user->office_id === null) {
                    $query->whereRaw('1 = 0');
                } elseif (empty($roleIds)) {
                    $query->where('transactions.office_id', $user->office_id);
                } else {
                    $query->where(function ($w) use ($roleIds, $user) {
                        $w->where('transactions.office_id', $user->office_id)
                            ->orWhereHas('state.currentStep', function ($s) use ($roleIds, $user) {
                                $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                                    ->where(function ($x) use ($user) {
                                        $x->whereEffectiveOffice($user->office_id)
                                            ->orWhere(fn ($y) => $y->whereLegacyNoOriginFallback());
                                    });
                            });
                    });
                }
            }
        }

        if ($q !== '') {
            $query->where(function ($w) use ($q) {
                $w->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('title', 'like', "%{$q}%");
            });
        }

        return TransactionListResource::collection($query->paginate($perPage));
    }

    public function store(CreateTransactionRequest $request, TransactionEngine $engine)
    {
        $user = $request->user();

        if ($user->hasRole('superadmin')) {
            // Required by CreateTransactionRequest; never null here.
            $officeId = $request->validated()['office_id'];
        } else {
            $officeId = $user->office_id;

            abort_if($officeId === null, 422, 'Your account has no office assigned.');
        }

        $tx = $engine->create(
            (int) $request->validated()['transaction_type_id'],
            $request->validated()['title'] ?? null,
            $user->id,
            $officeId
        );

        return (new TransactionResource($tx))->response()->setStatusCode(201);
    }

    public function updateOffice(Request $request, Transaction $transaction, RoutingEngine $routing, AuditService $audit)
    {
        $data = $request->validate([
            // A transaction always belongs to an office; reassignment can
            // move it but never clear it.
            'office_id' => ['required', 'integer', 'exists:offices,id'],
        ]);

        $before = ['office_id' => $transaction->office_id];
        $transaction->office_id = $data['office_id'];
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
            'workflow.steps.office',
            'workflow.routes',
            'workflow.stepRoles.role',
            'state.currentStep',
            'state.currentStep.office',
            'state.currentStep.requirementDefinitions',
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

    public function show(Transaction $transaction, Request $request, RoutingEngine $routing)
    {
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
            'state.currentStep.requirementDefinitions',
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

    public function executeAction(
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
            'fieldValues.fieldDefinition',
            'requirementChecks.checker',
            'checklistChecks.checker',
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
            $request->validated()['attachment_ids'] ?? [],
            $request->validated()['step_data'] ?? [],
            $request->validated()['flagged_items'] ?? []
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
