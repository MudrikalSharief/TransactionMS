<?php

namespace App\Http\Requests\Admin;

use App\Models\Role;
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
        $codeRules = ['required', 'string', 'max:50', 'regex:/^[a-z0-9_]+$/', Rule::unique('roles', 'code')->whereNull('deleted_at')];
        if ($this->user()->isOfficeAdmin()) {
            $codeRules[] = Rule::notIn(Role::HIERARCHY);
            $codeRules[] = function ($attribute, $value, $fail) {
                if (!is_string($value)) {
                    return;
                }
                $trashed = Role::onlyTrashed()->where('code', $value)->first();
                if ($trashed && !$trashed->canBeManagedBy($this->user())) {
                    $fail('That role code is reserved. Choose a different code for your office.');
                }
            };
        }

        return [
            // Only live roles count as taken: a deleted role's code is
            // brought back by the controller instead of blocking it.
            'code' => $codeRules,
            'name' => ['required', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:1000'],
        ];
    }
}
