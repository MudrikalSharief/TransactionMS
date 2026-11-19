<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowRoute, WorkflowStep};
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

    private function forwardToOtherOffice(): array
    {
        $office = Office::create(['code' => 'OTHER', 'name' => 'Receiving Office']);
        $step = WorkflowStep::create(['workflow_definition_id' => $this->step->workflow_definition_id, 'code' => 'OTHER', 'name' => 'Other office step', 'order_number' => 2, 'office_id' => $office->id]);
        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => Role::where('code', 'clerk')->value('id')]);
        $receiver = $this->actor('clerk', ['office_id' => $office->id]);
        $run = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $step->id, 'action_code' => 'submit', 'performed_by' => $this->receiver->id, 'performed_at' => now(), 'received_by' => $receiver->id, 'received_at' => now(), 'received_office_id' => $office->id]);
        $this->tx->state()->update(['current_step_id' => $step->id]);
        $this->tx->unsetRelation('state');
        return ['office' => $office, 'step' => $step, 'receiver' => $receiver, 'run' => $run];
    }

    public function test_departed_office_can_reassign_and_replacement_can_view_but_not_process_other_office_work(): void
    {
        $next = $this->forwardToOtherOffice();
        $this->tx->update(['office_id' => $next['office']->id]);
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.run_id', $this->run->id)->assertJsonPath('data.can_reassign', true);
        $this->getJson('/api/admin/transactions?q=TEST-1')->assertOk()->assertJsonPath('data.0.can_reassign_officer', true);
        $this->getJson("/api/admin/transactions/{$this->tx->id}")->assertOk();
        $this->assign()->assertOk()->assertJsonPath('data.office.id', $this->office->id)->assertJsonPath('data.history.0.office.id', $this->office->id)->assertJsonPath('data.history.0.step.id', $this->step->id);
        $this->assertNull($next['run']->fresh()->assigned_to);
        $this->assertSame($next['step']->id, $this->tx->state()->value('current_step_id'));
        $this->assertSame($this->receiver->id, $this->run->fresh()->received_by);

        Sanctum::actingAs($this->officer);
        $this->getJson("/api/transactions/{$this->tx->id}")->assertOk();
        $this->getJson("/api/admin/transactions/{$this->tx->id}")->assertOk();
        $this->getJson("/api/admin/transactions/{$this->tx->id}/attachments")->assertOk();
        foreach (['/api/transactions', '/api/admin/transactions'] as $list) {
            $this->getJson($list.'?q=TEST-1')->assertOk()->assertJsonCount(1, 'data');
        }
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertForbidden();
        $this->postJson("/api/transactions/{$this->tx->id}/execute", ['route_id' => 1])->assertForbidden();
        Sanctum::actingAs($this->receiver);
        $this->assertContains($this->getJson("/api/transactions/{$this->tx->id}")->status(), [403, 404]);
        Sanctum::actingAs($next['receiver']);
        $this->getJson("/api/transactions/{$this->tx->id}")->assertOk();
    }

    public function test_other_office_admin_cannot_select_or_reassign_departed_offices_visit(): void
    {
        $next = $this->forwardToOtherOffice();
        $otherAdmin = $this->actor('admin', ['office_id' => $next['office']->id]);
        Sanctum::actingAs($otherAdmin);
        $this->getJson($this->url().'?run_id='.$this->run->id)->assertForbidden();
        $this->postJson($this->url(), ['run_id' => $this->run->id, 'version' => 0, 'assigned_to' => $this->officer->id, 'reason' => 'Wrong office'])->assertForbidden();
    }

    public function test_pending_return_can_be_assigned_before_receipt_and_supersedes_departed_visit(): void
    {
        $next = $this->forwardToOtherOffice();
        $return = TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $next['step']->id, 'to_step_id' => $this->step->id, 'action_code' => 'return', 'performed_by' => $next['receiver']->id, 'performed_at' => now(), 'received_office_id' => $this->office->id]);
        $this->tx->state()->update(['current_step_id' => $this->step->id]);
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.run_id', $return->id)->assertJsonPath('data.can_reassign', true)->assertJsonPath('data.is_pending', true);
        $this->assign()->assertConflict();
        $this->run = $return;
        $this->assign()->assertOk();
        $this->assertNull($return->fresh()->received_at);
        $this->assertNull($return->fresh()->received_by);
        Sanctum::actingAs($this->receiver);
        $this->assertContains($this->postJson("/api/transactions/{$this->tx->id}/receive")->status(), [403, 404]);
        Sanctum::actingAs($this->officer);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
        $this->assertSame($this->officer->id, $return->fresh()->received_by);
        $this->assertSame($this->officer->id, $return->fresh()->assigned_to);
    }

    public function test_superadmin_can_select_each_office_and_cannot_overwrite_a_newer_assignment_version(): void
    {
        $next = $this->forwardToOtherOffice();
        $this->admin = $this->actor('superadmin');
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url().'?run_id='.$this->run->id)->assertOk()->assertJsonPath('data.run_id', $this->run->id)->assertJsonCount(2, 'data.visits');
        $first = $this->assign()->assertOk();
        $this->assign($this->receiver)->assertConflict();
        $this->assign($this->receiver, $first->json('data.version'))->assertOk();
        $this->assertNull($next['run']->fresh()->assigned_to);
        Sanctum::actingAs($this->officer);
        $this->assertContains($this->getJson("/api/transactions/{$this->tx->id}")->status(), [403, 404]);
    }

    private function sendBack(array $next, bool $jump = false)
    {
        Sanctum::actingAs($next['receiver']);
        if ($jump) {
            return $this->postJson("/api/transactions/{$this->tx->id}/goto", ['to_step_id' => $this->step->id, 'remarks' => 'Please correct']);
        }
        $route = WorkflowRoute::create(['workflow_definition_id' => $this->step->workflow_definition_id, 'from_step_id' => $next['step']->id, 'to_step_id' => $this->step->id, 'action_code' => 'return', 'is_return_route' => true]);
        return $this->postJson("/api/transactions/{$this->tx->id}/execute", ['route_id' => $route->id, 'remarks' => 'Please correct']);
    }

    public function test_return_automatically_restores_original_receiver_without_fabricating_receipt(): void
    {
        $originalReceipt = $this->run->received_at->toISOString();
        $next = $this->forwardToOtherOffice();
        $this->sendBack($next)->assertOk();
        $returned = $this->tx->runs()->latest('id')->first();
        $this->assertSame($this->step->id, $returned->to_step_id);
        $this->assertSame($this->office->id, $returned->received_office_id);
        $this->assertSame($this->receiver->id, $returned->assigned_to);
        $this->assertNull($returned->received_at);
        $this->assertNull($returned->received_by);
        $this->assertSame($originalReceipt, $this->run->fresh()->received_at->toISOString());
        $this->assertDatabaseHas('transaction_officer_assignments', ['transaction_step_run_id' => $returned->id, 'to_user_id' => $this->receiver->id, 'assigned_by_name' => 'System', 'is_automatic' => true]);
        $this->assertDatabaseHas('audit_logs', ['event' => 'transactions.officer_restore', 'step_run_id' => $returned->id]);
        Sanctum::actingAs($this->officer);
        $this->assertContains($this->postJson("/api/transactions/{$this->tx->id}/receive")->status(), [403, 404]);
        Sanctum::actingAs($this->receiver);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
        $this->assertSame($this->receiver->id, $returned->fresh()->received_by);
    }

    public function test_backward_jump_restores_reassigned_officer_instead_of_original_receiver(): void
    {
        $next = $this->forwardToOtherOffice();
        $this->assign()->assertOk();
        $this->sendBack($next, true)->assertOk();
        $returned = $this->tx->runs()->latest('id')->first();
        $this->assertSame($this->officer->id, $returned->assigned_to);
        $this->assertSame($this->receiver->id, $this->run->fresh()->received_by);
        Sanctum::actingAs($this->receiver);
        $this->assertContains($this->postJson("/api/transactions/{$this->tx->id}/receive")->status(), [403, 404]);
        Sanctum::actingAs($this->officer);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
    }

    public function test_return_uses_the_latest_prior_visit_to_the_destination_step(): void
    {
        $next = $this->forwardToOtherOffice();
        TransactionStepRun::create(['transaction_id' => $this->tx->id, 'from_step_id' => $next['step']->id, 'to_step_id' => $this->step->id, 'action_code' => 'return', 'performed_by' => $next['receiver']->id, 'performed_at' => now(), 'received_by' => $this->officer->id, 'received_at' => now(), 'received_office_id' => $this->office->id]);
        $secondDeparture = $next['run']->replicate();
        $secondDeparture->save();
        $this->sendBack($next)->assertOk();
        $this->assertSame($this->officer->id, $this->tx->runs()->latest('id')->first()->assigned_to);
    }

    public static function unavailableOfficers(): array
    {
        return [['inactive'], ['deleted'], ['different-office'], ['different-role']];
    }

    #[\PHPUnit\Framework\Attributes\DataProvider('unavailableOfficers')]
    public function test_unavailable_previous_officer_keeps_return_pending_for_admin_reassignment(string $change): void
    {
        $this->assign()->assertOk();
        $next = $this->forwardToOtherOffice();
        if ($change === 'inactive') $this->officer->update(['is_active' => false]);
        if ($change === 'different-office') $this->officer->update(['office_id' => $next['office']->id]);
        if (in_array($change, ['deleted', 'different-role'], true)) $this->officer->roles()->detach();
        if ($change === 'deleted') $this->officer->delete();

        $this->sendBack($next)->assertOk();
        $returned = $this->tx->runs()->latest('id')->first();
        $this->assertNull($returned->assigned_to);
        $this->assertNull($returned->received_at);
        Sanctum::actingAs($this->admin);
        $assignment = $this->getJson($this->url())->assertOk()->assertJsonPath('data.requires_reassignment', true)->assertJsonPath('data.can_reassign', true);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertUnprocessable();
        Sanctum::actingAs($this->receiver);
        $this->assertContains($this->postJson("/api/transactions/{$this->tx->id}/receive")->status(), [403, 404]);

        $this->run = $returned;
        $replacement = $this->actor('clerk');
        $this->assign($replacement, $assignment->json('data.version'))->assertOk()->assertJsonPath('data.requires_reassignment', false);
        Sanctum::actingAs($replacement);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
    }

    public static function forwardMethods(): array
    {
        return [['route'], ['resend']];
    }

    #[\PHPUnit\Framework\Attributes\DataProvider('forwardMethods')]
    public function test_forward_routes_and_resends_do_not_create_automatic_return_assignments(string $method): void
    {
        $next = $this->forwardToOtherOffice();
        $this->sendBack($next, true)->assertOk();
        Sanctum::actingAs($this->receiver);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
        if ($method === 'route') {
            $route = WorkflowRoute::create(['workflow_definition_id' => $this->step->workflow_definition_id, 'from_step_id' => $this->step->id, 'to_step_id' => $next['step']->id, 'action_code' => 'submit', 'is_return_route' => false]);
            $this->postJson("/api/transactions/{$this->tx->id}/execute", ['route_id' => $route->id])->assertOk();
        } else {
            $this->postJson("/api/transactions/{$this->tx->id}/goto", ['to_step_id' => $next['step']->id, 'remarks' => 'Corrections completed'])->assertOk();
        }
        $forwarded = $this->tx->runs()->latest('id')->first();
        $this->assertNull($forwarded->assigned_to);
        $this->assertDatabaseCount('transaction_officer_assignments', 1);
        Sanctum::actingAs($next['receiver']);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
    }

    public function test_missing_legacy_receiver_requires_admin_reassignment_on_return(): void
    {
        $this->run->update(['received_by' => null]);
        $next = $this->forwardToOtherOffice();
        $this->sendBack($next)->assertOk();
        Sanctum::actingAs($this->admin);
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.requires_reassignment', true)->assertJsonPath('data.can_reassign', true);
    }

    public function test_automatic_assignment_audit_failure_rolls_back_the_return(): void
    {
        $next = $this->forwardToOtherOffice();
        $audit = \Mockery::mock(\App\Services\AuditService::class)->makePartial();
        $audit->shouldReceive('log')->withArgs(fn ($request, $event) => $event === 'transactions.officer_restore')
            ->once()->andThrow(new \RuntimeException('Return audit write failed'));
        $this->app->instance(\App\Services\AuditService::class, $audit);
        $this->withoutExceptionHandling();
        try {
            $this->sendBack($next);
            $this->fail('The return continued after its assignment audit failed.');
        } catch (\RuntimeException $error) {
            $this->assertSame('Return audit write failed', $error->getMessage());
        }
        $this->assertSame($next['step']->id, $this->tx->state()->value('current_step_id'));
        $this->assertDatabaseCount('transaction_step_runs', 2);
        $this->assertDatabaseCount('transaction_officer_assignments', 0);
    }
}
