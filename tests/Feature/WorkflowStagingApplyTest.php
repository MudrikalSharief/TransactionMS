<?php

namespace Tests\Feature;

use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use App\Models\WorkflowStepData;
use App\Services\WorkflowVersioningService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Staged save (apply-staged): the client-side diff lands on the open draft
 * in one call. Overwriting while editing the live version publishes
 * automatically; overwriting an open draft stays a draft.
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

    public function test_overwriting_live_version_publishes_automatically(): void
    {
        Sanctum::actingAs($this->superadmin());

        $this->postJson("/api/admin/workflow-definitions/{$this->live->id}/apply-staged", [
            'mode' => 'overwrite',
            'name' => 'Renamed live',
            'steps_upsert' => $this->stepPayload(),
        ])->assertCreated()->assertJsonPath('meta.published', true);

        $this->live->refresh();
        $this->assertFalse((bool) $this->live->is_live);
        $this->assertSame('published', $this->live->status);

        $live = WorkflowDefinition::where('transaction_type_id', $this->type->id)
            ->where('is_live', true)
            ->firstOrFail();

        $this->assertSame(2, $live->version);
        $this->assertSame('Renamed live', $live->name);
        $this->assertSame('published', $live->status);

        $step = $live->steps()->where('code', 'start')->firstOrFail();
        $this->assertTrue((bool) $step->is_end_user);
        $this->assertTrue($step->roles()->where('roles.id', $this->endUserRole->id)->exists());
    }

    public function test_overwriting_open_draft_stays_draft(): void
    {
        $user = $this->superadmin();
        Sanctum::actingAs($user);

        $draft = app(WorkflowVersioningService::class)
            ->createDraft(['transaction_type_id' => $this->type->id], $user->id);

        $this->postJson("/api/admin/workflow-definitions/{$draft->id}/apply-staged", [
            'mode' => 'overwrite',
            'name' => 'Still draft',
            'steps_upsert' => $this->stepPayload(),
        ])->assertOk()->assertJsonPath('meta.published', false);

        $draft->refresh();
        $this->assertSame('draft', $draft->status);
        $this->assertFalse((bool) $draft->is_live);
        $this->assertSame('Still draft', $draft->name);

        $this->assertTrue((bool) $this->live->fresh()->is_live);
    }

    public function test_step_data_is_matched_by_original_code_after_cloning(): void
    {
        $user = $this->superadmin();
        Sanctum::actingAs($user);

        $alpha = WorkflowStepData::create([
            'workflow_step_id' => $this->start->id,
            'code' => 'alpha',
            'display_name' => 'Alpha',
            'type' => 'text',
            'is_required' => true,
            'display_order' => 0,
        ]);
        $removed = WorkflowStepData::create([
            'workflow_step_id' => $this->start->id,
            'code' => 'remove_me',
            'display_name' => 'Remove me',
            'type' => 'text',
            'is_required' => false,
            'display_order' => 1,
        ]);

        $draft = app(WorkflowVersioningService::class)
            ->createDraft(['transaction_type_id' => $this->type->id], $user->id);

        $draftStart = $draft->steps()->where('code', 'start')->firstOrFail();
        $draftAlpha = $draftStart->stepDataDefinitions()->where('code', 'alpha')->firstOrFail();
        $draftRemoved = $draftStart->stepDataDefinitions()->where('code', 'remove_me')->firstOrFail();
        $this->assertNotSame($alpha->id, $draftAlpha->id);

        // Live page sends the live row's id; the clone has a new id, so the
        // backend must fall back to original_code.
        $this->postJson("/api/admin/workflow-definitions/{$draft->id}/apply-staged", [
            'mode' => 'overwrite',
            'step_data' => [
                (string) $this->start->id => [
                    [
                        'key' => $alpha->id,
                        'source_id' => $alpha->id,
                        'original_code' => 'alpha',
                        'code' => 'alpha',
                        'display_name' => 'Alpha renamed',
                        'type' => 'text',
                        'is_required' => false,
                        'display_order' => 0,
                        'min_length' => null,
                        'max_length' => null,
                    ],
                    [
                        'key' => 'new-beta',
                        'source_id' => null,
                        'original_code' => null,
                        'code' => 'beta',
                        'display_name' => 'Beta',
                        'type' => 'text',
                        'is_required' => true,
                        'display_order' => 1,
                        'min_length' => null,
                        'max_length' => null,
                    ],
                ],
            ],
        ])->assertOk();

        $this->assertSame('Alpha renamed', $draftAlpha->fresh()->display_name);
        $this->assertFalse((bool) $draftAlpha->fresh()->is_required);
        $this->assertTrue(
            $draftStart->stepDataDefinitions()->where('code', 'beta')->exists()
        );
        $this->assertNotNull(
            WorkflowStepData::withTrashed()->findOrFail($draftRemoved->id)->deleted_at
        );
        // The source live version must remain untouched.
        $this->assertSame('Alpha', $alpha->fresh()->display_name);
        $this->assertTrue((bool) $alpha->fresh()->is_required);
        $this->assertNull($removed->fresh()->deleted_at);
    }

    public function test_step_data_codes_can_be_swapped(): void
    {
        $user = $this->superadmin();
        Sanctum::actingAs($user);

        $alpha = WorkflowStepData::create([
            'workflow_step_id' => $this->start->id,
            'code' => 'alpha',
            'display_name' => 'Alpha',
            'type' => 'text',
            'is_required' => false,
            'display_order' => 0,
        ]);
        $beta = WorkflowStepData::create([
            'workflow_step_id' => $this->start->id,
            'code' => 'beta',
            'display_name' => 'Beta',
            'type' => 'text',
            'is_required' => false,
            'display_order' => 1,
        ]);

        $draft = app(WorkflowVersioningService::class)
            ->createDraft(['transaction_type_id' => $this->type->id], $user->id);
        $draftStart = $draft->steps()->where('code', 'start')->firstOrFail();
        $draftAlpha = $draftStart->stepDataDefinitions()->where('code', 'alpha')->firstOrFail();
        $draftBeta = $draftStart->stepDataDefinitions()->where('code', 'beta')->firstOrFail();

        $this->postJson("/api/admin/workflow-definitions/{$draft->id}/apply-staged", [
            'mode' => 'overwrite',
            'step_data' => [
                (string) $this->start->id => [
                    [
                        'source_id' => $alpha->id,
                        'original_code' => 'alpha',
                        'code' => 'beta',
                        'display_name' => 'Alpha',
                        'type' => 'text',
                        'is_required' => false,
                        'display_order' => 0,
                    ],
                    [
                        'source_id' => $beta->id,
                        'original_code' => 'beta',
                        'code' => 'alpha',
                        'display_name' => 'Beta',
                        'type' => 'text',
                        'is_required' => false,
                        'display_order' => 1,
                    ],
                ],
            ],
        ])->assertOk();

        $this->assertSame('beta', $draftAlpha->fresh()->code);
        $this->assertSame('alpha', $draftBeta->fresh()->code);
        $this->assertSame('alpha', $alpha->fresh()->code);
        $this->assertSame('beta', $beta->fresh()->code);
    }

    private function stepPayload(): array
    {
        return [
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
        ];
    }
}
