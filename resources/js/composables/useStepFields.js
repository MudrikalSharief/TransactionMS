import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useStepFields() {
  const { api } = useApi()

  const assigned = ref([])
  const loading = ref(true)

  async function fetchAssigned(workflowStepId) {
    loading.value = true
    try {
      const res = await api.get(`/api/admin/workflow-steps/${workflowStepId}/fields`)
      assigned.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
  }

  async function sync(workflowStepId, fields) {
    const res = await api.post(`/api/admin/workflow-steps/${workflowStepId}/fields/sync`, { fields })
    assigned.value = res.data.data ?? res.data
    return assigned.value
  }

  return { assigned, loading, fetchAssigned, sync }
}
