<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Slim list projection for tables/search/dashboard.
 *
 * Deliberately avoids every per-row query in TransactionResource
 * (fieldDefinitions()->get(), requirementDefinitions()->get(),
 * predecessorsFor(), ensureItems() which WRITES on GET). Only reads
 * already-eager-loaded relations, so a 25-row page costs ~6 queries
 * total instead of N*5-10. Detail pages must use TransactionResource.
 */
class TransactionListResource extends JsonResource
{
    public function toArray($request): array
    {
        $state = $this->whenLoaded('state');
        $currentStep = $state?->currentStep;

        return [
            'id' => $this->id,
            'reference_number' => $this->reference_number,
            'title' => $this->title,
            'is_done' => (bool) $this->is_done,

            'transaction_type' => $this->type?->only(['id', 'code', 'name']),
            // Back-compat flat names used by tables/search/slimTx cache.
            'transaction_type_name' => $this->type?->name,
            'office' => $this->office?->only(['id', 'code', 'name']),
            'office_name' => $this->office?->name,
            'workflow' => $this->workflow?->only(['id', 'version', 'status', 'name']),

            'created_by' => $this->creator?->only(['id', 'name', 'email']),
            'created_at' => $this->created_at?->toISOString(),

            'current_step' => $currentStep ? array_merge(
                $currentStep->only(['id', 'order_number', 'code', 'name', 'stage', 'sla_minutes', 'is_start', 'is_end', 'office_id']),
                $this->stepOfficePayload($currentStep)
            ) : null,
            'entered_at' => $state?->entered_at?->toISOString(),

            // True when the paper is currently waiting on the requesting
            // user (same gate the write endpoints enforce). Lets the
            // dashboard split "waiting on me" from "in transit with other
            // offices" without re-deriving role/office rules client-side.
            'needs_action' => $this->needsAction($request),

            // Minimal steps for the hover StepProgress popout (works from cache too).
            'workflow_steps' => $this->whenLoaded(
                'workflow',
                fn () => $this->workflow?->steps?->map(fn ($s) => array_merge(
                    $s->only(['id', 'order_number', 'parent_id', 'code', 'name', 'stage', 'is_start', 'is_end', 'office_id']),
                    $this->stepOfficePayload($s)
                ))?->values()
            ),
        ];
    }

    /**
     * office_id + office for a step, with end-user and office-less
     * stations following the transaction's office instead of the
     * workflow template's step office.
     */
    private function stepOfficePayload($step): array
    {
        $office = $this->displayStepOffice($step);

        return [
            'office_id' => $office?->id,
            'office' => $office?->only(['id', 'code', 'name']),
        ];
    }

    /**
     * Waiting on the requesting user? Finalized rows are never actionable.
     * Relations are already eager-loaded by the list endpoints, so this is
     * pure PHP per row (no extra queries).
     */
    private function needsAction($request): bool
    {
        $user = $request?->user();
        $tx = $this->resource;

        if (!$user || (bool) $tx->is_done) return false;

        $tx->loadMissing(['workflow.stepRoles.role', 'state.currentStep', 'office']);
        if (!$tx->state?->currentStep) return false;

        return app(\App\Services\RoutingEngine::class)->userCanWorkOnCurrentStep($tx, $user);
    }
}
