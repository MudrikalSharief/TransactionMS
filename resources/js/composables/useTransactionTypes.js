import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useTransactionTypes() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  // Cache-first: cached rows are available instantly, then refreshed.
  // Loading is raised on every non-silent fetch so the TableLoader
  // takes priority over the table; pass { silent: true } for
  // invisible background refreshes (dashboard warm loads).
  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.transactionTypes)
    if (cached) items.value = cached
    if (!silent) loading.value = true
    try {
      const res = await api.get('/api/admin/transaction-types')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.transactionTypes, items.value)
    } finally {
      if (!silent) loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/transaction-types', payload)
    invalidateCache(CacheKeys.transactionTypes)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/transaction-types/${id}`, payload)
    invalidateCache(CacheKeys.transactionTypes)
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/transaction-types/${id}`)
    invalidateCache(CacheKeys.transactionTypes)
  }

  return { items, loading, fetchAll, create, update, remove }
}
