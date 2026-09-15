import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

export function useOffices() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  async function fetchAll() {
    loading.value = true
    try {
      const res = await api.get('/api/admin/offices')
      items.value = res.data.data ?? res.data
    } finally {
      loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/offices', payload)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/offices/${id}`, payload)
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/offices/${id}`)
  }

  async function fetchSteps(officeId) {
    const res = await api.get(`/api/admin/offices/${officeId}/steps`)
    return res.data.data ?? res.data
  }

  async function createStep(officeId, payload) {
    const res = await api.post(`/api/admin/offices/${officeId}/steps`, payload)
    return res.data.data ?? res.data
  }

  async function updateStep(officeId, stepId, payload) {
    const res = await api.put(`/api/admin/offices/${officeId}/steps/${stepId}`, payload)
    return res.data.data ?? res.data
  }

  async function removeStep(officeId, stepId) {
    await api.delete(`/api/admin/offices/${officeId}/steps/${stepId}`)
  }

  return { items, loading, fetchAll, create, update, remove, fetchSteps, createStep, updateStep, removeStep }
}
