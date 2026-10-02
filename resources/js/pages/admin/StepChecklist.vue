<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="info" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Checklist</span>
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
                    @discarded="loadChecklist"
                />

                <v-alert type="info" variant="tonal" class="mb-3">
                    Linked to the previous station's requirements (via forward routes) — they are added, updated,
                    and removed automatically on Save. Custom items you add here stay independent.
                    Starting stations have no previous station, so only custom items appear.
                    Edits stay local until you press Save version.
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
                            @click="loadChecklist"
                        >
                            Load Checklist
                        </v-btn>
                    </v-col>
                </v-row>

                <v-divider class="my-3" />

                <v-alert v-if="!selectedStepId" type="info" variant="tonal">
                    Pick a step first.
                </v-alert>

                <div v-else>
                    <div class="d-flex align-center mb-3 flex-wrap ga-3">
                        <div class="text-subtitle-1 font-weight-bold">
                            Checklist for this step
                        </div>
                        <v-spacer />
                        <v-btn
                            variant="outlined"
                            color="warning"
                            rounded="0"
                            prepend-icon="mdi-sync"
                            @click="resetToRequirements"
                        >
                            Reset to previous requirements
                        </v-btn>
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            prepend-icon="mdi-plus"
                            @click="openAdd"
                        >
                            Add item
                        </v-btn>
                    </div>

                    <div class="d-flex flex-column" style="min-height: 510px">
                        <v-data-table
                            v-show="!loading"
                            :headers="headers"
                            :items="rows"
                            item-key="_key"
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
                                <div v-if="item.requirement_definition_id" class="text-caption text-medium-emphasis">
                                    from requirement — managed by Requirements
                                </div>
                                <div v-else class="text-caption text-info">custom item</div>
                            </template>

                            <template v-slot:[`item.code`]="{ item }">
                                <v-text-field
                                    v-model="item.code"
                                    density="compact"
                                    hide-details
                                    placeholder="e.g. dtr, pr, voucher"
                                    style="max-width: 220px"
                                    @update:model-value="stageRows"
                                />
                            </template>

                            <template v-slot:[`item.is_required`]="{ item }">
                                <v-checkbox
                                    v-model="item.is_required"
                                    density="compact"
                                    hide-details
                                    color="grey-darken-3"
                                    @update:model-value="stageRows"
                                />
                            </template>

                            <template v-slot:[`item.actions`]="{ item }">
                                <v-btn
                                    icon="mdi-delete"
                                    v-tooltip="'Remove from checklist'"
                                    size="small"
                                    variant="text"
                                    color="error"
                                    @click="removeRow(item)"
                                />
                            </template>
                        </v-data-table>
                        <TableLoader v-if="loading" label="checklist" icon="mdi-clipboard-check-outline" style="flex: 1 1 auto" />
                    </div>
                </div>
            </v-card-text>
        </v-card>

        <v-dialog v-model="addDialog" max-width="600">
            <v-card rounded="0">
                <v-card-title>Add checklist item</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-alert v-if="addError" type="error" variant="tonal" class="mb-3">{{ addError }}</v-alert>
                    <v-text-field v-model="addForm.name" label="Name" />
                    <v-text-field
                        v-model="addForm.code"
                        label="Code"
                        hint="Short code, e.g. dtr (optional)"
                        persistent-hint
                    />
                    <v-textarea v-model="addForm.description" label="Remarks" rows="3" />
                    <v-switch v-model="addForm.is_required" color="grey-darken-3" label="Required" />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="addDialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :disabled="!addForm.name?.trim()"
                        @click="addRow"
                    >
                        Add
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useStepChecklist } from "@/composables/useStepChecklist";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import StagingSaveBar from "@/components/StagingSaveBar.vue";
import TableLoader from "@/components/TableLoader.vue";

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

const { items, loading, fetchChecklist } = useStepChecklist();
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

const rows = ref([]);

const headers = [
    { title: "Name", key: "name", sortable: false },
    { title: "Code", key: "code", sortable: false },
    { title: "Required?", key: "is_required", sortable: false },
    { title: "", key: "actions", sortable: false },
];

const addDialog = ref(false);
const addError = ref("");
const addForm = ref({ name: "", code: "", description: "", is_required: true });

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

function withKeys(list) {
    return (list || []).map((r, i) => ({
        ...r,
        is_required: !!r.is_required,
        _key: r.id ?? `tmp-${i}`,
    }));
}

function openAdd() {
    addError.value = "";
    addForm.value = { name: "", code: "", description: "", is_required: true };
    addDialog.value = true;
}

function storeRow(r, idx) {
    return {
        id: r.id ?? null,
        requirement_key: r.requirement_definition_id ?? null,
        name: r.name,
        code: r.code ?? null,
        description: r.description ?? null,
        is_required: !!r.is_required,
        display_order: Number(r.display_order ?? idx),
    };
}

// Write the visible rows into the staging store (no network). Called by
// every inline edit/add/remove; Save version persists everything at once.
function stageRows() {
    if (!typeId.value || !selectedStepId.value) return;
    staging.setChecklist(
        typeId.value,
        Number(selectedStepId.value),
        (rows.value || []).map((r, idx) => storeRow(r, idx)),
    );
}

function addRow() {
    if (!addForm.value.name?.trim()) {
        addError.value = "Name is required.";
        return;
    }
    rows.value = [
        ...rows.value,
        {
            id: null,
            requirement_definition_id: null,
            name: addForm.value.name.trim(),
            code: addForm.value.code?.trim() || null,
            description: addForm.value.description?.trim() || null,
            is_required: !!addForm.value.is_required,
            display_order: rows.value.length,
            _key: `tmp-${Date.now()}`,
        },
    ];
    addDialog.value = false;
    stageRows();
}

function removeRow(item) {
    rows.value = rows.value.filter((r) => r._key !== item._key);
    // Staged removal (undo via Discard on the save bar).
    stageRows();
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

async function loadChecklist() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        await fetchChecklist(workflowDefinitionId.value, Number(selectedStepId.value));
        const sid = Number(selectedStepId.value);
        // Prefer already-staged rows so revisit never shows stale server
        // state over unsaved edits.
        const staged = typeId.value
            ? staging.buckets.get(String(typeId.value))?.checklist?.[String(sid)]
            : null;
        if (staged) {
            rows.value = staged.map((r, i) => ({
                id: r.id ?? null,
                requirement_definition_id: r.requirement_key ?? r.requirement_definition_id ?? null,
                name: r.name,
                code: r.code ?? null,
                description: r.description ?? null,
                is_required: !!r.is_required,
                display_order: Number(r.display_order ?? i),
                _key: r.id ?? `${r.requirement_key ?? r.requirement_definition_id ?? "custom"}-${i}`,
            }));
            return;
        }
        rows.value = withKeys(items.value);
        // Seed the staging slice (skipped when staged edits exist).
        if (typeId.value) {
            staging.seedChecklist(
                typeId.value,
                sid,
                rows.value.map((r, idx) => storeRow(r, idx)),
            );
        }
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load checklist.";
    }
}

async function afterBulkSaved() {
    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await loadChecklist();
}

async function resetToRequirements() {
    if (!selectedStepId.value) return;
    if (!typeId.value) {
        error.value = "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    if (!window.confirm("On the next Save, this checklist will be rebuilt from the step's requirements. Custom rows will be dropped. Mark for rebuild?")) return;
    error.value = "";
    // Staged resync marker: the bulk endpoint re-mirrors this step and
    // ignores staged rows for it. Undo via Discard.
    staging.markResync(typeId.value, Number(selectedStepId.value));
}

onMounted(() => {
    // Steps list and checklist are independent endpoints: fetch in parallel.
    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) selectedStepId.value = sid;
    loadSteps().catch(() => {});
    if (sid && !Number.isNaN(sid)) loadChecklist().catch(() => {});
});
</script>
