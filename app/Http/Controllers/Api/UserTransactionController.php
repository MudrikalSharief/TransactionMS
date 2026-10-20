<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\CreateTransactionRequest;
use App\Http\Requests\Transactions\ExecuteActionRequest;
use App\Http\Resources\TransactionListResource;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Models\TransactionType;
use App\Services\OfficeScope;
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

    public function index(Request $request, RoutingEngine $routing, OfficeScope $officeScope)
    {
        $user = $request->user();
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);
        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');

        $user->loadMissing('roles');
        $isSuperadmin = $user->roles->contains(fn ($r) => $r->code === 'superadmin');
        $isOfficeAdmin = !$isSuperadmin && $user->isOfficeAdmin();
        $roleIds = $user->roles->pluck('id')->filter()->values()->all();

        $query = Transaction::query()
            ->with([
                'type:id,code,name',
                'office:id,code,name',
                'workflow.steps.office:id,code,name',
                'workflow.stepRoles.role',
                'state.currentStep.office:id,code,name',
                'creator:id,name,email',
            ])
            ->latest();

        if ($q !== '') {
            $query->where(function ($w) use ($q) {
                $w->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('title', 'like', "%{$q}%");
            });
        }

        if (!$isSuperadmin) {
            if ($isOfficeAdmin) {
                // Office admins: rows parked at their office (end-user
                // stations follow the transaction's office), plus every
                // transaction their office filed or that routes through it.
                $query->where(function ($w) use ($user, $officeScope) {
                    $w->where(function ($x) use ($user) {
                        $x->where('transactions.office_id', $user->office_id)
                            ->whereHas('state.currentStep.roles', fn ($r) => $r->where('roles.code', 'end_user'));
                    })->orWhereHas('state.currentStep', fn ($s) => $s
                        ->where('workflow_steps.office_id', $user->office_id)
                        ->whereDoesntHave('roles', fn ($r) => $r->where('roles.code', 'end_user')))
                    ->orWhere(fn ($o) => $officeScope->apply($o, (int) $user->office_id));
                });
            } elseif (empty($roleIds)) {
                return TransactionListResource::collection($query->whereRaw('1 = 0')->paginate($perPage));
            } else {
                // Push the role + office gate to SQL (no schema change). Only
                // rows whose current station lists one of the user's roles and
                // matches their office: regular stations by stored office
                // (office-less keep role-only), end-user stations by the
                // transaction's office. Keeps the exact
                // userCanWorkOnCurrentStep() semantics for the paged rows below.
                $query->whereHas('state.currentStep', function ($s) use ($roleIds, $user) {
                    $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                        ->where(function ($x) use ($user) {
                            $x->where(function ($y) use ($user) {
                                $y->whereHas('roles', fn ($r) => $r->where('roles.code', 'end_user'));
                                if ($user->office_id !== null) {
                                    $y->where('transactions.office_id', $user->office_id);
                                }
                            })->orWhere(function ($y) use ($user) {
                                $y->whereDoesntHave('roles', fn ($r) => $r->where('roles.code', 'end_user'));
                                if ($user->office_id !== null) {
                                    $y->where(function ($z) use ($user) {
                                        $z->whereNull('workflow_steps.office_id')
                                            ->orWhere('workflow_steps.office_id', $user->office_id);
                                    });
                                }
                            });
                        });
                });
            }
        }

        $page = $query->paginate($perPage);

        // Final in-memory guard preserves exact RoutingEngine semantics
        // (e.g. rows with no current step) for the 25 rows on this page —
        // cheap, unlike filtering the whole table.
        $page->setCollection(
            $page->getCollection()->filter(
                fn (Transaction $tx) => $isSuperadmin
                    || $officeScope->covers($tx, $user)
                    || $routing->userCanWorkOnCurrentStep($tx, $user)
            )->values()
        );

        return TransactionListResource::collection($page);
    }

    /**
     * Office admins start transactions for processes their office may file
     * (linked to their office, or linked to no office); the transaction
     * belongs to their office. Superadmins use the admin API.
     */
    public function store(CreateTransactionRequest $request, TransactionEngine $engine)
    {
        $user = $request->user();
        abort_unless($user->isOfficeAdmin(), 403, 'Only office admins can start transactions here.');

        $typeId = (int) $request->validated()['transaction_type_id'];
        $allowed = TransactionType::query()->fileableBy((int) $user->office_id)->whereKey($typeId)->exists();
        abort_unless($allowed, 403, 'Your office is not set up to file this process.');

        $tx = $engine->create(
            $typeId,
            $request->validated()['title'] ?? null,
            $user->id,
            (int) $user->office_id
        );

        return (new TransactionResource($tx))->response()->setStatusCode(201);
    }

    public function show(Transaction $transaction, Request $request, RoutingEngine $routing)
    {
        $routing->assertUserCanView($transaction, $request->user());

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
 