<?php

namespace Tests\Feature;

use App\Models\RequirementDefinition;
use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Models\TransactionState;
use App\Models\TransactionStepRun;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use App\Services\StepFileAccess;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Resends must land on the selected visited station (not the immediate
 * forward sender) and corrected checklist files must be re-filed under the
 * returned requirement before travelling with the resend.
 */
class TransactionGotoTest extends TestCase
{
    use RefreshDatabase;

    private User $admin;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    /** @var array<int, WorkflowStep> */
    private array $steps = [];
    private Transaction $tx;

    protected function setUp(): void
    {
        parent::setUp();

        $this->admin = User::factory()->create();
        $this->admin->roles()->attach(
            Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])->id
        );

        $this->type = TransactionType::create(['code' => 'procurement', 'name' => 'Procurement']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        for ($i = 1; $i <= 5; $i++) {
            $this->steps[$i] = WorkflowStep::create([
                'workflow_definition_id' => $this->workflow->id,
                'order_number' => $i,
                'code' => "step_{$i}",
                'name' => "Step {$i}",
                'is_start' => $i === 1,
                'is_end' => $i === 5,
            ]);
        }

        for ($i = 1; $i < 5; $i++) {
            WorkflowRoute::create([
                'workflow_definition_id' => $this->workflow->id,
                'from_step_id' => $this->steps[$i]->id,
                'to_step_id' => $this->steps[$i + 1]->id,
                'action_code' => 'submit',
                'is_return_route' => false,
            ]);
        }

        $this->tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Resend test',
            'created_by' => $this->admin->id,
        ]);

        TransactionState::create([
            'transaction_id' => $this->tx->id,
            'current_step_id' => $this->steps[1]->id,
            'entered_at' => now(),
        ]);

        $this->makeRun($this->steps[1], $this->steps[1], 'create');
        $this->makeRun($this->steps[1], $this->steps[2], 'submit');
        $this->makeRun($this->steps[2], $this->steps[3], 'submit');
        $this->makeRun($this->steps[3], $this->steps[4], 'submit');
        $this->makeRun($this->steps[4], $this->steps[5], 'submit');
        $this->makeRun($this->steps[5], $this->steps[1], 'return');
    }

    private function makeRun(WorkflowStep $from, WorkflowStep $to, string $action): TransactionStepRun
    {
        return TransactionStepRun::create([
            'transaction_id' => $this->tx->id,
            'from_step_id' => $from->id,
            'to_step_id' => $to->id,
            'action_code' => $action,
            'performed_by' => $this->admin->id,
            'performed_at' => now(),
            'received_at' => now(),
        ]);
    }

    public function test_resend_lands_on_the_selected_visited_step(): void
    {
        Sanctum::actingAs($this->admin);

        $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
            'to_step_id' => $this->steps[5]->id,
            'remarks' => 'Corrected the returned document.',
        ])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->steps[5]->id);

        $this->assertDatabaseHas('transaction_step_runs', [
            'transaction_id' => $this->tx->id,
            'from_step_id' => $this->steps[1]->id,
            'to_step_id' => $this->steps[5]->id,
            'action_code' => 'resend',
        ]);

        $this->assertDatabaseHas('transaction_states', [
            'transaction_id' => $this->tx->id,
            'current_step_id' => $this->steps[5]->id,
        ]);
    }

    public function test_resend_refiles_a_corrected_file_under_the_returned_requirement(): void
    {
        $requirement = RequirementDefinition::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'cto_app',
            'name' => 'CTO approve PR',
            'is_active' => true,
        ]);
        $this->steps[4]->requirementDefinitions()->attach($requirement->id, [
            'display_order' => 0,
            'is_required' => true,
            'is_upload_required' => true,
        ]);

        $file = TransactionAttachment::create([
            'transaction_id' => $this->tx->id,
            'workflow_step_id' => $this->steps[1]->id,
            'original_name' => 'cto-approval-updated.pdf',
            'stored_path' => 'attachments/cto-approval-updated.pdf',
            'disk' => 'local',
            'mime' => 'application/pdf',
            'size_bytes' => 2048,
            'uploaded_by' => $this->admin->id,
        ]);

        Sanctum::actingAs($this->admin);

        $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
            'to_step_id' => $this->steps[5]->id,
            'remarks' => 'Attached the corrected CTO approval.',
            'attachment_targets' => [[
                'attachment_id' => $file->id,
                'workflow_step_id' => $this->steps[4]->id,
                'requirement_definition_id' => $requirement->id,
            ]],
        ])->assertOk();

        $file->refresh();
        $run = TransactionStepRun::where('transaction_id', $this->tx->id)
            ->where('action_code', 'resend')
            ->firstOrFail();

        $this->assertSame($this->steps[4]->id, (int) $file->workflow_step_id);
        $this->assertSame($requirement->id, (int) $file->requirement_definition_id);
        $this->assertSame($run->id, (int) $file->step_run_id);
    }

    public function test_returned_transaction_only_allows_the_returning_station(): void
    {
        Sanctum::actingAs($this->admin);

        foreach ([2, 3, 4] as $stepNumber) {
            $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
                'to_step_id' => $this->steps[$stepNumber]->id,
                'remarks' => 'Wrong destination.',
            ])->assertStatus(422);
        }

        $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
            'to_step_id' => $this->steps[5]->id,
            'remarks' => 'Back to the station that returned it.',
        ])->assertOk();
    }

    public function test_return_target_follows_the_station_that_returned_it(): void
    {
        // Same failed-return shape, but the paper was sent back by Step 4.
        $return = TransactionStepRun::where('transaction_id', $this->tx->id)
            ->where('action_code', 'return')
            ->firstOrFail();
        $return->update(['from_step_id' => $this->steps[4]->id]);

        Sanctum::actingAs($this->admin);

        $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
            'to_step_id' => $this->steps[5]->id,
            'remarks' => 'Step 5 did not return this paper.',
        ])->assertStatus(422);

        $this->postJson("/api/admin/transactions/{$this->tx->id}/goto", [
            'to_step_id' => $this->steps[4]->id,
            'remarks' => 'Back to Step 4.',
        ])->assertOk();
    }

    public function test_returned_transaction_still_allows_normal_proceed(): void
    {
        $route = WorkflowRoute::where('workflow_definition_id', $this->workflow->id)
            ->where('from_step_id', $this->steps[1]->id)
            ->where('to_step_id', $this->steps[2]->id)
            ->firstOrFail();

        Sanctum::actingAs($this->admin);

        $this->postJson("/api/admin/transactions/{$this->tx->id}/execute", [
            'route_id' => $route->id,
            'remarks' => 'Proceeding to the next step instead of resending.',
        ])
            ->assertOk()
            ->assertJsonPath('data.current_step.id', $this->steps[2]->id);
    }

    public function test_flagged_return_file_is_readable_at_the_receiving_step(): void
    {
        $requirement = RequirementDefinition::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'cto_app',
            'name' => 'CTO approve PR',
            'is_active' => true,
        ]);
        $this->steps[4]->requirementDefinitions()->attach($requirement->id, [
            'display_order' => 0,
            'is_required' => true,
            'is_upload_required' => true,
        ]);

        $return = TransactionStepRun::where('transaction_id', $this->tx->id)
            ->where('action_code', 'return')
            ->firstOrFail();
        $return->update([
            'flagged_items' => [[
                'requirement_definition_id' => $requirement->id,
                'code' => 'cto_app',
                'name' => 'CTO approve PR',
            ]],
        ]);

        $viewer = User::factory()->create();

        $allowed = app(StepFileAccess::class)->allowedStepIds($this->tx->fresh(), $viewer);

        $this->assertContains($this->steps[4]->id, $allowed);
    }
}
