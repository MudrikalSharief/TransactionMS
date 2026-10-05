import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, CacheKeys } from "@/composables/useCache";

export function useStepRequirements() {
    const { api } = useApi();
    const assigned = ref([]);
    const loading = ref(true);
    const saving = ref(false);

    async function fetchAssigned(workflowDefinitionId, stepId, { silent = false } = {}) {
        const key = `${CacheKeys.stepRequirements}:${workflowDefinitionId}:${stepId}`;
        const cached = readCache(key);
        const quiet = silent || cached != null;
        if (cached != null) {
            assigned.value = cached;
            loading.value = false; // painted: drop the loader, refresh silently
        }
        if (!quiet) loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/requirements`,
            );
            assigned.value = res.data.data ?? res.data;
            writeCache(key, assigned.value);
        } finally {
            if (!quiet) loading.value = false;
        }
    }

    async function sync(workflowDefinitionId, stepId, payload) {
        saving.value = true;
        try {
            await api.post(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/requirements/sync`,
                payload,
            );
            // Refresh the cached assignment from the server response path:
            // next fetch revalidates anyway; drop the stale entry now.
            writeCache(
                `${CacheKeys.stepRequirements}:${workflowDefinitionId}:${stepId}`,
                assigned.value,
            );
        } finally {
            saving.value = false;
        }
    }

    return { assigned, loading, saving, fetchAssigned, sync };
}
