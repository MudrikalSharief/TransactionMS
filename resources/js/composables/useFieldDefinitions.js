import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useFieldDefinitions() {
  const { api } = useApi()

  const items = ref([])
  const loading = ref(true)

  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.fields)
    const quiet = silent || cached != null
    if (cached != null) {
      items.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/fields')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.fields, items.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function create(payload) {
    const res = await api.post('/api/admin/fields', payload)
    invalidateCache(CacheKeys.fields)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/fields/${id}`, payload)
    invalidateCache(CacheKeys.fields)
    return res.data.data ?? res.data
  }

  async function destroy(id) {
    await api.delete(`/api/admin/fields/${id}`)
    invalidateCache(CacheKeys.fields)
  }

  return { items, loading, fetchAll, create, update, destroy }
}
