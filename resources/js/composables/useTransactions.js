import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { readCache, writeCache, invalidateCache, CacheKeys, slimTx } from '@/composables/useCache'

export function useTransactions() {
  const { api } = useApi()

  const items = ref([])
  const loading = ref(true)

  // Cache-first: cached rows are available instantly, then refreshed.
  // Loading is raised on every non-silent fetch so the TableLoader
  // takes priority over the table; pass { silent: true } for
  // invisible background refreshes (dashboard warm loads).
  async function fetchAll({ silent = false } = {}) {
    const cached = readCache(CacheKeys.transactions)
    if (cached) items.value = cached
    if (!silent) loading.value = true
    try {
      const res = await api.get('/api/admin/transactions')
      items.value = res.data.data ?? res.data
      writeCache(CacheKeys.transactions, (items.value || []).map(slimTx))
    } finally {
      if (!silent) loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/transactions', payload)
    invalidateCache(CacheKeys.transactions)
    return res.data.data ?? res.data
  }

  async function getOne(id) {
    const res = await api.get(`/api/admin/transactions/${id}`)
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function updateOffice(id, office_id) {
    const res = await api.put(`/api/admin/transactions/${id}/office`, { office_id: office_id ?? null })
    invalidateCache(CacheKeys.transactions)
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function execute(id, payload) {
    const res = await api.post(`/api/admin/transactions/${id}/execute`, payload)
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function checkRequirement(id, requirement_definition_id) {
    const res = await api.post(`/api/admin/transactions/${id}/requirements/check`, {
      requirement_definition_id,
    })
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function destroy(id) {
    await api.delete(`/api/admin/transactions/${id}`)
    invalidateCache(CacheKeys.transactions)
  }

  async function uploadAttachment(id, file, requirementId = null) {
    const fd = new FormData()
    fd.append('file', file)
    if (requirementId) fd.append('requirement_definition_id', String(requirementId))
    const res = await api.post(`/api/admin/transactions/${id}/attachments`, fd)
    return res.data.data ?? res.data
  }

  return { items, loading, fetchAll, create, getOne, updateOffice, execute, checkRequirement, destroy, uploadAttachment }
}
