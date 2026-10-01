import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useGovernmentReferences() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.govRefs)
    const quiet = silent || cached != null
    if (cached != null) {
      items.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/government-references')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.govRefs, items.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function create(payload) {
    const res = await api.post('/api/admin/government-references', payload)
    invalidateCache(CacheKeys.govRefs)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/government-references/${id}`, payload)
    invalidateCache(CacheKeys.govRefs)
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/government-references/${id}`)
    invalidateCache(CacheKeys.govRefs)
  }

  return { items, loading, fetchAll, create, update, remove }
}
