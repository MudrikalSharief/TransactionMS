import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidatePrefix, CacheKeys } from '@/composables/useCache'

export function useRoles({ office = false, officeId = null } = {}) {
  const { api } = useApi()
  const base = office ? '/api/office/roles' : '/api/admin/roles'
  const cacheKey = office ? `${CacheKeys.roles}:office:${officeId}` : CacheKeys.roles
  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(cacheKey)
  const roles = ref(_cached ?? [])
  const loading = ref(_cached == null)

  async function fetchRoles({ silent = false } = {}) {
    const cached = readCache(cacheKey)
    const quiet = silent || cached != null
    if (cached != null) {
      roles.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get(base)
      roles.value = res.data.data ?? res.data
      writeCache(cacheKey, roles.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function createRole(payload) {
    const res = await api.post(base, payload)
    invalidatePrefix(CacheKeys.roles)
    return res.data.data ?? res.data
  }

  async function updateRole(id, payload) {
    const res = await api.put(`${base}/${id}`, payload)
    invalidatePrefix(CacheKeys.roles)
    return res.data.data ?? res.data
  }

  async function deleteRole(id) {
    await api.delete(`${base}/${id}`)
    invalidatePrefix(CacheKeys.roles)
  }

  return { roles, loading, fetchRoles, createRole, updateRole, deleteRole }
}
