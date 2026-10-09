<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Transactions\UploadAttachmentRequest;
use App\Http\Resources\TransactionAttachmentResource;
use App\Models\RequirementDefinition;
use App\Models\Transaction;
use App\Models\TransactionAttachment;
use App\Models\WorkflowStep;
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
        // Current-step workers only (existing gate). Files always belong
        // to the current step.
        $routing->assertUserCanExecute($transaction, $request->user());

        $transaction->loadMissing(['state.currentStep']);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        $validated = $request->validated();
        $requirementId = $validated['requirement_definition_id'] ?? null;
        if ($requirementId) $requirementId = (int) $requirementId;

        $stepId = $currentStepId;
        $assignStep = $transaction->state->currentStep;

        if ($requirementId) {
            if ((int) RequirementDefinition::whereKey($requirementId)->value('workflow_definition_id')
                !== (int) $transaction->workflow_definition_id) {
                abort(422, 'Requirement does not belong to this transaction workflow version.');
            }

            $isAssigned = $assignStep
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
        $path = $file->store('attachments/'.now()->format('Y/m')."/{$transaction->id}/{$stepId}", 'local');

        $attachment = TransactionAttachment::create([
            'transaction_id' => $transaction->id,
            'workflow_step_id' => $stepId,
            'requirement_definition_id' => $requirementId,
            'original_name' => $file->getClientOriginalName(),
            'label' => ($label = trim((string) ($validated['label'] ?? ''))) !== '' ? mb_substr($label, 0, 120) : null,
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

    public function view(Request $request, Transaction $transaction, TransactionAttachment $attachment, RoutingEngine $routing)
    {
        $this->assertCanView($transaction, $request, $routing);

        if ((int) $attachment->transaction_id !== (int) $transaction->id) {
            abort(404);
        }

        $disk = $attachment->disk ?: 'local';
        if (!Storage::disk($disk)->exists($attachment->stored_path)) {
            abort(404, 'File missing from storage.');
        }

        $mime = $attachment->mime ?: Storage::disk($disk)->mimeType($attachment->stored_path) ?: 'application/octet-stream';

        return Storage::disk($disk)->response(
            $attachment->stored_path,
            $attachment->original_name,
            [
                'Content-Type' => $mime,
                'Content-Disposition' => 'inline; filename="' . addslashes($attachment->original_name) . '"',
            ]
        );
    }

    /**
     * Link a file from the immediately previous step into the current step
     * (no re-upload). Creates a new row sharing the same stored_path,
     * tagged to the current step, with source_attachment_id pointing at
     * the owner row. With requirement_definition_id it links into that
     * requirement; without it, it links as a proceed-level
     * (Additional files) attachment carrying the source label.
     */
    public function reuse(Request $request, Transaction $transaction, RoutingEngine $routing)
    {
        $routing->assertUserCanExecute($transaction, $request->user());

        $data = $request->validate([
            'source_attachment_id' => ['required', 'integer', 'exists:transaction_attachments,id'],
            'requirement_definition_id' => ['nullable', 'integer', 'exists:requirement_definitions,id'],
            'label' => ['nullable', 'string', 'max:120'],
        ]);

        $transaction->loadMissing(['state.currentStep']);

        $currentStepId = (int) $transaction->state?->current_step_id;
        if (!$currentStepId) abort(422, 'Transaction has no current step.');

        $requirementId = $data['requirement_definition_id'] ?? null;
        if ($requirementId !== null) $requirementId = (int) $requirementId;

        if ($requirementId) {
            if ((int) RequirementDefinition::whereKey($requirementId)->value('workflow_definition_id')
                !== (int) $transaction->workflow_definition_id) {
                abort(422, 'Requirement does not belong to this transaction workflow version.');
            }

            $currentStep = $transaction->state->currentStep;
            $isAssigned = $currentStep
                ->requirementDefinitions()
                ->where('requirement_definitions.id', $requirementId)
                ->exists();
            if (!$isAssigned) {
                abort(422, 'Requirement is not assigned to the current step.');
            }
        } else {
            $currentStep = $transaction->state->currentStep;
        }

        $source = TransactionAttachment::whereKey((int) $data['source_attachment_id'])->first();
        if (!$source || (int) $source->transaction_id !== (int) $transaction->id) {
            abort(404, 'Source file not found in this transaction.');
        }
        if ($source->source_attachment_id) {
            abort(422, 'Only original (owner) files can be reused — links cannot be re-linked.');
        }

        $prevStepId = $this->previousStepId($transaction, (int) $currentStep->order_number);
        if (!$prevStepId) {
            abort(422, 'There is no previous step to reuse files from.');
        }
        if ((int) $source->workflow_step_id !== (int) $prevStepId) {
            abort(422, 'Only files from the immediately previous step can be reused.');
        }

        $dupQuery = TransactionAttachment::query()
            ->where('transaction_id', $transaction->id)
            ->where('workflow_step_id', $currentStepId)
            ->where('source_attachment_id', $source->id);
        if ($requirementId) {
            $dupQuery->where('requirement_definition_id', $requirementId);
        } else {
            $dupQuery->whereNull('requirement_definition_id');
        }
        if ($dupQuery->exists()) {
            abort(422, $requirementId
                ? 'This file is already linked to the requirement.'
                : 'This file is already linked to the Additional files.');
        }

        $disk = $source->disk ?: 'local';
        if (!Storage::disk($disk)->exists($source->stored_path)) {
            abort(404, 'Source file missing from storage.');
        }

        $linkLabel = $requirementId
            ? $source->label
            : ((($l = trim((string) ($data['label'] ?? ''))) !== '') ? mb_substr($l, 0, 120) : $source->label);

        $link = TransactionAttachment::create([
            'transaction_id' => $transaction->id,
            'workflow_step_id' => $currentStepId,
            'requirement_definition_id' => $requirementId,
            'source_attachment_id' => $source->id,
            'original_name' => $source->original_name,
            'label' => $linkLabel,
            'stored_path' => $source->stored_path,
            'disk' => $source->disk,
            'mime' => $source->mime,
            'size_bytes' => $source->size_bytes,
            'uploaded_by' => $request->user()->id,
        ]);

        $link->load(['step', 'requirement', 'uploader', 'source']);

        return (new TransactionAttachmentResource($link))->response()->setStatusCode(201);
    }

    /**
     * Remove a linked reference from the current step (unlink only).
     * The owner file and physical storage are left intact. Allowed for
     * current-step workers; owner deletes stay superadmin-only.
     * Travelled links stay detachable: only the reference row is deleted,
     * the owner file keeps its own history stamps.
     */
    public function unlink(Request $request, Transaction $transaction, int $attachment, RoutingEngine $routing)
    {
        $routing->assertUserCanExecute($transaction, $request->user());

        $model = TransactionAttachment::whereKey($attachment)->first();
        if (!$model) {
            abort(404, 'File not found or already deleted.');
        }
        if ((int) $model->transaction_id !== (int) $transaction->id) {
            abort(404);
        }
        if (!$model->source_attachment_id) {
            abort(403, 'This is an original file — only superadmin can delete it.');
        }

        $transaction->loadMissing(['state.currentStep']);
        $currentStepId = (int) $transaction->state?->current_step_id;
        if ($currentStepId && (int) $model->workflow_step_id !== $currentStepId) {
            abort(422, 'Only files linked on the current step can be removed.');
        }

        $model->delete();

        return response()->json(['message' => 'Reference removed. The original file is kept.']);
    }

    public function destroy(Request $request, Transaction $transaction, int $attachment)
    {
        $model = TransactionAttachment::whereKey($attachment)->first();
        if (!$model) {
            abort(404, 'File not found or already deleted.');
        }

        $user = $request->user();
        $user->loadMissing('roles');

        if (!($user->roles?->contains(fn ($r) => $r->code === 'superadmin'))) {
            abort(403, 'Only superadmin can delete attachments.');
        }

        if ((int) $model->transaction_id !== (int) $transaction->id) {
            abort(404);
        }

        if ($model->source_attachment_id) {
            abort(403, 'This is a linked reference — remove it from the step instead of deleting.');
        }

        $attachment = $model;

        // Dependents cascade at the DB level (FK), but collect their ids
        // first so callers can prune local lists if needed.
        $dependentIds = TransactionAttachment::where('source_attachment_id', $attachment->id)->pluck('id')->all();
        $path = $attachment->stored_path;
        $disk = $attachment->disk ?: 'local';

        $attachment->delete();

        // Delete the physical file only when no rows reference it anymore
        // (owner deleted + all its links gone).
        $stillReferenced = TransactionAttachment::where('stored_path', $path)->exists();
        if (!$stillReferenced) {
            Storage::disk($disk)->delete($path);
        }

        return response()->json(['message' => 'Deleted', 'cascaded_link_ids' => $dependentIds]);
    }

    private function previousStepId(Transaction $transaction, int $currentOrder): ?int
    {
        if ($currentOrder <= 1) return null;
        return WorkflowStep::query()
            ->where('workflow_definition_id', $transaction->workflow_definition_id)
            ->where('order_number', $currentOrder - 1)
            ->value('id');
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
