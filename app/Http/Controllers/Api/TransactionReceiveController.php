<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\TransactionResource;
use App\Models\Transaction;
use App\Services\RoutingEngine;
use App\Services\TransactionEngine;
use Illuminate\Http\Request;

class TransactionReceiveController extends Controller
{
    public function receive(Transaction $transaction, Request $request, RoutingEngine $routing, TransactionEngine $engine)
    {
        if ((bool) ($transaction->is_done ?? false)) {
            abort(422, 'Transaction is finalized and view-only.');
        }

        // Only users with the destination (current step) office+role may receive.
        $routing->assertUserCanExecute($transaction, $request->user());

        $tx = $engine->receive($transaction, $request->user()->id);
        $actions = $routing->availableActions($tx, $request->user());

        return (new TransactionResource($tx))->additional([
            'meta' => [
                'available_actions' => $actions,
                'visited_step_ids' => $routing->visitedStepIds($tx),
            ],
        ]);
    }
}
