import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, CacheKeys } from '@/composables/useCache'

export function useStepFields() {
  const { api } = useApi()

  const assigned = ref([])
  const loading = ref(true)

  async function fetchAssigned(workflowStepId, { silent = false } = {}) {
    const key = `${CacheKeys.stepFields}:${workflowStepId}`
    const cached = readCache(key)
    const quiet = silent || cached != null
    if (cached != null) {
      assigned.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get(`/api/admin/workflow-steps/${workflowStepId}/fields`)
      assigned.value = res.data.data ?? res.data
      writeCache(key, assigned.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function sync(workflowStepId, fields) {
    const res = await api.post(`/api/admin/workflow-steps/${workflowStepId}/fields/sync`, { fields })
    assigned.value = res.data.data ?? res.data
    writeCache(`${CacheKeys.stepFields}:${workflowStepId}`, assigned.value)
    return assigned.value
  }

  return { assigned, loading, fetchAssigned, sync }
}
