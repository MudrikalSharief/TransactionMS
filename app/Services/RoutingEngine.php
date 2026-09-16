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
            'state.currentStep',
            'workflow.stepRoles.role',
            'fieldValues.fieldDefinition',
            'type',
        ]);

        $currentStep = $tx->state?->currentStep;
        if (!$currentStep) return [];

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
                    'to_step' => $toStep?->only(['id', 'code', 'name', 'stage', 'is_end']),
                    'route_group' => $route->route_group,
                    'required_approvals_count' => $route->required_approvals_count,
                ];
            }
        }

        return $available;
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

    public function assertUserCanExecute(Transaction $tx, User $user): void
    {
        $tx->loadMissing(['workflow.stepRoles.role', 'state.currentStep']);
        $currentStepId = (int) $tx->state?->current_step_id;

        if (!$currentStepId || !$this->userCanWorkOnStep($tx, $user, $currentStepId)) {
            abort(403, 'You are not allowed to act on the current step.');
        }
    }

    public function assertRouteExecutable(Transaction $tx, int $routeId, User $user): WorkflowRoute
    {
        $this->assertUserCanExecute($tx, $user);

        $tx->loadMissing([
            'workflow.routes',
            'workflow.steps',
            'state.currentStep',
            'state.currentStep.requirementDefinitions',
            'requirementChecks',
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
            $this->assertRequiredRequirementsChecked($tx, $currentStepId);
        }

        $context = $this->buildContext($tx);

        if (!$this->routeConditionPasses($route, $context)) {
            abort(422, 'Route condition not satisfied.');
        }

        return $route;
    }

    private function assertRequiredRequirementsChecked(Transaction $tx, int $stepId): void
    {
        $step = $tx->state?->currentStep;
        if (!$step) return;

        $reqs = $step->requirementDefinitions()
            ->wherePivot('is_required', true)
            ->get();

        if ($reqs->isEmpty()) return;

        $requiredIds = $reqs->pluck('id')->values();

        $checkedIds = collect($tx->requirementChecks ?? [])
            ->where('workflow_step_id', $stepId)
            ->pluck('requirement_definition_id')
            ->unique()
            ->values();

        $missingIds = $requiredIds->diff($checkedIds)->values();

        if ($missingIds->isNotEmpty()) {
            $missingNames = $reqs->whereIn('id', $missingIds)->pluck('name')->values();
            abort(422, 'Required checklist items not completed: ' . $missingNames->implode(', '));
        }
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
