<template>
  <LoadingVeil :show="loading" label="fields" icon="mdi-form-textbox" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#1E40AF">mdi-form-textbox</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Field Definitions</span>
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
        Add Field
      </v-btn>
    </v-card-title>
    <v-divider />

    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :headers="headers"
        :items="filtered"
        :loading="loading"
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

        <template v-slot:[`item.type`]="{ item }">
          <span class="cell-truncate" :title="item.type">{{ item.type }}</span>
        </template>

        <template v-slot:[`item.validation_rules`]="{ item }">
          <code class="text-caption validation-cap" :title="stringify(item.validation_rules)">{{ stringify(item.validation_rules) }}</code>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end row-actions">
            <v-btn
              icon="mdi-pencil"
              v-tooltip="'Edit field'"
              size="small"
              variant="outlined"
              color="grey-darken-3"
              @click="openEdit(item)"
            />
            <v-btn
              icon="mdi-delete"
              v-tooltip="'Delete field'"
              size="small"
              variant="outlined"
              color="error"
              @click="confirmDelete(item)"
            />
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="900">
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title>{{ form.id ? 'Edit Field' : 'Create Field' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field v-model="form.code" label="Code (snake_case)" />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field v-model="form.name" label="Name" />
          </v-col>
          <v-col cols="12" md="4">
            <v-select
              v-model="form.type"
              :items="typeOptions"
              label="Type"
            />
          </v-col>

          <v-col cols="12" md="4">
            <v-text-field v-model.number="form.order_number" type="number" label="Order # (default)" />
          </v-col>

          <v-col cols="12" md="4">
            <v-select v-model="form.required" :items="[true,false]" label="Required (default)" />
          </v-col>

          <v-col cols="12" md="4">
            <v-select v-model="form.unique" :items="[true,false]" label="Unique (default)" />
          </v-col>

          <v-col cols="12" md="4">
            <v-text-field v-model.number="form.min_length" type="number" label="Min Length" />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field v-model.number="form.max_length" type="number" label="Max Length" />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field v-model.number="form.min_value" type="number" label="Min Value" />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field v-model.number="form.max_value" type="number" label="Max Value" />
          </v-col>

          <v-col cols="12" md="4">
            <v-text-field v-model="form.group" label="Group (optional)" />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field v-model="form.step_scope" label="Step Scope (optional)" />
          </v-col>

          <v-col cols="12">
            <v-textarea
              v-model="validationRulesText"
              rows="5"
              label="Validation Rules JSON (optional)"
              hint='Example: {"required_if":[{"field":"amount","op":">","value":5000}]}'
              persistent-hint
            />
          </v-col>

          <v-col cols="12">
            <v-textarea
              v-model="optionsText"
              rows="4"
              label="Options JSON for select/multiselect (optional)"
              hint='Example: [{"label":"Yes","value":"yes"},{"label":"No","value":"no"}]'
              persistent-hint
            />
          </v-col>
        </v-row>
      </v-card-text>

      <v-divider />

      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="dialog=false">Cancel</v-btn>
        <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="save">Save</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog v-model="deleteDialog" max-width="520">
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title>Delete Field</v-card-title>
      <v-divider />
      <v-card-text>
        Delete <b>{{ deleting?.name }}</b> ({{ deleting?.code }})?
        <div class="text-caption mt-2">
          This removes the definition. Any already-stored field values remain in DB but won’t render correctly.
          Don’t delete fields used in active workflows unless you enjoy pain.
        </div>
      </v-card-text>
      <v-divider />
      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="deleteDialog=false">Cancel</v-btn>
        <v-btn color="error" rounded="0" :loading="deletingNow" @click="doDelete">Delete</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useFieldDefinitions } from '@/composables/useFieldDefinitions'
import LoadingVeil from '@/components/LoadingVeil.vue'

const { items, loading, fetchAll, create, update, destroy } = useFieldDefinitions()

const error = ref('')
const dialog = ref(false)
const saving = ref(false)
const search = ref('')

// Client-side search: master data is small, filter loaded rows by
// order / code / name / type / group without extra requests.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return items.value || []
  return (items.value || []).filter((f) =>
    [f.order_number, f.code, f.name, f.type, f.group]
      .some((v) => String(v ?? '').toLowerCase().includes(q))
  )
})

const deleteDialog = ref(false)
const deleting = ref(null)
const deletingNow = ref(false)

let navObserver = null

const typeOptions = ['text', 'number', 'date', 'datetime', 'select', 'multiselect', 'boolean', 'textarea']

const headers = [
  // { title: 'ID', key: 'id' },
  { title: 'Order', key: 'order_number' },
  { title: 'Code', key: 'code' },
  { title: 'Name', key: 'name' },
  { title: 'Type', key: 'type' },
  { title: 'Required', key: 'required' },
  { title: 'Unique', key: 'unique' },
  { title: 'Validation', key: 'validation_rules', sortable: false },
  { title: '', key: 'actions', sortable: false },
]

const form = ref({
  id: null,
  order_number: 0,
  code: '',
  name: '',
  type: 'text',
  step_scope: null,
  group: null,
  required: false,
  unique: false,
  sensitive: false,
  min_length: null,
  max_length: null,
  min_value: null,
  max_value: null,
  options: null,
  validation_rules: null,
})

const validationRulesText = ref('')
const optionsText = ref('')

function resetForm() {
  form.value = {
    id: null,
    order_number: 0,
    code: '',
    name: '',
    type: 'text',
    step_scope: null,
    group: null,
    required: false,
    unique: false,
    sensitive: false,
    min_length: null,
    max_length: null,
    min_value: null,
    max_value: null,
    options: null,
    validation_rules: null,
  }
  validationRulesText.value = ''
  optionsText.value = ''
}

function openCreate() {
  resetForm()
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = { ...form.value, ...item, id: item.id }
  validationRulesText.value = item.validation_rules ? JSON.stringify(item.validation_rules, null, 2) : ''
  optionsText.value = item.options ? JSON.stringify(item.options, null, 2) : ''
  dialog.value = true
}

function confirmDelete(item) {
  deleting.value = item
  deleteDialog.value = true
}

function parseJsonOrNull(text) {
  if (!text || !text.trim()) return null
  return JSON.parse(text)
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    const payload = {
      order_number: Number(form.value.order_number ?? 0),
      code: form.value.code,
      name: form.value.name,
      type: form.value.type,
      step_scope: form.value.step_scope || null,
      group: form.value.group || null,
      required: !!form.value.required,
      unique: !!form.value.unique,
      sensitive: !!form.value.sensitive,
      min_length: form.value.min_length === '' ? null : form.value.min_length,
      max_length: form.value.max_length === '' ? null : form.value.max_length,
      min_value: form.value.min_value === '' ? null : form.value.min_value,
      max_value: form.value.max_value === '' ? null : form.value.max_value,
      options: parseJsonOrNull(optionsText.value),
      validation_rules: parseJsonOrNull(validationRulesText.value),
    }

    if (form.value.id) {
      await update(form.value.id, payload)
    } else {
      await create(payload)
    }

    dialog.value = false
    await fetchAll()
  } catch (e) {
    error.value =
      e?.response?.data?.message ||
      (e?.response?.data?.errors ? JSON.stringify(e.response.data.errors) : 'Save failed.')
  } finally {
    saving.value = false
  }
}

async function doDelete() {
  deletingNow.value = true
  error.value = ''
  try {
    await destroy(deleting.value.id)
    deleteDialog.value = false
    deleting.value = null
    await fetchAll()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  } finally {
    deletingNow.value = false
  }
}

function stringify(v) {
  if (!v) return ''
  try { return JSON.stringify(v) } catch { return String(v) }
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
/* Stable paged table: auto layout uses the full width, drawer
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
.lgu-table :deep(table) {
  width: 100%;
}
/* Long validation JSON truncates instead of blowing out the layout. */
.validation-cap {
  display: inline-block;
  max-width: 220px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  vertical-align: middle;
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
