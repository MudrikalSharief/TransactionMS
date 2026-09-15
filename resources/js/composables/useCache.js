// Tiny stale-while-revalidate cache shared by list composables.
//
// - Tab switches (SPA route changes): served from the in-memory map, instant.
// - Reloads: served from localStorage (TTL), instant, then silently refreshed.
// - All reads/writes are guarded so private-mode or quota errors never break the app.

const memory = new Map()
const TTL_MS = 10 * 60 * 1000
const PREFIX = 'lgu-tx:cache:v1:'

function safeParse(raw) {
    try {
        return JSON.parse(raw)
    } catch {
        return null
    }
}

export function readCache(key) {
    if (memory.has(key)) return memory.get(key)

    try {
        const raw = localStorage.getItem(PREFIX + key)
        if (!raw) return null
        const parsed = safeParse(raw)
        if (!parsed || !Array.isArray(parsed.d)) return null
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
    if (!Array.isArray(data)) return
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

export const CacheKeys = {
    transactions: 'tx-all',
    myTransactions: 'tx-my',
    transactionTypes: 'tx-types',
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
        created_at: tx.created_at ?? null,
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
                code: tx.current_step.code ?? null,
                name: tx.current_step.name ?? null,
                is_start: tx.current_step.is_start ?? null,
                is_end: tx.current_step.is_end ?? null,
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
