import { ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { useAuth } from '@/composables/useAuth'
import { readCache, writeCache, invalidateCache, CacheKeys, scopedKey, storedUserId, slimTx } from '@/composables/useCache'

export function useTransactions() {
  const { api } = useApi()
  const { user } = useAuth()
  // Rows depend on who is logged in: scope the cache per user so a shared
  // device never paints another user's list.
  const key = () => scopedKey(CacheKeys.transactions, user.value?.id ?? storedUserId())

  // Init from cache at setup: warm loads paint rows on first render with
  // loading already false (zero loader flash); cold loads start loading.
  const _cached = readCache(key())
  const items = ref(_cached ?? [])
  const loading = ref(_cached == null)
  // Server pagination meta (Laravel paginator). Tables bind to items;
  // meta drives total/pages without rendering unpaged thousands of rows.
  const meta = ref({ total: 0, page: 1, lastPage: 1, perPage: 25 })

  function applyPayload(res) {
    const raw = res.data
    const rows = Array.isArray(raw?.data) ? raw.data : Array.isArray(raw) ? raw : []
    items.value = rows
    if (raw && typeof raw === 'object' && (raw.meta || raw.total !== undefined)) {
      meta.value = {
        total: raw.meta?.total ?? raw.total ?? rows.length,
        page: raw.meta?.current_page ?? 1,
        lastPage: raw.meta?.last_page ?? 1,
        perPage: raw.meta?.per_page ?? rows.length ?? 25,
      }
    } else {
      meta.value = { total: rows.length, page: 1, lastPage: 1, perPage: rows.length || 25 }
    }
    return items.value
  }

  // Instant illusion: cached slim rows paint immediately with NO loader
  // flash (loading stays false), then the network refreshes silently in
  // the background. Search/pages skip the cache so filtered results never
  // poison the default-view cache.
  async function fetchAll({ silent = false, q = '', page = 1, per_page = 25 } = {}) {
    const isDefault = !String(q || '').trim() && Number(page) === 1
    let painted = false
    if (isDefault) {
      const cached = readCache(key())
      if (cached != null) {
        items.value = cached
        meta.value = { total: cached.length, page: 1, lastPage: 1, perPage: per_page }
        loading.value = false // painted: drop the loader, refresh silently
        painted = true
      }
    }
    const quiet = silent || painted
    if (!quiet) loading.value = true
    try {
      const params = { page, per_page }
      if (String(q || '').trim()) params.q = String(q).trim()
      const res = await api.get('/api/admin/transactions', { params })
      applyPayload(res)
      if (isDefault) writeCache(key(), (items.value || []).map(slimTx))
    } finally {
      if (!quiet) loading.value = false
    }
    return items.value
  }

  async function create(payload) {
    const res = await api.post('/api/admin/transactions', payload)
    invalidateCache(key())
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
    invalidateCache(key())
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

  async function receive(id) {
    const res = await api.post(`/api/admin/transactions/${id}/receive`)
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function gotoStation(id, payload) {
    const res = await api.post(`/api/admin/transactions/${id}/goto`, payload)
    return {
      tx: res.data.data ?? res.data,
      meta: res.data.meta ?? {},
    }
  }

  async function finalize(id) {
    const res = await api.post(`/api/admin/transactions/${id}/finalize`)
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
    invalidateCache(key())
  }

  async function uploadAttachment(id, file, requirementId = null) {
    const fd = new FormData()
    fd.append('file', file)
    if (requirementId) fd.append('requirement_definition_id', String(requirementId))
    const res = await api.post(`/api/admin/transactions/${id}/attachments`, fd)
    return res.data.data ?? res.data
  }

  return { items, loading, meta, fetchAll, create, getOne, updateOffice, execute, receive, gotoStation, finalize, checkRequirement, destroy, uploadAttachment }
}
