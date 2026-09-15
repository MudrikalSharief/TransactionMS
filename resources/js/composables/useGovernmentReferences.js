import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useGovernmentReferences() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  async function fetchAll() {
    loading.value = true
    try {
      const res = await api.get('/api/admin/government-references')
      items.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
  }

  async function create(payload) {
    const res = await api.post('/api/admin/government-references', payload)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/government-references/${id}`, payload)
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/government-references/${id}`)
  }

  return { items, loading, fetchAll, create, update, remove }
}
