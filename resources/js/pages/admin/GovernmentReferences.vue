<template>
  <LoadingVeil :show="loading" label="references" icon="mdi-bank" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-bank</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Government References</span>
      <v-spacer />
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add Reference
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :items="items"
        :headers="headers"
        :loading="loading"
        item-key="id"
        density="compact"
        :items-per-page="7"
        :items-per-page-options="[7]"
          hover
          class="lgu-table table-pages table-fixed-cols"
        >
          <template v-slot:[`item.code`]="{ item }">
            <span class="cell-truncate" :title="item.code">{{ item.code }}</span>
          </template>

          <template v-slot:[`item.source`]="{ item }">
            <span v-if="item.source" class="cell-truncate" :title="item.source">{{ item.source }}</span>
            <span v-else class="text-medium-emphasis">N/A</span>
          </template>

          <template v-slot:[`item.title`]="{ item }">
            <span v-if="item.title" class="cell-truncate font-weight-bold" v-tooltip="item.title">{{ item.title }}</span>
            <span v-else class="text-medium-emphasis">N/A</span>
          </template>

          <template v-slot:[`item.url`]="{ item }">
            <span v-if="item.url" class="cell-truncate text-grey-darken-3" v-tooltip="item.url">{{ item.url }}</span>
            <span v-else class="text-medium-emphasis">N/A</span>
          </template>

        <template v-slot:[`item.is_verified`]="{ item }">
          <v-chip :color="item.is_verified ? 'success' : 'warning'" rounded="0" size="small" variant="tonal">
            <v-icon start size="small">{{ item.is_verified ? 'mdi-check-circle' : 'mdi-alert-circle' }}</v-icon>
            {{ item.is_verified ? 'Verified' : 'TO VERIFY' }}
          </v-chip>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end row-actions">
            <v-btn
              icon="mdi-pencil"
              v-tooltip="'Edit reference'"
              size="small"
              variant="outlined"
              color="grey-darken-3"
              @click="openEdit(item)"
            />
            <v-btn
              icon="mdi-delete"
              v-tooltip="'Delete reference'"
              size="small"
              variant="outlined"
              color="error"
              @click="removeRow(item)"
            />
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="800">
    <v-card rounded="0">
      <v-card-title>{{ form.id ? 'Edit Reference' : 'New Reference' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.code" label="Code (e.g., RA-9184)" />
        <v-text-field v-model="form.title" label="Title" />
        <v-text-field v-model="form.source" label="Source (RA, IRR, COA, DBM, ...)" />
        <v-text-field v-model="form.url" label="URL (official link if available)" />
        <v-textarea v-model="form.notes" label="Notes" rows="4" />
        <v-switch v-model="form.is_verified" label="Verified (unchecked = TO VERIFY)" />
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
import { onMounted, onUnmounted, ref } from 'vue'
import { useGovernmentReferences } from '@/composables/useGovernmentReferences'
import LoadingVeil from '@/components/LoadingVeil.vue'

const { items, loading, fetchAll, create, update, remove } = useGovernmentReferences()

const headers = [
  { title: 'Code', key: 'code', width: 150 },
  { title: 'Title', key: 'title' },
  { title: 'Source', key: 'source', width: 130 },
  { title: 'URL', key: 'url', width: 200 },
  { title: 'Status', key: 'is_verified', width: 130 },
  { title: '', key: 'actions', sortable: false, width: 110, align: 'end' },
]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')

let navObserver = null

const form = ref({
  id: null,
  code: '',
  title: '',
  source: '',
  url: '',
  notes: '',
  is_verified: false,
})

function openCreate() {
  error.value = ''
  form.value = { id: null, code: '', title: '', source: '', url: '', notes: '', is_verified: false }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    code: item.code,
    title: item.title,
    source: item.source ?? '',
    url: item.url ?? '',
    notes: item.notes ?? '',
    is_verified: !!item.is_verified,
  }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    const payload = {
      code: form.value.code,
      title: form.value.title,
      source: form.value.source || null,
      url: form.value.url || null,
      notes: form.value.notes || null,
      is_verified: form.value.is_verified,
    }

    if (form.value.id) await update(form.value.id, payload)
    else await create(payload)

    dialog.value = false
    await fetchAll()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Save failed.'
  } finally {
    saving.value = false
  }
}

async function removeRow(item) {
  error.value = ''
  try {
    await remove(item.id)
    await fetchAll()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  }
}

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  fetchAll().catch(() => {})
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
/* Stable paged table: header widths use the full width, drawer
   expand/collapse can never create a visible horizontal scrollbar —
   overflow is clipped, not scrolled. */
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
/* Row actions stay visible normally. They only duck away (with a quick
   blink) while the left navbar is expanded so the narrower table never
   cuts them off. Space is reserved. */
.row-actions {
  opacity: 1;
  visibility: visible;
  min-width: 76px;
  justify-content: flex-end;
  transition: opacity 0.18s ease, visibility 0.18s ease;
}
html.nav-open .row-actions {
  opacity: 0;
  visibility: hidden;
  animation: action-blink-out 0.45s ease;
}
@keyframes action-blink-out {
  0% { opacity: 1; }
  30% { opacity: 0; }
  55% { opacity: 0.7; }
  100% { opacity: 0; }
}

/* Pin the "Items per page" footer to the bottom of the stage so it
   never shifts up when there are few entries. */
.table-stage {
  min-width: 0;
}
.table-stage :deep(.lgu-table) {
  flex: 1 1 auto;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.table-stage :deep(.v-data-table-footer) {
  margin-top: auto;
}
</style>
