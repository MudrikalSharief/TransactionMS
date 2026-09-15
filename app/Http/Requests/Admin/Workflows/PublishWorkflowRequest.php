<?php

namespace App\Http\Requests\Admin\Workflows;

use Illuminate\Foundation\Http\FormRequest;

class PublishWorkflowRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'notes' => ['nullable', 'string', 'max:5000'],
        ];
    }
}
