import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useAdminUsers() {
  const { api } = useApi()
  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(CacheKeys.users)
  const users = ref(_cached ?? [])
  const loading = ref(_cached == null)

  async function fetchUsers({ silent = false } = {}) {
    const cached = readCache(CacheKeys.users)
    const quiet = silent || cached != null
    if (cached != null) {
      users.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/users')
      users.value = res.data.data ?? res.data
      writeCache(CacheKeys.users, users.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function createUser(payload) {
    const res = await api.post('/api/admin/users', payload)
    invalidateCache(CacheKeys.users)
    return res.data.data ?? res.data
  }

  async function updateUser(id, payload) {
    const res = await api.put(`/api/admin/users/${id}`, payload)
    invalidateCache(CacheKeys.users)
    return res.data.data ?? res.data
  }

  async function deactivateUser(id) {
    await api.delete(`/api/admin/users/${id}`)
    invalidateCache(CacheKeys.users)
  }

  return { users, loading, fetchUsers, createUser, updateUser, deactivateUser }
}
