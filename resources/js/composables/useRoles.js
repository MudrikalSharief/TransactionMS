import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useRoles() {
  const { api } = useApi()
  const roles = ref([])
  const loading = ref(true)

  async function fetchRoles() {
    loading.value = true
    try {
      const res = await api.get('/api/admin/roles')
      roles.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
  }

  async function createRole(payload) {
    const res = await api.post('/api/admin/roles', payload)
    return res.data.data ?? res.data
  }

  async function updateRole(id, payload) {
    const res = await api.put(`/api/admin/roles/${id}`, payload)
    return res.data.data ?? res.data
  }

  async function deleteRole(id) {
    await api.delete(`/api/admin/roles/${id}`)
  }

  return { roles, loading, fetchRoles, createRole, updateRole, deleteRole }
}
