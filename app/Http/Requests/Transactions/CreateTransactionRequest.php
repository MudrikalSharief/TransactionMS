<?php

namespace App\Http\Requests\Transactions;

use App\Models\TransactionType;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;

class CreateTransactionRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'transaction_type_id' => ['required', 'integer', 'exists:transaction_types,id'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'title' => ['nullable', 'string', 'max:200'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                if ($validator->errors()->has('transaction_type_id')) return;

                $typeId = $this->input('transaction_type_id');
                if (!$typeId) return;

                $type = TransactionType::with('offices')->find($typeId);
                if (!$type) return;

                $officeId = $this->user()?->office_id;
                if ($type->offices->isNotEmpty() && !$type->offices->contains('id', $officeId)) {
                    $validator->errors()->add(
                        'transaction_type_id',
                        'Your office is not allowed to create this transaction type.'
                    );
                }
            },
        ];
    }
}
