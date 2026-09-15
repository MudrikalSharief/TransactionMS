<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreTransactionTypeRequest;
use App\Http\Requests\Admin\UpdateTransactionTypeRequest;
use App\Http\Resources\TransactionTypeResource;
use App\Models\TransactionType;
use App\Services\AuditService;
use Illuminate\Http\Request;

class TransactionTypeController extends Controller
{
    public function index()
    {
        return TransactionTypeResource::collection(
            TransactionType::query()->orderBy('name')->get()
        );
    }

    public function store(StoreTransactionTypeRequest $request, AuditService $audit)
    {
        $type = TransactionType::create($request->validated());

        $audit->log($request, 'transaction_types.create', $type, [
            'payload' => $request->validated(),
        ]);

        return (new TransactionTypeResource($type))->response()->setStatusCode(201);
    }

    public function update(UpdateTransactionTypeRequest $request, TransactionType $transactionType, AuditService $audit)
    {
        $before = $transactionType->only(['code', 'name', 'description', 'is_active']);

        $transactionType->update($request->validated());

        $audit->log($request, 'transaction_types.update', $transactionType, [
            'before' => $before,
            'after' => $transactionType->only(['code', 'name', 'description', 'is_active']),
        ]);

        return new TransactionTypeResource($transactionType);
    }

    public function destroy(Request $request, TransactionType $transactionType, AuditService $audit)
    {
        $transactionType->delete();

        $audit->log($request, 'transaction_types.delete', $transactionType, [
            'note' => 'Soft deleted transaction type',
        ]);

        return response()->json(['message' => 'Deleted.']);
    }
}
