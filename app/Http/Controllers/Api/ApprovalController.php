<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\ChecklistService;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

class ApprovalController extends Controller
{
    /**
     * Approval inbox: open transactions at a station the user works on
     * whose checklist mirrors the previous station's requirements — the
     * user validates what that station submitted. Start stations have no
     * predecessor, so they never appear. Attachments are loaded so each
     * item carries the previous station's files.
     */
    public function index(Request $request, RoutingEngine $routing, ChecklistService $checklists)
    {
        $user = $request->user();

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

        $filtered = $items->filter(function (Transaction $tx) use ($routing, $user, $checklists, &$reviewsPredecessor) {
            $step = $tx->state?->currentStep;
            if (!$step || !$routing->userCanWorkOnCurrentStep($tx, $user)) return false;

            return $reviewsPredecessor[$step->id] ??= $checklists->ensureItems($step)
                ->contains(fn ($item) => $item->requirement_definition_id !== null);
        })->values();

        return TransactionResource::collection($filtered);
    }
}
