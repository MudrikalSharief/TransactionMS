<?php

namespace App\Services;

use App\Models\ChecklistOverride;
use App\Models\WorkflowStep;
use Illuminate\Support\Collection;

class ChecklistService
{
    /**
     * Checklist rows for a step. Mirrors the requirements of the step's
     * forward-route predecessors (union when branches merge), plus any
     * custom items the admin added. New requirements show up without a
     * manual Reset. Start steps have no predecessor, so they hold only
     * custom items.
     *
     * Concretely: the requirements of step N become the checklist to tick
     * when leaving step N+1, which is why step 1 → step 2 never has a
     * checklist.
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
     * Predecessors whose requirements feed this step's checklist: sources
     * of incoming forward routes. Return routes never define a checklist —
     * a bounced-back station re-verifies nothing from the station that
     * returned it.
     */
    public function predecessorsFor(WorkflowStep $step): Collection
    {
        $fromIds = $step->incomingRoutes()
            ->where('is_return_route', false)
            ->where('from_step_id', '!=', (int) $step->id)
            ->pluck('from_step_id')
            ->map(fn ($id) => (int) $id)
            ->unique()
            ->values();

        if ($fromIds->isEmpty()) {
            return collect();
        }

        return WorkflowStep::whereIn('id', $fromIds)
            ->orderBy('order_number')
            ->orderBy('id')
            ->get();
    }

    /**
     * Upsert checklist rows from the predecessors' requirements:
     * - missing requirement -> insert
     * - requirement gone from every predecessor -> delete linked checklist row
     * - linked row fields follow the requirement (name/code/description)
     * - same definition on several predecessors: required wins, lowest
     *   predecessor/order first
     * - custom rows (no requirement_definition_id) are left alone
     */
    public function syncFromRequirements(WorkflowStep $step): void
    {
        $union = [];
        foreach ($this->predecessorsFor($step) as $pred) {
            $predOrder = (int) ($pred->order_number ?? 0);
            foreach ($pred->requirementDefinitions()->get() as $r) {
                $key = (int) $r->id;
                $required = (bool) ($r->pivot?->is_required ?? true);
                $display = (int) ($r->pivot?->display_order ?? 0);
                if (!isset($union[$key])) {
                    $union[$key] = [
                        'def' => $r,
                        'is_required' => $required,
                        'pred_order' => $predOrder,
                        'display_order' => $display,
                    ];
                } else {
                    $union[$key]['is_required'] = $union[$key]['is_required'] || $required;
                    $union[$key]['pred_order'] = min($union[$key]['pred_order'], $predOrder);
                    $union[$key]['display_order'] = min($union[$key]['display_order'], $display);
                }
            }
        }

        uasort($union, fn ($a, $b) =>
            [$a['pred_order'], $a['display_order'], $a['def']->id]
            <=> [$b['pred_order'], $b['display_order'], $b['def']->id]
        );

        $items = $step->checklistOverrides()->get();

        $byReqId = $items
            ->filter(fn ($i) => $i->requirement_definition_id !== null)
            ->keyBy(fn ($i) => (int) $i->requirement_definition_id);

        $keepIds = [];
        $now = now();

        foreach (array_values($union) as $entry) {
            $r = $entry['def'];
            $existing = $byReqId->get((int) $r->id);
            $payload = [
                'name' => $r->name,
                'code' => $r->code,
                'description' => $r->description,
                'is_required' => $entry['is_required'],
                'display_order' => $entry['display_order'],
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

    /**
     * Re-derive the checklists fed by this step — i.e. every step reached
     * from it by a forward route. Call after this step's requirements
     * change, since those edits land on the successors' checklists.
     */
    public function syncSuccessorsOf(WorkflowStep $step): void
    {
        $targets = $step->outgoingRoutes()
            ->where('is_return_route', false)
            ->where('to_step_id', '!=', (int) $step->id)
            ->pluck('to_step_id')
            ->map(fn ($id) => (int) $id)
            ->unique()
            ->values();

        if ($targets->isEmpty()) {
            return;
        }

        WorkflowStep::whereIn('id', $targets)->get()
            ->each(fn ($s) => $this->syncFromRequirements($s));
    }

    public function seedFromRequirements(WorkflowStep $step): void
    {
        $this->syncFromRequirements($step);
    }
}
