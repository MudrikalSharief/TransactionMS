<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowStep};
use App\Services\OfficerAssignmentAccess;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OfficerReassignmentTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private WorkflowStep $step;
    private Transaction $tx;
    private TransactionStepRun $run;
    private User $admin;
    private User $receiver;
    private User $officer;

    protected function setUp(): void
    {
        parent::setUp();
        $this->office = Office::create(['code' => 'TEST', 'name' => 'Test Office']);
        foreach (['admin', 'clerk', 'viewer', 'superadmin'] as $code) {
            Role::firstOrCreate(['code' => $code], ['name' => ucfirst($code)]);
        }
        $type = TransactionType::create(['code' => 'TEST', 'name' => 'Test Type']);
        $workflow = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);
        $this->step = WorkflowStep::create(['workflow_definition_id' => $workflow->id, 'code' => 'TEST', 'name' => 'Test step', 'order_number' => 1, 'office_id' => $this->office->id, 'is_start' => true]);
        StepRole::create(['workflow_step_id' => $this->step->id, 'role_id' => Role::where('code', 'clerk')->value('id')]);
        $this->admin = $this->actor('admin');
        $this->receiver = $this->actor('clerk');
        $this->officer = $this->actor('clerk');
        $this->tx = Transaction::create(['transaction_type_id' => $type->id, 'workflow_definition_id' => $workflow->id, 'office_id' => $this->office->id, 'reference_number' => 'TEST-1', 'title' => 'Reassign me', 'created_by' => $this->receiver->id, 'is_done' => false]);
        TransactionState::create(['transaction_id' => $this->tx->id, 'current_step_id' => $this->step->id, 'entered_at' => now()]);
        $this->run = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $this->step->id, 'action_code' => 'create', 'performed_by' => $this->receiver->id, 'performed_at' => now(), 'received_by' => $this->receiver->id, 'received_at' => now(), 'received_office_id' => $this->office->id, 'sla_minutes_snapshot' => 60]);
    }

    private function actor(string $role, array $attributes = []): User
    {
        $user = User::factory()->create(array_merge(['office_id' => $this->office->id, 'is_active' => true], $attributes));
        $user->roles()->attach(Role::where('code', $role)->value('id'));
        return $user;
    }

    private function url(): string
    {
        return "/api/admin/transactions/{$this->tx->id}/officer-assignment";
    }

    private function assign(?User $officer = null, int $version = 0, array $changes = [])
    {
        Sanctum::actingAs($this->admin);
        return $this->postJson($this->url(), array_merge(['run_id' => $this->run->id, 'version' => $version, 'assigned_to' => ($officer ?? $this->officer)->id, 'reason' => 'Coverage during leave'], $changes));
    }

    public function test_assignment_preserves_receipt_and_sla_and_writes_history_and_audit(): void
    {
        $receipt = $this->run->received_at->toISOString();
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.can_reassign', true)->assertJsonPath('data.version', 0);
        $response = $this->assign()->assertOk()->assertJsonPath('data.current_officer.id', $this->officer->id)->assertJsonPath('data.history.0.from_officer.id', $this->receiver->id)->assertJsonPath('data.history.0.reason', 'Coverage during leave');
        $this->assertGreaterThan(0, $response->json('data.version'));
        $this->run->refresh();
        $this->assertSame($this->receiver->id, $this->run->received_by);
        $this->assertSame($receipt, $this->run->received_at->toISOString());
        $this->assertSame(60, $this->run->sla_minutes_snapshot);
        $this->assertDatabaseCount('transaction_step_runs', 1);
        $this->assertDatabaseHas('audit_logs', ['event' => 'transactions.officer_reassign', 'transaction_id' => $this->tx->id, 'step_run_id' => $this->run->id]);
    }

    public function test_invalid_noop_and_stale_submissions_are_rejected(): void
    {
        $this->assign($this->receiver)->assertUnprocessable();
        $this->assign(changes: ['reason' => ' '])->assertUnprocessable();
        $this->assign($this->actor('viewer'))->assertUnprocessable();
        $this->assign($this->actor('clerk', ['is_active' => false]))->assertUnprocessable();
        $first = $this->assign()->assertOk();
        $this->assign($this->receiver)->assertConflict();
        $this->assign($this->receiver, $first->json('data.version'))->assertOk()->assertJsonCount(2, 'data.history');
    }

    public function test_regular_and_wrong_office_administrators_cannot_reassign(): void
    {
        Sanctum::actingAs($this->receiver);
        $this->postJson($this->url(), ['run_id' => $this->run->id, 'version' => 0, 'assigned_to' => $this->officer->id, 'reason' => 'No'])->assertForbidden();
        $wrong = Office::create(['code' => 'WRONG', 'name' => 'Wrong']);
        $this->admin->update(['office_id' => $wrong->id]);
        $this->assign()->assertForbidden();
    }

    public function test_departed_pending_archived_and_completed_visits_cannot_be_assigned(): void
    {
        $this->assign(changes: ['run_id' => $this->run->id + 100])->assertConflict();
        $this->run->update(['received_at' => null]);
        $this->assign()->assertUnprocessable();
        $this->run->update(['received_at' => now()]);
        $this->tx->update(['is_archive' => true]);
        $this->assign()->assertUnprocessable();
        $this->tx->update(['is_archive' => false, 'is_done' => true]);
        $this->assign()->assertUnprocessable();
    }

    public function test_visibility_fails_closed_and_preserves_finalization_visit(): void
    {
        $this->assign()->assertOk();
        $access = app(OfficerAssignmentAccess::class);
        foreach ([$this->receiver, $this->actor('clerk'), $this->actor('viewer')] as $excluded) {
            $this->assertFalse($access->canAccess($this->tx, $excluded));
            $this->assertFalse($access->applyVisibility(Transaction::withoutGlobalScopes(), $excluded)->whereKey($this->tx->id)->exists());
        }
        $this->assertTrue($access->canAccess($this->tx, $this->officer));
        $finalize = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $this->step->id, 'action_code' => 'finalize', 'performed_by' => $this->admin->id, 'performed_at' => now(), 'received_at' => now(), 'received_by' => $this->admin->id]);
        $this->assertSame($this->run->id, $access->currentRun($this->tx)->id);
        $this->assertSame($this->officer->id, $access->responsibleOfficer($finalize)['id']);
        $this->assertTrue($access->canAccess($this->tx, $this->officer));
        $this->officer->update(['is_active' => false]);
        $this->assertFalse($access->canAccess($this->tx, $this->officer));
        $this->officer->roles()->detach();
        $this->officer->delete();
        $this->assertFalse($access->canAccess($this->tx, $this->receiver));
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.history.0.to_officer.name', $this->officer->name);
    }

    public function test_never_assigned_access_is_unchanged_but_inactive_administrators_fail_closed_after_assignment(): void
    {
        $access = app(OfficerAssignmentAccess::class);
        $wrong = Office::create(['code' => 'OTHER', 'name' => 'Other']);
        $otherAdmin = $this->actor('admin', ['office_id' => $wrong->id]);
        $this->assertTrue($access->canAccess($this->tx, $otherAdmin));
        $this->assign()->assertOk();
        $this->assertFalse($access->canAccess($this->tx, $otherAdmin));
        $superadmin = $this->actor('superadmin', ['is_active' => false]);
        $this->assertFalse($access->canAccess($this->tx, $superadmin));
        $this->assertFalse($access->applyVisibility(Transaction::withoutGlobalScopes(), $superadmin)->whereKey($this->tx->id)->exists());
    }

    public function test_later_unassigned_receiver_is_excluded_after_their_visit_ends(): void
    {
        $this->assign()->assertOk();
        $laterReceiver = $this->actor('clerk');
        $second = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $this->step->id, 'action_code' => 'return', 'performed_by' => $this->officer->id, 'performed_at' => now(), 'received_by' => $laterReceiver->id, 'received_at' => now()]);
        $access = app(OfficerAssignmentAccess::class);
        $this->assertTrue($access->canAccess($this->tx, $laterReceiver));
        TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $this->step->id, 'action_code' => 'return', 'performed_by' => $laterReceiver->id, 'performed_at' => now()]);
        $this->assertFalse($access->canAccess($this->tx, $laterReceiver));
        $this->assertFalse($access->applyVisibility(Transaction::withoutGlobalScopes(), $laterReceiver)->whereKey($this->tx->id)->exists());
    }

    public function test_unassigned_next_visit_blocks_prior_officers_but_allows_new_receivers_and_admin_restore(): void
    {
        $this->assign()->assertOk();
        $next = WorkflowStep::create(['workflow_definition_id' => $this->step->workflow_definition_id, 'code' => 'NEXT', 'name' => 'Next', 'order_number' => 2, 'office_id' => $this->office->id]);
        StepRole::create(['workflow_step_id' => $next->id, 'role_id' => Role::where('code', 'clerk')->value('id')]);
        DB::table('transaction_states')->where('transaction_id', $this->tx->id)->update(['current_step_id' => $next->id]);
        $nextRun = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $next->id, 'action_code' => 'submit', 'performed_by' => $this->officer->id, 'performed_at' => now()]);
        $this->tx->unsetRelation('state');
        $access = app(OfficerAssignmentAccess::class);
        $this->assertFalse($access->canAccess($this->tx, $this->officer));
        $this->assertFalse($access->canAccess($this->tx, $this->receiver));
        $this->assertTrue($access->canAccess($this->tx, $this->actor('clerk')));
        $nextRun->update(['received_by' => $this->admin->id, 'received_at' => now()]);
        $this->run = $nextRun;
        $this->assign($this->receiver)->assertOk();
        $this->assertTrue($access->canAccess($this->tx, $this->receiver));
    }
}
