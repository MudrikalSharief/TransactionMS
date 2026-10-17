<template>
  <LoadingVeil :show="loading" label="roles" icon="mdi-shield-account" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#1E40AF">mdi-shield-account</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Roles</span>
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
      <v-btn variant="outlined" color="primary" rounded="0" prepend-icon="mdi-plus" height="40" @click="openCreate">
        Add Role
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
        <template v-slot:[`item.code`]="{ item }">
          <span class="cell-truncate" :title="item.code">{{ item.code }}</span>
        </template>

        <template v-slot:[`item.name`]="{ item }">
          <span class="cell-truncate font-weight-bold" :title="item.name">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.description`]="{ item }">
          <span class="cell-truncate text-medium-emphasis" :title="item.description || ''">{{ item.description || '—' }}</span>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end row-actions">
            <v-btn
              icon="mdi-shield-key-outline"
              v-tooltip="'Permissions'"
              size="small"
              variant="outlined"
              color="primary"
              :disabled="item.code === 'superadmin'"
              @click="openPermissions(item)"
            />
            <v-btn
              icon="mdi-pencil"
              v-tooltip="'Edit role'"
              size="small"
              variant="outlined"
              color="grey-darken-3"
              @click="openEdit(item)"
            />
            <v-btn
              icon="mdi-delete"
              v-tooltip="'Delete role'"
              size="small"
              variant="outlined"
              color="error"
              :disabled="item.code === 'superadmin'"
              @click="remove(item)"
            />
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="600">
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title>{{ form.id ? 'Edit Role' : 'New Role' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.code" label="Code (snake_case)" />
        <v-text-field v-model="form.name" label="Name" />
        <v-textarea v-model="form.description" label="Description" rows="3" />
      </v-card-text>
      <v-divider />
      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
        <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="save">Save</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog v-model="permDialog" max-width="640" scrollable>
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title>Permissions — {{ permRole?.name }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-alert v-if="permError" type="error" variant="tonal" class="mb-3">{{ permError }}</v-alert>
        <div v-for="g in permGroups" :key="g.module" class="perm-row">
          <span class="text-body-2 font-weight-bold">{{ g.label }}</span>
          <div class="d-flex ga-6">
            <v-switch
              v-if="g.view"
              :model-value="permCodes.has(g.view.code)"
              label="View"
              color="primary"
              density="compact"
              hide-details
              @update:model-value="(v) => togglePerm(g.view.code, v)"
            />
            <v-switch
              v-if="g.manage"
              :model-value="permCodes.has(g.manage.code)"
              label="Manage"
              color="primary"
              density="compact"
              hide-details
              @update:model-value="(v) => togglePerm(g.manage.code, v)"
            />
          </div>
        </div>
      </v-card-text>
      <v-divider />
      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="permDialog = false">Cancel</v-btn>
        <v-btn color="grey-darken-3" rounded="0" :loading="permSaving" @click="savePermissions">Save</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useApi } from '@/composables/useApi'
import { useRoles } from '@/composables/useRoles'
import LoadingVeil from '@/components/LoadingVeil.vue'

const { api } = useApi()
const { roles, loading, fetchRoles, createRole, updateRole, deleteRole, syncPermissions } = useRoles()

const headers = [
  { title: 'Code', key: 'code' },
  { title: 'Name', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: '', key: 'actions', sortable: false },
]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')

let navObserver = null

// Client-side search: master data is small, filter loaded rows by
// code / name / description without extra requests.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return roles.value || []
  return (roles.value || []).filter((r) =>
    [r.code, r.name, r.description].some((v) => String(v || '').toLowerCase().includes(q))
  )
})

const form = ref({ id: null, code: '', name: '', description: '' })

function openCreate() {
  error.value = ''
  form.value = { id: null, code: '', name: '', description: '' }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = { id: item.id, code: item.code, name: item.name, description: item.description ?? '' }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    if (form.value.id) {
      await updateRole(form.value.id, {
        code: form.value.code,
        name: form.value.name,
        description: form.value.description,
      })
    } else {
      await createRole({
        code: form.value.code,
        name: form.value.name,
        description: form.value.description,
      })
    }
    dialog.value = false
    await fetchRoles()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Save failed.'
  } finally {
    saving.value = false
  }
}

async function remove(item) {
  error.value = ''
  try {
    await deleteRole(item.id)
    await fetchRoles()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  }
}

const permissions = ref([])
const permDialog = ref(false)
const permRole = ref(null)
const permCodes = ref(new Set())
const permSaving = ref(false)
const permError = ref('')

const MODULE_LABELS = {
  dashboard: 'Dashboard',
  transactions: 'Transactions',
  transaction_types: 'Transaction Types',
  users: 'Users',
  roles: 'Roles',
  offices: 'Offices',
  workflows: 'Workflows',
  fields: 'Fields',
  requirements: 'Requirements',
  government_references: 'Government References',
}

const permGroups = computed(() => {
  const map = new Map()
  for (const p of permissions.value || []) {
    const module = String(p.code).split('.')[0]
    if (!map.has(module)) {
      map.set(module, { module, label: MODULE_LABELS[module] || module, view: null, manage: null })
    }
    const group = map.get(module)
    if (String(p.code).endsWith('.view')) group.view = p
    else if (String(p.code).endsWith('.manage')) group.manage = p
  }
  return [...map.values()]
})

function openPermissions(item) {
  permError.value = ''
  permRole.value = item
  permCodes.value = new Set(item.permission_codes || [])
  permDialog.value = true
}

function togglePerm(code, on) {
  const set = new Set(permCodes.value)
  if (on) {
    set.add(code)
    if (code.endsWith('.manage')) set.add(`${code.slice(0, -7)}.view`)
  } else {
    set.delete(code)
    if (code.endsWith('.view')) set.delete(`${code.slice(0, -5)}.manage`)
  }
  permCodes.value = set
}

async function savePermissions() {
  permSaving.value = true
  permError.value = ''
  try {
    await syncPermissions(permRole.value.id, [...permCodes.value])
    permDialog.value = false
    await fetchRoles()
  } catch (e) {
    permError.value = e?.response?.data?.message || 'Save failed.'
  } finally {
    permSaving.value = false
  }
}

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  fetchRoles().catch(() => {})
  api.get('/api/admin/permissions')
    .then((res) => { permissions.value = res.data.data ?? res.data })
    .catch(() => {})
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
.perm-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 4px 0;
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
  background-color: #1E3A8A !important;
  color: #ffffff !important;
  border-top: 2px solid #1E3A8A !important;
  border-bottom: 3px solid #1E3A8A !important;
  border-left: none !important;
  border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
  border-left: 2px solid #1E3A8A !important;
  padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
  border-right: 2px solid #1E3A8A !important;
  padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
  color: #ffffff !important;
}
</style>
