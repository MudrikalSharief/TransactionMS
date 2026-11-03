<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
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
            'created_by_me' => $created(Transaction::where('created_by', $user->id))->count(),
        ]);
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
