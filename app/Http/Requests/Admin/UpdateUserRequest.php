<?php

namespace App\Http\Requests\Admin;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    // Only touch the username when the form sends one (blank generates one).
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
        $officeId = $this->exists('office_id') ? $this->input('office_id') : $this->route('user')?->office_id;

        return [
            'name' => ['required', 'string', 'max:120'],
            'position' => ['nullable', 'string', 'max:120'],
            'username' => User::usernameRules(false, $userId),
            'email' => ['nullable', 'email', 'max:190', 'unique:users,email,' . $userId],
            'password' => ['nullable', 'string', 'min:8'],
            'contact_number' => ['nullable', 'string', 'max:20', 'regex:/^\+?[0-9][0-9\s\-()]{6,18}$/'],
            'is_active' => ['sometimes', 'boolean'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', Role::assignmentRule($officeId ? (int) $officeId : null)],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator) {
            if (!$this->exists('office_id') || $this->exists('role_ids') || $validator->errors()->isNotEmpty()) {
                return;
            }
            // Include deleted roles: restoring one must not give a transferred
            // member a role from their previous office.
            $roles = $this->route('user')->roles()->withTrashed()->whereNotNull('roles.office_id');
            $officeId = (int) $this->input('office_id');
            if ($officeId > 0) {
                $roles->where('roles.office_id', '!=', $officeId);
            }
            if ($roles->exists()) {
                $validator->errors()->add('role_ids', 'Remove roles belonging to another office before transferring this account.');
            }
        });
    }
}
