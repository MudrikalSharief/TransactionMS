<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class WorkflowStepResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'workflow_definition_id' => $this->workflow_definition_id,
            'parent_id' => $this->parent_id,
            'order_number' => $this->order_number,
            'code' => $this->code,
            'name' => $this->name,
            'stage' => $this->stage,
            'sla_minutes' => $this->sla_minutes,
            'is_start' => (bool) $this->is_start,
            'is_end' => (bool) $this->is_end,
            'role_ids' => $this->whenLoaded('roles', fn () => $this->roles->pluck('id')->values()),
        ];
    }
}
