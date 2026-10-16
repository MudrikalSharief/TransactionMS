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
                ['office' => $currentStep->office?->only(['id', 'code', 'name'])]
            ) : null,
            'entered_at' => $state?->entered_at?->toISOString(),

            // Minimal steps for the hover StepProgress popout (works from cache too).
            'workflow_steps' => $this->whenLoaded(
                'workflow',
                fn () => $this->workflow?->steps?->map(fn ($s) => array_merge(
                    $s->only(['id', 'order_number', 'parent_id', 'code', 'name', 'stage', 'is_start', 'is_end', 'office_id']),
                    ['office' => $s->office?->only(['id', 'code', 'name'])]
                ))?->values()
            ),
        ];
    }
}
