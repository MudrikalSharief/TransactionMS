<template>
  <LoadingVeil :show="loading" label="users" icon="mdi-account-group" />
  <v-card rounded="0" elevation="0" class="us-page mb-4">
    <header class="us-hd">
      <div class="us-badge" aria-hidden="true">
        <v-icon size="26">mdi-account-group</v-icon>
      </div>
      <div class="us-hd-main">
        <div class="us-titlewrap">
          <h1 class="us-title">{{ officeMode ? 'Office Users' : 'Users' }}</h1>
          <ScopeChip v-if="officeMode" class="us-scope" />
        </div>
        <p class="us-sub">
          {{
            officeMode
              ? 'The members of your office — their roles and account status.'
              : 'The people who use the system — their roles, offices and status.'
          }}
        </p>
      </div>
      <div class="us-tools">
        <div class="us-search" role="search">
          <v-icon class="us-search-icon" size="19">mdi-magnify</v-icon>
          <input
            v-model="search"
            type="search"
            class="us-search-input"
            placeholder="Search name, email, role or office"
            aria-label="Search users"
            autocomplete="off"
          />
          <button
            v-if="search"
            type="button"
            class="us-clear"
            aria-label="Clear search"
            @click="clearSearch"
          >
            <v-icon size="16">mdi-close</v-icon>
          </button>
        </div>
        <button
          v-if="canManage"
          type="button"
          class="us-add"
          aria-label="Add user"
          @click="openCreate"
        >
          <v-icon size="18">mdi-plus</v-icon>
          <span class="us-add-label">Add user</span>
        </button>
      </div>
    </header>

    <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="us-alert">
      {{ error }}
    </v-alert>
    <v-alert
      v-if="canManage && pendingCount"
      type="warning"
      variant="tonal"
      density="compact"
      rounded="0"
      icon="mdi-account-clock-outline"
      class="us-alert us-warn"
    >
      {{ pendingCount === 1 ? '1 account is' : `${pendingCount} accounts are` }} waiting for approval.
      They're listed first; check the details, then approve or reject.
    </v-alert>

    <div class="us-wrap">
      <v-data-table
        v-show="!loading"
        v-model:page="page"
        :items="filtered"
        :headers="headers"
        :loading="loading"
        item-key="id"
        :items-per-page="PER_PAGE"
        :hide-default-footer="true"
        hover
        class="us-table"
      >
        <template v-slot:[`item.name`]="{ item }">
          <span class="us-name">{{ item.name }}</span>
        </template>

        <template v-slot:[`item.email`]="{ item }">
          <span class="us-email">{{ item.email }}</span>
        </template>

        <template v-slot:[`item.roles`]="{ item }">
          <div v-if="(item.roles || []).length" class="us-roles">
            <v-chip
              v-for="r in item.roles"
              :key="r.id"
              rounded="0"
              size="small"
              variant="tonal"
              class="us-role"
            >
              {{ r.name }}
            </v-chip>
          </div>
          <span v-else class="us-dash" title="No active role">—</span>
        </template>

        <template v-slot:[`item.office`]="{ item }">
          <span
            v-if="item.office?.name || officeNameById.get(Number(item.office_id))"
            class="us-office is-specific"
            :title="item.office?.name || officeNameById.get(Number(item.office_id))"
          >
            <img
              v-if="officeIcon(userOffice(item))"
              class="us-office-icon"
              :src="officeIcon(userOffice(item))"
              :alt="`${item.office?.name || officeNameById.get(Number(item.office_id))} icon`"
            />
            <span
              v-else
              class="us-office-icon-ph"
              aria-label="No office icon"
            >
              ?
            </span>
            <span class="us-office-text">{{
              item.office?.name || officeNameById.get(Number(item.office_id))
            }}</span>
          </span>
          <span v-else class="us-dash">—</span>
        </template>

        <template v-slot:[`item.is_active`]="{ item }">
          <span v-if="item.pending_approval" class="us-status is-pending">
            <v-icon size="14">mdi-clock-outline</v-icon>
            Waiting
          </span>
          <span v-else-if="item.is_active" class="us-status is-active">
            <span class="us-status-dot" aria-hidden="true" />
            Active
          </span>
          <span v-else class="us-status is-off">
            <span class="us-status-dot" aria-hidden="true" />
            Inactive
          </span>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <div v-if="canManage" class="us-actions">
            <span
              v-if="lockReason(item)"
              v-tooltip="lockReason(item)"
              class="us-lock"
            >
              <v-icon size="18">mdi-lock-outline</v-icon>
            </span>
            <template v-else-if="item.pending_approval">
              <v-btn
                icon="mdi-check"
                v-tooltip="'Approve: let this person sign in'"
                size="small"
                variant="outlined"
                rounded="0"
                class="us-ib is-ok"
                :loading="busyId === item.id"
                @click="approve(item)"
              />
              <v-btn
                icon="mdi-pencil"
                v-tooltip="'Edit before approving'"
                size="small"
                variant="outlined"
                rounded="0"
                class="us-ib is-edit"
                :disabled="busyId === item.id"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-close"
                v-tooltip="'Reject: remove this request'"
                size="small"
                variant="outlined"
                rounded="0"
                class="us-ib is-delete"
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
                rounded="0"
                class="us-ib is-edit"
                :disabled="busyId === item.id"
                @click="openEdit(item)"
              />
              <v-btn
                icon="mdi-account-off"
                v-tooltip="'Deactivate user'"
                size="small"
                variant="outlined"
                rounded="0"
                class="us-ib is-delete"
                :disabled="item.id === meId"
                @click="deactivate(item)"
              />
            </template>
          </div>
        </template>

        <template #no-data>
          <div class="us-empty">
            <template v-if="search.trim()">
              <b>No matches</b> for “{{ search.trim() }}”. Try a different word.
            </template>
            <template v-else>
              <b>No users yet.</b>
              <span v-if="canManage"> Use “Add user” to create the first one. </span>
            </template>
          </div>
        </template>

        <template #body.append>
          <tr
            v-for="n in ghostRows"
            :key="`ghost-${n}`"
            class="us-ghost"
            aria-hidden="true"
          >
            <td v-for="h in headers" :key="h.key" />
          </tr>
        </template>
      </v-data-table>
    </div>

    <footer class="us-pg">
      <div class="us-per">
        <span>Items per page</span>
        <span class="us-per-box" aria-label="Items per page: 8">
          <span>8</span>
          <v-icon size="18" aria-hidden="true">mdi-chevron-down</v-icon>
        </span>
      </div>
      <span class="us-range">{{ rangeLabel }}</span>
      <div class="us-pn" role="group" aria-label="Pagination">
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
    </footer>
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
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useRoles } from '@/composables/useRoles'
import { useOffices } from '@/composables/useOffices'
import { useAuth } from '@/composables/useAuth'
import { useApi } from '@/composables/useApi'
import { confirm } from '@/composables/useConfirm'
import LoadingVeil from '@/components/LoadingVeil.vue'
import ScopeChip from '@/components/ScopeChip.vue'
import { officeIcon } from '@/utils/officeIcons'

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
// Columns share the table's width by percentage, so the table flexes with
// the window and the sidebar; long names, emails, roles and offices wrap
// inside their columns, and Status and the actions always stay in view.
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
const PER_PAGE = 8
const page = ref(1)

const pageCount = computed(() =>
  Math.max(1, Math.ceil(filtered.value.length / PER_PAGE)),
)
const pageStart = computed(() =>
  filtered.value.length ? (page.value - 1) * PER_PAGE + 1 : 0,
)
const pageEnd = computed(() =>
  Math.min(page.value * PER_PAGE, filtered.value.length),
)
const rangeLabel = computed(() =>
  filtered.value.length
    ? `${pageStart.value}–${pageEnd.value} of ${filtered.value.length}`
    : '0 of 0',
)
// Keep the seven-row rhythm: fill only the remaining slots with ghosts.
const ghostRows = computed(() => {
  const used = filtered.value.length
    ? Math.max(0, pageEnd.value - pageStart.value + 1)
    : 1
  return Math.max(0, PER_PAGE - used)
})

function goPage(next) {
  page.value = Math.min(pageCount.value, Math.max(1, Number(next) || 1))
}

function clearSearch() {
  search.value = ''
}

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

// Full office row for the icon chip (the API may embed a partial office).
function userOffice(item) {
  const id =
    item.office_id != null
      ? Number(item.office_id)
      : item.office?.id != null
        ? Number(item.office.id)
        : null
  if (id == null) return null
  const byId = (offices.value || []).find((o) => Number(o.id) === id)
  if (byId) return byId
  return item.office && Number(item.office.id) === id ? item.office : null
}

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

watch(search, () => { page.value = 1 })
watch(
  () => filtered.value.length,
  (length) => {
    if (page.value > Math.ceil(length / PER_PAGE)) {
      page.value = Math.max(1, Math.ceil(length / PER_PAGE))
    }
  },
)

onMounted(() => {
  // Independent lookups: run in parallel so one slow endpoint never blocks
  // the others. Each paints cache first, then revalidates silently.
  fetchRoles().catch(() => {})
  if (!officeMode) fetchOffices().catch(() => {})
  fetchUsers().catch(() => {})
})
</script>

<style scoped>
/* ==========================================================================
   Users — sharp panel, header, table and footer
   (visual port of the Offices / Transaction Types design system)
   ========================================================================== */
.us-page {
    --us-ink: rgb(var(--v-theme-on-surface));
    --us-muted: rgb(var(--v-theme-secondary));
    --us-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --us-panel: rgb(var(--v-theme-surface));
    --us-field: #f4f6fb;
    --us-hover: #f3f6fc;
    --us-blue: #005EED;
    --us-blue-bg: #e8eeff;
    --us-amber: #b86e00;
    --us-amber-bg: #fff1d6;
    --us-ok: #1b7a3d;
    --us-ok-bg: #e3f4e8;
    --us-err: rgb(var(--v-theme-error));
    --us-err-bg: rgba(var(--v-theme-error), 0.12);
    --us-ring: rgba(29, 63, 174, 0.28);
    overflow: hidden;
    background: var(--us-panel);
    border: 1px solid var(--us-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}
html.dark .us-page {
    --us-field: #1c2645;
    --us-hover: #1d2745;
    --us-blue: #6f8cff;
    --us-blue-bg: #25306a;
    --us-amber: #ffbf47;
    --us-amber-bg: #4a3510;
    --us-ok: #3fbf6f;
    --us-ok-bg: #1e3b28;
    --us-err-bg: #4a1f22;
    --us-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
.us-page button:focus-visible,
.us-page a:focus-visible {
    outline: 3px solid var(--us-ring);
    outline-offset: 2px;
}

/* ---- Header ---- */
.us-hd {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 22px 28px;
    border-bottom: 3px solid var(--us-blue);
    flex-wrap: wrap;
}
.us-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--tms-grad);
    color: #fff;
}
.us-hd-main {
    flex: 1 1 320px;
    min-width: 0;
}
.us-titlewrap {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}
.us-title {
    margin: 0;
    color: var(--us-ink);
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}
.us-sub {
    margin: 4px 0 0;
    color: var(--us-muted);
    font-size: 13.5px;
    font-weight: 500;
    line-height: 1.4;
}
.us-tools {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: nowrap;
    margin-left: auto;
}
.us-search {
    position: relative;
    flex: 0 0 320px;
    min-width: 0;
    max-width: 320px;
}
.us-search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--us-muted);
    pointer-events: none;
}
.us-search-input {
    width: 100%;
    height: 46px;
    padding: 0 42px;
    border: 1.5px solid var(--us-line);
    border-radius: 0;
    background: var(--us-field);
    color: var(--us-ink);
    font: inherit;
    font-size: 14.5px;
    font-weight: 500;
    transition:
        border-color 0.15s,
        box-shadow 0.15s,
        background 0.15s;
}
.us-search-input::placeholder {
    color: var(--us-muted);
    opacity: 0.9;
}
.us-search-input:hover {
    border-color: rgba(var(--v-border-color), 0.8);
}
.us-search-input:focus {
    outline: none;
    border-color: var(--us-blue);
    background: var(--us-panel);
    box-shadow: 0 0 0 4px var(--us-ring);
}
.us-search-input::-webkit-search-cancel-button {
    display: none;
}
.us-clear {
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
    color: var(--us-muted);
    cursor: pointer;
}
.us-clear:hover {
    background: var(--us-line);
}
.us-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: 46px;
    padding: 0 20px;
    flex: none;
    border: 1.5px solid var(--us-blue);
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
.us-add:hover {
    filter: brightness(0.94);
}

/* ---- Alerts + table shell ---- */
.us-alert {
    margin: 16px 28px 0 !important;
    border-radius: 0 !important;
}
.us-warn {
    margin-bottom: 0;
}
.us-wrap {
    min-width: 0;
    padding: 20px 28px 0;
}
.us-table {
    --v-table-row-height: var(--tms-row);
    --v-table-header-height: 44px;
    width: 100%;
    min-width: 0;
    background: transparent !important;
}
.us-table :deep(.v-table__wrapper) {
    overflow-x: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--us-muted) var(--us-field);
}
.us-table :deep(.v-table__wrapper::-webkit-scrollbar) {
    width: 10px;
    height: 10px;
}
.us-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
    background: var(--us-field);
}
.us-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
    border: 2px solid var(--us-field);
    background: var(--us-muted);
}
.us-table :deep(table) {
    width: 100%;
    min-width: 900px;
    border-collapse: collapse;
    table-layout: fixed;
}
.us-table :deep(thead th.v-data-table__th) {
    height: 44px;
    padding: 0 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--us-line) !important;
    border-radius: 0 !important;
    background: var(--us-field) !important;
    color: var(--us-muted) !important;
    font-size: 12px !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-align: left;
    text-transform: uppercase;
    white-space: nowrap;
}
.us-table :deep(thead th.v-data-table__th .v-data-table-header__content) {
    color: var(--us-muted) !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-transform: uppercase;
}
.us-table :deep(thead th.v-data-table__th .v-icon) {
    color: var(--us-muted) !important;
    opacity: 0.65;
}
.us-table :deep(thead th.v-data-table__th:last-child) {
    padding-left: 8px !important;
    text-align: right;
}
.us-table :deep(tbody td:last-child) {
    padding-left: 8px !important;
}
.us-table :deep(tbody td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--us-line) !important;
    border-radius: 0 !important;
    color: var(--us-ink);
    font-size: 14.5px;
    vertical-align: middle;
}
.us-table :deep(tbody tr:not(.us-ghost):hover) {
    background: var(--us-hover) !important;
}
.us-table :deep(tbody tr.us-ghost) {
    pointer-events: none;
}
.us-table :deep(tbody tr.us-ghost td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border-bottom: 1px solid var(--us-line) !important;
}
.us-table :deep(.v-data-table-rows-no-data td) {
    height: var(--tms-row) !important;
    padding: 0 !important;
    border-bottom: 1px solid var(--us-line) !important;
}
.us-empty {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 5px;
    min-height: var(--tms-row);
    padding: 0 14px;
    color: var(--us-muted);
    font-size: 14px;
    font-weight: 500;
    text-align: center;
}
.us-empty b {
    color: var(--us-ink);
}

/* ---- Cells ---- */
/* Names, emails, roles and offices wrap inside their columns (rows grow). */
.us-name {
    display: block;
    color: var(--us-ink);
    font-weight: 600;
    line-height: 1.4;
    overflow-wrap: anywhere;
    white-space: normal;
}
.us-email {
    display: block;
    color: var(--us-muted);
    line-height: 1.4;
    overflow-wrap: anywhere;
    white-space: normal;
}
.us-dash {
    color: var(--us-muted);
}
.us-roles {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
}
/* Chips wrap long role names instead of being cut at the column edge. */
.us-role {
    height: auto !important;
    min-height: 24px;
    max-width: 100%;
    padding-block: 3px;
    white-space: normal;
    font-weight: 600;
}
.us-role :deep(.v-chip__content) {
    line-height: 1.3;
    white-space: normal;
}
/* Office chip with icon (same pattern as Transaction Types). */
.us-office {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    max-width: 100%;
    padding: 4px 10px 4px 5px;
    background: var(--us-blue-bg);
    color: var(--us-blue);
    font-size: 13px;
    font-weight: 700;
    line-height: 1.25;
    vertical-align: middle;
}
.us-office-icon {
    width: 22px;
    height: 22px;
    flex: none;
    object-fit: contain;
}
.us-office-icon-ph {
    display: grid;
    place-items: center;
    width: 22px;
    height: 22px;
    flex: none;
    background: var(--us-panel);
    color: var(--us-blue);
    font-size: 12px;
    font-weight: 800;
    line-height: 1;
    border-radius: 50%;
}
.us-office-text {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
/* Status: waiting / active / off, dot style like the rest of the system. */
.us-status {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 9px;
    background: var(--us-amber-bg);
    color: var(--us-amber);
    font-size: 12.5px;
    font-weight: 700;
    white-space: nowrap;
}
.us-status.is-pending :deep(.v-icon) {
    color: inherit;
}
.us-status.is-active {
    background: var(--us-ok-bg);
    color: var(--us-ok);
}
.us-status.is-off {
    background: var(--us-field);
    color: var(--us-muted);
}
.us-status-dot {
    width: 8px;
    height: 8px;
    flex: none;
    border-radius: 50%;
    background: currentColor;
}
/* Actions: square icon buttons, state-coloured like the other pages. */
.us-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    flex-wrap: wrap;
    gap: 6px;
}
.us-lock {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    color: var(--us-muted);
}
.us-ib {
    width: 40px !important;
    min-width: 40px !important;
    height: 40px !important;
    padding: 0 !important;
    border: 1.5px solid var(--us-line) !important;
    border-radius: 0 !important;
    background: transparent !important;
    color: var(--us-muted) !important;
    box-shadow: none !important;
}
.us-ib :deep(.v-icon) {
    font-size: 18px !important;
}
.us-ib.is-ok {
    border-color: var(--us-ok-bg) !important;
    color: var(--us-ok) !important;
}
.us-ib.is-ok:hover {
    background: var(--us-ok-bg) !important;
}
.us-ib.is-edit {
    border-color: var(--us-amber-bg) !important;
    color: var(--us-amber) !important;
}
.us-ib.is-edit:hover {
    background: var(--us-amber-bg) !important;
}
.us-ib.is-delete {
    border-color: var(--us-err-bg) !important;
    color: var(--us-err) !important;
}
.us-ib.is-delete:hover {
    background: var(--us-err-bg) !important;
}
.us-ib:disabled {
    opacity: 0.45 !important;
}

/* ---- Footer ---- */
.us-pg {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 20px;
    padding: 16px 28px 20px;
    color: var(--us-muted);
    font-size: 14px;
    flex-wrap: wrap;
}
.us-per {
    display: flex;
    align-items: center;
    gap: 10px;
}
.us-per-box {
    display: inline-flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    min-width: 76px;
    height: 40px;
    padding: 0 8px 0 12px;
    border: 1.5px solid var(--us-line);
    background: var(--us-panel);
    color: var(--us-ink);
    font-weight: 700;
}
.us-per-box :deep(.v-icon) {
    color: var(--us-muted);
}
.us-range {
    color: var(--us-ink);
    font-weight: 700;
}
.us-pn {
    display: flex;
    gap: 4px;
}
.us-pn button {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid var(--us-line);
    border-radius: 0;
    background: var(--us-panel);
    color: var(--us-ink);
    cursor: pointer;
}
.us-pn button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

@media (max-width: 900px) {
    .us-tools {
        flex: 1 1 100%;
        margin-left: 0;
    }
    .us-search {
        flex: 1 1 100%;
        max-width: none;
    }
}
@media (max-width: 760px) {
    .us-hd {
        padding: 18px 16px;
    }
    .us-title {
        font-size: 20px;
    }
    .us-wrap {
        padding: 16px 16px 0;
    }
    .us-pg {
        justify-content: center;
        padding: 16px;
    }
}
@media (max-width: 520px) {
    .us-add {
        padding: 0 16px;
    }
    .us-add-label {
        display: none;
    }
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
  --nu-blue: #005EED;
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
  background: var(--tms-grad);
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
