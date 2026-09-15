import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useFieldDefinitions() {
  const { api } = useApi()

  const items = ref([])
  const loading = ref(true)

  async function fetchAll() {
    loading.value = true
    try {
      const res = await api.get('/api/admin/fields')
      items.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
  }

  async function create(payload) {
    const res = await api.post('/api/admin/fields', payload)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/fields/${id}`, payload)
    return res.data.data ?? res.data
  }

  async function destroy(id) {
    await api.delete(`/api/admin/fields/${id}`)
  }

  return { items, loading, fetchAll, create, update, destroy }
}
