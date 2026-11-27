<?php

namespace App\Services;

use App\Models\{Transaction, TransactionOfficerAssignment, TransactionStepRun, User};
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Cache;

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

    /** Called inside the return transaction, after the new destination visit is created. */
    public function restoreOnReturn(Transaction $tx, TransactionStepRun $run): void
    {
        if ($run->received_at !== null || $run->officerAssignments()->exists()) return;

        $previous = TransactionStepRun::where('transaction_id', $tx->id)
            ->where('to_step_id', $run->to_step_id)->where('id', '<', $run->id)
            ->where('action_code', '<>', 'finalize')->latest('id')->first();
        $previousOfficer = $previous ? $this->responsibleOfficer($previous) : null;
        $candidate = isset($previousOfficer['id'])
            ? User::whereKey($previousOfficer['id'])->lockForUpdate()->first() : null;
        $officer = $candidate && $this->eligibleOfficers($tx, $run)->contains('id', $candidate->id)
            ? $candidate : null;
        $reason = $officer
            ? 'Automatically restored the previous officer on return.'
            : 'Previous officer unavailable. Administrator reassignment is required.';

        $run->update(['assigned_to' => $officer?->id]);
        $event = TransactionOfficerAssignment::create([
            'transaction_id' => $tx->id,
            'transaction_step_run_id' => $run->id,
            'from_user_id' => $officer ? null : ($previousOfficer['id'] ?? null),
            'from_user_name' => $officer ? null : ($previousOfficer['name'] ?? null),
            'to_user_id' => $officer?->id,
            'to_user_name' => $officer?->name ?? 'Awaiting administrator reassignment',
            'assigned_by' => null,
            'assigned_by_name' => 'System',
            'is_automatic' => true,
            'assigned_at' => now(),
            'reason' => $reason,
        ]);
        $tx->touch();
        app(AuditService::class)->log(request(), 'transactions.officer_restore', $tx, [
            'after' => ['officer' => $officer?->only(['id', 'name'])],
            'step_run_id' => $run->id,
            'source_step_run_id' => $previous?->id,
            'office_id' => $this->officeId($tx, $run),
            'assignment_id' => $event->id,
            'requires_reassignment' => $officer === null,
            'description' => $reason,
        ]);
        $this->forgetApprovalCountsAfterCommit();
    }

    public function forgetApprovalCountsAfterCommit(): void
    {
        DB::afterCommit(function () {
            User::query()->select('id')->chunkById(500, function ($users) {
                foreach ($users as $user) Cache::forget('approvals:count:u' . $user->id);
            });
        });
    }

    /**
     * Add only an assignment restriction, preserving the caller's ordinary scope.
     * Raw correlated subqueries deliberately avoid Transaction's global scope.
     */
    public function applyVisibility(Builder $query, User $user): Builder
    {
        $table = $query->getModel()->getTable();
        $history = "exists (select 1 from transaction_officer_assignments oa where oa.transaction_id = {$table}.id)";
        $manualHistory = "exists (select 1 from transaction_officer_assignments ma where ma.transaction_id = {$table}.id and ma.is_automatic = 0)";
        if (!$user->is_active) {
            return $query->whereRaw("not ({$history})");
        }
        if ($user->isSuperadmin() || $user->isOfficeAdmin()) return $query;
        if ($user->isViewerOnly()) return $query->whereRaw("not ({$history})");

        $currentRun = "(select max(ar.id) from transaction_step_runs ar join transaction_states ast on ast.transaction_id = ar.transaction_id where ar.transaction_id = {$table}.id and ar.to_step_id = ast.current_step_id and ar.action_code <> 'finalize')";
        $currentAssigned = "exists (select 1 from transaction_officer_assignments ca where ca.transaction_step_run_id = {$currentRun})";
        $eligible = "exists (select 1 from transaction_states es join workflow_steps ew on ew.id = es.current_step_id where es.transaction_id = {$table}.id and (case when ew.is_end_user = 1 or ew.office_id is null then {$table}.office_id else ew.office_id end is null or case when ew.is_end_user = 1 or ew.office_id is null then {$table}.office_id else ew.office_id end = ?) and exists (select 1 from step_roles sr join role_user ru on ru.role_id = sr.role_id join roles er on er.id = sr.role_id where sr.workflow_step_id = ew.id and ru.user_id = ? and er.code not in ('viewer', 'admin', 'superadmin')))";

        $assignedAccess = "({$currentAssigned} and exists (select 1 from transaction_step_runs cr where cr.id = {$currentRun} and cr.assigned_to = ?))";
        $unassignedAccess = "(not ({$currentAssigned}) and (not ({$manualHistory}) or (not exists (select 1 from transaction_officer_assignments excluded where excluded.transaction_id = {$table}.id and (excluded.from_user_id = ? or excluded.to_user_id = ?)) and not exists (select 1 from transaction_step_runs departed where departed.transaction_id = {$table}.id and departed.id <> {$currentRun} and departed.action_code <> 'finalize' and departed.received_by = ?))))";

        return $query->where(function ($visible) use ($history, $eligible, $assignedAccess, $unassignedAccess, $user) {
            $visible->whereRaw("(not ({$history}) or ({$eligible} and ({$assignedAccess} or {$unassignedAccess})))", [$user->office_id, $user->id, $user->id, $user->id, $user->id, $user->id])
                ->orWhere(fn ($owned) => $this->whereAssignedOffice($owned, $user));
        });
    }

    /** Explicit ownership of an office's latest visit also grants read access after handoff. */
    public function whereAssignedOffice(Builder $query, User $user): Builder
    {
        if (!$user->is_active || !$user->office_id || $user->isViewerOnly()) return $query->whereRaw('1 = 0');
        $table = $query->getModel()->getTable();
        $office = $this->runOfficeSql('owned', 'owned_step', $table);
        $laterOffice = $this->runOfficeSql('later', 'later_step', $table);
        return $query->whereExists(function ($owned) use ($table, $user, $office, $laterOffice) {
            $owned->selectRaw('1')->from('transaction_step_runs as owned')
                ->join('workflow_steps as owned_step', 'owned_step.id', '=', 'owned.to_step_id')
                ->whereColumn('owned.transaction_id', "$table.id")
                ->where('owned.action_code', '<>', 'finalize')
                ->where('owned.assigned_to', $user->id)
                ->whereRaw("$office = ?", [$user->office_id])
                ->whereExists(fn ($events) => $events->selectRaw('1')->from('transaction_officer_assignments as owned_event')
                    ->whereColumn('owned_event.transaction_step_run_id', 'owned.id'))
                ->whereExists(fn ($roles) => $roles->selectRaw('1')->from('step_roles as owned_role')
                    ->join('role_user as owned_user_role', 'owned_user_role.role_id', '=', 'owned_role.role_id')
                    ->join('roles as owned_role_definition', 'owned_role_definition.id', '=', 'owned_role.role_id')
                    ->whereColumn('owned_role.workflow_step_id', 'owned.to_step_id')
                    ->where('owned_user_role.user_id', $user->id)
                    ->whereNotIn('owned_role_definition.code', ['viewer', 'admin', 'superadmin']))
                ->whereNotExists(fn ($later) => $later->selectRaw('1')->from('transaction_step_runs as later')
                    ->join('workflow_steps as later_step', 'later_step.id', '=', 'later.to_step_id')
                    ->whereColumn('later.transaction_id', 'owned.transaction_id')
                    ->whereColumn('later.id', '>', 'owned.id')
                    ->where('later.action_code', '<>', 'finalize')
                    ->whereRaw("$laterOffice = $office"));
        });
    }

    private function runOfficeSql(string $run, string $step, string $transaction): string
    {
        return "COALESCE($run.received_office_id, CASE WHEN $step.is_end_user = 1 OR $step.office_id IS NULL THEN $transaction.office_id ELSE $step.office_id END)";
    }

    public function hasOfficeAssignment(Transaction $tx, User $user): bool
    {
        return $this->whereAssignedOffice(Transaction::withoutGlobalScopes(), $user)->whereKey($tx->id)->exists();
    }

    public function officeId(Transaction $tx, TransactionStepRun $run): ?int
    {
        return $run->received_office_id ?? ($run->toStep ? $tx->effectiveStepOfficeId($run->toStep) : null);
    }

    /** One latest destination visit per office, including a pending return. */
    public function officeVisits(Transaction $tx, User $user): Collection
    {
        if (!$user->is_active || (!$user->isSuperadmin() && !$user->isOfficeAdmin())) return collect();
        $tx->loadMissing(['runs.toStep.office', 'state.currentStep']);
        return $tx->runs->where('action_code', '<>', 'finalize')->filter(fn ($run) => $run->toStep !== null)
            ->sortByDesc('id')->unique(fn ($run) => $this->officeId($tx, $run) ?? 'legacy')
            ->filter(fn ($run) => $user->isSuperadmin() || ($user->office_id !== null && $this->officeId($tx, $run) === (int) $user->office_id))
            ->values();
    }

    private function visitCanBeAssigned(Transaction $tx, TransactionStepRun $run): bool
    {
        if ($run->received_at !== null) return true;
        if ((int) $run->to_step_id !== (int) $tx->state?->current_step_id) return false;
        if ($run->officerAssignments()->exists()) return true;
        return $tx->runs->contains(fn ($previous) => $previous->id < $run->id
            && $previous->action_code !== 'finalize' && $previous->received_at !== null
            && $this->officeId($tx, $previous) === $this->officeId($tx, $run));
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
        return $user->is_active && ($user->isSuperadmin() || $this->officeVisits($tx, $user)->isNotEmpty());
    }

    public function canReassign(Transaction $tx, User $user, ?TransactionStepRun $run = null): bool
    {
        if ($tx->is_done || $tx->is_archive) return false;

        $current = $this->currentRun($tx);

        return $this->officeVisits($tx, $user)->contains(function ($visit) use ($tx, $user, $run, $current) {
            if ($run !== null && $visit->id !== $run->id) return false;

            // Office admins manage only work currently parked at their
            // office; a visit that already moved on cannot be reassigned.
            // Superadmins may still transfer a past visit.
            if (!$user->isSuperadmin() && ($current === null || $visit->id !== $current->id)) {
                return false;
            }

            return $this->visitCanBeAssigned($tx, $visit);
        });
    }

    /** Active regular officers whose step role and effective office both match. */
    public function eligibleOfficers(Transaction $tx, ?TransactionStepRun $run = null): Collection
    {
        $tx->loadMissing('state.currentStep');
        $step = $run ? $run->toStep : $tx->state?->currentStep;
        if (!$step) return collect();
        $officeId = $run ? $this->officeId($tx, $run) : $tx->effectiveStepOfficeId($step);
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
            ->with(['stepRun.toStep.office', 'stepRun.receivedOffice'])
            ->get()->map(function ($event) use ($tx) {
                $run = $event->stepRun;
                $office = $run?->receivedOffice ?? ($run?->toStep ? $tx->displayStepOffice($run->toStep) : null);
                return array_merge($event->toEvent(), [
                    'office' => $office?->only(['id', 'code', 'name']),
                    'step' => $run?->toStep?->only(['id', 'order_number', 'name']),
                ]);
            })->all();
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

    public function metadata(Transaction $tx, ?User $user, bool $includeDetails = false, ?int $runId = null): array
    {
        $visits = $user ? $this->officeVisits($tx, $user) : collect();
        $current = $this->currentRun($tx);
        $run = $runId !== null
            ? $visits->firstWhere('id', $runId)
            : ($user?->isOfficeAdmin()
                // Office admins always see the paper's actual current visit,
                // never a departed visit from their own office.
                ? ($visits->firstWhere('id', $current?->id) ?? $current ?? $visits->first())
                : ($visits->first(fn ($visit) => $visit->id === $current?->id && $this->canReassign($tx, $user, $visit))
                    ?? $visits->first(fn ($visit) => $this->canReassign($tx, $user, $visit))
                    ?? $visits->first() ?? $current));
        $data = [
            'can_reassign' => $user !== null && $run !== null && $this->canReassign($tx, $user, $run),
            'run_id' => $run?->id,
            'version' => $this->version($run),
            'current_officer' => $run ? $this->responsibleOfficer($run) : null,
            'office' => $run ? \App\Models\Office::find($this->officeId($tx, $run))?->only(['id', 'code', 'name']) : null,
            'step' => $run?->toStep?->only(['id', 'order_number', 'name']),
            'is_pending' => $run !== null && $run->received_at === null,
            'is_current' => $run !== null && $run->id === $current?->id,
        ];
        // Office admins may view and reassign other officers' work, but the
        // action UI stays hidden unless the current visit is unassigned or
        // theirs. Other roles keep their existing action gates.
        $data['can_act'] = true;
        if ($user?->isOfficeAdmin()) {
            $step = $tx->state?->currentStep;
            $stepOfficeId = $step ? $tx->effectiveStepOfficeId($step) : null;
            $ownerId = $run?->assigned_to ?? $run?->received_by;

            $data['can_act'] = !$tx->is_done
                && !$tx->is_archive
                && $run !== null
                && $data['is_current']
                && $stepOfficeId !== null
                && (int) $stepOfficeId === (int) $user->office_id
                && ($ownerId === null || (int) $ownerId === (int) $user->id);
        }

        $data['requires_reassignment'] = $data['is_pending'] && $data['version'] > 0 && $run->assigned_to === null;
        if ($includeDetails) {
            $offices = \App\Models\Office::whereIn('id', $visits->map(fn ($visit) => $this->officeId($tx, $visit))->filter())->get()->keyBy('id');
            $currentId = $data['current_officer']['id'] ?? null;
            $data['candidates'] = $this->eligibleOfficers($tx, $run)->reject(fn ($u) => $u->id === $currentId)->map(fn ($u) => $u->only(['id', 'name']))->values()->all();
            $data['history'] = $this->history($tx);
            $data['visits'] = $visits->filter(fn ($visit) => $this->canReassign($tx, $user, $visit))->map(fn ($visit) => [
                'id' => $visit->id,
                'label' => ($offices->get($this->officeId($tx, $visit))?->code ?? 'Originating office') . ' · Step ' . $visit->toStep?->order_number . ' · ' . $visit->toStep?->name,
            ])->values()->all();
        }
        return $data;
    }
}
