// Receipt eligibility follows the destination station, not the latest departure.
export function latestReceivedRunsByStep(runs = []) {
    const latest = new Map();
    for (const run of runs) {
        if (!run.received_at || !run.received_by || run.to_step?.id == null) continue;
        const key = String(run.to_step.id);
        const previous = latest.get(key);
        const time = Date.parse(run.received_at);
        if (!Number.isFinite(time)) continue;
        const previousTime = previous ? Date.parse(previous.received_at) : -Infinity;
        if (time > previousTime || (time === previousTime && Number(run.id || 0) > Number(previous.id || 0))) {
            latest.set(key, run);
        }
    }
    return latest;
}
