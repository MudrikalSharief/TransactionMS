<template>
  <LoadingVeil :show="loading" label="roles" icon="mdi-shield-account" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-shield-account</v-icon>
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
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
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
    <v-card rounded="0">
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
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRoles } from '@/composables/useRoles'
import LoadingVeil from '@/components/LoadingVeil.vue'

const { roles, loading, fetchRoles, createRole, updateRole, deleteRole } = useRoles()

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

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  fetchRoles().catch(() => {})
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
