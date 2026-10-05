<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Office;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;

/**
 * Dashboard "Transaction Summary" card (superadmin).
 *
 * Period: last week (default: the previous Mon–Sun calendar week) or a
 * calendar month, both in Manila time.
 * Completed counts by finalize date; everything else by created date.
 * Process/office filters narrow every count, except by_process, which
 * ignores the process filter so the card can fade unpicked processes.
 * office_code limits everything to one office by its code (the dashboard
 * sends the office its graph covers).
 *
 * The tile counts (__invoke) and the detail lists (details) share the same
 * queries below, so a list always has exactly as many rows as its tile.
 */
class DashboardSummaryController extends Controller
{
    private const TZ = 'Asia/Manila';
    private const CATEGORIES = ['completed', 'in_process', 'overdue', 'deleted', 'process'];

    private Carbon $from;
    private Carbon $to;
    private array $periodMeta;
    private array $processes = [];
    private array $offices = [];
    private ?int $officeId = null;

    public function __invoke(Request $request)
    {
        $this->resolveScope($request);

        $inProcess = $this->inProcess();

        $byProcess = $this->createdInPeriod($this->filtered(Transaction::query(), withProcess: false))
            ->join('transaction_types', 'transaction_types.id', '=', 'transactions.transaction_type_id')
            ->groupBy('transaction_types.id', 'transaction_types.name')
            ->selectRaw('transaction_types.id as id, transaction_types.name as name, COUNT(*) as count')
            ->orderByDesc('count')
            ->orderBy('transaction_types.name')
            ->get()
            ->map(fn ($row) => ['id' => (int) $row->id, 'name' => $row->name, 'count' => (int) $row->count])
            ->values();

        return response()->json([
            'period' => $this->periodMeta,
            'completed' => $this->completedQuery()->count(),
            'in_process' => $inProcess->count(),
            'overdue' => $inProcess->filter(fn ($tx) => $this->overdueMinutes($tx) > 0)->count(),
            'deleted' => $this->deletedQuery()->count(),
            'by_process' => $byProcess,
        ]);
    }

    /**
     * Detail list behind one tile (or one process bar, with process_id).
     */
    public function details(Request $request, string $category)
    {
        abort_unless(in_array($category, self::CATEGORIES, true), 404);
        $this->resolveScope($request, extra: [
            'process_id' => [$category === 'process' ? 'required' : 'nullable', 'integer'],
        ]);

        $rows = match ($category) {
            'completed' => $this->completedRows(),
            'in_process' => $this->openRows($this->inProcess())
                ->sortByDesc('waiting_minutes')->values(),
            'overdue' => $this->openRows($this->inProcess()->filter(fn ($tx) => $this->overdueMinutes($tx) > 0))
                ->sortByDesc('overdue_minutes')->values(),
            'deleted' => $this->deletedRows(),
            'process' => $this->processRows((int) $request->input('process_id')),
        };

        return response()->json([
            'category' => $category,
            'period' => $this->periodMeta,
            'count' => $rows->count(),
            'rows' => $rows,
        ]);
    }

    // ---- shared queries ---------------------------------------------------

    private function resolveScope(Request $request, array $extra = []): void
    {
        $data = $request->validate(array_merge([
            'month' => ['nullable', 'regex:/^\d{4}-(0[1-9]|1[0-2])$/'],
            'processes' => ['nullable', 'array'],
            'processes.*' => ['integer'],
            'offices' => ['nullable', 'array'],
            'offices.*' => ['integer'],
            'office_code' => ['nullable', 'string', 'max:50'],
        ], $extra));

        [$this->from, $this->to, $this->periodMeta] = $this->period($data['month'] ?? null);
        $this->processes = array_map('intval', $data['processes'] ?? []);
        $this->offices = array_map('intval', $data['offices'] ?? []);
        // An unknown code resolves to 0, which matches no transaction (never every office).
        $this->officeId = filled($data['office_code'] ?? null)
            ? (int) Office::whereRaw('UPPER(code) = ?', [mb_strtoupper($data['office_code'])])->value('id')
            : null;
    }

    private function filtered(Builder $q, bool $withProcess = true): Builder
    {
        if ($withProcess && $this->processes) $q->whereIn('transactions.transaction_type_id', $this->processes);
        if ($this->offices) $q->whereIn('transactions.office_id', $this->offices);
        if ($this->officeId !== null) $q->where('transactions.office_id', $this->officeId);

        return $q;
    }

    private function createdInPeriod(Builder $q): Builder
    {
        return $q->where('transactions.created_at', '>=', $this->from)
            ->where('transactions.created_at', '<', $this->to);
    }

    private function completedQuery(): Builder
    {
        return $this->filtered(Transaction::query())
            ->where('is_done', true)
            ->whereHas('runs', fn ($r) => $r
                ->where('action_code', 'finalize')
                ->where('performed_at', '>=', $this->from)
                ->where('performed_at', '<', $this->to));
    }

    /** Created in the period and still open (with what the lists need). */
    private function inProcess(): Collection
    {
        return $this->createdInPeriod($this->filtered(Transaction::query()))
            ->where('is_done', false)
            ->with(['state.currentStep', 'type', 'office', 'creator', 'workflow.stepRoles.role'])
            ->get();
    }

    private function deletedQuery(): Builder
    {
        return $this->createdInPeriod($this->filtered(Transaction::onlyTrashed()));
    }

    /** Minutes past the current station's SLA; 0 when on time or no SLA. */
    private function overdueMinutes(Transaction $tx): int
    {
        $sla = (int) ($tx->state?->currentStep?->sla_minutes ?? 0);
        $enteredAt = $tx->state?->entered_at;
        if ($sla <= 0 || !$enteredAt) return 0;

        return max(0, (int) $enteredAt->copy()->addMinutes($sla)->diffInMinutes(now(), false));
    }

    // ---- detail rows --------------------------------------------------------

    private function baseRow(Transaction $tx): array
    {
        return [
            'id' => $tx->id,
            'reference_number' => $tx->reference_number,
            'title' => $tx->title,
            'process' => $tx->type?->only(['id', 'name']),
            'office' => $tx->office?->only(['id', 'code', 'name']),
            'created_by' => $tx->creator?->only(['id', 'name', 'email']),
            'created_at' => $tx->created_at?->toIso8601String(),
        ];
    }

    private function stationFields(Transaction $tx): array
    {
        $step = $tx->state?->currentStep;
        $roles = $step
            ? $tx->workflow?->stepRoles
                ?->where('workflow_step_id', $step->id)
                ->map(fn ($sr) => $sr->role?->name)
                ->filter()->unique()->values()->all()
            : [];
        $enteredAt = $tx->state?->entered_at;

        return [
            'current_step' => $step ? ['id' => $step->id, 'name' => $step->name, 'order_number' => (int) $step->order_number] : null,
            'handled_by' => $roles ?? [],
            'entered_at' => $enteredAt?->toIso8601String(),
            'waiting_minutes' => $enteredAt ? (int) $enteredAt->diffInMinutes(now()) : null,
            'sla_minutes' => (int) ($step?->sla_minutes ?? 0),
            'overdue_minutes' => $this->overdueMinutes($tx),
        ];
    }

    private function openRows(Collection $txs): Collection
    {
        return $txs->map(fn (Transaction $tx) => $this->baseRow($tx) + $this->stationFields($tx))->values();
    }

    private function completedRows(): Collection
    {
        return $this->completedQuery()
            ->with(['type', 'office', 'creator', 'runs' => fn ($r) => $r->where('action_code', 'finalize')->with('performer')])
            ->get()
            ->map(function (Transaction $tx) {
                $run = $tx->runs->first();
                $finalizedAt = $run?->performed_at;

                return $this->baseRow($tx) + [
                    'finalized_at' => $finalizedAt?->toIso8601String(),
                    'finalized_by' => $run?->performer?->only(['id', 'name', 'email']),
                    'duration_minutes' => ($finalizedAt && $tx->created_at)
                        ? (int) $tx->created_at->diffInMinutes($finalizedAt) : null,
                ];
            })
            ->sortByDesc('finalized_at')
            ->values();
    }

    private function deletedRows(): Collection
    {
        $txs = $this->deletedQuery()->with(['type', 'office', 'creator', 'state.currentStep'])->get();

        // Who deleted it lives in the audit log (transactions.delete).
        $logs = AuditLog::query()
            ->where('event', 'transactions.delete')
            ->where('entity_type', Transaction::class)
            ->whereIn('entity_id', $txs->pluck('id'))
            ->orderByDesc('id')
            ->get(['entity_id', 'actor_user_id'])
            ->unique('entity_id')
            ->keyBy('entity_id');
        $actors = User::whereIn('id', $logs->pluck('actor_user_id')->filter())
            ->get(['id', 'name', 'email'])
            ->keyBy('id');

        return $txs->map(function (Transaction $tx) use ($logs, $actors) {
            $step = $tx->state?->currentStep;
            $actor = $actors->get($logs->get($tx->id)?->actor_user_id);

            return $this->baseRow($tx) + [
                'deleted_at' => $tx->deleted_at?->toIso8601String(),
                'deleted_by' => $actor?->only(['id', 'name', 'email']),
                'station_at_deletion' => $step ? ['name' => $step->name, 'order_number' => (int) $step->order_number] : null,
            ];
        })->sortByDesc('deleted_at')->values();
    }

    /** Every non-deleted transaction of one process created in the period. */
    private function processRows(int $processId): Collection
    {
        return $this->createdInPeriod($this->filtered(Transaction::query(), withProcess: false))
            ->where('transactions.transaction_type_id', $processId)
            ->with(['state.currentStep', 'type', 'office', 'creator', 'workflow.stepRoles.role'])
            ->get()
            ->map(function (Transaction $tx) {
                $status = $tx->is_done ? 'completed' : ($this->overdueMinutes($tx) > 0 ? 'overdue' : 'in_process');

                return $this->baseRow($tx) + $this->stationFields($tx) + ['status' => $status];
            })
            ->sortByDesc('created_at')
            ->values();
    }

    /** @return array{0: Carbon, 1: Carbon, 2: array} [from, to (exclusive), meta] in UTC */
    private function period(?string $month): array
    {
        if ($month) {
            $start = Carbon::parse("{$month}-01 00:00:00", self::TZ);
            $end = $start->copy()->addMonthNoOverflow();

            return [$start->copy()->utc(), $end->copy()->utc(), [
                'key' => $month,
                'label' => $start->format('F Y'),
                'from' => $start->toIso8601String(),
                'to' => $end->toIso8601String(),
            ]];
        }

        // Last week: the previous full Monday–Sunday week, not the current one.
        $end = now(self::TZ)->startOfWeek(Carbon::MONDAY);
        $start = $end->copy()->subWeek();
        $sunday = $end->copy()->subDay();

        return [$start->copy()->utc(), $end->copy()->utc(), [
            'key' => 'last_week',
            'label' => sprintf('Last week (%s–%s)', $start->format('M j'), $sunday->format($sunday->isSameMonth($start) ? 'j' : 'M j')),
            'from' => $start->toIso8601String(),
            'to' => $end->toIso8601String(),
        ]];
    }
}
