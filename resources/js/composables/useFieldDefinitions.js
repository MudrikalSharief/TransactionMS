import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useFieldDefinitions() {
  const { api } = useApi()

  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(CacheKeys.fields)
  const items = ref(_cached ?? [])
  const loading = ref(_cached == null)

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
