import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useTransactionTypes() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  // Instant illusion: cached rows paint with no loader flash, then the
  // network refreshes silently in the background.
  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.transactionTypes)
    const quiet = silent || cached != null
    if (cached != null) {
      items.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/transaction-types')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.transactionTypes, items.value)
    } finally {
      if (!quiet) loading.value = false
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
