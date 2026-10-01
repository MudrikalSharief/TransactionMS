import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, invalidatePrefix, CacheKeys } from "@/composables/useCache";

export function useRequirementDefinitions() {
    const { api } = useApi();
    const items = ref([]);
    const loading = ref(true);
    const touch = () => invalidatePrefix(CacheKeys.requirementDefs);

    async function fetchAll(workflowDefinitionId, { silent = false } = {}) {
        const key = `${CacheKeys.requirementDefs}:${workflowDefinitionId}`;
        const cached = readCache(key);
        const quiet = silent || cached != null;
        if (cached != null) {
            items.value = cached;
            loading.value = false; // painted: drop the loader, refresh silently
        }
        if (!quiet) loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements`,
            );
            items.value = res.data.data ?? res.data;
            writeCache(key, items.value);
        } finally {
            if (!quiet) loading.value = false;
        }
    }

    async function create(workflowDefinitionId, payload) {
        const res = await api.post(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function update(workflowDefinitionId, requirementId, payload) {
        const res = await api.put(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}`,
            payload,
        );
        touch();
        return res.data.data ?? res.data;
    }

    async function destroy(workflowDefinitionId, requirementId) {
        await api.delete(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}`,
        );
        touch();
    }

    async function syncSteps(workflowDefinitionId, requirementId, payload) {
        await api.post(
            `/api/admin/workflow-definitions/${workflowDefinitionId}/requirements/${requirementId}/steps/sync`,
            payload,
        );
        touch();
    }

    return { items, loading, fetchAll, create, update, destroy, syncSteps };
}
