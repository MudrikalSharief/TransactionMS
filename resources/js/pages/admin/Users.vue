<template>
  <LoadingVeil :show="loading" label="users" icon="mdi-account-group" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#16307C">mdi-account-group</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">{{ officeMode ? 'Office Users' : 'Users' }}</span>
      <ScopeChip v-if="officeMode" class="ml-3" />
      <v-spacer />
      <v-text-field
        v-model="search"
        prepend-inner-icon="mdi-magnify"
        label="Search . . ."
        variant="outlined"
        density="compact"
        rounded="0"
        hide-details
        clearable
        class="mr-2"
        style="max-width: 260px"
      />
      <v-btn v-if="canManage" variant="outlined" color="primary" rounded="0" prepend-icon="mdi-plus" height="40" @click="openCreate">
        Add User
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
        {{ error }}
      </v-alert>
      <v-alert
        v-if="canManage && pendingCount"
        type="warning"
        variant="tonal"
        density="compact"
        rounded="0"
        icon="mdi-account-clock-outline"
        class="mb-3"
      >
        {{ pendingCount === 1 ? '1 account is' : `${pendingCount} accounts are` }} waiting for approval.
        They're listed first; check the details, then approve or reject.
      </v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        v-model:page="page"
        :items="filtered"
        :loading="loading"
        :headers="headers"
        item-key="id"
        density="compact"
        :items-per-page="PER_PAGE"
        :items-per-page-options="[PER_PAGE]"
        hover
        class="lgu-table table-pages table-fixed-cols"
      >
        <template v-slot:[`item.name`]="{ item }">
          <span class="cell-wrap font-weight-bold">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.email`]="{ item }">
          <span class="cell-wrap cell-wrap--any">{{ item.email }}</span>
        </template>

        <template v-slot:[`item.roles`]="{ item }">
          <div v-if="(item.roles || []).length" class="chip-stack">
            <v-chip
              v-for="r in item.roles"
              :key="r.id"
              rounded="0"
              size="small"
              variant="tonal"
              class="chip-wrap"
            >
              {{ r.name }}
            </v-chip>
          </div>
          <span v-else class="text-medium-emphasis" title="No active role">—</span>
        </template>

        <template v-slot:[`item.office`]="{ item }">
          <v-chip
            v-if="item.office?.name || officeNameById.get(Number(item.office_id))"
            rounded="0"
            size="small"
            variant="tonal"
            color="primary"
            class="font-weight-bold chip-wrap"
          >
            {{ item.office?.name || officeNameById.get(Number(item.office_id)) }}
          </v-chip>
          <span v-else class="text-medium-emphasis">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <v-chip v-if="item.pending_approval" color="warning" rounded="0" size="small" variant="tonal" class="chip-wrap">
            <v-icon start size="small">mdi-clock-outline</v-icon>
            Waiting for approval
          </v-chip>
          <v-chip v-else :color="item.is_active ? 'success' : 'error'" rounded="0" size="small" variant="tonal">
            <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
            {{ item.is_active ? 'Active' : 'Inactive' }}
          </v-chip>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div v-if="canManage" class="d-flex ga-3 justify-end row-actions">
            <span v-if="lockReason(item)" v-tooltip="lockReason(item)" class="d-flex align-center text-medium-emphasis">
              <v-icon size="small">mdi-lock-outline</v-icon>
            </span>
            <template v-else-if="item.pending_approval">
              <v-btn
                icon="mdi-check"
                v-tooltip="'Approve: let this person sign in'"
                size="small"
                variant="outlined"
                color="success"
                :loading="busyId === item.id"
                @click="approve(item)"
              />
              <v-btn
                icon="mdi-pencil"
                v-tooltip="'Edit before approving'"
                size="small"
                variant="outlined"
                color="grey-darken-3"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-close"
                v-tooltip="'Reject: remove this request'"
                size="small"
                variant="outlined"
                color="error"
                :disabled="busyId === item.id"
                @click="reject(item)"
              />
            </template>
            <template v-else>
              <v-btn
                icon="mdi-pencil"
                v-tooltip="'Edit user'"
                size="small"
                variant="outlined"
                color="grey-darken-3"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-account-off"
                v-tooltip="'Deactivate user'"
                size="small"
                variant="outlined"
                color="error"
                :disabled="item.id === meId"
                @click="deactivate(item)"
              />
            </template>
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="700">
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title>{{ form.id ? 'Edit User' : 'New User' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.name" label="Name" />
        <v-text-field v-model="form.email" label="Email" type="email" />
        <v-text-field v-model="form.contact_number" label="Contact number" type="tel" placeholder="09171234567" />

        <v-text-field
          v-model="form.password"
          :label="form.id ? 'New Password (optional)' : 'Password'"
          type="password"
        />

        <!-- New users start active; the switch is only for existing ones
             (e.g. turning a deactivated account back on). -->
        <v-switch v-if="form.id && !form.pending_approval" v-model="form.is_active" label="Active" />

        <v-select
          v-model="form.role_ids"
          :items="roleOptions"
          item-title="label"
          item-value="id"
          label="Roles"
          multiple
          chips
        />

        <v-select
          v-if="!officeMode"
          v-model="form.office_id"
          :items="officeOptions"
          item-title="label"
          item-value="id"
          label="Office"
          clearable
        />
        <v-alert v-else type="info" variant="tonal" density="compact" rounded="0">
          {{ form.id ? 'Stays in' : 'Joins' }} <b>{{ myOffice?.name || 'your office' }}</b>.
          Admin and superadmin roles are given by a superadmin.
        </v-alert>
      </v-card-text>
      <v-divider />
      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
        <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="save">Save</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useRoles } from '@/composables/useRoles'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import { useApi } from '@/composables/useApi'
import { confirm } from '@/composables/useConfirm'
import LoadingVeil from '@/components/LoadingVeil.vue'
import ScopeChip from '@/components/ScopeChip.vue'

const auth = useAuth()
const { api } = useApi()
// /office/users: an office admin managing their own office's members.
const officeMode = !!useRoute().meta.officeScope
const { users, loading, fetchUsers, createUser, updateUser, deactivateUser, approveUser, rejectUser } =
  useAdminUsers({ office: officeMode })
const { roles: allRoles, fetchRoles: fetchAllRoles } = useRoles()
const { items: offices, fetchAll: fetchOffices } = useOffices()

// Superadmins manage everyone; office admins manage their own office (/office/users).
const canManage = computed(() => officeMode || (auth.user.value?.roles ?? []).some((r) => r.code === 'superadmin'))
const meId = computed(() => auth.user.value?.id)
const myOffice = computed(() => auth.user.value?.office ?? null)

// Office admins may only give out roles below admin (server list).
const officeRoles = ref([])
const roles = computed(() => (officeMode ? officeRoles.value : allRoles.value))
async function fetchRoles() {
  if (!officeMode) return fetchAllRoles()
  const res = await api.get('/api/office/roles')
  officeRoles.value = res.data.data ?? res.data
}

// Admins, superadmins and your own account stay with a superadmin.
function lockReason(item) {
  if (!officeMode) return ''
  if (item.id === meId.value) return 'Your own account is managed by a superadmin'
  if ((item.roles || []).some((r) => ['admin', 'superadmin'].includes(r.code))) {
    return 'Admins are managed by a superadmin'
  }
  return ''
}

// Two icon buttons side by side plus cell padding; a waiting account's
// three buttons wrap onto two lines.
const ACTIONS_W = 132
// Columns share the table's width by percentage (table-fixed-cols), so the
// table flexes with the window and the sidebar; long names, emails, roles
// and offices wrap inside their columns, and Status and the actions always
// stay in view.
const headers = officeMode
  ? [
      { title: 'Name', key: 'name', width: '30%' },
      { title: 'Email', key: 'email', width: '25%' },
      { title: 'Roles', key: 'roles', sortable: false, width: '18%' },
      { title: 'Status', key: 'is_active', width: '13%' },
      { title: '', key: 'actions', sortable: false, width: ACTIONS_W, align: 'end' },
    ]
  : [
      { title: 'Name', key: 'name', width: '24%' },
      { title: 'Email', key: 'email', width: '22%' },
      { title: 'Roles', key: 'roles', sortable: false, width: '15%' },
      { title: 'Office', key: 'office', sortable: false, width: '17%' },
      { title: 'Status', key: 'is_active', width: '12%' },
      { title: '', key: 'actions', sortable: false, width: ACTIONS_W, align: 'end' },
    ]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')
const PER_PAGE = 7
const page = ref(1)

let navObserver = null

// Client-side search: master data is small, filter loaded rows by
// name / email / roles / office / status without extra requests.
// Accounts waiting for approval come first.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  const rows = !q
    ? users.value || []
    : (users.value || []).filter((u) =>
        [
          u.name,
          u.email,
          u.contact_number,
          (u.roles || []).map((r) => r.name).join(' '),
          u.office?.name || officeNameById.value.get(Number(u.office_id)) || '',
          u.pending_approval ? 'waiting for approval pending' : u.is_active ? 'active' : 'inactive',
        ].some((v) => String(v || '').toLowerCase().includes(q))
      )
  return [...rows].sort((a, b) => Number(!!b.pending_approval) - Number(!!a.pending_approval))
})

const pendingCount = computed(() => (users.value || []).filter((u) => u.pending_approval).length)
const busyId = ref(null)

async function approve(item) {
  error.value = ''
  busyId.value = item.id
  try {
    await approveUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Approve failed.'
  } finally {
    busyId.value = null
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
  try {
    await rejectUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Reject failed.'
  } finally {
    busyId.value = null
  }
}

const form = ref({
  id: null,
  name: '',
  email: '',
  contact_number: '',
  password: '',
  is_active: true,
  pending_approval: false,
  role_ids: [],
  office_id: null,
})

const roleOptions = computed(() =>
   (roles.value || []).map(r => ({ id: r.id, label: `${r.name}` })) // use ${r.code} to show Role Code
)

const officeOptions = computed(() =>
  (offices.value || []).map(o => ({ id: o.id, label: `${o.name}` }))
)

const officeNameById = computed(() => {
  const m = new Map()
  for (const o of (offices.value || [])) m.set(Number(o.id), o.name || o.code)
  return m
})

function openCreate() {
  error.value = ''
  form.value = {
    id: null,
    name: '',
    email: '',
    contact_number: '',
    password: '',
    is_active: true,
    pending_approval: false,
    role_ids: [],
    office_id: null,
  }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    name: item.name,
    email: item.email,
    contact_number: item.contact_number || '',
    password: '',
    is_active: !!item.is_active,
    pending_approval: !!item.pending_approval,
    role_ids: (item.roles || []).map(r => r.id),
    office_id: item.office_id ?? item.office?.id ?? null,
  }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    const payload = {
      name: form.value.name,
      email: form.value.email,
      contact_number: form.value.contact_number || null,
      role_ids: form.value.role_ids,
    }
    // Pending accounts stay inactive until approved.
    if (!form.value.pending_approval) payload.is_active = form.value.is_active
    // Office mode: the server always uses the admin's own office.
    if (!officeMode) payload.office_id = form.value.office_id ?? null
    if (form.value.password) payload.password = form.value.password

    if (form.value.id) {
      await updateUser(form.value.id, payload)
    } else {
      if (!form.value.password) throw new Error('Password required')
      await createUser({ ...payload, password: form.value.password })
    }

    dialog.value = false
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || e?.message || 'Save failed.'
  } finally {
    saving.value = false
  }
}

async function deactivate(item) {
  error.value = ''
  try {
    await deactivateUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Deactivate failed.'
  }
}

// Scroll only when there's enough to scroll: with fewer than SCROLL_FROM
// rows on the current table page, the tab keeps the usual scroll lock;
// from SCROLL_FROM rows up (wrapped rows can outgrow the screen) the page
// scrolls. Defined after `filtered` and everything it reads.
const SCROLL_FROM = 5
const rowsOnPage = computed(() => {
  const total = filtered.value.length
  return Math.max(0, Math.min(PER_PAGE, total - (page.value - 1) * PER_PAGE))
})
watch(search, () => { page.value = 1 })
watch(
  rowsOnPage,
  (n) => document.documentElement.classList.toggle('lock-scroll', n < SCROLL_FROM),
  { immediate: true },
)

onMounted(() => {
  // Scroll lock follows the rows on screen (see rowsOnPage): rows wrap to
  // show full names, emails and offices, so a full page of users can be
  // taller than the screen and then the page scrolls.
  // Independent lookups: run in parallel so one slow endpoint never blocks
  // the others. Each paints cache first, then revalidates silently.
  fetchRoles().catch(() => {})
  if (!officeMode) fetchOffices().catch(() => {})
  fetchUsers().catch(() => {})
  // Track left-navbar width: rail ~56px vs expanded ~256px. While expanded
  // the table is narrower, so flag html.nav-open to duck the row actions
  // away instead of letting them get cut off. Covers hover-expand + toggle.
  try {
    const drawer = document.querySelector('.v-navigation-drawer')
    if (drawer && 'ResizeObserver' in window) {
      const sync = () => {
        const w = drawer.getBoundingClientRect().width || 0
        document.documentElement.classList.toggle('nav-open', w > 100)
      }
      sync()
      navObserver = new ResizeObserver(sync)
      navObserver.observe(drawer)
    }
  } catch {
    /* actions just stay visible */
  }
})

onUnmounted(() => {
  document.documentElement.classList.remove('lock-scroll')
  document.documentElement.classList.remove('nav-open')
  try {
    navObserver?.disconnect?.()
  } catch {
    /* ignore */
  }
  navObserver = null
})
</script>

<style scoped>
/* Full text, wrapped within its column; the row grows to fit. Breaks
   between words; a single word longer than the column still breaks. */
.cell-wrap {
  display: block;
  white-space: normal;
  word-break: normal;
  overflow-wrap: break-word;
  line-height: 1.4;
  padding: 10px 0;
}
/* Emails have no spaces: let them break anywhere. */
.cell-wrap--any {
  overflow-wrap: anywhere;
}
/* Actions: always visible here (the global rule hides them while the
   sidebar is open); with little room the buttons wrap instead. */
.row-actions,
:global(html.nav-open) .row-actions {
  opacity: 1 !important;
  visibility: visible !important;
  animation: none !important;
  flex-wrap: wrap;
  gap: 8px !important;
  min-width: 0;
  padding: 6px 0;
}
.chip-stack {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 6px 0;
}
/* Chips that wrap long text instead of being cut at the column edge. */
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
/* Hide the table's internal scrollbar; drawer expand can never create a
   visible horizontal bar — overflow is clipped, not scrolled. */
.lgu-table {
  min-width: 0;
  width: 100%;
}
.lgu-table :deep(.v-table__wrapper) {
  overflow-x: clip !important;
  scrollbar-width: none;
  -ms-overflow-style: none;
}
.lgu-table :deep(.v-table__wrapper::-webkit-scrollbar) {
  display: none;
  width: 0;
  height: 0;
}
.lgu-table :deep(table) {
  width: 100%;
}
/* Boxed table header: dark-blue fill, white text, outer border only —
   no dividers between header cells (matches Transactions tab). */
.lgu-table :deep(thead tr th.v-data-table__th) {
  background-color: #0E1F52 !important;
  color: #ffffff !important;
  border-top: 2px solid #0E1F52 !important;
  border-bottom: 3px solid #0E1F52 !important;
  border-left: none !important;
  border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
  border-left: 2px solid #0E1F52 !important;
  padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
  border-right: 2px solid #0E1F52 !important;
  padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
  color: #ffffff !important;
}
</style>
