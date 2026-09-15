<template>
  <v-card rounded="0" elevation="1" class="lgu-card lgu-card-fill">
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
      <div class="mb-2">
        <v-chip
          color="info"
          variant="tonal"
          rounded="lg"
          size="small"
          class="font-weight-bold"
          style="width: 100%; justify-content: start;"
        >
          <v-icon start size="small">mdi-information</v-icon>
          <span class="cell-truncate">These are configurable “compliance placeholders”. Do NOT hardcode legal text into code. Mark entries “TO VERIFY”.</span>
        </v-chip>
      </div>

      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <Transition name="swap" mode="out-in">
      <v-data-table
        v-if="!loading"
        key="gov-table"
        :items="items"
        :headers="headers"
        :loading="loading"
        item-key="id"
        density="compact"
        height="450"
        fixed-header
        :items-per-page="25"
          hover
          class="lgu-table table-fixed-cols"
        >
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
          <div class="d-flex ga-3 justify-end">
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
      <TableLoader v-else key="gov-loader" label="references" icon="mdi-bank" style="flex: 1 1 auto" />
      </Transition>
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
import { onMounted, ref } from 'vue'
import { useGovernmentReferences } from '@/composables/useGovernmentReferences'
import TableLoader from '@/components/TableLoader.vue'

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

onMounted(fetchAll)
</script>
