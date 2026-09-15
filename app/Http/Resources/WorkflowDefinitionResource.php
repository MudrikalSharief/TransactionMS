<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class WorkflowDefinitionResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'transaction_type_id' => $this->transaction_type_id,
            'version' => $this->version,
            'status' => $this->status,
            'name' => $this->name,
            'notes' => $this->notes,
            'published_at' => $this->published_at?->toISOString(),
            'published_by' => $this->published_by,
            'steps' => WorkflowStepResource::collection($this->whenLoaded('steps')),
            'routes' => WorkflowRouteResource::collection($this->whenLoaded('routes')),
        ];
    }
}
