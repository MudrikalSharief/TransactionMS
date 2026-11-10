<?php

namespace Tests\Feature;

use App\Models\AuditLog;
use App\Models\FieldDefinition;
use App\Models\Office;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class WorkflowAuditTest extends TestCase
{
    use RefreshDatabase;

    public function test_workflow_setup_changes_are_audited(): void
    {
        $office = Office::create(['code' => 'TST', 'name' => 'Test Office']);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $type = TransactionType::create(['code' => 'test_flow', 'name' => 'Test Flow']);

        $superadmin = User::factory()->create(['office_id' => null]);
        $superadmin->roles()->attach(
            Role::firstOrCreate(['code' => 'superadmin'], ['name' => 'Super Admin'])->id
        );

        Sanctum::actingAs($superadmin);

        $draft = $this->postJson('/api/admin/workflow-definitions', [
            'transaction_type_id' => $type->id,
            'name' => 'Test Draft',
        ])->assertCreated()->json('data');

        $workflowId = $draft['id'];
        $this->assertDatabaseHas('audit_logs', [
            'event' => 'workflow_definitions.create',
            'entity_type' => 'workflow_definition',
            'entity_id' => $workflowId,
        ]);

        $stepOne = $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps", [
            'order_number' => 1,
            'code' => 'first_step',
            'name' => 'First Step',
            'sla_minutes' => 60,
            'is_start' => true,
            'office_id' => $office->id,
            'role_ids' => [$clerk->id],
        ])->assertCreated()->json('data');

        $stepTwo = $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps", [
            'order_number' => 2,
            'code' => 'second_step',
            'name' => 'Second Step',
            'sla_minutes' => 60,
            'is_end' => true,
            'office_id' => $office->id,
            'role_ids' => [$clerk->id],
        ])->assertCreated()->json('data');

        $this->putJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepTwo['id']}", [
            'order_number' => 2,
            'code' => 'second_step',
            'name' => 'Second Step Updated',
            'sla_minutes' => 30,
            'is_end' => true,
            'office_id' => $office->id,
            'role_ids' => [$clerk->id],
        ])->assertOk();

        $route = $this->postJson("/api/admin/workflow-definitions/{$workflowId}/routes", [
            'from_step_id' => $stepOne['id'],
            'to_step_id' => $stepTwo['id'],
            'action_code' => 'submit',
        ])->assertCreated()->json('data');

        $this->putJson("/api/admin/workflow-definitions/{$workflowId}/routes/{$route['id']}", [
            'from_step_id' => $stepOne['id'],
            'to_step_id' => $stepTwo['id'],
            'action_code' => 'approve',
        ])->assertOk();

        $this->deleteJson("/api/admin/workflow-definitions/{$workflowId}/routes/{$route['id']}")
            ->assertOk();

        $field = FieldDefinition::create([
            'workflow_definition_id' => $workflowId,
            'code' => 'amount',
            'name' => 'Amount',
            'type' => 'number',
        ]);

        $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/fields/sync", [
            'fields' => [
                ['field_definition_id' => $field->id, 'display_order' => 1, 'required_override' => true],
            ],
        ])->assertOk();

        $requirement = $this->postJson("/api/admin/workflow-definitions/{$workflowId}/requirements", [
            'code' => 'receipt',
            'name' => 'Official Receipt',
            'is_active' => true,
        ])->assertCreated()->json('data');

        $this->putJson("/api/admin/workflow-definitions/{$workflowId}/requirements/{$requirement['id']}", [
            'code' => 'receipt',
            'name' => 'Official Receipt Updated',
            'is_active' => true,
        ])->assertOk();

        $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/requirements/sync", [
            'requirements' => [
                [
                    'requirement_definition_id' => $requirement['id'],
                    'display_order' => 1,
                    'is_required' => true,
                    'is_upload_required' => true,
                ],
            ],
        ])->assertOk();

        $this->postJson("/api/admin/workflow-definitions/{$workflowId}/requirements/{$requirement['id']}/steps/sync", [
            'steps' => [
                ['workflow_step_id' => $stepOne['id'], 'display_order' => 1, 'is_required' => true],
            ],
        ])->assertOk();

        $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/checklist/sync", [
            'items' => [
                ['name' => 'Check the receipt', 'is_required' => true, 'display_order' => 1],
            ],
        ])->assertOk();

        $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/checklist/resync")
            ->assertOk();

        $stepData = $this->postJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/step-data", [
            'code' => 'receipt_number',
            'display_name' => 'Receipt Number',
            'type' => 'text',
            'is_required' => true,
            'display_order' => 1,
        ])->assertCreated()->json();

        $this->putJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/step-data/{$stepData['id']}", [
            'display_name' => 'Receipt No.',
        ])->assertOk();

        $this->deleteJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepOne['id']}/step-data/{$stepData['id']}")
            ->assertOk();

        $this->deleteJson("/api/admin/workflow-definitions/{$workflowId}/requirements/{$requirement['id']}")
            ->assertNoContent();

        $this->deleteJson("/api/admin/workflow-definitions/{$workflowId}/steps/{$stepTwo['id']}")
            ->assertOk();

        foreach ([
            'workflow_steps.create',
            'workflow_steps.update',
            'workflow_steps.delete',
            'workflow_routes.create',
            'workflow_routes.update',
            'workflow_routes.delete',
            'step_fields.sync',
            'requirement_definitions.create',
            'requirement_definitions.update',
            'requirement_definitions.steps_sync',
            'requirement_definitions.delete',
            'step_requirements.sync',
            'step_checklists.sync',
            'step_checklists.resync',
            'workflow_step_data.create',
            'workflow_step_data.update',
            'workflow_step_data.delete',
        ] as $event) {
            $this->assertDatabaseHas('audit_logs', ['event' => $event]);
        }

        $stepSummary = $this->getJson('/api/admin/activity?kind=setup&module=workflow_steps&action=create')
            ->assertOk()
            ->json('data.0.summary');
        $this->assertStringContainsString('office: TST — Test Office', $stepSummary);
        $this->assertStringContainsString('workflow: Test Draft v1', $stepSummary);
        $this->assertStringNotContainsString('office_id', $stepSummary);
        $this->assertStringNotContainsString('workflow_definition_id', $stepSummary);

        $fieldSummary = $this->getJson('/api/admin/activity?kind=setup&module=step_fields&action=sync')
            ->assertOk()
            ->json('data.0.summary');
        $this->assertStringContainsString('Amount', $fieldSummary);
        $this->assertStringNotContainsString('field_definition_id', $fieldSummary);

        $requirementSummary = $this->getJson('/api/admin/activity?kind=setup&module=step_requirements&action=sync')
            ->assertOk()
            ->json('data.0.summary');
        $this->assertStringContainsString('Official Receipt Updated', $requirementSummary);
        $this->assertStringNotContainsString('requirement_definition_id', $requirementSummary);

        $checklistSummary = $this->getJson('/api/admin/activity?kind=setup&module=step_checklists&action=sync')
            ->assertOk()
            ->json('data.0.summary');
        $this->assertStringContainsString('Check the receipt', $checklistSummary);
        $this->assertStringNotContainsString('checklist_override_id', $checklistSummary);

        $this->assertSame(
            0,
            AuditLog::whereNull('actor_name')->whereNotNull('actor_user_id')->count()
        );
    }
}
