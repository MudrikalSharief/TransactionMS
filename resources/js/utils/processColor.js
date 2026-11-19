// One color + icon per process, picked from its name, so the same process
// looks the same on every dashboard card (By Process, queues, recent lists).

const PALETTE = ['#F26B21', '#3B82F6', '#8B5CF6', '#0EA5A4', '#0B2B66', '#E0569B']
const ICONS = [
    'mdi-cube-outline',
    'mdi-account-group-outline',
    'mdi-cog-outline',
    'mdi-file-document-multiple-outline',
    'mdi-briefcase-outline',
    'mdi-clipboard-text-outline',
]

function slot(name) {
    const s = String(name || '')
    let h = 0
    for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0
    return h % PALETTE.length
}

export function processColor(name) {
    return name ? PALETTE[slot(name)] : '#64748B'
}

export function processIcon(name) {
    return name ? ICONS[slot(name)] : 'mdi-file-document-outline'
}

export function txProcessName(tx) {
    return tx?.transaction_type?.name || tx?.transaction_type_name || ''
}

// Working-time countdowns use Manila office hours (same rule as
// App\Support\WorkingTime on the server).
export { workingMs } from '@/utils/workingTime'
import { workingMs } from '@/utils/workingTime'

/**
 * The SLA clock starts only when the destination worker clicks Receive.
 * Until then the paper is pending receipt, not overdue.
 */
function workStartedAt(tx) {
    return tx?.work_started_at || tx?.current_run_received_at || null
}

// True when the paper has been worked on at its current station longer than
// the station's time limit, in working time (no limit set: never overdue).
export function isPastLimit(tx) {
    const limit = Number(tx?.current_step?.sla_minutes || 0)
    const since = workStartedAt(tx)
    if (!limit || !since || tx?.is_done) return false
    return workingMs(since) > limit * 60000
}

// Open papers near or past their station's time limit (working time):
// 'overdue' once the limit has passed, 'due' with a quarter or less of it
// left, else null. Pending receipts are not overdue.
export function dueState(tx, now = Date.now()) {
    const limit = Number(tx?.current_step?.sla_minutes || 0)
    const since = workStartedAt(tx)
    if (!limit || !since || tx?.is_done) return null
    const left = limit * 60000 - workingMs(since, now)
    if (left < 0) return 'overdue'
    return left <= limit * 60000 * 0.25 ? 'due' : null
}
