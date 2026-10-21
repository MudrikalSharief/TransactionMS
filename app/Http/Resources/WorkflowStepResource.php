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
            'office_id' => $this->office_id,
            'office' => $this->whenLoaded('office', fn () => $this->office ? [
                'id' => $this->office->id,
                'code' => $this->office->code,
                'name' => $this->office->name,
            ] : null),
            'sla_minutes' => $this->sla_minutes,
            'step_data_count' => $this->whenCounted('stepDataDefinitions'),
            'is_start' => (bool) $this->is_start,
            'is_end' => (bool) $this->is_end,
            'is_end_user' => (bool) $this->is_end_user,
            'role_ids' => $this->whenLoaded('roles', fn () => $this->roles->pluck('id')->values()),
            'roles' => $this->whenLoaded('roles', fn () => $this->roles->map(fn ($r) => [
                'id' => $r->id,
                'code' => $r->code,
                'name' => $r->name,
            ])->values()),
        ];
    }
}
