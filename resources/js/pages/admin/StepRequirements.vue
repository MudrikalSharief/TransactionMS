<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-list-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Requirements</span>
                <v-spacer />
                <v-btn variant="text" @click="goBack">Back</v-btn>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <StagingSaveBar
                    :type-id="typeId"
                    :def-id="workflowDefinitionId"
                    @saved="afterBulkSaved"
                    @discarded="loadAssigned"
                />

                <v-alert type="info" variant="tonal" class="mb-3">
                    Staged assignment — edits stay local until you press Save version.
                </v-alert>

                <v-row>
                    <v-col cols="12" md="6">
                        <v-select
                            v-model="selectedStepId"
                            :items="stepOptions"
                            item-title="label"
                            item-value="id"
                            label="Select Step"
                            :loading="stepsLoading"
                            :disabled="!workflowDefinitionId"
                        />
                    </v-col>
                    <v-col cols="12" md="6" class="d-flex align-center">
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            :disabled="!selectedStepId"
                            @click="loadAssigned"
                        >
                            Load Step Requirements
                        </v-btn>
                    </v-col>
                </v-row>

                <v-divider class="my-3" />

                <v-alert v-if="!selectedStepId" type="info" variant="tonal">
                    Pick a step first.
                </v-alert>

                <div v-else>
                    <div class="d-flex align-center mb-3">
                        <div class="text-subtitle-1 font-weight-bold">
                            Requirements for this step
                        </div>
                        <v-spacer />
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            prepend-icon="mdi-plus"
                            @click="openAdd"
                        >
                            Add requirement
                        </v-btn>
                    </div>

                    <div class="d-flex flex-column" style="min-height: 510px">
                        <v-data-table
                            v-show="!loading"
                            :headers="assignHeaders"
                            :items="assignmentRows"
                            item-key="requirement_definition_id"
                            :items-per-page="25"
                            density="compact"
                            height="450"
                            fixed-header
                            hover
                            class="lgu-table"
                        >
                            <template v-slot:[`item.name`]="{ item }">
                                <div class="font-weight-medium">{{ item.name }}</div>
                                <div v-if="item.description" class="text-caption text-medium-emphasis">
                                    {{ item.description }}
                                </div>
                            </template>

                            <template v-slot:[`item.code`]="{ item }">
                                <v-text-field
                                    v-model="item.code"
                                    density="compact"
                                    hide-details
                                    placeholder="e.g. dtr, pr, voucher"
                                    style="max-width: 220px"
                                    :disabled="typeof item.requirement_definition_id === 'number'"
                                    :title="typeof item.requirement_definition_id === 'number' ? 'Codes are frozen once saved' : ''"
                                    @update:model-value="stageBindings"
                                />
                            </template>

                            <template v-slot:[`item.is_required`]="{ item }">
                                <v-checkbox
                                    v-model="item.is_required"
                                    density="compact"
                                    hide-details
                                    color="grey-darken-3"
                                    @update:model-value="stageBindings"
                                />
                            </template>

                            <template v-slot:[`item.is_upload_required`]="{ item }">
                                <v-checkbox
                                    v-model="item.is_upload_required"
                                    density="compact"
                                    hide-details
                                    color="grey-darken-3"
                                    @update:model-value="stageBindings"
                                />
                            </template>

                            <template v-slot:[`item.actions`]="{ item }">
                                <v-btn
                                    icon="mdi-delete"
                                    v-tooltip="'Remove from this step'"
                                    size="small"
                                    variant="text"
                                    color="error"
                                    @click="removeRow(item)"
                                />
                            </template>
                        </v-data-table>
                        <TableLoader v-if="loading" label="requirements" icon="mdi-clipboard-list-outline" style="flex: 1 1 auto" />
                    </div>
                </div>
            </v-card-text>
        </v-card>

        <v-dialog v-model="addDialog" max-width="600">
            <v-card rounded="0">
                <v-card-title>Add requirement</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-alert v-if="addError" type="error" variant="tonal" class="mb-3">{{ addError }}</v-alert>
                    <v-text-field v-model="addForm.name" label="Name" />
                    <v-text-field
                        v-model="addForm.code"
                        label="Code"
                        hint="System code, e.g. signed_pr_pdf (auto-generated from name if blank)"
                        persistent-hint
                    />
                    <v-textarea v-model="addForm.description" label="Remarks (instructions for workers)" rows="3" />
                    <v-switch v-model="addForm.is_required" color="grey-darken-3" label="Required item" />
                    <v-switch v-model="addForm.is_upload_required" color="grey-darken-3" label="Upload required (must attach file)" />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="addDialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="adding"
                        :disabled="!addForm.name?.trim()"
                        @click="addRequirement"
                    >
                        Add
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
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useStepRequirements } from "@/composables/useStepRequirements";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import TableLoader from '@/components/TableLoader.vue';
import StagingSaveBar from '@/components/StagingSaveBar.vue';

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const returnTypeId = ref(null);

function goBack() {
    const qType = Number(route.query.type);
    const target = Number.isFinite(qType) && qType > 0 ? qType : Number(returnTypeId.value);
    if (target > 0) router.push({ path: "/admin/workflows", query: { type: target } });
    else router.push("/admin/workflows");
}

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const {
    items: requirements,
    fetchAll: fetchReqs,
} = useRequirementDefinitions();
const { assigned, loading, fetchAssigned } = useStepRequirements();
const staging = useWorkflowStaging();

// Staging is keyed by transaction type: prefer the explicit query param,
// fall back to the type resolved from the loaded definition.
const typeId = computed(() => {
    const q = Number(route.query.type);
    if (Number.isFinite(q) && q > 0) return q;
    const t = Number(returnTypeId.value);
    return Number.isFinite(t) && t > 0 ? t : null;
});

const error = ref("");

const steps = ref([]);
const stepsLoading = ref(false);
const selectedStepId = ref(null);

// Working rows for the current step: pivots joined with definitions.
const assignmentRows = ref([]);

const assignHeaders = [
    { title: "Name", key: "name", sortable: false },
    { title: "Code", key: "code", sortable: false },
    { title: "Required?", key: "is_required", sortable: false },
    { title: "Upload required?", key: "is_upload_required", sortable: false },
    { title: "", key: "actions", sortable: false },
];

// Add-entry dialog
const addDialog = ref(false);
const adding = ref(false);
const addError = ref("");
const addForm = ref({ name: "", code: "", description: "", is_required: true, is_upload_required: true });

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

function openAdd() {
    addError.value = "";
    addForm.value = { name: "", code: "", description: "", is_required: true, is_upload_required: true };
    addDialog.value = true;
}

function storeRow(r, idx) {
    return {
        req_key: r.requirement_definition_id,
        display_order: Number(r.display_order ?? idx),
        is_required: !!r.is_required,
        is_upload_required: r.is_upload_required ?? r.is_required ?? true,
        code: r.code ?? "",
        description: r.description ?? "",
    };
}

// Write the visible rows into the staging store (no network). Called by
// every inline edit/add/remove; Save version persists everything at once.
function stageBindings() {
    if (!typeId.value || !selectedStepId.value) return;
    staging.setBindings(
        typeId.value,
        Number(selectedStepId.value),
        (assignmentRows.value || []).map((r, idx) => storeRow(r, idx)),
    );
}

function addRequirement() {
    if (!addForm.value.name?.trim()) return;
    if (!typeId.value) {
        addError.value = "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    adding.value = true;
    addError.value = "";
    try {
        // Staged requirement definition (server mints id + code on save).
        const created = staging.upsertReqDef(typeId.value, {
            name: addForm.value.name.trim(),
            code: addForm.value.code?.trim() || null,
            description: addForm.value.description?.trim() || null,
        });
        // Attach to the current step immediately with the chosen required flag.
        assignmentRows.value = [
            ...assignmentRows.value,
            {
                requirement_definition_id: created.client_id ?? created.id,
                code: created.code,
                name: created.name,
                label: created.label,
                description: created.description,
                display_order: assignmentRows.value.length,
                is_required: !!addForm.value.is_required,
                is_upload_required: !!addForm.value.is_upload_required,
            },
        ];
        addDialog.value = false;
        stageBindings();
    } catch (e) {
        addError.value = e?.message || "Failed to add requirement.";
    } finally {
        adding.value = false;
    }
}

function removeRow(item) {
    assignmentRows.value = assignmentRows.value.filter(
        (r) => r.requirement_definition_id !== item.requirement_definition_id,
    );
    // Staged removal (undo via Discard on the save bar).
    stageBindings();
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

function enrichStagedRow(r, idx) {
    // Names/labels for staged rows: staged defs first, then the server
    // catalog, then whatever the row itself carries.
    const key = String(r.req_key ?? r.requirement_definition_id ?? r.id);
    const b = typeId.value ? staging.buckets.get(String(typeId.value)) : null;
    const staged = (b?.reqDefs || []).find((d) => String(d.client_id ?? d.id) === key);
    const cat = (requirements.value || []).find((d) => String(d.id) === key);
    const src = staged || cat || {};
    return {
        requirement_definition_id: r.req_key ?? r.requirement_definition_id,
        code: r.code ?? src.code ?? "",
        name: src.name ?? r.name ?? "",
        label: src.label ?? r.label ?? "",
        description: r.description ?? src.description ?? "",
        display_order: Number(r.display_order ?? idx),
        is_required: r.is_required ?? true,
        is_upload_required: r.is_upload_required ?? r.is_required ?? true,
    };
}

async function loadAssigned() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        await fetchAssigned(workflowDefinitionId.value, Number(selectedStepId.value));
        const sid = Number(selectedStepId.value);
        // Prefer already-staged rows so revisit never shows stale server
        // state over unsaved edits; names resolve via staged defs/catalog.
        const staged = typeId.value
            ? staging.buckets.get(String(typeId.value))?.bindings?.[String(sid)]
            : null;
        if (staged) {
            assignmentRows.value = staged.map((r, idx) => enrichStagedRow(r, idx));
            return;
        }
        assignmentRows.value = (assigned.value || []).map((a) => ({
            requirement_definition_id: a.id,
            code: a.code ?? "",
            name: a.name,
            label: a.label ?? "",
            description: a.description ?? "",
            display_order: a.pivot_meta?.display_order ?? 0,
            is_required: a.pivot_meta?.is_required ?? true,
            is_upload_required: a.pivot_meta?.is_upload_required ?? a.pivot_meta?.is_required ?? true,
        }));
        // Seed the staging slice (skipped when staged edits exist).
        if (typeId.value) {
            staging.seedBindings(
                typeId.value,
                sid,
                assignmentRows.value.map((r, idx) => storeRow(r, idx)),
            );
            staging.seedReqDefs(typeId.value, requirements.value || []);
        }
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load assigned requirements.";
    }
}

async function afterBulkSaved() {
    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await fetchReqs(workflowDefinitionId.value);
    await loadAssigned();
}

watch(selectedStepId, () => {
    assigned.value = [];
    assignmentRows.value = [];
});

onMounted(async () => {
    // Requirement catalog and step list are independent: fetch in parallel.
    await Promise.allSettled([fetchReqs(workflowDefinitionId.value), loadSteps()]);

    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) {
        selectedStepId.value = sid;
        await loadAssigned();
    }
});
</script>
