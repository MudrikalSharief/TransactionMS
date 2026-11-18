<?php

namespace Tests\Feature;

use App\Models\{Office, Role, StepRole, Transaction, TransactionState, TransactionStepRun, TransactionType, User, WorkflowDefinition, WorkflowStep};
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TransactionReceivingOfficerTest extends TestCase
{
    use RefreshDatabase;

    private Office $office;
    private WorkflowStep $step;
    private Transaction $tx;

    protected function setUp(): void
    {
        parent::setUp();
        $this->office = Office::create(['code' => 'GSO', 'name' => 'General Services Office']);
        $type = TransactionType::create(['code' => 'pr', 'name' => 'Purchase Request']);
        $workflow = WorkflowDefinition::create(['transaction_type_id' => $type->id, 'version' => 1, 'status' => 'published']);
        $this->step = WorkflowStep::create([
            'workflow_definition_id' => $workflow->id, 'order_number' => 1,
            'code' => 'gso', 'name' => 'GSO Processing', 'office_id' => $this->office->id, 'is_start' => true,
        ]);
        $clerk = Role::firstOrCreate(['code' => 'clerk'], ['name' => 'Clerk']);
        StepRole::create(['workflow_step_id' => $this->step->id, 'role_id' => $clerk->id]);
        $this->tx = Transaction::create([
            'transaction_type_id' => $type->id, 'workflow_definition_id' => $workflow->id,
            'office_id' => $this->office->id, 'reference_number' => 'OFFICER-1',
            'created_by' => User::factory()->create()->id, 'is_done' => false,
        ]);
        TransactionState::create(['transaction_id' => $this->tx->id, 'current_step_id' => $this->step->id, 'entered_at' => now()]);
    }

    private function actor(string $role): User
    {
        $user = User::factory()->create(['office_id' => $this->office->id]);
        $user->roles()->attach(Role::firstOrCreate(['code' => $role], ['name' => $role]));
        return $user;
    }

    private function receipt(User $receiver, ?string $at = '2026-11-17 01:00:00', array $overrides = []): TransactionStepRun
    {
        return TransactionStepRun::create(array_merge([
            'transaction_id' => $this->tx->id, 'from_step_id' => $this->step->id,
            'to_step_id' => $this->step->id, 'action_code' => 'submit',
            'performed_by' => $receiver->id, 'performed_at' => '2026-11-16 01:00:00',
            'received_by' => $receiver->id, 'received_at' => $at, 'received_office_id' => $this->office->id,
        ], $overrides));
    }

    private function url(string $prefix = ''): string
    {
        return "/api/{$prefix}transactions/{$this->tx->id}/steps/{$this->step->id}/receivers";
    }

    public function test_staff_sees_only_latest_completed_destination_receipt_with_minimal_personal_details(): void
    {
        $old = User::factory()->create(['name' => 'Old Receiver', 'Contact_number' => '09170000001']);
        $latest = User::factory()->create(['name' => 'Latest Receiver', 'Contact_number' => '09170000002']);
        $this->receipt($old);
        $this->receipt($latest); // Same timestamp: higher ID wins.
        $this->receipt($old, null); // New pending visit must not replace completed receipt.
        Sanctum::actingAs($this->actor('clerk'));
        foreach (['', 'admin/'] as $prefix) {
            $this->getJson($this->url($prefix))->assertOk()->assertJsonCount(1, 'data.receipts')
                ->assertJsonPath('data.receipts.0.officer', ['name' => 'Latest Receiver', 'contact_number' => '09170000002'])
                ->assertJsonPath('data.receipts.0.office.name', 'General Services Office')
                ->assertJsonMissing(['name' => 'Old Receiver'])->assertJsonMissingPath('data.receipts.0.officer.email');
        }
    }

    public function test_latest_means_receipt_time_rather_than_insertion_order(): void
    {
        $latest = User::factory()->create(['name' => 'Latest By Time']);
        $this->receipt($latest, '2026-11-17 03:00:00');
        $this->receipt(User::factory()->create(), '2026-11-17 01:00:00');
        Sanctum::actingAs($this->actor('clerk'));
        $this->getJson($this->url())->assertOk()->assertJsonCount(1, 'data.receipts')
            ->assertJsonPath('data.receipts.0.officer.name', 'Latest By Time');
    }

    public function test_step_from_another_workflow_is_rejected_even_with_a_malformed_run(): void
    {
        $workflow = WorkflowDefinition::create([
            'transaction_type_id' => $this->tx->transaction_type_id, 'version' => 2, 'status' => 'published',
        ]);
        $foreignStep = $this->step->replicate();
        $foreignStep->workflow_definition_id = $workflow->id;
        $foreignStep->save();
        $this->receipt(User::factory()->create(), '2026-11-17 01:00:00', ['to_step_id' => $foreignStep->id]);
        Sanctum::actingAs($this->actor('superadmin'));
        $this->getJson("/api/transactions/{$this->tx->id}/steps/{$foreignStep->id}/receivers")->assertNotFound();
    }

    public function test_admin_and_superadmin_see_every_receipt_including_repeated_receivers(): void
    {
        $receiver = User::factory()->create();
        $this->receipt($receiver);
        $this->receipt($receiver, '2026-11-17 02:00:00');
        foreach (['admin', 'superadmin'] as $role) {
            Sanctum::actingAs($this->actor($role));
            foreach (['', 'admin/'] as $prefix) {
                $this->getJson($this->url($prefix))->assertOk()->assertJsonCount(2, 'data.receipts')
                    ->assertJsonPath('data.show_history', true);
            }
        }
    }

    public function test_viewer_is_forbidden_from_both_endpoints(): void
    {
        $this->receipt(User::factory()->create());
        Sanctum::actingAs($this->actor('viewer'));
        foreach (['', 'admin/'] as $prefix) $this->getJson($this->url($prefix))->assertForbidden();
    }

    public function test_pending_receipt_and_departure_from_selected_step_do_not_unlock_details(): void
    {
        $receiver = User::factory()->create();
        $this->receipt($receiver, null);
        $other = $this->step->replicate();
        $other->code = 'other';
        $other->order_number = 2;
        $other->save();
        $this->receipt($receiver, '2026-11-17 02:00:00', ['to_step_id' => $other->id]);
        Sanctum::actingAs($this->actor('superadmin'));
        $this->getJson($this->url())->assertNotFound();
    }

    public function test_foreign_transaction_receipts_do_not_unlock_selected_step(): void
    {
        $other = $this->tx->replicate();
        $other->reference_number = 'OFFICER-2';
        $other->save();
        $this->receipt(User::factory()->create(), '2026-11-17 01:00:00', ['transaction_id' => $other->id]);
        Sanctum::actingAs($this->actor('superadmin'));
        $this->getJson($this->url())->assertNotFound();
    }

    public function test_missing_contact_is_returned_as_null_and_office_snapshot_is_preserved(): void
    {
        $receiver = User::factory()->create(['Contact_number' => null]);
        $this->receipt($receiver);
        $otherOffice = Office::create(['code' => 'NEW', 'name' => 'New Office']);
        $receiver->update(['office_id' => $otherOffice->id]);
        $this->step->update(['office_id' => $otherOffice->id]);
        Sanctum::actingAs($this->actor('superadmin'));
        $this->getJson($this->url())->assertOk()->assertJsonPath('data.receipts.0.officer.contact_number', null)
            ->assertJsonPath('data.receipts.0.office.name', 'General Services Office');
    }

    public function test_unrelated_office_cannot_read_receivers_and_guest_requires_login(): void
    {
        $this->receipt(User::factory()->create());
        $this->getJson($this->url())->assertUnauthorized();
        $otherOffice = Office::create(['code' => 'OTHER', 'name' => 'Other Office']);
        foreach (['clerk', 'admin'] as $role) {
            $actor = $this->actor($role);
            $actor->update(['office_id' => $otherOffice->id]);
            Sanctum::actingAs($actor);
            foreach (['', 'admin/'] as $prefix) $this->getJson($this->url($prefix))->assertForbidden();
        }
    }
}
