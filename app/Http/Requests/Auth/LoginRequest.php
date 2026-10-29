<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    // `login` is an email or a username; `email` is still accepted from
    // older callers.
    public function rules(): array
    {
        return [
            'login' => ['required_without:email', 'nullable', 'string', 'max:190'],
            'email' => ['required_without:login', 'nullable', 'string', 'max:190'],
            'password' => ['required', 'string'],
            'remember' => ['sometimes', 'boolean'],
        ];
    }

    public function messages(): array
    {
        return [
            'login.required_without' => 'Enter your username or email.',
            'email.required_without' => 'Enter your username or email.',
        ];
    }
}
