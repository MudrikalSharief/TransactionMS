<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Clerk is the one universal staff role: the same Clerk can receive,
     * submit or approve at any step. Who actually acts is still decided by
     * the step's office (RoutingEngine: allowed role AND the step's
     * effective office must match the user's office), so a GSO clerk only
     * works GSO steps.
     *
     * Ticks Clerk on every step of every workflow version still in use
     * (running transactions stay on older versions, so those count too).
     * Existing role links are left as they are. Creates the Clerk role when
     * a database doesn't have it yet; restores it if it was deleted.
     */
    public function up(): void
    {
        $clerk = DB::table('roles')->where('code', 'clerk')->first();
        if (!$clerk) {
            $clerkId = DB::table('roles')->insertGetId([
                'code' => 'clerk',
                'name' => 'Clerk',
                'description' => 'Office staff: receives, submits and approves at steps assigned to their office.',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } else {
            $clerkId = $clerk->id;
            if (!empty($clerk->deleted_at)) {
                DB::table('roles')->where('id', $clerkId)->update(['deleted_at' => null, 'updated_at' => now()]);
            }
        }

        $stepIds = DB::table('workflow_steps as s')
            ->join('workflow_definitions as d', 'd.id', '=', 's.workflow_definition_id')
            ->join('transaction_types as t', 't.id', '=', 'd.transaction_type_id')
            ->whereNull('s.deleted_at')
            ->whereNull('d.deleted_at')
            ->whereNull('t.deleted_at')
            ->whereNotExists(fn ($q) => $q->from('step_roles')
                ->whereColumn('step_roles.workflow_step_id', 's.id')
                ->where('step_roles.role_id', $clerkId))
            ->pluck('s.id');

        foreach ($stepIds->chunk(500) as $chunk) {
            DB::table('step_roles')->insert($chunk->map(fn ($id) => [
                'workflow_step_id' => $id,
                'role_id' => $clerkId,
                'created_at' => now(),
                'updated_at' => now(),
            ])->all());
        }
    }

    public function down(): void
    {
        // Data only: links added here can't be told apart from Clerk links
        // ticked by hand, so they are kept. Untick Clerk per step if needed.
    }
};
