<template>
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-form-textbox</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Field Definitions</span>
      <v-spacer />
      <v-tooltip location="bottom" max-width="520">
        <template #activator="{ props }">
          <v-btn
            icon="mdi-help-circle-outline"
            variant="text"
            color="grey-darken-3"
            v-bind="props"
            class="mr-1"
          />
        </template>
        <GuideTable title="Column guide" :sections="guideSections" horizontal />
      </v-tooltip>
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add Field
      </v-btn>
    </v-card-title>
    <v-divider />

    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :headers="headers"
        :items="items"
        :loading="loading"
        item-key="id"
        density="compact"
        height="450"
        fixed-header
        :items-per-page="25"
        hover
        class="lgu-table"
      >
        <template v-slot:[`item.validation_rules`]="{ item }">
          <code class="text-caption">{{ stringify(item.validation_rules) }}</code>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end">
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
      <TableLoader v-if="loading" label="fields" icon="mdi-form-textbox" style="flex: 1 1 auto" />
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="900">
    <v-card rounded="0">
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
    <v-card rounded="0">
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
import { computed, onMounted, ref } from 'vue'
import { useFieldDefinitions } from '@/composables/useFieldDefinitions'
import TableLoader from '@/components/TableLoader.vue'
import GuideTable from '@/components/GuideTable.vue'

const { items, loading, fetchAll, create, update, destroy } = useFieldDefinitions()

const error = ref('')
const dialog = ref(false)
const saving = ref(false)

const guideSections = [
    {
        title: 'COLUMNS',
        rows: [
            { term: 'ORDER', text: 'DISPLAY ORDER ON FORMS' },
            { term: 'CODE', text: 'SYSTEM NAME (SNAKE_CASE), USED IN RULES' },
            { term: 'NAME', text: 'LABEL SHOWN TO END USERS' },
            { term: 'TYPE', text: 'TEXT, NUMBER, DATE, SELECT…' },
            { term: 'REQUIRED', text: 'WHETHER IT MUST BE FILLED IN (YES = MANDATORY, NO = OPTIONAL)' },
            { term: 'UNIQUE', text: 'WHETHER THE VALUE MUST NOT REPEAT (YES = NO DUPLICATES)' },
            { term: 'VALIDATION', text: 'EXTRA RULES IN JSON FORMAT' },
        ],
    },
]

const deleteDialog = ref(false)
const deleting = ref(null)
const deletingNow = ref(false)

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

onMounted(fetchAll)
</script>
