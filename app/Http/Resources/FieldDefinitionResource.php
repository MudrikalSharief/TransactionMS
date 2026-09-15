<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FieldDefinitionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $pivot = $this->pivot;

        return [
            'id' => $this->id,
            'workflow_definition_id' => $this->workflow_definition_id,
            'order_number' => $this->order_number,
            'code' => $this->code,
            'name' => $this->name,
            'type' => $this->type,
            'group' => $this->group,
            'display_order' => $pivot?->display_order ?? $this->display_order,
            'required' => $pivot?->required_override ?? $this->required,
            'unique' => $this->unique,
            'sensitive' => $this->sensitive,
            'min_length' => $this->min_length,
            'max_length' => $this->max_length,
            'min_value' => $this->min_value,
            'max_value' => $this->max_value,
            'options' => $this->options,
            'validation_rules' => $this->validation_rules,
        ];
    }
}
