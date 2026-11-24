<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowStep};
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ClerkStepSummaryTest extends TestCase
{
    use RefreshDatabase;

    private ?string $originalTimezone = null;

    protected function tearDown(): void
    {
        parent::tearDown();
        if ($this->originalTimezone !== null) date_default_timezone_set($this->originalTimezone);
    }

    public function test_needs_action_card_counts_step_visits_and_isolates_office_and_officer(): void
    {
        $this->originalTimezone = date_default_timezone_get();
        config(['app.timezone' => 'Asia/Manila']);
        date_default_timezone_set('Asia/Manila');
        $this->travelTo(\Illuminate\Support\Carbon::parse('2026-11-24 11:00'));
        $office = Office::create(['code' => 'CLERK', 'name' => 'Clerk office']);
        $other = Office::create(['code' => 'OTHER', 'name' => 'Other office']);
        $role = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        $user = User::factory()->create(['office_id' => $office->id]);
        $user->roles()->attach($role);
        $colleague = User::factory()->create(['office_id' => $office->id]);
        $type = TransactionType::create(['code' => 'CARD', 'name' => 'Cards']);
        $workflow = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);
        $step = WorkflowStep::create(['workflow_definition_id' => $workflow->id, 'order_number' => 1, 'code' => 'CLERK', 'name' => 'Clerk step', 'office_id' => $office->id, 'sla_minutes' => 30]);
        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $role->id]);
        $next = WorkflowStep::create(['workflow_definition_id' => $workflow->id, 'order_number' => 2, 'code' => 'NEXT', 'name' => 'Next step', 'office_id' => $other->id]);
        $make = function (string $ref, ?int $officer, bool $received = true, string $action = 'submit', ?int $officeId = null) use ($type, $workflow, $step, $user, $office) {
            $tx = Transaction::create(['transaction_type_id' => $type->id, 'workflow_definition_id' => $workflow->id, 'office_id' => $office->id, 'created_by' => $user->id, 'reference_number' => $ref]);
            $run = TransactionStepRun::create(['transaction_id' => $tx->id, 'from_step_id' => $step->id, 'to_step_id' => $step->id, 'action_code' => $action, 'performed_by' => $user->id, 'performed_at' => now()->subHours(3), 'received_at' => $received ? now()->subHours(2) : null, 'received_by' => $received ? $officer : null, 'assigned_to' => $officer, 'received_office_id' => $officeId ?? $office->id, 'sla_minutes_snapshot' => 30]);
            TransactionState::create(['transaction_id' => $tx->id, 'current_step_id' => $step->id, 'current_run_id' => $run->id, 'entered_at' => $run->performed_at]);
            return [$tx, $run];
        };
        [$done] = $make('COMPLETED', $user->id);
        $departure = TransactionStepRun::create(['transaction_id' => $done->id, 'from_step_id' => $step->id, 'to_step_id' => $next->id, 'action_code' => 'submit', 'performed_by' => $user->id, 'performed_at' => now()->subHour()]);
        $done->state()->update(['current_step_id' => $next->id, 'current_run_id' => $departure->id]);
        $make('OVERDUE', $user->id);
        $make('ARRIVAL', null, false);
        $make('RETURN', $user->id, false, 'return');
        $make('COLLEAGUE', $colleague->id);
        $make('OTHER-OFFICE', $user->id, true, 'submit', $other->id);
        [$onTime, $onTimeRun] = $make('ON-TIME', $user->id);
        $onTimeRun->update(['received_at' => now()->subMinutes(30)]);
        Sanctum::actingAs($user);
        $response = $this->getJson('/api/portal/summary')->assertOk()
            ->assertJsonPath('needs_action.count', 4)
            ->assertJsonCount(4, 'needs_action.rows')
            ->assertJsonMissingPath('clerk_steps');
        $reasons = collect($response->json('needs_action.rows'))->pluck('reason');
        $this->assertTrue($reasons->contains('Received — ready to release'));
        $this->assertTrue($reasons->contains('Awaiting receipt'));
        $this->assertTrue($reasons->contains('Return assigned to you'));
        $actions = collect($response->json('needs_action.rows'))->pluck('action');
        $this->assertTrue($actions->contains('release'));
        $this->assertTrue($actions->contains('receive'));
        $this->assertTrue($actions->contains('return'));
        $this->getJson('/api/portal/summary?period=2026-10')->assertOk()
            ->assertJsonPath('needs_action.count', 4);

        // Finalization closes the current visit; it must not count as another arrival.
        [$final] = $make('FINALIZED', $user->id);
        TransactionStepRun::create(['transaction_id' => $final->id, 'from_step_id' => $step->id, 'to_step_id' => $step->id, 'action_code' => 'finalize', 'performed_by' => $user->id, 'performed_at' => now()->subHour()]);
        $final->update(['is_done' => true]);
        [$archived] = $make('ARCHIVED', $user->id);
        $archived->update(['is_archive' => true]);
        [, $zeroSla] = $make('NO-SLA', $user->id);
        $zeroSla->update(['sla_minutes_snapshot' => 0]);
        $this->getJson('/api/portal/summary')->assertOk()
            ->assertJsonPath('needs_action.count', 5)
            ->assertJsonCount(5, 'needs_action.rows');

        $user->update(['office_id' => null]);
        $this->getJson('/api/portal/summary')->assertOk()
            ->assertJsonPath('needs_action.count', 0)
            ->assertJsonCount(0, 'needs_action.rows');
    }

    public function test_needs_action_is_available_to_non_clerk_staff(): void
    {
        $this->originalTimezone = date_default_timezone_get();
        config(['app.timezone' => 'Asia/Manila']);
        date_default_timezone_set('Asia/Manila');
        $this->travelTo(\Illuminate\Support\Carbon::parse('2026-11-24 11:00'));

        $office = Office::create(['code' => 'STAFF', 'name' => 'Staff office']);
        $role = Role::firstOrCreate(['code' => 'officer'], ['name' => 'Officer']);
        $user = User::factory()->create(['office_id' => $office->id]);
        $user->roles()->attach($role->id);

        $type = TransactionType::create(['code' => 'STAFF-TYPE', 'name' => 'Staff type']);
        $workflow = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);
        $step = WorkflowStep::create(['workflow_definition_id' => $workflow->id, 'order_number' => 1, 'code' => 'STAFF', 'name' => 'Staff step', 'office_id' => $office->id, 'sla_minutes' => 30]);
        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $role->id]);

        $tx = Transaction::create(['transaction_type_id' => $type->id, 'workflow_definition_id' => $workflow->id, 'office_id' => $office->id, 'created_by' => $user->id, 'reference_number' => 'STAFF-1']);
        $run = TransactionStepRun::create(['transaction_id' => $tx->id, 'from_step_id' => $step->id, 'to_step_id' => $step->id, 'action_code' => 'create', 'performed_by' => $user->id, 'performed_at' => now()->subHours(2), 'received_at' => null, 'received_by' => null, 'assigned_to' => null, 'received_office_id' => $office->id, 'sla_minutes_snapshot' => 30]);
        TransactionState::create(['transaction_id' => $tx->id, 'current_step_id' => $step->id, 'current_run_id' => $run->id, 'entered_at' => $run->performed_at]);

        Sanctum::actingAs($user);

        $this->getJson('/api/portal/summary')->assertOk()
            ->assertJsonPath('needs_action.count', 1)
            ->assertJsonPath('needs_action.rows.0.reference_number', 'STAFF-1')
            ->assertJsonPath('needs_action.rows.0.reason', 'Awaiting receipt')
            ->assertJsonPath('needs_action.rows.0.action', 'receive');
    }
}
