<template>
  <div>
    <LoadingVeil :show="loading" label="transactions" icon="mdi-swap-horizontal" />
    <v-card rounded="0" elevation="0" class="tl-page mb-4">
      <header class="tl-hd">
        <div class="tl-badge" aria-hidden="true">
          <v-icon size="26">mdi-swap-horizontal</v-icon>
        </div>
        <div class="tl-hd-main">
          <h1 class="tl-title">Transactions</h1>
          <p class="tl-sub">
            The transactions moving through your offices, and where each one
            is in its workflow.
          </p>
        </div>
        <div class="tl-tools">
          <div class="tl-search" role="search">
            <v-icon class="tl-search-icon" size="19">mdi-magnify</v-icon>
            <input
              v-model="search"
              type="search"
              class="tl-search-input"
              placeholder="Search reference or title"
              aria-label="Search transactions"
              autocomplete="off"
            />
            <button
              v-if="search"
              type="button"
              class="tl-clear"
              aria-label="Clear search"
              @click="clearSearch"
            >
              <v-icon size="16">mdi-close</v-icon>
            </button>
          </div>
          <button
            v-if="canManage"
            type="button"
            class="tl-add"
            aria-label="New transaction"
            @click="openCreate"
          >
            <v-icon size="18">mdi-plus</v-icon>
            <span class="tl-add-label">New transaction</span>
          </button>
        </div>
      </header>

      <v-alert
        v-if="error"
        type="error"
        variant="tonal"
        rounded="0"
        class="tl-alert"
      >
        {{ error }}
      </v-alert>

      <div class="tl-wrap">
        <v-data-table
          v-show="!loading"
          :headers="headers"
          :items="filtered"
          :loading="loading"
          item-key="id"
          :items-per-page="8"
          :sort-by="[{ key: 'created_at', order: 'desc' }]"
          v-model:page="tablePage"
          :hide-default-footer="true"
          hover
          class="tl-table"
          @click:row="(_, row) => go(row.item.id)"
        >
          <template v-slot:[`item.reference_number`]="{ item }">
            <v-chip color="primary" variant="tonal" rounded="0" size="small" class="font-weight-bold">
              {{ item.reference_number || `#${item.id}` }}
            </v-chip>
          </template>

          <template v-slot:[`item.title`]="{ item }">
            <span class="tl-name" :title="item.title || ''">{{ item.title || 'N/A' }}</span>
          </template>

          <template v-slot:[`item.type`]="{ item }">
            <v-chip color="info" variant="tonal" rounded="0" size="small" class="tx-chip" :title="item.transaction_type?.name || item.transaction_type_name || ''">
              <span class="tx-chip-text">{{ item.transaction_type?.name || item.transaction_type_name || 'N/A' }}</span>
            </v-chip>
          </template>

          <template v-slot:[`item.office`]="{ item }">
            <span
              v-if="item.office?.name || item.office?.code"
              v-tooltip="item.office?.name || item.office?.code || ''"
              class="tl-office-chip"
              :title="item.office?.name || item.office?.code || ''"
            >
              <img
                v-if="officeIcon(item.office)"
                class="tl-office-icon"
                :src="officeIcon(item.office)"
                :alt="`${item.office?.name || 'Office'} icon`"
                width="22"
                height="22"
                decoding="async"
              />
              <span
                v-else
                class="tl-office-icon-ph"
                aria-label="No office icon"
              >
                ?
              </span>
              <span class="tl-office-code">{{
                item.office?.code || item.office?.name
              }}</span>
            </span>
            <span v-else class="tl-dash">—</span>
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
                  <span class="tx-chip-text">{{ item.current_step?.name || item.current_step?.code || 'Unassigned' }}</span>
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
            <div class="tl-date">{{ fmtDate(item.created_at) }}</div>
            <div class="tl-ago">{{ timeAgo(item.created_at) }}</div>
          </template>

          <template #no-data>
            <div class="tl-empty">
              <template v-if="search.trim()">
                <b>No matches</b> for “{{ search.trim() }}”. Try a different word.
              </template>
              <template v-else>
                <b>No transactions yet.</b>
                <span v-if="canManage">Use “New transaction” to start the first one.</span>
              </template>
            </div>
          </template>

          <template #body.append>
            <tr
              v-for="n in ghostRows"
              :key="`ghost-${n}`"
              class="tl-ghost"
              aria-hidden="true"
            >
              <td v-for="h in headers" :key="h.key" />
            </tr>
          </template>
        </v-data-table>
      </div>

      <footer class="tl-pg">
        <div class="tl-per">
          <span>Items per page</span>
          <span class="tl-per-box" aria-label="Items per page: 8">
            <span>8</span>
            <v-icon size="18" aria-hidden="true">mdi-chevron-down</v-icon>
          </span>
        </div>
        <span class="tl-range">{{ rangeText }}</span>
        <div class="tl-pn" role="group" aria-label="Pagination">
          <button
            type="button"
            :disabled="navDisabled || currentPage <= 1"
            aria-label="First page"
            @click="goPage(1)"
          >
            <v-icon size="18">mdi-page-first</v-icon>
          </button>
          <button
            type="button"
            :disabled="navDisabled || currentPage <= 1"
            aria-label="Previous page"
            @click="goPage(currentPage - 1)"
          >
            <v-icon size="18">mdi-chevron-left</v-icon>
          </button>
          <button
            type="button"
            :disabled="navDisabled || currentPage >= pageCount"
            aria-label="Next page"
            @click="goPage(currentPage + 1)"
          >
            <v-icon size="18">mdi-chevron-right</v-icon>
          </button>
          <button
            type="button"
            :disabled="navDisabled || currentPage >= pageCount"
            aria-label="Last page"
            @click="goPage(pageCount)"
          >
            <v-icon size="18">mdi-page-last</v-icon>
          </button>
        </div>
      </footer>
    </v-card>

    <NewTransactionDialog
      v-model="dialog"
      :type-options="typeOptions"
      :office-options="officeOptions"
      :is-superadmin="isSuperadmin"
      :saving="saving"
      :error="error"
      @submit="createTx"
    />

  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTransactions } from '@/composables/useTransactions'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import { useSmartPoll } from '@/composables/useSmartPoll'
import LoadingVeil from '@/components/LoadingVeil.vue'
import StepProgress from '@/components/StepProgress.vue'
import NewTransactionDialog from '@/components/NewTransactionDialog.vue'
import { officeIcon } from '@/utils/officeIcons'

const router = useRouter()
const { items, loading, meta, fetchAll, create } = useTransactions()
const page = ref(1)
const { items: types, fetchAll: fetchTypes } = useTransactionTypes()
const { items: offices, fetchAll: fetchOffices } = useOffices()
const auth = useAuth()

const isSuperadmin = computed(() =>
  (auth.user.value?.roles || []).some((r) => r.code === 'superadmin')
)

const canManage = computed(() => isSuperadmin.value || auth.user.value?.office != null)

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')

const typeOptions = computed(() => {
  const myOfficeId = auth.user.value?.office?.id ?? null
  return (types.value || [])
    .filter((t) => {
      // Superadmins can originate any type for any office.
      if (isSuperadmin.value) return true
      // The type-level allowlist decides who can create; the first station
      // no longer restricts the Originating Office.
      const ids = t.office_ids ?? (t.offices || []).map((o) => o.id)
      return !ids.length
        || (myOfficeId != null && ids.some((id) => Number(id) === Number(myOfficeId)))
    })
    .map((t) => ({
      id: t.id,
      label: t.name,
      name: t.name,
      code: t.code,
      // Ordered steps of the type's live workflow, for the dialog's flow preview.
      workflow_steps: t.workflow_steps ?? [],
    }))
})

const officeOptions = computed(() =>
  (offices.value || [])
    .filter(o => o.is_active !== false && o.is_active !== 0)
    .map(o => ({ id: o.id, label: `${o.name} (${o.code})` }))
)

const headers = [
  { title: 'Ref #', key: 'reference_number', width: '14%' },
  { title: 'Title', key: 'title', width: '18%' },
  { title: 'Transaction Type', key: 'type', sortable: false, width: '17%' },
  { title: 'Originating Office', key: 'office', sortable: false, width: '16%' },
  { title: 'Current Step', key: 'current_step', sortable: false, width: '21%' },
  { title: 'Created', key: 'created_at', width: '14%' },
]

// Server-filtered: the API already applies ?q= (ref/title) and paginates to
// 25 slim rows, so the table renders one light page instead of filtering
// thousands of heavy rows on a weak CPU. Keeps the `filtered` name so the
// template is untouched.
const filtered = computed(() => items.value || [])

// Client-side page count for the loaded 25-row server chunk at 8/page.
// Server jumps use `page`; in-chunk moves use `tablePage`.
const tablePage = ref(1)
const clientPages = computed(() => Math.max(1, Math.ceil((filtered.value || []).length / 8)))

// The footer drives whichever pager is active: server pages when the API
// reports more than one, otherwise the in-chunk pages of the loaded rows.
const currentPage = computed(() => (meta.value.lastPage > 1 ? page.value : tablePage.value))
const pageCount = computed(() => (meta.value.lastPage > 1 ? meta.value.lastPage : clientPages.value))
const navDisabled = computed(() => !!loading.value)

// Keep the eight-row rhythm: fill only the remaining slots with ghosts.
const ghostRows = computed(() => {
  const n = (filtered.value || []).length
  const used = n
    ? Math.max(0, Math.min(8, n - (tablePage.value - 1) * 8))
    : 1
  return Math.max(0, 8 - Math.max(1, used))
})

// Default-footer style range for the visible chunk: "1–8 of 25".
const rangeText = computed(() => {
  const n = (filtered.value || []).length
  if (!n) return '0 of 0'
  const start = (tablePage.value - 1) * 8 + 1
  return `${start}–${Math.min(tablePage.value * 8, n)} of ${n}`
})

function clearSearch() {
  search.value = ''
}

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

async function goPage(p) {
  const target = Math.min(pageCount.value, Math.max(1, Number(p) || 1))
  if (meta.value.lastPage > 1) {
    if (target === page.value) return
    await goToPage(target)
    return
  }
  tablePage.value = target
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
  dialog.value = true
}

function go(id) {
  router.push(`/transactions/${id}`)
}

async function createTx(payload) {
  saving.value = true
  error.value = ''
  try {
    const body = {
      transaction_type_id: payload?.transaction_type_id,
      title: payload?.title || null,
    }
    // Office is only a choice for superadmins; admins/employees are
    // created under their own office automatically.
    if (isSuperadmin.value) body.office_id = payload?.office_id ?? null
    const tx = await create(body)
    dialog.value = false
    await fetchAll({ q: search.value, page: page.value })
    go(tx.id)
  } catch (e) {
    const errs = e?.response?.data?.errors
    const first = errs && Object.values(errs).find(Boolean)
    const msg = Array.isArray(first) ? first[0] : first
    error.value = msg || e?.response?.data?.message || 'Create failed.'
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  // Fire together: each paints its cache synchronously on invocation and
  // revalidates in parallel, so the table never waits behind the lookups.
  fetchTypes().catch(() => {})
  fetchOffices().catch(() => {})
  fetchAll({ q: search.value, page: page.value }).catch(() => {})
})

// Silent 20s smart-poll: refresh rows in place without loader flash,
// page reload, or losing search/sort/pagination/scroll.
useSmartPoll(async () => {
  // Skip while creating to avoid clobbering the dialog.
  if (saving.value || dialog.value) return
  try {
    await fetchAll({ silent: true, q: search.value, page: page.value })
  } catch {
    /* next tick retries */
  }
})
</script>

<style scoped>
/* ==========================================================================
   Transactions — sharp panel, header, table and footer
   (visual port of the Offices / Transaction Types design system)
   ========================================================================== */
.tl-page {
    --tl-ink: rgb(var(--v-theme-on-surface));
    --tl-muted: rgb(var(--v-theme-secondary));
    --tl-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --tl-panel: rgb(var(--v-theme-surface));
    --tl-field: #f4f6fb;
    --tl-hover: #f3f6fc;
    --tl-blue: #005EED;
    --tl-blue-bg: #e8eeff;
    --tl-ring: rgba(29, 63, 174, 0.28);
    overflow: hidden;
    background: var(--tl-panel);
    border: 1px solid var(--tl-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}
html.dark .tl-page {
    --tl-field: #1c2645;
    --tl-hover: #1d2745;
    --tl-blue: #6f8cff;
    --tl-blue-bg: #25306a;
    --tl-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
.tl-page button:focus-visible,
.tl-page a:focus-visible {
    outline: 3px solid var(--tl-ring);
    outline-offset: 2px;
}

/* ---- Header ---- */
.tl-hd {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 22px 28px;
    border-bottom: 3px solid var(--tl-blue);
    flex-wrap: wrap;
}
.tl-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--tms-grad);
    color: #fff;
}
.tl-hd-main {
    flex: 1 1 320px;
    min-width: 0;
}
.tl-title {
    margin: 0;
    color: var(--tl-ink);
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}
.tl-sub {
    margin: 4px 0 0;
    color: var(--tl-muted);
    font-size: 13.5px;
    font-weight: 500;
    line-height: 1.4;
}
.tl-tools {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: nowrap;
    margin-left: auto;
}
.tl-search {
    position: relative;
    flex: 0 0 320px;
    min-width: 0;
    max-width: 320px;
}
.tl-search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--tl-muted);
    pointer-events: none;
}
.tl-search-input {
    width: 100%;
    height: 46px;
    padding: 0 42px;
    border: 1.5px solid var(--tl-line);
    border-radius: 0;
    background: var(--tl-field);
    color: var(--tl-ink);
    font: inherit;
    font-size: 14.5px;
    font-weight: 500;
    transition:
        border-color 0.15s,
        box-shadow 0.15s,
        background 0.15s;
}
.tl-search-input::placeholder {
    color: var(--tl-muted);
    opacity: 0.9;
}
.tl-search-input:hover {
    border-color: rgba(var(--v-border-color), 0.8);
}
.tl-search-input:focus {
    outline: none;
    border-color: var(--tl-blue);
    background: var(--tl-panel);
    box-shadow: 0 0 0 4px var(--tl-ring);
}
.tl-search-input::-webkit-search-cancel-button {
    display: none;
}
.tl-clear {
    position: absolute;
    right: 6px;
    top: 50%;
    display: grid;
    place-items: center;
    width: 34px;
    height: 34px;
    padding: 0;
    transform: translateY(-50%);
    border: 0;
    border-radius: 0;
    background: none;
    color: var(--tl-muted);
    cursor: pointer;
}
.tl-clear:hover {
    background: var(--tl-line);
}
.tl-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: 46px;
    padding: 0 20px;
    flex: none;
    border: 1.5px solid var(--tl-blue);
    border-radius: 0;
    background: var(--tms-grad);
    color: #fff;
    font: inherit;
    font-size: 14.5px;
    font-weight: 700;
    white-space: nowrap;
    cursor: pointer;
    transition: filter 0.15s;
}
.tl-add:hover {
    filter: brightness(0.94);
}

/* ---- Alerts + table shell ---- */
.tl-alert {
    margin: 16px 28px 0 !important;
    border-radius: 0 !important;
}
.tl-wrap {
    min-width: 0;
    padding: 20px 28px 0;
}
.tl-table {
    --v-table-row-height: var(--tms-row);
    --v-table-header-height: 44px;
    width: 100%;
    min-width: 0;
    background: transparent !important;
}
.tl-table :deep(.v-table__wrapper) {
    overflow-x: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--tl-muted) var(--tl-field);
}
.tl-table :deep(.v-table__wrapper::-webkit-scrollbar) {
    width: 10px;
    height: 10px;
}
.tl-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
    background: var(--tl-field);
}
.tl-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
    border: 2px solid var(--tl-field);
    background: var(--tl-muted);
}
.tl-table :deep(table) {
    width: 100%;
    min-width: 960px;
    border-collapse: collapse;
    table-layout: fixed;
}
.tl-table :deep(thead th.v-data-table__th) {
    height: 44px;
    padding: 0 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--tl-line) !important;
    border-radius: 0 !important;
    background: var(--tl-field) !important;
    color: var(--tl-muted) !important;
    font-size: 12px !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-align: left;
    text-transform: uppercase;
    white-space: nowrap;
}
.tl-table :deep(thead th.v-data-table__th .v-data-table-header__content) {
    color: var(--tl-muted) !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-transform: uppercase;
}
.tl-table :deep(thead th.v-data-table__th .v-icon) {
    color: var(--tl-muted) !important;
    opacity: 0.65;
}
.tl-table :deep(tbody td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--tl-line) !important;
    border-radius: 0 !important;
    color: var(--tl-ink);
    font-size: 14.5px;
    vertical-align: middle;
}
/* Rows open the transaction detail — make the affordance obvious. */
.tl-table :deep(tbody tr:not(.tl-ghost)) {
    cursor: pointer;
}
.tl-table :deep(tbody tr:not(.tl-ghost):hover) {
    background: var(--tl-hover) !important;
}
.tl-table :deep(tbody tr.tl-ghost) {
    pointer-events: none;
}
.tl-table :deep(tbody tr.tl-ghost td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border-bottom: 1px solid var(--tl-line) !important;
}
.tl-table :deep(.v-data-table-rows-no-data td) {
    height: var(--tms-row) !important;
    padding: 0 !important;
    border-bottom: 1px solid var(--tl-line) !important;
}
.tl-empty {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 5px;
    min-height: var(--tms-row);
    padding: 0 14px;
    color: var(--tl-muted);
    font-size: 14px;
    font-weight: 500;
    text-align: center;
}
.tl-empty b {
    color: var(--tl-ink);
}

/* ---- Cells ---- */
/* Long titles / offices / chip names truncate to one line (full text on
   hover) so rows hold the 56px rhythm. Full values remain visible on the
   detail page. The step chip's icon must not eat the text budget, so the
   text gets its own cap slightly inside the chip's overall cap. */
.tl-name {
    display: block;
    max-width: 100%;
    overflow: hidden;
    color: var(--tl-ink);
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
}
/* Originating office: icon chip showing only the code; the full office
   name is the tooltip. Same pattern as the Transaction Types table. */
.tl-office-chip {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    max-width: 100%;
    padding: 4px 10px 4px 5px;
    background: var(--tl-blue-bg);
    color: var(--tl-blue);
    font-size: 13px;
    font-weight: 700;
    line-height: 1.25;
    vertical-align: middle;
}
.tl-office-chip:hover {
    filter: brightness(0.97);
}
.tl-office-icon {
    width: 22px;
    height: 22px;
    flex: none;
    object-fit: contain;
}
.tl-office-icon-ph {
    display: grid;
    place-items: center;
    width: 22px;
    height: 22px;
    flex: none;
    background: var(--tl-panel);
    color: var(--tl-blue);
    font-size: 12px;
    font-weight: 800;
    line-height: 1;
    border-radius: 50%;
}
.tl-office-code {
    overflow: hidden;
    letter-spacing: 0.02em;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.tl-dash {
    color: var(--tl-muted);
}
.tl-date {
    font-weight: 700;
}
.tl-ago {
    color: var(--tl-muted);
    font-size: 12px;
}
.tx-chip :deep(.v-chip__content) {
    max-width: 200px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.tx-chip-text {
    min-width: 0;
    max-width: 170px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

/* ---- Footer ---- */
.tl-pg {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 20px;
    padding: 16px 28px 20px;
    color: var(--tl-muted);
    font-size: 14px;
    flex-wrap: wrap;
}
.tl-per {
    display: flex;
    align-items: center;
    gap: 10px;
}
.tl-per-box {
    display: inline-flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    min-width: 76px;
    height: 40px;
    padding: 0 8px 0 12px;
    border: 1.5px solid var(--tl-line);
    background: var(--tl-panel);
    color: var(--tl-ink);
    font-weight: 700;
}
.tl-per-box :deep(.v-icon) {
    color: var(--tl-muted);
}
.tl-range {
    color: var(--tl-ink);
    font-weight: 700;
}
.tl-pn {
    display: flex;
    gap: 4px;
}
.tl-pn button {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid var(--tl-line);
    border-radius: 0;
    background: var(--tl-panel);
    color: var(--tl-ink);
    cursor: pointer;
}
.tl-pn button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

@media (max-width: 900px) {
    .tl-tools {
        flex: 1 1 100%;
        margin-left: 0;
    }
    .tl-search {
        flex: 1 1 100%;
        max-width: none;
    }
}
@media (max-width: 760px) {
    .tl-hd {
        padding: 18px 16px;
    }
    .tl-title {
        font-size: 20px;
    }
    .tl-wrap {
        padding: 16px 16px 0;
    }
    .tl-pg {
        justify-content: center;
        padding: 16px;
    }
}
@media (max-width: 520px) {
    .tl-add {
        padding: 0 16px;
    }
    .tl-add-label {
        display: none;
    }
}
</style>
