// Shared helpers for the Transaction History redesign.
// Pure display mappings over the existing TransactionStepRunResource payload —
// no backend or SLA-calculation changes. Uses MDI icon names (no new deps).

// "Sep 26, 2026 · 5:05 PM" in Manila time (existing fmtDateTime renders 9/26/26).
const historyDateFmt = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Manila',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
});

export function formatHistoryDate(v) {
    if (!v) return '—';
    const d = new Date(v);
    if (Number.isNaN(d.getTime())) return '—';
    // "Sep 26, 2026, 5:05 PM" -> "Sep 26, 2026 · 5:05 PM"
    return historyDateFmt.format(d).replace(/, (\d{1,2}:)/, ' · $1');
}

// Compact row timestamp: month, day, time — no year.
const historyDateShortFmt = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Manila',
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
});

export function formatHistoryDateShort(v) {
    if (!v) return '—';
    const d = new Date(v);
    if (Number.isNaN(d.getTime())) return '—';
    return historyDateShortFmt.format(d).replace(/, (\d{1,2}:)/, ' · $1');
}

// Working-minute formatter: hours, then 8-hour working days after 48 hours.
export function formatMinutes(v) {
    const n = Number(v);
    if (!Number.isFinite(n)) return '—';
    if (n < 60) return `${n}m`;
    const h = Math.floor(n / 60);
    const m = n % 60;
    if (h < 48) return m ? `${h}h ${m}m` : `${h}h`;
    // A "day" in these durations is an 8-hour working day.
    const d = Math.floor(n / 480);
    const rh = Math.floor((n % 480) / 60);
    const rm = n % 60;
    return [d ? `${d}d` : '', rh ? `${rh}h` : '', rm ? `${rm}m` : '']
        .filter(Boolean)
        .join(' ');
}

// Calendar-minute formatter for pending time: real elapsed time, 24-hour days.
export function formatCalendarMinutes(v) {
    const n = Number(v);
    if (!Number.isFinite(n)) return '—';
    if (n < 60) return `${n}m`;
    const h = Math.floor(n / 60);
    const m = n % 60;
    if (h < 24) return m ? `${h}h ${m}m` : `${h}h`;
    const d = Math.floor(h / 24);
    const rh = h % 24;
    return [d ? `${d}d` : '', rh ? `${rh}h` : '', m ? `${m}m` : '']
        .filter(Boolean)
        .join(' ');
}

const ACTION_CONFIGS = {
    create: { label: 'Created', icon: 'mdi-file-plus-outline', color: 'grey-darken-1' },
    submit: { label: 'Submitted', icon: 'mdi-send-outline', color: 'blue-darken-2' },
    approve: { label: 'Approved', icon: 'mdi-check', color: 'green-darken-2' },
    finalize: { label: 'Finalized', icon: 'mdi-check-circle-outline', color: 'green-darken-3' },
    return: { label: 'Returned', icon: 'mdi-rotate-ccw', color: 'amber-darken-3' },
    resend: { label: 'Resent', icon: 'mdi-send-circle-outline', color: 'blue-darken-2' },
    reject: { label: 'Rejected', icon: 'mdi-close', color: 'red-darken-2' },
    forward: { label: 'Forwarded', icon: 'mdi-arrow-right', color: 'blue-darken-1' },
    reassign: { label: 'Reassigned', icon: 'mdi-account-cog-outline', color: 'purple-darken-2' },
    cancel: { label: 'Cancelled', icon: 'mdi-cancel', color: 'grey-darken-1' },
    reopen: { label: 'Reopened', icon: 'mdi-restore', color: 'teal-darken-2' },
    complete: { label: 'Completed', icon: 'mdi-flag-checkered', color: 'green-darken-2' },
    revisit: { label: 'Revisited', icon: 'mdi-history', color: 'blue-grey-darken-1' },
    return_missing: { label: 'Returned — missing requirements', icon: 'mdi-file-alert-outline', color: 'deep-orange-darken-2' },
};

function titleCaseAction(code) {
    const s = String(code || '').replace(/[_-]+/g, ' ').trim();
    if (!s) return 'Action';
    return s.charAt(0).toUpperCase() + s.slice(1);
}

export function getActionConfig(actionCode) {
    const key = String(actionCode || '').toLowerCase();
    if (ACTION_CONFIGS[key]) return { code: key, ...ACTION_CONFIGS[key] };
    return { code: key || 'unknown', label: titleCaseAction(key), icon: 'mdi-swap-horizontal', color: 'grey-darken-1' };
}

export function getStatusConfig(run) {
    if (!run?.received_at) return { label: 'Pending', color: 'warning', dot: 'bg-warning' };

    const est = Number(run?.duration_estimated_minutes ?? run?.sla_minutes_snapshot ?? 0);
    const working = Number(run?.working_minutes ?? 0);
    const breached = run?.is_working_breached === true || (est > 0 && working > est);

    return breached
        ? { label: 'Overdue', color: 'error', dot: 'bg-error' }
        : { label: 'On time', color: 'success', dot: 'bg-success' };
}

export function getUserInitials(name) {
    const parts = String(name || '').trim().split(/\s+/).filter(Boolean);
    if (!parts.length) return '—';
    if (parts.length === 1) return parts[0].charAt(0).toUpperCase();
    return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
}

// Primary timestamp for the main row: when the action completed/was received.
export function mainTimestamp(run) {
    return run?.received_at || run?.released_at || run?.performed_at || null;
}

function officeOf(step) {
    return step?.office?.name || step?.stage || step?.name || null;
}

// Office code for the Movement column (e.g. "GSO → OCT"). Falls back to the
// step code when a legacy/end-user station has no resolved office.
function officeCodeOf(step) {
    const officeCode = String(step?.office?.code || '').trim();
    if (officeCode) return officeCode;
    return String(step?.code || step?.stage || step?.name || '').trim() || null;
}

function stepNo(step) {
    return step?.order_number ?? null;
}

export function isCreateRun(run) {
    return String(run?.action_code || '').toLowerCase() === 'create';
}

// Office-code movement only: "GSO → OCT". Create events with no source
// render as "Created → GSO".
export function movementOf(run) {
    const fromOffice = officeCodeOf(run?.from_step);
    const toOffice = officeCodeOf(run?.to_step);
    const isCreate = isCreateRun(run);

    if (isCreate || !fromOffice) {
        return { from: 'Created', to: toOffice || null };
    }

    return { from: fromOffice, to: toOffice || '—' };
}

export function stepLabelOf(run, fallbackIndex) {
    // Badge = the station that performed the run (its history), not the
    // destination. Creates happen before the first station, so they show
    // 0 instead of claiming step 1.
    if (isCreateRun(run)) return 0;
    return stepNo(run?.from_step) ?? stepNo(run?.to_step) ?? fallbackIndex;
}

export function detailStepText(step) {
    if (!step) return '—';
    const n = stepNo(step);
    const office = officeOf(step);
    if (n != null && office) return `Step ${n} · ${office}`;
    if (office) return office;
    return step?.code || step?.name || '—';
}

export function userPositionText(user) {
    return String(user?.position || '').trim() || null;
}
