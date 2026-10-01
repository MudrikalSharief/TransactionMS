import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, invalidatePrefix, CacheKeys } from "@/composables/useCache";

export function useWorkflows() {
    const { api } = useApi();
    const defs = ref([]);
    const loading = ref(true);

    async function fetchDefinitions(transactionTypeId, { silent = false } = {}) {
        const key = transactionTypeId ? `${CacheKeys.workflows}:${transactionTypeId}` : CacheKeys.workflows;
        const cached = readCache(key);
        const quiet = silent || cached != null;
        if (cached != null) {
            defs.value = cached;
            loading.value = false; // painted: drop the loader, refresh silently
        }
        if (!quiet) loading.value = true;
        try {
            const res = await api.get("/api/admin/workflow-definitions", {
                params: transactionTypeId
                    ? { transaction_type_id: transactionTypeId }
                    : {},
            });
            defs.value = res.data.data ?? res.data;
            writeCache(key, defs.value);
        } finally {
            if (!quiet) loading.value = false;
        }
    }

    // Any structural change busts all cached definition lists.
    const touch = () => invalidatePrefix(CacheKeys.workflows);

    async function createDraft(payload) {
        const res = await api.post("/api/admin/workflow-definitions", payload);
        touch();
        return res.data.data ?? res.data;
    }

    async function publish(defId, payload = {}) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/publish`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function deleteDefinition(defId) {
        await api.delete(`/api/admin/workflow-definitions/${defId}`);
        touch();
    }

    async function makeLive(defId) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/make-live`,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function saveAs(defId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/save-as`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function addStep(defId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/steps`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function updateStep(defId, stepId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${defId}/steps/${stepId}`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function deleteStep(defId, stepId) {
        await api.delete(
            `/api/admin/workflow-definitions/${defId}/steps/${stepId}`,
        );
        touch();
    }

    async function addRoute(defId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/routes`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function updateRoute(defId, routeId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${defId}/routes/${routeId}`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function deleteRoute(defId, routeId) {
        const res = await api.delete(
            `/api/admin/workflow-definitions/${defId}/routes/${routeId}`,
        );
        touch();
        return res;
    }

    return {
        defs,
        loading,
        fetchDefinitions,
        createDraft,
        publish,
        makeLive,
        saveAs,
        deleteDefinition,
        addStep,
        updateStep,
        deleteStep,
        addRoute,
        updateRoute,
        deleteRoute,
    };
}
