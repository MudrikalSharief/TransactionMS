<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    // Keep the existing payload key, but accept a username only.
    public function rules(): array
    {
        return [
            'login' => ['required', 'string', 'min:3', 'max:30', 'regex:/^[a-zA-Z0-9](?:[a-zA-Z0-9._]*[a-zA-Z0-9])?$/'],
            'password' => ['required', 'string'],
            'remember' => ['sometimes', 'boolean'],
        ];
    }

    public function messages(): array
    {
        return [
            'login.required' => 'Enter your username.',
            'login.regex' => 'Enter your username, using letters, numbers, dots or underscores.',
        ];
    }

    protected function prepareForValidation(): void
    {
        if (is_string($this->input('login'))) {
            $this->merge(['login' => trim($this->input('login'))]);
        }
    }
}
