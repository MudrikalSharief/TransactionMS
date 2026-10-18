<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionListResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

/**
 * Read-only tracking for viewer accounts: only transactions the viewer
 * created, progress and movement only. Deliberately returns no
 * attachments, field values, remarks or staff names.
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

        $query = Transaction::query()
            ->where('transactions.created_by', $request->user()->id)
            ->with([
                'type:id,code,name',
                'office:id,code,name',
                'workflow.steps.office:id,code,name',
                'state.currentStep.office:id,code,name',
                'creator:id,name,email',
            ])
            ->latest();

        if ($q !== '') {
            $query->where(function ($w) use ($q) {
                $w->where('reference_number', 'like', "%{$q}%")
                    ->orWhere('title', 'like', "%{$q}%");
            });
        }

        return TransactionListResource::collection($query->paginate($perPage));
    }

    public function show(Request $request, Transaction $transaction, RoutingEngine $routing)
    {
        // 404 (not 403) so other people's transactions are not discoverable.
        abort_unless((int) $transaction->created_by === (int) $request->user()->id, 404);

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
                'status' => $transaction->is_done ? 'completed' : 'in_process',
                'updated_at' => $transaction->updated_at?->toISOString(),
                'history' => $history,
                'visited_step_ids' => $routing->visitedStepIds($transaction),
            ]),
        ]);
    }
}
