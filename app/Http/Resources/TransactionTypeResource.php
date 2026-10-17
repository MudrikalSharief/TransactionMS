<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

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
            ])->values()),
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
