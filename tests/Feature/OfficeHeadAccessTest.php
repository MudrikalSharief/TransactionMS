<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * Office Head is a dedicated read-only role: it sees the same system-wide
 * dashboard data as a superadmin, but never enters the office-admin area.
 */
class OfficeHeadAccessTest extends TestCase
{
    use RefreshDatabase;

    private Office $csd;
    private Office $gso;
    private Role $headRole;
    private Role $adminRole;
    private Role $superRole;
    private Role $clerkRole;
    private User $head;
    private User $pendingCsd;
    private User $pendingGso;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $step;

    protected function setUp(): void
    {
        parent::setUp();

        $this->csd = Office::create(['code' => 'CSD', 'name' => 'Computer Service Division']);
        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);

        $this->headRole = Role::create([
            'code' => 'office_head',
            'name' => 'Office Head',
            'office_id' => $this->csd->id,
        ]);
        $this->adminRole = Role::firstOrCreate(['code' => 'admin'], ['name' => 'Admin']);
        $this->superRole = Role::firstOrCreate(['code' => 'superadmin'], ['name' => 'Super Admin']);
        $this->clerkRole = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);

        $this->head = $this->account($this->csd, $this->headRole);
        $this->pendingCsd = $this->pendingAccount($this->csd);
        $this->pendingGso = $this->pendingAccount($this->gso);

        $this->type = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);
        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'start',
            'name' => 'Start',
            'is_start' => true,
        ]);
    }

    private function account(Office $office, Role ...$roles): User
    {
        $user = User::factory()->create(['office_id' => $office->id]);
        $user->roles()->attach(collect($roles)->pluck('id')->all());

        return $user;
    }

    private function pendingAccount(Office $office): User
    {
        $user = User::factory()->create([
            'office_id' => $office->id,
            'approved_at' => null,
            'is_active' => false,
        ]);
        $user->roles()->attach($this->clerkRole->id);

        return $user;
    }

    private function transaction(Office $office): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'office_id' => $office->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Office head dashboard test',
            'is_done' => false,
            'created_by' => $this->head->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $this->step->id,
            'entered_at' => now(),
        ]);

        return $tx;
    }

    public function test_office_head_dashboard_shows_one_office_at_a_time(): void
    {
        $this->transaction($this->csd);
        $this->transaction($this->csd);
        $this->transaction($this->gso);

        Sanctum::actingAs($this->head);

        // Default: the head's own office, not every office.
        $summary = $this->getJson('/api/office-head/dashboard/summary')->assertOk();
        $this->assertSame(2, $summary->json('in_process'), 'Office head should default to their own office');

        // The picker can switch to another office.
        $other = $this->getJson('/api/office-head/dashboard/summary?office_id='.$this->gso->id)->assertOk();
        $this->assertSame(1, $other->json('in_process'), 'Office head should see the selected office only');

        $this->getJson('/api/office-head/dashboard/overdue-overview')->assertOk();
        $this->getJson('/api/office-head/dashboard/overdue-overview?office_id='.$this->gso->id)->assertOk();

        $officeCodes = collect($this->getJson('/api/office-head/offices')->assertOk()->json('data'))
            ->pluck('code');
        $this->assertTrue($officeCodes->contains('CSD'));
        $this->assertTrue($officeCodes->contains('GSO'));

        $report = $this->getJson('/api/office-head/reports/monitoring')->assertOk();
        $this->assertCount(2, $report->json('by_office'), 'Report should cover both offices');

        $pendingIds = collect($this->getJson('/api/office-head/pending-accounts')->assertOk()->json('data'))
            ->pluck('id')
            ->all();
        $this->assertEqualsCanonicalizing(
            [$this->pendingCsd->id, $this->pendingGso->id],
            $pendingIds
        );
    }

    public function test_office_head_cannot_enter_the_office_admin_area(): void
    {
        Sanctum::actingAs($this->head);

        foreach ([
            '/api/office/users',
            '/api/office/roles',
            '/api/office/transaction-types',
            '/api/office/dashboard/summary',
            '/api/admin/users',
            '/api/admin/activity',
        ] as $url) {
            $this->getJson($url)->assertForbidden();
        }

        $this->postJson('/api/admin/transaction-types', [])->assertForbidden();
    }

    public function test_office_admin_and_superadmin_keep_their_access(): void
    {
        Sanctum::actingAs($this->account($this->csd, $this->adminRole));
        $this->getJson('/api/office/users')->assertOk();
        $this->getJson('/api/office/dashboard/summary')->assertOk();
        $this->getJson('/api/office-head/dashboard/summary')->assertForbidden();

        Sanctum::actingAs($this->account($this->csd, $this->superRole));
        $this->getJson('/api/admin/dashboard/summary')->assertOk();
        $this->getJson('/api/office-head/dashboard/summary')->assertForbidden();
    }

    public function test_admin_role_outranks_office_head(): void
    {
        $both = $this->account($this->csd, $this->adminRole, $this->headRole);

        $this->assertTrue($both->isOfficeAdmin());
        $this->assertFalse($both->isOfficeHead());

        Sanctum::actingAs($both);
        $this->getJson('/api/office-head/dashboard/summary')->assertForbidden();
        $this->getJson('/api/office/users')->assertOk();
    }

    public function test_office_head_without_an_office_sees_no_office_data(): void
    {
        $headless = User::factory()->create(['office_id' => null]);
        $headless->roles()->attach($this->headRole->id);

        $this->assertTrue($headless->isOfficeHead());

        Sanctum::actingAs($headless);
        $summary = $this->getJson('/api/office-head/dashboard/summary')->assertOk();
        $this->assertSame(0, $summary->json('in_process'), 'Without an office, no office data is shown');
    }
}
