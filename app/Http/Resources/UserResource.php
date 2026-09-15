<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\RoleResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $roles = $this->whenLoaded('roles', function () {
            return RoleResource::collection($this->roles);
        });

        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'office_id' => $this->office_id,
            'office' => $this->whenLoaded('office', function () {
                return $this->office ? [
                    'id' => $this->office->id,
                    'code' => $this->office->code,
                    'name' => $this->office->name,
                ] : null;
            }),
            'is_active' => (bool) $this->is_active,
            'roles' => $roles,
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
