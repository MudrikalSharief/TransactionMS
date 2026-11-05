<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionListResource;
use App\Models\Transaction;
use App\Services\AuditService;
use Carbon\Carbon;
use Illuminate\Http\Request;

/**
 * Superadmin-only archive. Archiving is an alternative to deleting a
 * transaction: the row, its files and its full history stay in the database,
 * but it leaves every operational queue and becomes view-only.
 */
class TransactionArchiveController extends Controller
{
    public function index(Request $request)
    {
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
            'transaction_type_id' => ['nullable', 'integer', 'exists:transaction_types,id'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
            'date_from' => ['nullable', 'date_format:Y-m-d'],
            'date_to' => ['nullable', 'date_format:Y-m-d'],
        ]);

        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');

        $query = Transaction::query()
            ->archived()
            ->with([
                'type:id,code,name',
                'office:id,code,name,icon_path',
                'workflow.steps.office:id,code,name,icon_path',
                'workflow.stepRoles.role',
                'state.currentStep.office:id,code,name,icon_path',
                'creator:id,name,email',
            ])
            ->latest();

        if ($q !== '') {
            $query->where(function ($w) use ($q) {
                $w->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('title', 'like', "%{$q}%");
            });
        }

        if (!empty($data['transaction_type_id'])) {
            $query->where('transaction_type_id', (int) $data['transaction_type_id']);
        }

        if (!empty($data['office_id'])) {
            $query->where('office_id', (int) $data['office_id']);
        }

        if (!empty($data['date_from'])) {
            $query->where(
                'created_at',
                '>=',
                Carbon::createFromFormat('Y-m-d', $data['date_from'], 'Asia/Manila')
                    ->startOfDay()
                    ->utc()
            );
        }

        if (!empty($data['date_to'])) {
            $query->where(
                'created_at',
                '<=',
                Carbon::createFromFormat('Y-m-d', $data['date_to'], 'Asia/Manila')
                    ->endOfDay()
                    ->utc()
            );
        }

        return TransactionListResource::collection($query->paginate($perPage));
    }

    public function store(Request $request, Transaction $transaction, AuditService $audit)
    {
        if ((bool) $transaction->is_archive) {
            return response()->json([
                'message' => 'Transaction is already archived.',
                'data' => [
                    'id' => $transaction->id,
                    'is_archive' => true,
                ],
            ]);
        }

        $wasDone = (bool) $transaction->is_done;

        $transaction->is_archive = true;
        $transaction->save();

        $audit->log($request, 'transactions.archive', $transaction, [
            'was_done' => $wasDone,
            'note' => 'Archived instead of deleted; record and history kept.',
        ]);

        return response()->json([
            'message' => 'Transaction archived.',
            'data' => [
                'id' => $transaction->id,
                'is_archive' => true,
            ],
        ]);
    }

    public function unarchive(Request $request, Transaction $transaction, AuditService $audit)
    {
        if (!(bool) $transaction->is_archive) {
            return response()->json([
                'message' => 'Transaction is already active.',
                'data' => [
                    'id' => $transaction->id,
                    'is_archive' => false,
                ],
            ]);
        }

        $transaction->is_archive = false;
        $transaction->save();

        $audit->log($request, 'transactions.unarchive', $transaction, [
            'note' => 'Restored to the active transaction lists; record and history unchanged.',
        ]);

        return response()->json([
            'message' => 'Transaction unarchived.',
            'data' => [
                'id' => $transaction->id,
                'is_archive' => false,
            ],
        ]);
    }
}
