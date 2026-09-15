<template>
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-account-group</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Users</span>
      <v-spacer />
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add User
      </v-btn>
    </v-card-title>
    <v-divider />
    <v-card-text class="pa-4">
      <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
        {{ error }}
      </v-alert>

      <div class="d-flex flex-column" style="min-height: 510px">
      <v-data-table
        v-show="!loading"
        :items="users"
        :loading="loading"
        :headers="headers"
        item-key="id"
        density="compact"
        height="450"
        fixed-header
        :items-per-page="25"
        hover
        class="lgu-table"
      >
        <template v-slot:[`item.roles`]="{ item }">
          <v-chip
            v-for="r in item.roles || []"
            :key="r.id"
            rounded="0"
            size="small"
            variant="tonal"
            class="mr-1"
          >
            {{ r.name }}
          </v-chip>
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
              :disabled="item.id === auth.user?.id"
              @click="deactivate(item)"
            />
          </div>
        </template>
      </v-data-table>
      <TableLoader v-if="loading" label="users" icon="mdi-account-group" style="flex: 1 1 auto" />
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="700">
    <v-card rounded="0">
      <v-card-title>{{ form.id ? 'Edit User' : 'New User' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.name" label="Name" />
        <v-text-field v-model="form.email" label="Email" type="email" />

        <v-text-field
          v-model="form.password"
          :label="form.id ? 'New Password (optional)' : 'Password'"
          type="password"
        />

        <v-switch v-model="form.is_active" label="Active" />

        <v-select
          v-model="form.role_ids"
          :items="roleOptions"
          item-title="label"
          item-value="id"
          label="Roles"
          multiple
          chips
        />
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
import { computed, onMounted, ref } from 'vue'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useRoles } from '@/composables/useRoles'
import { useAuth } from '@/composables/useAuth'
import TableLoader from '@/components/TableLoader.vue'

const auth = useAuth()
const { users, loading, fetchUsers, createUser, updateUser, deactivateUser } = useAdminUsers()
const { roles, fetchRoles } = useRoles()

const headers = [
  { title: 'Name', key: 'name' },
  { title: 'Email', key: 'email' },
  { title: 'Roles', key: 'roles', sortable: false },
  { title: 'Status', key: 'is_active' },
  { title: '', key: 'actions', sortable: false },
]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')

const form = ref({
  id: null,
  name: '',
  email: '',
  password: '',
  is_active: true,
  role_ids: [],
})

const roleOptions = computed(() =>
   (roles.value || []).map(r => ({ id: r.id, label: `${r.name}` })) // use ${r.code} to show Role Code
)

function openCreate() {
  error.value = ''
  form.value = { id: null, name: '', email: '', password: '', is_active: true, role_ids: [] }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = {
    id: item.id,
    name: item.name,
    email: item.email,
    password: '',
    is_active: !!item.is_active,
    role_ids: (item.roles || []).map(r => r.id),
  }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    const payload = {
      name: form.value.name,
      email: form.value.email,
      is_active: form.value.is_active,
      role_ids: form.value.role_ids,
    }
    if (form.value.password) payload.password = form.value.password

    if (form.value.id) {
      await updateUser(form.value.id, payload)
    } else {
      if (!form.value.password) throw new Error('Password required')
      await createUser({ ...payload, password: form.value.password })
    }

    dialog.value = false
    await fetchUsers()
  } catch (e) {
    error.value = e?.response?.data?.message || e?.message || 'Save failed.'
  } finally {
    saving.value = false
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

onMounted(async () => {
  await fetchRoles()
  await fetchUsers()
})
</script>
