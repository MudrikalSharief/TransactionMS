<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionListResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

/**
 * Read-only tracking for viewer accounts, progress and movement only.
 * Deliberately returns no attachments, field values, remarks or staff names.
 *
 * What a viewer can see: any transaction matching a keyword they type
 * (reference number, title, transaction type or office), tracking only.
 * Who created it is never shown unless it is the viewer's own.
 */
class ViewerTrackingController extends Controller
{
    public function index(Request $request)
    {
        $data = $request->validate([
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);
        $perPage = (int) ($data['per_page'] ?? 25);
        $q = trim($data['q'] ?? '');
        $userId = $request->user()->id;

        $query = Transaction::query()
            // No keyword: only the viewer's own. A keyword searches everything.
            ->when($q === '', fn ($w) => $w->where('transactions.created_by', $userId))
            ->with([
                'type:id,code,name',
                'office:id,code,name',
                'workflow.steps.office:id,code,name',
                'state.currentStep.office:id,code,name',
                'creator:id,name,email',
            ])
            ->latest();

        if ($q !== '') {
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
        // Any transaction can be tracked (it is reachable by keyword anyway);
        // the payload below carries tracking only.
        $isOwner = (int) $transaction->created_by === (int) $request->user()->id;

        $transaction->load([
            'type:id,code,name',
            'office:id,code,name',
            'workflow.steps.office:id,code,name',
            'state.currentStep.office:id,code,name',
            'creator:id,name,email',
            'runs.fromStep.office:id,code,name',
            'runs.toStep.office:id,code,name',
            'runs.receivedOffice:id,code,name',
        ]);

        $summary = (new TransactionListResource($transaction))->resolve($request);

        $step = fn ($s) => $s ? [
            'id' => $s->id,
            'code' => $s->code,
            'name' => $s->name,
            'office' => $transaction->displayStepOffice($s)?->only(['id', 'code', 'name']),
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
                'received_office' => $r->receivedOffice?->only(['id', 'code', 'name']),
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
