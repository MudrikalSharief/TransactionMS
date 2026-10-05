<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Services\TransactionEngine;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Live version switching: the is_live flag moves between published
 * versions ("change from and to"). Old versions are never deleted;
 * running transactions stay pinned; new ones follow the live version.
 */
class WorkflowMakeLiveTest extends TestCase
{
    use RefreshDatabase;

    private TransactionType $type;
    private WorkflowDefinition $v1;
    private WorkflowDefinition $v2;

    protected function setUp(): void
    {
        parent::setUp();

        $this->type = TransactionType::create(['code' => 'permit', 'name' => 'Permit']);
        $this->v1 = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
            'is_live' => false,
        ]);
        $this->v2 = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 2,
            'status' => 'published',
            'is_live' => true,
        ]);
    }

    private function superadmin(): User
    {
        $user = User::factory()->create();
        $user->roles()->attach(Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])->id);

        return $user;
    }

    public function test_make_live_switches_flag_and_keeps_old_versions(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->v1->id}/make-live")
            ->assertOk()
            ->assertJsonPath('data.version', 1)
            ->assertJsonPath('data.is_live', true);

        // Old versions kept: same row count, flag moved.
        $this->assertEquals(2, WorkflowDefinition::where('transaction_type_id', $this->type->id)->count());
        $this->assertTrue($this->v1->fresh()->is_live);
        $this->assertFalse($this->v2->fresh()->is_live);
    }

    public function test_make_live_rejects_drafts(): void
    {
        $draft = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 3,
            'status' => 'draft',
        ]);

        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$draft->id}/make-live")
            ->assertStatus(422);
    }

    public function test_make_live_blocked_while_draft_open(): void
    {
        WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 3,
            'status' => 'draft',
        ]);

        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->v1->id}/make-live")
            ->assertStatus(422);

        // Flag untouched.
        $this->assertFalse($this->v1->fresh()->is_live);
        $this->assertTrue($this->v2->fresh()->is_live);
    }

    public function test_make_live_is_idempotent_when_already_live(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->v2->id}/make-live")
            ->assertOk()
            ->assertJsonPath('data.is_live', true);
    }

    public function test_make_live_is_forbidden_for_non_superadmin(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $this->postJson("/api/admin/workflow-definitions/{$this->v1->id}/make-live")
            ->assertForbidden();
    }

    public function test_new_transactions_use_the_live_version(): void
    {
        foreach ([$this->v1, $this->v2] as $def) {
            WorkflowStep::create([
                'workflow_definition_id' => $def->id,
                'order_number' => 1,
                'code' => 'start',
                'name' => 'Start',
                'is_start' => true,
            ]);
            WorkflowStep::create([
                'workflow_definition_id' => $def->id,
                'order_number' => 2,
                'code' => 'end',
                'name' => 'End',
                'is_end' => true,
            ]);
        }

        $engine = app(TransactionEngine::class);
        $creator = $this->superadmin();

        // v2 live → new transaction pins v2.
        $tx = $engine->create($this->type->id, 'First', $creator->id);
        $this->assertEquals($this->v2->id, $tx->workflow_definition_id);

        // Switch live to v1 → new transaction pins v1, old one stays on v2.
        Sanctum::actingAs($creator);
        $this->postJson("/api/admin/workflow-definitions/{$this->v1->id}/make-live")->assertOk();

        $tx2 = $engine->create($this->type->id, 'Second', $creator->id);
        $this->assertEquals($this->v1->id, $tx2->workflow_definition_id);
        $this->assertEquals($this->v2->id, $tx->fresh()->workflow_definition_id);
    }
}
