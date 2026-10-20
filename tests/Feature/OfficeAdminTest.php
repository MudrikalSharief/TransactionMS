<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Office admin: superadmin powers limited to one office. Sees transactions
 * its office filed or that pass through one of its steps, acts at its own
 * office's steps, starts transactions for processes its office files, and
 * manages the regular users of its own office.
 */
class OfficeAdminTest extends TestCase
{
    use RefreshDatabase;

    private Office $csd;
    private Office $gso;
    private Office $cbo;
    private Role $adminRole;
    private Role $clerk;
    private Role $gsoStaff;
    private Role $cboStaff;
    private TransactionType $pr;
    private TransactionType $fuel;
    private WorkflowStep $prepare;   // CSD
    private WorkflowStep $canvass;   // GSO
    private WorkflowStep $budget;    // CBO
    private WorkflowStep $fuelStart; // CBO only
    private WorkflowRoute $toBudget;
    private WorkflowRoute $toCanvass;

    protected function setUp(): void
    {
        parent::setUp();

        $this->csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->cbo = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);

        $this->adminRole = Role::create(['code' => 'admin', 'name' => 'Admin']);
        $this->clerk = Role::create(['code' => 'clerk', 'name' => 'Clerk']);
        $this->gsoStaff = Role::create(['code' => 'gso', 'name' => 'GSO']);
        $this->cboStaff = Role::create(['code' => 'cbo', 'name' => 'CBO']);

        // Purchase request: CSD -> GSO -> CBO. Filed by CSD.
        $this->pr = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $this->pr->offices()->attach($this->csd->id);
        $wf = WorkflowDefinition::create(['transaction_type_id' => $this->pr->id, 'version' => 1, 'status' => 'published']);
        $this->prepare = $this->step($wf, 1, 'prepare', $this->csd, $this->clerk, isStart: true);
        $this->canvass = $this->step($wf, 2, 'canvass', $this->gso, $this->gsoStaff);
        $this->budget = $this->step($wf, 3, 'budget', $this->cbo, $this->cboStaff);
        $this->toCanvass = $this->route($wf, $this->prepare, $this->canvass);
        $this->toBudget = $this->route($wf, $this->canvass, $this->budget);

        // Fuel: a CBO-only process that never touches GSO.
        $this->fuel = TransactionType::create(['code' => 'fuel', 'name' => 'Fuel']);
        $fuelWf = WorkflowDefinition::create(['transaction_type_id' => $this->fuel->id, 'version' => 1, 'status' => 'published']);
        $this->fuelStart = $this->step($fuelWf, 1, 'fuel_start', $this->cbo, $this->cboStaff, isStart: true);
    }

    private function step(WorkflowDefinition $wf, int $order, string $code, Office $office, Role $role, bool $isStart = false): WorkflowStep
    {
        $step = WorkflowStep::create([
            'workflow_definition_id' => $wf->id,
            'order_number' => $order,
            'code' => $code,
            'name' => ucfirst($code),
            'office_id' => $office->id,
            'is_start' => $isStart,
        ]);
        StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $role->id]);

        return $step;
    }

    private function route(WorkflowDefinition $wf, WorkflowStep $from, WorkflowStep $to): WorkflowRoute
    {
        return WorkflowRoute::create([
            'workflow_definition_id' => $wf->id,
            'from_step_id' => $from->id,
            'to_step_id' => $to->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);
    }

    private function tx(WorkflowStep $at, ?Office $filedBy, bool $done = false): Transaction
    {
        $creator = User::factory()->create();
        $tx = Transaction::create([
            'transaction_type_id' => $at->workflowDefinition->transaction_type_id,
            'workflow_definition_id' => $at->workflow_definition_id,
            'office_id' => $filedBy?->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Test',
            'is_done' => $done,
            'created_by' => $creator->id,
        ]);
        TransactionState::create(['transaction_id' => $tx->id, 'current_step_id' => $at->id, 'entered_at' => now()]);

        return $tx;
    }

    private function user(?Office $office, Role ...$roles): User
    {
        $user = User::factory()->create(['office_id' => $office?->id]);
        $user->roles()->attach(collect($roles)->pluck('id')->all());

        return $user;
    }

    private function listedIds(User $user): array
    {
        Sanctum::actingAs($user);

        return collect($this->getJson('/api/transactions')->assertOk()->json('data'))->pluck('id')->sort()->values()->all();
    }

    public function test_office_admin_lists_transactions_filed_by_or_passing_through_their_office(): void
    {
        $passesGso = $this->tx($this->prepare, $this->csd);   // filed by CSD, route goes through GSO
        $filedByGso = $this->tx($this->fuelStart, $this->gso); // CBO-only route, but filed by GSO
        $elsewhere = $this->tx($this->fuelStart, $this->cbo);  // nothing to do with GSO

        $gsoAdmin = $this->user($this->gso, $this->adminRole);
        $this->assertSame([$passesGso->id, $filedByGso->id], $this->listedIds($gsoAdmin));

        $csdAdmin = $this->user($this->csd, $this->adminRole);
        $this->assertSame([$passesGso->id], $this->listedIds($csdAdmin));

        // Regular users keep the role gate: only rows waiting at their station.
        $cbo = $this->user($this->cbo, $this->cboStaff);
        $this->assertSame([$filedByGso->id, $elsewhere->id], $this->listedIds($cbo));
    }

    public function test_office_admin_can_view_in_scope_transactions_even_when_finished(): void
    {
        $gsoAdmin = $this->user($this->gso, $this->adminRole);
        $finished = $this->tx($this->budget, $this->csd, done: true);
        $outOfScope = $this->tx($this->fuelStart, $this->cbo);

        Sanctum::actingAs($gsoAdmin);
        $this->getJson("/api/transactions/{$finished->id}")->assertOk();
        $this->getJson("/api/transactions/{$outOfScope->id}")->assertForbidden();
    }

    public function test_office_admin_acts_only_at_their_own_office_steps(): void
    {
        $gsoAdmin = $this->user($this->gso, $this->adminRole);
        Sanctum::actingAs($gsoAdmin);

        // At GSO's canvass step: may act without holding the gso role.
        $atGso = $this->tx($this->canvass, $this->csd);
        $this->getJson("/api/transactions/{$atGso->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions.0.route_id', $this->toBudget->id);

        // At CSD's prepare step: view-only.
        $atCsd = $this->tx($this->prepare, $this->csd);
        $this->getJson("/api/transactions/{$atCsd->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions', []);
        $this->postJson("/api/transactions/{$atCsd->id}/execute", ['route_id' => $this->toCanvass->id])
            ->assertForbidden();
    }

    public function test_office_admin_acts_at_step_one_of_their_office_requests_even_without_an_office_on_it(): void
    {
        // Step 1 with no office assigned (like Procurement's first steps).
        $this->prepare->update(['office_id' => null]);
        $csdRequest = $this->tx($this->prepare, $this->csd);
        $gsoRequest = $this->tx($this->prepare, $this->gso);

        Sanctum::actingAs($this->user($this->csd, $this->adminRole));
        $this->getJson("/api/transactions/{$csdRequest->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions.0.route_id', $this->toCanvass->id);
        // Filed by GSO, and with step 1 office-less the route never touches CSD: out of scope.
        $this->getJson("/api/transactions/{$gsoRequest->id}")->assertForbidden();

        // GSO admin sees the CSD request (it passes through GSO) but step 1 isn't theirs.
        Sanctum::actingAs($this->user($this->gso, $this->adminRole));
        $this->getJson("/api/transactions/{$csdRequest->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions', []);
        $this->getJson("/api/transactions/{$gsoRequest->id}")
            ->assertOk()
            ->assertJsonPath('meta.available_actions.0.route_id', $this->toCanvass->id);
    }

    public function test_office_admin_starts_transactions_only_for_processes_their_office_files(): void
    {
        Sanctum::actingAs($this->user($this->csd, $this->adminRole));
        $this->postJson('/api/transactions', ['transaction_type_id' => $this->pr->id, 'title' => 'Laptops'])
            ->assertCreated()
            ->assertJsonPath('data.office.id', $this->csd->id);

        // GSO isn't linked to the purchase request process (linked to CSD only).
        Sanctum::actingAs($this->user($this->gso, $this->adminRole));
        $this->postJson('/api/transactions', ['transaction_type_id' => $this->pr->id])
            ->assertUnprocessable()
            ->assertJsonPath('message', 'Your office is not allowed to create this transaction type.');

        // A process linked to no office is open to every office.
        $this->postJson('/api/transactions', ['transaction_type_id' => $this->fuel->id])
            ->assertCreated()
            ->assertJsonPath('data.office.id', $this->gso->id);
        $offered = collect($this->getJson('/api/office/transaction-types')->assertOk()->json('data'))->pluck('code');
        $this->assertSame(['fuel'], $offered->values()->all());

        // Processes without a published workflow aren't offered (they can't start).
        TransactionType::create(['code' => 'draft_only', 'name' => 'Draft only']);
        $offered = collect($this->getJson('/api/office/transaction-types')->json('data'))->pluck('code');
        $this->assertFalse($offered->contains('draft_only'));

        // Regular users can't start transactions here.
        Sanctum::actingAs($this->user($this->csd, $this->clerk));
        $this->postJson('/api/transactions', ['transaction_type_id' => $this->pr->id])->assertForbidden();
    }

    public function test_office_admin_manages_only_regular_users_of_their_own_office(): void
    {
        $gsoAdmin = $this->user($this->gso, $this->adminRole);
        $gsoClerk = $this->user($this->gso, $this->gsoStaff);
        $peerAdmin = $this->user($this->gso, $this->adminRole);
        $csdClerk = $this->user($this->csd, $this->clerk);
        Sanctum::actingAs($gsoAdmin);

        $listed = collect($this->getJson('/api/office/users')->assertOk()->json('data'))->pluck('id')->sort()->values()->all();
        $this->assertSame(collect([$gsoAdmin->id, $gsoClerk->id, $peerAdmin->id])->sort()->values()->all(), $listed);

        // New users always join the admin's office; admin/superadmin can't be granted.
        $created = $this->postJson('/api/office/users', [
            'name' => 'New Staff', 'email' => 'new@lgu.test', 'password' => 'secret123',
            'office_id' => $this->csd->id, 'role_ids' => [$this->gsoStaff->id],
        ])->assertCreated();
        $this->assertSame($this->gso->id, $created->json('data.office_id'));
        $this->postJson('/api/office/users', [
            'name' => 'Sneaky', 'email' => 'sneaky@lgu.test', 'password' => 'secret123',
            'role_ids' => [$this->adminRole->id],
        ])->assertUnprocessable();

        $edit = fn (User $u) => ['name' => $u->name, 'email' => $u->email, 'role_ids' => [$this->gsoStaff->id]];
        $this->putJson("/api/office/users/{$gsoClerk->id}", $edit($gsoClerk))->assertOk();
        $this->putJson("/api/office/users/{$csdClerk->id}", $edit($csdClerk))->assertNotFound();
        $this->putJson("/api/office/users/{$peerAdmin->id}", $edit($peerAdmin))->assertForbidden();
        $this->putJson("/api/office/users/{$gsoAdmin->id}", $edit($gsoAdmin))->assertUnprocessable();
        $this->deleteJson("/api/office/users/{$peerAdmin->id}")->assertForbidden();

        $roleCodes = collect($this->getJson('/api/office/roles')->assertOk()->json('data'))->pluck('code');
        $this->assertFalse($roleCodes->contains('admin'));
        $this->assertTrue($roleCodes->contains('gso'));
    }

    public function test_office_area_needs_an_admin_with_an_office_and_admin_area_stays_superadmin_only(): void
    {
        Sanctum::actingAs($this->user(null, $this->adminRole));
        $this->getJson('/api/office/users')
            ->assertForbidden()
            ->assertJsonPath('message', 'Your admin account has no office assigned. Ask a superadmin to set one.');

        Sanctum::actingAs($this->user($this->gso, $this->gsoStaff));
        $this->getJson('/api/office/users')->assertForbidden();

        Sanctum::actingAs($this->user($this->gso, $this->adminRole));
        $this->getJson('/api/admin/users')->assertForbidden();
    }

    public function test_office_summary_counts_only_their_office_scope(): void
    {
        $this->tx($this->prepare, $this->csd);   // passes through GSO
        $this->tx($this->fuelStart, $this->cbo); // not GSO's

        Sanctum::actingAs($this->user($this->gso, $this->adminRole));
        $this->getJson('/api/office/dashboard/summary')->assertOk()->assertJsonPath('in_process', 1);

        Sanctum::actingAs($this->user(null, Role::create(['code' => 'superadmin', 'name' => 'Super Admin'])));
        $this->getJson('/api/admin/dashboard/summary')->assertOk()->assertJsonPath('in_process', 2);
    }
}
