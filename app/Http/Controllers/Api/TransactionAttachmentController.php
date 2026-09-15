<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\UploadAttachmentRequest;
use App\Http\Resources\TransactionAttachmentResource;
use App\Models\RequirementDefinition;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Services\RoutingEngine;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TransactionAttachmentController extends Controller
{
    public function index(Request $request, Transaction $transaction, RoutingEngine $routing)
    {
        $this->assertCanView($transaction, $request, $routing);

        $items = TransactionAttachment::query()
            ->where('transaction_id', $transaction->id)
            ->with(['step', 'requirement', 'uploader'])
            ->orderByDesc('created_at')
            ->get();

        return TransactionAttachmentResource::collection($items);
    }

    public function store(
        UploadAttachmentRequest $request,
        Transaction $transaction,
        RoutingEngine $routing
    ) {
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing(['state.currentStep']);

        $stepId = (int) $transaction->state?->current_step_id;
        if (!$stepId) abort(422, 'Transaction has no current step.');

        $requirementId = $request->validated()['requirement_definition_id'] ?? null;
        if ($requirementId) {
            $requirementId = (int) $requirementId;
            if ((int) RequirementDefinition::whereKey($requirementId)->value('workflow_definition_id')
                !== (int) $transaction->workflow_definition_id) {
                abort(422, 'Requirement does not belong to this transaction workflow version.');
            }

            $isAssigned = $transaction->state->currentStep
                ->requirementDefinitions()
                ->where('requirement_definitions.id', $requirementId)
                ->exists();

            if (!$isAssigned) {
                abort(422, 'Requirement is not assigned to the current step.');
            }
        }

        $file = $request->file('file');
        $ext = strtolower($file->getClientOriginalExtension());
        if (in_array($ext, ['php', 'phtml', 'phar', 'exe', 'bat', 'cmd', 'sh', 'js'], true)) {
            abort(422, 'File type not allowed.');
        }
        $path = $file->store("attachments/{$transaction->id}/{$stepId}", 'local');

        $attachment = TransactionAttachment::create([
            'transaction_id' => $transaction->id,
            'workflow_step_id' => $stepId,
            'requirement_definition_id' => $requirementId,
            'original_name' => $file->getClientOriginalName(),
            'stored_path' => $path,
            'disk' => 'local',
            'mime' => $file->getMimeType(),
            'size_bytes' => $file->getSize(),
            'uploaded_by' => $request->user()->id,
        ]);

        $attachment->load(['step', 'requirement', 'uploader']);

        return (new TransactionAttachmentResource($attachment))->response()->setStatusCode(201);
    }

    public function download(Request $request, Transaction $transaction, TransactionAttachment $attachment, RoutingEngine $routing)
    {
        $this->assertCanView($transaction, $request, $routing);

        if ((int) $attachment->transaction_id !== (int) $transaction->id) {
            abort(404);
        }

        $disk = $attachment->disk ?: 'local';
        if (!Storage::disk($disk)->exists($attachment->stored_path)) {
            abort(404, 'File missing from storage.');
        }

        return Storage::disk($disk)->download(
            $attachment->stored_path,
            $attachment->original_name
        );
    }

    public function destroy(Request $request, Transaction $transaction, TransactionAttachment $attachment)
    {
        $user = $request->user();
        $user->loadMissing('roles');

        if (!($user->roles?->contains(fn ($r) => $r->code === 'superadmin'))) {
            abort(403, 'Only superadmin can delete attachments.');
        }

        if ((int) $attachment->transaction_id !== (int) $transaction->id) {
            abort(404);
        }

        Storage::disk($attachment->disk ?: 'local')->delete($attachment->stored_path);
        $attachment->delete();

        return response()->json(['message' => 'Deleted']);
    }

    private function assertCanView(Transaction $transaction, Request $request, RoutingEngine $routing): void
    {
        $user = $request->user();
        $user->loadMissing('roles');

        if ($user->roles?->contains(fn ($r) => $r->code === 'superadmin')) return;

        // All viewers: anyone who can view the transaction detail may list/download.
        // Creators can always view their own transactions; step workers via role gate.
        if ((int) $transaction->created_by === (int) $user->id) return;

        try {
            $routing->assertUserCanExecute($transaction, $user);
            return;
        } catch (\Throwable $e) {
            // Fall through to 403 below so office-mates without current-step
            // role don't leak files, while keeping superadmin/creator access.
        }

        abort(403, 'You are not allowed to view attachments for this transaction.');
    }
}
