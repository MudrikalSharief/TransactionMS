import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useAdminUsers() {
  const { api } = useApi()
  const users = ref([])
  const loading = ref(true)

  async function fetchUsers() {
    loading.value = true
    try {
      const res = await api.get('/api/admin/users')
      users.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
  }

  async function createUser(payload) {
    const res = await api.post('/api/admin/users', payload)
    return res.data.data ?? res.data
  }

  async function updateUser(id, payload) {
    const res = await api.put(`/api/admin/users/${id}`, payload)
    return res.data.data ?? res.data
  }

  async function deactivateUser(id) {
    await api.delete(`/api/admin/users/${id}`)
  }

  return { users, loading, fetchUsers, createUser, updateUser, deactivateUser }
}
