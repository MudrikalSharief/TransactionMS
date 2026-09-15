<template>
  <v-card rounded="0" elevation="1" class="lgu-card">
    <v-card-title class="d-flex align-center pa-5">
      <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
        <v-icon color="white">mdi-shield-account</v-icon>
      </v-avatar>
      <span class="text-h6 font-weight-bold">Roles</span>
      <v-spacer />
      <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-plus" @click="openCreate">
        Add Role
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
        :items="roles"
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
        <template v-slot:[`item.actions`]="{ item }">
          <div class="d-flex ga-3 justify-end">
            <v-btn
              icon="mdi-pencil"
              v-tooltip="'Edit role'"
              size="small"
              variant="outlined"
              color="grey-darken-3"
              @click="openEdit(item)"
            />
            <v-btn
              icon="mdi-delete"
              v-tooltip="'Delete role'"
              size="small"
              variant="outlined"
              color="error"
              :disabled="item.code === 'superadmin'"
              @click="remove(item)"
            />
          </div>
        </template>
      </v-data-table>
      <TableLoader v-if="loading" label="roles" icon="mdi-shield-account" style="flex: 1 1 auto" />
      </div>
    </v-card-text>
  </v-card>

  <v-dialog v-model="dialog" max-width="600">
    <v-card rounded="0">
      <v-card-title>{{ form.id ? 'Edit Role' : 'New Role' }}</v-card-title>
      <v-divider />
      <v-card-text>
        <v-text-field v-model="form.code" label="Code (snake_case)" />
        <v-text-field v-model="form.name" label="Name" />
        <v-textarea v-model="form.description" label="Description" rows="3" />
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
import { onMounted, ref } from 'vue'
import { useRoles } from '@/composables/useRoles'
import TableLoader from '@/components/TableLoader.vue'

const { roles, loading, fetchRoles, createRole, updateRole, deleteRole } = useRoles()

const headers = [
  { title: 'Code', key: 'code' },
  { title: 'Name', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: '', key: 'actions', sortable: false },
]

const dialog = ref(false)
const saving = ref(false)
const error = ref('')

const form = ref({ id: null, code: '', name: '', description: '' })

function openCreate() {
  error.value = ''
  form.value = { id: null, code: '', name: '', description: '' }
  dialog.value = true
}

function openEdit(item) {
  error.value = ''
  form.value = { id: item.id, code: item.code, name: item.name, description: item.description ?? '' }
  dialog.value = true
}

async function save() {
  saving.value = true
  error.value = ''
  try {
    if (form.value.id) {
      await updateRole(form.value.id, {
        code: form.value.code,
        name: form.value.name,
        description: form.value.description,
      })
    } else {
      await createRole({
        code: form.value.code,
        name: form.value.name,
        description: form.value.description,
      })
    }
    dialog.value = false
    await fetchRoles()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Save failed.'
  } finally {
    saving.value = false
  }
}

async function remove(item) {
  error.value = ''
  try {
    await deleteRole(item.id)
    await fetchRoles()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Delete failed.'
  }
}

onMounted(fetchRoles)
</script>
