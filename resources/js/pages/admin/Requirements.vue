<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Requirements Library</span>
                <v-spacer />
                <v-btn variant="text" @click="$router.push('/admin/workflows')">Back</v-btn>
                <v-btn
                    color="grey-darken-3"
                    rounded="0"
                    prepend-icon="mdi-plus"
                    @click="openDialog()"
                >
                    Add Requirement
                </v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <v-alert type="warning" variant="tonal" class="mb-3">
                    Live list — adds and edits apply to running transactions immediately.
                </v-alert>

                <div class="d-flex flex-column" style="min-height: 510px">
                <v-data-table
                    v-show="!loading"
                    :items="items"
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
                    <template v-slot:[`item.is_active`]="{ item }">
                        <v-chip rounded="0" size="small" variant="tonal" :color="item.is_active ? 'success' : 'error'">
                            <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
                            {{ item.is_active ? "active" : "inactive" }}
                        </v-chip>
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn icon="mdi-pencil" v-tooltip="'Edit requirement'" size="small" variant="outlined" color="grey-darken-3" @click="openDialog(item)" />
                            <v-btn icon="mdi-delete" v-tooltip="'Delete requirement'" size="small" variant="outlined" color="error" @click="remove(item)" />
                        </div>
                    </template>
                </v-data-table>
                <TableLoader v-if="loading" label="requirements" icon="mdi-clipboard-check-outline" style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>

        <v-dialog v-model="dialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>{{ form.id ? "Edit Requirement" : "New Requirement" }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-text-field v-model="form.order_number" type="number" label="Order #" />
                    <v-text-field v-model="form.code" label="Code (snake_case)" />
                    <v-text-field v-model="form.name" label="Name" />
                    <v-textarea v-model="form.description" label="Description (optional)" rows="3" />
                    <v-switch v-model="form.is_active" label="Active" />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="save">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRoute } from "vue-router";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import TableLoader from '@/components/TableLoader.vue';

const route = useRoute();

const workflowDefinitionId = computed(() => Number(route.params.workflowId));

const { items, loading, fetchAll, create, update, destroy } = useRequirementDefinitions();

const error = ref("");
const dialog = ref(false);
const saving = ref(false);

const form = ref({
    id: null,
    order_number: 0,
    code: "",
    name: "",
    description: "",
    is_active: true,
});

const headers = [
    { title: "#", key: "order_number" },
    { title: "Code", key: "code" },
    { title: "Name", key: "name" },
    { title: "Active", key: "is_active" },
    { title: "", key: "actions", sortable: false },
];

function openDialog(item = null) {
    error.value = "";
    if (item) {
        form.value = {
            id: item.id,
            order_number: item.order_number ?? 0,
            code: item.code,
            name: item.name,
            description: item.description ?? "",
            is_active: !!item.is_active,
        };
    } else {
        form.value = {
            id: null,
            order_number: (items.value?.length || 0) + 1,
            code: "",
            name: "",
            description: "",
            is_active: true,
        };
    }
    dialog.value = true;
}

async function load() {
    error.value = "";
    try {
        await fetchAll(workflowDefinitionId.value);
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load requirements.";
    }
}

async function save() {
    saving.value = true;
    error.value = "";
    try {
        const payload = {
            order_number: Number(form.value.order_number || 0),
            code: form.value.code,
            name: form.value.name,
            description: form.value.description || null,
            is_active: !!form.value.is_active,
        };

        if (form.value.id) {
            await update(workflowDefinitionId.value, form.value.id, payload);
        } else {
            await create(workflowDefinitionId.value, payload);
        }

        dialog.value = false;
        await fetchAll(workflowDefinitionId.value);
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Save failed.";
    } finally {
        saving.value = false;
    }
}

async function remove(item) {
    error.value = "";
    try {
        await destroy(workflowDefinitionId.value, item.id);
        await fetchAll(workflowDefinitionId.value);
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete failed.";
    }
}

onMounted(load);
</script>
