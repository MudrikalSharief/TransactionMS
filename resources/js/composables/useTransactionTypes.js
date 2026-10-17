import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { useAuth } from '@/composables/useAuth'
import { readCache, writeCache, invalidateCache, CacheKeys, scopedKey, storedUserId } from '@/composables/useCache'

export function useTransactionTypes() {
  const { api } = useApi()
  const { user } = useAuth()
  // Rows are office-filtered server-side: scope the cache per user so a
  // shared device never paints another user's type list.
  const key = () => scopedKey(CacheKeys.transactionTypes, user.value?.id ?? storedUserId())

  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(key())
  const items = ref(_cached ?? [])
  const loading = ref(_cached == null)

  // Instant illusion: cached rows paint with no loader flash, then the
  // network refreshes silently in the background.
  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(key())
    const quiet = silent || cached != null
    if (cached != null) {
      items.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/transaction-types')
      items.value = res.data.data ?? res.data
      writeCache(key(), items.value)
    } finally {
      if (!quiet) loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/transaction-types', payload)
    invalidateCache(key())
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/transaction-types/${id}`, payload)
    invalidateCache(key())
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/transaction-types/${id}`)
    invalidateCache(key())
  }

  return { items, loading, fetchAll, create, update, remove }
}
