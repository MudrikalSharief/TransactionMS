import { ref } from 'vue'
import { useApi } from '@/composables/useApi'

// Number of sign-ups waiting for approval, for the sidebar badge and the
// Account Approvals page. Module-level so both read the same value.
// Superadmin counts every office (/api/admin/users); an office admin only
// their own office (/api/office/users, scoped by the server).
const pendingAccounts = ref(0)
let inFlight = null
let lastAt = 0

export function usePendingAccounts() {
  const { api } = useApi()

  // `office`: office admin mode. Calls within 30s reuse the last count
  // unless `force` (after approving/rejecting).
  function refresh({ office = false, force = false } = {}) {
    if (inFlight) return inFlight
    if (!force && Date.now() - lastAt < 30000) return Promise.resolve(pendingAccounts.value)
    inFlight = api
      .get(office ? '/api/office/users' : '/api/admin/users')
      .then((res) => {
        const rows = res.data?.data ?? res.data ?? []
        pendingAccounts.value = rows.filter((u) => u.pending_approval).length
        lastAt = Date.now()
        return pendingAccounts.value
      })
      .catch(() => {
        pendingAccounts.value = 0
        return 0
      })
      .finally(() => {
        inFlight = null
      })
    return inFlight
  }

  function clear() {
    pendingAccounts.value = 0
    lastAt = 0
  }

  return { pendingAccounts, refresh, clear }
}
