<template>
  <LoadingVeil :show="loading" label="users" icon="mdi-account-group" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-account-group</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Users</span>
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
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add User
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
        {{ error }}
      </v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :items="filtered"
        :loading="loading"
        :headers="headers"
        item-key="id"
        density="compact"
        :items-per-page="7"
        :items-per-page-options="[7]"
        hover
        class="lgu-table table-pages"
      >
        <template v-slot:[`item.name`]="{ item }">
          <span class="cell-truncate font-weight-bold" :title="item.name">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.email`]="{ item }">
          <span class="cell-truncate" :title="item.email">{{ item.email }}</span>
        </template>

        <template v-slot:[`item.roles`]="{ item }">
          <v-chip
            v-for="r in item.roles || []"
            :key="r.id"
            rounded="0"
            size="small"
            variant="tonal"
            class="mr-1"
          >
            {{ r.name }}
          </v-chip>
        </template>

        <template v-slot:[`item.office`]="{ item }">
          <v-chip
            v-if="item.office?.name || officeNameById.get(Number(item.office_id))"
            rounded="0"
            size="small"
            variant="tonal"
            color="primary"
            class="font-weight-bold"
          >
            {{ item.office?.name || officeNameById.get(Number(item.office_id)) }}
          </v-chip>
          <span v-else class="text-medium-emphasis">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <v-chip :color="item.is_active ? 'success' : 'error'" rounded="0" size="small" variant="tonal">
            <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
            {{ item.is_active ? 'Active' : 'Inactive' }}
          </v-chip>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end row-actions">
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
              :disabled="item.id === auth.user?.id"
              @click="deactivate(item)"
            />
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="700">
    <v-card rounded="0">
      <v-card-title>{{ form.id ? 'Edit User' : 'New User' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.name" label="Name" />
        <v-text-field v-model="form.email" label="Email" type="email" />

        <v-text-field
          v-model="form.password"
          :label="form.id ? 'New Password (optional)' : 'Password'"
          type="password"
        />

        <v-switch v-model="form.is_active" label="Active" />

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
          v-model="form.office_id"
          :items="officeOptions"
          item-title="label"
          item-value="id"
          label="Office"
          clearable
        />
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
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useRoles } from '@/composables/useRoles'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import LoadingVeil from '@/components/LoadingVeil.vue'

const auth = useAuth()
const { users, loading, fetchUsers, createUser, updateUser, deactivateUser } = useAdminUsers()
const { roles, fetchRoles } = useRoles()
const { items: offices, fetchAll: fetchOffices } = useOffices()

const headers = [
  { title: 'Name', key: 'name' },
  { title: 'Email', key: 'email' },
  { title: 'Roles', key: 'roles', sortable: false },
  { title: 'Office', key: 'office', sortable: false },
  { title: 'Status', key: 'is_active' },
  { title: '', key: 'actions', sortable: false },
]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')

let navObserver = null

// Client-side search: master data is small, filter loaded rows by
// name / email / roles / office / status without extra requests.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return users.value || []
  return (users.value || []).filter((u) =>
    [
      u.name,
      u.email,
      (u.roles || []).map((r) => r.name).join(' '),
      u.office?.name || officeNameById.value.get(Number(u.office_id)) || '',
      u.is_active ? 'active' : 'inactive',
    ].some((v) => String(v || '').toLowerCase().includes(q))
  )
})

const form = ref({
  id: null,
  name: '',
  email: '',
  password: '',
  is_active: true,
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
  form.value = { id: null, name: '', email: '', password: '', is_active: true, role_ids: [], office_id: null }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    name: item.name,
    email: item.email,
    password: '',
    is_active: !!item.is_active,
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
      is_active: form.value.is_active,
      role_ids: form.value.role_ids,
      office_id: form.value.office_id ?? null,
    }
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

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  // Independent lookups: run in parallel so one slow endpoint never blocks
  // the others. Each paints cache first, then revalidates silently.
  fetchRoles().catch(() => {})
  fetchOffices().catch(() => {})
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
</style>
