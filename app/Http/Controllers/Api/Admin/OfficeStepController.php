<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\OfficeStep;
use App\Services\AuditService;
use Illuminate\Http\Request;

class OfficeStepController extends Controller
{
    private function shape(OfficeStep $s): array
    {
        return [
            'id' => $s->id,
            'office_id' => $s->office_id,
            'parent_id' => $s->parent_id,
            'order_number' => (int) $s->order_number,
            'code' => $s->code,
            'name' => $s->name,
            'description' => $s->description,
            'is_active' => (bool) $s->is_active,
        ];
    }

    public function index(Office $office)
    {
        return $office->steps()->orderBy('order_number')->get()->map(fn (OfficeStep $s) => $this->shape($s))->values();
    }

    public function store(Request $request, Office $office, AuditService $audit)
    {
        $data = $request->validate([
            'parent_id' => ['nullable', 'integer', 'exists:office_steps,id'],
            'order_number' => ['sometimes', 'integer', 'min:1', 'max:9999'],
            'name' => ['required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:2000'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $this->assertValidParent($office, $data['parent_id'] ?? null, null);

        $data['order_number'] = $data['order_number'] ?? ((int) $office->steps()->withTrashed()->max('order_number') + 1 ?: 1);
        $data['code'] = $this->nextCode($office, (int) $data['order_number']);

        $step = $office->steps()->create($data);

        $audit->log($request, 'office_steps.create', $step, ['payload' => $data]);

        return response()->json($this->shape($step), 201);
    }

    public function update(Request $request, Office $office, OfficeStep $officeStep, AuditService $audit)
    {
        $this->assertBelongs($office, $officeStep);

        $data = $request->validate([
            'parent_id' => ['nullable', 'integer', 'exists:office_steps,id'],
            'order_number' => ['sometimes', 'integer', 'min:1', 'max:9999'],
            'name' => ['required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:2000'],
            'is_active' => ['sometimes', 'boolean'],
        ]);

        $before = $officeStep->only(['parent_id', 'order_number', 'code', 'name', 'description', 'is_active']);

        if (array_key_exists('parent_id', $data)) {
            $this->assertValidParent($office, $data['parent_id'], $officeStep->id);
        }

        // Keep the code in sync with the hierarchy slot: {office}_{order}.
        if (isset($data['order_number']) && (int) $data['order_number'] !== (int) $officeStep->order_number) {
            $data['code'] = $this->nextCode($office, (int) $data['order_number'], $officeStep->id);
        }

        $officeStep->update($data);

        $audit->log($request, 'office_steps.update', $officeStep, [
            'before' => $before,
            'after' => $officeStep->only(['parent_id', 'order_number', 'code', 'name', 'description', 'is_active']),
        ]);

        return response()->json($this->shape($officeStep));
    }

    public function destroy(Request $request, Office $office, OfficeStep $officeStep, AuditService $audit)
    {
        $this->assertBelongs($office, $officeStep);

        $officeStep->delete();

        $audit->log($request, 'office_steps.delete', $officeStep, [
            'note' => 'Soft deleted office step',
        ]);

        return response()->json(['message' => 'Deleted.']);
    }

    private function assertBelongs(Office $office, OfficeStep $step): void
    {
        if ((int) $step->office_id !== (int) $office->id) {
            abort(404);
        }
    }

    /**
     * Parent must live in the same office and must not create a cycle
     * (a step can never sit under itself or one of its descendants).
     */
    private function assertValidParent(Office $office, ?int $parentId, ?int $selfId): void
    {
        if ($parentId === null) return;

        $seen = $selfId ? [$selfId] : [];
        $cursor = $parentId;

        while ($cursor !== null) {
            if (in_array($cursor, $seen, true)) {
                abort(422, 'Circular hierarchy detected: a step cannot sit under itself or its own sub-step.');
            }
            $ancestor = OfficeStep::withTrashed()->find($cursor);
            if (!$ancestor || (int) $ancestor->office_id !== (int) $office->id) {
                abort(422, 'Parent step must belong to the same office.');
            }
            $seen[] = $cursor;
            $cursor = $ancestor->parent_id;
        }
    }

    /**
     * Auto code in the form {office_code}_{order}, e.g. csd_1.
     * Suffixes (-2, -3…) on collision, trashed rows included
     * since the unique index covers them too.
     */
    private function nextCode(Office $office, int $order, ?int $ignoreId = null): string
    {
        $base = strtolower(preg_replace('/[^a-z0-9]+/', '_', $office->code));
        $base = trim($base, '_') ?: 'office';

        $candidate = "{$base}_{$order}";
        $suffix = 2;
        while (
            OfficeStep::withTrashed()
                ->where('office_id', $office->id)
                ->where('code', $candidate)
                ->when($ignoreId, fn ($q) => $q->where('id', '!=', $ignoreId))
                ->exists()
        ) {
            $candidate = "{$base}_{$order}-{$suffix}";
            $suffix++;
        }

        return $candidate;
    }
}
