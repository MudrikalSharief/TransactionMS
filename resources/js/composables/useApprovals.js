import { ref } from "vue";
import { useApi } from "@/composables/useApi";

// Approval inbox: open transactions at a station the user works on, whose
// checklist mirrors the previous station's requirements. Validating an item
// is a checklist tick; the endpoint returns the refreshed transaction so the
// page can swap a single row instead of reloading the whole inbox.
export function useApprovals() {
    const { api } = useApi();

    const items = ref([]);
    const loading = ref(true);

    async function fetchAll() {
        loading.value = true;
        try {
            const res = await api.get("/api/approvals");
            items.value = res.data.data ?? res.data;
        } finally {
            loading.value = false;
        }
        return items.value;
    }

    async function setValidated(transactionId, checklistItemId, validated) {
        const url = `/api/transactions/${transactionId}/checklist/${checklistItemId}/check`;
        const res = validated ? await api.post(url) : await api.delete(url);
        return res.data.data ?? res.data;
    }

    return { items, loading, fetchAll, setValidated };
}
