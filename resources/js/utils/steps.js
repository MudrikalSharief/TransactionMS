export function fmtStepOfficeRoles(step) {
    if (!step) return '—';
    const n = step?.order_number ?? '—';
    const stage = (step?.stage || '').trim() || '—';
    return `(Step ${n}) ${stage}`;
}

// Creation row didn't come from anywhere — blank the From step cell.
// From user + Released At still show the creator/time (separate columns).
export function fmtFromStep(item) {
    if (!item || item.action_code === 'create') return '—';
    return fmtStepOfficeRoles(item.from_step);
}
