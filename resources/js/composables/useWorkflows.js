import { ref } from "vue";
import { useApi } from "@/composables/useApi";

export function useWorkflows() {
    const { api } = useApi();
    const defs = ref([]);
    const loading = ref(true);

    async function fetchDefinitions(transactionTypeId) {
        loading.value = true;
        try {
            const res = await api.get("/api/admin/workflow-definitions", {
                params: transactionTypeId
                    ? { transaction_type_id: transactionTypeId }
                    : {},
            });
            defs.value = res.data.data ?? res.data;
        } finally {
            loading.value = false;
        }
    }

    async function createDraft(payload) {
        const res = await api.post("/api/admin/workflow-definitions", payload);
        return res.data.data ?? res.data;
    }

    async function publish(defId, payload = {}) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/publish`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function deleteDefinition(defId) {
        await api.delete(`/api/admin/workflow-definitions/${defId}`);
    }

    async function addStep(defId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/steps`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function updateStep(defId, stepId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${defId}/steps/${stepId}`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function deleteStep(defId, stepId) {
        await api.delete(
            `/api/admin/workflow-definitions/${defId}/steps/${stepId}`,
        );
    }

    async function addRoute(defId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${defId}/routes`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function updateRoute(defId, routeId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${defId}/routes/${routeId}`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function deleteRoute(defId, routeId) {
        return api.delete(
            `/api/admin/workflow-definitions/${defId}/routes/${routeId}`,
        );
    }

    return {
        defs,
        loading,
        fetchDefinitions,
        createDraft,
        publish,
        deleteDefinition,
        addStep,
        updateStep,
        deleteStep,
        addRoute,
        updateRoute,
        deleteRoute,
    };
}
