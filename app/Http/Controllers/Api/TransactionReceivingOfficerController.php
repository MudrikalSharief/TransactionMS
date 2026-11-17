<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Transaction;
use App\Models\WorkflowStep;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;

class TransactionReceivingOfficerController extends Controller
{
    public function show(Request $request, Transaction $transaction, WorkflowStep $step, RoutingEngine $routing)
    {
        $routing->assertUserCanView($transaction, $request->user());

        return $this->details($request, $transaction, $step);
    }

    // This route uses the same EnsureTransactionOffice middleware as admin detail.
    public function showAdmin(Request $request, Transaction $transaction, WorkflowStep $step)
    {
        return $this->details($request, $transaction, $step);
    }

    private function details(Request $request, Transaction $transaction, WorkflowStep $step)
    {
        abort_unless((int) $step->workflow_definition_id === (int) $transaction->workflow_definition_id, 404);

        $user = $request->user();
        $showHistory = $user->hasRole('superadmin') || $user->hasRole('admin');
        $query = $transaction->runs()
            ->where('to_step_id', $step->id)
            ->whereNotNull('received_at')
            ->whereNotNull('received_by')
            ->with(['receiver:id,name,Contact_number', 'receivedOffice:id,code,name'])
            ->orderByDesc('received_at')
            ->orderByDesc('id');

        if (!$showHistory) $query->limit(1);
        $receipts = $query->get();
        abort_if($receipts->isEmpty(), 404, 'No receiving officer is available for this step yet.');

        return response()->json(['data' => [
            'transaction' => $transaction->only(['id', 'reference_number']),
            'step' => $step->only(['id', 'name', 'order_number']),
            'show_history' => $showHistory,
            'receipts' => $receipts->map(fn ($run) => [
                'id' => $run->id,
                'received_at' => $run->received_at->toISOString(),
                'office' => Office::mini($run->receivedOffice),
                'officer' => [
                    'name' => $run->receiver?->name ?? 'Officer no longer available',
                    'contact_number' => $run->receiver?->Contact_number,
                ],
            ]),
        ]]);
    }
}
