import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, CacheKeys } from "@/composables/useCache";

export function useStepChecklist() {
    const { api } = useApi();
    const items = ref([]);
    const loading = ref(true);
    const saving = ref(false);

    const keyFor = (workflowDefinitionId, stepId) =>
        `${CacheKeys.stepChecklist}:${workflowDefinitionId}:${stepId}`;

    async function fetchChecklist(workflowDefinitionId, stepId, { silent = false } = {}) {
        const key = keyFor(workflowDefinitionId, stepId);
        const cached = readCache(key);
        const quiet = silent || cached != null;
        if (cached != null) {
            items.value = cached;
            loading.value = false; // painted: drop the loader, refresh silently
        }
        if (!quiet) loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/checklist`,
            );
            items.value = res.data.data ?? res.data;
            writeCache(key, items.value);
        } finally {
            if (!quiet) loading.value = false;
        }
    }

    async function sync(workflowDefinitionId, stepId, payload) {
        saving.value = true;
        try {
            const res = await api.post(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/checklist/sync`,
                payload,
            );
            items.value = res.data.data ?? items.value;
            writeCache(keyFor(workflowDefinitionId, stepId), items.value);
        } finally {
            saving.value = false;
        }
    }

    async function resync(workflowDefinitionId, stepId) {
        saving.value = true;
        try {
            const res = await api.post(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/checklist/resync`,
            );
            items.value = res.data.data ?? res.data;
            writeCache(keyFor(workflowDefinitionId, stepId), items.value);
        } finally {
            saving.value = false;
        }
    }

    return { items, loading, saving, fetchChecklist, sync, resync };
}
