<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
use App\Models\TransactionStepRun;
use App\Services\RoutingEngine;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

/** Office-level numbers for the staff portal home page. */
class PortalController extends Controller
{
    private const TZ = 'Asia/Manila';

    /**
     * Optional `period` (the Home page's Period filter, same values as the
     * admin Dashboard): all (default), today, this_week or YYYY-MM. Like the
     * admin summary, Completed counts by finalize date and the rest by
     * created date.
     */
    public function summary(Request $request)
    {
        $data = $request->validate([
            'period' => ['nullable', 'regex:/^(all|today|this_week|\d{4}-(0[1-9]|1[0-2]))$/'],
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
            'step_metrics' => $this->stepMetrics($user, $from, $to),
            'needs_action' => $this->needsAction($user),
        ]);
    }

    /** Step activity, open work, and forward releases in the selected Period. */
    private function stepMetrics($user, $from, $to): array
    {
        $empty = ['received' => 0, 'entered' => 0, 'overdue_work' => 0, 'released' => 0];
        if ($user->office_id === null) return $empty;

        $received = TransactionStepRun::query()
            ->where('received_by', $user->id)
            ->where('action_code', '<>', 'finalize')
            ->when($from, fn (Builder $q) => $q
                ->where('received_at', '>=', $from)
                ->where('received_at', '<', $to))
            ->whereHas('transaction', fn (Builder $q) => $q
                ->withoutGlobalScope('officer_assignment')
                ->active())
            ->count();

        $roleIds = $user->roles->pluck('id')->map(fn ($id) => (int) $id)->all();
        $entered = 0;
        if ($roleIds) {
            $entered = TransactionStepRun::query()
                ->when($from, fn (Builder $q) => $q
                    ->where('performed_at', '>=', $from)
                    ->where('performed_at', '<', $to))
                ->where('action_code', '<>', 'finalize')
                ->whereHas('transaction', fn (Builder $q) => $q
                    ->withoutGlobalScope('officer_assignment')
                    ->active())
                ->whereHas('toStep.roles', fn (Builder $q) => $q->whereIn('roles.id', $roleIds))
                ->with([
                    'toStep' => fn ($q) => $q->select(['id', 'office_id', 'is_end_user']),
                    'transaction:id,office_id,workflow_definition_id',
                ])
                ->get()
                ->filter(function (TransactionStepRun $run) use ($user) {
                    $step = $run->toStep;
                    $tx = $run->transaction;
                    if (!$step || !$tx) return false;
                    $officeId = $run->received_office_id ?? $tx->effectiveStepOfficeId($step);

                    return (int) $officeId === (int) $user->office_id;
                })
                ->count();
        }

        // Every open step the user currently holds, received inside the Period:
        // overdue visits and visits still inside their limit both count.
        $overdueWork = Transaction::query()
            ->withoutGlobalScope('officer_assignment')
            ->active()
            ->where('is_done', false)
            ->whereHas('state.currentRun', function (Builder $q) use ($user, $from, $to) {
                $q->whereNotNull('received_at')
                    ->when($from, fn (Builder $w) => $w
                        ->where('received_at', '>=', $from)
                        ->where('received_at', '<', $to))
                    ->where(function (Builder $w) use ($user) {
                        $w->where('assigned_to', $user->id)
                            ->orWhere(fn (Builder $x) => $x
                                ->whereNull('assigned_to')
                                ->where('received_by', $user->id));
                    });
            })
            ->count();

        // Forward "Proceed" actions the user actually performed in the
        // selected Period. Creating, returning, resending, and finalizing are
        // separate actions and do not count as released steps.
        $released = TransactionStepRun::query()
            ->where('performed_by', $user->id)
            ->whereNotIn('action_code', ['create', 'return', 'resend', 'finalize'])
            ->when($from, fn (Builder $q) => $q
                ->where('performed_at', '>=', $from)
                ->where('performed_at', '<', $to))
            ->whereHas('transaction', fn (Builder $q) => $q
                ->withoutGlobalScope('officer_assignment'))
            ->count();

        return [
            'received' => $received,
            'entered' => $entered,
            'overdue_work' => $overdueWork,
            'released' => $released,
        ];
    }

    /**
     * Current steps this user can act on: received work still to release,
     * returns assigned to them, and arrivals at their office for their role.
     */
    private function needsAction($user): array
    {
        if ($user->office_id === null) return ['count' => 0, 'rows' => []];

        $rows = [];
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
                if (!$isCurrent || !$routing->userCanWorkOnCurrentStep($tx, $user)) continue;

                $reason = $run->action_code === 'return'
                    ? 'Return assigned to you'
                    : ($run->received_at === null ? 'Awaiting receipt' : 'Received — ready to release');
                $action = $run->action_code === 'return'
                    ? 'return'
                    : ($run->received_at === null ? 'receive' : 'release');

                $rows[] = [
                    'id' => $run->id,
                    'transaction_id' => $tx->id,
                    'reference_number' => $tx->reference_number,
                    'title' => $tx->title,
                    'step_name' => $step->name,
                    'reason' => $reason,
                    'action' => $action,
                ];
            }
        }

        return ['count' => count($rows), 'rows' => $rows];
    }

    /** [from, to) in UTC for the period; [null, null] for all time. */
    private function range(string $period): array
    {
        if ($period === 'all') return [null, null];

        if ($period === 'today') {
            $start = now(self::TZ)->startOfDay();
            $end = $start->copy()->addDay();
        } elseif ($period === 'this_week') {
            $start = now(self::TZ)->startOfWeek(Carbon::MONDAY);
            $end = $start->copy()->addWeek();
        } else {
            $start = Carbon::parse("{$period}-01 00:00:00", self::TZ);
            $end = $start->copy()->addMonthNoOverflow();
        }

        return [$start->copy()->utc(), $end->copy()->utc()];
    }
}
