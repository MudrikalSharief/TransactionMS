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
     * Approval inbox: open transactions at a station the user works on
     * whose checklist mirrors the previous station's requirements — the
     * user validates what that station submitted. Start stations have no
     * predecessor, so they never appear. Attachments are loaded so each
     * item carries the previous station's files.
     */
    public function index(Request $request)
    {
        return TransactionResource::collection($this->inbox($request->user()));
    }

    /**
     * Sidebar badge: required requirements still waiting to be validated
     * across the inbox (unticked required checklist items).
     */
    public function count(Request $request)
    {
        $inbox = $this->inbox($request->user());
        $requiredByStep = [];

        $pending = $inbox->sum(function (Transaction $tx) use (&$requiredByStep) {
            $step = $tx->state->currentStep;
            $required = $requiredByStep[$step->id] ??= $this->checklists->ensureItems($step)
                ->filter(fn ($item) => $item->is_required);
            $ticked = $tx->checklistChecks
                ->where('workflow_step_id', $step->id)
                ->pluck('checklist_override_id')
                ->map(fn ($id) => (int) $id);

            return $required->reject(fn ($item) => $ticked->contains((int) $item->id))->count();
        });

        return response()->json([
            'pending_requirements' => $pending,
            'transactions' => $inbox->count(),
        ]);
    }

    private function inbox(User $user): Collection
    {
        $user->loadMissing('roles');

        // Approvals needs an assigned role, and end users submit rather than
        // approve. Superadmin always keeps access. Mirrors canUseApprovals()
        // in resources/js/composables/useAuth.js.
        $roleCodes = $user->roles->pluck('code');
        if ($roleCodes->isEmpty()) {
            abort(403, 'The Approvals section requires an assigned role.');
        }
        if ($roleCodes->contains('end_user') && !$roleCodes->contains('superadmin')) {
            abort(403, 'The Approvals section is not available to end users.');
        }

        $items = Transaction::query()
            ->where('is_done', false)
            ->with([
                'type',
                'office',
                'workflow',
                'workflow.stepRoles.role',
                'state.currentStep',
                'creator',
                'checklistChecks.checker',
                'attachments.uploader',
            ])
            ->latest()
            ->get();

        $reviewsPredecessor = [];

        return $items->filter(function (Transaction $tx) use ($user, &$reviewsPredecessor) {
            $step = $tx->state?->currentStep;
            if (!$step || !$this->routing->userCanWorkOnCurrentStep($tx, $user)) return false;

            return $reviewsPredecessor[$step->id] ??= $this->checklists->ensureItems($step)
                ->contains(fn ($item) => $item->requirement_definition_id !== null);
        })->values();
    }
}
