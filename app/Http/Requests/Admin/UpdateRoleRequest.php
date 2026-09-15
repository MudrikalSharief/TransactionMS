<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRoleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $roleId = $this->route('role')?->id;

        return [
            'code' => ['required', 'string', 'max:50', 'regex:/^[a-z0-9_]+$/', 'unique:roles,code,' . $roleId],
            'name' => ['required', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
