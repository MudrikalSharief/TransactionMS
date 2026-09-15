<template>
  <div>
    <v-card rounded="0" elevation="1" class="lgu-card mb-4">
      <v-card-title class="d-flex align-center pa-5">
        <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
          <v-icon color="white">mdi-office-building-outline</v-icon>
        </v-avatar>
        <div>
          <span class="text-h6 font-weight-bold">{{ office?.name || 'Office Steps' }}</span>
          <div v-if="office" class="text-caption text-medium-emphasis font-weight-bold">
            {{ office.code }} · hierarchy 1 - 2 - 3
          </div>
        </div>
        <v-spacer />
        <v-btn variant="text" @click="$router.push('/admin/offices')">Back</v-btn>
        <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
          Add Step
        </v-btn>
      </v-card-title>
    </v-card>

    <v-card rounded="0" elevation="1" class="lgu-card">
      <v-card-text class="pa-4">
        <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>
        <v-alert v-if="!steps.length && !loading" type="info" variant="tonal" class="mb-3">
          No steps yet — add step 1, 2, 3… in hierarchy order.
        </v-alert>

        <div class="d-flex flex-column" style="min-height: 458px">
        <v-data-table
          v-show="!loading"
          :items="flatSteps"
          :headers="headers"
          :loading="loading"
          item-key="id"
          density="compact"
          :items-per-page="7"
          hover
          class="lgu-table table-pages"
        >
          <template v-slot:[`item.order_number`]="{ item }">
            <v-chip rounded="0" size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
              {{ item._num }}
            </v-chip>
          </template>

          <template v-slot:[`item.name`]="{ item }">
            <div class="d-flex align-center" :style="`padding-left: ${item._depth * 28}px`">
              <v-icon v-if="item._depth > 0" size="small" color="grey" class="mr-1">mdi-subdirectory-arrow-right</v-icon>
              <span class="font-weight-medium">{{ item.name }}</span>
            </div>
            <div v-if="item.parent_name" class="text-caption text-medium-emphasis" :style="`padding-left: ${item._depth * 28 + 22}px`">
              sub of {{ item.parent_name }}
            </div>
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
                v-tooltip="'Edit step'"
                size="small"
                variant="outlined"
                color="grey-darken-3"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-delete"
                v-tooltip="'Delete step'"
                size="small"
                variant="outlined"
                color="error"
                @click="removeRow(item)"
              />
            </div>
          </template>
        </v-data-table>
        <TableLoader v-if="loading" label="office steps" icon="mdi-format-list-numbered" style="flex: 1 1 auto" />
        </div>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialog" max-width="700">
      <v-card rounded="0">
        <v-card-title>{{ form.id ? 'Edit Step' : 'New Step' }}</v-card-title>
        <v-divider />
        <v-card-text>
          <v-text-field v-model.number="form.order_number" type="number" label="Order # (1 - 2 - 3)" min="1" />
          <v-select
            v-model="form.parent_id"
            :items="parentOptions"
            item-title="label"
            item-value="id"
            label="Parent step (empty = top level)"
            :hint="!parentOptions.length ? 'No steps yet — save this as the first top-level step, then nest others under it.' : ''"
            persistent-hint
            clearable
          />
          <v-text-field v-model="form.name" label="Office Name of this step" />
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
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { useOffices } from '@/composables/useOffices'
import TableLoader from '@/components/TableLoader.vue'

const route = useRoute()
const officeId = route.params.officeId
const { items, fetchAll, fetchSteps, createStep, updateStep, removeStep } = useOffices()

const office = ref(null)
const steps = ref([])
const loading = ref(true)

const headers = [
  { title: '#', key: 'order_number' },
  { title: 'Code', key: 'code' },
  { title: 'Office Name', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: 'Status', key: 'is_active' },
  { title: '', key: 'actions', sortable: false },
]

// Hierarchy: flat API rows → depth-first tree → flat display rows
// with dotted numbers (1, 1.1, 1.2, 2…). Editable afterwards.
const flatSteps = computed(() => {
  const list = steps.value || []
  const byId = new Map(list.map((s) => [s.id, s]))
  const byParent = new Map()
  for (const s of list) {
    const key = s.parent_id ?? 0
    if (!byParent.has(key)) byParent.set(key, [])
    byParent.get(key).push(s)
  }
  for (const arr of byParent.values()) {
    arr.sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0))
  }
  const out = []
  const walk = (parentKey, depth, prefix) => {
    for (const s of (byParent.get(parentKey) || [])) {
      const num = prefix ? `${prefix}.${s.order_number}` : `${s.order_number}`
      out.push({
        ...s,
        _depth: depth,
        _num: num,
        parent_name: s.parent_id ? byId.get(s.parent_id)?.name ?? null : null,
      })
      walk(s.id, depth + 1, num)
    }
  }
  walk(0, 0, '')
  for (const s of list) {
    if (s.parent_id && !byId.has(s.parent_id) && !out.some((r) => r.id === s.id)) {
      out.push({ ...s, _depth: 0, _num: `${s.order_number}`, parent_name: null })
    }
  }
  return out
})

function descendantsOf(id) {
  const ids = new Set([id])
  let grew = true
  while (grew) {
    grew = false
    for (const s of (steps.value || [])) {
      if (s.parent_id && ids.has(s.parent_id) && !ids.has(s.id)) {
        ids.add(s.id)
        grew = true
      }
    }
  }
  return ids
}

// Parent picker: every step except self + own sub-steps (would cycle).
const parentOptions = computed(() => {
  const banned = form.value.id ? descendantsOf(form.value.id) : new Set()
  return flatSteps.value
    .filter((s) => !banned.has(s.id))
    .map((s) => ({ id: s.id, label: `${s._num} · ${s.name}` }))
})

const dialog = ref(false)
const saving = ref(false)
const error = ref('')

const form = ref({ id: null, order_number: 1, parent_id: null, name: '', description: '', is_active: true })

async function load() {
  loading.value = true
  error.value = ''
  try {
    await fetchAll()
    office.value = (items.value || []).find(o => String(o.id) === String(officeId)) ?? null
    steps.value = await fetchSteps(officeId)
  } catch (e) {
    error.value = e?.response?.data?.message || 'Failed to load steps.'
  } finally {
    loading.value = false
  }
}

function openCreate() {
  error.value = ''
  const topLevel = (steps.value || []).filter((s) => !s.parent_id)
  const next = topLevel.reduce((m, s) => Math.max(m, Number(s.order_number) || 0), 0) + 1
  form.value = { id: null, order_number: next, parent_id: null, name: '', description: '', is_active: true }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    order_number: item.order_number,
    parent_id: item.parent_id ?? null,
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
      parent_id: form.value.parent_id ?? null,
      order_number: Number(form.value.order_number || 1),
      name: form.value.name,
      description: form.value.description,
      is_active: form.value.is_active,
    }
    if (form.value.id) await updateStep(officeId, form.value.id, payload)
    else await createStep(officeId, payload)
    dialog.value = false
    steps.value = await fetchSteps(officeId)
  } catch (e) {
    error.value = e?.response?.data?.message || 'Save failed.'
  } finally {
    saving.value = false
  }
}

async function removeRow(item) {
  error.value = ''
  try {
    await removeStep(officeId, item.id)
    steps.value = await fetchSteps(officeId)
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  }
}

onMounted(load)
</script>
