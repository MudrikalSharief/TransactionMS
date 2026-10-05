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
        // Static lookup fetched on almost every page (create dialogs, filters):
        // 10min server cache + frontend localStorage cache = 1 tiny hit.
        $items = \Illuminate\Support\Facades\Cache::remember(
            'lookup:transaction-types',
            600,
            fn () => TransactionType::query()->with('offices')->orderBy('name')->get()
        );

        return TransactionTypeResource::collection($items);
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

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types');

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

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types');

        return new TransactionTypeResource($transactionType->load('offices'));
    }

    public function destroy(Request $request, TransactionType $transactionType, AuditService $audit)
    {
        $transactionType->delete();

        $audit->log($request, 'transaction_types.delete', $transactionType, [
            'note' => 'Soft deleted transaction type',
        ]);

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types');

        return response()->json(['message' => 'Deleted.']);
    }
}
