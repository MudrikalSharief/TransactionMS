<template>
  <LoadingVeil :show="loading" label="offices" icon="mdi-office-building-outline" />
  <v-card rounded="0" elevation="0" class="ofp-page mb-4">
    <header class="ofp-hd">
      <div class="ofp-badge" aria-hidden="true">
        <v-icon size="26">mdi-office-building-outline</v-icon>
      </div>
      <div class="ofp-hd-main">
        <h1 class="ofp-title">Offices</h1>
        <p class="ofp-sub">
          The offices that start, review and approve transactions.
        </p>
      </div>
      <div class="ofp-tools">
        <div class="ofp-search" role="search">
          <v-icon class="ofp-search-icon" size="19">mdi-magnify</v-icon>
          <input
            ref="searchInput"
            v-model="search"
            type="search"
            class="ofp-search-input"
            placeholder="Search code, name or description"
            aria-label="Search offices"
            autocomplete="off"
          />
          <button
            v-if="search"
            type="button"
            class="ofp-clear"
            aria-label="Clear search"
            @click="clearSearch"
          >
            <v-icon size="16">mdi-close</v-icon>
          </button>
        </div>
        <button
          v-if="canManage"
          type="button"
          class="ofp-add"
          aria-label="Add office"
          @click="openCreate"
        >
          <v-icon size="18">mdi-plus</v-icon>
          <span class="ofp-add-label">Add office</span>
        </button>
      </div>
    </header>

    <v-alert
      v-if="error"
      type="error"
      variant="tonal"
      rounded="0"
      class="ofp-alert"
    >
      {{ error }}
    </v-alert>

    <div class="ofp-wrap">
      <v-data-table
        v-show="!loading"
        v-model:page="page"
        v-model:sort-by="sortBy"
        :items="filtered"
        :headers="headers"
        :loading="loading"
        item-key="id"
        :items-per-page="pageSize"
        :hide-default-footer="true"
        :mobile="false"
        must-sort
        hover
        initial-sort-order="asc"
        sort-asc-icon="mdi-arrow-up"
        sort-desc-icon="mdi-arrow-down"
        class="ofp-table"
      >
        <template v-slot:[`item.code`]="{ item }">
          <span class="ofp-code" :title="item.code">{{ item.code }}</span>
        </template>

        <template v-slot:[`item.name`]="{ item }">
          <div class="ofp-name" :title="item.name">
            <span
              class="ofp-av"
              :class="`ofp-h${hueOf(item)}`"
              aria-hidden="true"
            >
              <img
                v-if="officeIcon(item)"
                class="ofp-av-img"
                :src="officeIcon(item)"
                alt=""
              />
              <span v-else class="ofp-av-text">{{ initialsOf(item) }}</span>
            </span>
            <span class="ofp-name-text">{{ item.name }}</span>
          </div>
        </template>

        <template v-slot:[`item.description`]="{ item }">
          <span
            v-if="item.description"
            class="ofp-desc"
            :title="item.description"
          >
            {{ item.description }}
          </span>
          <span v-else class="ofp-dash">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <span class="ofp-status" :class="{ 'is-off': !item.is_active }">
            <span class="ofp-status-dot" aria-hidden="true" />
            {{ item.is_active ? 'Active' : 'Inactive' }}
          </span>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div v-if="canManage" class="ofp-actions">
            <v-btn
              class="ofp-ib is-edit"
              icon="mdi-pencil"
              aria-label="Edit office"
              v-tooltip="'Edit office'"
              size="small"
              variant="outlined"
              rounded="0"
              @click="openEdit(item)"
            />
            <v-btn
              class="ofp-ib is-delete"
              icon="mdi-delete"
              aria-label="Delete office"
              v-tooltip="'Delete office'"
              size="small"
              variant="outlined"
              rounded="0"
              @click="removeRow(item)"
            />
          </div>
        </template>

        <template #header.actions>
          <span class="ofp-sr-only">Actions</span>
        </template>

        <template #no-data>
          <div class="ofp-empty">
            <template v-if="search.trim()">
              <b>No matches</b> for “{{ search.trim() }}”. Try a different
              word.
            </template>
            <template v-else>
              <b>No offices yet.</b>
              <span v-if="canManage">
                Use “Add office” to create the first one.
              </span>
            </template>
          </div>
        </template>

        <template #body.append>
          <tr
            v-for="n in ghostRows"
            :key="`ghost-${n}`"
            class="ofp-ghost"
            aria-hidden="true"
          >
            <td v-for="h in headers" :key="h.key" />
          </tr>
        </template>
      </v-data-table>
    </div>

    <footer class="ofp-pg">
      <label class="ofp-per">
        <span>Items per page</span>
        <span class="ofp-select-wrap">
          <select
            v-model.number="pageSize"
            class="ofp-select"
            aria-label="Items per page"
          >
            <option :value="7">7</option>
            <option :value="10">10</option>
            <option :value="25">25</option>
          </select>
          <v-icon class="ofp-select-icon" size="18" aria-hidden="true">
            mdi-chevron-down
          </v-icon>
        </span>
      </label>
      <span class="ofp-range">{{ rangeLabel }}</span>
      <div class="ofp-pn" role="group" aria-label="Pagination">
        <button
          type="button"
          :disabled="page <= 1"
          aria-label="First page"
          @click="goPage(1)"
        >
          <v-icon size="18">mdi-page-first</v-icon>
        </button>
        <button
          type="button"
          :disabled="page <= 1"
          aria-label="Previous page"
          @click="goPage(page - 1)"
        >
          <v-icon size="18">mdi-chevron-left</v-icon>
        </button>
        <button
          type="button"
          :disabled="page >= pageCount"
          aria-label="Next page"
          @click="goPage(page + 1)"
        >
          <v-icon size="18">mdi-chevron-right</v-icon>
        </button>
        <button
          type="button"
          :disabled="page >= pageCount"
          aria-label="Last page"
          @click="goPage(pageCount)"
        >
          <v-icon size="18">mdi-page-last</v-icon>
        </button>
      </div>
      <span class="ofp-sr-only" aria-live="polite">{{ rangeLabel }}</span>
    </footer>
  </v-card>

  <v-dialog
    v-model="dialog"
    max-width="520"
    scrollable
    content-class="office-dialog"
    attach="body"
    :persistent="saving"
    aria-labelledby="office-dialog-title"
    aria-describedby="office-dialog-subtitle"
  >
    <v-card rounded="xl" elevation="0" class="ofc-card">
      <v-card-title class="ofc-hd">
        <v-avatar color="primary" variant="tonal" rounded="lg" size="44" class="ofc-badge">
          <v-icon color="primary">mdi-office-building-outline</v-icon>
        </v-avatar>
        <div class="ofc-hd-t">
          <div id="office-dialog-title" class="ofc-title">
            {{ form.id ? 'Edit Office' : 'New Office' }}
          </div>
          <div id="office-dialog-subtitle" class="ofc-sub">
            {{ form.id ? 'Update the office details and availability.' : 'Add an office that can handle transactions.' }}
          </div>
        </div>
        <v-btn
          icon="mdi-close"
          variant="text"
          size="small"
          color="grey-darken-3"
          class="ofc-x"
          aria-label="Close office dialog"
          :disabled="saving"
          @click="closeDialog"
        />
      </v-card-title>
      <v-card-text class="ofc-bd">
        <v-alert v-if="dialogError" type="error" variant="tonal" density="compact" class="mb-4" role="alert">
          {{ dialogError }}
        </v-alert>

        <div class="ofc-f">
          <label class="ofc-lb" for="ofc-name">Name <span class="ofc-req">*</span></label>
          <v-text-field
            id="ofc-name"
            ref="nameField"
            v-model="form.name"
            placeholder="e.g. General Service Office"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            autocomplete="off"
            autofocus
            :error-messages="fieldErrors.name"
            class="ofc-in"
            @update:model-value="onNameInput"
          />
        </div>

        <div class="ofc-f">
          <label class="ofc-lb" for="ofc-code">Code <span class="ofc-req">*</span></label>
          <v-text-field
            id="ofc-code"
            ref="codeField"
            :model-value="form.code"
            placeholder="GENERAL_SERVICE_OFFICE"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            autocomplete="off"
            autocapitalize="characters"
            autocorrect="off"
            spellcheck="false"
            :error-messages="fieldErrors.code"
            class="ofc-in ofc-mono"
            @update:model-value="onCodeInput"
          />
          <div v-if="!fieldErrors.code" class="ofc-help">
            Auto-generated from the name. Uppercase letters, numbers and underscores only.
          </div>
        </div>

        <div class="ofc-f">
          <label class="ofc-lb ofc-lb-row" for="ofc-desc">
            <span>Description <span class="ofc-opt">(optional)</span></span>
            <span class="ofc-cnt">{{ descriptionLength }}/200</span>
          </label>
          <v-textarea
            id="ofc-desc"
            ref="descField"
            v-model="form.description"
            placeholder="What does this office do?"
            rows="3"
            maxlength="200"
            variant="outlined"
            density="comfortable"
            hide-details="auto"
            persistent-placeholder
            :error-messages="fieldErrors.description"
            class="ofc-in"
            @update:model-value="clearFieldError('description')"
          />
        </div>

        <div class="ofc-sw">
          <div>
            <div class="ofc-sw-t">Active</div>
            <div class="ofc-sw-d">
              {{ form.is_active ? 'Available for new transactions' : 'Hidden from new transactions' }}
            </div>
          </div>
          <v-spacer />
          <v-switch
            v-model="form.is_active"
            color="success"
            density="compact"
            hide-details
            inset
            aria-label="Active"
            class="ofc-sw-tg"
          />
        </div>
      </v-card-text>
      <v-divider />
      <v-card-actions class="ofc-ft">
        <v-btn variant="outlined" rounded="lg" class="ofc-b" :disabled="saving" @click="closeDialog">
          Cancel
        </v-btn>
        <v-btn color="primary" rounded="lg" class="ofc-b ofc-b-pri" :loading="saving" @click="save">
          {{ form.id ? 'Save changes' : 'Save office' }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useAuth } from '@/composables/useAuth'
import { useOffices } from '@/composables/useOffices'
import { toast } from '@/composables/useToast'
import { officeIcon } from '@/utils/officeIcons'
import LoadingVeil from '@/components/LoadingVeil.vue'

const auth = useAuth()
const { items, loading, fetchAll, create, update, remove } = useOffices()

const canManage = computed(() => (auth.user.value?.roles ?? []).some((r) => r.code === 'superadmin'))

const searchInput = ref(null)
const page = ref(1)
const pageSize = ref(7)
const sortBy = ref([{ key: 'code', order: 'asc' }])

const compareText = (a, b) =>
  String(a ?? '').localeCompare(String(b ?? ''), undefined, {
    sensitivity: 'base',
    numeric: true,
  })

const headers = computed(() => {
  const ariaSort = (key) => {
    const active = sortBy.value.find((sort) => sort.key === key)
    if (!active) return 'none'
    return active.order === 'asc' ? 'ascending' : 'descending'
  }

  return [
    {
      title: 'Code',
      key: 'code',
      width: '14%',
      sort: compareText,
      headerProps: { 'aria-sort': ariaSort('code') },
    },
    {
      title: 'Name',
      key: 'name',
      width: '32%',
      sort: compareText,
      headerProps: { 'aria-sort': ariaSort('name') },
    },
    { title: 'Description', key: 'description', width: '28%', sortable: false },
    { title: 'Status', key: 'is_active', width: '12%', sortable: false },
    { title: '', key: 'actions', width: '14%', sortable: false, align: 'end' },
  ]
})

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')
const fieldErrors = ref({})
const dialogError = ref('')
const codeTouched = ref(false)
const nameField = ref(null)
const codeField = ref(null)
const descField = ref(null)

// Client-side search: master data is small, filter loaded rows by
// code / name / description without extra requests.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  if (!q) return items.value || []
  return (items.value || []).filter((o) =>
    [o.code, o.name, o.description].some((v) => String(v || '').toLowerCase().includes(q))
  )
})

const pageCount = computed(() =>
  Math.max(1, Math.ceil(filtered.value.length / pageSize.value))
)
const pageStart = computed(() =>
  filtered.value.length ? (page.value - 1) * pageSize.value + 1 : 0
)
const pageEnd = computed(() =>
  Math.min(page.value * pageSize.value, filtered.value.length)
)
const rangeLabel = computed(() =>
  filtered.value.length
    ? `${pageStart.value}–${pageEnd.value} of ${filtered.value.length}`
    : '0 of 0'
)
// Keep the selected page size filled: one no-data row plus ghosts when there
// are no results, otherwise only the remaining slots on the current page.
const ghostRows = computed(() => {
  const used = filtered.value.length
    ? Math.max(0, pageEnd.value - pageStart.value + 1)
    : 1
  return Math.max(0, pageSize.value - used)
})

function hueOf(item) {
  const value = String(item?.code || item?.name || '')
  let hash = 0
  for (const char of value) {
    hash = (hash * 31 + char.charCodeAt(0)) % 5
  }
  return hash
}

function initialsOf(item) {
  const code = String(item?.code || '').trim()
  if (code) return code.slice(0, 2).toUpperCase()
  return (
    String(item?.name || '?')
      .trim()
      .split(/\s+/)
      .slice(0, 2)
      .map((part) => part[0] || '')
      .join('')
      .toUpperCase() || '?'
  )
}

function goPage(next) {
  page.value = Math.min(pageCount.value, Math.max(1, Number(next) || 1))
}

function clearSearch() {
  search.value = ''
  searchInput.value?.focus()
}

watch(search, () => {
  page.value = 1
})
watch(pageSize, () => {
  page.value = 1
})
watch(
  sortBy,
  () => {
    page.value = 1
  },
  { deep: true }
)
watch(
  () => filtered.value.length,
  (length) => {
    const pages = Math.max(1, Math.ceil(length / pageSize.value))
    if (page.value > pages) page.value = pages
  }
)

const form = ref({ id: null, code: '', name: '', description: '', is_active: true })
const descriptionLength = computed(() => String(form.value.description || '').length)

function clearFieldError(key) {
  if (!fieldErrors.value[key]) return
  const next = { ...fieldErrors.value }
  delete next[key]
  fieldErrors.value = next
}

// Uppercase snake case, capped at the backend's 50-character limit.
function slugCode(value) {
  return String(value ?? '')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .toUpperCase()
    .replace(/[^A-Z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 50)
    .replace(/_+$/g, '')
}

function onNameInput(value) {
  form.value.name = value
  if (!form.value.id && !codeTouched.value) {
    form.value.code = slugCode(value)
    clearFieldError('code')
  }
  clearFieldError('name')
}

function onCodeInput(value) {
  const next = String(value ?? '').toUpperCase()
  form.value.code = next
  codeTouched.value = next.length > 0
  clearFieldError('code')
}

function focusField(key) {
  nextTick(() => {
    if (key === 'name') nameField.value?.focus?.()
    else if (key === 'code') codeField.value?.focus?.()
    else if (key === 'description') descField.value?.focus?.()
  })
}

function focusFirstError(errors = fieldErrors.value) {
  if (errors.name) focusField('name')
  else if (errors.code) focusField('code')
  else if (errors.description) focusField('description')
}

function openCreate() {
  error.value = ''
  fieldErrors.value = {}
  dialogError.value = ''
  codeTouched.value = false
  form.value = { id: null, code: '', name: '', description: '', is_active: true }
  dialog.value = true
  focusField('name')
}

function openEdit(item) {
  error.value = ''
  fieldErrors.value = {}
  dialogError.value = ''
  codeTouched.value = true
  form.value = {
    id: item.id,
    code: String(item.code ?? '').toUpperCase(),
    name: item.name ?? '',
    description: item.description ?? '',
    is_active: !!item.is_active,
  }
  dialog.value = true
  focusField('name')
}

function closeDialog() {
  if (saving.value) return
  dialog.value = false
}

function validateForm() {
  const errors = {}
  const name = String(form.value.name ?? '').trim()
  const code = String(form.value.code ?? '').trim().toUpperCase()

  if (!name) {
    errors.name = 'Enter the office name.'
  } else if (name.length > 120) {
    errors.name = 'Keep the name to 120 characters or fewer.'
  }

  if (!code) {
    errors.code = 'Enter an office code.'
  } else if (!/^[A-Z][A-Z0-9_]*$/.test(code)) {
    errors.code = 'Use uppercase snake case, starting with a letter (for example GENERAL_SERVICE_OFFICE).'
  } else if (code.length > 50) {
    errors.code = 'Keep the code to 50 characters or fewer.'
  } else {
    const duplicate = (items.value || []).some(
      (o) => String(o.id) !== String(form.value.id) && String(o.code ?? '').toUpperCase() === code
    )
    if (duplicate) errors.code = 'This code is already used by another office.'
  }

  if (String(form.value.description ?? '').length > 200) {
    errors.description = 'Keep the description to 200 characters or fewer.'
  }

  return errors
}

async function save() {
  if (saving.value) return

  error.value = ''
  dialogError.value = ''
  fieldErrors.value = {}

  const name = String(form.value.name ?? '').trim()
  let code = String(form.value.code ?? '').trim().toUpperCase()
  if (!code && name && !form.value.id) code = slugCode(name)
  form.value.name = name
  form.value.code = code

  const errors = validateForm()
  if (Object.keys(errors).length) {
    fieldErrors.value = errors
    focusFirstError(errors)
    return
  }

  saving.value = true
  try {
    const payload = {
      code,
      name,
      description: form.value.description ?? '',
      is_active: !!form.value.is_active,
    }

    if (form.value.id) await update(form.value.id, payload)
    else await create(payload)
  } catch (e) {
    const errs = e?.response?.data?.errors
    if (errs && typeof errs === 'object' && Object.keys(errs).length) {
      const first = (v) => (Array.isArray(v) ? v[0] : String(v ?? ''))
      fieldErrors.value = Object.fromEntries(
        Object.entries(errs).map(([key, value]) => [key, first(value)])
      )
      focusFirstError(fieldErrors.value)
    } else {
      dialogError.value = e?.response?.data?.message || 'Save failed.'
    }
    saving.value = false
    return
  }

  dialog.value = false
  saving.value = false
  toast.success(`Office "${name}" saved.`)
  fetchAll({ silent: true }).catch(() => {})
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
  fetchAll().catch(() => {})
})
</script>

<style scoped>
/* ==========================================================================
   Offices — sharp panel, header, table and footer
   (visual port of the supplied "Offices" mockup)
   ========================================================================== */
.ofp-page {
  --ofp-ink: rgb(var(--v-theme-on-surface));
  --ofp-muted: rgb(var(--v-theme-secondary));
  --ofp-line: rgba(var(--v-border-color), var(--v-border-opacity));
  --ofp-panel: rgb(var(--v-theme-surface));
  --ofp-field: #f4f6fb;
  --ofp-hover: #f3f6fc;
  --ofp-blue: #1d3fae;
  --ofp-blue-bg: #e8eeff;
  --ofp-ok: #1b7a3d;
  --ofp-ok-bg: #e3f5ea;
  --ofp-amber: #b86e00;
  --ofp-amber-bg: #fff1d6;
  --ofp-err: rgb(var(--v-theme-error));
  --ofp-err-bg: rgba(var(--v-theme-error), 0.12);
  --ofp-ring: rgba(29, 63, 174, 0.28);
  --ofp-h0: #1d3fae;
  --ofp-h1: #1b7a3d;
  --ofp-h2: #c77700;
  --ofp-h3: #8a3ab9;
  --ofp-h4: #0e7490;
  overflow: hidden;
  background: var(--ofp-panel);
  border: 1px solid var(--ofp-line);
  box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
  font-variant-numeric: tabular-nums;
}
html.dark .ofp-page {
  --ofp-field: #1c2645;
  --ofp-hover: #1d2745;
  --ofp-blue: #6f8cff;
  --ofp-blue-bg: #25306a;
  --ofp-ok: #3fbf6f;
  --ofp-ok-bg: #16382a;
  --ofp-amber: #ffbf47;
  --ofp-amber-bg: #4a3510;
  --ofp-err-bg: #4a1f22;
  --ofp-ring: rgba(138, 161, 255, 0.38);
  --ofp-h0: #7f9bff;
  --ofp-h1: #4cd080;
  --ofp-h2: #ffb347;
  --ofp-h3: #c995f0;
  --ofp-h4: #4cc3dd;
  box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
/* The mockup squares everything inside the page. Keep this scoped so the
   teleported modal and the other tabs retain their rounded styling. */
.ofp-page,
.ofp-page *,
.ofp-page *::before,
.ofp-page *::after {
  border-radius: 0 !important;
}
.ofp-page button:focus-visible,
.ofp-page a:focus-visible {
  outline: 3px solid var(--ofp-ring);
  outline-offset: 2px;
}

/* ---- Header ---- */
.ofp-hd {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 22px 28px;
  border-bottom: 3px solid var(--ofp-blue);
  flex-wrap: wrap;
}
.ofp-badge {
  display: grid;
  place-items: center;
  width: 52px;
  height: 52px;
  flex: none;
  background: var(--ofp-blue);
  color: #fff;
}
.ofp-hd-main {
  flex: 1 1 320px;
  min-width: 0;
}
.ofp-title {
  margin: 0;
  color: var(--ofp-ink);
  font-size: 24px;
  font-weight: 800;
  letter-spacing: -0.015em;
  line-height: 1.2;
}
.ofp-sub {
  margin: 4px 0 0;
  color: var(--ofp-muted);
  font-size: 13.5px;
  font-weight: 500;
  line-height: 1.4;
}
.ofp-tools {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: nowrap;
  margin-left: auto;
}
.ofp-search {
  position: relative;
  flex: 0 1 360px;
  min-width: 0;
  max-width: 360px;
}
.ofp-search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--ofp-muted);
  pointer-events: none;
}
.ofp-search-input {
  box-sizing: border-box;
  width: 100%;
  height: 46px;
  padding: 0 42px;
  border: 1.5px solid var(--ofp-line);
  border-radius: 0;
  background: var(--ofp-field);
  color: var(--ofp-ink);
  font: inherit;
  font-size: 14.5px;
  font-weight: 500;
  transition:
    border-color 0.15s,
    box-shadow 0.15s,
    background 0.15s;
}
.ofp-search-input::placeholder {
  color: var(--ofp-muted);
  opacity: 0.9;
}
.ofp-search-input:hover {
  border-color: rgba(var(--v-border-color), 0.8);
}
.ofp-search-input:focus {
  outline: none;
  border-color: var(--ofp-blue);
  background: var(--ofp-panel);
  box-shadow: 0 0 0 4px var(--ofp-ring);
}
.ofp-search-input::-webkit-search-cancel-button {
  display: none;
}
.ofp-clear {
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
  color: var(--ofp-muted);
  cursor: pointer;
}
.ofp-clear:hover {
  background: var(--ofp-line);
}
.ofp-add {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: 46px;
  padding: 0 20px;
  flex: none;
  border: 1.5px solid var(--ofp-blue);
  border-radius: 0;
  background: var(--ofp-blue);
  color: #fff;
  font: inherit;
  font-size: 14.5px;
  font-weight: 700;
  white-space: nowrap;
  cursor: pointer;
  transition: filter 0.15s;
}
.ofp-add:hover {
  filter: brightness(0.94);
}

/* ---- Alerts + table shell ---- */
.ofp-alert {
  margin: 16px 28px 0 !important;
  border-radius: 0 !important;
}
.ofp-wrap {
  min-width: 0;
  padding: 20px 28px 0;
}
.ofp-table {
  --v-table-row-height: 74px;
  --v-table-header-height: 44px;
  width: 100%;
  min-width: 0;
  background: transparent !important;
}
.ofp-table :deep(.v-table__wrapper) {
  overflow-x: auto;
  scrollbar-width: thin;
  scrollbar-color: var(--ofp-muted) var(--ofp-field);
}
.ofp-table :deep(.v-table__wrapper::-webkit-scrollbar) {
  width: 10px;
  height: 10px;
}
.ofp-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
  background: var(--ofp-field);
}
.ofp-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
  border: 2px solid var(--ofp-field);
  background: var(--ofp-muted);
}
.ofp-table :deep(table) {
  width: 100%;
  min-width: 960px;
  border-collapse: collapse;
  table-layout: fixed;
}
.ofp-table :deep(thead th.v-data-table__th) {
  height: 44px;
  padding: 0 14px !important;
  border: 0 !important;
  border-bottom: 1px solid var(--ofp-line) !important;
  border-radius: 0 !important;
  background: var(--ofp-field) !important;
  color: var(--ofp-muted) !important;
  font-size: 12px !important;
  font-weight: 800 !important;
  letter-spacing: 0.06em !important;
  text-align: left;
  text-transform: uppercase;
  white-space: nowrap;
}
.ofp-table :deep(thead th.v-data-table__th .v-data-table-header__content) {
  color: inherit !important;
  font-weight: 800 !important;
  letter-spacing: 0.06em !important;
  text-transform: uppercase;
  gap: 7px;
}
.ofp-table :deep(thead th.v-data-table__th .v-data-table-header__sort-icon) {
  width: 14px;
  height: 14px;
  font-size: 14px !important;
  color: currentColor !important;
  opacity: 0.35;
  transition:
    transform 0.15s,
    opacity 0.15s;
}
.ofp-table :deep(thead th.v-data-table__th--sortable:hover) {
  background: var(--ofp-hover) !important;
}
.ofp-table :deep(thead th.v-data-table__th--sorted) {
  color: var(--ofp-blue) !important;
}
.ofp-table
  :deep(thead th.v-data-table__th--sorted .v-data-table-header__content) {
  color: var(--ofp-blue) !important;
}
.ofp-table
  :deep(thead th.v-data-table__th--sorted .v-data-table-header__sort-icon) {
  opacity: 1;
}
.ofp-table :deep(thead th.v-data-table__th:last-child) {
  padding-left: 8px !important;
  text-align: right;
}
.ofp-table :deep(tbody td) {
  height: 74px;
  padding: 14px !important;
  border: 0 !important;
  border-bottom: 1px solid var(--ofp-line) !important;
  border-radius: 0 !important;
  color: var(--ofp-ink);
  font-size: 14.5px;
  vertical-align: middle;
}
.ofp-table :deep(tbody td:last-child) {
  padding-left: 8px !important;
  text-align: right;
}
.ofp-table :deep(tbody tr:not(.ofp-ghost):hover) {
  background: var(--ofp-hover) !important;
}
.ofp-table :deep(tbody tr.ofp-ghost) {
  pointer-events: none;
}
.ofp-table :deep(tbody tr.ofp-ghost td) {
  height: 74px;
  padding: 14px !important;
  border-bottom: 1px solid var(--ofp-line) !important;
}
.ofp-table :deep(.v-data-table-rows-no-data td) {
  height: 74px !important;
  padding: 0 !important;
  border-bottom: 1px solid var(--ofp-line) !important;
}
.ofp-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  min-height: 74px;
  padding: 0 14px;
  color: var(--ofp-muted);
  font-size: 14px;
  font-weight: 500;
  text-align: center;
}
.ofp-empty b {
  color: var(--ofp-ink);
}

/* ---- Cells ---- */
.ofp-code {
  display: inline-block;
  max-width: 100%;
  overflow: hidden;
  padding: 4px 9px;
  background: var(--ofp-field);
  color: var(--ofp-muted);
  font-family: ui-monospace, Menlo, Consolas, monospace;
  font-size: 12.5px;
  text-overflow: ellipsis;
  vertical-align: middle;
  white-space: nowrap;
}
.ofp-name {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
}
.ofp-av {
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  flex: none;
  overflow: hidden;
  border: 1px solid var(--ofp-field);
  background: var(--ofp-field);
  background: color-mix(in srgb, var(--ofp-h) 14%, var(--ofp-panel));
  border-color: color-mix(in srgb, var(--ofp-h) 32%, var(--ofp-panel));
  color: var(--ofp-h);
  font-size: 13px;
  font-weight: 800;
  line-height: 1;
  text-transform: uppercase;
}
/* Keep the row icon holders round despite the page-wide square-corner rule. */
.ofp-page .ofp-av {
  border-radius: 50% !important;
}
.ofp-av.h0 {
  --ofp-h: var(--ofp-h0);
}
.ofp-av.h1 {
  --ofp-h: var(--ofp-h1);
}
.ofp-av.h2 {
  --ofp-h: var(--ofp-h2);
}
.ofp-av.h3 {
  --ofp-h: var(--ofp-h3);
}
.ofp-av.h4 {
  --ofp-h: var(--ofp-h4);
}
.ofp-av-img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.ofp-av-text {
  display: block;
  line-height: 1;
}
.ofp-name-text {
  min-width: 0;
  overflow: hidden;
  color: var(--ofp-ink);
  font-size: 15px;
  font-weight: 600;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.ofp-desc {
  display: block;
  max-width: 100%;
  overflow: hidden;
  color: var(--ofp-muted);
  text-overflow: ellipsis;
  white-space: nowrap;
}
.ofp-dash {
  color: var(--ofp-line);
  font-weight: 700;
}
.ofp-status {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 5px 11px;
  border: 0;
  border-radius: 0;
  background: var(--ofp-ok-bg);
  color: var(--ofp-ok);
  font: inherit;
  font-size: 12.5px;
  font-weight: 700;
  white-space: nowrap;
}
.ofp-status.is-off {
  background: var(--ofp-field);
  color: var(--ofp-muted);
}
.ofp-status-dot {
  width: 7px;
  height: 7px;
  flex: none;
  background: currentColor;
}
.ofp-actions {
  display: flex;
  justify-content: flex-end;
  gap: 6px;
}
.ofp-ib {
  width: 40px !important;
  min-width: 40px !important;
  height: 40px !important;
  padding: 0 !important;
  border: 1.5px solid var(--ofp-line) !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--ofp-muted) !important;
  box-shadow: none !important;
}
.ofp-ib :deep(.v-icon) {
  font-size: 18px !important;
}
.ofp-ib.is-edit {
  border-color: var(--ofp-amber-bg) !important;
  color: var(--ofp-amber) !important;
}
.ofp-ib.is-edit:hover {
  background: var(--ofp-amber-bg) !important;
}
.ofp-ib.is-delete {
  border-color: var(--ofp-err-bg) !important;
  color: var(--ofp-err) !important;
}
.ofp-ib.is-delete:hover {
  background: var(--ofp-err-bg) !important;
}

/* ---- Footer ---- */
.ofp-pg {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 20px;
  padding: 16px 28px 20px;
  color: var(--ofp-muted);
  font-size: 14px;
  flex-wrap: wrap;
}
.ofp-per {
  display: flex;
  align-items: center;
  gap: 10px;
}
.ofp-select-wrap {
  position: relative;
  display: inline-flex;
  align-items: center;
}
.ofp-select {
  min-width: 76px;
  height: 40px;
  padding: 0 34px 0 12px;
  border: 1.5px solid var(--ofp-line);
  border-radius: 0;
  background: var(--ofp-panel);
  color: var(--ofp-ink);
  font: inherit;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  appearance: none;
  -webkit-appearance: none;
}
.ofp-select:focus {
  outline: none;
  border-color: var(--ofp-blue);
  box-shadow: 0 0 0 3px var(--ofp-ring);
}
.ofp-select-icon {
  position: absolute;
  right: 8px;
  pointer-events: none;
  color: var(--ofp-muted);
}
.ofp-range {
  color: var(--ofp-ink);
  font-weight: 700;
}
.ofp-pn {
  display: flex;
  gap: 4px;
}
.ofp-pn button {
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 1.5px solid var(--ofp-line);
  border-radius: 0;
  background: var(--ofp-panel);
  color: var(--ofp-ink);
  cursor: pointer;
}
.ofp-pn button:hover:not(:disabled) {
  background: var(--ofp-hover);
}
.ofp-pn button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.ofp-sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

@media (max-width: 900px) {
  .ofp-tools {
    flex: 1 1 100%;
    margin-left: 0;
  }
  .ofp-search {
    flex: 1 1 100%;
    max-width: none;
  }
}
@media (max-width: 760px) {
  .ofp-hd {
    padding: 18px 16px;
  }
  .ofp-title {
    font-size: 20px;
  }
  .ofp-wrap {
    padding: 16px 16px 0;
  }
  .ofp-alert {
    margin: 12px 16px 0 !important;
  }
  .ofp-pg {
    justify-content: center;
    padding: 16px;
  }
}
@media (max-width: 520px) {
  .ofp-add {
    padding: 0 16px;
  }
  .ofp-add-label {
    display: none;
  }
}

/* ---- New / Edit Office modal (design mockup port) ---- */
.ofc-card {
  overflow: hidden;
  box-shadow: 0 30px 70px -20px rgba(14, 22, 48, 0.5);
}

/* Header: tinted badge + title + subtitle + close. */
.ofc-hd {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 22px 24px 14px;
}
.ofc-badge {
  flex: none;
}
.ofc-hd-t {
  min-width: 0;
}
.ofc-title {
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.01em;
  line-height: 1.25;
}
.ofc-sub {
  margin-top: 3px;
  font-size: 14px;
  color: rgb(var(--v-theme-secondary));
}
.ofc-x {
  margin-left: auto;
  flex: none;
}

/* Body: label / field / help rhythm, scrolling inside the dialog. */
.ofc-bd {
  padding: 6px 24px 8px;
}
.ofc-f {
  margin-bottom: 18px;
}
.ofc-lb {
  display: block;
  margin-bottom: 7px;
  font-size: 14px;
  font-weight: 600;
}
.ofc-lb-row {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
}
.ofc-opt {
  font-weight: 500;
  color: rgb(var(--v-theme-secondary));
}
.ofc-cnt {
  font-size: 12.5px;
  font-weight: 500;
  color: rgb(var(--v-theme-secondary));
  font-variant-numeric: tabular-nums;
}
.ofc-req {
  color: rgb(var(--v-theme-error));
}
.ofc-help {
  margin: 6px 2px 0;
  font-size: 12.5px;
  color: rgb(var(--v-theme-secondary));
}

/* Fields: 48px tall, radius 12, tinted fill, soft focus ring. */
.ofc-in :deep(.v-field) {
  min-height: 48px;
  border-radius: 12px;
  background: #f4f6fb;
}
.ofc-in :deep(.v-field__outline) {
  --v-field-border-width: 1.5px;
}
.ofc-in :deep(.v-field--focused) {
  background: rgb(var(--v-theme-surface));
  box-shadow: 0 0 0 4px rgba(22, 48, 124, 0.18);
}
.ofc-in :deep(textarea) {
  min-height: 96px;
}
.ofc-mono :deep(input) {
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 14.5px;
  letter-spacing: 0.02em;
}

/* Active: bordered row, subtitle tracks the switch. */
.ofc-sw {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 6px;
  padding: 12px 14px;
  border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
  border-radius: 14px;
}
.ofc-sw-t {
  font-size: 14.5px;
  font-weight: 700;
}
.ofc-sw-d {
  font-size: 12.5px;
  color: rgb(var(--v-theme-secondary));
}
.ofc-sw-tg {
  flex: none;
}

/* Footer: ghost Cancel + primary Save, stacked on phones. */
.ofc-ft {
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 24px 20px;
}
.ofc-b {
  height: 46px;
  padding: 0 22px;
  border-width: 1.5px;
  font-weight: 700;
  text-transform: none;
}
.ofc-b-pri {
  min-width: 130px;
}

/* Dark theme (html.dark is toggled by AppShell for pixivDark). */
html.dark .ofc-in :deep(.v-field) {
  background: #232b45;
}
html.dark .ofc-in :deep(.v-field--focused) {
  background: rgb(var(--v-theme-surface));
  box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}
html.dark .ofc-sw {
  border-color: rgba(255, 255, 255, 0.16);
}

@media (max-width: 520px) {
  .ofc-ft {
    flex-direction: column-reverse;
  }
  .ofc-b {
    width: 100%;
  }
  :global(.office-dialog) {
    position: fixed !important;
    inset: auto 0 0 0 !important;
    width: 100% !important;
    max-width: 100% !important;
    margin: 0 !important;
  }
  :global(.office-dialog .v-card) {
    max-height: 94vh;
    border-radius: 24px 24px 0 0 !important;
  }
}
</style>
