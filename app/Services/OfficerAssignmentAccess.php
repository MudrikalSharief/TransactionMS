<?php

namespace App\Services;

use App\Models\{Transaction, TransactionOfficerAssignment, TransactionStepRun, User};
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class OfficerAssignmentAccess
{
    /** A finalize self-loop records completion, not a new destination visit. */
    public function currentRun(Transaction $tx): ?TransactionStepRun
    {
        $stepId = DB::table('transaction_states')->where('transaction_id', $tx->id)->value('current_step_id');
        if (!$stepId) return null;

        return TransactionStepRun::query()->where('transaction_id', $tx->id)
            ->where('to_step_id', $stepId)->where('action_code', '<>', 'finalize')->latest('id')->first();
    }

    /**
     * Add only an assignment restriction, preserving the caller's ordinary scope.
     * Raw correlated subqueries deliberately avoid Transaction's global scope.
     */
    public function applyVisibility(Builder $query, User $user): Builder
    {
        $table = $query->getModel()->getTable();
        $history = "exists (select 1 from transaction_officer_assignments oa where oa.transaction_id = {$table}.id)";
        if (!$user->is_active) {
            return $query->whereRaw("not ({$history})");
        }
        if ($user->isSuperadmin() || $user->isOfficeAdmin()) return $query;
        if ($user->isViewerOnly()) return $query->whereRaw("not ({$history})");

        $currentRun = "(select max(ar.id) from transaction_step_runs ar join transaction_states ast on ast.transaction_id = ar.transaction_id where ar.transaction_id = {$table}.id and ar.to_step_id = ast.current_step_id and ar.action_code <> 'finalize')";
        $currentAssigned = "exists (select 1 from transaction_officer_assignments ca where ca.transaction_step_run_id = {$currentRun})";
        $eligible = "exists (select 1 from transaction_states es join workflow_steps ew on ew.id = es.current_step_id where es.transaction_id = {$table}.id and (case when ew.is_end_user = 1 or ew.office_id is null then {$table}.office_id else ew.office_id end is null or case when ew.is_end_user = 1 or ew.office_id is null then {$table}.office_id else ew.office_id end = ?) and exists (select 1 from step_roles sr join role_user ru on ru.role_id = sr.role_id join roles er on er.id = sr.role_id where sr.workflow_step_id = ew.id and ru.user_id = ? and er.code not in ('viewer', 'admin', 'superadmin')))";

        $assignedAccess = "({$currentAssigned} and exists (select 1 from transaction_step_runs cr where cr.id = {$currentRun} and cr.assigned_to = ?))";
        $unassignedAccess = "(not ({$currentAssigned}) and not exists (select 1 from transaction_officer_assignments excluded where excluded.transaction_id = {$table}.id and (excluded.from_user_id = ? or excluded.to_user_id = ?)) and not exists (select 1 from transaction_step_runs departed where departed.transaction_id = {$table}.id and departed.id <> {$currentRun} and departed.action_code <> 'finalize' and departed.received_by = ?))";

        return $query->whereRaw("(not ({$history}) or ({$eligible} and ({$assignedAccess} or {$unassignedAccess})))", [$user->office_id, $user->id, $user->id, $user->id, $user->id, $user->id]);
    }

    public function canAccess(Transaction $tx, User $user): bool
    {
        // This service narrows access only after a transaction's first
        // explicit assignment; all legacy authorization remains unchanged.
        if (!TransactionOfficerAssignment::where('transaction_id', $tx->id)->exists()) return true;
        if (!$user->is_active) return false;
        if ($user->isSuperadmin()) return true;
        if ($user->isOfficeAdmin()) return app(OfficeScope::class)->covers($tx, $user);

        // Hydrate no model and invoke no Transaction scope recursively.
        $probe = new \Illuminate\Database\Eloquent\Builder(DB::table('transactions'));
        $probe->setModel(new Transaction());
        return $this->applyVisibility($probe, $user)->where('transactions.id', $tx->id)->exists();
    }

    public function assertAccess(Transaction $tx, User $user): void
    {
        abort_unless($this->canAccess($tx, $user), 403, 'This transaction is assigned to another officer.');
    }

    public function canManage(Transaction $tx, User $user): bool
    {
        if (!$user->is_active) return false;
        if ($user->isSuperadmin()) return true;
        $tx->loadMissing('state.currentStep');
        $step = $tx->state?->currentStep;
        return $step && $user->isOfficeAdmin()
            && (int) $tx->effectiveStepOfficeId($step) === (int) $user->office_id;
    }

    public function canReassign(Transaction $tx, User $user): bool
    {
        if (!$this->canManage($tx, $user) || $tx->is_done || $tx->is_archive) return false;
        $run = $this->currentRun($tx);
        return $run !== null && $run->received_at !== null;
    }

    /** Active regular officers whose step role and effective office both match. */
    public function eligibleOfficers(Transaction $tx): Collection
    {
        $tx->loadMissing('state.currentStep');
        $step = $tx->state?->currentStep;
        if (!$step) return collect();
        $officeId = $tx->effectiveStepOfficeId($step);
        return User::query()->where('is_active', true)
            ->when($officeId !== null, fn ($q) => $q->where('office_id', $officeId))
            ->whereHas('roles', fn ($q) => $q->whereNotIn('code', ['viewer', 'admin', 'superadmin'])
                ->whereIn('roles.id', DB::table('step_roles')->select('role_id')->where('workflow_step_id', $step->id)))
            ->whereDoesntHave('roles', fn ($q) => $q->whereIn('code', ['admin', 'superadmin']))
            ->orderBy('name')->get(['id', 'name']);
    }

    /** Latest append-only event ID on this visit, or 0 before its first assignment. */
    public function version(?TransactionStepRun $run): int
    {
        return $run ? (int) TransactionOfficerAssignment::where('transaction_step_run_id', $run->id)->max('id') : 0;
    }

    public function history(Transaction $tx): array
    {
        return TransactionOfficerAssignment::where('transaction_id', $tx->id)->orderBy('assigned_at')->orderBy('id')
            ->get()->map(fn ($event) => $event->toEvent())->all();
    }

    public function responsibleOfficer(TransactionStepRun $run): ?array
    {
        if ($run->action_code === 'finalize') {
            $arrival = TransactionStepRun::where('transaction_id', $run->transaction_id)
                ->where('to_step_id', $run->to_step_id)->where('id', '<', $run->id)
                ->where('action_code', '<>', 'finalize')->latest('id')->first();
            if ($arrival) return $this->responsibleOfficer($arrival);
        }
        $event = TransactionOfficerAssignment::where('transaction_step_run_id', $run->id)->latest('id')->first();
        if ($event) {
            $user = $run->assigned_to ? User::find($run->assigned_to) : null;
            return ['id' => $user?->id, 'name' => $user?->name ?? $event->to_user_name];
        }
        $receiver = $run->receiver;
        return $receiver ? $receiver->only(['id', 'name']) : null;
    }

    public function metadata(Transaction $tx, ?User $user, bool $includeDetails = false): array
    {
        $run = $this->currentRun($tx);
        $data = [
            'can_reassign' => $user !== null && $this->canReassign($tx, $user),
            'run_id' => $run?->id,
            'version' => $this->version($run),
            'current_officer' => $run ? $this->responsibleOfficer($run) : null,
        ];
        if ($includeDetails) {
            $currentId = $data['current_officer']['id'] ?? null;
            $data['candidates'] = $this->eligibleOfficers($tx)->reject(fn ($u) => $u->id === $currentId)->map(fn ($u) => $u->only(['id', 'name']))->values()->all();
            $data['history'] = $this->history($tx);
        }
        return $data;
    }
}
