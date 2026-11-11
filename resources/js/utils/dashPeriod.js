// The dashboards' Period filter (admin Dashboard and staff Home): All time,
// This week (Mon–Sun) or one of the last 12 months. The stat cards send the
// value to the server ('all' | 'this_week' | 'YYYY-MM'); the per-process
// graphs group their rows by it here, in the browser's local calendar.

const DAY_MS = 86400000
// All time: one bar group per month, or per quarter past this many months.
const MAX_MONTH_GROUPS = 12

export const monthValue = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`

// The last 12 months, newest first.
export function monthOptions(now = new Date()) {
    return Array.from({ length: 12 }, (_, i) => {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
        return { title: d.toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }), value: monthValue(d) }
    })
}

export function periodOptions(now = new Date()) {
    return [{ title: 'All time', value: 'all' }, { title: 'This week', value: 'this_week' }, ...monthOptions(now)]
}

export function periodLabel(value) {
    return periodOptions().find((o) => o.value === value)?.title || value
}

const md = (d) => d.toLocaleDateString('en-PH', { month: 'short', day: 'numeric' })

function rangeLabel(start, endExclusive) {
    const last = new Date(endExclusive.getTime() - DAY_MS)
    if (last.getTime() <= start.getTime()) return md(start)
    return start.getMonth() === last.getMonth() ? `${md(start)}–${last.getDate()}` : `${md(start)}–${md(last)}`
}

function thisMonday(now) {
    const d = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    d.setDate(d.getDate() - ((d.getDay() + 6) % 7))
    return d
}

// Start of the period (null = all time), for loading only what it needs.
export function periodStart(value, now = new Date()) {
    if (!value || value === 'all') return null
    if (value === 'this_week') return thisMonday(now)
    const [y, m] = value.split('-').map(Number)
    return new Date(y, m - 1, 1)
}

// Bar groups for the period, never past today:
//   this week -> one per day (Mon, Tue, …)
//   a month   -> its calendar weeks (1–7, 8–14, …)
//   all time  -> one per month from the oldest row (per quarter when long)
export function periodBuckets(value, { oldest = null, now = new Date() } = {}) {
    const endOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1)
    const out = []

    if (value === 'this_week') {
        for (let start = thisMonday(now); start < endOfToday;) {
            const end = new Date(start.getFullYear(), start.getMonth(), start.getDate() + 1)
            out.push({ start, end, label: `${start.toLocaleDateString('en-PH', { weekday: 'short' })} ${start.getDate()}` })
            start = end
        }
        return out
    }

    if (value && value !== 'all') {
        const [y, m] = value.split('-').map(Number)
        const monthEnd = new Date(y, m, 1)
        for (let start = new Date(y, m - 1, 1); start < monthEnd && start < endOfToday;) {
            const end = new Date(Math.min(start.getTime() + 7 * DAY_MS, monthEnd.getTime()))
            out.push({ start, end, label: rangeLabel(start, end) })
            start = end
        }
        return out
    }

    const first = oldest ? new Date(oldest) : now
    const from = new Date(first.getFullYear(), first.getMonth(), 1)
    const months = (now.getFullYear() - from.getFullYear()) * 12 + now.getMonth() - from.getMonth() + 1
    const step = months > MAX_MONTH_GROUPS ? 3 : 1
    // Quarters start on Jan/Apr/Jul/Oct so the labels read naturally.
    const start0 = step === 3 ? new Date(from.getFullYear(), from.getMonth() - (from.getMonth() % 3), 1) : from
    for (let start = start0; start < endOfToday;) {
        const end = new Date(start.getFullYear(), start.getMonth() + step, 1)
        const label = step === 3
            ? `Q${Math.floor(start.getMonth() / 3) + 1} ${start.getFullYear()}`
            : start.toLocaleDateString('en-PH', { month: 'short', year: months > 1 && start.getMonth() === 0 ? 'numeric' : undefined })
        out.push({ start, end, label })
        start = end
    }
    return out
}

// Index of the bar group holding this timestamp, or -1.
export function bucketIndexOf(buckets, iso) {
    if (!iso) return -1
    const t = new Date(iso).getTime()
    return buckets.findIndex((b) => t >= b.start.getTime() && t < b.end.getTime())
}

// Grouping word for chart labels ("per day", "per week", …).
export function bucketUnit(value, buckets) {
    if (value === 'this_week') return 'day'
    if (value && value !== 'all') return 'week'
    const b = buckets[0]
    const span = b ? (b.end.getFullYear() - b.start.getFullYear()) * 12 + b.end.getMonth() - b.start.getMonth() : 1
    return span === 3 ? 'quarter' : 'month'
}
