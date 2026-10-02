<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-source-branch</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Assign Fields to Step</span>
                <v-spacer />
                <v-btn variant="text" @click="goBack"
                    >Back</v-btn
                >
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">
                <v-alert
                    v-if="error"
                    type="error"
                    variant="tonal"
                    class="mb-3"
                    >{{ error }}</v-alert
                >

                <StagingSaveBar
                    :type-id="typeId"
                    :def-id="workflowDefinitionId"
                    @saved="afterBulkSaved"
                    @discarded="loadAssigned"
                />

                <v-alert
                    v-if="!workflowDefinitionId || !stepIdFromUrl"
                    type="error"
                    variant="tonal"
                    class="mb-3"
                >
                    Invalid URL. Expected
                    /admin/workflows/:workflowId/steps/:stepId/fields
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
                            Load Step Fields
                        </v-btn>
                    </v-col>
                </v-row>

                <v-divider class="my-3" />

                <div class="text-subtitle-1 mb-2">Step Field Assignment</div>
                <v-alert v-if="!selectedStepId" type="info" variant="tonal">
                    Pick a step first.
                </v-alert>

                <div v-else>
                    <v-alert type="info" variant="tonal" class="mb-3">
                        You are editing builder configuration. Changes stay
                        staged locally until you press Save version — even on
                        published versions (the server applies them to the draft).
                    </v-alert>

                    <v-row>
                        <v-col cols="12" md="7">
                            <v-autocomplete
                                v-model="selectedFieldIds"
                                :items="fields"
                                item-title="name"
                                item-value="id"
                                label="Fields on this step"
                                multiple
                                chips
                                closable-chips
                                @update:model-value="stageFields"
                            />
                        </v-col>
                    </v-row>

                    <v-divider class="my-3" />

                    <div class="text-subtitle-2 mb-2">
                        Per-field overrides (order + required)
                    </div>

                    <div class="d-flex flex-column" style="min-height: 510px">
                    <v-data-table
                        v-show="!stepsLoading"
                        :headers="assignHeaders"
                        :items="assignmentRows"
                        item-key="field_definition_id"
                        :items-per-page="25"
                        density="compact"
                        height="450"
                        fixed-header
                        hover
                        class="lgu-table"
                    >
                        <template v-slot:[`item.name`]="{ item }">
                            <div class="font-weight-medium">
                                {{ item.name }}
                            </div>
                            <div class="text-caption">
                                {{ item.code }} • {{ item.type }}
                            </div>
                        </template>

                        <template v-slot:[`item.display_order`]="{ item }">
                            <v-text-field
                                v-model.number="item.display_order"
                                type="number"
                                density="compact"
                                hide-details
                                style="max-width: 120px"
                                @update:model-value="stageFields"
                            />
                        </template>

                        <template v-slot:[`item.required_override`]="{ item }">
                            <v-select
                                v-model="item.required_override"
                                :items="requiredOverrideOptions"
                                density="compact"
                                hide-details
                                style="max-width: 180px"
                                @update:model-value="stageFields"
                            />
                        </template>
                    </v-data-table>
                    <TableLoader v-if="stepsLoading" label="fields" icon="mdi-form-textbox" style="flex: 1 1 auto" />
                    </div>
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, nextTick, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useFieldDefinitions } from "@/composables/useFieldDefinitions";
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

const { items: fields, fetchAll: fetchFields } = useFieldDefinitions();
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

const selectedFieldIds = ref([]);
const assigned = ref([]);

const requiredOverrideOptions = [
    { title: "Default (use field.required)", value: null },
    { title: "Force Required", value: true },
    { title: "Force Optional", value: false },
];

const assignHeaders = [
    { title: "Field", key: "name", sortable: false },
    { title: "Display Order", key: "display_order", sortable: false },
    { title: "Required Override", key: "required_override", sortable: false },
];

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

const assignmentRows = computed(() => {
    const assignedMap = new Map((assigned.value || []).map((a) => [a.id, a]));
    return (selectedFieldIds.value || [])
        .map((fid) => {
            const f = (fields.value || []).find((x) => x.id === fid);
            if (!f) return null;
            const a = assignedMap.get(fid);
            const pivot = a?.pivot_meta || a?.pivot || {};
            return {
                field_definition_id: fid,
                name: f.name,
                code: f.code,
                type: f.type,
                display_order: pivot.display_order ?? 0,
                required_override: pivot.required_override ?? null,
            };
        })
        .filter(Boolean)
        .sort((x, y) => (x.display_order ?? 0) - (y.display_order ?? 0));
});

async function loadSteps() {
    stepsLoading.value = true;
    error.value = "";
    try {
        const wid = workflowDefinitionId.value;
        if (!wid || Number.isNaN(wid))
            throw new Error("Invalid workflowDefinitionId");

        try {
            const defRes = await api.get(
                `/api/admin/workflow-definitions/${wid}`,
            );
            const def = defRes.data?.data ?? defRes.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
        } catch {
            /* type id for Back is best-effort */
        }

        const res = await api.get(
            `/api/admin/workflow-definitions/${wid}/steps`,
        );
        steps.value = res.data.data ?? res.data;
    } catch (e) {
        error.value =
            e?.response?.data?.message || e?.message || "Failed to load steps.";
    } finally {
        stepsLoading.value = false;
    }
}

async function loadAssigned() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        const wid = workflowDefinitionId.value;
        const sid = Number(selectedStepId.value);
        if (!wid || Number.isNaN(wid) || !sid || Number.isNaN(sid))
            throw new Error("Invalid ids");

        const res = await api.get(
            `/api/admin/workflow-definitions/${wid}/steps/${sid}/fields`,
        );
        // Prefer already-staged assignment so revisit never shows stale
        // server state over unsaved edits (names resolve via the catalog).
        const staged = typeId.value
            ? staging.buckets.get(String(typeId.value))?.fields?.[String(sid)]
            : null;
        if (staged) {
            selectedFieldIds.value = staged.map((r) => r.field_definition_id);
            assigned.value = staged.map((r) => ({
                id: r.field_definition_id,
                pivot_meta: {
                    display_order: r.display_order ?? 0,
                    required_override: r.required_override ?? null,
                },
            }));
            return;
        }
        assigned.value = res.data.data ?? res.data;

        selectedFieldIds.value = (assigned.value || []).map((a) => a.id);

        // Seed the staging slice (skipped when staged edits exist).
        if (typeId.value) {
            staging.seedFields(
                typeId.value,
                sid,
                assignmentRows.value.map((r) => ({
                    field_definition_id: r.field_definition_id,
                    display_order: Number(r.display_order ?? 0),
                    required_override: r.required_override ?? null,
                })),
            );
        }
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to load assigned fields.";
    }
}

// Write the visible assignment into the staging store (no network).
// Called by every picker/toggle edit; Save version persists everything.
// Deferred a tick so v-model writes land before we snapshot the rows.
async function stageFields() {
    await nextTick();
    if (!typeId.value || !selectedStepId.value) return;
    staging.setFields(
        typeId.value,
        Number(selectedStepId.value),
        assignmentRows.value.map((r) => ({
            field_definition_id: r.field_definition_id,
            display_order: Number(r.display_order ?? 0),
            required_override: r.required_override ?? null,
        })),
    );
}

async function afterBulkSaved() {
    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await loadAssigned();
}

watch(selectedStepId, () => {
    assigned.value = [];
    selectedFieldIds.value = [];
});

watch(
    () => [workflowDefinitionId.value, stepIdFromUrl.value],
    async ([wid, sid]) => {
        if (!wid || Number.isNaN(wid)) return;
        if (!sid || Number.isNaN(sid)) return;

        if (steps.value.length) {
            selectedStepId.value = sid;
            await loadAssigned();
        }
    },
);

onMounted(async () => {
    // Field catalog and step list are independent: fetch in parallel.
    await Promise.allSettled([fetchFields(), loadSteps()]);

    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) {
        selectedStepId.value = sid;
        await loadAssigned();
    }
});
</script>
