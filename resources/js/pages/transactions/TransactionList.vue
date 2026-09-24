<template>
  <div>
    <v-card rounded="0" elevation="1" class="lgu-card">
      <v-card-title class="d-flex align-center pa-5">
        <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
          <v-icon color="white">mdi-swap-horizontal</v-icon>
        </v-avatar>
        <span class="text-h6 font-weight-bold">Transactions</span>
        <v-spacer />
        <v-tooltip location="bottom" max-width="480">
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
        <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">New Transaction</v-btn>
      </v-card-title>
      <v-divider />

      <v-card-text class="pa-4">
        <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

        <v-text-field
          v-model="search"
          prepend-inner-icon="mdi-magnify"
          label="Search . . ."
          variant="outlined"
          density="compact"
          rounded="0"
          hide-details
          clearable
          class="mb-3"
          style="max-width: 420px"
        />

        <div class="d-flex flex-column" style="min-height: 458px">
        <v-data-table
          v-show="!loading"
          :headers="headers"
          :items="filtered"
          :loading="loading"
          item-key="id"
          density="compact"
          height="398"
          fixed-header
          :items-per-page="25"
          :sort-by="[{ key: 'created_at', order: 'desc' }]"
          hover
          class="lgu-table table-search"
          @click:row="(_, row) => go(row.item.id)"
        >
          <template v-slot:[`item.actions`]="{ item }">
            <v-btn
              v-if="isSuperadmin"
              icon="mdi-delete"
              v-tooltip="'Delete transaction'"
              size="small"
              variant="outlined"
              color="error"
              @click.stop="askRemove(item)"
            />
          </template>

          <template v-slot:[`item.reference_number`]="{ item }">
            <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
              {{ item.reference_number || `#${item.id}` }}
            </v-chip>
          </template>

          <template v-slot:[`item.title`]="{ item }">
            <span class="font-weight-bold">{{ item.title || 'N/A' }}</span>
          </template>

          <template v-slot:[`item.type`]="{ item }">
            <v-chip color="info" variant="tonal" rounded="0" size="small">
              <v-icon start size="small">mdi-tag-outline</v-icon>
              {{ item.transaction_type?.name || item.transaction_type_name || 'N/A' }}
            </v-chip>
          </template>

          <template v-slot:[`item.current_step`]="{ item }">
            <v-menu open-on-hover location="end" open-delay="250">
              <template #activator="{ props }">
                <v-chip
                  :color="stepColor(item.current_step)"
                  variant="tonal"
                  rounded="0"
                  size="small"
                  v-bind="props"
                >
                  <v-icon start size="small">{{ stepIcon(item.current_step) }}</v-icon>
                  {{ item.current_step?.name || item.current_step?.code || 'Unassigned' }}
                </v-chip>
                <v-chip
                  v-if="item.is_done"
                  color="success"
                  variant="flat"
                  rounded="0"
                  size="small"
                  class="ml-1"
                >
                  <v-icon start size="small">mdi-flag-checkered</v-icon>
                  Done
                </v-chip>
              </template>
              <StepProgress
                :steps="item.workflow_steps"
                :current-step-id="item.current_step?.id"
                :current-step-code="item.current_step?.code"
                :title="item.current_step?.name || item.current_step?.code || 'Unassigned'"
              />
            </v-menu>
          </template>

          <template v-slot:[`item.created_at`]="{ item }">
            <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
            <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
          </template>
        </v-data-table>
        <TableLoader v-if="loading" label="transactions" icon="mdi-swap-horizontal" style="flex: 1 1 auto" />
        </div>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialog" max-width="700">
      <v-card rounded="0">
        <v-card-title>New Transaction</v-card-title>
        <v-divider />
        <v-card-text>
          <v-select
            v-model="form.transaction_type_id"
            :items="typeOptions"
            item-title="label"
            item-value="id"
            label="Transaction Type"
          />
          <v-text-field v-model="form.title" label="Title (optional)" />
          <v-alert type="info" variant="tonal" class="mt-3">
            Transaction will follow the <b>current steps</b> for the chosen type.
          </v-alert>
        </v-card-text>
        <v-divider />
        <v-card-actions class="justify-end">
          <v-btn variant="text" @click="dialog=false">Cancel</v-btn>
          <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="createTx">Create</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="confirmDialog" max-width="500">
      <v-card rounded="0">
        <v-card-title>Delete transaction?</v-card-title>
        <v-divider />
        <v-card-text>
          Delete <b>{{ removeTarget?.reference_number || `#${removeTarget?.id}` }}</b><span v-if="removeTarget?.title"> — {{ removeTarget.title }}</span>?
          This removes it from the list (kept as soft-deleted history).
        </v-card-text>
        <v-divider />
        <v-card-actions class="justify-end">
          <v-btn variant="text" @click="confirmDialog=false">Cancel</v-btn>
          <v-btn color="error" rounded="0" :loading="removing" @click="removeTx">Delete</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useTransactions } from '@/composables/useTransactions'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useAuth } from '@/composables/useAuth'
import TableLoader from '@/components/TableLoader.vue'
import StepProgress from '@/components/StepProgress.vue'
import GuideTable from '@/components/GuideTable.vue'

const router = useRouter()
const { items, loading, fetchAll, create, destroy } = useTransactions()
const { items: types, fetchAll: fetchTypes } = useTransactionTypes()
const auth = useAuth()

const isSuperadmin = computed(() =>
  (auth.user.value?.roles || []).some((r) => r.code === 'superadmin')
)

const dialog = ref(false)
const confirmDialog = ref(false)
const removeTarget = ref(null)
const removing = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')

const guideSections = [
  {
    title: 'COLUMNS',
    rows: [
      { term: 'DELETE', text: 'REMOVE THE REQUEST (SOFT-DELETED, KEPT IN HISTORY)' },
      { term: 'REF #', text: 'UNIQUE TRACKING CODE — QUOTE IT WHEN FOLLOWING UP' },
      { term: 'TITLE', text: 'SHORT NAME OF THE REQUEST' },
      { term: 'TRANSACTION TYPE', text: 'WHAT KIND OF REQUEST IT IS' },
      { term: 'CURRENT STEP', text: 'WHERE IT IS RIGHT NOW (HOVER THE CHIP FOR PROGRESS)' },
      { term: 'CREATED', text: 'WHEN THE REQUEST WAS SUBMITTED' },
    ],
  },
]

const form = ref({
  transaction_type_id: null,
  title: '',
})

const typeOptions = computed(() =>
  (types.value || []).map(t => ({ id: t.id, label: `${t.name} (${t.code})` }))
)

const baseHeaders = [
  { title: 'Ref #', key: 'reference_number' },
  { title: 'Title', key: 'title' },
  { title: 'Transaction Type', key: 'type', sortable: false },
  { title: 'Current Step', key: 'current_step', sortable: false },
  { title: 'Created', key: 'created_at' },
]

const headers = computed(() =>
  isSuperadmin.value
    ? [{ title: '', key: 'actions', sortable: false }, ...baseHeaders]
    : baseHeaders
)

const filtered = computed(() => {
  const q = search.value.trim().toLowerCase()
  if (!q) return items.value || []
  return (items.value || []).filter((tx) =>
    [
      tx.reference_number,
      tx.title,
      tx.transaction_type?.name,
      tx.transaction_type_name,
      tx.current_step?.name,
      tx.current_step?.code,
    ]
      .filter(Boolean)
      .join(' ')
      .toLowerCase()
      .includes(q)
  )
})

function stepColor(step) {
  if (!step) return 'grey'
  if (step.is_end) return 'success'
  if (step.is_start) return 'teal'
  return 'primary'
}

function stepIcon(step) {
  if (!step) return 'mdi-help-circle-outline'
  if (step.is_end) return 'mdi-flag-checkered'
  if (step.is_start) return 'mdi-play'
  return 'mdi-dots-horizontal-circle-outline'
}

function fmtDate(iso) {
  if (!iso) return 'N/A'
  return new Date(iso).toLocaleDateString('en-PH', {
    timeZone: 'Asia/Manila',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

function timeAgo(iso) {
  if (!iso) return ''
  const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000)
  if (s < 60) return 'just now'
  if (s < 3600) return `${Math.floor(s / 60)}m ago`
  if (s < 86400) return `${Math.floor(s / 3600)}h ago`
  if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`
  return fmtDate(iso)
}

function openCreate() {
  error.value = ''
  form.value = { transaction_type_id: null, title: '' }
  dialog.value = true
}

function go(id) {
  router.push(`/transactions/${id}`)
}

async function createTx() {
  saving.value = true
  error.value = ''
  try {
    const tx = await create({
      transaction_type_id: form.value.transaction_type_id,
      title: form.value.title || null,
    })
    dialog.value = false
    await fetchAll()
    go(tx.id)
  } catch (e) {
    error.value = e?.response?.data?.message || 'Create failed.'
  } finally {
    saving.value = false
  }
}

function askRemove(item) {
  error.value = ''
  removeTarget.value = item
  confirmDialog.value = true
}

async function removeTx() {
  if (!removeTarget.value) return
  removing.value = true
  error.value = ''
  try {
    await destroy(removeTarget.value.id)
    confirmDialog.value = false
    removeTarget.value = null
    await fetchAll()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  } finally {
    removing.value = false
  }
}

onMounted(async () => {
  await fetchTypes()
  await fetchAll()
})
</script>
