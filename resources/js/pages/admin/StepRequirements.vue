<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Assign Requirements to Step</span>
                <v-spacer />
                <v-btn variant="text" @click="$router.push('/admin/workflows')">Back</v-btn>
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
                    <v-row>
                        <v-col cols="12" md="7">
                            <v-autocomplete
                                v-model="selectedRequirementIds"
                                :items="requirements"
                                item-title="name"
                                item-value="id"
                                label="Requirements on this step"
                                multiple
                                chips
                                closable-chips
                            />
                        </v-col>

                        <v-col cols="12" md="5">
                            <v-btn
                                color="grey-darken-3"
                                rounded="0"
                                :loading="saving"
                                class="mt-1"
                                @click="save"
                            >
                                Save Assignment
                            </v-btn>
                        </v-col>
                    </v-row>

                    <v-divider class="my-3" />

                    <div class="text-subtitle-2 mb-2">
                        Per-requirement overrides (order + required/optional)
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
                            <div class="text-caption">{{ item.code }}</div>
                        </template>

                        <template v-slot:[`item.display_order`]="{ item }">
                            <v-text-field
                                v-model.number="item.display_order"
                                type="number"
                                density="compact"
                                hide-details
                                style="max-width: 120px"
                            />
                        </template>

                        <template v-slot:[`item.is_required`]="{ item }">
                            <v-select
                                v-model="item.is_required"
                                :items="requiredOptions"
                                density="compact"
                                hide-details
                                style="max-width: 200px"
                            />
                        </template>
                    </v-data-table>
                    <TableLoader v-if="loading" label="requirements" icon="mdi-clipboard-check-outline" style="flex: 1 1 auto" />
                    </div>
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useStepRequirements } from "@/composables/useStepRequirements";
import TableLoader from '@/components/TableLoader.vue';

const route = useRoute();
const { api } = useApi();

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const { items: requirements, fetchAll: fetchReqs } = useRequirementDefinitions();
const { assigned, loading, saving, fetchAssigned, sync } = useStepRequirements();

const error = ref("");

const steps = ref([]);
const stepsLoading = ref(false);
const selectedStepId = ref(null);

const selectedRequirementIds = ref([]);

const requiredOptions = [
    { title: "Required (blocks transition)", value: true },
    { title: "Optional (does not block)", value: false },
];

const assignHeaders = [
    { title: "Requirement", key: "name", sortable: false },
    { title: "Display Order", key: "display_order", sortable: false },
    { title: "Required?", key: "is_required", sortable: false },
];

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

const assignmentRows = computed(() => {
    const assignedMap = new Map((assigned.value || []).map((a) => [a.id, a]));
    return (selectedRequirementIds.value || [])
        .map((rid) => {
            const r = (requirements.value || []).find((x) => x.id === rid);
            if (!r) return null;
            const a = assignedMap.get(rid);
            const pivot = a?.pivot_meta || a?.pivot || {};
            return {
                requirement_definition_id: rid,
                name: r.name,
                code: r.code,
                display_order: pivot.display_order ?? 0,
                is_required: pivot.is_required ?? true,
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
        selectedRequirementIds.value = (assigned.value || []).map((a) => a.id);
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load assigned requirements.";
    }
}

async function save() {
    if (!selectedStepId.value) return;
    error.value = "";
    try {
        const payload = assignmentRows.value.map((r) => ({
            requirement_definition_id: r.requirement_definition_id,
            display_order: Number(r.display_order ?? 0),
            is_required: !!r.is_required,
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
    selectedRequirementIds.value = [];
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
