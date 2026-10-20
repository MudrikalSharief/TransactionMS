<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Models\User;
use App\Services\ChecklistService;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;

class ApprovalController extends Controller
{
    public function __construct(
        private readonly RoutingEngine $routing,
        private readonly ChecklistService $checklists,
    ) {}

    /**
     * Approval inbox: every open transaction waiting at a station the user
     * works on (same set as My Transactions). A transaction is "pending"
     * while it still has unchecked items there: a required upload of this
     * station, or a required previous-station requirement to validate.
     * Attachments are loaded so each item carries its files.
     */
    public function index(Request $request)
    {
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        return TransactionResource::collection(
            $this->inbox($request->user(), $data)
        );
    }

    /**
     * Sidebar badge: unchecked required items across the inbox — missing
     * required uploads plus unvalidated required checklist items. Same rules
     * that block Proceed.
     */
    public function count(Request $request)
    {
        $this->ensureApprovalsAllowed($request->user());

        // Badge totals need the whole inbox, not one page — but the badge now
        // polls every 1-5min (AppShell) so a 60s server cache is safe and
        // keeps weak devices / bad networks from rescanning on every poll.
        $userId = $request->user()->id;
        $cached = \Illuminate\Support\Facades\Cache::remember(
            "approvals:count:u{$userId}",
            60,
            function () use ($request) {
                $txs = $this->allInboxRows($request->user());
                $cache = [];
                $pending = $txs->sum(fn (Transaction $tx) => $this->uncheckedItems($tx, $cache));

                return [
                    'pending_requirements' => $pending,
                    'transactions' => $txs->count(),
                ];
            }
        );

        return response()->json($cached);
    }

    /**
     * Approvals needs an assigned role, and end users submit rather than
     * approve. Superadmin always keeps access. Mirrors canUseApprovals()
     * in resources/js/composables/useAuth.js. Shared by index() and count()
     * so the badge endpoint can't bypass the inbox gate.
     */
    private function ensureApprovalsAllowed(User $user): void
    {
        $user->loadMissing('roles');
        $roleCodes = $user->roles->pluck('code');
        if ($roleCodes->isEmpty()) {
            abort(403, 'The Approvals section requires an assigned role.');
        }
        if ($roleCodes->contains('end_user') && !$roleCodes->contains('superadmin')) {
            abort(403, 'The Approvals section is not available to end users.');
        }
    }

    /** Full inbox collection for the badge (minimal columns, no pagination). */
    private function allInboxRows(User $user): Collection
    {
        $user->loadMissing('roles');
        $roleIds = $user->roles->pluck('id')->filter()->values()->all();
        $isSuperadmin = $user->roles->pluck('code')->contains('superadmin');
        $isOfficeAdmin = !$isSuperadmin && $user->isOfficeAdmin();

        $query = Transaction::query()
            ->where('is_done', false)
            ->with(['state.currentStep', 'attachments', 'checklistChecks'])
            ->latest();

        if (!$isSuperadmin) {
            if ($isOfficeAdmin) {
                // End-user stations follow the transaction's office.
                $query->where(function ($w) use ($user) {
                    $w->where(function ($x) use ($user) {
                        $x->where('transactions.office_id', $user->office_id)
                            ->whereHas('state.currentStep', fn ($s) => $s->where('workflow_steps.is_end_user', true));
                    })->orWhereHas('state.currentStep', fn ($s) => $s
                        ->where('workflow_steps.office_id', $user->office_id)
                        ->where('workflow_steps.is_end_user', false));
                });
            } elseif (empty($roleIds)) {
                return collect();
            } else {
                $query->whereHas('state.currentStep', function ($s) use ($roleIds, $user) {
                    $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                        ->where(function ($x) use ($user) {
                            $x->where(function ($y) use ($user) {
                                $y->where('workflow_steps.is_end_user', true);
                                if ($user->office_id !== null) {
                                    $y->where('transactions.office_id', $user->office_id);
                                }
                            })->orWhere(function ($y) use ($user) {
                                $y->where('workflow_steps.is_end_user', false);
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

        return $query->get()
            ->filter(fn (Transaction $tx) => $tx->state?->currentStep
                && $this->routing->userCanWorkOnCurrentStep($tx, $user))
            ->values();
    }

    /** Unchecked required items at the transaction's current station. */
    private function uncheckedItems(Transaction $tx, array &$cache): int
    {
        $step = $tx->state?->currentStep;
        if (!$step) return 0;

        $cache[$step->id] ??= [
            'uploads' => $step->requirementDefinitions()->wherePivot('is_required', true)->pluck('requirement_definitions.id')
                ->map(fn ($id) => (int) $id),
            // Step 1 -> 2 is requirements-only: the checklist isn't enforced there.
            // Read-only (itemsFor, no sync): checklist rows are synced on write
            // paths (requirements/routes/checklist admins + transitions), so
            // GETs never WRITE — faster lists + safe on bad networks/retries.
            'checklist' => (int) $step->order_number === 1
                ? collect()
                : $this->checklists->itemsFor($step)->filter(fn ($i) => $i->is_required)->pluck('id')->map(fn ($id) => (int) $id),
        ];

        $uploaded = $tx->attachments
            ->where('workflow_step_id', $step->id)
            ->pluck('requirement_definition_id')
            ->map(fn ($id) => (int) $id);
        $ticked = $tx->checklistChecks
            ->where('workflow_step_id', $step->id)
            ->pluck('checklist_override_id')
            ->map(fn ($id) => (int) $id);

        return $cache[$step->id]['uploads']->reject(fn ($id) => $uploaded->contains($id))->count()
            + $cache[$step->id]['checklist']->reject(fn ($id) => $ticked->contains($id))->count();
    }

    private function inbox(User $user, array $filters = [])
    {
        $this->ensureApprovalsAllowed($user);

        $roleCodes = $user->roles->pluck('code');
        $isSuperadmin = $roleCodes->contains('superadmin');
        $isOfficeAdmin = !$isSuperadmin && $user->isOfficeAdmin();
        $roleIds = $user->roles->pluck('id')->filter()->values()->all();
        $perPage = (int) ($filters['per_page'] ?? 25);
        $perPage = max(1, min(100, $perPage));
        $q = trim($filters['q'] ?? '');

        $query = Transaction::query()
            ->where('is_done', false)
            // Eager-load everything TransactionResource reads on lists so the
            // 25 rows on this page don't fan out to N*5 lazy queries.
            ->with([
                'type:id,code,name',
                'office:id,code,name',
                'workflow.steps.office:id,code,name',
                'workflow.routes',
                'workflow.stepRoles.role',
                'state.currentStep.office',
                'creator:id,name,email',
                'fieldValues.fieldDefinition',
                'requirementChecks.checker',
                'checklistChecks.checker',
                'attachments.uploader',
                'attachments.step',
                'attachments.requirement',
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
                // End-user stations follow the transaction's office.
                $query->where(function ($w) use ($user) {
                    $w->where(function ($x) use ($user) {
                        $x->where('transactions.office_id', $user->office_id)
                            ->whereHas('state.currentStep', fn ($s) => $s->where('workflow_steps.is_end_user', true));
                    })->orWhereHas('state.currentStep', fn ($s) => $s
                        ->where('workflow_steps.office_id', $user->office_id)
                        ->where('workflow_steps.is_end_user', false));
                });
            } else {
                $query->whereHas('state.currentStep', function ($s) use ($roleIds, $user) {
                    $s->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
                        ->where(function ($x) use ($user) {
                            $x->where(function ($y) use ($user) {
                                $y->where('workflow_steps.is_end_user', true);
                                if ($user->office_id !== null) {
                                    $y->where('transactions.office_id', $user->office_id);
                                }
                            })->orWhere(function ($y) use ($user) {
                                $y->where('workflow_steps.is_end_user', false);
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

        // Final in-memory guard preserves exact RoutingEngine semantics for
        // the rows on this page (cheap: max 25 rows, unlike whole-table).
        $page->setCollection(
            $page->getCollection()->filter(fn (Transaction $tx) => $tx->state?->currentStep
                && $this->routing->userCanWorkOnCurrentStep($tx, $user))
                ->values()
        );

        return $page;
    }
}
