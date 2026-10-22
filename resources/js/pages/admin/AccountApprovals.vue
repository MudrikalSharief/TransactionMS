<template>
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center ga-2 pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
        <v-icon color="#16307C">mdi-account-clock-outline</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Account Approvals</span>
      <v-chip
        v-if="!loading"
        size="small"
        rounded="0"
        variant="flat"
        :color="pending.length ? 'error' : 'success'"
        class="font-weight-bold"
      >
        {{ pending.length }} waiting
      </v-chip>
      <v-spacer />
      <v-btn
        variant="outlined"
        color="grey-darken-3"
        rounded="0"
        height="40"
        :loading="loading"
        :icon="xs"
        :prepend-icon="xs ? undefined : 'mdi-refresh'"
        aria-label="Refresh"
        @click="load(true)"
      >
        <v-icon v-if="xs">mdi-refresh</v-icon>
        <template v-else>Refresh</template>
      </v-btn>
    </v-card-title>
    <v-divider />

    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3" closable @click:close="error = ''">
        {{ error }}
      </v-alert>

      <v-alert type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
        <template v-if="officeMode">
          People who signed up for <b>{{ auth.user.value?.office?.name || 'your office' }}</b> wait here until you
          approve them. Approved accounts can sign in right away; rejected requests are removed and the person can
          sign up again.
        </template>
        <template v-else>
          People who signed up from the login page wait here until they are approved. Approved accounts can sign in
          right away; rejected requests are removed and the person can sign up again.
        </template>
      </v-alert>

      <v-text-field
        v-model="search"
        prepend-inner-icon="mdi-magnify"
        label="Search . . ."
        variant="outlined"
        density="compact"
        rounded="0"
        hide-details
        clearable
        class="mb-3"
        style="max-width: 420px"
      />

      <div class="d-flex flex-column" style="min-height: 458px">
        <v-data-table
          v-show="!loading || pending.length"
          v-model:page="page"
          :items="filtered"
          :headers="headers"
          item-key="id"
          density="compact"
          :items-per-page="PER_PAGE"
          hide-default-footer
          :sort-by="[{ key: 'created_at', order: 'asc' }]"
          hover
          class="lgu-table table-pages table-fixed-cols"
        >
          <template #no-data>
            <div class="pa-6 text-medium-emphasis">
              {{ search ? 'No requests match your search.' : 'No accounts are waiting for approval.' }}
            </div>
          </template>
          <template v-slot:[`item.name`]="{ item }">
            <span class="cell-wrap font-weight-bold">{{ item.name }}</span>
          </template>
          <template v-slot:[`item.email`]="{ item }">
            <span class="cell-wrap cell-wrap--any">{{ item.email }}</span>
            <span v-if="item.contact_number" class="cell-sub">{{ item.contact_number }}</span>
          </template>
          <template v-slot:[`item.office`]="{ item }">
            <span class="cell-wrap">{{ item.office?.name || '—' }}</span>
          </template>
          <template v-slot:[`item.roles`]="{ item }">
            <div v-if="(item.roles || []).length" class="chip-stack">
              <v-chip
                v-for="r in item.roles"
                :key="r.id || r.code"
                size="small"
                rounded="0"
                variant="tonal"
                color="primary"
                class="font-weight-bold chip-wrap"
              >
                {{ r.name || r.code }}
              </v-chip>
            </div>
            <span v-else class="text-medium-emphasis">—</span>
          </template>
          <template v-slot:[`item.created_at`]="{ item }">
            <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
            <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
          </template>
          <template v-slot:[`item.actions`]="{ item }">
            <div class="d-flex ga-2 justify-end flex-wrap py-2">
              <v-btn
                color="success"
                variant="flat"
                rounded="0"
                size="small"
                prepend-icon="mdi-account-check"
                :loading="busyId === item.id && busyAction === 'approve'"
                :disabled="busyId != null && busyId !== item.id"
                @click="approve(item)"
              >
                Approve
              </v-btn>
              <v-btn
                color="error"
                variant="outlined"
                rounded="0"
                size="small"
                prepend-icon="mdi-account-remove"
                :loading="busyId === item.id && busyAction === 'reject'"
                :disabled="busyId != null && busyId !== item.id"
                @click="reject(item)"
              >
                Reject
              </v-btn>
            </div>
          </template>
        </v-data-table>
        <div v-if="pageCount > 1" class="d-flex justify-center py-3">
          <v-pagination v-model="page" :length="pageCount" :total-visible="5" density="compact" />
        </div>
        <TableLoader v-if="loading && !pending.length" label="account requests" icon="mdi-account-clock-outline" style="flex: 1 1 auto" />
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useDisplay } from 'vuetify'
import { useAuth, isSuperadminUser } from '@/composables/useAuth'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { usePendingAccounts } from '@/composables/usePendingAccounts'
import { confirm } from '@/composables/useConfirm'
import { toast } from '@/composables/useToast'
import TableLoader from '@/components/TableLoader.vue'

// Sign-ups from the login page wait here (approved_at is empty) until a
// superadmin (any office) or an office admin (their own office) decides.
// Uses the same approve / reject endpoints as the Users page.
const auth = useAuth()
const { xs } = useDisplay()
const officeMode = !isSuperadminUser(auth.user.value)
const { users, loading, fetchUsers, approveUser, rejectUser } = useAdminUsers({ office: officeMode })
const pendingCount = usePendingAccounts()

const PER_PAGE = 7
const search = ref('')
const page = ref(1)
const error = ref('')
const busyId = ref(null)
const busyAction = ref('')

const headers = [
  { title: 'Name', key: 'name', width: '20%' },
  { title: 'Email / Contact', key: 'email', width: '23%' },
  { title: 'Office', key: 'office', sortable: false, width: '19%' },
  { title: 'Role requested', key: 'roles', sortable: false, width: '13%' },
  { title: 'Requested', key: 'created_at', width: '12%' },
  { title: '', key: 'actions', sortable: false, width: 260, align: 'end' },
]

const pending = computed(() => (users.value || []).filter((u) => u.pending_approval))
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return pending.value
  return pending.value.filter((u) =>
    [u.name, u.email, u.contact_number, u.office?.name, ...(u.roles || []).map((r) => r.name)]
      .some((v) => String(v || '').toLowerCase().includes(q)),
  )
})
const pageCount = computed(() => Math.max(1, Math.ceil(filtered.value.length / PER_PAGE)))
watch(search, () => { page.value = 1 })
watch(pageCount, (n) => { if (page.value > n) page.value = n })

// Keep the sidebar badge equal to what this page shows.
watch(pending, (rows) => { pendingCount.pendingAccounts.value = rows.length })

async function load(fresh = false) {
  error.value = ''
  try {
    await fetchUsers({ silent: !fresh && users.value.length > 0 })
  } catch (e) {
    error.value = e?.response?.data?.message || 'Failed to load account requests.'
  }
}

async function approve(item) {
  error.value = ''
  busyId.value = item.id
  busyAction.value = 'approve'
  try {
    await approveUser(item.id)
    toast.success(`${item.name} can now sign in.`)
    await fetchUsers({ silent: true })
  } catch (e) {
    error.value = e?.response?.data?.message || 'Approve failed.'
  } finally {
    busyId.value = null
    busyAction.value = ''
  }
}

async function reject(item) {
  const ok = await confirm({
    title: 'Reject this request?',
    message: `${item.name} (${item.email}) will not get access, and the request will be removed. They can sign up again.`,
    confirmLabel: 'Reject',
    cancelLabel: 'Keep',
  })
  if (!ok) return
  error.value = ''
  busyId.value = item.id
  busyAction.value = 'reject'
  try {
    await rejectUser(item.id)
    toast.success(`Request from ${item.name} rejected.`)
    await fetchUsers({ silent: true })
  } catch (e) {
    error.value = e?.response?.data?.message || 'Reject failed.'
  } finally {
    busyId.value = null
    busyAction.value = ''
  }
}

function fmtDate(iso) {
  if (!iso) return 'N/A'
  return new Date(iso).toLocaleDateString('en-PH', {
    timeZone: 'Asia/Manila',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

function timeAgo(iso) {
  if (!iso) return ''
  const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000)
  if (s < 60) return 'just now'
  if (s < 3600) return `${Math.floor(s / 60)}m ago`
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`
  if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`
  return fmtDate(iso)
}

onMounted(() => load(true))
</script>

<style scoped>
/* Full text in every column, wrapped inside its own width; rows grow. */
.cell-wrap {
  display: block;
  white-space: normal;
  overflow-wrap: break-word;
  line-height: 1.4;
  padding: 8px 0 2px;
}
.cell-wrap--any {
  overflow-wrap: anywhere;
}
.cell-sub {
  display: block;
  padding-bottom: 8px;
  font-size: 0.8rem;
  color: rgba(var(--v-theme-on-surface), 0.62);
}
.chip-stack {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 6px 0;
}
.chip-wrap {
  height: auto !important;
  min-height: 24px;
  max-width: 100%;
  padding-block: 3px;
  white-space: normal;
}
.chip-wrap :deep(.v-chip__content) {
  white-space: normal;
  line-height: 1.3;
}
/* Boxed table header: dark-blue fill, white text (same as the admin tables). */
.lgu-table :deep(thead tr th.v-data-table__th) {
  background-color: #0e1f52 !important;
  color: #ffffff !important;
  border-top: 2px solid #0e1f52 !important;
  border-bottom: 3px solid #0e1f52 !important;
  border-left: none !important;
  border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
  border-left: 2px solid #0e1f52 !important;
  padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
  border-right: 2px solid #0e1f52 !important;
  padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
  color: #ffffff !important;
}
</style>
