// Tiny stale-while-revalidate cache shared by list composables.
//
// - Tab switches (SPA route changes): served from the in-memory map, instant.
// - Reloads: served from localStorage (TTL), instant, then silently refreshed.
// - All reads/writes are guarded so private-mode or quota errors never break the app.

const memory = new Map()
const TTL_MS = 10 * 60 * 1000
const PREFIX = 'lgu-tx:cache:v4:'

// One-time purge of stale cache generations (e.g. v1): any cached entry not
// under the current PREFIX is dropped on boot, so lists cold-load fresh and
// new loading UI is actually seen. Non-cache keys (e.g. theme) are untouched.
try {
    const drop = []
    for (let i = 0; i < localStorage.length; i++) {
        const k = localStorage.key(i)
        if (k && k.startsWith('lgu-tx:cache:') && !k.startsWith(PREFIX)) drop.push(k)
    }
    drop.forEach((k) => localStorage.removeItem(k))
} catch { /* private mode: nothing cached to purge */ }

function safeParse(raw) {
    try {
        return JSON.parse(raw)
    } catch {
        return null
    }
}

// Generalized to any JSON value (arrays, objects, numbers): miss returns
// null, so callers must check `!= null` (a cached 0/false is valid data).
export function readCache(key) {
    if (memory.has(key)) return memory.get(key)

    try {
        const raw = localStorage.getItem(PREFIX + key)
        if (!raw) return null
        const parsed = safeParse(raw)
        if (!parsed || typeof parsed !== 'object' || !('d' in parsed)) return null
        if (Date.now() - parsed.t > TTL_MS) {
            try {
                localStorage.removeItem(PREFIX + key)
            } catch { /* ignore */ }
            return null
        }
        memory.set(key, parsed.d)
        return parsed.d
    } catch {
        return null
    }
}

export function writeCache(key, data) {
    if (data === undefined) return
    memory.set(key, data)
    try {
        localStorage.setItem(PREFIX + key, JSON.stringify({ t: Date.now(), d: data }))
    } catch { /* quota / private mode: memory cache still works */ }
}

export function isCached(key) {
    return readCache(key) !== null
}

export function invalidateCache(key) {
    memory.delete(key)
    try {
        localStorage.removeItem(PREFIX + key)
    } catch { /* ignore */ }
}

// Drop every cached entry under a base key (e.g. all `workflows:<id>`
// variants after an admin mutation), in memory and in localStorage.
export function invalidatePrefix(base) {
    const full = PREFIX + base
    try {
        for (const k of [...memory.keys()]) {
            if (k === base || k.startsWith(base + ':')) memory.delete(k)
        }
    } catch { /* ignore */ }
    try {
        const drop = []
        for (let i = 0; i < localStorage.length; i++) {
            const k = localStorage.key(i)
            if (k && (k === full || k.startsWith(full + ':'))) drop.push(k)
        }
        drop.forEach((k) => localStorage.removeItem(k))
    } catch { /* quota / private mode: memory already cleared */ }
}

// Per-user namespace for caches whose rows depend on who is logged in
// (transaction lists, badge counts). Prevents one browser profile leaking
// another user's painted rows between logins on a shared device.
export function scopedKey(base, userId) {
    return userId ? `${base}:${userId}` : base
}

// Last-known user id, read straight from persistence (not the memory map,
// which is empty on a fresh page load). Lets list/badge lookups build the
// correctly-scoped key even when they run before auth.init() has restored
// the session — previously that race produced an unscoped key, a cache
// miss, and a full loader flash on refresh.
export function storedUserId() {
    try {
        const raw = localStorage.getItem(PREFIX + CacheKeys.authUser)
        if (!raw) return null
        const parsed = safeParse(raw)
        if (!parsed || typeof parsed !== 'object' || !('d' in parsed)) return null
        if (Date.now() - parsed.t > TTL_MS) return null
        const id = parsed.d?.id
        return id ?? null
    } catch {
        return null
    }
}

export const CacheKeys = {
    transactions: 'tx-all',
    myTransactions: 'tx-my',
    transactionTypes: 'tx-types',
    offices: 'offices',
    roles: 'roles',
    users: 'admin-users',
    // Param-keyed lookups append ':' + id (workflows by type, requirement
    // defs by workflow, step data by step/workflow). Detail-level rows are
    // small; the 10-min TTL keeps admin config pages instant.
    workflows: 'workflows',
    govRefs: 'gov-refs',
    fields: 'fields',
    requirementDefs: 'req-defs',
    stepFields: 'step-fields',
    stepRequirements: 'step-reqs',
    stepChecklist: 'step-checklist',
    officeSteps: 'office-steps',
    summary: 'dash-summary',
    approvalCount: 'approval-count',
    authUser: 'auth-user',
}

// Slim projection: list/table/dashboard/search only need these fields.
// Full transaction payloads (nested fields, requirements, history) are
// huge and blow the ~5MB localStorage quota, which silently kills
// persistence. Details pages always fetch fresh via getOne().
export function slimTx(tx) {
    if (!tx || typeof tx !== 'object') return tx
    return {
        id: tx.id,
        title: tx.title ?? null,
        reference_number: tx.reference_number ?? null,
        is_done: tx.is_done ?? false,
        created_at: tx.created_at ?? null,
        // Dashboard "waiting" column reads entered_at with created_at fallback.
        entered_at: tx.entered_at ?? null,
        transaction_type_name: tx.transaction_type_name ?? tx.transaction_type?.name ?? null,
        transaction_type: tx.transaction_type
            ? { id: tx.transaction_type.id ?? null, name: tx.transaction_type.name ?? null }
            : null,
        office_name: tx.office_name ?? tx.office?.name ?? null,
        office: tx.office
            ? { id: tx.office.id ?? null, code: tx.office.code ?? null, name: tx.office.name ?? null }
            : null,
        workflow: tx.workflow
            ? {
                version: tx.workflow.version ?? null,
                status: tx.workflow.status ?? null,
                name: tx.workflow.name ?? null,
            }
            : null,
        current_step: tx.current_step
            ? {
                id: tx.current_step.id ?? null,
                order_number: tx.current_step.order_number ?? null,
                code: tx.current_step.code ?? null,
                name: tx.current_step.name ?? null,
                stage: tx.current_step.stage ?? null,
                is_start: tx.current_step.is_start ?? null,
                is_end: tx.current_step.is_end ?? null,
                office: tx.current_step.office
                    ? {
                        id: tx.current_step.office.id ?? null,
                        code: tx.current_step.office.code ?? null,
                        name: tx.current_step.office.name ?? null,
                    }
                    : null,
            }
            : null,
        // Kept slim (id/order/code/name/flags only) so the hover
        // step-progress popout also works from cached rows.
        workflow_steps: Array.isArray(tx.workflow_steps)
            ? tx.workflow_steps.map((s) => ({
                id: s.id ?? null,
                order_number: s.order_number ?? null,
                code: s.code ?? null,
                name: s.name ?? null,
                is_start: s.is_start ?? null,
                is_end: s.is_end ?? null,
            }))
            : null,
    }
}
