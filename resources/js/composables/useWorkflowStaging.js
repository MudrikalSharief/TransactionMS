import { computed, reactive } from 'vue'
import { useApi } from '@/composables/useApi'
import { invalidatePrefix, CacheKeys } from '@/composables/useCache'

// Staging store: NOTHING hits the network until Save version.
//
// One bucket per transaction type holds a working copy of the workflow
// content (steps, routes, requirement defs + bindings, checklist rows,
// field assignments). Dialogs mutate the working copy only; the bulk
// endpoint persists everything atomically. New rows use "tmp_<n>" client
// ids, resolved server-side. Discard drops the bucket (pages refetch).
//
// Rows staged against a published version are fine: the server remaps by
// code into the draft it ensures. Steps that don't exist on the
// server yet (tmp) can't open the requirements/checklist/fields sub-pages
// — those buttons stay disabled until the first save mints real ids.

let tmpSeq = 0
export function tmpKey() {
    tmpSeq += 1
    return `tmp_${Date.now().toString(36)}_${tmpSeq}`
}

const buckets = reactive(new Map())

const cloneRows = (rows) => (rows || []).map((row) => ({ ...row }))

// Baselines let the modal show what changed instead of the size of the
// working copy. They are captured before the dirty guard so navigating
// from one staging slice to another still gives us a source to diff.
function captureRows(b, key, rows) {
    if (b[key] == null) b[key] = cloneRows(rows)
}

function captureStepRows(b, key, stepKey, rows) {
    if (!b[key]) b[key] = {}
    const k = String(stepKey)
    if (!Object.prototype.hasOwnProperty.call(b[key], k)) {
        b[key][k] = cloneRows(rows)
    }
}

function hasStepRows(map, stepKey) {
    return !!map && Object.prototype.hasOwnProperty.call(map, String(stepKey))
}

function bucket(typeId) {
    const key = String(typeId)
    if (!buckets.has(key)) {
        buckets.set(key, {
            typeId: Number(typeId),
            sourceDefId: null,
            sourceUpdatedAt: null,
            // Source snapshots for the staged-change counters.
            sourceSteps: null,
            sourceRoutes: null,
            sourceReqDefs: null,
            sourceBindings: {},
            sourceChecklist: {},
            sourceFields: {},
            steps: [],
            routes: [],
            reqDefs: [],
            bindings: {},
            checklist: {},
            resyncSteps: [],
            fields: {},
            removedStepIds: [],
            removedRouteIds: [],
            removedReqIds: [],
            dirty: false,
            // Per-entity dirty mirrors for tab dots (cleared with the
            // bucket by discard/markClean, same lifecycle as `dirty`).
            stepsDirty: false,
            routesDirty: false,
        })
    }
    return buckets.get(key)
}

function rowKey(r) {
    return r?.client_id ?? r?.id
}

// Module-level helpers (safe outside setup: no composition API used).
export function stagingIsDirty(typeId) {
    const b = buckets.get(String(typeId))
    return !!b?.dirty
}

export function anyStagingDirty() {
    for (const b of buckets.values()) if (b.dirty) return true
    return false
}

export function clearAllStaging() {
    buckets.clear()
}

function idValue(value) {
    if (value == null || value === '') return null
    const n = Number(value)
    return Number.isFinite(n) ? n : value
}

function numberOrNull(value) {
    if (value == null || value === '') return null
    const n = Number(value)
    return Number.isFinite(n) ? n : value
}

function textOrNull(value) {
    return value == null || value === '' ? null : value
}

function idList(values) {
    return Array.from(values || [])
        .map((value) => Number(value))
        .filter((value) => Number.isFinite(value))
        .sort((a, b) => a - b)
}

function diffRow(oldRow, newRow, specs) {
    const changes = []
    for (const spec of specs) {
        const from = spec.normalize(spec.get(oldRow))
        const to = spec.normalize(spec.get(newRow))
        if (JSON.stringify(from) !== JSON.stringify(to)) {
            changes.push({ field: spec.key, label: spec.label, from, to })
        }
    }
    return changes
}

function collectListChanges(sourceRows, workingRows, keyFn, specs) {
    const source = new Map()
    ;(sourceRows || []).forEach((row, idx) => {
        source.set(keyFn(row, idx) ?? `source:${idx}`, row)
    })
    const working = new Map()
    ;(workingRows || []).forEach((row, idx) => {
        working.set(keyFn(row, idx) ?? `working:${idx}`, row)
    })
    const items = []
    for (const [key, row] of working) {
        const old = source.get(key)
        if (!old) {
            items.push({ kind: 'added', key, row, changes: [] })
        } else {
            const changes = diffRow(old, row, specs)
            if (changes.length) items.push({ kind: 'updated', key, row, changes })
        }
    }
    for (const [key, row] of source) {
        if (!working.has(key)) items.push({ kind: 'removed', key, row, changes: [] })
    }
    return items
}

function bindingRawKey(r) {
    return r?.req_key ?? r?.requirement_definition_id ?? r?.id
}

function bindingKey(r) {
    const key = bindingRawKey(r)
    return key == null ? null : `req:${key}`
}

function checklistKey(r, idx) {
    return r?.id != null ? `id:${r.id}` : `new:${idx}`
}

function fieldKey(r) {
    const id = r?.field_definition_id
    return id == null ? null : `field:${id}`
}

function stepLabel(step) {
    return step?.name || (step?.id != null ? `Step #${step.id}` : 'Untitled step')
}

function routeLabel(route, stepName) {
    const from = stepName(route?.from_step_id ?? route?.from_key)
    const to = stepName(route?.to_step_id ?? route?.to_key)
    const action = textOrNull(route?.action_code)
    return action ? `${from} → ${to} (${action})` : `${from} → ${to}`
}

function requirementLabel(def) {
    return def?.name || def?.code || (def?.id != null ? `Requirement #${def.id}` : 'Requirement')
}

const STEP_SPECS = [
    { key: 'name', label: 'Name', get: (s) => s?.name, normalize: (v) => String(v ?? '') },
    { key: 'code', label: 'Code', get: (s) => s?.code, normalize: textOrNull },
    { key: 'order_number', label: 'Order', get: (s) => s?.order_number, normalize: (v) => Number(v ?? 0) },
    { key: 'parent', label: 'Parent step', get: (s) => s?.parent_id ?? s?.parent_key, normalize: idValue },
    { key: 'stage', label: 'Stage', get: (s) => s?.stage, normalize: textOrNull },
    { key: 'office', label: 'Office', get: (s) => s?.office_id, normalize: idValue },
    { key: 'sla_minutes', label: 'SLA', get: (s) => s?.sla_minutes, normalize: (v) => Number(v ?? 0) },
    { key: 'is_start', label: 'Start step', get: (s) => s?.is_start, normalize: (v) => !!v },
    { key: 'is_end', label: 'End step', get: (s) => s?.is_end, normalize: (v) => !!v },
    {
        key: 'roles',
        label: 'Roles',
        get: (s) => s?.role_ids ?? s?.roles?.map?.((r) => r.id) ?? [],
        normalize: idList,
    },
]

const ROUTE_SPECS = [
    { key: 'from', label: 'From step', get: (r) => r?.from_step_id ?? r?.from_key, normalize: idValue },
    { key: 'to', label: 'To step', get: (r) => r?.to_step_id ?? r?.to_key, normalize: idValue },
    { key: 'action_code', label: 'Action', get: (r) => r?.action_code, normalize: textOrNull },
    {
        key: 'is_return_route',
        label: 'Return route',
        get: (r) => r?.is_return_route,
        normalize: (v) => !!v,
    },
    {
        key: 'condition_expression',
        label: 'Condition',
        get: (r) => r?.condition_expression,
        normalize: textOrNull,
    },
    { key: 'route_group', label: 'Route group', get: (r) => r?.route_group, normalize: textOrNull },
    {
        key: 'required_approvals_count',
        label: 'Required approvals',
        get: (r) => r?.required_approvals_count,
        normalize: numberOrNull,
    },
]

const REQUIREMENT_SPECS = [
    { key: 'code', label: 'Code', get: (d) => d?.code, normalize: textOrNull },
    { key: 'name', label: 'Name', get: (d) => d?.name, normalize: (v) => String(v ?? '') },
    { key: 'label', label: 'Label', get: (d) => d?.label, normalize: textOrNull },
    { key: 'description', label: 'Description', get: (d) => d?.description, normalize: textOrNull },
    {
        key: 'is_active',
        label: 'Active',
        get: (d) => d?.is_active,
        normalize: (v) => !!(v ?? true),
    },
    {
        key: 'order_number',
        label: 'Order',
        get: (d) => d?.order_number,
        normalize: (v) => Number(v ?? 0),
    },
]

const BINDING_SPECS = [
    {
        key: 'display_order',
        label: 'Order',
        get: (r) => r?.display_order,
        normalize: (v) => Number(v ?? 0),
    },
    {
        key: 'is_required',
        label: 'Required',
        get: (r) => r?.is_required,
        normalize: (v) => !!(v ?? true),
    },
    {
        key: 'is_upload_required',
        label: 'Upload required',
        get: (r) => r?.is_upload_required ?? r?.is_required,
        normalize: (v) => !!(v ?? true),
    },
    { key: 'code', label: 'Code', get: (r) => r?.code, normalize: textOrNull },
    { key: 'description', label: 'Description', get: (r) => r?.description, normalize: textOrNull },
]

const CHECKLIST_SPECS = [
    {
        key: 'requirement',
        label: 'Linked requirement',
        get: (r) => r?.requirement_key ?? r?.requirement_definition_id,
        normalize: idValue,
    },
    { key: 'name', label: 'Name', get: (r) => r?.name, normalize: (v) => String(v ?? '') },
    { key: 'code', label: 'Code', get: (r) => r?.code, normalize: textOrNull },
    { key: 'description', label: 'Description', get: (r) => r?.description, normalize: textOrNull },
    {
        key: 'is_required',
        label: 'Required',
        get: (r) => r?.is_required,
        normalize: (v) => !!(v ?? true),
    },
    {
        key: 'display_order',
        label: 'Order',
        get: (r) => r?.display_order,
        normalize: (v) => Number(v ?? 0),
    },
]

const FIELD_SPECS = [
    {
        key: 'display_order',
        label: 'Order',
        get: (r) => r?.display_order,
        normalize: (v) => Number(v ?? 0),
    },
    {
        key: 'required_override',
        label: 'Required override',
        get: (r) => r?.required_override,
        normalize: (v) => (v == null ? null : !!v),
    },
]

// What this save actually changes. Deletions are explicit for
// steps/routes/req defs; checklist/field/binding removals are diffs against
// the per-step baseline.
function collectChanges(typeId) {
    const b = buckets.get(String(typeId))
    const details = { steps: [], routes: [], requirements: [], checklists: [], fields: [] }
    if (!b) return details

    const sourceSteps = b.sourceSteps || []
    const workingSteps = b.steps || []
    const stepLabels = new Map()
    for (const step of [...sourceSteps, ...workingSteps]) {
        if (step?.id != null) stepLabels.set(String(step.id), stepLabel(step))
    }
    const stepName = (id) => {
        if (id == null) return 'Unknown step'
        return stepLabels.get(String(id)) || `Step #${id}`
    }

    const sourceStepById = new Map(sourceSteps.map((s) => [String(s.id), s]))
    for (const step of workingSteps) {
        const key = String(step.client_id ?? step.id)
        const old = sourceStepById.get(key) ?? sourceStepById.get(String(step.id))
        if (!old) {
            details.steps.push({ kind: 'added', label: stepLabel(step), changes: [] })
        } else {
            const changes = diffRow(old, step, STEP_SPECS)
            if (changes.length) {
                details.steps.push({ kind: 'updated', label: stepLabel(step), changes })
            }
        }
    }
    for (const id of b.removedStepIds || []) {
        const old = sourceStepById.get(String(id))
        details.steps.push({
            kind: 'removed',
            label: old ? stepLabel(old) : `Step #${id}`,
            changes: [],
        })
    }

    const sourceRoutes = b.sourceRoutes || []
    const workingRoutes = b.routes || []
    const sourceRouteById = new Map(sourceRoutes.map((r) => [String(r.id), r]))
    const workingRouteIds = new Set()
    for (const route of workingRoutes) {
        workingRouteIds.add(String(route.id))
        const key = String(route.client_id ?? route.id)
        const old = sourceRouteById.get(key) ?? sourceRouteById.get(String(route.id))
        if (!old) {
            details.routes.push({ kind: 'added', label: routeLabel(route, stepName), changes: [] })
        } else {
            const changes = diffRow(old, route, ROUTE_SPECS)
            if (changes.length) {
                details.routes.push({ kind: 'updated', label: routeLabel(route, stepName), changes })
            }
        }
    }
    const removedRouteIds = new Set((b.removedRouteIds || []).map(String))
    for (const id of b.removedRouteIds || []) {
        const old = sourceRouteById.get(String(id))
        details.routes.push({
            kind: 'removed',
            label: old ? routeLabel(old, stepName) : `Route #${id}`,
            changes: [],
        })
    }
    // Removing a step prunes its routes without a route-delete id.
    const removedStepIds = new Set((b.removedStepIds || []).map(String))
    for (const route of sourceRoutes) {
        const routeId = String(route.id)
        if (workingRouteIds.has(routeId) || removedRouteIds.has(routeId)) continue
        const from = String(idValue(route.from_step_id ?? route.from_key) ?? '')
        const to = String(idValue(route.to_step_id ?? route.to_key) ?? '')
        if (removedStepIds.has(from) || removedStepIds.has(to)) {
            details.routes.push({ kind: 'removed', label: routeLabel(route, stepName), changes: [] })
        }
    }

    const sourceReqs = b.sourceReqDefs || []
    const workingReqs = b.reqDefs || []
    const reqLabels = new Map()
    for (const def of [...sourceReqs, ...workingReqs]) {
        const label = requirementLabel(def)
        if (def?.id != null) reqLabels.set(String(def.id), label)
        if (def?.client_id != null) reqLabels.set(String(def.client_id), label)
    }
    const reqName = (row) => {
        const key = bindingRawKey(row)
        return (
            reqLabels.get(String(key)) ||
            textOrNull(row?.name) ||
            textOrNull(row?.code) ||
            (key != null ? `Requirement #${key}` : 'Requirement')
        )
    }

    const sourceReqById = new Map(sourceReqs.map((d) => [String(d.id), d]))
    for (const def of workingReqs) {
        const key = String(def.client_id ?? def.id)
        const old = sourceReqById.get(key) ?? sourceReqById.get(String(def.id))
        if (!old) {
            details.requirements.push({ kind: 'added', label: requirementLabel(def), changes: [] })
        } else {
            const changes = diffRow(old, def, REQUIREMENT_SPECS)
            if (changes.length) {
                details.requirements.push({ kind: 'updated', label: requirementLabel(def), changes })
            }
        }
    }
    for (const id of b.removedReqIds || []) {
        const old = sourceReqById.get(String(id))
        details.requirements.push({
            kind: 'removed',
            label: old ? requirementLabel(old) : `Requirement #${id}`,
            changes: [],
        })
    }

    const bindingSteps = new Set([
        ...Object.keys(b.sourceBindings || {}),
        ...Object.keys(b.bindings || {}),
    ])
    for (const sk of bindingSteps) {
        if (!hasStepRows(b.bindings, sk)) continue
        const items = collectListChanges(
            b.sourceBindings?.[sk] || [],
            b.bindings?.[sk] || [],
            bindingKey,
            BINDING_SPECS,
        )
        for (const item of items) {
            details.requirements.push({
                kind: item.kind,
                label: `${stepName(sk)}: ${reqName(item.row)}`,
                changes: item.changes,
            })
        }
    }

    const resyncSteps = new Set((b.resyncSteps || []).map(String))
    const checklistSteps = new Set([
        ...Object.keys(b.sourceChecklist || {}),
        ...Object.keys(b.checklist || {}),
        ...resyncSteps,
    ])
    for (const sk of checklistSteps) {
        if (resyncSteps.has(String(sk))) {
            details.checklists.push({
                kind: 'updated',
                label: `${stepName(sk)}: Rebuild checklist from requirements`,
                changes: [],
            })
            continue
        }
        if (!hasStepRows(b.checklist, sk)) continue
        const items = collectListChanges(
            b.sourceChecklist?.[sk] || [],
            b.checklist?.[sk] || [],
            checklistKey,
            CHECKLIST_SPECS,
        )
        for (const item of items) {
            const name =
                textOrNull(item.row?.name) || textOrNull(item.row?.code) || 'Checklist item'
            details.checklists.push({
                kind: item.kind,
                label: `${stepName(sk)}: ${name}`,
                changes: item.changes,
            })
        }
    }

    const fieldSteps = new Set([
        ...Object.keys(b.sourceFields || {}),
        ...Object.keys(b.fields || {}),
    ])
    for (const sk of fieldSteps) {
        if (!hasStepRows(b.fields, sk)) continue
        const items = collectListChanges(
            b.sourceFields?.[sk] || [],
            b.fields?.[sk] || [],
            fieldKey,
            FIELD_SPECS,
        )
        for (const item of items) {
            const name =
                textOrNull(item.row?.name) ||
                textOrNull(item.row?.code) ||
                (item.row?.field_definition_id != null
                    ? `Field #${item.row.field_definition_id}`
                    : 'Field assignment')
            details.fields.push({
                kind: item.kind,
                label: `${stepName(sk)}: ${name}`,
                changes: item.changes,
            })
        }
    }

    return details
}

export function changedCounts(typeId) {
    const details = collectChanges(typeId)
    return {
        steps: details.steps.length,
        routes: details.routes.length,
        requirements: details.requirements.length,
        checklists: details.checklists.length,
        fields: details.fields.length,
    }
}

export function changedDetails(typeId) {
    return collectChanges(typeId)
}

export function useWorkflowStaging() {
    const { api } = useApi()

    function isDirty(typeId) {
        const b = buckets.get(String(typeId))
        return !!b?.dirty
    }

    const anyDirty = computed(() => [...buckets.values()].some((b) => b.dirty))

    function touch(b) {
        b.dirty = true
    }

    // ---- seeding (from last server state) ----

    function seedSteps(typeId, sourceDefId, sourceUpdatedAt, steps) {
        const b = bucket(typeId)
        const nextDefId = sourceDefId != null ? Number(sourceDefId) : null
        // A clean bucket switching versions should diff against the newly
        // selected definition, not the previous one.
        if (!b.dirty && b.sourceDefId !== nextDefId) {
            b.sourceSteps = null
            b.sourceRoutes = null
            b.sourceReqDefs = null
            b.sourceBindings = {}
            b.sourceChecklist = {}
            b.sourceFields = {}
            // Clean version switch: drop sub-page slices from the old
            // definition so they are not mistaken for new staged rows.
            b.reqDefs = []
            b.bindings = {}
            b.checklist = {}
            b.fields = {}
            b.resyncSteps = []
        }
        captureRows(b, 'sourceSteps', steps)
        if (b.dirty) return b // never clobber staged edits with a refetch
        b.sourceDefId = nextDefId
        b.sourceUpdatedAt = sourceUpdatedAt ?? null
        b.steps = cloneRows(steps)
    }

    function seedRoutes(typeId, routes) {
        const b = bucket(typeId)
        captureRows(b, 'sourceRoutes', routes)
        if (b.dirty) return b
        b.routes = cloneRows(routes)
    }

    function seedReqDefs(typeId, defs) {
        const b = bucket(typeId)
        captureRows(b, 'sourceReqDefs', defs)
        if (b.dirty) return b
        b.reqDefs = cloneRows(defs)
    }

    function seedBindings(typeId, stepKey, rows) {
        const b = bucket(typeId)
        captureStepRows(b, 'sourceBindings', stepKey, rows)
        if (b.dirty) return b
        b.bindings[String(stepKey)] = cloneRows(rows)
    }

    function seedChecklist(typeId, stepKey, rows) {
        const b = bucket(typeId)
        captureStepRows(b, 'sourceChecklist', stepKey, rows)
        if (b.dirty) return b
        b.checklist[String(stepKey)] = cloneRows(rows)
    }

    function seedFields(typeId, stepKey, rows) {
        const b = bucket(typeId)
        captureStepRows(b, 'sourceFields', stepKey, rows)
        if (b.dirty) return b
        b.fields[String(stepKey)] = cloneRows(rows)
    }

    function markResync(typeId, stepKey) {
        const b = bucket(typeId)
        const k = String(stepKey)
        if (!b.resyncSteps.includes(k)) b.resyncSteps.push(k)
        touch(b)
    }

    // ---- staged mutations (no network) ----

    function upsertStep(typeId, row) {
        const b = bucket(typeId)
        const k = String(rowKey(row) ?? tmpKey())
        const idx = b.steps.findIndex((s) => String(rowKey(s)) === k)
        const next = { ...row }
        // Tmp rows carry the client key as `id` too, so tree/table logic
        // (keyed by id) works before the server mints real ids.
        if (next.id == null) next.id = k
        if (!next.client_id) next.client_id = k
        if (idx >= 0) b.steps.splice(idx, 1, { ...b.steps[idx], ...next })
        else b.steps.push(next)
        touch(b)
        b.stepsDirty = true
        return next
    }

    function removeStep(typeId, key) {
        const b = bucket(typeId)
        const k = String(key)
        const idx = b.steps.findIndex((s) => String(rowKey(s)) === k)
        if (idx === -1) return
        const [gone] = b.steps.splice(idx, 1)
        // Only real (numeric) ids go to the server delete list — tmp rows
        // simply vanish from the working copy.
        if (typeof gone?.id === 'number') b.removedStepIds.push(gone.id)
        // Drop dangling staged references to the removed step.
        b.routes = b.routes.filter(
            (r) => String(r.from_step_id ?? r.from_key) !== k && String(r.to_step_id ?? r.to_key) !== k,
        )
        delete b.bindings[k]
        delete b.checklist[k]
        delete b.fields[k]
        b.resyncSteps = b.resyncSteps.filter((s) => s !== k)
        touch(b)
        // Removing a step also prunes its staged routes above.
        b.stepsDirty = true
        b.routesDirty = true
    }

    function upsertRoute(typeId, row) {
        const b = bucket(typeId)
        const k = String(rowKey(row) ?? row.id ?? tmpKey())
        const idx = b.routes.findIndex((r) => String(rowKey(r) ?? r.id) === k)
        const next = { ...row }
        if (next.id == null) next.id = k
        if (!next.client_id) next.client_id = k
        if (idx >= 0) b.routes.splice(idx, 1, { ...b.routes[idx], ...next })
        else b.routes.push(next)
        touch(b)
        b.routesDirty = true
        return next
    }

    function removeRoute(typeId, key) {
        const b = bucket(typeId)
        const k = String(key)
        const idx = b.routes.findIndex((r) => String(rowKey(r) ?? r.id) === k)
        if (idx === -1) return
        const [gone] = b.routes.splice(idx, 1)
        if (typeof gone?.id === 'number') b.removedRouteIds.push(gone.id)
        touch(b)
        b.routesDirty = true
    }

    function upsertReqDef(typeId, row) {
        const b = bucket(typeId)
        const k = String(rowKey(row) ?? row.id ?? tmpKey())
        const idx = b.reqDefs.findIndex((d) => String(rowKey(d) ?? d.id) === k)
        const next = { ...row }
        if (next.id == null) next.id = k
        if (!next.client_id) next.client_id = k
        if (idx >= 0) b.reqDefs.splice(idx, 1, { ...b.reqDefs[idx], ...next })
        else b.reqDefs.push(next)
        touch(b)
        return next
    }

    function removeReqDef(typeId, key) {
        const b = bucket(typeId)
        const k = String(key)
        const idx = b.reqDefs.findIndex((d) => String(rowKey(d) ?? d.id) === k)
        if (idx === -1) return
        const [gone] = b.reqDefs.splice(idx, 1)
        if (typeof gone?.id === 'number') b.removedReqIds.push(gone.id)
        // Detach from every staged binding/checklist row.
        for (const sk of Object.keys(b.bindings)) {
            b.bindings[sk] = (b.bindings[sk] || []).filter((r) => String(r.requirement_definition_id ?? r.req_key) !== k)
        }
        for (const sk of Object.keys(b.checklist)) {
            b.checklist[sk] = (b.checklist[sk] || []).filter(
                (r) => String(r.requirement_definition_id ?? r.requirement_key ?? '') !== k,
            )
        }
        touch(b)
    }

    function setBindings(typeId, stepKey, rows) {
        const b = bucket(typeId)
        b.bindings[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
        touch(b)
    }

    function setChecklist(typeId, stepKey, rows) {
        const b = bucket(typeId)
        b.checklist[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
        touch(b)
    }

    function setFields(typeId, stepKey, rows) {
        const b = bucket(typeId)
        b.fields[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
        touch(b)
    }

    function discard(typeId) {
        buckets.delete(String(typeId))
    }

    function markClean(typeId) {
        buckets.delete(String(typeId))
    }

    // ---- bulk save (the ONLY writer) ----

    function stepRef(s) {
        // New rows keep tmp keys; existing rows keep numeric ids. Codes
        // travel along so the server can remap across draft/published scope.
        return s?.client_id ?? s?.id
    }

    function buildPayload(typeId) {
        const b = buckets.get(String(typeId))
        if (!b) return null
        const steps_upsert = b.steps.map((s) => ({
            key: stepRef(s),
            code: s.code ?? null,
            parent_key: s.parent_id ?? s.parent_key ?? null,
            order_number: Number(s.order_number),
            name: s.name,
            stage: s.stage ?? null,
            office_id: s.office_id ?? null,
            sla_minutes: Number(s.sla_minutes ?? 0),
            is_start: !!s.is_start,
            is_end: !!s.is_end,
            is_end_user: !!s.is_end_user,
            role_ids: (s.role_ids ?? s.roles?.map?.((r) => r.id) ?? []).map(Number),
        }))
        const routes_upsert = b.routes.map((r) => ({
            key: r.client_id ?? r.id,
            from_key: r.from_step_id ?? r.from_key,
            to_key: r.to_step_id ?? r.to_key,
            action_code: r.action_code,
            is_return_route: !!r.is_return_route,
            condition_expression: r.condition_expression ?? null,
            route_group: r.route_group ?? null,
            required_approvals_count: r.required_approvals_count ?? null,
        }))
        const requirements_upsert = b.reqDefs.map((d) => ({
            key: d.client_id ?? d.id,
            code: d.code ?? null,
            name: d.name,
            label: d.label ?? null,
            description: d.description ?? null,
            is_active: d.is_active ?? true,
            order_number: Number(d.order_number ?? 0),
        }))
        const step_requirements = {}
        for (const [sk, rows] of Object.entries(b.bindings)) {
            step_requirements[sk] = (rows || []).map((r, idx) => ({
                req_key: r.requirement_definition_id ?? r.req_key,
                display_order: Number(r.display_order ?? idx),
                is_required: r.is_required ?? true,
                is_upload_required: r.is_upload_required ?? r.is_required ?? true,
                code: r.code ?? '',
                description: r.description ?? '',
            }))
        }
        const step_checklist = {}
        for (const [sk, rows] of Object.entries(b.checklist)) {
            step_checklist[sk] = (rows || []).map((r, idx) => ({
                id: r.id ?? null,
                requirement_key: r.requirement_definition_id ?? r.requirement_key ?? null,
                name: r.name,
                code: r.code ?? null,
                description: r.description ?? null,
                is_required: r.is_required ?? true,
                display_order: Number(r.display_order ?? idx),
            }))
        }
        const step_fields = {}
        for (const [sk, rows] of Object.entries(b.fields)) {
            step_fields[sk] = (rows || []).map((r) => ({
                field_definition_id: Number(r.field_definition_id),
                display_order: Number(r.display_order ?? 0),
                required_override: r.required_override ?? null,
            }))
        }
        return {
            steps_upsert,
            steps_delete: b.removedStepIds.map((id) => ({ id })),
            routes_upsert,
            routes_delete: b.removedRouteIds.map((id) => ({ id })),
            requirements_upsert,
            requirements_delete: b.removedReqIds.map((id) => ({ id })),
            step_requirements,
            step_checklist,
            resync_checklist_steps: [...b.resyncSteps],
            step_fields,
            source_updated_at: b.sourceUpdatedAt,
        }
    }

    async function saveAll(typeId, defId, { mode, name = null, notes = null } = {}) {
        const payload = buildPayload(typeId)
        if (!payload) throw new Error('Nothing staged to save.')
        payload.mode = mode
        if (name) payload.name = name
        if (notes !== null && notes !== undefined) payload.notes = notes
        const res = await api.post(`/api/admin/workflow-definitions/${defId}/apply-staged`, payload)
        const meta = res.data?.meta ?? {}
        // Server content is now canonical: drop staged state everywhere
        // workflow-ish so lists repaint from the fresh fetch.
        markClean(typeId)
        invalidatePrefix(CacheKeys.workflows)
        invalidatePrefix(CacheKeys.requirementDefs)
        invalidatePrefix(CacheKeys.stepFields)
        invalidatePrefix(CacheKeys.stepRequirements)
        invalidatePrefix(CacheKeys.stepChecklist)
        invalidatePrefix(CacheKeys.transactions)
        invalidatePrefix(CacheKeys.myTransactions)
        return { data: res.data?.data ?? res.data, meta }
    }

    return {
        buckets,
        isDirty,
        anyDirty,
        seedSteps,
        seedRoutes,
        seedReqDefs,
        seedBindings,
        seedChecklist,
        seedFields,
        markResync,
        upsertStep,
        removeStep,
        upsertRoute,
        removeRoute,
        upsertReqDef,
        removeReqDef,
        setBindings,
        setChecklist,
        setFields,
        changedCounts,
        changedDetails,
        discard,
        markClean,
        buildPayload,
        saveAll,
    }
}
