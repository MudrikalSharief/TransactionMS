<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\{Transaction, TransactionOfficerAssignment, User};
use App\Services\{AuditService, OfficerAssignmentAccess};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\ValidationException;

class OfficerReassignmentController extends Controller
{
    public function show(Transaction $transaction, Request $request, OfficerAssignmentAccess $access)
    {
        abort_unless($access->canManage($transaction, $request->user()), 403, 'Only the current office administrator can reassign this officer.');
        return response()->json(['data' => $access->metadata($transaction, $request->user(), true)]);
    }

    public function store(Transaction $transaction, Request $request, OfficerAssignmentAccess $access, AuditService $audit)
    {
        abort_unless($access->canManage($transaction, $request->user()), 403, 'Only the current office administrator can reassign this officer.');
        $data = $request->validate([
            'run_id' => ['required', 'integer', 'min:1'],
            'version' => ['required', 'integer', 'min:0'],
            'assigned_to' => ['required', 'integer', 'min:1'],
            'reason' => ['required', 'string', 'max:1000'],
        ]);
        $reason = trim($data['reason']);
        if ($reason === '') throw ValidationException::withMessages(['reason' => 'A reassignment reason is required.']);

        return DB::transaction(function () use ($transaction, $request, $access, $audit, $data, $reason) {
            // Routing/receipt/finalization use the same transaction-row lock.
            $tx = Transaction::query()->whereKey($transaction->id)->lockForUpdate()->firstOrFail();
            $tx->load('state.currentStep');
            abort_unless($access->canManage($tx, $request->user()), 403, 'Only the current office administrator can reassign this officer.');
            $run = $access->currentRun($tx);
            abort_if(!$run || (int) $data['run_id'] !== (int) $run->id || (int) $data['version'] !== $access->version($run), 409, 'The current step or officer changed. Reload before reassigning.');
            abort_unless($access->canReassign($tx, $request->user()), 422, 'Only an active, received step can be reassigned.');

            // Lock the target account and recheck eligibility; do not trust the dialog's candidate list.
            $target = User::query()->whereKey($data['assigned_to'])->lockForUpdate()->first();
            if (!$target || !$access->eligibleOfficers($tx)->contains('id', $target->id)) {
                throw ValidationException::withMessages(['assigned_to' => 'Choose an active eligible officer in the current step office.']);
            }
            $previous = $access->responsibleOfficer($run);
            if ((int) ($previous['id'] ?? 0) === (int) $target->id) {
                throw ValidationException::withMessages(['assigned_to' => 'This officer is already responsible for this step.']);
            }
            $run->update(['assigned_to' => $target->id]);
            $tx->touch();
            $event = TransactionOfficerAssignment::create([
                'transaction_id' => $tx->id,
                'transaction_step_run_id' => $run->id,
                'from_user_id' => $previous['id'] ?? null,
                'from_user_name' => $previous['name'] ?? null,
                'to_user_id' => $target->id,
                'to_user_name' => $target->name,
                'assigned_by' => $request->user()->id,
                'assigned_by_name' => $request->user()->name,
                'assigned_at' => now(),
                'reason' => $reason,
            ]);
            $audit->log($request, 'transactions.officer_reassign', $tx, [
                'before' => ['officer' => $previous],
                'after' => ['officer' => $target->only(['id', 'name'])],
                'step_run_id' => $run->id,
                'reason' => $reason,
                'assignment_id' => $event->id,
                'description' => 'Reassigned the responsible officer for the current received step.',
            ]);
            // Cached inbox counts predate the now-exclusive ownership. Clear
            // every active account's short-lived count after a committed transfer.
            DB::afterCommit(function () {
                User::query()->select('id')->chunkById(500, function ($users) {
                    foreach ($users as $user) Cache::forget('approvals:count:u' . $user->id);
                });
            });
            return response()->json(['data' => $access->metadata($tx, $request->user(), true)]);
        });
    }
}
