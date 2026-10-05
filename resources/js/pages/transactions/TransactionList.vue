<template>
  <div>
    <LoadingVeil :show="loading" label="transactions" icon="mdi-swap-horizontal" />
    <v-card rounded="0" elevation="1" class="lgu-card">
      <v-card-title class="d-flex align-center pa-5">
        <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
          <v-icon color="white">mdi-swap-horizontal</v-icon>
        </v-avatar>
        <span class="text-h6 font-weight-bold">Transactions</span>
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
        <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">New Transaction</v-btn>
      </v-card-title>
      <v-divider />

      <v-card-text class="pa-4">
        <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

        <div class="d-flex flex-column table-stage" style="min-height: 510px">
        <v-data-table
          v-show="!loading"
          :headers="headers"
          :items="padded"
          :loading="loading"
          item-key="id"
          density="compact"
          :items-per-page="7"
          :sort-by="[{ key: 'created_at', order: 'desc' }]"
          v-model:page="tablePage"
          hide-default-footer
          hover
          class="lgu-table table-pages"
          :row-props="(item) => (item.__pad ? { class: 'pad-row' } : {})"
          @click:row="(_, row) => { if (!row.item.__pad) go(row.item.id) }"
        >
          <template v-slot:bottom>
            <div class="page-slot">
              <div class="d-flex align-center justify-space-between w-100 pl-4 pr-2">
                <div class="d-flex align-center ga-2">
                  <span class="text-caption text-medium-emphasis font-weight-bold">Items per page:</span>
                  <v-select
                    :model-value="7"
                    :items="[7]"
                    density="compact"
                    variant="outlined"
                    rounded="0"
                    hide-details
                    style="max-width: 76px"
                  />
                  <span class="text-caption text-medium-emphasis">{{ rangeText }}</span>
                </div>
                <v-pagination
                  v-if="meta.lastPage > 1 && !loading"
                  v-model="page"
                  :length="meta.lastPage"
                  :total-visible="5"
                  density="comfortable"
                  @update:model-value="goToPage"
                />
                <v-pagination
                  v-else
                  v-model="tablePage"
                  :length="clientPages"
                  :total-visible="5"
                  density="comfortable"
                />
              </div>
            </div>
          </template>
          <template v-slot:[`item.actions`]="{ item }">
            <div class="row-actions">
              <v-btn
                v-if="isSuperadmin"
                icon="mdi-delete"
                v-tooltip="'Delete transaction'"
                size="small"
                variant="outlined"
                color="error"
                @click.stop="askRemove(item)"
              />
            </div>
          </template>

          <template v-slot:[`item.reference_number`]="{ item }">
            <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
              {{ item.reference_number || `#${item.id}` }}
            </v-chip>
          </template>

          <template v-slot:[`item.title`]="{ item }">
            <span class="cell-truncate font-weight-bold" :title="item.title || ''">{{ item.title || 'N/A' }}</span>
          </template>

          <template v-slot:[`item.type`]="{ item }">
            <v-chip color="info" variant="tonal" rounded="0" size="small" class="tx-chip" :title="item.transaction_type?.name || item.transaction_type_name || ''">
              <span class="tx-chip-text">{{ item.transaction_type?.name || item.transaction_type_name || 'N/A' }}</span>
            </v-chip>
          </template>

          <template v-slot:[`item.office`]="{ item }">
            <span v-if="item.office?.name" class="cell-truncate text-medium-emphasis" :title="item.office.name">
              {{ item.office.name }}
            </span>
            <span v-else class="text-medium-emphasis">—</span>
          </template>

          <template v-slot:[`item.current_step`]="{ item }">
            <v-menu open-on-hover location="end" open-delay="250">
              <template #activator="{ props }">
                <v-chip
                  :color="stepColor(item.current_step)"
                  variant="tonal"
                  rounded="0"
                  size="small"
                  class="tx-chip"
                  :title="item.current_step?.name || item.current_step?.code || ''"
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
          <v-select
            v-model="form.office_id"
            :items="officeOptions"
            item-title="label"
            item-value="id"
            label="Office (optional)"
            clearable
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
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTransactions } from '@/composables/useTransactions'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import { useSmartPoll } from '@/composables/useSmartPoll'
import LoadingVeil from '@/components/LoadingVeil.vue'
import StepProgress from '@/components/StepProgress.vue'

const router = useRouter()
const { items, loading, meta, fetchAll, create, destroy } = useTransactions()
const page = ref(1)
const { items: types, fetchAll: fetchTypes } = useTransactionTypes()
const { items: offices, fetchAll: fetchOffices } = useOffices()
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

let navObserver = null

const form = ref({
  transaction_type_id: null,
  office_id: null,
  title: '',
})

const typeOptions = computed(() =>
  (types.value || []).map(t => ({ id: t.id, label: `${t.name} (${t.code})` }))
)

const officeOptions = computed(() =>
  (offices.value || [])
    .filter(o => o.is_active !== false && o.is_active !== 0)
    .map(o => ({ id: o.id, label: `${o.name} (${o.code})` }))
)

const baseHeaders = [
  { title: 'Ref #', key: 'reference_number' },
  { title: 'Title', key: 'title' },
  { title: 'Transaction Type', key: 'type', sortable: false },
  { title: 'Office', key: 'office', sortable: false },
  { title: 'Current Step', key: 'current_step', sortable: false },
  { title: 'Created', key: 'created_at' },
]

const headers = computed(() =>
  isSuperadmin.value
    ? [{ title: '', key: 'actions', sortable: false }, ...baseHeaders]
    : baseHeaders
)

// Server-filtered: the API already applies ?q= (ref/title) and paginates to
// 25 slim rows, so the table renders one light page instead of filtering
// thousands of heavy rows on a weak CPU. Keeps the `filtered` name so the
// template is untouched.
const filtered = computed(() => items.value || [])

// Client-side page count for the loaded 25-row server chunk at 7/page.
// Server jumps use `page`; in-chunk moves use `tablePage`.
const tablePage = ref(1)
const clientPages = computed(() => Math.max(1, Math.ceil((filtered.value || []).length / 7)))

// Pad short pages with invisible filler rows so every page paints a full
// 7 rows, exactly like full tabs — same density, same card, no perceived
// shortness. Fillers sort last (epoch date), never navigate, never hover,
// and render no content (CSS hides it) while keeping their 60px rhythm.
const padded = computed(() => {
  const rows = filtered.value || []
  if (!rows.length) return rows
  const need = (7 - (rows.length % 7)) % 7
  if (!need) return rows
  return [
    ...rows,
    ...Array.from({ length: need }, (_, i) => ({
      __pad: true,
      id: `__pad-${i}`,
      created_at: '1970-01-01T00:00:00Z',
    })),
  ]
})

// Default-footer style range for the visible chunk: "1–7 of 25".
const rangeText = computed(() => {
  const n = (filtered.value || []).length
  if (!n) return '0 of 0'
  const start = (tablePage.value - 1) * 7 + 1
  return `${start}–${Math.min(tablePage.value * 7, n)} of ${n}`
})

let searchTimer = null
watch(search, () => {
  // Debounced server search: one request per pause, not per keystroke —
  // critical on bad networks. Resets to page 1.
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(async () => {
    page.value = 1
    tablePage.value = 1
    try {
      await fetchAll({ q: search.value, page: 1 })
    } catch {
      /* error banner stays from last load */
    }
  }, 400)
})

async function goToPage(p) {
  page.value = p
  tablePage.value = 1
  try {
    await fetchAll({ q: search.value, page: p })
  } catch {
    /* keep current rows */
  }
}

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
  form.value = { transaction_type_id: null, office_id: null, title: '' }
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
      office_id: form.value.office_id ?? null,
      title: form.value.title || null,
    })
    dialog.value = false
    await fetchAll({ q: search.value, page: page.value })
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
    await fetchAll({ q: search.value, page: page.value })
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  } finally {
    removing.value = false
  }
}

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  // Fire together: each paints its cache synchronously on invocation and
  // revalidates in parallel, so the table never waits behind the lookups.
  fetchTypes().catch(() => {})
  fetchOffices().catch(() => {})
  fetchAll({ q: search.value, page: page.value }).catch(() => {})
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

// Silent 20s smart-poll: refresh rows in place without loader flash,
// page reload, or losing search/sort/pagination/scroll.
useSmartPoll(async () => {
  // Skip while creating/deleting to avoid clobbering the dialogs.
  if (saving.value || removing.value || dialog.value || confirmDialog.value) return
  try {
    await fetchAll({ silent: true, q: search.value, page: page.value })
  } catch {
    /* next tick retries */
  }
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
/* Long titles / offices / chip names truncate to one line (full text on
   hover) so rows always hold the 60px rhythm and the card matches the
   other tabs. Full values remain visible on the detail page. */
.tx-chip :deep(.v-chip__content) {
  max-width: 150px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.tx-chip-text {
  min-width: 0;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
/* Filler rows: full 60px rhythm, zero paint — no hover, no clicks,
   no cell content (hidden but layout-preserving). */
.lgu-table :deep(tr.pad-row) {
  pointer-events: none;
}
.lgu-table :deep(tr.pad-row:hover) {
  background: transparent !important;
}
.lgu-table :deep(tr.pad-row > td > *) {
  visibility: hidden;
}
</style>
