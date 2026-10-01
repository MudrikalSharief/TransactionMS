<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Save-as-version: typing a name stores the viewed version's content
 * (steps + routes) as a brand-new live version. Old ones are kept.
 */
class WorkflowSaveAsTest extends TestCase
{
    use RefreshDatabase;

    private TransactionType $type;
    private WorkflowDefinition $live;

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
        $start = WorkflowStep::create([
            'workflow_definition_id' => $this->live->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'is_start' => true,
        ]);
        $end = WorkflowStep::create([
            'workflow_definition_id' => $this->live->id,
            'order_number' => 2,
            'code' => 'end',
            'name' => 'End',
            'is_end' => true,
        ]);
        WorkflowRoute::create([
            'workflow_definition_id' => $this->live->id,
            'from_step_id' => $start->id,
            'to_step_id' => $end->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);
    }

    private function superadmin(): User
    {
        $user = User::factory()->create();
        $user->roles()->attach(Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])->id);

        return $user;
    }

    public function test_save_as_clones_published_into_named_live_version(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/save-as", ['name' => 'Holiday rush flow'])
            ->assertCreated()
            ->assertJsonPath('data.version', 2)
            ->assertJsonPath('data.name', 'Holiday rush flow')
            ->assertJsonPath('data.status', 'published')
            ->assertJsonPath('data.is_live', true);

        // Old version kept, flag moved.
        $this->assertEquals(2, WorkflowDefinition::where('transaction_type_id', $this->type->id)->count());
        $this->assertFalse($this->live->fresh()->is_live);

        // Steps + routes cloned.
        $saved = WorkflowDefinition::where('transaction_type_id', $this->type->id)->where('version', 2)->first();
        $this->assertEquals(2, $saved->steps()->count());
        $this->assertEquals(1, $saved->routes()->count());
    }

    public function test_save_as_on_draft_renames_and_publishes_it(): void
    {
        $draft = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 2,
            'status' => 'draft',
        ]);
        WorkflowStep::create([
            'workflow_definition_id' => $draft->id,
            'order_number' => 1, 'code' => 'start', 'name' => 'Start', 'is_start' => true,
        ]);
        WorkflowStep::create([
            'workflow_definition_id' => $draft->id,
            'order_number' => 2, 'code' => 'end', 'name' => 'End', 'is_end' => true,
        ]);

        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$draft->id}/save-as", ['name' => 'Finished draft'])
            ->assertCreated()
            ->assertJsonPath('data.version', 2)
            ->assertJsonPath('data.name', 'Finished draft')
            ->assertJsonPath('data.is_live', true);
    }

    public function test_save_as_requires_a_name(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/save-as", ['name' => ''])
            ->assertStatus(422);
    }

    public function test_save_as_blocked_while_another_draft_open(): void
    {
        WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 2,
            'status' => 'draft',
        ]);

        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/save-as", ['name' => 'Blocked'])
            ->assertStatus(422);
    }

    public function test_save_as_is_forbidden_for_non_superadmin(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/save-as", ['name' => 'Nope'])
            ->assertForbidden();
    }
}
