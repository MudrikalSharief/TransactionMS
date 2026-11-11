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
use App\Services\TransactionVisibility;
use Carbon\Carbon;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request, TransactionVisibility $visibility)
    {
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
            'transaction_type_id' => ['nullable', 'integer', 'exists:transaction_types,id'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'date_from' => ['nullable', 'date_format:Y-m-d'],
            'date_to' => ['nullable', 'date_format:Y-m-d'],
            // Access column filter: public = is_private ON (viewers can find
            // it on Track), private = is_private OFF (hidden from viewers).
            'access' => ['nullable', 'in:public,private'],
        ]);

        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');

        $query = Transaction::query()
            ->active()
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
        $visibility->apply($query, $user);

        if ($q !== '') {
            $query->where(function ($w) use ($q) {
                $w->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('title', 'like', "%{$q}%");
            });
        }

        if (!empty($data['transaction_type_id'])) {
            $query->where('transaction_type_id', (int) $data['transaction_type_id']);
        }

        if (!empty($data['office_id'])) {
            $query->where('office_id', (int) $data['office_id']);
        }

        if (!empty($data['access'])) {
            $query->where('is_private', $data['access'] === 'public');
        }

        if (!empty($data['date_from'])) {
            $query->where(
                'created_at',
                '>=',
                Carbon::createFromFormat('Y-m-d', $data['date_from'], 'Asia/Manila')
                    ->startOfDay()
                    ->utc()
            );
        }

        if (!empty($data['date_to'])) {
            $query->where(
                'created_at',
                '<=',
                Carbon::createFromFormat('Y-m-d', $data['date_to'], 'Asia/Manila')
                    ->endOfDay()
                    ->utc()
            );
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

    /**
     * Admin Track search visibility. When is_private is true the transaction
     * is discoverable by other viewer accounts through /track. Office admins
     * can change this only for transactions in their office scope.
     */
    public function updatePrivacy(Request $request, Transaction $transaction, AuditService $audit)
    {
        $data = $request->validate([
            'is_private' => ['required', 'boolean'],
        ]);

        $before = (bool) $transaction->is_private;
        $transaction->is_private = (bool) $data['is_private'];

        if ($transaction->isDirty('is_private')) {
            $transaction->save();

            $audit->log($request, 'transactions.privacy', $transaction, [
                'before' => ['is_private' => $before],
                'after' => ['is_private' => (bool) $transaction->is_private],
            ]);
        }

        return response()->json([
            'message' => $transaction->is_private
                ? 'Transaction is now searchable on Track.'
                : 'Transaction removed from Track search.',
            'data' => [
                'id' => $transaction->id,
                'is_private' => (bool) $transaction->is_private,
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
