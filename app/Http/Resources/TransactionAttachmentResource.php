<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionAttachmentResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'transaction_id' => $this->transaction_id,
            'workflow_step_id' => $this->workflow_step_id,
            'step' => $this->whenLoaded('step', fn () => $this->step?->only(['id', 'code', 'name'])),
            'requirement_definition_id' => $this->requirement_definition_id,
            'requirement' => $this->whenLoaded('requirement', fn () => $this->requirement?->only(['id', 'code', 'name'])),
            'step_run_id' => $this->step_run_id,
            'origin' => $this->requirement_definition_id ? 'check' : 'proceed',
            'original_name' => $this->original_name,
            'mime' => $this->mime,
            'size_bytes' => (int) $this->size_bytes,
            'uploaded_by' => $this->whenLoaded('uploader', fn () => $this->uploader?->only(['id', 'name'])),
            'created_at' => $this->created_at?->toISOString(),
            'download_url' => url("/api/transactions/{$this->transaction_id}/attachments/{$this->id}/download"),
        ];
    }
}
