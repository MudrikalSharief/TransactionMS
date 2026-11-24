<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use App\Support\WorkingTime;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

/** Office-level numbers for the staff portal home page. */
class PortalController extends Controller
{
    private const TZ = 'Asia/Manila';

    /**
     * Optional `period` (the Home page's Period filter, same values as the
     * admin Dashboard): all (default), this_week or YYYY-MM. Like the admin
     * summary, Completed counts by finalize date and the rest by created date.
     */
    public function summary(Request $request)
    {
        $data = $request->validate([
            'period' => ['nullable', 'regex:/^(all|this_week|\d{4}-(0[1-9]|1[0-2]))$/'],
        ]);
        [$from, $to] = $this->range($data['period'] ?? 'all');

        $user = $request->user();
        $user->loadMissing(['roles', 'office:id,code,name,icon_path']);

        $office = Transaction::query()
            ->active()
            ->when(
                $user->office_id !== null,
                fn ($q) => $q->where('office_id', $user->office_id),
                fn ($q) => $q->whereRaw('1 = 0')
            );
        $created = fn (Builder $q) => $from ? $q->where('created_at', '>=', $from)->where('created_at', '<', $to) : $q;

        return response()->json([
            'office' => Office::mini($user->office),
            'office_total' => $created(clone $office)->count(),
            'in_process' => $created((clone $office)->where('is_done', false))->count(),
            'completed' => (clone $office)
                ->where('is_done', true)
                ->when($from, fn ($q) => $q->whereHas('runs', fn ($r) => $r
                    ->where('action_code', 'finalize')
                    ->where('performed_at', '>=', $from)
                    ->where('performed_at', '<', $to)))
                ->count(),
            'created_by_me' => $created(Transaction::query()->active()->where('created_by', $user->id))->count(),
            ...($user->roles->contains('code', 'clerk') ? ['clerk_steps' => $this->clerkSteps($user, $from, $to)] : []),
        ]);
    }

    private function clerkSteps($user, $from, $to): array
    {
        $rows = ['overdue_completed' => [], 'overdue_pending' => [], 'needs_action' => []];
        if ($user->office_id === null) return array_fill_keys(array_keys($rows), 0) + ['rows' => $rows];

        $routing = app(RoutingEngine::class);
        // Include past visits: completing a step does not require finalizing its transaction.
        $transactions = Transaction::query()->active()
            ->whereHas('runs', fn ($q) => $q->where(function ($q) use ($user) {
                $q->where('received_office_id', $user->office_id)
                    ->orWhereHas('toStep', fn ($s) => $s->where('office_id', $user->office_id))
                    ->orWhereNull('received_office_id');
            }))
            ->with(['runs.toStep.office', 'state.currentStep', 'state.currentRun', 'workflow.steps', 'workflow.stepRoles.role', 'office'])
            ->get();

        foreach ($transactions as $tx) {
            $runs = $tx->runs->sortBy('id')->values();
            $current = $runs->where('to_step_id', $tx->state?->current_step_id)
                ->where('action_code', '<>', 'finalize')->last();
            foreach ($runs as $run) {
                $step = $run->toStep;
                if (!$step || $run->action_code === 'finalize') continue;
                $officeId = $run->received_office_id ?? $tx->effectiveStepOfficeId($step);
                if ((int) $officeId !== (int) $user->office_id) continue;
                if (!$tx->workflow->stepRoles->contains(fn ($role) => (int) $role->workflow_step_id === (int) $step->id
                    && $user->roles->contains('id', $role->role_id))) continue;

                $officerId = $run->assigned_to ?? $run->received_by;
                if ($officerId !== null && (int) $officerId !== (int) $user->id) continue;
                $departure = $runs->first(fn ($next) => $next->id > $run->id && (int) $next->from_step_id === (int) $step->id);
                $isCurrent = !$tx->is_done && $current?->id === $run->id && !$departure;
                $sla = (int) ($run->sla_minutes_snapshot ?? $step->sla_minutes);
                $overdue = $run->received_at && $sla > 0
                    && WorkingTime::minutesBetween($run->received_at, $departure?->performed_at ?? now()) > $sla;
                $row = [
                    'id' => $run->id,
                    'transaction_id' => $tx->id,
                    'reference_number' => $tx->reference_number,
                    'title' => $tx->title,
                    'step_name' => $step->name,
                    'reason' => $run->action_code === 'return' ? 'Returned to you' : 'Awaiting receipt',
                ];
                if ($departure && $officerId !== null && $overdue
                    && (!$from || ($departure->performed_at >= $from && $departure->performed_at < $to))) {
                    $rows['overdue_completed'][] = $row;
                }
                if (!$isCurrent || !$routing->userCanWorkOnCurrentStep($tx, $user)) continue;
                if ($overdue) $rows['overdue_pending'][] = $row;
                if ($run->received_at === null || $run->action_code === 'return') $rows['needs_action'][] = $row;
            }
        }

        return array_map('count', $rows) + ['rows' => $rows];
    }

    /** [from, to) in UTC for the period; [null, null] for all time. */
    private function range(string $period): array
    {
        if ($period === 'all') return [null, null];

        $start = $period === 'this_week'
            ? now(self::TZ)->startOfWeek(Carbon::MONDAY)
            : Carbon::parse("{$period}-01 00:00:00", self::TZ);
        $end = $period === 'this_week' ? $start->copy()->addWeek() : $start->copy()->addMonthNoOverflow();

        return [$start->copy()->utc(), $end->copy()->utc()];
    }
}
