<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class TransactionTypeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'code' => $this->code,
            'name' => $this->name,
            'description' => $this->description,
            'is_active' => (bool) $this->is_active,
            'office_ids' => $this->whenLoaded('offices', fn () => $this->offices->pluck('id')->values()),
            'offices' => $this->whenLoaded('offices', fn () => $this->offices->map(fn ($o) => [
                'id' => $o->id,
                'code' => $o->code,
                'name' => $o->name,
                'icon_url' => $o->icon_path
                    ? Storage::disk('public')->url($o->icon_path)
                    : null,
            ])->values()),
            // Ordered steps of the published workflow this type follows, for
            // the New Transaction dialog's flow preview. Only present when the
            // caller eager-loaded the relation (the lookup index does).
            'workflow_steps' => $this->when(
                $this->relationLoaded('liveWorkflow'),
                fn () => collect($this->liveWorkflow?->steps ?? [])
                    ->sortBy(fn ($s) => [(int) ($s->order_number ?? 0), (int) $s->id])
                    ->values()
                    ->map(fn ($s) => [
                        'id' => $s->id,
                        'order_number' => (int) $s->order_number,
                        'name' => $s->name,
                        'code' => $s->code,
                        'is_start' => (bool) $s->is_start,
                        'is_end' => (bool) $s->is_end,
                        'is_end_user' => (bool) $s->is_end_user,
                        'office' => $s->relationLoaded('office') && $s->office ? [
                            'id' => $s->office->id,
                            'code' => $s->office->code,
                            'name' => $s->office->name,
                        ] : null,
                    ])
                    ->all()
            ),
            'createdby_office' => $this->whenLoaded('createdByOffice', fn () => $this->createdByOffice ? [
                'id' => $this->createdByOffice->id,
                'code' => $this->createdByOffice->code,
                'name' => $this->createdByOffice->name,
            ] : null),
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
