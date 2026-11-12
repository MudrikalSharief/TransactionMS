import { fmtDateTime } from '@/utils/dates'
import { readCache, writeCache, CacheKeys } from '@/composables/useCache'
import { useAuth, isSuperadminUser } from '@/composables/useAuth'

// Superadmins read the summary from /api/admin; office admins from
// /api/office, where the server forces their own office's scope.
export function summaryApiBase() {
    return isSuperadminUser(useAuth().user.value) ? '/api/admin/dashboard/summary' : '/api/office/dashboard/summary'
}

// Shared by the Transaction Summary popover (compact) and full-list window:
// category wording/colors and how each row reads.

export const SUMMARY_META = {
    completed: {
        title: 'Completed transactions', short: 'Completed', icon: 'mdi-check-circle', light: '#008300', dark: '#2fa84f',
        explain: 'Finalized at their last station during this period, newest first.',
        empty: 'No transactions were finalized in this period.',
    },
    in_process: {
        title: 'In-process transactions', short: 'In-process', icon: 'mdi-progress-clock', light: '#2a78d6', dark: '#3987e5',
        explain: 'Created in this period and still moving through their stations. Longest waiting first.',
        empty: 'Nothing created in this period is still open.',
    },
    overdue: {
        title: 'Overdue transactions', short: 'Overdue', icon: 'mdi-alert', light: '#c98500', dark: '#e0a526',
        explain: 'Still open and waiting longer than their current station allows. Most overdue first.',
        empty: 'Nothing in this period is past its station’s time limit.',
    },
    deleted: {
        title: 'Deleted transactions', short: 'Deleted', icon: 'mdi-delete-outline', light: '#6f6d68', dark: '#a3a19b',
        explain: 'Created in this period and later deleted. Deleted transactions can’t be opened.',
        empty: 'No transactions created in this period were deleted.',
    },
    process: {
        title: '', short: '', icon: 'mdi-format-list-bulleted-type', light: '#2a78d6', dark: '#3987e5',
        explain: 'Every transaction of this process created in this period, newest first.',
        empty: 'No transactions of this process were created in this period.',
    },
    on_time: {
        title: 'On-time transactions', short: 'On time', icon: 'mdi-timer-check-outline', light: '#008300', dark: '#2fa84f',
        explain: 'Finalized in this period before their deadline (the total of their stations’ time limits), archived ones included. Newest first.',
        empty: 'No transactions were finished on time in this period.',
    },
    returns: {
        title: 'Returned transactions', short: 'Returns', icon: 'mdi-undo-variant', light: '#7c4dcc', dark: '#a37be6',
        explain: 'Sent back to an earlier station during this period. Most returns first.',
        empty: 'Nothing was returned in this period.',
    },
}

// Office in charge and the people assigned there, as one line.
export function inCharge(r) {
    const office = r.office_in_charge?.code || r.office_in_charge?.name || ''
    const people = (r.assigned || []).join(', ')
    return [office, people].filter(Boolean).join(' · ')
}

// Lists that can be narrowed to one office of a dashboard chart.
const BY_OFFICE = ['overdue', 'on_time', 'returns']

export function summaryMeta(category) {
    return SUMMARY_META[category] || SUMMARY_META.in_process
}

export function dur(min) {
    if (min === null || min === undefined) return '—'
    const m = Math.max(0, Math.round(min))
    const d = Math.floor(m / 1440)
    const h = Math.floor((m % 1440) / 60)
    const mm = m % 60
    if (d) return h ? `${d} d ${h} h` : `${d} d`
    if (h) return mm ? `${h} h ${mm} m` : `${h} h`
    return `${mm} m`
}

const minutesSince = (iso) => (iso ? (Date.now() - new Date(iso).getTime()) / 60000 : null)

// "Station 3: Finalize Payroll", but not "Station 1: Station 1".
export function stationName(s) {
    if (!s) return 'no station'
    return /station\s*\d/i.test(s.name) ? s.name : `Station ${s.order_number}: ${s.name}`
}

const byName = (u) => (u?.name ? `by ${u.name}` : '')

/** Row as: from -> to, plus the one number that matters for the category. */
export function rowView(category, r) {
    const created = { label: 'Created', value: fmtDateTime(r.created_at), sub: byName(r.created_by) }
    const station = {
        label: r.current_step ? `Now at station ${r.current_step.order_number}` : 'Station',
        value: r.current_step?.name || '—',
        sub: r.handled_by?.length ? `Handled by ${r.handled_by.join(', ')}` : '',
    }
    switch (category) {
        case 'completed':
            return {
                from: created,
                to: { label: 'Finalized', value: fmtDateTime(r.finalized_at), sub: byName(r.finalized_by) },
                metric: { value: dur(r.duration_minutes), label: 'from start to finish' },
                brief: `Finalized ${fmtDateTime(r.finalized_at)}${r.finalized_by?.name ? ` by ${r.finalized_by.name}` : ''}`,
            }
        case 'overdue':
            return {
                from: { label: 'Arrived at station', value: fmtDateTime(r.entered_at) },
                to: {
                    ...station,
                    sub: inCharge(r) ? `In charge: ${inCharge(r)}` : station.sub,
                },
                metric: { value: `${dur(r.overdue_minutes)} over`, label: `Limit ${dur(r.sla_minutes)}`, tone: 'warn', icon: 'mdi-alert' },
                brief: `At ${r.current_step ? stationName(r.current_step) : 'no station'}`,
            }
        case 'on_time':
            return {
                from: created,
                to: {
                    label: r.archived ? 'Finalized · now archived' : 'Finalized',
                    value: fmtDateTime(r.finalized_at),
                    sub: inCharge(r) ? `In charge: ${inCharge(r)}` : byName(r.finalized_by),
                },
                metric: {
                    value: `${dur(r.deadline_minutes - r.spent_minutes)} early`,
                    label: `Took ${dur(r.spent_minutes)} of ${dur(r.deadline_minutes)}`,
                    tone: 'good',
                    icon: 'mdi-timer-check-outline',
                },
                brief: `Finalized ${fmtDateTime(r.finalized_at)}${r.finalized_by?.name ? ` by ${r.finalized_by.name}` : ''}`,
            }
        case 'returns':
            return {
                from: {
                    label: 'Returned by',
                    value: r.returned_from ? stationName(r.returned_from) : '—',
                    sub: inCharge(r) ? `In charge: ${inCharge(r)}` : '',
                },
                to: {
                    label: 'Sent back to',
                    value: r.returned_to ? stationName(r.returned_to) : '—',
                    sub: `Last on ${fmtDateTime(r.last_returned_at)}`,
                },
                metric: { value: String(r.returns), label: r.returns === 1 ? 'return' : 'returns', tone: 'warn', icon: 'mdi-undo-variant' },
                brief: `Returned ${r.returns}×`,
            }
        case 'deleted':
            return {
                from: created,
                to: {
                    label: 'Deleted',
                    value: fmtDateTime(r.deleted_at),
                    sub: [byName(r.deleted_by), r.station_at_deletion ? `at ${stationName(r.station_at_deletion)}` : ''].filter(Boolean).join(', '),
                },
                metric: { value: dur(minutesSince(r.deleted_at)), label: 'since deleted', tone: 'muted' },
                brief: `Deleted ${fmtDateTime(r.deleted_at)}${r.deleted_by?.name ? ` by ${r.deleted_by.name}` : ''}`,
            }
        case 'process': {
            const status = {
                completed: { value: 'Completed', icon: 'mdi-check-circle', tone: 'good' },
                overdue: { value: 'Overdue', icon: 'mdi-alert', tone: 'warn' },
                in_process: { value: 'In-process', icon: 'mdi-progress-clock', tone: '' },
            }[r.status] || { value: r.status, tone: '' }
            return {
                from: created,
                to: r.status === 'completed' ? { label: 'Finished at', value: r.current_step?.name || '—' } : station,
                metric: {
                    ...status,
                    label: r.status === 'overdue' ? `${dur(r.overdue_minutes)} past limit` : r.status === 'completed' ? 'finalized' : `waiting ${dur(r.waiting_minutes)}`,
                },
                brief: r.status === 'completed' ? 'Finalized' : `At ${r.current_step ? stationName(r.current_step) : 'no station'}`,
            }
        }
        default: // in_process
            return {
                from: { label: 'Arrived at station', value: fmtDateTime(r.entered_at) },
                to: station,
                metric: {
                    value: dur(r.waiting_minutes),
                    label: r.sla_minutes ? `waiting, limit ${dur(r.sla_minutes)}` : 'waiting',
                    tone: r.overdue_minutes > 0 ? 'warn' : '',
                    icon: r.overdue_minutes > 0 ? 'mdi-alert' : null,
                },
                brief: `At ${r.current_step ? stationName(r.current_step) : 'no station'}`,
            }
    }
}

// Short-lived memory cache plus a persistent mirror so reopening the same
// box — even after reload — paints instantly, then revalidates silently.
const cache = new Map()
const TTL_MS = 60_000

export async function fetchSummaryRows(api, category, query, processId, { silentRefresh = true } = {}) {
    const params = { ...query }
    if (category === 'process') params.process_id = processId
    // One office's list, from a dashboard chart (overdue, on time, returns).
    else if (BY_OFFICE.includes(category) && processId != null) params.at_office = processId
    const base = summaryApiBase()
    // Per user: an office admin's rows differ by office.
    const key = `${useAuth().user.value?.id ?? ''}|${category}|${JSON.stringify(params)}`
    const hit = cache.get(key)
    if (hit && Date.now() - hit.at < TTL_MS) return hit.data
    const storeKey = `${CacheKeys.summary}:rows:${key}`
    const stored = readCache(storeKey)
    if (stored != null) {
        cache.set(key, { at: Date.now(), data: stored })
        // Revalidate in the background when the stored copy is stale; the
        // caller already painted, so don't make it wait.
        if (silentRefresh) {
            api.get(`${base}/${category}`, { params })
                .then((res) => {
                    const fresh = { rows: res.data.rows || [], count: res.data.count ?? (res.data.rows || []).length }
                    cache.set(key, { at: Date.now(), data: fresh })
                    writeCache(storeKey, fresh)
                })
                .catch(() => { /* keep the painted copy */ });
        }
        return stored
    }
    const res = await api.get(`${base}/${category}`, { params })
    const data = { rows: res.data.rows || [], count: res.data.count ?? (res.data.rows || []).length }
    cache.set(key, { at: Date.now(), data })
    writeCache(storeKey, data)
    return data
}
