<?php

namespace App\Console\Commands;

use App\Models\Transaction;
use App\Models\WorkflowDefinition;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class PruneUnusedWorkflows extends Command
{
    protected $signature = 'workflow:prune-unused
        {--execute : Actually delete (soft-delete by default). Without this flag only a dry-run report is shown.}
        {--force : Force-delete (hard delete) instead of soft-delete. Requires --execute.}
        {--workflow= : Comma-separated workflow_definition IDs to limit cleanup to.}
        {--include-trashed-workflows : Also consider soft-deleted workflow definitions as candidates.}';

    protected $description = 'Delete workflow_routes + workflow_steps whose whole workflow_definition has zero transactions (trashed transactions still protect).';

    public function handle(): int
    {
        $execute = (bool) $this->option('execute');
        $force = (bool) $this->option('force');
        $includeTrashedWorkflows = (bool) $this->option('include-trashed-workflows');

        if ($force && ! $execute) {
            $this->warn('--force has no effect without --execute. Showing dry-run only.');
        }

        $query = $includeTrashedWorkflows
            ? WorkflowDefinition::withTrashed()
            : WorkflowDefinition::query();

        if ($this->option('workflow')) {
            $ids = collect(explode(',', (string) $this->option('workflow')))
                ->map(fn ($v) => (int) trim($v))
                ->filter(fn ($v) => $v > 0)
                ->unique()
                ->values()
                ->all();
            $query->whereIn('id', $ids);
        }

        $definitions = $query->orderBy('id')->get();

        if ($definitions->isEmpty()) {
            $this->info('No workflow definitions found.');
            return self::SUCCESS;
        }

        $rows = [];
        $candidates = [];

        foreach ($definitions as $wd) {
            // Trashed transactions still protect (per requirement).
            $txCount = Transaction::withTrashed()
                ->where('workflow_definition_id', $wd->id)
                ->count();

            // Orphan runtime refs left by manual DB deletes (FKs may have been bypassed).
            // If any exist, block this workflow even when tx count is 0.
            $stepIds = DB::table('workflow_steps')
                ->where('workflow_definition_id', $wd->id)
                ->pluck('id')
                ->all();

            $orphanRefs = 0;
            if (! empty($stepIds)) {
                $orphanRefs += DB::table('transaction_states')->whereIn('current_step_id', $stepIds)->count();
                $orphanRefs += DB::table('transaction_step_runs')->whereIn('from_step_id', $stepIds)->count();
                $orphanRefs += DB::table('transaction_step_runs')->whereIn('to_step_id', $stepIds)->count();
                if (DB::getSchemaBuilder()->hasTable('transaction_attachments')) {
                    $orphanRefs += DB::table('transaction_attachments')->whereIn('workflow_step_id', $stepIds)->count();
                }
                if (DB::getSchemaBuilder()->hasTable('transaction_requirement_checks')) {
                    $orphanRefs += DB::table('transaction_requirement_checks')->whereIn('workflow_step_id', $stepIds)->count();
                }
                if (DB::getSchemaBuilder()->hasTable('transaction_checklist_checks')) {
                    $orphanRefs += DB::table('transaction_checklist_checks')->whereIn('workflow_step_id', $stepIds)->count();
                }
            }

            $stepsCount = DB::table('workflow_steps')
                ->where('workflow_definition_id', $wd->id)
                ->whereNull('deleted_at')
                ->count();
            $routesCount = DB::table('workflow_routes')
                ->where('workflow_definition_id', $wd->id)
                ->whereNull('deleted_at')
                ->count();

            $status = 'candidate';
            if ($txCount > 0) {
                $status = "protected ({$txCount} tx incl. trashed)";
            } elseif ($orphanRefs > 0) {
                $status = "blocked ({$orphanRefs} orphan runtime refs)";
            } elseif ($stepsCount === 0 && $routesCount === 0) {
                $status = 'nothing to delete';
            }

            $rows[] = [
                $wd->id,
                $wd->version ?? '-',
                $wd->status ?? '-',
                $wd->trashed() ? 'trashed' : 'active',
                $txCount,
                $stepsCount,
                $routesCount,
                $status,
            ];

            if ($status === 'candidate' && ($stepsCount > 0 || $routesCount > 0)) {
                $candidates[] = $wd;
            }
        }

        $this->table(
            ['WD ID', 'Version', 'Status', 'WD state', 'Tx (incl. trashed)', 'Steps', 'Routes', 'Decision'],
            $rows
        );

        if (empty($candidates)) {
            $this->info('Nothing to delete: every workflow with steps/routes is still referenced (or already clean).');
            return self::SUCCESS;
        }

        if (! $execute) {
            $this->info(count($candidates).' workflow(s) would be pruned. Re-run with --execute to delete (soft-delete). Add --force for hard delete.');
            return self::SUCCESS;
        }

        foreach ($candidates as $wd) {
            DB::transaction(function () use ($wd, $force) {
                // Routes first (they FK to steps), then steps.
                // Step dependents (step_roles, field pivots, step_requirements,
                // checklist_overrides) are FK CASCADE and clean up automatically.
                if ($force) {
                    $wd->routes()->withTrashed()->forceDelete();
                    $wd->steps()->withTrashed()->forceDelete();
                } else {
                    $wd->routes()->delete();
                    $wd->steps()->delete();
                }
            });

            $mode = $force ? 'force-deleted' : 'soft-deleted';
            $this->info("WD {$wd->id}: routes + steps {$mode}.");
        }

        $this->info('Done. Workflow_definition shells were kept (only steps + routes removed).');
        return self::SUCCESS;
    }
}
