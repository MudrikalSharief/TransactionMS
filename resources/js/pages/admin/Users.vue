<template>
  <LoadingVeil :show="loading" label="users" icon="mdi-account-group" />
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5 lgu-head">
      <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
        <v-icon color="#16307C">mdi-account-group</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">{{ officeMode ? 'Office Users' : 'Users' }}</span>
      <ScopeChip v-if="officeMode" class="ml-3" />
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
        Add User
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
        {{ error }}
      </v-alert>
      <v-alert
        v-if="canManage && pendingCount"
        type="warning"
        variant="tonal"
        density="compact"
        rounded="0"
        icon="mdi-account-clock-outline"
        class="mb-3"
      >
        {{ pendingCount === 1 ? '1 account is' : `${pendingCount} accounts are` }} waiting for approval.
        They're listed first; check the details, then approve or reject.
      </v-alert>

      <div class="d-flex flex-column table-stage" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        v-model:page="page"
        :items="filtered"
        :loading="loading"
        :headers="headers"
        item-key="id"
        density="compact"
        :items-per-page="PER_PAGE"
        :items-per-page-options="[PER_PAGE]"
        hover
        class="lgu-table table-pages table-fixed-cols"
      >
        <template v-slot:[`item.name`]="{ item }">
          <span class="cell-wrap font-weight-bold">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.email`]="{ item }">
          <span class="cell-wrap cell-wrap--any">{{ item.email }}</span>
        </template>

        <template v-slot:[`item.roles`]="{ item }">
          <div v-if="(item.roles || []).length" class="chip-stack">
            <v-chip
              v-for="r in item.roles"
              :key="r.id"
              rounded="0"
              size="small"
              variant="tonal"
              class="chip-wrap"
            >
              {{ r.name }}
            </v-chip>
          </div>
          <span v-else class="text-medium-emphasis" title="No active role">—</span>
        </template>

        <template v-slot:[`item.office`]="{ item }">
          <v-chip
            v-if="item.office?.name || officeNameById.get(Number(item.office_id))"
            rounded="0"
            size="small"
            variant="tonal"
            color="primary"
            class="font-weight-bold chip-wrap"
          >
            {{ item.office?.name || officeNameById.get(Number(item.office_id)) }}
          </v-chip>
          <span v-else class="text-medium-emphasis">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <v-chip v-if="item.pending_approval" color="warning" rounded="0" size="small" variant="tonal" class="chip-wrap">
            <v-icon start size="small">mdi-clock-outline</v-icon>
            Waiting for approval
          </v-chip>
          <v-chip v-else :color="item.is_active ? 'success' : 'error'" rounded="0" size="small" variant="tonal">
            <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
            {{ item.is_active ? 'Active' : 'Inactive' }}
          </v-chip>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div v-if="canManage" class="d-flex ga-3 justify-end row-actions">
            <span v-if="lockReason(item)" v-tooltip="lockReason(item)" class="d-flex align-center text-medium-emphasis">
              <v-icon size="small">mdi-lock-outline</v-icon>
            </span>
            <template v-else-if="item.pending_approval">
              <v-btn
                icon="mdi-check"
                v-tooltip="'Approve: let this person sign in'"
                size="small"
                variant="outlined"
                color="success"
                :loading="busyId === item.id"
                @click="approve(item)"
              />
              <v-btn
                icon="mdi-pencil"
                v-tooltip="'Edit before approving'"
                size="small"
                variant="outlined"
                color="grey-darken-3"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-close"
                v-tooltip="'Reject: remove this request'"
                size="small"
                variant="outlined"
                color="error"
                :disabled="busyId === item.id"
                @click="reject(item)"
              />
            </template>
            <template v-else>
              <v-btn
                icon="mdi-pencil"
                v-tooltip="'Edit user'"
                size="small"
                variant="outlined"
                color="grey-darken-3"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-account-off"
                v-tooltip="'Deactivate user'"
                size="small"
                variant="outlined"
                color="error"
                :disabled="item.id === meId"
                @click="deactivate(item)"
              />
            </template>
          </div>
        </template>
      </v-data-table>
      </div>
    </v-card-text>
  </v-card>

  <v-dialog
    v-model="dialog"
    max-width="540"
    scrollable
    content-class="nu-dialog"
    :persistent="saving"
    aria-labelledby="nu-title"
    @after-enter="focusName"
  >
    <form class="nu-form" autocomplete="off" novalidate @submit.prevent="save">
      <v-card class="nu-card" elevation="0">
        <div class="nu-hd">
          <div class="nu-badge" aria-hidden="true">
            <v-icon size="24">
              {{ isEdit ? 'mdi-account-edit-outline' : 'mdi-account-plus-outline' }}
            </v-icon>
          </div>
          <div class="nu-hd-copy">
            <h2 id="nu-title" class="nu-title">
              {{ isEdit ? 'Edit User' : 'New User' }}
            </h2>
            <p class="nu-sub">
              {{
                isEdit
                  ? 'Update this user’s account details and access.'
                  : 'Create an account and choose what the user can access.'
              }}
            </p>
          </div>
          <button
            type="button"
            class="nu-x"
            aria-label="Close"
            :disabled="saving"
            @click="closeDialog"
          >
            <v-icon size="20">mdi-close</v-icon>
          </button>
        </div>

        <div class="nu-bd">
          <div
            v-if="formError"
            ref="formErrorBanner"
            class="nu-alert"
            role="alert"
            tabindex="-1"
          >
            <v-icon size="18">mdi-alert-circle-outline</v-icon>
            <span>{{ formError }}</span>
          </div>

          <div class="nu-field" :class="{ 'is-bad': errors.name }">
            <label class="nu-label" for="nu-name">
              Name <span class="nu-req" aria-hidden="true">*</span>
            </label>
            <input
              id="nu-name"
              ref="nameInput"
              v-model="form.name"
              class="nu-input"
              type="text"
              maxlength="120"
              placeholder="e.g. Juan Dela Cruz"
              autocomplete="off"
              autocapitalize="words"
              aria-required="true"
              :aria-invalid="!!errors.name"
              :aria-describedby="errors.name ? 'nu-name-err' : undefined"
              :disabled="saving"
              @input="clearError('name')"
            />
            <div v-if="errors.name" id="nu-name-err" class="nu-err">
              {{ errors.name }}
            </div>
          </div>

          <div class="nu-field" :class="{ 'is-bad': errors.email }">
            <label class="nu-label" for="nu-email">
              Email <span class="nu-req" aria-hidden="true">*</span>
            </label>
            <input
              id="nu-email"
              ref="emailInput"
              v-model="form.email"
              class="nu-input"
              type="email"
              maxlength="190"
              placeholder="name@zamboanga.gov.ph"
              autocomplete="off"
              autocapitalize="none"
              spellcheck="false"
              inputmode="email"
              aria-required="true"
              :aria-invalid="!!errors.email"
              :aria-describedby="errors.email ? 'nu-email-err' : undefined"
              :disabled="saving"
              @input="clearError('email')"
            />
            <div v-if="errors.email" id="nu-email-err" class="nu-err">
              {{ errors.email }}
            </div>
          </div>

          <div class="nu-field" :class="{ 'is-bad': errors.contact_number }">
            <label class="nu-label" for="nu-contact">
              Contact number <span class="nu-opt">(optional)</span>
            </label>
            <input
              id="nu-contact"
              ref="contactInput"
              v-model="form.contact_number"
              class="nu-input"
              type="tel"
              maxlength="20"
              placeholder="09171234567"
              autocomplete="off"
              inputmode="tel"
              :aria-invalid="!!errors.contact_number"
              :aria-describedby="errors.contact_number ? 'nu-contact-err' : undefined"
              :disabled="saving"
              @input="clearError('contact_number')"
            />
            <div v-if="errors.contact_number" id="nu-contact-err" class="nu-err">
              {{ errors.contact_number }}
            </div>
          </div>

          <div class="nu-field nu-pw" :class="{ 'is-bad': errors.password }">
            <label class="nu-label" for="nu-password">
              {{ isEdit ? 'New password' : 'Password' }}
              <span v-if="!isEdit" class="nu-req" aria-hidden="true">*</span>
              <span v-else class="nu-opt">(optional)</span>
            </label>
            <div class="nu-pw-wrap">
              <input
                id="nu-password"
                ref="passwordInput"
                v-model="form.password"
                class="nu-input"
                :type="passwordVisible ? 'text' : 'password'"
                placeholder="At least 8 characters"
                autocomplete="new-password"
                spellcheck="false"
                :aria-required="!isEdit"
                :aria-invalid="!!errors.password"
                :aria-describedby="
                  errors.password ? 'nu-password-err' : 'nu-password-help'
                "
                :disabled="saving"
                @input="onPasswordInput"
              />
              <button
                type="button"
                class="nu-eye"
                :aria-label="
                  passwordVisible ? 'Hide password' : 'Show password'
                "
                :aria-pressed="passwordVisible"
                aria-controls="nu-password"
                :disabled="saving"
                @click="passwordVisible = !passwordVisible"
              >
                <v-icon size="20">
                  {{
                    passwordVisible
                      ? 'mdi-eye-off-outline'
                      : 'mdi-eye-outline'
                  }}
                </v-icon>
              </button>
            </div>
            <div
              v-if="!isEdit || form.password"
              class="nu-meter"
              :data-s="passwordStrength.score"
              aria-hidden="true"
            >
              <i v-for="n in 4" :key="n"></i>
            </div>
            <div id="nu-password-help" class="nu-pw-meta">
              <span>
                {{
                  isEdit
                    ? 'Leave blank to keep the current password. New passwords need at least 8 characters.'
                    : 'Use 8 or more characters. Mix letters, numbers and symbols.'
                }}
              </span>
              <b v-if="form.password">{{ passwordStrength.label }}</b>
            </div>
            <div v-if="errors.password" id="nu-password-err" class="nu-err">
              {{ errors.password }}
            </div>
          </div>

          <!-- New users start active; accounts waiting for approval stay
               inactive until approved, so the switch is only for others. -->
          <div v-if="isEdit && !form.pending_approval" class="nu-switch">
            <div class="nu-switch-copy">
              <b id="nu-active-label">{{ form.is_active ? 'Active' : 'Inactive' }}</b>
              <span id="nu-active-desc">
                {{
                  form.is_active
                    ? 'The user can sign in'
                    : 'The user can’t sign in'
                }}
              </span>
            </div>
            <button
              type="button"
              class="nu-toggle"
              role="switch"
              aria-labelledby="nu-active-label"
              aria-describedby="nu-active-desc"
              :aria-checked="form.is_active"
              :disabled="saving"
              @click="form.is_active = !form.is_active"
            ></button>
          </div>

          <div class="nu-field" :class="{ 'is-bad': errors.role_ids }">
            <span id="nu-roles-label" class="nu-label">
              Roles <span class="nu-req" aria-hidden="true">*</span>
            </span>
            <div
              ref="roleGroup"
              class="nu-roles"
              role="group"
              tabindex="-1"
              aria-labelledby="nu-roles-label"
              :aria-invalid="!!errors.role_ids"
              :aria-describedby="
                errors.role_ids ? 'nu-roles-err' : 'nu-roles-help'
              "
            >
              <span v-if="rolesLoading" class="nu-roles-loading">
                Loading roles…
              </span>
              <span v-else-if="!roleOptions.length" class="nu-roles-loading">
                No roles available.
              </span>
              <button
                v-for="role in roleOptions"
                :key="role.id"
                type="button"
                class="nu-role"
                :aria-pressed="isRoleSelected(role.id)"
                :disabled="saving || rolesLoading"
                @click="toggleRole(role.id)"
              >
                {{ role.label }}
              </button>
            </div>
            <div v-if="errors.role_ids" id="nu-roles-err" class="nu-err">
              {{ errors.role_ids }}
            </div>
            <div v-else id="nu-roles-help" class="nu-help">
              Select one or more.
            </div>
          </div>

          <div v-if="officeMode" class="nu-field nu-field-last">
            <span class="nu-label">Office</span>
            <div class="nu-help">
              {{ isEdit ? 'Stays in' : 'Joins' }} <b>{{ myOffice?.name || 'your office' }}</b>.
              Admin and superadmin roles are given by a superadmin.
            </div>
          </div>
          <div
            v-else
            class="nu-field nu-field-last"
            :class="{ 'is-bad': errors.office_id }"
          >
            <label class="nu-label" for="nu-office">
              Office <span class="nu-opt">(optional)</span>
            </label>
            <div class="nu-select-wrap">
              <select
                id="nu-office"
                ref="officeInput"
                v-model="form.office_id"
                class="nu-input nu-select"
                :disabled="saving || officesLoading"
                :aria-invalid="!!errors.office_id"
                :aria-describedby="
                  errors.office_id ? 'nu-office-err' : undefined
                "
                @change="clearError('office_id')"
              >
                <option v-if="officesLoading" :value="null" disabled>
                  Loading offices…
                </option>
                <option :value="null">No office assigned</option>
                <option
                  v-for="office in officeOptions"
                  :key="office.id"
                  :value="office.id"
                >
                  {{ office.label }}
                </option>
              </select>
              <v-icon class="nu-select-icon" size="20" aria-hidden="true">
                mdi-chevron-down
              </v-icon>
            </div>
            <div v-if="errors.office_id" id="nu-office-err" class="nu-err">
              {{ errors.office_id }}
            </div>
          </div>
        </div>

        <div class="nu-ft">
          <button
            type="button"
            class="nu-btn nu-btn-ghost"
            :disabled="saving"
            @click="closeDialog"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="nu-btn nu-btn-pri"
            :disabled="saving || rolesLoading"
            :aria-busy="saving"
          >
            <span v-if="saving" class="nu-spinner" aria-hidden="true"></span>
            {{
              saving
                ? isEdit
                  ? 'Saving…'
                  : 'Creating…'
                : isEdit
                  ? 'Save changes'
                  : 'Create user'
            }}
          </button>
        </div>
      </v-card>
    </form>
  </v-dialog>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useRoles } from '@/composables/useRoles'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import { useApi } from '@/composables/useApi'
import { confirm } from '@/composables/useConfirm'
import LoadingVeil from '@/components/LoadingVeil.vue'
import ScopeChip from '@/components/ScopeChip.vue'

const auth = useAuth()
const { api } = useApi()
// /office/users: an office admin managing their own office's members.
const officeMode = !!useRoute().meta.officeScope
const { users, loading, fetchUsers, createUser, updateUser, deactivateUser, approveUser, rejectUser } =
  useAdminUsers({ office: officeMode })
const { roles: allRoles, loading: allRolesLoading, fetchRoles: fetchAllRoles } = useRoles()
const { items: offices, loading: officesLoading, fetchAll: fetchOffices } = useOffices()

// Superadmins manage everyone; office admins manage their own office (/office/users).
const canManage = computed(() => officeMode || (auth.user.value?.roles ?? []).some((r) => r.code === 'superadmin'))
const meId = computed(() => auth.user.value?.id)
const myOffice = computed(() => auth.user.value?.office ?? null)

// Office admins may only give out roles below admin (server list).
const officeRoles = ref([])
const officeRolesLoading = ref(false)
const roles = computed(() => (officeMode ? officeRoles.value : allRoles.value))
const rolesLoading = computed(() => (officeMode ? officeRolesLoading.value : !!allRolesLoading.value))
async function fetchRoles() {
  if (!officeMode) return fetchAllRoles()
  officeRolesLoading.value = true
  try {
    const res = await api.get('/api/office/roles')
    officeRoles.value = res.data.data ?? res.data
  } finally {
    officeRolesLoading.value = false
  }
}

// Admins, superadmins and your own account stay with a superadmin.
function lockReason(item) {
  if (!officeMode) return ''
  if (item.id === meId.value) return 'Your own account is managed by a superadmin'
  if ((item.roles || []).some((r) => ['admin', 'superadmin'].includes(r.code))) {
    return 'Admins are managed by a superadmin'
  }
  return ''
}

// Two icon buttons side by side plus cell padding; a waiting account's
// three buttons wrap onto two lines.
const ACTIONS_W = 132
// Columns share the table's width by percentage (table-fixed-cols), so the
// table flexes with the window and the sidebar; long names, emails, roles
// and offices wrap inside their columns, and Status and the actions always
// stay in view.
const headers = officeMode
  ? [
      { title: 'Name', key: 'name', width: '30%' },
      { title: 'Email', key: 'email', width: '25%' },
      { title: 'Roles', key: 'roles', sortable: false, width: '18%' },
      { title: 'Status', key: 'is_active', width: '13%' },
      { title: '', key: 'actions', sortable: false, width: ACTIONS_W, align: 'end' },
    ]
  : [
      { title: 'Name', key: 'name', width: '24%' },
      { title: 'Email', key: 'email', width: '22%' },
      { title: 'Roles', key: 'roles', sortable: false, width: '15%' },
      { title: 'Office', key: 'office', sortable: false, width: '17%' },
      { title: 'Status', key: 'is_active', width: '12%' },
      { title: '', key: 'actions', sortable: false, width: ACTIONS_W, align: 'end' },
    ]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')
const search = ref('')
const PER_PAGE = 7
const page = ref(1)

let navObserver = null

// Client-side search: master data is small, filter loaded rows by
// name / email / roles / office / status without extra requests.
// Accounts waiting for approval come first.
const filtered = computed(() => {
  const q = String(search.value || '').trim().toLowerCase()
  const rows = !q
    ? users.value || []
    : (users.value || []).filter((u) =>
        [
          u.name,
          u.email,
          u.contact_number,
          (u.roles || []).map((r) => r.name).join(' '),
          u.office?.name || officeNameById.value.get(Number(u.office_id)) || '',
          u.pending_approval ? 'waiting for approval pending' : u.is_active ? 'active' : 'inactive',
        ].some((v) => String(v || '').toLowerCase().includes(q))
      )
  return [...rows].sort((a, b) => Number(!!b.pending_approval) - Number(!!a.pending_approval))
})

const pendingCount = computed(() => (users.value || []).filter((u) => u.pending_approval).length)
const busyId = ref(null)

async function approve(item) {
  error.value = ''
  busyId.value = item.id
  try {
    await approveUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Approve failed.'
  } finally {
    busyId.value = null
  }
}

async function reject(item) {
  const ok = await confirm({
    title: 'Reject this request?',
    message: `${item.name} (${item.email}) will not get access, and the request will be removed. They can sign up again.`,
    confirmLabel: 'Reject',
    cancelLabel: 'Keep',
  })
  if (!ok) return
  error.value = ''
  busyId.value = item.id
  try {
    await rejectUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Reject failed.'
  } finally {
    busyId.value = null
  }
}

// ---- New / Edit User dialog (redesigned form with validation) ----
const formError = ref('')
const errors = ref(blankErrors())
const nameInput = ref(null)
const emailInput = ref(null)
const contactInput = ref(null)
const passwordInput = ref(null)
const roleGroup = ref(null)
const officeInput = ref(null)
const formErrorBanner = ref(null)
const passwordVisible = ref(false)

function blankForm() {
  return {
    id: null,
    name: '',
    email: '',
    contact_number: '',
    password: '',
    is_active: true,
    pending_approval: false,
    role_ids: [],
    office_id: null,
  }
}

function blankErrors() {
  return {
    name: '',
    email: '',
    contact_number: '',
    password: '',
    role_ids: '',
    office_id: '',
  }
}

const form = ref(blankForm())
const isEdit = computed(() => !!form.value.id)

const passwordStrength = computed(() => {
  const password = form.value.password || ''
  if (!password) return { score: 0, label: '' }

  let score = 0
  if (password.length >= 8) score++
  if (password.length >= 12) score++
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++
  if (/\d/.test(password) && /[^A-Za-z0-9]/.test(password)) score++
  else if ((/\d/.test(password) || /[^A-Za-z0-9]/.test(password)) && password.length >= 10) score++

  if (password.length < 8) return { score: 1, label: 'Weak' }

  const level = Math.max(1, Math.min(4, score))
  return { score: level, label: ['', 'Weak', 'Fair', 'Good', 'Strong'][level] }
})

const roleOptions = computed(() =>
   (roles.value || []).map(r => ({ id: r.id, label: `${r.name}` })) // use ${r.code} to show Role Code
)

const officeOptions = computed(() =>
  (offices.value || []).map(o => ({ id: o.id, label: `${o.name}` }))
)

const officeNameById = computed(() => {
  const m = new Map()
  for (const o of (offices.value || [])) m.set(Number(o.id), o.name || o.code)
  return m
})

function openCreate() {
  error.value = ''
  formError.value = ''
  errors.value = blankErrors()
  passwordVisible.value = false
  form.value = blankForm()
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  formError.value = ''
  errors.value = blankErrors()
  passwordVisible.value = false
  form.value = {
    id: item.id,
    name: item.name || '',
    email: item.email || '',
    contact_number: item.contact_number || '',
    password: '',
    is_active: !!item.is_active,
    pending_approval: !!item.pending_approval,
    role_ids: (item.roles || []).map((r) => Number(r.id)),
    office_id:
      item.office_id != null
        ? Number(item.office_id)
        : item.office?.id != null
          ? Number(item.office.id)
          : null,
  }
  dialog.value = true
}

function closeDialog() {
  if (saving.value) return
  dialog.value = false
  formError.value = ''
  errors.value = blankErrors()
  passwordVisible.value = false
}

function focusName() {
  nextTick(() => nameInput.value?.focus())
}

function clearError(field) {
  if (field in errors.value) errors.value[field] = ''
  formError.value = ''
}

function onPasswordInput() {
  clearError('password')
}

function isRoleSelected(id) {
  return form.value.role_ids.some((roleId) => Number(roleId) === Number(id))
}

function toggleRole(id) {
  const roleId = Number(id)
  const index = form.value.role_ids.findIndex((value) => Number(value) === roleId)

  if (index >= 0) form.value.role_ids.splice(index, 1)
  else form.value.role_ids.push(roleId)

  clearError('role_ids')
}

function validate() {
  const next = blankErrors()
  const name = form.value.name.trim()
  const email = form.value.email.trim()
  const contact = String(form.value.contact_number || '').trim()
  const password = form.value.password || ''

  if (!name) next.name = 'Enter the user’s name.'

  if (!email) next.email = 'Enter an email address.'
  else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) next.email = 'Enter a valid email address.'

  if (contact && !/^\+?[0-9][0-9\s\-()]{6,18}$/.test(contact)) {
    next.contact_number = 'Enter a valid contact number, for example 09171234567.'
  }

  if ((!isEdit.value || password) && password.length < 8) {
    next.password = 'Password must be at least 8 characters.'
  }

  if (!Array.isArray(form.value.role_ids) || form.value.role_ids.length === 0) {
    next.role_ids = 'Select at least one role.'
  }

  errors.value = next
  return !Object.values(next).some(Boolean)
}

async function focusFirstError() {
  await nextTick()

  if (errors.value.name) {
    nameInput.value?.focus()
    return
  }
  if (errors.value.email) {
    emailInput.value?.focus()
    return
  }
  if (errors.value.contact_number) {
    contactInput.value?.focus()
    return
  }
  if (errors.value.password) {
    passwordInput.value?.focus()
    return
  }
  if (errors.value.role_ids) {
    const firstRole = roleGroup.value?.querySelector('button')
    ;(firstRole || roleGroup.value)?.focus()
    return
  }
  if (errors.value.office_id) officeInput.value?.focus()
}

function applyServerErrors(e) {
  const data = e?.response?.data || {}
  const validation = data.errors && typeof data.errors === 'object' ? data.errors : {}
  const next = { ...errors.value }
  let mapped = false

  for (const [key, messages] of Object.entries(validation)) {
    const field = key.startsWith('role_ids') ? 'role_ids' : key
    const message = Array.isArray(messages) ? messages[0] : messages

    if (field in next && message) {
      next[field] = message
      mapped = true
    }
  }

  errors.value = next

  if (mapped) {
    formError.value = ''
    void focusFirstError()
    return
  }

  formError.value = data.message || e?.message || 'Save failed.'
  void nextTick(() => formErrorBanner.value?.focus())
}

async function save() {
  if (saving.value) return

  formError.value = ''
  if (!validate()) {
    await focusFirstError()
    return
  }

  saving.value = true
  error.value = ''
  let saved = false

  try {
    const payload = {
      name: form.value.name.trim(),
      email: form.value.email.trim(),
      contact_number: String(form.value.contact_number || '').trim() || null,
      role_ids: form.value.role_ids.map((id) => Number(id)),
    }
    // Accounts waiting for approval stay inactive until approved.
    if (!form.value.pending_approval) payload.is_active = !!form.value.is_active
    // Office mode: the server always uses the admin's own office.
    if (!officeMode) {
      payload.office_id =
        form.value.office_id == null || form.value.office_id === ''
          ? null
          : Number(form.value.office_id)
    }
    if (form.value.password) payload.password = form.value.password

    if (isEdit.value) {
      await updateUser(form.value.id, payload)
    } else {
      await createUser({ ...payload, password: form.value.password })
    }

    saved = true
    dialog.value = false
  } catch (e) {
    applyServerErrors(e)
  } finally {
    saving.value = false
  }

  if (saved) {
    try {
      await fetchUsers()
    } catch {
      error.value = 'User saved, but the list could not be refreshed.'
    }
  }
}

async function deactivate(item) {
  error.value = ''
  try {
    await deactivateUser(item.id)
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Deactivate failed.'
  }
}

// Scroll only when there's enough to scroll: with fewer than SCROLL_FROM
// rows on the current table page, the tab keeps the usual scroll lock;
// from SCROLL_FROM rows up (wrapped rows can outgrow the screen) the page
// scrolls. Defined after `filtered` and everything it reads.
const SCROLL_FROM = 5
const rowsOnPage = computed(() => {
  const total = filtered.value.length
  return Math.max(0, Math.min(PER_PAGE, total - (page.value - 1) * PER_PAGE))
})
watch(search, () => { page.value = 1 })
watch(
  rowsOnPage,
  (n) => document.documentElement.classList.toggle('lock-scroll', n < SCROLL_FROM),
  { immediate: true },
)

onMounted(() => {
  // Scroll lock follows the rows on screen (see rowsOnPage): rows wrap to
  // show full names, emails and offices, so a full page of users can be
  // taller than the screen and then the page scrolls.
  // Independent lookups: run in parallel so one slow endpoint never blocks
  // the others. Each paints cache first, then revalidates silently.
  fetchRoles().catch(() => {})
  if (!officeMode) fetchOffices().catch(() => {})
  fetchUsers().catch(() => {})
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
/* Full text, wrapped within its column; the row grows to fit. Breaks
   between words; a single word longer than the column still breaks. */
.cell-wrap {
  display: block;
  white-space: normal;
  word-break: normal;
  overflow-wrap: break-word;
  line-height: 1.4;
  padding: 10px 0;
}
/* Emails have no spaces: let them break anywhere. */
.cell-wrap--any {
  overflow-wrap: anywhere;
}
/* Actions: always visible here (the global rule hides them while the
   sidebar is open); with little room the buttons wrap instead. */
.row-actions,
:global(html.nav-open) .row-actions {
  opacity: 1 !important;
  visibility: visible !important;
  animation: none !important;
  flex-wrap: wrap;
  gap: 8px !important;
  min-width: 0;
  padding: 6px 0;
}
.chip-stack {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  padding: 6px 0;
}
/* Chips that wrap long text instead of being cut at the column edge. */
.chip-wrap {
  height: auto !important;
  min-height: 24px;
  max-width: 100%;
  padding-block: 3px;
  white-space: normal;
}
.chip-wrap :deep(.v-chip__content) {
  white-space: normal;
  line-height: 1.3;
}
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

/* New / Edit User modal */
:global(.nu-dialog) {
  width: min(540px, calc(100vw - 40px)) !important;
  max-width: 540px !important;
}

.nu-form {
  width: 100%;
  max-width: 100%;
}

.nu-card {
  --nu-panel: #ffffff;
  --nu-ink: #14213d;
  --nu-muted: #5b6780;
  --nu-line: #d5dbe8;
  --nu-field: #f4f6fb;
  --nu-hover: #f3f6fc;
  --nu-blue: #1d3fae;
  --nu-blue-d: #142d82;
  --nu-blue-bg: #e8eeff;
  --nu-err: #c62828;
  --nu-err-bg: rgba(198, 40, 40, 0.07);
  --nu-ok: #1b7a3d;
  --nu-warn: #c77700;
  --nu-lime: #7aa11f;
  --nu-ring: rgba(29, 63, 174, 0.28);
  --nu-input-hover: #aab4cc;
  --nu-placeholder: #7b869e;
  --nu-switch-off: #98a2b8;
  color-scheme: light;
  display: flex;
  flex-direction: column;
  width: 100%;
  min-width: 0;
  max-height: calc(100vh - 40px) !important;
  max-height: calc(100dvh - 40px) !important;
  overflow: hidden !important;
  border-radius: 24px !important;
  background: var(--nu-panel) !important;
  color: var(--nu-ink);
  box-shadow: 0 30px 70px -20px rgba(0, 0, 0, 0.5) !important;
  font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
}

html.dark .nu-card {
  --nu-panel: #161e36;
  --nu-ink: #eef2fb;
  --nu-muted: #9aa7c4;
  --nu-line: #2b3558;
  --nu-field: #1c2645;
  --nu-hover: #1d2745;
  --nu-blue: #6f8cff;
  --nu-blue-d: #8aa1ff;
  --nu-blue-bg: #25306a;
  --nu-err: #ff8a80;
  --nu-err-bg: rgba(255, 138, 128, 0.1);
  --nu-ok: #3fbf6f;
  --nu-warn: #ffb347;
  --nu-lime: #a3c14a;
  --nu-ring: rgba(138, 161, 255, 0.38);
  --nu-input-hover: #4a5a86;
  --nu-switch-off: #4b587b;
  color-scheme: dark;
  box-shadow: 0 30px 80px -20px rgba(0, 0, 0, 0.75) !important;
}

.nu-card,
.nu-card * {
  box-sizing: border-box;
}

.nu-card button,
.nu-card input,
.nu-card select {
  font-family: inherit;
}

.nu-hd {
  display: flex;
  flex: none;
  align-items: flex-start;
  gap: 14px;
  padding: 22px 24px 14px;
}

.nu-badge {
  display: grid;
  flex: none;
  place-items: center;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: var(--nu-blue-bg);
  color: var(--nu-blue);
}

.nu-hd-copy {
  flex: 1;
  min-width: 0;
}

.nu-title {
  margin: 0;
  font-size: 20px;
  font-weight: 800;
  line-height: 1.2;
  letter-spacing: -0.01em;
  color: var(--nu-ink);
}

.nu-sub {
  margin: 3px 0 0;
  font-size: 14px;
  line-height: 1.3;
  color: var(--nu-muted);
}

.nu-x {
  display: grid;
  flex: none;
  place-items: center;
  width: 36px;
  height: 36px;
  margin-left: auto;
  padding: 0;
  border: 0;
  border-radius: 10px;
  background: none;
  color: var(--nu-muted);
  cursor: pointer;
  transition: background-color 0.15s, color 0.15s;
}

.nu-x:hover:not(:disabled) {
  background: var(--nu-hover);
  color: var(--nu-ink);
}

.nu-x:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.nu-bd {
  flex: 1 1 auto;
  min-height: 0;
  padding: 20px 24px 8px;
  overflow-y: auto;
  overscroll-behavior: contain;
  scrollbar-color: var(--nu-line) transparent;
  scrollbar-width: thin;
}

.nu-bd::-webkit-scrollbar {
  width: 10px;
}

.nu-bd::-webkit-scrollbar-thumb {
  border: 3px solid var(--nu-panel);
  border-radius: 99px;
  background: var(--nu-line);
}

.nu-bd::-webkit-scrollbar-track {
  background: transparent;
}

.nu-alert {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 16px;
  padding: 10px 12px;
  border: 1.5px solid var(--nu-err);
  border-radius: 12px;
  background: var(--nu-err-bg);
  color: var(--nu-err);
  font-size: 13.5px;
  font-weight: 600;
  line-height: 1.35;
}

.nu-field {
  position: relative;
  margin-bottom: 18px;
}

.nu-field-last {
  margin-bottom: 8px;
}

.nu-label {
  display: block;
  margin-bottom: 7px;
  font-size: 14px;
  font-weight: 600;
  line-height: 1.25;
  color: var(--nu-ink);
}

.nu-req {
  color: var(--nu-err);
}

.nu-opt {
  color: var(--nu-muted);
  font-weight: 500;
}

.nu-input {
  width: 100%;
  height: 48px;
  padding: 0 14px;
  border: 1.5px solid var(--nu-line);
  border-radius: 12px;
  outline: none;
  background: var(--nu-field);
  color: var(--nu-ink);
  font-size: 15.5px;
  line-height: 1.3;
  transition: border-color 0.15s, box-shadow 0.15s, background-color 0.15s;
}

.nu-input::placeholder {
  color: var(--nu-placeholder);
}

.nu-input:hover {
  border-color: var(--nu-input-hover);
}

.nu-input:focus {
  border-color: var(--nu-blue);
  background: var(--nu-panel);
  box-shadow: 0 0 0 4px var(--nu-ring);
}

.nu-input[aria-invalid='true'],
.is-bad .nu-input {
  border-color: var(--nu-err);
}

.nu-input:disabled {
  cursor: not-allowed;
  opacity: 0.65;
}

.nu-input:-webkit-autofill {
  -webkit-text-fill-color: var(--nu-ink);
  box-shadow: 0 0 0 1000px var(--nu-field) inset;
  transition: background-color 9999s ease-out;
}

.nu-help {
  margin: 6px 2px 0;
  color: var(--nu-muted);
  font-size: 12.5px;
  line-height: 1.3;
}

.nu-err {
  margin: 6px 2px 0;
  color: var(--nu-err);
  font-size: 12.5px;
  font-weight: 600;
  line-height: 1.3;
}

.nu-pw-wrap {
  position: relative;
}

.nu-pw .nu-input {
  padding-right: 50px;
}

.nu-pw .nu-input::-ms-reveal,
.nu-pw .nu-input::-ms-clear {
  display: none;
}

.nu-eye {
  position: absolute;
  top: 4px;
  right: 4px;
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 0;
  border-radius: 10px;
  background: none;
  color: var(--nu-muted);
  cursor: pointer;
  transition: background-color 0.15s, color 0.15s;
}

.nu-eye:hover:not(:disabled) {
  background: var(--nu-hover);
  color: var(--nu-ink);
}

.nu-eye:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.nu-meter {
  display: flex;
  gap: 4px;
  margin-top: 10px;
}

.nu-meter i {
  flex: 1;
  height: 4px;
  border-radius: 99px;
  background: var(--nu-line);
  transition: background-color 0.2s;
}

.nu-meter[data-s='1'] i:nth-child(-n + 1) {
  background: var(--nu-err);
}

.nu-meter[data-s='2'] i:nth-child(-n + 2) {
  background: var(--nu-warn);
}

.nu-meter[data-s='3'] i:nth-child(-n + 3) {
  background: var(--nu-lime);
}

.nu-meter[data-s='4'] i {
  background: var(--nu-ok);
}

.nu-pw-meta {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  margin-top: 6px;
  color: var(--nu-muted);
  font-size: 12.5px;
  line-height: 1.3;
}

.nu-pw-meta b {
  flex: none;
  color: var(--nu-ink);
  font-weight: 700;
}

.nu-switch {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 18px;
  padding: 12px 14px;
  border: 1.5px solid var(--nu-line);
  border-radius: 14px;
}

.nu-switch-copy b {
  display: block;
  color: var(--nu-ink);
  font-size: 14.5px;
  line-height: 1.3;
}

.nu-switch-copy span {
  display: block;
  margin-top: 2px;
  color: var(--nu-muted);
  font-size: 12.5px;
  line-height: 1.3;
}

.nu-toggle {
  position: relative;
  flex: none;
  width: 48px;
  height: 28px;
  margin-left: auto;
  padding: 0;
  border: 0;
  border-radius: 99px;
  background: var(--nu-switch-off);
  cursor: pointer;
  transition: background-color 0.2s;
}

.nu-toggle::after {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  transition: transform 0.2s;
}

.nu-toggle[aria-checked='true'] {
  background: var(--nu-ok);
}

.nu-toggle[aria-checked='true']::after {
  transform: translateX(20px);
}

.nu-toggle:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.nu-roles {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.nu-roles-loading {
  color: var(--nu-muted);
  font-size: 13px;
  line-height: 40px;
}

.nu-role {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  min-height: 40px;
  max-width: 100%;
  padding: 8px 14px 8px 12px;
  border: 1.5px solid var(--nu-line);
  border-radius: 99px;
  background: none;
  color: var(--nu-ink);
  font-size: 14px;
  font-weight: 600;
  line-height: 1.25;
  text-align: left;
  overflow-wrap: anywhere;
  cursor: pointer;
  transition: background-color 0.15s, border-color 0.15s, color 0.15s;
}

.nu-role::before {
  content: '';
  flex: none;
  width: 16px;
  height: 16px;
  border: 2px solid var(--nu-line);
  border-radius: 50%;
  transition: background-color 0.15s, border-color 0.15s;
}

.nu-role:hover:not(:disabled) {
  background: var(--nu-hover);
}

.nu-role[aria-pressed='true'] {
  border-color: var(--nu-blue);
  background: var(--nu-blue-bg);
  color: var(--nu-blue);
}

.nu-role[aria-pressed='true']::before {
  border-color: var(--nu-blue);
  background: var(--nu-blue)
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='m4 8.5 2.8 2.8L12 5.5' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E")
    center / 100% no-repeat;
}

.nu-role:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.nu-select-wrap {
  position: relative;
}

.nu-select {
  padding-right: 42px;
  appearance: none;
  cursor: pointer;
}

.nu-select-icon {
  position: absolute;
  top: 50%;
  right: 13px;
  color: var(--nu-muted);
  pointer-events: none;
  transform: translateY(-50%);
}

.nu-ft {
  display: flex;
  flex: none;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 24px 20px;
  border-top: 1px solid var(--nu-line);
}

.nu-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 46px;
  padding: 0 22px;
  border: 1.5px solid transparent;
  border-radius: 12px;
  font-size: 14.5px;
  font-weight: 700;
  line-height: 1;
  cursor: pointer;
  transition: background-color 0.15s, border-color 0.15s, color 0.15s;
}

.nu-btn:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.nu-btn-ghost {
  border-color: var(--nu-line);
  background: none;
  color: var(--nu-ink);
}

.nu-btn-ghost:hover:not(:disabled) {
  background: var(--nu-hover);
}

.nu-btn-pri {
  min-width: 130px;
  border-color: var(--nu-blue);
  background: var(--nu-blue);
  color: #ffffff;
}

.nu-btn-pri:hover:not(:disabled) {
  border-color: var(--nu-blue-d);
  background: var(--nu-blue-d);
}

.nu-spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  margin-right: 8px;
  border: 2px solid rgba(255, 255, 255, 0.35);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: nu-spin 0.7s linear infinite;
}

.nu-x:focus-visible,
.nu-eye:focus-visible,
.nu-toggle:focus-visible,
.nu-role:focus-visible,
.nu-btn:focus-visible,
.nu-alert:focus-visible {
  outline: 3px solid var(--nu-ring);
  outline-offset: 2px;
}

@keyframes nu-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 520px) {
  :global(.nu-dialog) {
    position: fixed !important;
    inset: auto 0 0 0 !important;
    width: 100% !important;
    max-width: 100% !important;
    margin: 0 !important;
  }

  .nu-card {
    max-height: 94vh !important;
    max-height: 94dvh !important;
    border-radius: 24px 24px 0 0 !important;
  }

  .nu-ft {
    flex-direction: column-reverse;
    padding: 16px 24px calc(20px + env(safe-area-inset-bottom, 0px));
  }

  .nu-btn {
    width: 100%;
  }
}

@media (prefers-reduced-motion: reduce) {
  .nu-card *,
  .nu-card *::before,
  .nu-card *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
</style>
