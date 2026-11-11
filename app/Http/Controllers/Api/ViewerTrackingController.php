<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionListResource;
use App\Models\Transaction;
use App\Models\Office;
use App\Services\RoutingEngine;
use Carbon\Carbon;
use Illuminate\Http\Request;

/**
 * Read-only tracking for viewer accounts, progress and movement only.
 * Deliberately returns no attachments, field values, remarks or staff names.
 *
 * What a viewer can see: their own transactions, plus transactions the
 * superadmin or office admin has marked searchable for Track (is_private).
 * Tracking only. Who created it is never shown unless it is the viewer's own.
 */
class ViewerTrackingController extends Controller
{
    public function index(Request $request)
    {
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
            'status' => ['nullable', 'in:completed,in_process'],
            // Date filter on the created date, in Manila time: a year, a month
            // of a year, or a month in any year.
            'month' => ['nullable', 'integer', 'between:1,12'],
            'year' => ['nullable', 'integer', 'between:2000,2100'],
        ]);
        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');
        $userId = $request->user()->id;

        $query = Transaction::query()
            // Archived transactions leave Track entirely: they are hidden
            // from the normal list, keyword search and direct detail opens.
            ->where('transactions.is_archive', false)
            // No keyword: only the viewer's own active transactions. A keyword
            // searches their own rows plus rows shared for Track search.
            ->when($q === '', fn ($w) => $w->where('transactions.created_by', $userId))
            ->when(isset($data['status']), fn ($w) => $w->where('transactions.is_done', $data['status'] === 'completed'))
            ->with([
                'type:id,code,name',
                'office:id,code,name,icon_path',
                'workflow.steps.office:id,code,name,icon_path',
                'state.currentStep.office:id,code,name,icon_path',
                'creator:id,name,email',
            ])
            ->latest();

        if (!empty($data['year'])) {
            $from = Carbon::create((int) $data['year'], (int) ($data['month'] ?? 1), 1, 0, 0, 0, 'Asia/Manila');
            $to = empty($data['month']) ? $from->copy()->addYear() : $from->copy()->addMonthNoOverflow();
            $query->where('transactions.created_at', '>=', $from->copy()->utc())
                ->where('transactions.created_at', '<', $to->copy()->utc());
        } elseif (!empty($data['month'])) {
            // Stored in UTC; Manila is a fixed +08:00 (no daylight saving).
            $query->whereRaw(
                "MONTH(CONVERT_TZ(transactions.created_at, '+00:00', '+08:00')) = ?",
                [(int) $data['month']]
            );
        }

        if ($q !== '') {
            // Owners keep access to their own rows; everyone else needs the
            // admin's Track-visibility toggle.
            $query->where(function ($w) use ($userId) {
                $w->where('transactions.created_by', $userId)
                    ->orWhere('transactions.is_private', true);
            });

            // Treat % and _ as plain characters, not wildcards.
            $like = '%' . addcslashes($q, '%_\\') . '%';
            $query->where(function ($w) use ($like) {
                $w->where('transactions.reference_number', 'like', $like)
                    ->orWhere('transactions.title', 'like', $like)
                    ->orWhereHas('type', fn ($t) => $t->where('name', 'like', $like))
                    ->orWhereHas('office', fn ($o) => $o->where('name', 'like', $like)->orWhere('code', 'like', $like));
            });
        }

        $payload = TransactionListResource::collection($query->paginate($perPage))
            ->response()
            ->getData(true);

        // Never reveal who created someone else's transaction.
        $payload['data'] = array_map(
            fn ($row) => (int) ($row['created_by']['id'] ?? 0) === (int) $userId
                ? $row
                : array_merge($row, ['created_by' => null]),
            $payload['data'] ?? []
        );

        return response()->json($payload);
    }

    public function show(Request $request, Transaction $transaction, RoutingEngine $routing)
    {
        // Archived rows are not part of Track, even by direct URL. 404 avoids
        // revealing that the record exists.
        if ((bool) $transaction->is_archive) {
            abort(404);
        }

        // Owners may always track their own rows; everyone else needs the
        // superadmin's Track-visibility toggle. 404 avoids leaking existence.
        $isOwner = (int) $transaction->created_by === (int) $request->user()->id;
        if (!$isOwner && !(bool) $transaction->is_private) {
            abort(404);
        }

        $transaction->load([
            'type:id,code,name',
            'office:id,code,name,icon_path',
            'workflow.steps.office:id,code,name,icon_path',
            'state.currentStep.office:id,code,name,icon_path',
            'creator:id,name,email',
            'runs.fromStep.office:id,code,name,icon_path',
            'runs.toStep.office:id,code,name,icon_path',
            'runs.receivedOffice:id,code,name,icon_path',
        ]);

        $summary = (new TransactionListResource($transaction))->resolve($request);

        $step = fn ($s) => $s ? [
            'id' => $s->id,
            'code' => $s->code,
            'name' => $s->name,
            'office' => Office::mini($transaction->displayStepOffice($s)),
        ] : null;

        $history = $transaction->runs
            ->sortBy(fn ($r) => sprintf('%s-%010d', $r->performed_at?->format('YmdHis') ?? '0', $r->id))
            ->map(fn ($r) => [
                'id' => $r->id,
                'is_creation' => $r->from_step_id !== null && (int) $r->from_step_id === (int) $r->to_step_id,
                'action_code' => $r->action_code,
                'from_step' => $step($r->fromStep),
                'to_step' => $step($r->toStep),
                'performed_at' => $r->performed_at?->toISOString(),
                'received_at' => $r->received_at?->toISOString(),
                'received_office' => Office::mini($r->receivedOffice),
            ])
            ->values();

        return response()->json([
            'data' => array_merge($summary, [
                'created_by' => $isOwner ? ($summary['created_by'] ?? null) : null,
                'status' => $transaction->is_done ? 'completed' : 'in_process',
                'updated_at' => $transaction->updated_at?->toISOString(),
                'history' => $history,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ]),
        ]);
    }
}
