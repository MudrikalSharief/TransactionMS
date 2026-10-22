<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreRoleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; 
    }

    public function rules(): array
    {
        return [
            // Only live roles count as taken: a deleted role's code is
            // brought back by the controller instead of blocking it.
            'code' => ['required', 'string', 'max:50', 'regex:/^[a-z0-9_]+$/', Rule::unique('roles', 'code')->whereNull('deleted_at')],
            'name' => ['required', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
