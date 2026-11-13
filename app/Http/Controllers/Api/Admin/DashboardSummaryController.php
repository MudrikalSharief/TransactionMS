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
 * The monthly status series always covers the last two months plus the
 * current one, independent of the Period filter. overdue_steps follows the
 * selected Period; overdue_transactions is always all-current.
 * Process/office filters narrow every count, except by_process, which
 * ignores the process filter so the card can fade unpicked processes.
 * office_code limits everything to one office by its code (the dashboard
 * sends the office its graph covers).
 * overdue_by_office: offices with open transactions whose combined working
 * time exceeds the sum of their stations' SLA limits, busiest first.
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
            $sla = $this->slaCounts();

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
                // The dashboard's Overdue Transactions pie: open papers whose
                // total working time is over their combined SLA (all current,
                // independent of the Period filter), by originating office.
                'overdue_by_office' => $sla['overdue_by_office'],
                // Overdue step counts (all periods' open work, per step and
                // per office) for anything reading the SLA figures.
                'overdue_steps' => $sla['overdue_steps'],
                'overdue_transactions' => $sla['overdue_transactions'],
                'overdue_steps_by_office' => $sla['overdue_steps_by_office'],
                'deleted' => $this->deletedQuery()->count(),
                'by_process' => $byProcess,
                'monthly' => $this->monthlyStatuses(),
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
     * One month of Transaction Status counts plus the top three overdue
     * step + office pairs. Both share the card's Month and Office filters;
     * the office filter narrows by the office handling the step.
     */
    public function overdueOverview(Request $request)
    {
        $data = $request->validate([
            'month' => ['nullable', 'regex:/^\d{4}-(0[1-9]|1[0-2])$/'],
            'office_id' => ['nullable', 'integer', 'exists:offices,id'],
        ]);

        $user = $request->user();
        $this->processes = [];
        $this->offices = [];
        // Do not filter transactions by originating office; the step's
        // effective office is filtered while counting visits below.
        $this->officeId = null;
        $this->scopeOfficeId = $user->isSuperadmin() ? null : (int) $user->office_id;
        $filterOfficeId = $user->isSuperadmin() && !empty($data['office_id'])
            ? (int) $data['office_id']
            : null;

        $month = !empty($data['month'])
            ? Carbon::createFromFormat('Y-m', $data['month'], self::TZ)
            : now(self::TZ);
        $monthStart = $month->copy()->startOfMonth();
        $windowStart = $monthStart->copy()->subMonths(2);
        $windowFrom = $windowStart->copy()->utc();
        $windowTo = $monthStart->copy()->addMonthNoOverflow()->utc();

        $key = 'dash:overdue-overview:'.md5(json_encode([
            $data['month'] ?? null, $filterOfficeId, $this->scopeOfficeId,
        ]));

        $payload = \Illuminate\Support\Facades\Cache::remember(
            $key,
            60,
            fn () => $this->overdueOverviewData(
                $monthStart,
                $windowStart,
                $windowFrom,
                $windowTo,
                $filterOfficeId,
            ),
        );

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
            ->whereIn('entity_type', ['transaction', Transaction::class])
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

    /**
     * Last two months plus the current month (Manila), split by status.
     * Completed rows count by their finalize run's date; open rows count by
     * their creation date. This fixed window is independent of the Period
     * filter, so the overview graph always shows three monthly groups.
     */
    private function monthlyStatuses(): array
    {
        $end = now(self::TZ)->startOfMonth()->addMonth();
        $start = $end->copy()->subMonths(3);
        $fromUtc = $start->copy()->utc();
        $toUtc = $end->copy()->utc();

        $buckets = [];
        for ($cursor = $start->copy(); $cursor < $end; $cursor->addMonthNoOverflow()) {
            $key = $cursor->format('Y-m');
            $buckets[$key] = [
                'month' => $key,
                'label' => $cursor->format('M Y'),
                'completed' => 0,
                'in_process' => 0,
                'overdue' => 0,
            ];
        }

        // Open rows: created in the window and still open now.
        $open = $this->filtered(Transaction::query())
            ->where('is_done', false)
            ->where('transactions.created_at', '>=', $fromUtc)
            ->where('transactions.created_at', '<', $toUtc)
            ->with('state.currentStep')
            ->get();

        foreach ($open as $tx) {
            $key = $tx->created_at?->copy()->setTimezone(self::TZ)->format('Y-m');
            if (!$key || !isset($buckets[$key])) continue;
            $buckets[$key][$this->overdueMinutes($tx) > 0 ? 'overdue' : 'in_process']++;
        }

        // Completed rows: finalized in the window, even when created earlier.
        $completed = $this->filtered(Transaction::query())
            ->where('is_done', true)
            ->whereHas('runs', fn ($r) => $r
                ->where('action_code', 'finalize')
                ->where('performed_at', '>=', $fromUtc)
                ->where('performed_at', '<', $toUtc))
            ->with(['runs' => fn ($r) => $r
                ->where('action_code', 'finalize')
                ->where('performed_at', '>=', $fromUtc)
                ->where('performed_at', '<', $toUtc)])
            ->get();

        foreach ($completed as $tx) {
            $run = $tx->runs->sortBy('performed_at')->first();
            $key = $run?->performed_at?->copy()->setTimezone(self::TZ)->format('Y-m');
            if ($key && isset($buckets[$key])) $buckets[$key]['completed']++;
        }

        return array_values($buckets);
    }

    /**
     * Two SLA views used by the dashboard status cards.
     *
     * overdue_steps: every step visit (finished or current) whose working
     * time at that step exceeded its SLA. A step visit counts for the
     * selected Period when it overlaps that period, grouped by the office
     * responsible for that step.
     *
     * overdue_transactions: open transactions only, always all-current.
     * A transaction counts when the total working time spent at its visited
     * steps exceeds the sum of those steps' SLA limits. Revisits count each
     * time; steps with no SLA are ignored. The same transactions are grouped
     * by originating office for the dashboard pie.
     */
    private function slaCounts(): array
    {
        $now = now();

        // Open papers are always needed for the all-current transaction
        // view; finished papers are needed when one of their runs (a step
        // visit ending) falls in the selected Period.
        $txs = $this->filtered(Transaction::query())
            ->when($this->from, fn ($q) => $q->where(fn ($w) => $w
                ->where('is_done', false)
                ->orWhereBetween('transactions.created_at', [$this->from, $this->to])
                ->orWhereHas('runs', fn ($r) => $r->whereBetween('performed_at', [$this->from, $this->to]))))
            ->with(['runs' => fn ($r) => $r
                ->reorder()
                ->orderBy('performed_at')
                ->orderBy('id')
                ->select(['id', 'transaction_id', 'to_step_id', 'performed_at', 'sla_minutes_snapshot'])
                ->with([
                    'toStep:id,sla_minutes,office_id,is_end_user',
                    'toStep.office:id,code,name',
                ])])
            ->with('office:id,code,name')
            ->get();

        $overdueSteps = 0;
        $overdueTransactions = 0;
        $byOffice = [];
        $byStepOffice = [];

        foreach ($txs as $tx) {
            $runs = $tx->runs->values();
            $actual = 0;
            $allowed = 0;

            foreach ($runs as $i => $run) {
                if (!$run->performed_at) continue;

                $next = $runs->get($i + 1);
                // A finished transaction's finalize run has no visit to
                // measure; the previous run's step ends at the finalize.
                if (!$next && $tx->is_done) continue;

                $enteredAt = $run->performed_at;
                $leftAt = $next?->performed_at ?? $now;
                $sla = (int) ($run->sla_minutes_snapshot ?: $run->toStep?->sla_minutes ?: 0);
                if ($sla <= 0) continue;

                $wait = WorkingTime::minutesBetween($enteredAt, $leftAt);

                if ($wait > $sla && $enteredAt->lt($this->to) && $leftAt->gt($this->from)) {
                    $overdueSteps++;
                    $stepOffice = $run->toStep ? $tx->effectiveStepOffice($run->toStep) : null;
                    $officeId = $stepOffice?->id ?? 0;
                    $byStepOffice[$officeId] ??= [
                        'id' => $stepOffice?->id,
                        'code' => $stepOffice?->code,
                        'name' => $stepOffice?->name ?? 'No office',
                        'count' => 0,
                    ];
                    $byStepOffice[$officeId]['count']++;
                }

                if (!$tx->is_done) {
                    $actual += $wait;
                    $allowed += $sla;
                }
            }

            if (!$tx->is_done && $allowed > 0 && $actual > $allowed) {
                $overdueTransactions++;
                $office = $tx->office;
                $officeId = $office?->id ?? 0;
                $byOffice[$officeId] ??= [
                    'id' => $office?->id,
                    'code' => $office?->code,
                    'name' => $office?->name ?? 'No office',
                    'count' => 0,
                ];
                $byOffice[$officeId]['count']++;
            }
        }

        return [
            'overdue_steps' => $overdueSteps,
            'overdue_transactions' => $overdueTransactions,
            'overdue_by_office' => collect($byOffice)
                ->sortByDesc('count')
                ->values()
                ->all(),
            'overdue_steps_by_office' => collect($byStepOffice)
                ->sortByDesc('count')
                ->values()
                ->all(),
        ];
    }

    /**
     * Three months of status counts plus the selected month's top overdue
     * step + office pairs. The ending month is the card's Month filter; the
     * office filter narrows by the office handling the step.
     */
    private function overdueOverviewData(
        Carbon $selectedStart,
        Carbon $windowStart,
        Carbon $windowFrom,
        Carbon $windowTo,
        ?int $filterOfficeId,
    ): array {
        $buckets = [];
        $bucketList = [];
        for ($cursor = $windowStart->copy(), $i = 0; $i < 3; $i++, $cursor->addMonthNoOverflow()) {
            $key = $cursor->format('Y-m');
            $buckets[$key] = [
                'month' => $key,
                'label' => $cursor->format('M Y'),
                'completed' => 0,
                'in_process' => 0,
                'overdue' => 0,
            ];
            $bucketList[] = [
                'key' => $key,
                'start' => $cursor->copy()->utc(),
                'end' => $cursor->copy()->addMonthNoOverflow()->utc(),
            ];
        }
        $selectedKey = $selectedStart->format('Y-m');

        $txs = $this->filtered(Transaction::query())
            ->where(fn ($w) => $w
                ->where('is_done', false)
                ->orWhereBetween('transactions.created_at', [$windowFrom, $windowTo])
                ->orWhereHas('runs', fn ($r) => $r->whereBetween('performed_at', [$windowFrom, $windowTo])))
            ->with([
                'state.currentStep',
                'office:id,code,name',
                'type:id,name',
                'runs' => fn ($r) => $r
                    ->reorder()
                    ->orderBy('performed_at')
                    ->orderBy('id')
                    ->select(['id', 'transaction_id', 'to_step_id', 'action_code', 'performed_at', 'sla_minutes_snapshot'])
                    ->with([
                        'toStep:id,name,code,order_number,sla_minutes,office_id,is_end_user',
                        'toStep.office:id,code,name',
                    ]),
            ])
            ->get();

        $groups = [];

        foreach ($txs as $tx) {
            $runs = $tx->runs->values();
            $officeVisitMonths = [];
            $finalizedMonths = [];

            foreach ($runs as $i => $run) {
                if (!$run->performed_at) continue;

                $runKey = $run->performed_at->copy()->setTimezone(self::TZ)->format('Y-m');

                if ($run->action_code === 'finalize' && isset($buckets[$runKey])) {
                    $finalizedMonths[$runKey] = true;
                }

                $next = $runs->get($i + 1);
                if (!$next && $tx->is_done) continue;

                $enteredAt = $run->performed_at;
                $leftAt = $next?->performed_at ?? now();
                $sla = (int) ($run->sla_minutes_snapshot ?: $run->toStep?->sla_minutes ?: 0);
                if ($sla <= 0) continue;

                $step = $run->toStep;
                if (!$step) continue;

                $office = $tx->effectiveStepOffice($step);
                $officeMatches = $filterOfficeId === null
                    || (int) ($office?->id ?? 0) === $filterOfficeId;

                $wait = WorkingTime::minutesBetween($enteredAt, $leftAt);

                foreach ($bucketList as $bucket) {
                    if (!($enteredAt->lt($bucket['end']) && $leftAt->gt($bucket['start']))) continue;
                    if (!$officeMatches) continue;

                    $officeVisitMonths[$bucket['key']] = true;

                    if ($bucket['key'] !== $selectedKey || $wait <= $sla) continue;

                    $key = $step->id.'|'.($office?->id ?? 0).'|'.$bucket['key'];
                    $groups[$key] ??= [
                        'step_id' => $step->id,
                        'step' => $step->name,
                        'step_code' => $step->code,
                        'order_number' => (int) $step->order_number,
                        'transaction_type' => $tx->type?->name,
                        'office' => $office
                            ? ['id' => $office->id, 'code' => $office->code, 'name' => $office->name]
                            : null,
                        'count' => 0,
                    ];
                    $groups[$key]['count']++;
                }
            }

            $officeMatches = fn (string $monthKey) => $filterOfficeId === null
                || isset($officeVisitMonths[$monthKey]);

            if ($tx->is_done) {
                foreach (array_keys($finalizedMonths) as $monthKey) {
                    if ($officeMatches($monthKey)) $buckets[$monthKey]['completed']++;
                }
                continue;
            }

            $createdKey = $tx->created_at?->copy()->setTimezone(self::TZ)->format('Y-m');
            if ($createdKey && isset($buckets[$createdKey]) && $officeMatches($createdKey)) {
                $buckets[$createdKey][$this->overdueMinutes($tx) > 0 ? 'overdue' : 'in_process']++;
            }
        }

        $steps = collect($groups)
            ->sort(fn ($a, $b) => $b['count'] <=> $a['count']
                ?: strcmp($a['step'], $b['step'])
                ?: strcmp($a['office']['code'] ?? '', $b['office']['code'] ?? ''))
            ->take(3)
            ->values()
            ->all();

        return [
            'month' => $selectedKey,
            'label' => $selectedStart->format('F Y'),
            'months' => array_values($buckets),
            'steps' => $steps,
        ];
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
