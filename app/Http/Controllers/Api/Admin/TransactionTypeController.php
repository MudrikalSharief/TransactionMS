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
    public function index(Request $request)
    {
        // Static lookup fetched on almost every page (create dialogs, filters):
        // 10min server cache + frontend localStorage cache = 1 tiny hit. The
        // cache holds the full catalog; per-user office filtering happens here
        // so the cache stays single-key and never leaks other offices' types.
        $items = \Illuminate\Support\Facades\Cache::remember(
            'lookup:transaction-types:v2',
            600,
            fn () => TransactionType::query()
                ->with([
                    'offices',
                    'liveWorkflow.steps' => fn ($q) => $q->orderBy('order_number')->orderBy('id'),
                    'liveWorkflow.steps.office',
                ])
                ->orderBy('name')
                ->get()
        );

        $user = $request->user();
        if ($user && !$user->hasRole('superadmin')) {
            $officeId = $user->office_id !== null ? (int) $user->office_id : null;
            $items = $items
                ->filter(fn (TransactionType $type) => $type->offices->isEmpty()
                    || ($officeId !== null && $type->offices->contains('id', $officeId)))
                ->values();
        }

        return TransactionTypeResource::collection($items);
    }

    public function store(StoreTransactionTypeRequest $request, AuditService $audit)
    {
        $validated = $request->validated();
        $officeIds = $validated['office_ids'] ?? [];
        unset($validated['office_ids']);

        $user = $request->user();
        if (!$user->hasRole('superadmin')) {
            $officeIds = array_map('intval', $officeIds);
            if (!in_array((int) $user->office_id, $officeIds, true)) {
                $officeIds[] = (int) $user->office_id;
            }
        }

        $type = TransactionType::create($validated);

        if ($officeIds) {
            $type->offices()->sync($officeIds);
        }

        $audit->log($request, 'transaction_types.create', $type, [
            'payload' => $request->validated(),
        ]);

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types:v2');

        return (new TransactionTypeResource($type->load('offices')))->response()->setStatusCode(201);
    }

    public function update(UpdateTransactionTypeRequest $request, TransactionType $transactionType, AuditService $audit)
    {
        $user = $request->user();
        if (!$user->hasRole('superadmin')) {
            if (!$this->assignedToUserOffice($transactionType, $user)) {
                return response()->json(['message' => 'Forbidden.'], 403);
            }
        }

        $before = $transactionType->only(['code', 'name', 'description', 'is_active']);
        $before['office_ids'] = $transactionType->offices()->pluck('offices.id')->values()->all();

        $validated = $request->validated();
        $officeIds = $validated['office_ids'] ?? null;
        unset($validated['office_ids']);

        if (is_array($officeIds) && !$user->hasRole('superadmin')) {
            $officeIds = array_map('intval', $officeIds);
            if (!in_array((int) $user->office_id, $officeIds, true)) {
                $officeIds[] = (int) $user->office_id;
            }
        }

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

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types:v2');

        return new TransactionTypeResource($transactionType->load('offices'));
    }

    public function destroy(Request $request, TransactionType $transactionType, AuditService $audit)
    {
        $user = $request->user();
        if (!$user->hasRole('superadmin') && !$this->assignedToUserOffice($transactionType, $user)) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $transactionType->delete();

        $audit->log($request, 'transaction_types.delete', $transactionType, [
            'note' => 'Soft deleted transaction type',
        ]);

        \Illuminate\Support\Facades\Cache::forget('lookup:transaction-types:v2');

        return response()->json(['message' => 'Deleted.']);
    }

    private function assignedToUserOffice(TransactionType $type, $user): bool
    {
        if ($user->office_id === null) {
            return false;
        }

        return $type->offices()
            ->where('offices.id', $user->office_id)
            ->exists();
    }
}
