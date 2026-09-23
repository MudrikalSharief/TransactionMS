import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, CacheKeys, slimTx } from "@/composables/useCache";

export function useMyTransactions() {
    const { api } = useApi();

    const items = ref([]);
    const loading = ref(true);

    // Cache-first: cached rows are available instantly, then refreshed.
    // Loading is raised on every non-silent fetch so the TableLoader
    // takes priority over the table; pass { silent: true } for
    // invisible background refreshes (dashboard warm loads).
    async function fetchAll({ silent = false } = {}) {
        const cached = readCache(CacheKeys.myTransactions);
        if (cached) items.value = cached;
        if (!silent) loading.value = true;
        try {
            const res = await api.get("/api/transactions");
            items.value = res.data.data ?? res.data;
            writeCache(CacheKeys.myTransactions, (items.value || []).map(slimTx));
        } finally {
            if (!silent) loading.value = false;
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
        fetchAll,
        getOne,
        execute,
        gotoStation,
        finalize,
        checkRequirement,
        uncheckRequirement,
        uploadAttachment,
    };
}
