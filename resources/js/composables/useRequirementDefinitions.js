import { ref } from "vue";
import { useApi } from "@/composables/useApi";

export function useRequirementDefinitions() {
    const { api } = useApi();
    const items = ref([]);
    const loading = ref(true);

    async function fetchAll(workflowDefinitionId) {
        loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements`,
            );
            items.value = res.data.data ?? res.data;
        } finally {
            loading.value = false;
        }
    }

    async function create(workflowDefinitionId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function update(workflowDefinitionId, requirementId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}`,
            payload,
        );
        return res.data.data ?? res.data;
    }

    async function destroy(workflowDefinitionId, requirementId) {
        await api.delete(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}`,
        );
    }

    async function syncSteps(workflowDefinitionId, requirementId, payload) {
        await api.post(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}/steps/sync`,
            payload,
        );
    }

    return { items, loading, fetchAll, create, update, destroy, syncSteps };
}
