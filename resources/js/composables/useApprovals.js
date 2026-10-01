import { ref } from "vue";
import { useApi } from "@/composables/useApi";

// Approval inbox: open transactions at a station the user works on, whose
// checklist mirrors the previous station's requirements. Validating and
// proceeding happen in ApprovalProceedDialog via the transaction endpoints.
export function useApprovals() {
    const { api } = useApi();

    const items = ref([]);
    const loading = ref(true);

    // Silent background refreshes (smart-poll) must not flash the loader
    // or the Refresh button spinner — same convention as the transaction
    // list composables.
    async function fetchAll({ silent = false } = {}) {
        if (!silent) loading.value = true;
        try {
            const res = await api.get("/api/approvals");
            items.value = res.data.data ?? res.data;
        } finally {
            if (!silent) loading.value = false;
        }
        return items.value;
    }

    return { items, loading, fetchAll };
}
