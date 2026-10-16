import { ref } from "vue";
import { useApi } from "@/composables/useApi";

// Approval inbox: open transactions at a station the user works on, whose
// checklist mirrors the previous station's requirements. Validating and
// proceeding happen in ApprovalProceedDialog via the transaction endpoints.
export function useApprovals() {
    const { api } = useApi();

    const items = ref([]);
    const loading = ref(true);
    const meta = ref({ total: 0, page: 1, lastPage: 1, perPage: 25 });

    // Silent background refreshes (smart-poll) must not flash the loader
    // or the Refresh button spinner — same convention as the transaction
    // list composables. Server-paginated: only 25 full rows per page cross
    // the wire (approvals need the full checklist payload per row).
    async function fetchAll({ silent = false, q = "", page = 1, per_page = 25 } = {}) {
        if (!silent) loading.value = true;
        try {
            const params = { page, per_page };
            if (String(q || "").trim()) params.q = String(q).trim();
            const res = await api.get("/api/approvals", { params });
            const raw = res.data;
            const rows = Array.isArray(raw?.data) ? raw.data : Array.isArray(raw) ? raw : [];
            items.value = rows;
            if (raw && typeof raw === "object" && (raw.meta || raw.total !== undefined)) {
                meta.value = {
                    total: raw.meta?.total ?? raw.total ?? rows.length,
                    page: raw.meta?.current_page ?? 1,
                    lastPage: raw.meta?.last_page ?? 1,
                    perPage: raw.meta?.per_page ?? rows.length ?? 25,
                };
            } else {
                meta.value = { total: rows.length, page: 1, lastPage: 1, perPage: rows.length || 25 };
            }
        } finally {
            if (!silent) loading.value = false;
        }
        return items.value;
    }

    return { items, loading, meta, fetchAll };
}
