<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\{Transaction, TransactionOfficerAssignment, User};
use App\Services\{AuditService, OfficerAssignmentAccess};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OfficerReassignmentController extends Controller
{
    public function show(Transaction $transaction, Request $request, OfficerAssignmentAccess $access)
    {
        abort_unless($access->canManage($transaction, $request->user()), 403, 'Only an authorized office administrator can reassign this officer.');
        $data = $request->validate(['run_id' => ['nullable', 'integer', 'min:1']]);
        $runId = isset($data['run_id']) ? (int) $data['run_id'] : null;
        if ($runId !== null) {
            abort_unless($access->officeVisits($transaction, $request->user())->contains('id', $runId), 403, 'Choose a visit managed by your office.');
        }
        return response()->json(['data' => $access->metadata($transaction, $request->user(), true, $runId)]);
    }

    public function store(Transaction $transaction, Request $request, OfficerAssignmentAccess $access, AuditService $audit)
    {
        abort_unless($access->canManage($transaction, $request->user()), 403, 'Only an authorized office administrator can reassign this officer.');
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
            abort_unless($access->canManage($tx, $request->user()), 403, 'Only an authorized office administrator can reassign this officer.');
            $run = $tx->runs()->with('toStep.office')->find($data['run_id']);
            abort_if(!$run, 409, 'The office visit changed. Reload before reassigning.');
            abort_unless($request->user()->isSuperadmin() || $access->officeId($tx, $run) === (int) $request->user()->office_id, 403, 'Choose a visit managed by your office.');
            abort_if(!$access->officeVisits($tx, $request->user())->contains('id', $run->id) || (int) $data['version'] !== $access->version($run), 409, 'The office visit or officer changed. Reload before reassigning.');
            abort_unless($access->canReassign($tx, $request->user(), $run), 422, 'Only an active received visit or pending return can be reassigned.');

            // Lock the target account and recheck eligibility; do not trust the dialog's candidate list.
            $target = User::query()->whereKey($data['assigned_to'])->lockForUpdate()->first();
            if (!$target || !$access->eligibleOfficers($tx, $run)->contains('id', $target->id)) {
                throw ValidationException::withMessages(['assigned_to' => 'Choose an active eligible officer in the selected office.']);
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
                'description' => 'Reassigned the responsible officer for the selected office visit.',
            ]);
            // Cached inbox counts predate the now-exclusive ownership. Clear
            // every active account's short-lived count after a committed transfer.
            $access->forgetApprovalCountsAfterCommit();
            $tx->unsetRelation('runs');
            return response()->json(['data' => $access->metadata($tx, $request->user(), true, $run->id)]);
        });
    }
}
