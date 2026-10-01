import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, invalidateCache, CacheKeys } from "@/composables/useCache";

// Shared count for the sidebar APPROVALS badge: required requirements still
// waiting to be validated across the user's approval inbox. Module-level so
// the sidebar and the Approvals page read and refresh the same value.
// Paints the last known count instantly, then revalidates silently.
const pendingRequirements = ref(0);
let inFlight = null;
let painted = false;

export function useApprovalBadge() {
    const { api } = useApi();

    function paintCached() {
        if (painted) return;
        painted = true;
        try {
            const cached = readCache(CacheKeys.approvalCount);
            if (cached != null) pendingRequirements.value = Number(cached ?? 0);
        } catch { /* ignore */ }
    }
    paintCached();

    async function refresh() {
        // Collapse overlapping calls (route change + timer + page action).
        if (inFlight) return inFlight;
        inFlight = api
            .get("/api/approvals/count")
            .then((res) => {
                pendingRequirements.value = Number(res.data?.pending_requirements ?? 0);
                writeCache(CacheKeys.approvalCount, pendingRequirements.value);
            })
            .catch(() => {
                // No access / logged out / offline: just hide the badge.
                pendingRequirements.value = 0;
            })
            .finally(() => {
                inFlight = null;
            });
        return inFlight;
    }

    function clear() {
        pendingRequirements.value = 0;
        invalidateCache(CacheKeys.approvalCount);
    }

    return { pendingRequirements, refresh, clear };
}
