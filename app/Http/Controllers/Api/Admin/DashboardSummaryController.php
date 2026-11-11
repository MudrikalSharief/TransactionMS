<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Office;
use App\Models\Transaction;
use App\Models\TransactionStepRun;
use App\Models\User;
use App\Services\OfficeScope;
use App\Support\WorkingTime;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;

/**
 * Dashboard "Transaction Summary" card (superadmin, and office admins via
 * /api/office, who only ever see their own office's scope: transactions it
 * filed or that pass through one of its steps).
 *
 * Period: this week (default: the current Mon–Sun calendar week), a
 * calendar month, or all time, all in Manila time.
 * Completed counts by finalize date; everything else by created date.
 * Process/office filters narrow every count, except by_process, which
 * ignores the process filter so the card can fade unpicked processes.
 * office_code limits everything to one office by its code (the dashboard
 * sends the office its graph covers).
 * overdue_by_office: the five offices holding the most overdue transactions
 * (the office of each one's current station), busiest first.
 * Superadmins also get, five offices each:
 *   on_time_by_office  completed in the period (archived included) before the
 *                      transaction's deadline (sum of its stations' time
 *                      limits), by the office of the station that finished it
 *   returns_by_office  returns made in the period, by the office that sent the
 *                      transaction back
 * Each office carries a few sample rows (reference, assigned person) for the
 * chart's tooltip; its full list comes from details() with at_office.
 *
 * The tile counts (__invoke) and the detail lists (details) share the same
 * queries below, so a list always has exactly as many rows as its tile.
 */
class DashboardSummaryController extends Controller
{
    private const TZ = 'Asia/Manila';
    private const CATEGORIES = ['completed', 'in_process', 'overdue', 'deleted', 'process', 'on_time', 'returns'];
    // Lists only superadmins see (the per-office charts on their dashboard).
    private const SUPERADMIN_CATEGORIES = ['on_time', 'returns'];
    private const SAMPLES = 3;

    private Carbon $from;
    private Carbon $to;
    private array $periodMeta;
    private array $processes = [];
    private array $offices = [];
    private ?int $officeId = null;
    // Office admins: forced to their own office's scope (see OfficeScope).
    private ?int $scopeOfficeId = null;
    private bool $isSuperadmin = false;
    // People who can work a station at an office, by "office|role ids".
    private array $people = [];

    public function __invoke(Request $request)
    {
        $this->resolveScope($request);

        // Tile counts are polled silently every 20s by every open Dashboard —
        // 60s server cache cuts that to 1 query-batch per minute per filter.
        $key = 'dash:summary:'.md5(json_encode([
            $this->periodMeta, $this->processes, $this->offices, $this->officeId, $this->scopeOfficeId,
        ]));

        $payload = \Illuminate\Support\Facades\Cache::remember($key, 60, function () {
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

            $overdue = $inProcess->filter(fn ($tx) => $this->overdueMinutes($tx) > 0);

            $payload = [
                'period' => $this->periodMeta,
                'completed' => $this->completedQuery()->count(),
                'in_process' => $inProcess->count(),
                'overdue' => $overdue->count(),
                'overdue_by_office' => $this->topOffices(
                    $overdue->map(fn (Transaction $tx) => [
                        'office' => $this->heldOffice($tx),
                        'tx' => $tx,
                        'assigned' => fn () => $this->assignedNow($tx),
                    ]),
                    withSamples: $this->isSuperadmin,
                ),
                'deleted' => $this->deletedQuery()->count(),
                'by_process' => $byProcess,
            ];

            if ($this->isSuperadmin) {
                $payload['on_time_by_office'] = $this->topOffices($this->onTimeItems());
                $payload['returns_by_office'] = $this->topOffices($this->returnItems());
            }

            return $payload;
        });

        return response()->json($payload);
    }

    /**
     * Detail list behind one tile (or one process bar, with process_id).
     */
    public function details(Request $request, string $category)
    {
        abort_unless(in_array($category, self::CATEGORIES, true), 404);
        $this->resolveScope($request, extra: [
            'process_id' => [$category === 'process' ? 'required' : 'nullable', 'integer'],
            // One office's list: where overdue papers are now, the office that
            // finished on-time papers, or the office that made the returns.
            'at_office' => ['nullable', 'integer'],
        ]);
        abort_if(in_array($category, self::SUPERADMIN_CATEGORIES, true) && !$this->isSuperadmin, 403);
        $atOffice = $request->filled('at_office') ? (int) $request->input('at_office') : null;

        $rows = match ($category) {
            'completed' => $this->completedRows(),
            'in_process' => $this->openRows($this->inProcess())
                ->sortByDesc('waiting_minutes')->values(),
            'overdue' => $this->openRows($this->inProcess()
                ->filter(fn ($tx) => $this->overdueMinutes($tx) > 0)
                ->filter(fn ($tx) => $atOffice === null || $this->heldOffice($tx)?->id === $atOffice))
                ->sortByDesc('overdue_minutes')->values(),
            'deleted' => $this->deletedRows(),
            'process' => $this->processRows((int) $request->input('process_id')),
            'on_time' => $this->onTimeRows($atOffice),
            'returns' => $this->returnRows($atOffice),
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
            'month' => ['nullable', 'regex:/^(\d{4}-(0[1-9]|1[0-2])|all)$/'],
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

        $user = $request->user();
        $this->isSuperadmin = $user->isSuperadmin();
        $this->scopeOfficeId = $this->isSuperadmin ? null : (int) $user->office_id;
    }

    private function filtered(Builder $q, bool $withProcess = true, bool $withArchived = false): Builder
    {
        if (!$withArchived) $q->where('transactions.is_archive', false);
        if ($withProcess && $this->processes) $q->whereIn('transactions.transaction_type_id', $this->processes);
        if ($this->offices) $q->whereIn('transactions.office_id', $this->offices);
        if ($this->officeId !== null) $q->where('transactions.office_id', $this->officeId);
        if ($this->scopeOfficeId !== null) app(OfficeScope::class)->apply($q, $this->scopeOfficeId);

        return $q;
    }

    private function createdInPeriod(Builder $q): Builder
    {
        return $q->where('transactions.created_at', '>=', $this->from)
            ->where('transactions.created_at', '<', $this->to);
    }

    private function completedQuery(bool $withArchived = false): Builder
    {
        return $this->filtered(Transaction::query(), withArchived: $withArchived)
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
            ->with(['state.currentStep.office', 'type', 'office', 'creator', 'workflow.stepRoles.role'])
            ->get();
    }

    private function deletedQuery(): Builder
    {
        return $this->createdInPeriod($this->filtered(Transaction::onlyTrashed()));
    }

    /** The office holding the transaction now: its current station's office. */
    private function heldOffice(Transaction $tx): ?Office
    {
        $step = $tx->state?->currentStep;

        return $step ? $tx->effectiveStepOffice($step) : $tx->office;
    }

    /** Working minutes past the current station's SLA (weekends skipped); 0 when on time or no SLA. */
    private function overdueMinutes(Transaction $tx): int
    {
        $sla = (int) ($tx->state?->currentStep?->sla_minutes ?? 0);
        $enteredAt = $tx->state?->entered_at;
        if ($sla <= 0 || !$enteredAt) return 0;

        return max(0, WorkingTime::minutesBetween($enteredAt, now()) - $sla);
    }

    // ---- per-office charts (on time, overdue, returns) ------------------------

    /**
     * Five offices with the most items, busiest first. Each item is
     * ['office' => ?Office, 'tx' => Transaction, 'assigned' => names or a
     * closure returning them]; count = items, transactions = distinct papers.
     */
    private function topOffices(Collection $items, bool $withSamples = true): Collection
    {
        return $items
            ->groupBy(fn ($item) => $item['office']?->id ?? 0)
            ->map(function (Collection $group, $officeId) use ($withSamples) {
                $office = $group->first()['office'];
                $row = [
                    'id' => $officeId ?: null,
                    'code' => $office?->code,
                    'name' => $office?->name ?? 'No office',
                    'count' => $group->count(),
                    'transactions' => $group->pluck('tx.id')->unique()->count(),
                ];
                if ($withSamples) {
                    // Everyone in charge of these at the office, most involved first.
                    $row['people'] = $group->flatMap(fn ($item) => value($item['assigned']))
                        ->countBy()->sortDesc()->keys()->take(self::SAMPLES)->values();
                    $row['samples'] = $group->unique(fn ($item) => $item['tx']->id)
                        ->take(self::SAMPLES)
                        ->map(fn ($item) => [
                            'reference_number' => $item['tx']->reference_number,
                            'title' => $item['tx']->title,
                            'assigned' => value($item['assigned']),
                        ])
                        ->values();
                }

                return $row;
            })
            ->sortBy([['count', 'desc'], ['name', 'asc']])
            ->take(5)
            ->values();
    }

    /**
     * Completed in the period (finalize date), archived ones included, and
     * finished before the transaction's deadline: the working time spent at
     * its stations is no more than the sum of those stations' time limits.
     * A transaction whose stations have no limits has no deadline and is
     * left out.
     */
    private function onTimeTransactions(): Collection
    {
        return $this->completedQuery(withArchived: true)
            ->with([
                'type', 'office', 'creator', 'workflow.steps.office',
                // Oldest first (the relation itself sorts newest first).
                'runs' => fn ($r) => $r->reorder()->orderBy('performed_at')->orderBy('id')->with('performer'),
            ])
            ->get()
            ->filter(function (Transaction $tx) {
                [$spent, $deadline] = $this->deadlineUse($tx);

                return $deadline > 0 && $spent <= $deadline;
            })
            ->values();
    }

    /**
     * [working minutes spent, deadline in minutes] over the stations the
     * transaction passed. Visit = from the run that brought it in to the run
     * that moved it on (same rule as the monitoring report).
     */
    private function deadlineUse(Transaction $tx): array
    {
        $steps = $tx->workflow?->steps?->keyBy('id') ?? collect();
        $runs = $tx->runs->values();
        $spent = 0;
        $deadline = 0;
        foreach ($runs as $i => $run) {
            $next = $runs->get($i + 1);
            if (!$next) break;
            $spent += WorkingTime::minutesBetween($run->performed_at, $next->performed_at);
            $deadline += (int) ($run->sla_minutes_snapshot ?: $steps->get($run->to_step_id)?->sla_minutes ?: 0);
        }

        return [$spent, $deadline];
    }

    /** The finalize run, and the office of the station it was finalized at. */
    private function finish(Transaction $tx): array
    {
        $run = $tx->runs->where('action_code', 'finalize')->last();
        $step = $run ? $tx->workflow?->steps?->firstWhere('id', $run->from_step_id) : null;

        return [$run, $step ? $tx->effectiveStepOffice($step) : $tx->office];
    }

    private function onTimeItems(): Collection
    {
        return $this->onTimeTransactions()->map(function (Transaction $tx) {
            [$run, $office] = $this->finish($tx);

            return ['office' => $office, 'tx' => $tx, 'assigned' => array_filter([$run?->performer?->name])];
        });
    }

    /** Returns made in the period on transactions in scope, oldest first. */
    private function returnRuns(): Collection
    {
        return TransactionStepRun::query()
            ->where('action_code', 'return')
            ->where('performed_at', '>=', $this->from)
            ->where('performed_at', '<', $this->to)
            ->whereHas('transaction', fn ($q) => $this->filtered($q))
            ->with(['transaction.type', 'transaction.office', 'transaction.creator', 'fromStep.office', 'toStep', 'performer'])
            ->orderBy('performed_at')
            ->get();
    }

    /** The office that sent the transaction back: its station's office. */
    private function returnOffice(TransactionStepRun $run): ?Office
    {
        return $run->fromStep ? $run->transaction->effectiveStepOffice($run->fromStep) : $run->transaction->office;
    }

    private function returnItems(): Collection
    {
        return $this->returnRuns()->map(fn (TransactionStepRun $run) => [
            'office' => $this->returnOffice($run),
            'tx' => $run->transaction,
            'assigned' => array_filter([$run->performer?->name]),
        ]);
    }

    /**
     * Who is on the paper at its current station: the person who received it
     * there, or, before anyone has, the active people at that office who hold
     * one of the station's roles.
     */
    private function assignedNow(Transaction $tx): array
    {
        $step = $tx->state?->currentStep;
        if (!$step) return [];

        $run = $tx->runs->firstWhere('to_step_id', $step->id);
        if ($run?->receiver) return [$run->receiver->name];

        $office = $this->heldOffice($tx);
        $roleIds = $tx->workflow?->stepRoles?->where('workflow_step_id', $step->id)
            ->pluck('role_id')->filter()->unique()->sort()->values()->all() ?? [];
        if (!$office || !$roleIds) return [];

        return $this->people[$office->id.'|'.implode(',', $roleIds)] ??= User::query()
            ->where('office_id', $office->id)
            ->where('is_active', true)
            ->whereHas('roles', fn ($r) => $r->whereIn('roles.id', $roleIds))
            ->orderBy('name')
            ->limit(5)
            ->pluck('name')
            ->all();
    }

    // ---- detail rows --------------------------------------------------------

    private function baseRow(Transaction $tx): array
    {
        return [
            'id' => $tx->id,
            'reference_number' => $tx->reference_number,
            'title' => $tx->title,
            'process' => $tx->type?->only(['id', 'name']),
            'office' => Office::mini($tx->office),
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
            // Working minutes, so "waiting" compares directly with the limit.
            'waiting_minutes' => $enteredAt ? WorkingTime::minutesBetween($enteredAt, now()) : null,
            'sla_minutes' => (int) ($step?->sla_minutes ?? 0),
            'overdue_minutes' => $this->overdueMinutes($tx),
        ];
    }

    private function openRows(Collection $txs): Collection
    {
        $txs->load('runs.receiver');

        return $txs->map(fn (Transaction $tx) => $this->baseRow($tx) + $this->stationFields($tx) + [
            'office_in_charge' => Office::mini($this->heldOffice($tx)),
            'assigned' => $this->assignedNow($tx),
        ])->values();
    }

    /** On-time papers, optionally only those finished at one office. */
    private function onTimeRows(?int $atOffice): Collection
    {
        return $this->onTimeTransactions()
            ->map(function (Transaction $tx) use ($atOffice) {
                [$run, $office] = $this->finish($tx);
                if ($atOffice !== null && $office?->id !== $atOffice) return null;
                $finalizedAt = $run?->performed_at;
                [$spent, $deadline] = $this->deadlineUse($tx);

                return $this->baseRow($tx) + [
                    'archived' => (bool) $tx->is_archive,
                    'spent_minutes' => $spent,
                    'deadline_minutes' => $deadline,
                    'finalized_at' => $finalizedAt?->toIso8601String(),
                    'finalized_by' => $run?->performer?->only(['id', 'name', 'email']),
                    'duration_minutes' => ($finalizedAt && $tx->created_at)
                        ? (int) $tx->created_at->diffInMinutes($finalizedAt) : null,
                    'office_in_charge' => Office::mini($office),
                    'assigned' => array_filter([$run?->performer?->name]),
                ];
            })
            ->filter()
            ->sortByDesc('finalized_at')
            ->values();
    }

    /** One row per transaction returned in the period (optionally by one office), most returns first. */
    private function returnRows(?int $atOffice): Collection
    {
        return $this->returnRuns()
            ->filter(fn (TransactionStepRun $run) => $atOffice === null || $this->returnOffice($run)?->id === $atOffice)
            ->groupBy('transaction_id')
            ->map(function (Collection $runs) {
                $last = $runs->last();
                $tx = $last->transaction;

                return $this->baseRow($tx) + [
                    'returns' => $runs->count(),
                    'last_returned_at' => $last->performed_at?->toIso8601String(),
                    'returned_from' => $last->fromStep ? ['name' => $last->fromStep->name, 'order_number' => (int) $last->fromStep->order_number] : null,
                    'returned_to' => $last->toStep ? ['name' => $last->toStep->name, 'order_number' => (int) $last->toStep->order_number] : null,
                    'remarks' => $last->remarks,
                    'office_in_charge' => Office::mini($this->returnOffice($last)),
                    'assigned' => $runs->map(fn ($run) => $run->performer?->name)->filter()->unique()->values()->all(),
                ];
            })
            ->sortBy([['returns', 'desc'], ['last_returned_at', 'desc']])
            ->values();
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
        if ($month === 'all') {
            $from = Carbon::parse('1970-01-01 00:00:00', 'UTC');
            $to = Carbon::parse('9999-12-31 23:59:59', 'UTC');

            return [$from, $to, [
                'key' => 'all',
                'label' => 'All time',
                'from' => $from->toIso8601String(),
                'to' => $to->toIso8601String(),
            ]];
        }

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

        // This week: the current Monday–Sunday week (so far).
        $start = now(self::TZ)->startOfWeek(Carbon::MONDAY);
        $end = $start->copy()->addWeek();
        $sunday = $end->copy()->subDay();

        return [$start->copy()->utc(), $end->copy()->utc(), [
            'key' => 'this_week',
            'label' => sprintf('This week (%s–%s)', $start->format('M j'), $sunday->format($sunday->isSameMonth($start) ? 'j' : 'M j')),
            'from' => $start->toIso8601String(),
            'to' => $end->toIso8601String(),
        ]];
    }
}
