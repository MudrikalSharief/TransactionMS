<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Office;
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
            'username' => $this->username,
            'email' => $this->email,
            'office_id' => $this->office_id,
            'office' => $this->whenLoaded('office', function () {
                return Office::mini($this->office);
            }),
            'contact_number' => $this->Contact_number,
            'is_active' => (bool) $this->is_active,
            // Signed up on the login page and waiting for an admin.
            'pending_approval' => $this->approved_at === null,
            'roles' => $roles,
            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
