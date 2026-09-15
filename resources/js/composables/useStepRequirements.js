import { ref } from "vue";
import { useApi } from "@/composables/useApi";

export function useStepRequirements() {
    const { api } = useApi();
    const assigned = ref([]);
    const loading = ref(true);
    const saving = ref(false);

    async function fetchAssigned(workflowDefinitionId, stepId) {
        loading.value = true;
        try {
            const res = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/requirements`,
            );
            assigned.value = res.data.data ?? res.data;
        } finally {
            loading.value = false;
        }
    }

    async function sync(workflowDefinitionId, stepId, payload) {
        saving.value = true;
        try {
            await api.post(
                `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/requirements/sync`,
                payload,
            );
        } finally {
            saving.value = false;
        }
    }

    return { assigned, loading, saving, fetchAssigned, sync };
}
