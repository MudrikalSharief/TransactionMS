import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, scopedKey, storedUserId, CacheKeys } from '@/composables/useCache'

// `office: true` = office admin mode: only the admin's own office, through
// /api/office (the server forces the office and blocks admin roles).
export function useAdminUsers({ office = false } = {}) {
  const { api } = useApi()
  const base = office ? '/api/office/users' : '/api/admin/users'
  const cacheKey = office ? scopedKey(CacheKeys.officeUsers, storedUserId()) : CacheKeys.users
  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(cacheKey)
  const users = ref(_cached ?? [])
  const loading = ref(_cached == null)

  async function fetchUsers({ silent = false } = {}) {
    const cached = readCache(cacheKey)
    const quiet = silent || cached != null
    if (cached != null) {
      users.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get(base)
      users.value = res.data.data ?? res.data
      writeCache(cacheKey, users.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function createUser(payload) {
    const res = await api.post(base, payload)
    invalidateCache(cacheKey)
    return res.data.data ?? res.data
  }

  async function updateUser(id, payload) {
    const res = await api.put(`${base}/${id}`, payload)
    invalidateCache(cacheKey)
    return res.data.data ?? res.data
  }

  async function deactivateUser(id) {
    await api.delete(`${base}/${id}`)
    invalidateCache(cacheKey)
  }

  return { users, loading, fetchUsers, createUser, updateUser, deactivateUser }
}
