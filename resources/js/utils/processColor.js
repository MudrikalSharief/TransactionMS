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

// True when the paper has waited at its current station longer than the
// station's time limit (no limit set: never overdue).
export function isPastLimit(tx) {
    const limit = Number(tx?.current_step?.sla_minutes || 0)
    const since = tx?.entered_at || tx?.created_at
    if (!limit || !since || tx?.is_done) return false
    return Date.now() - new Date(since).getTime() > limit * 60000
}
