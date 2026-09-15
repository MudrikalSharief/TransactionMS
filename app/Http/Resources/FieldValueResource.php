<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FieldValueResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'field_definition_id' => $this->field_definition_id,
            'value_json' => $this->value_json,
            'value_text' => $this->value_text,
            'updated_at' => optional($this->updated_at)?->toISOString(),
        ];
    }
}
