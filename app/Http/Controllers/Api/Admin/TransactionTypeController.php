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
            TransactionType::query()->with('offices')->orderBy('name')->get()
        );
    }

    public function store(StoreTransactionTypeRequest $request, AuditService $audit)
    {
        $validated = $request->validated();
        $officeIds = $validated['office_ids'] ?? null;
        unset($validated['office_ids']);

        $type = TransactionType::create($validated);

        if (is_array($officeIds)) {
            $type->offices()->sync($officeIds);
        }

        $audit->log($request, 'transaction_types.create', $type, [
            'payload' => $request->validated(),
        ]);

        return (new TransactionTypeResource($type->load('offices')))->response()->setStatusCode(201);
    }

    public function update(UpdateTransactionTypeRequest $request, TransactionType $transactionType, AuditService $audit)
    {
        $before = $transactionType->only(['code', 'name', 'description', 'is_active']);
        $before['office_ids'] = $transactionType->offices()->pluck('offices.id')->values()->all();

        $validated = $request->validated();
        $officeIds = $validated['office_ids'] ?? null;
        unset($validated['office_ids']);

        $transactionType->update($validated);

        if (is_array($officeIds)) {
            $transactionType->offices()->sync($officeIds);
        }

        $audit->log($request, 'transaction_types.update', $transactionType, [
            'before' => $before,
            'after' => array_merge($transactionType->only(['code', 'name', 'description', 'is_active']), [
                'office_ids' => $transactionType->offices()->pluck('offices.id')->values()->all(),
            ]),
        ]);

        return new TransactionTypeResource($transactionType->load('offices'));
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
