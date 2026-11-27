<?php

namespace Tests\Feature;

use App\Models\{Office, Role, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowStep};
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * The staff portal's Office view must use the exact same office-admin numbers.
 */
class PortalOfficeSummaryTest extends TestCase
{
    use RefreshDatabase;

    public function test_office_summary_matches_the_office_admin_dashboard(): void
    {
        Carbon::setTestNow(Carbon::parse('2026-11-24 03:00:00', 'UTC')); // 11:00 Manila

        $office = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $adminRole = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $clerkRole = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);

        $admin = User::factory()->create(['office_id' => $office->id]);
        $admin->roles()->attach($adminRole->id);
        $staff = User::factory()->create(['office_id' => $office->id]);
        $staff->roles()->attach($clerkRole->id);

        $type = TransactionType::create(['code' => 'service', 'name' => 'Service']);
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'office_id' => $office->id,
            'is_start' => true,
            'sla_minutes' => 60,
        ]);

        // One open step, received two hours ago against a one-hour limit.
        $tx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'TX-OFFICE-1',
            'created_by' => $staff->id,
            'is_done' => false,
        ]);
        $run = TransactionStepRun::create([
            'transaction_id' => $tx->id,
            'from_step_id' => $step->id,
            'to_step_id' => $step->id,
            'action_code' => 'submit',
            'performed_by' => $staff->id,
            'performed_at' => now()->subHours(2),
            'received_at' => now()->subHours(2),
            'received_by' => $staff->id,
            'received_office_id' => $office->id,
            'sla_minutes_snapshot' => 60,
        ]);
        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $step->id,
            'current_run_id' => $run->id,
            'entered_at' => $run->performed_at,
        ]);

        // One step sent back to the office in November: counts as an entry
        // and a Return, but adds no receipt or current work.
        $returnedTx = Transaction::create([
            'transaction_type_id' => $type->id,
            'workflow_definition_id' => $workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'TX-OFFICE-RETURN',
            'created_by' => $staff->id,
            'is_done' => false,
        ]);
        TransactionStepRun::create([
            'transaction_id' => $returnedTx->id,
            'from_step_id' => $step->id,
            'to_step_id' => $step->id,
            'action_code' => 'return',
            'performed_by' => $staff->id,
            'performed_at' => now()->subHour(),
            'received_at' => null,
            'received_by' => null,
            'assigned_to' => $staff->id,
            'received_office_id' => $office->id,
            'sla_minutes_snapshot' => 60,
        ]);

        Sanctum::actingAs($admin);
        $adminJson = $this->getJson('/api/office/dashboard/summary?month=2026-11')
            ->assertOk()
            ->json();

        Sanctum::actingAs($staff);
        $staffJson = $this->getJson('/api/portal/office-summary?period=2026-11')
            ->assertOk()
            ->json();

        $this->assertSame($adminJson['office_step_metrics'], $staffJson['office_step_metrics']);
        $this->assertSame($adminJson['overdue_steps'], $staffJson['overdue_steps']);
        $this->assertSame($adminJson['overdue_transactions'], $staffJson['overdue_transactions']);

        // Prove the fixture exercised every card, not just two empty payloads.
        $this->assertSame(2, $staffJson['office_step_metrics']['entered']);
        $this->assertSame(1, $staffJson['office_step_metrics']['received']);
        $this->assertSame(1, $staffJson['office_step_metrics']['in_progress']);
        $this->assertSame(1, $staffJson['office_step_metrics']['overdue_steps']);
        $this->assertSame(1, $staffJson['office_step_metrics']['returned']);
        $this->assertSame(1, $staffJson['office_step_metrics']['released']);
        $this->assertSame(1, $staffJson['overdue_steps']);
        $this->assertSame(1, $staffJson['overdue_transactions']);

        Carbon::setTestNow();
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        parent::tearDown();
    }
}
