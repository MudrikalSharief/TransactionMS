<?php

namespace App\Http\Requests\Admin;

use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    // Only touch the username when the form sends one (blank clears it).
    protected function prepareForValidation(): void
    {
        if ($this->has('username')) {
            $this->merge(['username' => User::normalizeUsername($this->input('username'))]);
        }
    }

    public function messages(): array
    {
        return User::USERNAME_MESSAGES;
    }

    public function rules(): array
    {
        $userId = $this->route('user')?->id;

        return [
            'name' => ['required', 'string', 'max:120'],
            'username' => User::usernameRules(false, $userId),
            'email' => ['required', 'email', 'max:190', 'unique:users,email,' . $userId],
            'password' => ['nullable', 'string', 'min:8'],
            'contact_number' => ['nullable', 'string', 'max:20', 'regex:/^\+?[0-9][0-9\s\-()]{6,18}$/'],
            'is_active' => ['sometimes', 'boolean'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', 'exists:roles,id'],
        ];
    }
}
