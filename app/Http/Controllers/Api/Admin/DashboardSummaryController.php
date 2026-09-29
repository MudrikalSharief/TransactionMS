<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

/**
 * Dashboard "Transaction Summary" card (superadmin).
 *
 * Period: the last 4 weeks (default) or a calendar month in Manila time.
 * Completed counts by finalize date; everything else by created date.
 * Process/office filters narrow every count, except by_process, which
 * ignores the process filter so the card can fade unpicked processes.
 */
class DashboardSummaryController extends Controller
{
    private const TZ = 'Asia/Manila';

    public function __invoke(Request $request)
    {
        $data = $request->validate([
            'month' => ['nullable', 'regex:/^\d{4}-(0[1-9]|1[0-2])$/'],
            'processes' => ['nullable', 'array'],
            'processes.*' => ['integer'],
            'offices' => ['nullable', 'array'],
            'offices.*' => ['integer'],
        ]);

        [$from, $to, $period] = $this->period($data['month'] ?? null);
        $processes = array_map('intval', $data['processes'] ?? []);
        $offices = array_map('intval', $data['offices'] ?? []);

        $filtered = function (Builder $q, bool $withProcess = true) use ($processes, $offices) {
            if ($withProcess && $processes) $q->whereIn('transactions.transaction_type_id', $processes);
            if ($offices) $q->whereIn('transactions.office_id', $offices);

            return $q;
        };
        $createdInPeriod = fn (Builder $q) => $q
            ->where('transactions.created_at', '>=', $from)
            ->where('transactions.created_at', '<', $to);

        $completed = $filtered(Transaction::query())
            ->where('is_done', true)
            ->whereHas('runs', fn ($r) => $r
                ->where('action_code', 'finalize')
                ->where('performed_at', '>=', $from)
                ->where('performed_at', '<', $to))
            ->count();

        $inProcess = $createdInPeriod($filtered(Transaction::query()))
            ->where('is_done', false)
            ->with('state.currentStep')
            ->get();

        // Overdue: still waiting at the current station past that station's SLA.
        $now = now();
        $overdue = $inProcess->filter(function (Transaction $tx) use ($now) {
            $sla = (int) ($tx->state?->currentStep?->sla_minutes ?? 0);
            $enteredAt = $tx->state?->entered_at;

            return $sla > 0 && $enteredAt && $enteredAt->copy()->addMinutes($sla)->lt($now);
        })->count();

        $deleted = $createdInPeriod($filtered(Transaction::onlyTrashed()))->count();

        $byProcess = $createdInPeriod($filtered(Transaction::query(), withProcess: false))
            ->join('transaction_types', 'transaction_types.id', '=', 'transactions.transaction_type_id')
            ->groupBy('transaction_types.id', 'transaction_types.name')
            ->selectRaw('transaction_types.id as id, transaction_types.name as name, COUNT(*) as count')
            ->orderByDesc('count')
            ->orderBy('transaction_types.name')
            ->get()
            ->map(fn ($row) => ['id' => (int) $row->id, 'name' => $row->name, 'count' => (int) $row->count])
            ->values();

        return response()->json([
            'period' => $period,
            'completed' => $completed,
            'in_process' => $inProcess->count(),
            'overdue' => $overdue,
            'deleted' => $deleted,
            'by_process' => $byProcess,
        ]);
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

        $end = now();
        $start = $end->copy()->subWeeks(4);

        return [$start, $end, [
            'key' => 'last_4_weeks',
            'label' => 'Last 4 weeks',
            'from' => $start->copy()->setTimezone(self::TZ)->toIso8601String(),
            'to' => $end->copy()->setTimezone(self::TZ)->toIso8601String(),
        ]];
    }
}
