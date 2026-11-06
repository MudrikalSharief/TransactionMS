<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
use App\Models\WorkflowStep;
use App\Services\OfficeScope;
use App\Support\ReportPeriod;
use App\Support\WorkingTime;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;

/**
 * Monitoring report (superadmin, or an office admin for their office's
 * scope): read-only figures worked out from the existing transactions,
 * step runs, requirement checks and attachments. Nothing is written.
 *
 *   by_office / by_process  filed, completed, in process, overdue, average
 *                           completion time (working minutes)
 *   steps                   time spent at each station (bottlenecks)
 *   requirements            required items still missing on open papers
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
                'workflow.steps.office:id,code,name',
                'workflow.stepRoles.role',
                // Oldest first (the relation itself sorts newest first).
                'runs' => fn ($r) => $r->reorder()->orderBy('performed_at')->orderBy('id'),
                'requirementChecks:id,transaction_id,workflow_step_id,requirement_definition_id',
                'attachments:id,transaction_id,workflow_step_id,requirement_definition_id',
            ])
            ->get();

        $now = now();

        return response()->json([
            'period' => ['key' => $data['period'] ?? 'all', 'label' => $label],
            'generated_at' => $now->toIso8601String(),
            'totals' => $this->counts($txs, $in, $now),
            'by_office' => $this->grouped($txs, fn ($tx) => $tx->office_id, fn ($tx) => Office::mini($tx->office), $in, $now),
            'by_process' => $this->grouped($txs, fn ($tx) => $tx->transaction_type_id, fn ($tx) => $tx->type?->only(['id', 'name']), $in, $now),
            'steps' => $this->steps($txs, $in, $now),
            'requirements' => $this->requirements($txs, $in),
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
        $sla = (int) ($tx->state?->currentStep?->sla_minutes ?? 0);
        $enteredAt = $tx->state?->entered_at;

        return $sla > 0 && $enteredAt && WorkingTime::minutesBetween($enteredAt, $now) > $sla;
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

    // ---- time per station (bottlenecks) --------------------------------

    /**
     * Each run moves a paper into a station (to_step); the next run moves it
     * out. Time at the station = working minutes between the two. Visits
     * that ended in the period are averaged; papers still at a station count
     * as "waiting now". Receipt time = sent until received there.
     */
    private function steps(Collection $txs, callable $in, $now): array
    {
        $rows = [];
        foreach ($txs as $tx) {
            $steps = $tx->workflow?->steps?->keyBy('id') ?? collect();
            $runs = $tx->runs->values();
            foreach ($runs as $i => $run) {
                $step = $steps->get($run->to_step_id);
                if (!$step) continue;
                $next = $runs->get($i + 1);
                if (!$next && $tx->is_done) continue;

                $leftAt = $next?->performed_at;
                if ($next && !$in($leftAt)) continue;

                $office = $tx->effectiveStepOffice($step);
                $key = implode('|', [$tx->type?->name, $step->name, $office?->id]);
                $rows[$key] ??= [
                    'process' => $tx->type?->name,
                    'step' => $step->name,
                    'office' => Office::mini($office),
                    'sla_minutes' => (int) ($step->sla_minutes ?? 0),
                    'handled' => 0,
                    'wait_total' => 0,
                    'max_wait_minutes' => 0,
                    'over_limit' => 0,
                    'waiting_now' => 0,
                    'receipt_total' => 0,
                    'receipt_count' => 0,
                ];
                $r = &$rows[$key];
                $sla = (int) ($run->sla_minutes_snapshot ?: $step->sla_minutes ?: 0);
                $wait = WorkingTime::minutesBetween($run->performed_at, $leftAt ?? $now);

                if ($next) {
                    $r['handled']++;
                    $r['wait_total'] += $wait;
                    $r['max_wait_minutes'] = max($r['max_wait_minutes'], $wait);
                } else {
                    $r['waiting_now']++;
                }
                if ($sla > 0 && $wait > $sla) $r['over_limit']++;
                if ($run->action_code !== 'create' && $run->received_at) {
                    $r['receipt_total'] += WorkingTime::minutesBetween($run->performed_at, $run->received_at);
                    $r['receipt_count']++;
                }
                unset($r);
            }
        }

        return collect($rows)
            ->map(function ($r) {
                $visits = $r['handled'] + $r['waiting_now'];

                return [
                    'process' => $r['process'],
                    'step' => $r['step'],
                    'office' => $r['office'],
                    'sla_minutes' => $r['sla_minutes'],
                    'handled' => $r['handled'],
                    'waiting_now' => $r['waiting_now'],
                    'avg_wait_minutes' => $r['handled'] ? (int) round($r['wait_total'] / $r['handled']) : null,
                    'max_wait_minutes' => $r['handled'] ? $r['max_wait_minutes'] : null,
                    'avg_receipt_minutes' => $r['receipt_count'] ? (int) round($r['receipt_total'] / $r['receipt_count']) : null,
                    'over_limit' => $r['over_limit'],
                    'over_limit_pct' => $visits ? (int) round(100 * $r['over_limit'] / $visits) : 0,
                ];
            })
            // Worst first: most visits over the limit, then most papers
            // waiting there now, then the longest average stay.
            ->sortByDesc(fn ($r) => [$r['over_limit'], $r['waiting_now'], $r['avg_wait_minutes'] ?? -1])
            ->values()
            ->all();
    }

    // ---- missing requirements ------------------------------------------

    /**
     * Open papers filed in the period: required items at their current
     * station that are not complete yet (physical copy not ticked, or no
     * file attached), the same rule that blocks Proceed.
     */
    private function requirements(Collection $txs, callable $in): array
    {
        $required = [];
        $rows = [];
        foreach ($txs as $tx) {
            if ($tx->is_done || !$in($tx->created_at)) continue;
            $step = $tx->state?->currentStep;
            if (!$step instanceof WorkflowStep) continue;

            $required[$step->id] ??= $step->requirementDefinitions()
                ->wherePivot('is_required', true)
                ->get(['requirement_definitions.id', 'requirement_definitions.name', 'requirement_definitions.label']);

            $ticked = $tx->requirementChecks->where('workflow_step_id', $step->id)->pluck('requirement_definition_id')->map(fn ($id) => (int) $id);
            $filed = $tx->attachments->where('workflow_step_id', $step->id)->pluck('requirement_definition_id')->filter()->map(fn ($id) => (int) $id);

            foreach ($required[$step->id] as $req) {
                $noTick = !$ticked->contains((int) $req->id);
                $noFile = !$filed->contains((int) $req->id);
                if (!$noTick && !$noFile) continue;

                $name = $req->label ?: $req->name;
                $key = implode('|', [$tx->type?->name, $step->name, $name]);
                $rows[$key] ??= [
                    'requirement' => $name,
                    'process' => $tx->type?->name,
                    'step' => $step->name,
                    'office' => Office::mini($tx->effectiveStepOffice($step)),
                    'transactions' => 0,
                    'not_checked' => 0,
                    'no_file' => 0,
                ];
                $rows[$key]['transactions']++;
                if ($noTick) $rows[$key]['not_checked']++;
                if ($noFile) $rows[$key]['no_file']++;
            }
        }

        return collect($rows)->sortByDesc('transactions')->values()->all();
    }
}
