<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Office;
use App\Models\TransactionStepRun;
use App\Models\User;
use App\Services\OfficeScope;
use App\Support\ReportPeriod;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;
use Illuminate\Support\Str;

/**
 * Activity log (read-only): who did what, and when.
 *   transactions  every step run (created, forwarded, returned, finalized…)
 *                 plus its receipt, from transaction_step_runs; office admins
 *                 see their office's scope (filed by or passing through it)
 *   setup         the audit log (accounts, roles, offices, workflows…),
 *                 superadmins only
 * Nothing is written.
 */
class ActivityLogController extends Controller
{
    /** Newest rows read per source; the page shows the latest activity. */
    private const LIMIT = 3000;

    private const ACTIONS = [
        'create' => 'Created',
        'submit' => 'Forwarded',
        'approve' => 'Approved',
        'return' => 'Returned',
        'resend' => 'Resent',
        'rewind' => 'Sent back',
        'revisit' => 'Revisited',
        'finalize' => 'Finalized',
    ];

    /** Audit-log verbs as past tense ("users.update" -> "User updated"). */
    private const VERBS = [
        'create' => 'created',
        'update' => 'updated',
        'delete' => 'deleted',
        'deactivate' => 'deactivated',
        'approve' => 'approved',
        'reject' => 'rejected',
        'register' => 'registered',
        'finalize' => 'finalized',
        'reassign_office' => 'office reassigned',
        'make_live' => 'made live',
        'apply_staged' => 'changes applied',
        'save_as' => 'saved as a new version',
        'delete_draft' => 'draft deleted',
        'password' => 'password changed',
    ];

    public function __invoke(Request $request)
    {
        $data = $request->validate([
            'period' => ['nullable', ReportPeriod::RULE],
            'kind' => ['nullable', 'in:all,transactions,setup'],
            'q' => ['nullable', 'string', 'max:200'],
            'page' => ['nullable', 'integer', 'min:1'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:200'],
        ]);
        [$from, $to, $label] = ReportPeriod::resolve($data['period'] ?? 'all');
        $kind = $data['kind'] ?? 'all';
        $user = $request->user();
        $isSuperadmin = $user->isSuperadmin();

        $rows = collect();
        if ($kind !== 'setup') {
            $rows = $rows->concat($this->transactionRows($from, $to, $isSuperadmin ? null : (int) $user->office_id));
        }
        if ($kind !== 'transactions' && $isSuperadmin) {
            $rows = $rows->concat($this->setupRows($from, $to));
        }

        $q = mb_strtolower(trim($data['q'] ?? ''));
        if ($q !== '') {
            $rows = $rows->filter(fn ($r) => str_contains(mb_strtolower(implode(' ', [
                $r['action'], $r['summary'], $r['actor']['name'] ?? '', $r['reference_number'] ?? '', $r['office']['code'] ?? '', $r['remarks'] ?? '',
            ])), $q));
        }

        $rows = $rows->sortByDesc('at')->values();
        $perPage = (int) ($data['per_page'] ?? 50);
        $page = (int) ($data['page'] ?? 1);
        $paginator = new LengthAwarePaginator($rows->forPage($page, $perPage)->values(), $rows->count(), $perPage, $page);

        return response()->json([
            'period' => ['key' => $data['period'] ?? 'all', 'label' => $label],
            'can_see_setup' => $isSuperadmin,
            'data' => $paginator->items(),
            'meta' => [
                'total' => $paginator->total(),
                'per_page' => $perPage,
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    private function transactionRows($from, $to, ?int $scopeOfficeId): Collection
    {
        $runs = TransactionStepRun::query()
            ->whereHas('transaction', fn ($t) => $scopeOfficeId
                ? app(OfficeScope::class)->apply($t, $scopeOfficeId)
                : $t)
            ->when($from, fn ($q) => $q->where(fn ($w) => $w
                ->whereBetween('performed_at', [$from, $to])
                ->orWhereBetween('received_at', [$from, $to])))
            ->with([
                'transaction:id,reference_number,title,office_id,transaction_type_id',
                'transaction.office:id,code,name',
                'transaction.type:id,name',
                'fromStep:id,name',
                'toStep:id,name',
                'performer:id,name',
                'receiver:id,name',
                'receivedOffice:id,code,name',
            ])
            ->reorder()
            ->orderByDesc('performed_at')
            ->limit(self::LIMIT)
            ->get();

        $in = fn ($at) => ReportPeriod::contains($from, $to, $at);
        $out = [];
        foreach ($runs as $run) {
            $tx = $run->transaction;
            $base = [
                'kind' => 'transaction',
                'transaction_id' => $tx?->id,
                'reference_number' => $tx?->reference_number,
                'title' => $tx?->title,
                'process' => $tx?->type?->name,
            ];
            if ($in($run->performed_at)) {
                $action = self::ACTIONS[$run->action_code] ?? Str::headline((string) $run->action_code);
                $summary = match (true) {
                    $run->action_code === 'create' => "Started at {$run->toStep?->name}",
                    $run->action_code === 'finalize' => "Finished at {$run->fromStep?->name}",
                    default => trim("{$run->fromStep?->name} → {$run->toStep?->name}", ' →'),
                };
                $out[] = $base + [
                    'id' => "run-{$run->id}",
                    'at' => $run->performed_at?->toIso8601String(),
                    'action' => $action,
                    'summary' => $summary,
                    'actor' => $run->performer?->only(['id', 'name']),
                    'office' => Office::mini($tx?->office),
                    'remarks' => $run->action_code === 'create' ? null : $run->remarks,
                ];
            }
            // Forwarded papers: the receipt at the next station is its own entry.
            if ($run->action_code !== 'create' && $run->received_at && $in($run->received_at)) {
                $out[] = $base + [
                    'id' => "rcv-{$run->id}",
                    'at' => $run->received_at->toIso8601String(),
                    'action' => 'Received',
                    'summary' => "Received at {$run->toStep?->name}",
                    'actor' => $run->receiver?->only(['id', 'name']),
                    'office' => Office::mini($run->receivedOffice),
                    'remarks' => null,
                ];
            }
        }

        return collect($out);
    }

    private function setupRows($from, $to): Collection
    {
        $logs = AuditLog::query()
            ->when($from, fn ($q) => $q->whereBetween('created_at', [$from, $to]))
            ->orderByDesc('created_at')
            ->limit(self::LIMIT)
            ->get();
        $actors = User::whereIn('id', $logs->pluck('actor_user_id')->filter()->unique())->get(['id', 'name'])->keyBy('id');

        return $logs
            ->map(function (AuditLog $log) use ($actors) {
                [$entity, $verb] = array_pad(explode('.', (string) $log->event, 2), 2, '');
                $meta = is_array($log->meta) ? $log->meta : [];
                $after = is_array($meta['after'] ?? null) ? $meta['after'] : $meta;
                $name = $after['name'] ?? $after['code'] ?? $after['reference_number'] ?? $after['title'] ?? null;

                return [
                    'kind' => 'setup',
                    'id' => "log-{$log->id}",
                    'at' => $log->created_at?->toIso8601String(),
                    'action' => Str::headline(Str::singular($entity)) . ' ' . (self::VERBS[$verb] ?? Str::lower(Str::headline($verb))),
                    'summary' => $name ? (string) $name : ($log->entity_id ? '#' . $log->entity_id : ''),
                    'actor' => $actors->get($log->actor_user_id)?->only(['id', 'name']),
                    'office' => null,
                    'remarks' => null,
                    'transaction_id' => null,
                    'reference_number' => null,
                    'title' => null,
                    'process' => null,
                ];
            });
    }
}
