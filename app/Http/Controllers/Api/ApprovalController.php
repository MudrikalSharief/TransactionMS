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
        return TransactionResource::collection($this->inbox($request->user()));
    }

    /**
     * Sidebar badge: unchecked required items across the inbox — missing
     * required uploads plus unvalidated required checklist items. Same rules
     * that block Proceed.
     */
    public function count(Request $request)
    {
        $inbox = $this->inbox($request->user());
        $cache = [];

        $pending = $inbox->sum(fn (Transaction $tx) => $this->uncheckedItems($tx, $cache));

        return response()->json([
            'pending_requirements' => $pending,
            'transactions' => $inbox->count(),
        ]);
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
            'checklist' => (int) $step->order_number === 1
                ? collect()
                : $this->checklists->ensureItems($step)->filter(fn ($i) => $i->is_required)->pluck('id')->map(fn ($id) => (int) $id),
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

        return Transaction::query()
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
            ->get()
            ->filter(fn (Transaction $tx) => $tx->state?->currentStep
                && $this->routing->userCanWorkOnCurrentStep($tx, $user))
            ->values();
    }
}
