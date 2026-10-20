<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Staged save (apply-staged): the client-side diff lands on the open draft
 * in one call; overwrite mode also renames/updates notes on the draft.
 */
class WorkflowStagingApplyTest extends TestCase
{
    use RefreshDatabase;

    private TransactionType $type;
    private WorkflowDefinition $live;
    private WorkflowStep $start;
    private WorkflowStep $end;
    private Role $endUserRole;

    protected function setUp(): void
    {
        parent::setUp();

        $this->type = TransactionType::create(['code' => 'permit', 'name' => 'Permit']);
        $this->live = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
            'is_live' => true,
        ]);
        $this->start = WorkflowStep::create([
            'workflow_definition_id' => $this->live->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'is_start' => true,
        ]);
        $this->end = WorkflowStep::create([
            'workflow_definition_id' => $this->live->id,
            'order_number' => 2,
            'code' => 'end',
            'name' => 'End',
            'is_end' => true,
        ]);
        $this->endUserRole = Role::create(['code' => 'end_user', 'name' => 'End User']);
    }

    private function superadmin(): User
    {
        $user = User::factory()->create();
        $user->roles()->attach(Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])->id);

        return $user;
    }

    public function test_staged_save_persists_end_user_toggle_and_renames_draft(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/apply-staged", [
            'mode' => 'overwrite',
            'name' => 'Renamed draft',
            'steps_upsert' => [
                [
                    'key' => $this->start->id,
                    'code' => 'start',
                    'order_number' => 1,
                    'name' => 'Start',
                    'stage' => null,
                    'office_id' => null,
                    'sla_minutes' => 60,
                    'is_start' => true,
                    'is_end' => false,
                    'is_end_user' => true,
                    'role_ids' => [$this->endUserRole->id],
                ],
                [
                    'key' => $this->end->id,
                    'code' => 'end',
                    'order_number' => 2,
                    'name' => 'End',
                    'stage' => null,
                    'office_id' => null,
                    'sla_minutes' => 0,
                    'is_start' => false,
                    'is_end' => true,
                    'is_end_user' => false,
                    'role_ids' => [],
                ],
            ],
        ])->assertOk()->assertJsonPath('meta.published', false);

        $draft = WorkflowDefinition::where('transaction_type_id', $this->type->id)
            ->where('status', 'draft')
            ->firstOrFail();

        $this->assertSame('Renamed draft', $draft->name);

        $step = $draft->steps()->where('code', 'start')->firstOrFail();
        $this->assertTrue((bool) $step->is_end_user);
        $this->assertTrue($step->roles()->where('roles.id', $this->endUserRole->id)->exists());
    }
}
