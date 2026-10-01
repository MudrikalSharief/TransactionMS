import { onMounted, onUnmounted } from "vue";
import { useApi } from "@/composables/useApi";

const POLL_INTERVAL_MS = 20000;
const POLL_JITTER_MS = 3000;
const MAX_BACKOFF_MS = 60000;

// Smart 20s poll: hits the tiny /api/transactions/version endpoint and only
// runs the full silent refresh when the version stamp actually changed.
// Never touches window scroll, search text, pagination, or dialog state —
// callers must use silent fetches ({ silent: true }) inside onChanged so no
// loader/spinner flashes and the page never reloads.
export function useSmartPoll(onChanged, { interval = POLL_INTERVAL_MS, enabled = null } = {}) {
    const { api } = useApi();
    // Bad-network adaptation: stretch the version-check interval on 2g /
    // saveData so weak devices + poor links aren't woken every 20s.
    try {
        const conn = navigator.connection;
        if (conn && (conn.saveData || ["slow-2g", "2g"].includes(conn.effectiveType))) {
            interval = Math.max(interval, 60000);
        }
    } catch { /* ignore */ }

    let timer = null;
    let stopped = false;
    let inFlight = false;
    let backoffMs = 0;
    let lastVersion = null;
    let baselineSet = false;

    const isEnabled = () => (typeof enabled === "function" ? enabled() : true);

    function schedule(delay = null) {
        if (stopped) return;
        const jitter = Math.random() * POLL_JITTER_MS;
        const wait = delay ?? interval + jitter + backoffMs;
        timer = setTimeout(tick, wait);
    }

    async function tick() {
        if (stopped) return;
        // Skip quietly when the tab isn't visible or we're offline — the
        // version check resumes on the next tick / visibility return.
        if (document.hidden || !navigator.onLine || !isEnabled()) {
            schedule();
            return;
        }
        if (inFlight) {
            schedule();
            return;
        }
        inFlight = true;
        try {
            const res = await api.get("/api/transactions/version");
            const v = res.data?.version ?? null;
            if (!baselineSet) {
                // First successful check after mount only sets the baseline;
                // the page just loaded fresh data, so nothing to refresh yet.
                lastVersion = v;
                baselineSet = true;
            } else if (v !== null && v !== lastVersion) {
                lastVersion = v;
                await onChanged();
            }
            backoffMs = 0;
        } catch {
            // Offline / session hiccup: back off instead of hammering.
            backoffMs = Math.min(MAX_BACKOFF_MS, (backoffMs || interval / 2) * 1.5);
        } finally {
            inFlight = false;
            schedule();
        }
    }

    function handleVisibility() {
        // Tab came back: check soon (with a small delay so auth/network
        // settles) instead of waiting out the full 20s stale window.
        if (!document.hidden && !stopped) {
            if (timer) clearTimeout(timer);
            timer = setTimeout(tick, 2000);
        }
    }

    onMounted(() => {
        stopped = false;
        document.addEventListener("visibilitychange", handleVisibility);
        window.addEventListener("online", handleVisibility);
        schedule();
    });

    onUnmounted(() => {
        stopped = true;
        if (timer) clearTimeout(timer);
        document.removeEventListener("visibilitychange", handleVisibility);
        window.removeEventListener("online", handleVisibility);
    });

    return { resync: () => { lastVersion = null; baselineSet = false; } };
}
