<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Requirements Library</span>
                <v-spacer />
                <v-btn variant="text" @click="goBack">Back</v-btn>
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

                <StagingSaveBar
                    :type-id="typeId"
                    :def-id="workflowDefinitionId"
                    @saved="load"
                    @discarded="load"
                />

                <v-alert type="info" variant="tonal" class="mb-3">
                    Staged library — adds, edits, and removals stay local until you press Save version.
                </v-alert>

                <div class="d-flex flex-column" style="min-height: 510px">
                <v-data-table
                    v-show="!loading"
                    :items="tableItems"
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
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title>{{ form.id ? "Edit Requirement" : "New Requirement" }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-text-field v-model="form.order_number" type="number" label="Order #" />
                    <v-text-field
                        v-model="form.code"
                        label="Code (snake_case)"
                        :disabled="typeof form.id === 'number'"
                        :hint="typeof form.id === 'number' ? 'Codes are frozen once saved' : 'Auto-generated from name if blank'"
                        persistent-hint
                    />
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
import { useRoute, useRouter } from "vue-router";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import { useApi } from "@/composables/useApi";
import TableLoader from '@/components/TableLoader.vue';
import StagingSaveBar from '@/components/StagingSaveBar.vue';

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const workflowDefinitionId = computed(() => Number(route.params.workflowId));

const returnTypeId = ref(null);

function goBack() {
    const qType = Number(route.query.type);
    const target = Number.isFinite(qType) && qType > 0 ? qType : Number(returnTypeId.value);
    if (target > 0) router.push({ path: "/admin/workflows", query: { type: target } });
    else router.push("/admin/workflows");
}

const { items, loading, fetchAll } = useRequirementDefinitions();
const staging = useWorkflowStaging();

// Staging is keyed by transaction type: prefer the explicit query param,
// fall back to the type resolved from the loaded definition.
const typeId = computed(() => {
    const q = Number(route.query.type);
    if (Number.isFinite(q) && q > 0) return q;
    const t = Number(returnTypeId.value);
    return Number.isFinite(t) && t > 0 ? t : null;
});

// Table renders the working copy once seeded (dirty or not); before the
// first seed it falls back to the loaded definitions.
const tableItems = computed(() => {
    const b = typeId.value ? staging.buckets.get(String(typeId.value)) : null;
    if (b && (b.dirty || b.sourceDefId != null)) return b.reqDefs;
    return items.value || [];
});

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
            client_id: item.client_id ?? null,
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
        try {
            const defRes = await api.get(`/api/admin/workflow-definitions/${workflowDefinitionId.value}`);
            const def = defRes.data?.data ?? defRes.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
        } catch {
            /* type id for Back is best-effort */
        }
        await fetchAll(workflowDefinitionId.value);
        // Seed the staging slice (skipped when staged edits exist).
        if (typeId.value) {
            staging.seedReqDefs(typeId.value, items.value || []);
        }
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load requirements.";
    }
}

function save() {
    // Staged: no network. The row lands in the working copy (new rows get
    // a tmp id) until Save version. Codes of saved rows are frozen.
    error.value = "";
    if (!typeId.value) {
        error.value = "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    if (!form.value.name?.trim()) {
        error.value = "Give the requirement a name first.";
        return;
    }
    staging.upsertReqDef(typeId.value, {
        id: form.value.id ?? undefined,
        client_id: form.value.client_id ?? undefined,
        order_number: Number(form.value.order_number || 0),
        code: form.value.code || null,
        name: form.value.name.trim(),
        description: form.value.description || null,
        is_active: !!form.value.is_active,
    });
    dialog.value = false;
}

function remove(item) {
    error.value = "";
    if (!typeId.value) return;
    // Staged removal (undo via Discard on the save bar).
    staging.removeReqDef(typeId.value, item?.id ?? item?.client_id);
}

onMounted(load);
</script>
