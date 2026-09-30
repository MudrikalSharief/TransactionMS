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

// Same buckets as the inline fmtMinutes in the detail pages (kept in sync
// so SLA values stay exactly consistent with the previous implementation).
export function formatMinutes(v) {
    const n = Number(v);
    if (!Number.isFinite(n)) return '—';
    if (n < 60) return `${n}m`;
    const h = Math.floor(n / 60);
    const m = n % 60;
    if (h < 48) return m ? `${h}h ${m}m` : `${h}h`;
    const d = Math.floor(h / 24);
    const rh = h % 24;
    return rh ? `${d}d ${rh}h` : `${d}d`;
}

const ACTION_CONFIGS = {
    create: { label: 'Created', icon: 'mdi-file-plus-outline', color: 'grey-darken-1' },
    submit: { label: 'Submitted', icon: 'mdi-send-outline', color: 'blue-darken-2' },
    approve: { label: 'Approved', icon: 'mdi-check', color: 'green-darken-2' },
    finalize: { label: 'Finalized', icon: 'mdi-check-circle-outline', color: 'green-darken-3' },
    return: { label: 'Returned', icon: 'mdi-rotate-ccw', color: 'amber-darken-3' },
    reject: { label: 'Rejected', icon: 'mdi-close', color: 'red-darken-2' },
    forward: { label: 'Forwarded', icon: 'mdi-arrow-right', color: 'blue-darken-1' },
    reassign: { label: 'Reassigned', icon: 'mdi-account-cog-outline', color: 'purple-darken-2' },
    cancel: { label: 'Cancelled', icon: 'mdi-cancel', color: 'grey-darken-1' },
    reopen: { label: 'Reopened', icon: 'mdi-restore', color: 'teal-darken-2' },
    complete: { label: 'Completed', icon: 'mdi-flag-checkered', color: 'green-darken-2' },
    revisit: { label: 'Revisited', icon: 'mdi-history', color: 'blue-grey-darken-1' },
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
    if (run?.is_breached) return { label: 'Overdue', color: 'error', dot: 'bg-error' };
    return { label: 'On time', color: 'success', dot: 'bg-success' };
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

function stepNo(step) {
    return step?.order_number ?? null;
}

// "HR → Accounting" (+ "Step 2 → Step 3" caption). Create events with no
// source render as "Created → HR" instead of a raw dash.
export function movementOf(run) {
    const fromOffice = officeOf(run?.from_step);
    const toOffice = officeOf(run?.to_step);
    const isCreate = String(run?.action_code || '').toLowerCase() === 'create';

    let main;
    if (isCreate || !fromOffice) {
        main = toOffice ? { from: 'Created', to: toOffice } : { from: 'Created', to: null };
    } else {
        main = { from: fromOffice, to: toOffice || '—' };
    }

    const fromN = stepNo(run?.from_step);
    const toN = stepNo(run?.to_step);
    let sub = null;
    if (fromN != null && toN != null && !isCreate) sub = `Step ${fromN} → Step ${toN}`;
    else if (toN != null) sub = `Step ${toN}`;

    return { ...main, sub };
}

export function stepLabelOf(run, fallbackIndex) {
    const n = stepNo(run?.to_step);
    return n ?? fallbackIndex;
}

export function detailStepText(step) {
    if (!step) return '—';
    const n = stepNo(step);
    const office = officeOf(step);
    if (n != null && office) return `Step ${n} · ${office}`;
    if (office) return office;
    return step?.code || step?.name || '—';
}

export function userRoleText(user) {
    const roles = (user?.roles || []).map((r) => r?.name || r?.code).filter(Boolean);
    return roles.length ? roles.join(' · ') : null;
}
