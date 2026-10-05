import { ref } from "vue";
import { useApi } from "@/composables/useApi";

// Shared count for the sidebar APPROVALS badge: required requirements still
// waiting to be validated across the user's approval inbox. Module-level so
// the sidebar and the Approvals page read and refresh the same value.
const pendingRequirements = ref(0);
let inFlight = null;

export function useApprovalBadge() {
    const { api } = useApi();

    async function refresh() {
        // Collapse overlapping calls (route change + timer + page action).
        if (inFlight) return inFlight;
        inFlight = api
            .get("/api/approvals/count")
            .then((res) => {
                pendingRequirements.value = Number(res.data?.pending_requirements ?? 0);
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
    }

    return { pendingRequirements, refresh, clear };
}
