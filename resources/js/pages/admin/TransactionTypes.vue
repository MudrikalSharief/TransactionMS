<template>
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-format-list-bulleted-type</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Transaction Types</span>
      <v-spacer />
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add Transaction Type
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :items="items"
        :headers="headers"
        :loading="loading"
        item-key="id"
        density="compact"
        height="450"
        fixed-header
        :items-per-page="25"
        hover
        class="lgu-table"
      >
        <template v-slot:[`item.steps`]="{ item }">
          <v-progress-circular
            v-if="stepsLoading && !stepsOf(item)"
            indeterminate
            size="16"
            width="2"
            color="grey-darken-3"
          />
          <v-chip
            v-else-if="stepsOf(item)"
            rounded="0"
            size="small"
            variant="tonal"
            color="primary"
            class="font-weight-bold"
            @click="goSteps(item)"
          >
            <v-icon start size="small">mdi-format-list-numbered</v-icon>
            {{ stepsOf(item).count }} steps
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
          <div class="d-flex ga-3 justify-end">
            <v-btn
              icon="mdi-pencil"
              v-tooltip="'Edit transaction type'"
              size="small"
              variant="outlined"
              color="grey-darken-3"
              @click="openEdit(item)"
            />
            <v-btn
              icon="mdi-delete"
              v-tooltip="'Delete transaction type'"
              size="small"
              variant="outlined"
              color="error"
              @click="removeRow(item)"
            />
          </div>
        </template>
      </v-data-table>
      <TableLoader v-if="loading" label="transaction types" icon="mdi-format-list-bulleted-type" style="flex: 1 1 auto" />
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="700">
    <v-card rounded="0">
      <v-card-title>{{ form.id ? 'Edit Transaction Type' : 'New Transaction Type' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.code" label="Code (snake_case)" />
        <v-text-field v-model="form.name" label="Name" />
        <v-textarea v-model="form.description" label="Description" rows="3" />
        <v-switch v-model="form.is_active" label="Active" />
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
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useWorkflows } from '@/composables/useWorkflows'
import TableLoader from '@/components/TableLoader.vue'

const router = useRouter()
const { items, loading, fetchAll, create, update, remove } = useTransactionTypes()
const { defs, loading: defsLoading, fetchDefinitions } = useWorkflows()

const headers = [
  { title: 'Code', key: 'code' },
  { title: 'Name', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: 'Steps', key: 'steps', sortable: false },
  { title: 'Status', key: 'is_active' },
  { title: '', key: 'actions', sortable: false },
]

// Latest workflow version per type → its ordered 1-2-3 steps,
// same steps logic as offices (just versioned per type).
const latestByType = computed(() => {
  const map = {}
  for (const d of (defs.value || [])) {
    const tid = d.transaction_type_id
    if (!map[tid] || Number(d.version) > Number(map[tid].version)) map[tid] = d
  }
  return map
})

function stepsOf(item) {
  const d = latestByType.value[item.id]
  if (!d) return null
  return { version: d.version, status: d.status, count: (d.steps || []).length }
}

const stepsLoading = computed(() => defsLoading.value)

function goSteps(item) {
  router.push(`/admin/workflows?type=${item.id}`)
}

const dialog = ref(false)
const saving = ref(false)
const error = ref('')

const form = ref({ id: null, code: '', name: '', description: '', is_active: true })

function openCreate() {
  error.value = ''
  form.value = { id: null, code: '', name: '', description: '', is_active: true }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    code: item.code,
    name: item.name,
    description: item.description ?? '',
    is_active: !!item.is_active,
  }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    const payload = {
      code: form.value.code,
      name: form.value.name,
      description: form.value.description,
      is_active: form.value.is_active,
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

onMounted(async () => {
  await fetchAll()
  await fetchDefinitions()
})
</script>
