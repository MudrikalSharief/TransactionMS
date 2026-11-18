<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionAttachment, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowRoute, WorkflowStep};
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OfficerAssignmentAccessTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private WorkflowStep $step;
    private Transaction $tx;
    private TransactionStepRun $run;
    private User $old;
    private User $next;
    private User $admin;

    protected function setUp(): void
    {
        parent::setUp();
        $this->office = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->old = $this->actor('clerk');
        $this->next = $this->actor('clerk');
        $this->admin = $this->actor('admin');
        $type = TransactionType::create(['code' => 'assignment', 'name' => 'Assignment test']);
        $workflow = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);
        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id, 'order_number' => 1,
            'code' => 'processing', 'name' => 'Processing', 'office_id' => $this->office->id, 'is_start' => true,
        ]);
        StepRole::create(['workflow_step_id' => $this->step->id, 'role_id' => Role::where('code', 'clerk')->first()->id]);
        $this->tx = Transaction::create([
            'transaction_type_id' => $type->id, 'workflow_definition_id' => $workflow->id,
            'office_id' => $this->office->id, 'reference_number' => 'EXCLUSIVE-1',
            'created_by' => $this->old->id, 'is_done' => false,
        ]);
        TransactionState::create(['transaction_id' => $this->tx->id, 'current_step_id' => $this->step->id, 'entered_at' => now()]);
        $this->run = $this->arrival($this->step, $this->old);
    }

    private function actor(string $code): User
    {
        $actor = User::factory()->create(['office_id' => $this->office->id, 'is_active' => true]);
        $actor->roles()->attach(Role::firstOrCreate(['code' => $code], ['name' => $code]));
        return $actor;
    }

    private function arrival(WorkflowStep $step, ?User $receiver): TransactionStepRun
    {
        return TransactionStepRun::create([
            'transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id, 'to_step_id' => $step->id,
            'action_code' => 'submit', 'performed_by' => $this->admin->id, 'performed_at' => now(),
            'received_by' => $receiver?->id, 'received_at' => $receiver ? now() : null,
            'received_office_id' => $this->office->id,
        ]);
    }

    private function assign(?User $target = null, ?TransactionStepRun $run = null, int $version = 0): void
    {
        Sanctum::actingAs($this->admin);
        $this->postJson("/api/admin/transactions/{$this->tx->id}/officer-assignment", [
            'run_id' => ($run ?? $this->run)->id, 'version' => $version,
            'assigned_to' => ($target ?? $this->next)->id, 'reason' => 'Transfer current workload',
        ])->assertOk();
    }

    private function denied(string $url, string $method = 'get', array $data = []): void
    {
        $response = $this->{$method.'Json'}($url, $data);
        $this->assertContains($response->status(), [403, 404], $url.' must deny access: '.$response->getContent());
    }

    public function test_transfer_revokes_creator_detail_files_and_mutations_but_assignee_retains_access(): void
    {
        Storage::fake('local');
        Storage::disk('local')->put('assignment.txt', 'Assigned evidence');
        $attachment = TransactionAttachment::create([
            'transaction_id' => $this->tx->id, 'workflow_step_id' => $this->step->id,
            'original_name' => 'evidence.txt', 'stored_path' => 'assignment.txt', 'disk' => 'local',
            'mime' => 'text/plain', 'size_bytes' => 17, 'uploaded_by' => $this->old->id,
        ]);
        $this->assign();
        Sanctum::actingAs($this->old);
        foreach (['/api', '/api/admin'] as $prefix) {
            $base = "$prefix/transactions/{$this->tx->id}";
            $this->denied($base);
            $this->denied("$base/attachments");
            $this->denied("$base/attachments/{$attachment->id}/view");
            $this->denied("$base/attachments/{$attachment->id}/download");
            $this->denied("$base/receive", 'post');
            $this->denied("$base/execute", 'post', ['route_id' => 123]);
            $this->denied("$base/attachments/{$attachment->id}", 'delete');
            $this->denied("$base/steps/{$this->step->id}/receivers");
        }
        Sanctum::actingAs($this->next);
        $this->getJson("/api/transactions/{$this->tx->id}")->assertOk();
        $this->getJson("/api/transactions/{$this->tx->id}/attachments/{$attachment->id}/download")->assertOk();
        $this->assertDatabaseHas('transaction_step_runs', ['id' => $this->run->id, 'received_by' => $this->old->id]);
    }

    public function test_lists_approvals_and_dashboard_do_not_leak_to_office_colleagues_or_creator(): void
    {
        $colleague = $this->actor('clerk');
        $this->assign();
        foreach ([$this->old, $colleague] as $excluded) {
            Sanctum::actingAs($excluded);
            foreach (['/api/transactions', '/api/admin/transactions'] as $list) {
                $this->getJson($list.'?q=EXCLUSIVE-1')->assertOk()->assertJsonCount(0, 'data');
            }
            $this->getJson('/api/approvals')->assertOk()->assertJsonCount(0, 'data');
            $this->getJson('/api/portal/summary')->assertOk()->assertJsonPath('office_total', 0)->assertJsonPath('created_by_me', 0);
        }
        Sanctum::actingAs($this->next);
        $this->getJson('/api/transactions?q=EXCLUSIVE-1')->assertOk()->assertJsonCount(1, 'data');
    }

    public function test_viewer_cannot_find_public_assigned_transactions(): void
    {
        $viewer = $this->actor('viewer');
        $this->assign();
        Sanctum::actingAs($viewer);
        $this->getJson('/api/viewer/transactions?q=EXCLUSIVE-1')->assertOk()->assertJsonCount(0, 'data');
        $this->denied("/api/viewer/transactions/{$this->tx->id}");
    }

    public function test_past_officers_stay_excluded_at_next_visit_and_explicit_assignment_restores_access(): void
    {
        $third = $this->actor('clerk');
        $this->assign();
        $nextStep = $this->step->replicate();
        $nextStep->code = 'second';
        $nextStep->order_number = 2;
        $nextStep->save();
        StepRole::create(['workflow_step_id' => $nextStep->id, 'role_id' => Role::where('code', 'clerk')->first()->id]);
        $newRun = $this->arrival($nextStep, null);
        $this->tx->state()->update(['current_step_id' => $nextStep->id]);
        foreach ([$this->old, $this->next] as $past) {
            Sanctum::actingAs($past);
            $this->denied("/api/transactions/{$this->tx->id}");
            $this->denied("/api/transactions/{$this->tx->id}/receive", 'post');
        }
        Sanctum::actingAs($third);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
        $this->assign($this->old, $newRun);
        Sanctum::actingAs($this->old);
        $this->getJson("/api/transactions/{$this->tx->id}")->assertOk();
        Sanctum::actingAs($this->next);
        $this->denied("/api/transactions/{$this->tx->id}");
    }

    public function test_deleted_or_inactive_assignee_does_not_reopen_access(): void
    {
        $this->assign();
        Sanctum::actingAs($this->admin);
        $this->next->update(['is_active' => false]);
        Sanctum::actingAs($this->next);
        $this->denied("/api/transactions/{$this->tx->id}");
        Sanctum::actingAs($this->admin);
        $this->next->roles()->detach();
        $this->next->delete();
        Sanctum::actingAs($this->old);
        $this->denied("/api/transactions/{$this->tx->id}");
        Sanctum::actingAs($this->admin);
        $this->getJson("/api/admin/transactions/{$this->tx->id}")->assertOk();
    }

    public function test_finalization_self_loop_preserves_the_assignment_lock(): void
    {
        $this->assign();
        Sanctum::actingAs($this->admin);
        $this->tx->update(['is_done' => true]);
        $this->arrival($this->step, $this->admin)->update(['action_code' => 'finalize']);
        Sanctum::actingAs($this->old);
        $this->denied("/api/admin/transactions/{$this->tx->id}");
        Sanctum::actingAs($this->next);
        $this->getJson("/api/admin/transactions/{$this->tx->id}")->assertOk();
    }

    public function test_stale_bound_write_is_rechecked_before_controller_executes(): void
    {
        $staleTransaction = $this->tx;
        $this->assign();
        Sanctum::actingAs($this->old);
        $request = \Illuminate\Http\Request::create("/api/transactions/{$this->tx->id}/execute", 'POST');
        $request->setUserResolver(fn () => $this->old);
        $route = new \Illuminate\Routing\Route('POST', 'api/transactions/{transaction}/execute', fn () => null);
        $route->bind($request);
        $route->setParameter('transaction', $staleTransaction);
        $request->setRouteResolver(fn () => $route);
        $ran = false;
        try {
            app(\App\Http\Middleware\EnforceOfficerAssignment::class)->handle($request, function () use (&$ran) {
                $ran = true;
                return response()->json(['unexpected' => true]);
            });
            $this->fail('A stale transaction write was allowed after ownership transfer.');
        } catch (\Symfony\Component\HttpKernel\Exception\HttpException $e) {
            $this->assertSame(403, $e->getStatusCode());
        }
        $this->assertFalse($ran);
    }

    public function test_assignee_can_route_and_the_next_office_can_receive_without_restoring_old_access(): void
    {
        $newReceiver = $this->actor('clerk');
        $second = $this->step->replicate();
        $second->code = 'routed';
        $second->order_number = 2;
        $second->save();
        StepRole::create(['workflow_step_id' => $second->id, 'role_id' => Role::where('code', 'clerk')->first()->id]);
        $route = WorkflowRoute::create([
            'workflow_definition_id' => $this->tx->workflow_definition_id,
            'from_step_id' => $this->step->id, 'to_step_id' => $second->id,
            'action_code' => 'submit', 'is_return_route' => false,
        ]);
        $this->assign();
        Sanctum::actingAs($this->next);
        $this->postJson("/api/transactions/{$this->tx->id}/execute", ['route_id' => $route->id])->assertOk();
        $this->denied("/api/transactions/{$this->tx->id}");
        Sanctum::actingAs($newReceiver);
        $this->postJson("/api/transactions/{$this->tx->id}/receive")->assertOk();
        $this->getJson("/api/transactions/{$this->tx->id}")->assertOk();
        Sanctum::actingAs($this->old);
        $this->denied("/api/transactions/{$this->tx->id}");
    }
}
