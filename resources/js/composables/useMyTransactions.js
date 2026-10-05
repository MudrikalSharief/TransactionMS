import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { readCache, writeCache, CacheKeys, scopedKey, storedUserId, slimTx } from "@/composables/useCache";

export function useMyTransactions() {
    const { api } = useApi();
    const { user } = useAuth();
    const key = () => scopedKey(CacheKeys.myTransactions, user.value?.id ?? storedUserId());

    const items = ref([]);
    const loading = ref(true);
    const meta = ref({ total: 0, page: 1, lastPage: 1, perPage: 25 });

    function applyPayload(res) {
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
        return items.value;
    }

    async function fetchAll({ silent = false, q = "", page = 1, per_page = 25 } = {}) {
        const isDefault = !String(q || "").trim() && Number(page) === 1;
        let painted = false;
        if (isDefault) {
            const cached = readCache(key());
            if (cached != null) {
                items.value = cached;
                meta.value = { total: cached.length, page: 1, lastPage: 1, perPage: per_page };
                loading.value = false; // painted: drop the loader, refresh silently
                painted = true;
            }
        }
        const quiet = silent || painted;
        if (!quiet) loading.value = true;
        try {
            const params = { page, per_page };
            if (String(q || "").trim()) params.q = String(q).trim();
            const res = await api.get("/api/transactions", { params });
            applyPayload(res);
            if (isDefault) writeCache(key(), (items.value || []).map(slimTx));
        } finally {
            if (!quiet) loading.value = false;
        }
        return items.value;
    }

    async function getOne(id) {
        const res = await api.get(`/api/transactions/${id}`);
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function execute(id, payload) {
        const res = await api.post(`/api/transactions/${id}/execute`, payload);
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function receive(id) {
        const res = await api.post(`/api/transactions/${id}/receive`);
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function gotoStation(id, payload) {
        const res = await api.post(`/api/transactions/${id}/goto`, payload);
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function finalize(id) {
        const res = await api.post(`/api/transactions/${id}/finalize`);
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function checkRequirement(transactionId, requirementId) {
        const res = await api.post(
            `/api/transactions/${transactionId}/requirements/${requirementId}/check`,
        );
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function uncheckRequirement(transactionId, requirementId) {
        const res = await api.delete(
            `/api/transactions/${transactionId}/requirements/${requirementId}/check`,
        );
        return {
            tx: res.data.data ?? res.data,
            meta: res.data.meta ?? {},
        };
    }

    async function uploadAttachment(transactionId, file, requirementId = null) {
        const fd = new FormData();
        fd.append("file", file);
        if (requirementId) fd.append("requirement_definition_id", String(requirementId));
        const res = await api.post(`/api/transactions/${transactionId}/attachments`, fd);
        return res.data.data ?? res.data;
    }

    return {
        items,
        loading,
        meta,
        fetchAll,
        getOne,
        execute,
        receive,
        gotoStation,
        finalize,
        checkRequirement,
        uncheckRequirement,
        uploadAttachment,
    };
}
