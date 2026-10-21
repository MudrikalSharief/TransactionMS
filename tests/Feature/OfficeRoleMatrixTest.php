<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\StepRole;
use App\Models\Transaction;
use App\Models\TransactionState;
use App\Models\TransactionStepRun;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use App\Models\WorkflowRoute;
use App\Models\WorkflowStep;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * One-stop office x role matrix for the current-step policy across every
 * surface the UI uses (all /api/admin routes):
 *
 *  - superadmin: everything, regardless of office.
 *  - office admin (admin role + office): their own office's papers
 *    (view/list) plus any station parked at their office, role aside.
 *  - regular user: role match + effective office match on the current
 *    station (blank stations follow the transaction's Originating Office).
 *
 * Shapes: a GSO paper parked at CBO (the tx-44 "outgoing" shape), a GSO
 * paper parked at GSO, a CBO paper parked at CBO, and a blank
 * station. Actors without an office keep role-only fallback only on legacy
 * transactions that have no Originating Office.
 */
class OfficeRoleMatrixTest extends TestCase
{
    use RefreshDatabase;

    private Office $gso;
    private Office $cbo;
    private Office $hr;
    private TransactionType $type;
    private WorkflowDefinition $workflow;
    private WorkflowStep $gsoStep;
    private WorkflowStep $cboStep;
    private WorkflowStep $freeStep;
    private WorkflowRoute $route;
    private User $creator;

    /** @var array<string, Role> */
    private array $roles = [];

    /** @var array<string, User> */
    private array $actors = [];

    protected function setUp(): void
    {
        parent::setUp();

        $this->gso = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $this->cbo = Office::create(['code' => 'CBO', 'name' => 'City Budget Office']);
        $this->hr = Office::create(['code' => 'HR', 'name' => 'Human Resources']);

        foreach (['superadmin', 'admin', 'clerk', 'approver', 'end_user'] as $code) {
            $this->roles[$code] = Role::create(['code' => $code, 'name' => ucfirst($code)]);
        }

        $this->type = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $this->workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->type->id,
            'version' => 1,
            'status' => 'published',
        ]);

        $this->gsoStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 1,
            'code' => 'gso_process',
            'name' => 'GSO Processing',
            'is_start' => true,
            'office_id' => $this->gso->id,
        ]);
        $this->cboStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 2,
            'code' => 'cbo_budget',
            'name' => 'CBO Budget',
            'office_id' => $this->cbo->id,
        ]);
        $this->freeStep = WorkflowStep::create([
            'workflow_definition_id' => $this->workflow->id,
            'order_number' => 3,
            'code' => 'free_step',
            'name' => "User's Office Step",
            'office_id' => null,
        ]);

        foreach ([$this->gsoStep, $this->cboStep, $this->freeStep] as $step) {
            StepRole::create(['workflow_step_id' => $step->id, 'role_id' => $this->roles['clerk']->id]);
        }

        $this->route = WorkflowRoute::create([
            'workflow_definition_id' => $this->workflow->id,
            'from_step_id' => $this->gsoStep->id,
            'to_step_id' => $this->cboStep->id,
            'action_code' => 'submit',
            'is_return_route' => false,
        ]);

        $this->creator = User::factory()->create();
    }

    private function actor(string $key): User
    {
        if (isset($this->actors[$key])) {
            return $this->actors[$key];
        }

        [$roleCode, $office] = match ($key) {
            'superadmin' => ['superadmin', null],
            'no_office_clerk' => ['clerk', null],
            'no_office_admin' => ['admin', null],
            'gso_clerk' => ['clerk', $this->gso],
            'cbo_clerk' => ['clerk', $this->cbo],
            'hr_clerk' => ['clerk', $this->hr],
            'cbo_approver' => ['approver', $this->cbo],
            'gso_admin' => ['admin', $this->gso],
            'cbo_admin' => ['admin', $this->cbo],
            'gso_end_user' => ['end_user', $this->gso],
        };

        $user = User::factory()->create(['name' => $key, 'office_id' => $office?->id]);
        $user->roles()->attach($this->roles[$roleCode]->id);

        return $this->actors[$key] = $user;
    }

    /**
     * @param  WorkflowStep|null  $pendingFrom  When given, the paper arrived
     *         from this step and the receipt is still pending (locks Proceed).
     */
    private function makeTx(Office $owner, WorkflowStep $current, ?WorkflowStep $pendingFrom = null): Transaction
    {
        $tx = Transaction::create([
            'transaction_type_id' => $this->type->id,
            'workflow_definition_id' => $this->workflow->id,
            'office_id' => $owner->id,
            'reference_number' => 'TX-' . uniqid(),
            'title' => 'Matrix request',
            'is_done' => false,
            'created_by' => $this->creator->id,
        ]);

        TransactionState::create([
            'transaction_id' => $tx->id,
            'current_step_id' => $current->id,
            'entered_at' => now(),
        ]);

        if ($pendingFrom !== null) {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $pendingFrom->id,
                'to_step_id' => $current->id,
                'action_code' => 'submit',
                'remarks' => 'Forwarded',
                'performed_by' => $this->creator->id,
                'performed_at' => now(),
                'received_at' => null,
                'received_office_id' => $current->office_id,
                'sla_minutes_snapshot' => 0,
            ]);
        } else {
            TransactionStepRun::create([
                'transaction_id' => $tx->id,
                'from_step_id' => $current->id,
                'to_step_id' => $current->id,
                'action_code' => 'create',
                'remarks' => 'Transaction created',
                'performed_by' => $this->creator->id,
                'performed_at' => now(),
                'received_at' => now(),
                'received_by' => $this->creator->id,
                'received_office_id' => $current->office_id,
                'sla_minutes_snapshot' => 0,
            ]);
        }

        return $tx;
    }

    /** @param array<string, int> $expected actor key => HTTP status */
    private function assertMatrix(string $surface, array $expected, callable $request): void
    {
        foreach ($expected as $key => $status) {
            Sanctum::actingAs($this->actor($key));
            $response = $request($status);
            $this->assertSame(
                $status,
                $response->getStatusCode(),
                "[{$surface}] {$key} expected {$status}, got {$response->getStatusCode()}"
            );
        }
    }

    public function test_outgoing_paper_detail_matrix(): void
    {
        $tx = $this->makeTx($this->gso, $this->cboStep);

        $this->assertMatrix('detail GSO@CBO', [
            'superadmin' => 200,
            'gso_admin' => 200,      // own office's paper, wherever it sits
            'cbo_admin' => 200,      // parked at their office
            'gso_clerk' => 200,      // own office's paper
            'cbo_clerk' => 200,      // role + office match at the station
            'cbo_approver' => 403,   // right office, wrong role
            'hr_clerk' => 403,       // role, wrong office
            'no_office_clerk' => 403, // assigned station requires an office
            'no_office_admin' => 403, // admin without office gets no powers
            'gso_end_user' => 200,   // own office's paper is viewable; acting still denied
        ], fn () => $this->getJson("/api/admin/transactions/{$tx->id}"));
    }

    public function test_outgoing_paper_receive_matrix(): void
    {
        $this->assertMatrix('receive GSO@CBO', [
            'superadmin' => 200,
            'cbo_clerk' => 200,      // destination role + office
            'cbo_admin' => 200,      // destination office admin
            'gso_admin' => 403,      // own paper, but OCT-style: not their station
            'gso_clerk' => 403,      // role match, but wrong office
            'cbo_approver' => 403,
            'hr_clerk' => 403,
            'no_office_clerk' => 403, // assigned station requires an office
            'no_office_admin' => 403,
            'gso_end_user' => 403,   // can view own papers, never receive
        ], function () {
            $tx = $this->makeTx($this->gso, $this->cboStep, $this->gsoStep);

            return $this->postJson("/api/admin/transactions/{$tx->id}/receive");
        });
    }

    public function test_home_station_receive_matrix(): void
    {
        $this->assertMatrix('receive GSO@GSO', [
            'superadmin' => 200,
            'gso_clerk' => 200,
            'gso_admin' => 200,
            'cbo_clerk' => 403,
            'cbo_admin' => 403,
            'hr_clerk' => 403,
            'cbo_approver' => 403,
            'no_office_admin' => 403,
        ], function () {
            $tx = $this->makeTx($this->gso, $this->gsoStep, $this->gsoStep);

            return $this->postJson("/api/admin/transactions/{$tx->id}/receive");
        });
    }

    public function test_home_station_proceed_matrix(): void
    {
        $this->assertMatrix('proceed GSO@GSO', [
            'superadmin' => 200,
            'gso_clerk' => 200,
            'gso_admin' => 200,
            'cbo_clerk' => 403,
            'cbo_admin' => 403,
            'hr_clerk' => 403,
            'cbo_approver' => 403,
            'no_office_admin' => 403,
        ], function () {
            $tx = $this->makeTx($this->gso, $this->gsoStep);

            return $this->postJson("/api/admin/transactions/{$tx->id}/execute", ['route_id' => $this->route->id]);
        });
    }

    public function test_list_visibility_matrix(): void
    {
        $gsoAtCbo = $this->makeTx($this->gso, $this->cboStep);
        $cboAtCbo = $this->makeTx($this->cbo, $this->cboStep);
        $gsoAtGso = $this->makeTx($this->gso, $this->gsoStep);
        $gsoAtFree = $this->makeTx($this->gso, $this->freeStep);

        $expectations = [
            'superadmin' => [$gsoAtCbo, $cboAtCbo, $gsoAtGso, $gsoAtFree],
            'gso_admin' => [$gsoAtCbo, $gsoAtGso, $gsoAtFree],
            'cbo_admin' => [$gsoAtCbo, $cboAtCbo],
            'gso_clerk' => [$gsoAtCbo, $gsoAtGso, $gsoAtFree],
            'cbo_clerk' => [$gsoAtCbo, $cboAtCbo],
            'cbo_approver' => [$cboAtCbo],
            'hr_clerk' => [],
            'no_office_clerk' => [],
            'no_office_admin' => [],
            'gso_end_user' => [$gsoAtCbo, $gsoAtGso, $gsoAtFree],
        ];

        foreach ($expectations as $key => $txs) {
            Sanctum::actingAs($this->actor($key));
            $ids = collect($this->getJson('/api/admin/transactions')->assertOk()->json('data'))
                ->pluck('id')
                ->all();
            $this->assertEqualsCanonicalizing(
                collect($txs)->pluck('id')->all(),
                $ids,
                "[list] {$key} saw unexpected rows"
            );
        }
    }

    public function test_blank_station_follows_the_transactions_office(): void
    {
        $tx = $this->makeTx($this->gso, $this->freeStep);

        $this->assertMatrix('detail GSO@free', [
            'superadmin' => 200,
            'gso_admin' => 200,      // own office's paper
            'gso_clerk' => 200,      // role + effective office
            'cbo_clerk' => 403,      // role, wrong effective office
            'hr_clerk' => 403,
            'no_office_clerk' => 403,
            'cbo_admin' => 403,
            'no_office_admin' => 403,
            'cbo_approver' => 403,
        ], fn () => $this->getJson("/api/admin/transactions/{$tx->id}"));

        $this->assertMatrix('receive GSO@free', [
            'superadmin' => 200,
            'gso_clerk' => 200,
            'gso_admin' => 200,      // office admin at the effective office
            'cbo_clerk' => 403,
            'hr_clerk' => 403,
            'no_office_clerk' => 403,
            'cbo_admin' => 403,
            'cbo_approver' => 403,
        ], function () {
            $tx = $this->makeTx($this->gso, $this->freeStep, $this->freeStep);

            return $this->postJson("/api/admin/transactions/{$tx->id}/receive");
        });
    }

    public function test_blank_station_approvals_follow_the_transactions_office(): void
    {
        $this->makeTx($this->gso, $this->freeStep);

        $expectations = [
            'superadmin' => 1,
            'gso_clerk' => 1,
            'gso_admin' => 1,
            'cbo_clerk' => 0,
            'cbo_admin' => 0,
            'hr_clerk' => 0,
            'cbo_approver' => 0,
            'no_office_clerk' => 0,
        ];

        foreach ($expectations as $key => $rows) {
            Sanctum::actingAs($this->actor($key));

            $inbox = $this->getJson('/api/approvals')->assertOk();
            $this->assertCount($rows, $inbox->json('data'), "[approvals] {$key} inbox rows");

            $badge = $this->getJson('/api/approvals/count')->assertOk();
            $this->assertSame($rows, $badge->json('transactions'), "[approvals badge] {$key}");
        }
    }

    public function test_approvals_inbox_and_badge_matrix(): void
    {
        $this->makeTx($this->gso, $this->cboStep);

        $expectations = [
            'superadmin' => 200,
            'cbo_clerk' => 200,
            'cbo_admin' => 200,
            'gso_admin' => 200,
            'gso_clerk' => 200,
            'hr_clerk' => 200,
            'cbo_approver' => 200,
        ];

        foreach ($expectations as $key => $status) {
            Sanctum::actingAs($this->actor($key));

            $inbox = $this->getJson('/api/approvals');
            $this->assertSame($status, $inbox->getStatusCode(), "[approvals] {$key}");
            $badge = $this->getJson('/api/approvals/count');
            $this->assertSame($status, $badge->getStatusCode(), "[approvals badge] {$key}");

            $sees = in_array($key, ['superadmin', 'cbo_clerk', 'cbo_admin'], true);
            $this->assertSame(
                $sees ? 1 : 0,
                count($inbox->json('data')),
                "[approvals] {$key} inbox rows"
            );
            $this->assertSame(
                $sees ? 1 : 0,
                $badge->json('transactions'),
                "[approvals badge] {$key} transactions"
            );
        }

        // End users have no approvals section at all.
        Sanctum::actingAs($this->actor('gso_end_user'));
        $this->getJson('/api/approvals')->assertForbidden();
        $this->getJson('/api/approvals/count')->assertForbidden();
    }

    public function test_my_transactions_endpoint_stays_station_scoped(): void
    {
        // The legacy /api/transactions routes (ApprovalProceedDialog) never
        // widened with the admin list: only users who can work the station.
        $tx = $this->makeTx($this->gso, $this->cboStep);

        $this->assertMatrix('user detail GSO@CBO', [
            'superadmin' => 200,
            'cbo_clerk' => 200,
            'cbo_admin' => 200,
            'gso_clerk' => 403,
            'gso_admin' => 403,
            'hr_clerk' => 403,
            'gso_end_user' => 403,
        ], fn () => $this->getJson("/api/transactions/{$tx->id}"));
    }
}
