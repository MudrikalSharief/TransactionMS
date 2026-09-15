<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; 
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:120'],
            'email' => ['required', 'email', 'max:190', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'is_active' => ['sometimes', 'boolean'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', 'exists:roles,id'],
        ];
    }
}
