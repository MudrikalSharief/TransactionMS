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

function bucket(typeId) {
    const key = String(typeId)
    if (!buckets.has(key)) {
        buckets.set(key, {
            typeId: Number(typeId),
            sourceDefId: null,
            sourceUpdatedAt: null,
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
        if (b.dirty) return b // never clobber staged edits with a refetch
        b.sourceDefId = sourceDefId != null ? Number(sourceDefId) : null
        b.sourceUpdatedAt = sourceUpdatedAt ?? null
        b.steps = (steps || []).map((s) => ({ ...s }))
    }

    function seedRoutes(typeId, routes) {
        const b = bucket(typeId)
        if (b.dirty) return b
        b.routes = (routes || []).map((r) => ({ ...r }))
    }

    function seedReqDefs(typeId, defs) {
        const b = bucket(typeId)
        if (b.dirty) return b
        b.reqDefs = (defs || []).map((d) => ({ ...d }))
    }

    function seedBindings(typeId, stepKey, rows) {
        const b = bucket(typeId)
        if (b.dirty) return b
        b.bindings[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
    }

    function seedChecklist(typeId, stepKey, rows) {
        const b = bucket(typeId)
        if (b.dirty) return b
        b.checklist[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
    }

    function seedFields(typeId, stepKey, rows) {
        const b = bucket(typeId)
        if (b.dirty) return b
        b.fields[String(stepKey)] = (rows || []).map((r) => ({ ...r }))
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
        discard,
        markClean,
        buildPayload,
        saveAll,
    }
}
