import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useRoles() {
  const { api } = useApi()
  const roles = ref([])
  const loading = ref(true)

  async function fetchRoles({ silent = false } = {}) {
    const cached = readCache(CacheKeys.roles)
    const quiet = silent || cached != null
    if (cached != null) {
      roles.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/roles')
      roles.value = res.data.data ?? res.data
      writeCache(CacheKeys.roles, roles.value)
    } finally {
      if (!quiet) loading.value = false
    }
  }

  async function createRole(payload) {
    const res = await api.post('/api/admin/roles', payload)
    invalidateCache(CacheKeys.roles)
    return res.data.data ?? res.data
  }

  async function updateRole(id, payload) {
    const res = await api.put(`/api/admin/roles/${id}`, payload)
    invalidateCache(CacheKeys.roles)
    return res.data.data ?? res.data
  }

  async function deleteRole(id) {
    await api.delete(`/api/admin/roles/${id}`)
    invalidateCache(CacheKeys.roles)
  }

  return { roles, loading, fetchRoles, createRole, updateRole, deleteRole }
}
