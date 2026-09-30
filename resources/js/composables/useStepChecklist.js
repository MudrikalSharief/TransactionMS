import { ref } from "vue";
import { useApi } from "@/composables/useApi";

export function useStepChecklist() {
    const { api } = useApi();
    const items = ref([]);
    const loading = ref(true);
    const saving = ref(false);

    async function fetchChecklist(workflowDefinitionId, stepId) {
        loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/checklist`,
            );
            items.value = res.data.data ?? res.data;
        } finally {
            loading.value = false;
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
        } finally {
            saving.value = false;
        }
    }

    return { items, loading, saving, fetchChecklist, sync, resync };
}
