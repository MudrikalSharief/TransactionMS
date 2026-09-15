<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class WorkflowRouteResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'from_step_id' => $this->from_step_id,
            'to_step_id' => $this->to_step_id,
            'action_code' => $this->action_code,
            'is_return_route' => (bool) $this->is_return_route,
            'condition_expression' => $this->condition_expression,
            'route_group' => $this->route_group,
            'required_approvals_count' => $this->required_approvals_count,
        ];
    }
}
