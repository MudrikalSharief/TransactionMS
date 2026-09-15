<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $userId = $this->route('user')?->id;

        return [
            'name' => ['required', 'string', 'max:120'],
            'email' => ['required', 'email', 'max:190', 'unique:users,email,' . $userId],
            'password' => ['nullable', 'string', 'min:8'],
            'is_active' => ['sometimes', 'boolean'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', 'exists:roles,id'],
        ];
    }
}
