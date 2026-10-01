<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\User;
use App\Models\WorkflowRoute;

class RoutingEngine
{
    public function __construct(
        private readonly JsonLogicEvaluator $evaluator
    ) {}

    public function availableActions(Transaction $tx, User $user): array
    {
        $tx->loadMissing([
            'workflow.routes',
            'workflow.steps',
            'workflow.steps.office',
            'state.currentStep',
            'workflow.stepRoles.role',
            'fieldValues.fieldDefinition',
            'type',
        ]);

        $currentStep = $tx->state?->currentStep;
        if (!$currentStep) return [];

        // Finalized transactions are view-only — no actions at all.
        if ((bool) ($tx->is_done ?? false)) return [];

        // Pending receipt locks the station: destination office must click
        // Receive before any Proceed/return/jump action is offered.
        if ($this->hasPendingReceipt($tx)) return [];

        if (!$this->userCanWorkOnStep($tx, $user, (int) $currentStep->id)) {
            return [];
        }

        $context = $this->buildContext($tx);

        $routes = $tx->workflow->routes
            ->where('from_step_id', (int) $currentStep->id)
            ->values();

        $available = [];
        foreach ($routes as $route) {
            if ($this->routeConditionPasses($route, $context)) {
                $toStep = $tx->workflow->steps->firstWhere('id', $route->to_step_id);

                $available[] = [
                    'route_id' => $route->id,
                    'action_code' => $route->action_code,
                    'is_return_route' => (bool) $route->is_return_route,
                    'to_step' => $toStep ? array_merge(
                        $toStep->only(['id', 'code', 'name', 'order_number', 'stage', 'is_end', 'office_id']),
                        ['office' => $toStep->office?->only(['id', 'code', 'name'])]
                    ) : null,
                    'route_group' => $route->route_group,
                    'required_approvals_count' => $route->required_approvals_count,
                ];
            }
        }

        return $available;
    }

    /**
     * Stations the paper has already passed through (every from/to step
     * in the run history, plus current). Monotonic: moving never
     * un-visits. Drives free jumps + the tracker colors.
     */
    public function visitedStepIds(Transaction $tx): array
    {
        $ids = \App\Models\TransactionStepRun::query()
            ->where('transaction_id', $tx->id)
            ->get(['from_step_id', 'to_step_id'])
            ->flatMap(fn ($r) => [(int) $r->from_step_id, (int) $r->to_step_id])
            ->filter(fn ($id) => $id > 0)
            ->unique()
            ->values()
            ->all();

        $tx->loadMissing(['state']);
        $currentStepId = (int) ($tx->state?->current_step_id ?? 0);
        if ($currentStepId > 0 && !in_array($currentStepId, $ids, true)) {
            $ids[] = $currentStepId;
        }

        return array_values($ids);
    }

    public function userCanWorkOnCurrentStep(Transaction $tx, User $user): bool
    {
        $tx->loadMissing([
            'workflow.stepRoles.role',
            'state.currentStep',
        ]);

        $stepId = (int) ($tx->state?->current_step_id ?? 0);
        if (!$stepId) return false;

        return $this->userCanWorkOnStep($tx, $user, $stepId);
    }

    /**
     * True when the latest forward has not been received yet.
     * Used to lock Proceed actions until the destination office receives.
     */
    public function hasPendingReceipt(Transaction $tx): bool
    {
        return \App\Models\TransactionStepRun::where('transaction_id', $tx->id)
            ->whereNull('received_at')
            ->exists();
    }

    public function pendingReceipt(Transaction $tx): ?\App\Models\TransactionStepRun
    {
        return \App\Models\TransactionStepRun::where('transaction_id', $tx->id)
            ->whereNull('received_at')
            ->with(['fromStep:id,code,name', 'toStep:id,code,name,office_id', 'performer:id,name', 'receivedOffice:id,code,name'])
            ->orderByDesc('performed_at')
            ->orderByDesc('id')
            ->first();
    }

    public function assertUserCanExecute(Transaction $tx, User $user): void
    {
        if ((bool) ($tx->is_done ?? false)) {
            abort(422, 'Transaction is finalized and view-only.');
        }
        $tx->loadMissing(['workflow.stepRoles.role', 'state.currentStep']);
        $currentStepId = (int) $tx->state?->current_step_id;

        if (!$currentStepId || !$this->userCanWorkOnStep($tx, $user, $currentStepId)) {
            abort(403, 'You are not allowed to act on the current step.');
        }
    }

    public function assertRouteExecutable(Transaction $tx, int $routeId, User $user): WorkflowRoute
    {
        $this->assertUserCanExecute($tx, $user);
        if ($this->hasPendingReceipt($tx)) {
            abort(422, 'Please receive the step first before acting.');
        }
        $tx->loadMissing([
            'workflow.routes',
            'workflow.steps',
            'workflow.steps.office',
            'state.currentStep',
            'state.currentStep.office',
            'state.currentStep.requirementDefinitions',
            'requirementChecks',
            'checklistChecks',
            'attachments',
            'fieldValues.fieldDefinition',
            'type',
        ]);

        $currentStepId = (int) $tx->state->current_step_id;

        /** @var WorkflowRoute|null $route */
        $route = $tx->workflow->routes->firstWhere('id', $routeId);
        if (!$route) {
            abort(422, 'Route not found in pinned workflow.');
        }

        if ((int) $route->from_step_id !== (int) $currentStepId) {
            abort(422, 'Route does not start from current step.');
        }

        // Returns never require the checklist: a station sending work back
        // must not be blocked by its own incomplete items.
        if (!$route->is_return_route) {
            $this->assertRequiredRequirementsUploaded($tx, $currentStepId);
            $this->assertRequiredHardCopyTicks($tx, $currentStepId);
            // Step 1 → step 2 shows requirements only: no checklist gate.
            // (Checklists mirror the previous station's requirements, so
            // step 1 has none anyway; this also guards custom items an
            // admin may have added to a start step.)
            if (!$this->isFirstStepTransition($tx, $route)) {
                $this->assertRequiredChecklistTicked($tx, $currentStepId);
            }
        }

        $context = $this->buildContext($tx);

        if (!$this->routeConditionPasses($route, $context)) {
            abort(422, 'Route condition not satisfied.');
        }

        return $route;
    }

    /**
     * Required requirements block Proceed until at least one file is
     * attached for that item. Optional requirements never block.
     */
    private function assertRequiredRequirementsUploaded(Transaction $tx, int $stepId): void
    {
        $step = $tx->state?->currentStep;
        if (!$step) return;

        $reqs = $step->requirementDefinitions()
            ->get()
            ->filter(fn ($r) => (bool) ($r->pivot?->is_upload_required ?? $r->pivot?->is_required ?? true))
            ->values();

        if ($reqs->isEmpty()) return;

        $tx->loadMissing('attachments');
        $attCounts = collect($tx->attachments ?? [])
            ->where('workflow_step_id', $stepId)
            ->groupBy(fn ($a) => (int) ($a->requirement_definition_id ?? 0))
            ->map(fn ($g) => $g->count());

        $missing = $reqs
            ->filter(fn ($r) => ($attCounts->get((int) $r->id, 0) ?? 0) < 1)
            ->pluck('name')
            ->values();

        if ($missing->isNotEmpty()) {
            abort(422, 'Upload-required items missing files: ' . $missing->implode(', '));
        }
    }

    /**
     * Required requirements (tick-only AND upload rows like AR/Payroll)
     * block Proceed until ticked. The top tick unlocks the upload card
     * below. Optional rows never block.
     */
    private function assertRequiredHardCopyTicks(Transaction $tx, int $stepId): void
    {
        $step = $tx->state?->currentStep;
        if (!$step) return;

        $reqs = $step->requirementDefinitions()
            ->get()
            ->filter(fn ($r) => (bool) ($r->pivot?->is_required ?? true))
            ->values();

        if ($reqs->isEmpty()) return;

        $checkedIds = collect($tx->requirementChecks ?? [])
            ->where('workflow_step_id', $stepId)
            ->pluck('requirement_definition_id')
            ->map(fn ($v) => (int) $v)
            ->unique()
            ->values();

        $missing = $reqs
            ->filter(fn ($r) => !$checkedIds->contains((int) $r->id))
            ->pluck('name')
            ->values();

        if ($missing->isNotEmpty()) {
            abort(422, 'Required hard-copy items not ticked: ' . $missing->implode(', '));
        }
    }

    /**
     * Required checklist items block Proceed until ticked. Optional
     * checklist items never block — same shape as the old requirement ticks.
     */
    private function assertRequiredChecklistTicked(Transaction $tx, int $stepId): void
    {
        $step = $tx->state?->currentStep;
        if (!$step) return;

        $items = \app(\App\Services\ChecklistService::class)->ensureItems($step);
        $required = $items->filter(fn ($i) => (bool) $i->is_required)->values();
        if ($required->isEmpty()) return;

        $checkedIds = collect($tx->checklistChecks ?? [])
            ->where('workflow_step_id', $stepId)
            ->pluck('checklist_override_id')
            ->filter()
            ->map(fn ($v) => (int) $v)
            ->unique()
            ->values();

        $missingNames = $required
            ->filter(fn ($i) => !$checkedIds->contains((int) $i->id))
            ->pluck('name')
            ->values();

        if ($missingNames->isNotEmpty()) {
            abort(422, 'Required checklist items not completed: ' . $missingNames->implode(', '));
        }
    }

    /**
     * The step 1 → step 2 transition shows requirements only, so the
     * checklist is neither displayed nor enforced. Returns and every
     * other transition keep the checklist gate.
     */
    private function isFirstStepTransition(Transaction $tx, WorkflowRoute $route): bool
    {
        $from = $tx->workflow->steps->firstWhere('id', (int) $route->from_step_id);
        $to = $tx->workflow->steps->firstWhere('id', (int) $route->to_step_id);

        return (int) ($from?->order_number ?? 0) === 1
            && (int) ($to?->order_number ?? 0) === 2;
    }

    private function userCanWorkOnStep(Transaction $tx, User $user, int $stepId): bool
    {
        $user->loadMissing('roles');
        if ($user->roles->contains(fn ($r) => $r->code === 'superadmin')) return true;

        $allowedRoleIds = $tx->workflow->stepRoles
            ->where('workflow_step_id', $stepId)
            ->pluck('role_id')
            ->unique()
            ->values();

        if ($allowedRoleIds->isEmpty()) return false;

        $userRoleIds = $user->roles->pluck('id')->values();

        return $allowedRoleIds->intersect($userRoleIds)->isNotEmpty();
    }

    private function routeConditionPasses(WorkflowRoute $route, array $context): bool
    {
        if (!$route->condition_expression) return true;

        return (bool) $this->evaluator->evaluate($route->condition_expression, $context);
    }

    private function buildContext(Transaction $tx): array
    {
        $fieldsByCode = [];

        $tx->loadMissing(['fieldValues.fieldDefinition', 'state.currentStep', 'workflow', 'type']);

        foreach (($tx->fieldValues ?? []) as $fv) {
            $code = $fv->fieldDefinition?->code;
            if (!$code) continue;

            $val = null;

            if (is_array($fv->value_json) && array_key_exists('value', $fv->value_json)) {
                $val = $fv->value_json['value'];
            } elseif ($fv->value_number !== null) {
                $val = is_numeric($fv->value_number) ? ($fv->value_number + 0) : $fv->value_number;
            } elseif ($fv->value_text !== null) {
                $val = $fv->value_text;
            } else {
                $val = $fv->value_json;
            }

            $fieldsByCode[$code] = $val;
        }

        return [
            'transaction_id' => $tx->id,
            'transaction_type_code' => $tx->type?->code,
            'workflow_version' => $tx->workflow?->version,
            'current_step_code' => $tx->state?->currentStep?->code,
            'fields' => $fieldsByCode,
        ];
    }
}
