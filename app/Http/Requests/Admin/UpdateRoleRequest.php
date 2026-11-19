<?php

namespace App\Http\Requests\Admin;

use App\Models\Role;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateRoleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $roleId = $this->route('role')?->id;
        $codeRules = ['required', 'string', 'max:50', 'regex:/^[a-z0-9_]+$/', 'unique:roles,code,' . $roleId];
        if ($this->user()->isOfficeAdmin()) {
            $codeRules[] = Rule::notIn(Role::HIERARCHY);
        }

        return [
            'code' => $codeRules,
            'name' => ['required', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
