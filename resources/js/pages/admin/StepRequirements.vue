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

                <v-alert type="warning" variant="tonal" class="mb-3">
                    Live assignment — saves apply to running transactions immediately.
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
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            prepend-icon="mdi-content-save"
                            class="ml-3"
                            :loading="saving"
                            @click="save"
                        >
                            Save
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
                                />
                            </template>

                            <template v-slot:[`item.is_required`]="{ item }">
                                <v-checkbox
                                    v-model="item.is_required"
                                    density="compact"
                                    hide-details
                                    color="grey-darken-3"
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
                    <v-switch v-model="addForm.is_required" color="grey-darken-3" label="Required (blocks transition)" />
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
import TableLoader from '@/components/TableLoader.vue';

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
    create: createRequirement,
} = useRequirementDefinitions();
const { assigned, loading, saving, fetchAssigned, sync } = useStepRequirements();

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
    { title: "", key: "actions", sortable: false },
];

// Add-entry dialog
const addDialog = ref(false);
const adding = ref(false);
const addError = ref("");
const addForm = ref({ name: "", code: "", description: "", is_required: true });

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

function openAdd() {
    addError.value = "";
    addForm.value = { name: "", code: "", description: "", is_required: true };
    addDialog.value = true;
}

async function addRequirement() {
    if (!addForm.value.name?.trim()) return;
    adding.value = true;
    addError.value = "";
    try {
        const created = await createRequirement(workflowDefinitionId.value, {
            name: addForm.value.name.trim(),
            code: addForm.value.code?.trim() || null,
            description: addForm.value.description?.trim() || null,
        });
        // Attach to the current step immediately with the chosen required flag.
        assignmentRows.value = [
            ...assignmentRows.value,
            {
                requirement_definition_id: created.id,
                code: created.code,
                name: created.name,
                label: created.label,
                description: created.description,
                display_order: assignmentRows.value.length,
                is_required: !!addForm.value.is_required,
            },
        ];
        addDialog.value = false;
        await fetchReqs(workflowDefinitionId.value);
        await save();
    } catch (e) {
        addError.value = e?.response?.data?.message || e?.response?.errors?.name?.[0] || "Failed to add requirement.";
    } finally {
        adding.value = false;
    }
}

function removeRow(item) {
    assignmentRows.value = assignmentRows.value.filter(
        (r) => r.requirement_definition_id !== item.requirement_definition_id,
    );
    // Persist the shorter list immediately so removal sticks on reload.
    save();
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

async function loadAssigned() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        await fetchAssigned(workflowDefinitionId.value, Number(selectedStepId.value));
        assignmentRows.value = (assigned.value || []).map((a) => ({
            requirement_definition_id: a.id,
            code: a.code ?? "",
            name: a.name,
            label: a.label ?? "",
            description: a.description ?? "",
            display_order: a.pivot_meta?.display_order ?? 0,
            is_required: a.pivot_meta?.is_required ?? true,
        }));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load assigned requirements.";
    }
}

async function save() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        const payload = assignmentRows.value.map((r, idx) => ({
            requirement_definition_id: r.requirement_definition_id,
            display_order: Number(r.display_order ?? idx),
            is_required: !!r.is_required,
            code: r.code ?? "",
            description: r.description ?? "",
        }));

        await sync(workflowDefinitionId.value, Number(selectedStepId.value), {
            requirements: payload,
        });

        await loadAssigned();
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Save failed.";
    }
}

watch(selectedStepId, () => {
    assigned.value = [];
    assignmentRows.value = [];
});

onMounted(async () => {
    await fetchReqs(workflowDefinitionId.value);
    await loadSteps();

    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) {
        selectedStepId.value = sid;
        await loadAssigned();
    }
});
</script>
