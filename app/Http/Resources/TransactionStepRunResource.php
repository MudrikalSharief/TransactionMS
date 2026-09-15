<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionStepRunResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'from_step' => $this->fromStep?->only(['id','code','name','stage']),
            'to_step' => $this->toStep?->only(['id','code','name','stage']),
            'action_code' => $this->action_code,
            'remarks' => $this->remarks,
            'performed_by' => $this->performer?->only(['id','name','email']),
            'performed_at' => $this->performed_at?->toISOString(),
        ];
    }
}
