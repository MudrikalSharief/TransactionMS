<?php

namespace App\Services;

use App\Models\ChecklistOverride;
use App\Models\WorkflowStep;
use Illuminate\Support\Collection;

class ChecklistService
{
    /**
     * Checklist rows for a step. Always mirrors this step's requirements
     * (linked by requirement_definition_id) plus any custom items the
     * admin added. New requirements show up without a manual Reset.
     */
    public function ensureItems(WorkflowStep $step): Collection
    {
        $this->syncFromRequirements($step);

        return $this->itemsFor($step);
    }

    public function itemsFor(WorkflowStep $step): Collection
    {
        return $step->checklistOverrides()
            ->orderBy('display_order')
            ->orderBy('id')
            ->get();
    }

    /**
     * Upsert checklist rows from the step's requirements:
     * - missing requirement -> insert
     * - requirement removed from step -> delete linked checklist row
     * - linked row fields follow the requirement (name/code/remarks/required/order)
     * - custom rows (no requirement_definition_id) are left alone
     */
    public function syncFromRequirements(WorkflowStep $step): void
    {
        $reqs = $step->requirementDefinitions()->get();
        $items = $step->checklistOverrides()->get();

        $byReqId = $items
            ->filter(fn ($i) => $i->requirement_definition_id !== null)
            ->keyBy(fn ($i) => (int) $i->requirement_definition_id);

        $keepIds = [];
        $now = now();

        foreach ($reqs as $i => $r) {
            $existing = $byReqId->get((int) $r->id);
            $payload = [
                'name' => $r->name,
                'code' => $r->code,
                'description' => $r->description,
                'is_required' => (bool) ($r->pivot?->is_required ?? true),
                'display_order' => (int) ($r->pivot?->display_order ?? $i),
                'updated_at' => $now,
            ];

            if ($existing) {
                $existing->fill($payload);
                if ($existing->isDirty()) {
                    $existing->save();
                }
                $keepIds[] = $existing->id;
            } else {
                $created = ChecklistOverride::create(array_merge($payload, [
                    'workflow_step_id' => $step->id,
                    'requirement_definition_id' => $r->id,
                    'created_at' => $now,
                ]));
                $keepIds[] = $created->id;
            }
        }

        $items
            ->filter(fn ($i) => $i->requirement_definition_id !== null && !in_array($i->id, $keepIds, true))
            ->each(fn ($i) => $i->delete());
    }

    public function seedFromRequirements(WorkflowStep $step): void
    {
        $this->syncFromRequirements($step);
    }
}
