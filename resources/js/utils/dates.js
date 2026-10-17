// Pretty Manila-time dates: "9/26/26 · 3:45 PM" (no seconds).
const pretty = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Manila',
    month: 'numeric',
    day: 'numeric',
    year: '2-digit',
    hour: 'numeric',
    minute: '2-digit',
    hour12: true,
});

export function fmtDateTime(v) {
    if (!v) return '—';
    const d = new Date(v);
    if (Number.isNaN(d.getTime())) return '—';
    // "9/26/26, 3:45 PM" -> "9/26/26 · 3:45 PM"
    return pretty.format(d).replace(/, (\d{1,2}:)/, ' · $1');
}
