<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class SyncRolePermissionsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'permission_codes' => ['present', 'array'],
            'permission_codes.*' => ['string', 'exists:permissions,code'],
        ];
    }
}
