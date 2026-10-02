import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { readCache, writeCache, invalidateCache, CacheKeys, scopedKey } from "@/composables/useCache";

// Shared count for the sidebar APPROVALS badge: required requirements still
// waiting to be validated across the user's approval inbox. Module-level so
// the sidebar and the Approvals page read and refresh the same value.
// Paints the last known count instantly, then revalidates silently.
const pendingRequirements = ref(0);
let inFlight = null;
let painted = false;
let paintedFor = null;

export function useApprovalBadge() {
    const { api } = useApi();
    const { user } = useAuth();
    const key = () => scopedKey(CacheKeys.approvalCount, user.value?.id);

    function paintCached() {
        const uid = user.value?.id ?? null;
        if (painted && paintedFor === uid) return;
        painted = true;
        paintedFor = uid;
        try {
            const cached = readCache(key());
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
                writeCache(key(), pendingRequirements.value);
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
        invalidateCache(key());
    }

    return { pendingRequirements, refresh, clear };
}
