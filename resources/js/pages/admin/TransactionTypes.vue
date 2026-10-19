<template>
  <LoadingVeil :show="loading" label="transaction types" icon="mdi-format-list-bulleted-type" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#16307C">mdi-format-list-bulleted-type</v-icon>
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
      <v-btn v-if="canManage" variant="outlined" color="primary" rounded="0" prepend-icon="mdi-plus" height="40" @click="openCreate">
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
            :clickable="isSuperadmin"
            @click="goSteps(item)"
          >
            <v-icon start size="small">mdi-format-list-numbered</v-icon>
            {{ stepsOf(item).count }} steps
          </v-chip>
          <v-btn
            v-else-if="isSuperadmin"
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
          <span v-else class="text-medium-emphasis">—</span>
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
          <v-chip
            v-else
            rounded="0"
            size="small"
            variant="tonal"
            color="grey-darken-3"
            title="Available to every office"
          >
            ALL Offices
          </v-chip>
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
          <div v-if="canManage" class="d-flex ga-3 justify-end row-actions">
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

  <v-dialog v-model="dialog" max-width="560" scrollable>
    <v-card rounded="xl" style="overflow: hidden">
      <v-card-title class="ntt-hd">
        <v-avatar color="primary" variant="tonal" rounded="lg" size="44" class="ntt-badge">
          <v-icon color="primary">mdi-file-document-plus-outline</v-icon>
        </v-avatar>
        <div class="ntt-hd-t">
          <div class="ntt-title">{{ form.id ? 'Edit Transaction Type' : 'New Transaction Type' }}</div>
          <div class="ntt-sub">
            {{ form.id
              ? 'Update the details and which offices can use it.'
              : 'Define a transaction and choose which offices can use it.' }}
          </div>
        </div>
        <v-btn icon="mdi-close" variant="text" size="small" color="grey-darken-3" class="ntt-x" @click="dialog = false" />
      </v-card-title>
      <v-divider />
      <v-card-text class="ntt-bd">
        <v-alert v-if="dialogError" type="error" variant="tonal" density="compact" class="mb-4">{{ dialogError }}</v-alert>

        <div class="ntt-f">
          <label class="ntt-lb" for="ntt-name">Name <span class="ntt-req">*</span></label>
          <v-text-field
            id="ntt-name"
            v-model="form.name"
            placeholder="e.g. Purchase Request"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            :error-messages="fieldErrors.name"
            class="ntt-in"
            @update:model-value="clearFieldError('name')"
          />
        </div>

        <div class="ntt-f">
          <label class="ntt-lb" for="ntt-code">Code <span class="ntt-req">*</span></label>
          <v-text-field
            id="ntt-code"
            v-model="form.code"
            placeholder="purchase_request"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            spellcheck="false"
            :error-messages="fieldErrors.code"
            class="ntt-in ntt-mono"
            @update:model-value="clearFieldError('code')"
          />
          <div v-if="!fieldErrors.code" class="ntt-help">Lowercase letters, numbers and underscores only.</div>
        </div>

        <div class="ntt-f">
          <label class="ntt-lb" for="ntt-desc">Description</label>
          <v-textarea
            id="ntt-desc"
            v-model="form.description"
            placeholder="What is this transaction used for?"
            rows="3"
            maxlength="200"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            :error-messages="fieldErrors.description"
            class="ntt-in"
            @update:model-value="clearFieldError('description')"
          />
          <div v-if="!fieldErrors.description" class="ntt-help">{{ (form.description || '').length }}/200 characters</div>
        </div>

        <div class="ntt-f">
          <label class="ntt-lb" for="ntt-offices">Offices</label>
          <v-select
            v-if="isSuperadmin"
            id="ntt-offices"
            v-model="form.office_ids"
            :items="officeOptions"
            item-title="title"
            item-value="id"
            :item-props="officeItemProps"
            placeholder="Select offices"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            multiple
            chips
            closable-chips
            :error-messages="fieldErrors.office_ids"
            class="ntt-in ntt-offices"
          >
            <template #chip="{ item, props: chipProps }">
              <v-chip v-bind="chipProps" color="primary" variant="tonal" rounded="lg">{{ item.title }}</v-chip>
            </template>
          </v-select>
          <v-alert v-else type="info" variant="tonal" density="compact" class="mb-0">
            Available to: <b>{{ auth.user.value?.office?.name || 'your office' }}</b>
            <div class="text-caption">
              Office admins manage their own office's types; clearing the list keeps your office assigned.
            </div>
          </v-alert>
          <div v-if="isSuperadmin && !fieldErrors.office_ids" class="ntt-help">
            ALL Offices means every office may create this type.
          </div>
        </div>

        <div class="ntt-sw">
          <div>
            <div class="ntt-sw-t">Active</div>
            <div class="ntt-sw-d">
              {{ form.is_active ? 'Available for new requests' : 'Hidden from new requests' }}
            </div>
          </div>
          <v-spacer />
          <v-switch
            v-model="form.is_active"
            color="success"
            density="compact"
            hide-details
            inset
            class="ntt-sw-tg"
          />
        </div>
      </v-card-text>
      <v-divider />
      <v-card-actions class="ntt-ft">
        <v-btn variant="outlined" rounded="lg" class="ntt-b" @click="dialog = false">Cancel</v-btn>
        <v-btn color="primary" rounded="lg" class="ntt-b ntt-b-pri" :loading="saving" @click="save">Save</v-btn>
      </v-card-actions>
  </v-card>
  </v-dialog>

  <v-dialog v-model="liveDialog" max-width="500">
    <v-card rounded="xl" style="overflow: hidden">
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
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth, isOfficeAdminUser } from '@/composables/useAuth'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useWorkflows } from '@/composables/useWorkflows'
import { useOffices } from '@/composables/useOffices'
import { wfStatusColor, wfStatusIcon, wfStatusLabel } from '@/utils/workflowStatus'
import LoadingVeil from '@/components/LoadingVeil.vue'

const router = useRouter()
const auth = useAuth()
const { items, loading, fetchAll, create, update, remove } = useTransactionTypes()
const { defs, loading: defsLoading, fetchDefinitions, makeLive } = useWorkflows()
const { items: offices, fetchAll: fetchOffices } = useOffices()

const isSuperadmin = computed(() => (auth.user.value?.roles ?? []).some((r) => r.code === 'superadmin'))
const isOfficeAdmin = computed(() => isOfficeAdminUser(auth.user.value))
const canManage = computed(() => isSuperadmin.value || isOfficeAdmin.value)

// "ALL Offices" is the always-present first row. Storing no office rows means
// every office may use the type (see CreateTransactionRequest + the index
// filter). The sentinel is UI-only: save() strips it back to an empty list.
// Rows are two-line (code over full name): the chip shows `title` (the office
// code, or "ALL Offices"), the dropdown row adds `subtitle` (full name).
const ALL_OFFICES = '__all__'
const officeOptions = computed(() => [
  { id: ALL_OFFICES, title: 'ALL Offices', subtitle: 'Available to every office' },
  ...(offices.value || []).map((o) => ({
    id: o.id,
    title: o.code || o.name,
    subtitle: o.name,
  })),
])
// Only `subtitle` is injected — Vuetify keeps item-title as the row title.
const officeItemProps = (item) => ({ subtitle: item.subtitle })

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
  if (!isSuperadmin.value) return
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

const form = ref({ id: null, code: '', name: '', description: '', office_ids: [ALL_OFFICES], is_active: true })
// 422 field errors render under their inputs; `dialogError` holds anything
// that isn't field-specific (the page-level alert sits behind the dialog).
const fieldErrors = ref({})
const dialogError = ref('')

function clearFieldError(key) {
  if (!fieldErrors.value[key]) return
  const next = { ...fieldErrors.value }
  delete next[key]
  fieldErrors.value = next
}

// ALL Offices and specific offices are mutually exclusive, and ALL is the
// fallback so the field is never blank: picking ALL wins over a selection,
// picking a real office while ALL is on drops ALL, and clearing the last
// chip snaps back to ALL.
watch(() => form.value.office_ids, (val, old) => {
  const list = Array.isArray(val) ? val : []
  if (list.length === 0) {
    form.value.office_ids = [ALL_OFFICES]
    return
  }
  if (!list.includes(ALL_OFFICES) || list.length <= 1) return
  const hadAll = (old || []).includes(ALL_OFFICES)
  form.value.office_ids = hadAll ? list.filter((v) => v !== ALL_OFFICES) : [ALL_OFFICES]
})

// Stored office ids, or the ALL sentinel when the type has none.
function officeIdsOf(item) {
  const ids = (item.office_ids ?? (item.offices || []).map((o) => o.id) ?? []).slice()
  return ids.length ? ids : [ALL_OFFICES]
}

function openCreate() {
  error.value = ''
  fieldErrors.value = {}
  dialogError.value = ''
  form.value = { id: null, code: '', name: '', description: '', office_ids: [ALL_OFFICES], is_active: true }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  fieldErrors.value = {}
  dialogError.value = ''
  form.value = {
    id: item.id,
    code: item.code,
    name: item.name,
    description: item.description ?? '',
    office_ids: officeIdsOf(item),
    is_active: !!item.is_active,
  }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  fieldErrors.value = {}
  dialogError.value = ''
  try {
    const payload = {
      code: form.value.code,
      name: form.value.name,
      description: form.value.description,
      is_active: form.value.is_active,
    }
    // Superadmin picks the offices; office admins keep their office's
    // existing assignments (backend enforces their office stays included).
    // ALL Offices is stored as "no office rows" — the sentinel is UI-only.
    if (isSuperadmin.value) {
      payload.office_ids = (form.value.office_ids || []).filter((v) => v !== ALL_OFFICES)
    }

    if (form.value.id) await update(form.value.id, payload)
    else await create(payload)

    dialog.value = false
    await fetchAll()
  } catch (e) {
    // Server-side validation lands under the offending field; anything else
    // (network, 403, 500) shows at the top of the dialog body.
    const errs = e?.response?.data?.errors
    if (errs && typeof errs === 'object') {
      const first = (v) => (Array.isArray(v) ? v[0] : String(v ?? ''))
      fieldErrors.value = Object.fromEntries(
        Object.entries(errs).map(([key, value]) => [key, first(value)]),
      )
    } else {
      dialogError.value = e?.response?.data?.message || 'Save failed.'
    }
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
  background-color: #0E1F52 !important;
  color: #ffffff !important;
  border-top: 2px solid #0E1F52 !important;
  border-bottom: 3px solid #0E1F52 !important;
  border-left: none !important;
  border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
  border-left: 2px solid #0E1F52 !important;
  padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
  border-right: 2px solid #0E1F52 !important;
  padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
  color: #ffffff !important;
}
</style>

<style scoped>
/* ---- New / Edit Transaction Type modal (design mockup port) ---- */
/* Header: tinted badge + title + subtitle + close. */
.ntt-hd {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 22px 24px 16px;
}
.ntt-badge {
  flex: none;
}
.ntt-hd-t {
  min-width: 0;
}
.ntt-title {
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.01em;
  line-height: 1.25;
}
.ntt-sub {
  margin-top: 3px;
  font-size: 14px;
  color: rgb(var(--v-theme-secondary));
}
.ntt-x {
  margin-left: auto;
  flex: none;
}

/* Body: label / field / help rhythm, scrolling inside the dialog. */
.ntt-bd {
  padding: 18px 24px 8px;
}
.ntt-f {
  margin-bottom: 18px;
}
.ntt-lb {
  display: block;
  margin-bottom: 7px;
  font-size: 14px;
  font-weight: 600;
}
.ntt-req {
  color: rgb(var(--v-theme-error));
}
.ntt-help {
  margin: 6px 2px 0;
  font-size: 12.5px;
  color: rgb(var(--v-theme-secondary));
}

/* Fields: 48px tall, radius 12, tinted fill, soft focus ring. */
.ntt-in :deep(.v-field) {
  min-height: 48px;
  border-radius: 12px;
  background: #f4f6fb;
}
.ntt-in :deep(.v-field__outline) {
  --v-field-border-width: 1.5px;
}
.ntt-in :deep(.v-field--focused) {
  background: rgb(var(--v-theme-surface));
  box-shadow: 0 0 0 4px rgba(22, 48, 124, 0.18);
}
.ntt-mono :deep(input) {
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 14.5px;
}

/* Offices: two-line option rows (code over full name). */
.ntt-offices :deep(.v-list-item-title) {
  font-weight: 700;
}
.ntt-offices :deep(.v-list-item-subtitle) {
  font-size: 12.5px;
  white-space: normal;
}

/* Active: bordered row, subtitle tracks the switch. */
.ntt-sw {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 6px;
  padding: 8px 14px;
  border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
  border-radius: 14px;
}
.ntt-sw-t {
  font-size: 14.5px;
  font-weight: 700;
}
.ntt-sw-d {
  font-size: 12.5px;
  color: rgb(var(--v-theme-secondary));
}
.ntt-sw-tg {
  flex: none;
}

/* Footer: ghost Cancel + primary Save, stacked on phones. */
.ntt-ft {
  gap: 10px;
  padding: 16px 24px 20px;
}
.ntt-b {
  height: 46px;
  padding: 0 22px;
  font-weight: 700;
  text-transform: none;
}
.ntt-b-pri {
  min-width: 120px;
}
@media (max-width: 520px) {
  .ntt-ft {
    flex-direction: column-reverse;
  }
  .ntt-b {
    width: 100%;
  }
}

/* Dark theme (html.dark is toggled by AppShell for pixivDark). */
html.dark .ntt-in :deep(.v-field) {
  background: #232b45;
}
html.dark .ntt-in :deep(.v-field--focused) {
  background: rgb(var(--v-theme-surface));
  box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}
html.dark .ntt-sw {
  border-color: rgba(255, 255, 255, 0.16);
}
</style>
