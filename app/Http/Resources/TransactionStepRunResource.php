<?php

namespace App\Http\Resources;

use App\Models\Office;
use App\Models\Transaction;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionStepRunResource extends JsonResource
{
    /** Parent transaction when the run is serialized inside one. */
    public ?Transaction $transaction = null;

    public function forTransaction(Transaction $transaction): static
    {
        $this->transaction = $transaction;

        return $this;
    }

    public function toArray($request): array
    {
        $estimated = (int) ($this->sla_minutes_snapshot ?? $this->toStep?->sla_minutes ?? 0);
        $actual = null;
        if ($this->performed_at && $this->received_at) {
            $actual = (int) max(0, $this->performed_at->diffInMinutes($this->received_at, true));
        }

        return [
            'id' => $this->id,
            'from_step' => $this->stepPayload($this->fromStep),
            'to_step' => $this->stepPayload($this->toStep),
            'action_code' => $this->action_code,
            'remarks' => $this->remarks,
            'flagged_items' => $this->flagged_items ?? [],
            // #3 From user / #1 From (releasing) timestamp
            'performed_by' => $this->userPayload($this->performer),
            'performed_at' => $this->performed_at?->toISOString(),
            'released_at' => $this->performed_at?->toISOString(),
            // #4 To user / #2 To (receiving) timestamp
            'received_by' => $this->receiver ? $this->userPayload($this->receiver) : null,
            'received_at' => $this->received_at?->toISOString(),
            'received_office' => $this->receivedOfficePayload(),
            // #5 Estimated duration (snapshot of destination sla_minutes)
            'duration_estimated_minutes' => $estimated,
            'sla_minutes_snapshot' => $estimated,
            // #6 Actual send→receive time + breach flag
            'sla_actual_minutes' => $actual,
            'is_pending' => $this->received_at === null,
            'is_breached' => $actual !== null && $actual > $estimated,
            'attachments' => TransactionAttachmentResource::collection($this->whenLoaded('attachments')),
        ];
    }

    /**
     * User payload for history From/To User cells: identity + roles.
     * Roles render as colored chips in the same column on the frontend.
     */
    private function userPayload($user): ?array
    {
        if (!$user) return null;

        $roles = [];
        if ($user->relationLoaded('roles')) {
            $roles = $user->roles->map(fn ($r) => ['id' => $r->id, 'code' => $r->code, 'name' => $r->name])->values()->all();
        }

        return array_merge(
            $user->only(['id', 'name', 'email']),
            ['roles' => $roles],
        );
    }

    /**
     * Receipt office: end-user stations and blank assignments follow the
     * transaction's Originating Office. Assigned stations keep the office
     * snapshot stored on the run, so later workflow edits don't rewrite
     * history.
     */
    private function receivedOfficePayload(): ?array
    {
        if ($this->transaction && $this->toStep) {
            if (
                $this->transaction->stepIsEndUser($this->toStep)
                || $this->toStep->office_id === null
            ) {
                return Office::mini($this->transaction->office);
            }
        }

        return Office::mini($this->receivedOffice);
    }

    /**
     * History display payload: (Step N) Office, Roles.
     * Keeps code/name for tooltips but the frontend renders number + office + roles only.
     */
    private function stepPayload($step): ?array
    {
        if (!$step) return null;

        $office = null;
        if ($this->transaction) {
            $office = Office::mini($this->transaction->displayStepOffice($step));
        } elseif ($step->relationLoaded('office') || $step->office_id) {
            $office = Office::mini($step->office);
        }

        $roles = [];
        if ($step->relationLoaded('roles')) {
            $roles = $step->roles->map(fn ($r) => ['id' => $r->id, 'code' => $r->code, 'name' => $r->name])->values()->all();
        }

        return array_merge(
            $step->only(['id', 'code', 'name', 'stage', 'order_number']),
            ['office' => $office, 'roles' => $roles],
        );
    }
}
