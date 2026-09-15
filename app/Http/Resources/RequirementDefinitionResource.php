<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class RequirementDefinitionResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'workflow_definition_id' => $this->workflow_definition_id,
            'order_number' => $this->order_number,
            'code' => $this->code,
            'name' => $this->name,
            'description' => $this->description,
            'is_active' => (bool) $this->is_active,
            'steps' => $this->whenLoaded('steps', function () {
                return $this->steps->map(function ($s) {
                    return array_merge(
                        $s->only(['id', 'order_number', 'code', 'name']),
                        [
                            'pivot_meta' => [
                                'display_order' => (int) ($s->pivot?->display_order ?? 0),
                                'is_required' => (bool) ($s->pivot?->is_required ?? true),
                            ],
                        ]
                    );
                })->values();
            }),
        ];
    }
}
