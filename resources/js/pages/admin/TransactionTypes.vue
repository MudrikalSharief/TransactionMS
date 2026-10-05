<template>
  <LoadingVeil :show="loading" label="transaction types" icon="mdi-format-list-bulleted-type" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#1E40AF">mdi-format-list-bulleted-type</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Transaction Types</span>
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
        Add Transaction Type
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :items="filtered"
        :headers="headers"
        :loading="loading"
        item-key="id"
        density="compact"
        :items-per-page="7"
        :items-per-page-options="[7]"
        hover
        class="lgu-table table-pages"
      >
        <template v-slot:[`item.code`]="{ item }">
          <span class="cell-truncate code-cap" :title="item.code">{{ item.code }}</span>
        </template>

        <template v-slot:[`item.name`]="{ item }">
          <span class="cell-truncate name-cap font-weight-bold" :title="item.name">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.description`]="{ item }">
          <span class="desc-full text-medium-emphasis" :title="item.description || ''">{{ item.description || '—' }}</span>
        </template>

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
          <v-btn
            v-else
            rounded="0"
            size="small"
            variant="outlined"
            color="grey-darken-3"
            prepend-icon="mdi-plus"
            v-tooltip="'Add first step'"
            @click="goSteps(item)"
          >
            Add Step
          </v-btn>
        </template>

        <template v-slot:[`item.offices`]="{ item }">
          <div v-if="(item.offices || []).length" class="d-flex flex-wrap ga-1 office-chips">
            <v-chip
              v-for="o in item.offices"
              :key="o.id"
              rounded="0"
              size="small"
              variant="tonal"
              color="grey-darken-3"
              :title="o.name"
            >
              {{ o.name }}
            </v-chip>
          </div>
          <span v-else class="text-medium-emphasis">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <v-menu open-on-hover location="end" open-delay="250">
            <template #activator="{ props }">
              <v-chip
                :color="item.is_active ? 'success' : 'error'"
                rounded="0"
                size="small"
                variant="tonal"
                v-bind="props"
              >
                <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
                {{ item.is_active ? 'Active' : 'Inactive' }}
              </v-chip>
            </template>
            <v-card rounded="0" min-width="340" max-width="420">
              <v-card-title class="text-subtitle-2 font-weight-bold pa-3">
                Workflow versions · {{ item.name || item.code }}
                <div class="text-caption text-medium-emphasis font-weight-medium">
                  New transactions use the live version · old versions are kept
                </div>
              </v-card-title>
              <v-divider />
              <v-list density="compact" class="py-1">
                <v-list-item v-if="!defsOf(item).length">
                  <v-list-item-title class="text-medium-emphasis">No workflow yet</v-list-item-title>
                  <v-list-item-subtitle>Open Steps to create version 1</v-list-item-subtitle>
                </v-list-item>
                <v-list-item
                  v-for="d in defsOf(item)"
                  :key="d.id"
                  :active="isLiveDef(d, item)"
                  rounded="lg"
                >
                  <template #prepend>
                    <v-icon :color="wfStatusColor(d.status)" size="small">{{ wfStatusIcon(d.status) }}</v-icon>
                  </template>
                  <v-list-item-title class="font-weight-bold">
                    v{{ d.version }}<span v-if="d.name"> · {{ d.name }}</span> · {{ (d.steps || []).length }} steps
                    <v-chip
                      v-if="isLiveDef(d, item)"
                      color="success"
                      variant="flat"
                      rounded="0"
                      size="x-small"
                      class="ml-1 font-weight-bold"
                    >
                      ACTIVE
                    </v-chip>
                  </v-list-item-title>
                  <v-list-item-subtitle>
                    {{ wfStatusLabel(d.status) }}<span v-if="d.published_at"> · {{ fmtDate(d.published_at) }}</span><span v-else-if="d.status === 'draft'"> · publish first to go live</span>
                  </v-list-item-subtitle>
                  <template #append>
                    <v-btn
                      v-if="d.status === 'published' && !isLiveDef(d, item)"
                      size="x-small"
                      variant="outlined"
                      color="grey-darken-3"
                      rounded="0"
                      class="font-weight-bold"
                      v-tooltip="'Make this version live for new transactions'"
                      @click="askMakeLive(item, d)"
                    >
                      Make live
                    </v-btn>
                    <v-btn
                      icon="mdi-eye"
                      v-tooltip="'View steps'"
                      size="x-small"
                      variant="text"
                      color="primary"
                      @click="goSteps(item)"
                    />
                  </template>
                </v-list-item>
              </v-list>
            </v-card>
          </v-menu>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end row-actions">
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
        <v-select
          v-model="form.office_ids"
          :items="officeOptions"
          item-title="label"
          item-value="id"
          label="Office(s)"
          multiple
          chips
          closable-chips
        />
        <v-switch v-model="form.is_active" label="Active" />
      </v-card-text>
      <v-divider />
    <v-card-actions class="justify-end">
      <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
      <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="save">Save</v-btn>
    </v-card-actions>
  </v-card>
  </v-dialog>

  <v-dialog v-model="liveDialog" max-width="500">
    <v-card rounded="0">
      <v-card-title>Switch live version?</v-card-title>
      <v-divider />
      <v-card-text>
        Change live from
        <b>v{{ liveFrom?.version ?? '—' }}</b> to
        <b>v{{ liveTarget?.version }}</b>
        for <b>{{ liveType?.name || liveType?.code }}</b>?
        <v-alert type="info" variant="tonal" density="compact" class="mt-3">
          New transactions will use v{{ liveTarget?.version }}. Running
          transactions stay on their version. Old versions are kept.
        </v-alert>
      </v-card-text>
      <v-divider />
      <v-card-actions class="justify-end">
        <v-btn variant="text" @click="liveDialog = false">Cancel</v-btn>
        <v-btn color="grey-darken-3" rounded="0" :loading="switching" @click="confirmMakeLive">Switch</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useWorkflows } from '@/composables/useWorkflows'
import { useOffices } from '@/composables/useOffices'
import { wfStatusColor, wfStatusIcon, wfStatusLabel } from '@/utils/workflowStatus'
import LoadingVeil from '@/components/LoadingVeil.vue'

const router = useRouter()
const { items, loading, fetchAll, create, update, remove } = useTransactionTypes()
const { defs, loading: defsLoading, fetchDefinitions, makeLive } = useWorkflows()
const { items: offices, fetchAll: fetchOffices } = useOffices()

const officeOptions = computed(() =>
  (offices.value || []).map((o) => ({ id: o.id, label: `${o.name} (${o.code})` })),
)

const headers = [
  { title: 'Code', key: 'code' },
  { title: 'Name', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: 'Steps', key: 'steps', sortable: false },
  { title: 'Office(s)', key: 'offices', sortable: false },
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
  // Live version's steps (what new transactions follow); fallback to
  // the latest version when nothing is live yet.
  const d = liveDefOf(item) || latestByType.value[item.id]
  if (!d) return null
  return { version: d.version, status: d.status, count: (d.steps || []).length }
}

// All workflow versions for a type, newest first — shown in the
// Status-chip hover menu so live can be switched from and to.
function defsOf(item) {
  return (defs.value || [])
    .filter((d) => Number(d.transaction_type_id) === Number(item.id))
    .sort((a, b) => Number(b.version) - Number(a.version))
}

// Live version: the is_live flag wins; fallback to the highest
// published version for rows predating the backfill.
function liveDefOf(item) {
  const list = defsOf(item)
  return list.find((d) => d.is_live)
    || list.filter((d) => d.status === 'published').sort((a, b) => Number(b.version) - Number(a.version))[0]
    || null
}

function isLiveDef(d, item) {
  const live = liveDefOf(item)
  return !!live && Number(live.id) === Number(d.id)
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

const liveDialog = ref(false)
const liveTarget = ref(null)
const liveFrom = ref(null)
const liveType = ref(null)
const switching = ref(false)

function askMakeLive(item, d) {
  error.value = ''
  liveType.value = item
  liveTarget.value = d
  liveFrom.value = liveDefOf(item)
  liveDialog.value = true
}

async function confirmMakeLive() {
  if (!liveTarget.value) return
  switching.value = true
  error.value = ''
  try {
    await makeLive(liveTarget.value.id)
    liveDialog.value = false
    liveTarget.value = null
    await fetchDefinitions()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Switching live version failed.'
    liveDialog.value = false
  } finally {
    switching.value = false
  }
}

const stepsLoading = computed(() => defsLoading.value)

function goSteps(item) {
  router.push(`/admin/workflows?type=${item.id}`)
}

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')

let navObserver = null

// Client-side search: master data is small, filter loaded rows by
// code / name / description / office without extra requests.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return items.value || []
  return (items.value || []).filter((t) =>
    [t.code, t.name, t.description, (t.offices || []).map((o) => o.name).join(' ')]
      .some((v) => String(v || '').toLowerCase().includes(q))
  )
})

const form = ref({ id: null, code: '', name: '', description: '', office_ids: [], is_active: true })

function openCreate() {
  error.value = ''
  form.value = { id: null, code: '', name: '', description: '', office_ids: [], is_active: true }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    code: item.code,
    name: item.name,
    description: item.description ?? '',
    office_ids: (item.office_ids ?? (item.offices || []).map((o) => o.id) ?? []).slice(),
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
      office_ids: form.value.office_ids || [],
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

onMounted(() => {
  // Full scroll lock for this tab: no bars and no scrolling anywhere.
  document.documentElement.classList.add('lock-scroll')
  // Independent lookups: run in parallel so one slow endpoint never blocks
  // the others. Each paints cache first, then revalidates silently.
  fetchAll().catch(() => {})
  fetchDefinitions().catch(() => {})
  fetchOffices().catch(() => {})
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
/* Stable paged table: auto layout uses the full width (no equal-split
   cutting), drawer expand/collapse can never create a visible
   horizontal scrollbar — overflow is clipped, not scrolled. */
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
/* Description uses the freed space and wraps — capped at 2 lines so a
   long description can never stretch rows past the 60px rhythm and break
   card equality (full text stays on hover via title). */
.desc-full {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  white-space: normal;
  word-break: break-word;
  line-height: 1.4;
}
/* Slim columns stay capped so Description + Offices get the full leftover. */
.code-cap {
  max-width: 140px;
}
.name-cap {
  max-width: 180px;
}
/* Offices fully show: wrap to as many lines as needed, no ellipsis cap. */
.office-chips {
  min-width: 0;
  max-width: 100%;
}
/* Row actions stay visible normally. They only duck away (with a quick
   blink) while the left navbar is expanded — hovering it or toggled open —
   so the narrower table never cuts them off. Space is reserved. */
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
