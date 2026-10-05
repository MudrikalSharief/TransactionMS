<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-text-box-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Step Data</span>
                <v-spacer />
                <v-btn variant="text" @click="goBack">Back</v-btn>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <v-alert type="info" variant="tonal" class="mb-3">
                    Template for this step — text values collected at Proceed (e.g. receipt number). Values keep history per visit.
                </v-alert>

                <v-row>
                    <v-col cols="12">
                        <v-select
                            v-model="selectedStepId"
                            :items="stepOptions"
                            item-title="label"
                            item-value="id"
                            label="Select Step"
                            :loading="stepsLoading || loading"
                            :disabled="!workflowDefinitionId"
                        />
                    </v-col>
                </v-row>

                <v-divider class="my-3" />

                <v-alert v-if="!selectedStepId" type="info" variant="tonal">
                    Pick a step first.
                </v-alert>

                <div v-else>
                    <div class="d-flex align-center mb-3">
                        <div class="text-subtitle-1 font-weight-bold">
                            Data fields for this step
                        </div>
                        <v-spacer />
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            prepend-icon="mdi-plus"
                            @click="openAdd"
                        >
                            Add data field
                        </v-btn>
                    </div>

                    <div class="d-flex flex-column" style="min-height: 510px">
                        <v-data-table
                            v-show="!loading"
                            :headers="headers"
                            :items="items"
                            item-key="id"
                            :items-per-page="25"
                            density="compact"
                            height="450"
                            fixed-header
                            hover
                            class="lgu-table"
                        >
                            <template v-slot:[`item.display_name`]="{ item }">
                                <div class="font-weight-medium">{{ item.display_name }}</div>
                                <div class="text-caption text-medium-emphasis">{{ item.code }}</div>
                            </template>

                            <template v-slot:[`item.is_required`]="{ item }">
                                <v-checkbox
                                    :model-value="!!item.is_required"
                                    density="compact"
                                    hide-details
                                    color="grey-darken-3"
                                    readonly
                                />
                            </template>

                            <template v-slot:[`item.actions`]="{ item }">
                                <v-btn
                                    icon="mdi-pencil"
                                    v-tooltip="'Edit'"
                                    size="small"
                                    variant="text"
                                    color="warning"
                                    @click="openEdit(item)"
                                />
                                <v-btn
                                    icon="mdi-delete"
                                    v-tooltip="'Delete'"
                                    size="small"
                                    variant="text"
                                    color="error"
                                    @click="removeRow(item)"
                                />
                            </template>
                        </v-data-table>
                        <TableLoader v-if="loading" label="step data" icon="mdi-text-box-outline" style="flex: 1 1 auto" />
                    </div>
                </div>
            </v-card-text>
        </v-card>

        <v-dialog v-model="dialog" max-width="600">
            <v-card rounded="0">
                <v-card-title>{{ editingId ? "Edit data field" : "Add data field" }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-alert v-if="formError" type="error" variant="tonal" class="mb-3">{{ formError }}</v-alert>
                    <v-text-field v-model="form.display_name" label="Display name *" placeholder="e.g. Receipt Number" />
                    <v-text-field
                        v-model="form.code"
                        label="Code *"
                        hint="System code, e.g. receipt_number (auto-generated from name if blank)"
                        persistent-hint
                        placeholder="e.g. receipt_number"
                    />
                    <v-switch v-model="form.is_required" color="grey-darken-3" label="Required" />
                    <v-text-field v-model.number="form.display_order" type="number" label="Display order" min="0" />
                    <v-row>
                        <v-col cols="6">
                            <v-text-field v-model.number="form.min_length" type="number" label="Min length" min="0" clearable />
                        </v-col>
                        <v-col cols="6">
                            <v-text-field v-model.number="form.max_length" type="number" label="Max length" min="0" clearable />
                        </v-col>
                    </v-row>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="saving"
                        :disabled="!form.display_name?.trim()"
                        @click="saveForm"
                    >
                        Save
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useStepData } from "@/composables/useStepData";
import TableLoader from '@/components/TableLoader.vue';

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { items, loading, saving, fetchAll, create, update, remove } = useStepData();

const returnTypeId = ref(null);

function goBack() {
    const qType = Number(route.query.type);
    const target = Number.isFinite(qType) && qType > 0 ? qType : Number(returnTypeId.value);
    if (target > 0) router.push({ path: "/admin/workflows", query: { type: target } });
    else router.push("/admin/workflows");
}

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const error = ref("");
const steps = ref([]);
const stepsLoading = ref(false);
const selectedStepId = ref(null);

const headers = [
    { title: "Field", key: "display_name", sortable: false },
    { title: "Required?", key: "is_required", sortable: false },
    { title: "Order", key: "display_order", sortable: false },
    { title: "", key: "actions", sortable: false },
];

const dialog = ref(false);
const editingId = ref(null);
const formError = ref("");
const form = ref({ display_name: "", code: "", is_required: false, display_order: 0, min_length: null, max_length: null });

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

function slugify(v) {
    return String(v || "").toLowerCase().trim().replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");
}

function openAdd() {
    formError.value = "";
    editingId.value = null;
    form.value = { display_name: "", code: "", is_required: false, display_order: items.value.length, min_length: null, max_length: null };
    dialog.value = true;
}

function openEdit(item) {
    formError.value = "";
    editingId.value = item.id;
    form.value = {
        display_name: item.display_name ?? "",
        code: item.code ?? "",
        is_required: !!item.is_required,
        display_order: item.display_order ?? 0,
        min_length: item.min_length ?? null,
        max_length: item.max_length ?? null,
    };
    dialog.value = true;
}

function cleanPayload() {
    const code = form.value.code?.trim() || slugify(form.value.display_name);
    return {
        display_name: form.value.display_name.trim(),
        code,
        is_required: !!form.value.is_required,
        display_order: Number(form.value.display_order ?? 0),
        min_length: form.value.min_length === "" || form.value.min_length == null ? null : Number(form.value.min_length),
        max_length: form.value.max_length === "" || form.value.max_length == null ? null : Number(form.value.max_length),
    };
}

async function saveForm() {
    if (!form.value.display_name?.trim() || !selectedStepId.value) return;
    formError.value = "";
    try {
        const payload = cleanPayload();
        if (editingId.value) {
            await update(workflowDefinitionId.value, Number(selectedStepId.value), editingId.value, payload);
        } else {
            await create(workflowDefinitionId.value, Number(selectedStepId.value), payload);
        }
        dialog.value = false;
    } catch (e) {
        formError.value = e?.response?.data?.message || "Save failed.";
    }
}

async function removeRow(item) {
    if (!window.confirm(`Delete "${item.display_name}"? Past entered values are kept for history.`)) return;
    error.value = "";
    try {
        await remove(workflowDefinitionId.value, Number(selectedStepId.value), item.id);
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete failed.";
    }
}

async function loadSteps() {
    stepsLoading.value = true;
    error.value = "";
    try {
        const wid = workflowDefinitionId.value;
        try {
            const defRes = await api.get(`/api/admin/workflow-definitions/${wid}`);
            const def = defRes.data?.data ?? defRes.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
        } catch {
            /* type id for Back is best-effort */
        }
        const res = await api.get(`/api/admin/workflow-definitions/${wid}/steps`);
        steps.value = res.data.data ?? res.data;
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Failed to load steps.";
    } finally {
        stepsLoading.value = false;
    }
}

async function loadItems() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        await fetchAll(workflowDefinitionId.value, Number(selectedStepId.value));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load step data.";
    }
}

watch(selectedStepId, async () => {
    if (!selectedStepId.value) return;
    await loadItems();
});

onMounted(async () => {
    await loadSteps();
    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) {
        selectedStepId.value = sid;
    }
});
</script>
