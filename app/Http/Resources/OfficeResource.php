<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class OfficeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'code' => $this->code,
            'name' => $this->name,
            'description' => $this->description,
            'icon_path' => $this->icon_path,
            'icon_url' => $this->icon_path
                ? Storage::disk('public')->url($this->icon_path)
                : null,
            'is_active' => (bool) $this->is_active,
            'users_count' => $this->whenCounted('users'),
            'steps_count' => $this->whenCounted('steps'),
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
