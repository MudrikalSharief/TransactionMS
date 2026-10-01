import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys } from '@/composables/useCache'

export function useOffices() {
  const { api } = useApi()
  const items = ref([])
  const loading = ref(true)

  // Instant illusion: cached offices paint with no loader flash, then the
  // network refreshes silently in the background.
  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.offices)
    const quiet = silent || cached != null
    if (cached != null) {
      items.value = cached
      loading.value = false // painted: drop the loader, refresh silently
    }
    if (!quiet) loading.value = true
    try {
      const res = await api.get('/api/admin/offices')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.offices, items.value)
    } finally {
      if (!quiet) loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/offices', payload)
    invalidateCache(CacheKeys.offices)
    return res.data.data ?? res.data
  }

  async function update(id, payload) {
    const res = await api.put(`/api/admin/offices/${id}`, payload)
    invalidateCache(CacheKeys.offices)
    return res.data.data ?? res.data
  }

  async function remove(id) {
    await api.delete(`/api/admin/offices/${id}`)
    invalidateCache(CacheKeys.offices)
  }

  async function fetchSteps(officeId, { silent = false } = {}) {
    const key = `${CacheKeys.officeSteps}:${officeId}`
    const cached = readCache(key)
    if (cached != null) {
      // Paint now, warm the cache detached for the next visit.
      api.get(`/api/admin/offices/${officeId}/steps`)
        .then((res) => writeCache(key, res.data.data ?? res.data))
        .catch(() => { /* keep painted copy */ });
      return cached
    }
    if (!silent) loading.value = true
    try {
      const res = await api.get(`/api/admin/offices/${officeId}/steps`)
      const rows = res.data.data ?? res.data
      writeCache(key, rows)
      return rows
    } finally {
      if (!silent) loading.value = false
    }
  }

  async function createStep(officeId, payload) {
    const res = await api.post(`/api/admin/offices/${officeId}/steps`, payload)
    invalidateCache(`${CacheKeys.officeSteps}:${officeId}`)
    return res.data.data ?? res.data
  }

  async function updateStep(officeId, stepId, payload) {
    const res = await api.put(`/api/admin/offices/${officeId}/steps/${stepId}`, payload)
    invalidateCache(`${CacheKeys.officeSteps}:${officeId}`)
    return res.data.data ?? res.data
  }

  async function removeStep(officeId, stepId) {
    await api.delete(`/api/admin/offices/${officeId}/steps/${stepId}`)
    invalidateCache(`${CacheKeys.officeSteps}:${officeId}`)
  }

  return { items, loading, fetchAll, create, update, remove, fetchSteps, createStep, updateStep, removeStep }
}
