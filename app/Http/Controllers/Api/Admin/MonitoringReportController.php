<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
use App\Services\OfficeScope;
use App\Support\ReportPeriod;
use App\Support\WorkingTime;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;

/**
 * Monitoring report (superadmin, or an office admin for their office's
 * scope): read-only figures worked out from the existing transactions
 * and step runs. Nothing is written.
 *
 *   by_office / by_process  filed, completed, in process, overdue, average
 *                           completion time (working minutes)
 */
class MonitoringReportController extends Controller
{
    public function __invoke(Request $request)
    {
        $data = $request->validate([
            'period' => ['nullable', ReportPeriod::RULE],
            'offices' => ['nullable', 'array'],
            'offices.*' => ['integer'],
        ]);
        [$from, $to, $label] = ReportPeriod::resolve($data['period'] ?? 'all');
        $in = fn ($at) => ReportPeriod::contains($from, $to, $at);

        $user = $request->user();
        $scopeOfficeId = $user->isSuperadmin() ? null : (int) $user->office_id;
        $offices = array_map('intval', $data['offices'] ?? []);

        $txs = Transaction::query()
            ->when($scopeOfficeId, fn ($q) => app(OfficeScope::class)->apply($q, $scopeOfficeId))
            ->when($offices, fn ($q) => $q->whereIn('transactions.office_id', $offices))
            // A period only needs what was filed or moved in it, plus open papers.
            ->when($from, fn ($q) => $q->where(fn ($w) => $w
                ->where('is_done', false)
                ->orWhereBetween('created_at', [$from, $to])
                ->orWhereHas('runs', fn ($r) => $r->whereBetween('performed_at', [$from, $to]))))
            ->with([
                'type:id,name',
                'office:id,code,name',
                'state.currentStep',
                'state.currentRun',
                // Oldest first (the relation itself sorts newest first).
                'runs' => fn ($r) => $r->reorder()->orderBy('performed_at')->orderBy('id'),
            ])
            ->get();

        $now = now();

        return response()->json([
            'period' => ['key' => $data['period'] ?? 'all', 'label' => $label],
            'generated_at' => $now->toIso8601String(),
            'totals' => $this->counts($txs, $in, $now),
            'by_office' => $this->grouped($txs, fn ($tx) => $tx->office_id, fn ($tx) => Office::mini($tx->office), $in, $now),
            'by_process' => $this->grouped($txs, fn ($tx) => $tx->transaction_type_id, fn ($tx) => $tx->type?->only(['id', 'name']), $in, $now),
        ]);
    }

    // ---- counts ---------------------------------------------------------

    private function finalizedAt(Transaction $tx)
    {
        return $tx->runs->where('action_code', 'finalize')->last()?->performed_at;
    }

    private function overdue(Transaction $tx, $now): bool
    {
        if ($tx->is_done) return false;
        $run = $tx->state?->currentVisit();
        $sla = (int) ($run?->sla_minutes_snapshot ?: $tx->state?->currentStep?->sla_minutes ?? 0);
        $startedAt = $run?->received_at;

        return $sla > 0 && $startedAt && WorkingTime::minutesBetween($startedAt, $now) > $sla;
    }

    /** Filed and in process by created date, completed by finalize date (same as the dashboards). */
    private function counts(Collection $txs, callable $in, $now): array
    {
        $filed = $txs->filter(fn ($tx) => $in($tx->created_at));
        $open = $filed->where('is_done', false);
        $completed = $txs->filter(fn ($tx) => $tx->is_done && $in($this->finalizedAt($tx)));
        $durations = $completed
            ->map(fn ($tx) => WorkingTime::minutesBetween($tx->created_at, $this->finalizedAt($tx)))
            ->filter(fn ($m) => $m !== null);

        return [
            'filed' => $filed->count(),
            'completed' => $completed->count(),
            'in_process' => $open->count(),
            'pending' => $open->filter(function ($tx) {
                $run = $tx->state?->currentVisit();
                return $run && $run->received_at === null;
            })->count(),
            'working' => $open->filter(fn ($tx) => $tx->state?->currentVisit()?->received_at !== null)->count(),
            'overdue' => $open->filter(fn ($tx) => $this->overdue($tx, $now))->count(),
            'avg_completion_minutes' => $durations->count() ? (int) round($durations->avg()) : null,
        ];
    }

    private function grouped(Collection $txs, callable $key, callable $label, callable $in, $now): array
    {
        return $txs->groupBy($key)
            ->map(fn (Collection $group) => ['item' => $label($group->first())] + $this->counts($group, $in, $now))
            ->filter(fn ($row) => $row['filed'] || $row['completed'])
            ->sortByDesc('filed')
            ->values()
            ->all();
    }
}
