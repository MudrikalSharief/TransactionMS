import { ref } from "vue";
import { useApi } from "@/composables/useApi";

export function useStepData() {
    const { api } = useApi();
    const items = ref([]);
    const loading = ref(false);
    const saving = ref(false);

    function baseUrl(workflowDefinitionId, stepId) {
        return `/api/admin/workflow-definitions/${workflowDefinitionId}/steps/${stepId}/step-data`;
    }

    async function fetchAll(workflowDefinitionId, stepId) {
        loading.value = true;
        try {
            const res = await api.get(baseUrl(workflowDefinitionId, stepId));
            items.value = res.data.data ?? res.data ?? [];
        } finally {
            loading.value = false;
        }
    }

    async function create(workflowDefinitionId, stepId, payload) {
        saving.value = true;
        try {
            const res = await api.post(baseUrl(workflowDefinitionId, stepId), payload);
            const row = res.data.data ?? res.data;
            if (row?.id) items.value = [...items.value, row];
            return row;
        } finally {
            saving.value = false;
        }
    }

    async function update(workflowDefinitionId, stepId, id, payload) {
        saving.value = true;
        try {
            const res = await api.put(`${baseUrl(workflowDefinitionId, stepId)}/${id}`, payload);
            const row = res.data.data ?? res.data;
            if (row?.id) {
                items.value = items.value.map((r) => (Number(r.id) === Number(row.id) ? row : r));
            }
            return row;
        } finally {
            saving.value = false;
        }
    }

    async function remove(workflowDefinitionId, stepId, id) {
        saving.value = true;
        try {
            await api.delete(`${baseUrl(workflowDefinitionId, stepId)}/${id}`);
            items.value = items.value.filter((r) => Number(r.id) !== Number(id));
        } finally {
            saving.value = false;
        }
    }

    return { items, loading, saving, fetchAll, create, update, remove };
}
