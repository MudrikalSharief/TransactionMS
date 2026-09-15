<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card lgu-card-fill">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Requirements Library</span>
                <v-spacer />
                <v-btn variant="text" @click="$router.push('/')">Back</v-btn>
                <v-btn
                    color="grey-darken-3"
                    rounded="0"
                    prepend-icon="mdi-plus"
                    :disabled="!selectedWorkflowId"
                    @click="openDialog()"
                >
                    Add Requirement
                </v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>

                <div class="text-caption text-medium-emphasis font-weight-bold mb-1 pl-4">
                    1 · Pick a live process — its checklist loads by itself
                </div>
                <div class="d-flex ga-2 mb-2 flex-wrap">
                    <v-select
                        v-model="selectedWorkflowId"
                        :items="workflowOptions"
                        item-title="label"
                        item-value="id"
                        placeholder="Select a process…"
                        aria-label="Select process"
                        :loading="wfLoading"
                        clearable
                        density="compact"
                        variant="outlined"
                        rounded="0"
                        hide-details
                        style="flex: 1 1 260px"
                    />
                    <v-text-field
                        v-model="search"
                        prepend-inner-icon="mdi-magnify"
                        placeholder="Search checklist…"
                        aria-label="Search requirements"
                        density="compact"
                        variant="outlined"
                        rounded="0"
                        hide-details
                        clearable
                        style="flex: 1 1 200px"
                    />
                    <v-btn
                        variant="tonal"
                        rounded="0"
                        height="40"
                        :disabled="!selectedWorkflowId"
                        :loading="reqLoading"
                        @click="loadRequirements"
                        style="flex: 0 1 140px"
                    >
                        Refresh
                    </v-btn>
                </div>

                <div class="mb-2">
                    <v-chip
                        color="warning"
                        variant="tonal"
                        rounded="lg"
                        size="small"
                        class="font-weight-bold"
                        style="width: 100%; justify-content: start;"
                    >
                        <v-icon start size="small">mdi-alert-circle</v-icon>
                        Live list — adds and edits apply to running transactions immediately.
                    </v-chip>
                </div>

                <div class="d-flex flex-column table-stage" style="min-height: 240px">
                <Transition name="swap" mode="out-in">
                <v-data-table
                    v-if="!reqLoading"
                    key="req-table"
                    :items="filteredItems"
                    :headers="headers"
                    item-key="id"
                    :loading="reqLoading"
                    density="compact"
                    height="450"
                    fixed-header
                    :items-per-page="5"
                    :items-per-page-options="[5, 10, 25]"
                    hover
                    no-data-text="No checklist items here yet — pick another process or add one above."
                    class="lgu-table table-hug"
                >
                    <template v-slot:[`item.is_active`]="{ item }">
                        <v-chip rounded="0" size="small" variant="tonal" :color="item.is_active ? 'success' : 'error'">
                            <v-icon start size="small">{{ item.is_active ? 'mdi-check-circle' : 'mdi-close-circle' }}</v-icon>
                            {{ item.is_active ? "Active" : "Inactive" }}
                        </v-chip>
                    </template>

                    <template v-slot:[`item.stations`]="{ item }">
                        <div class="d-flex flex-wrap ga-1">
                            <v-chip
                                v-for="s in (item.steps || [])"
                                :key="s.id"
                                rounded="0"
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                class="font-weight-bold"
                            >
                                {{ s.order_number }}. {{ s.name }}
                            </v-chip>
                            <span v-if="!(item.steps || []).length" class="text-caption text-medium-emphasis">—</span>
                        </div>
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn
                                icon="mdi-link-variant"
                                v-tooltip="'View / bind stations'"
                                size="small"
                                variant="outlined"
                                color="info"
                                @click="openBindDialog(item)"
                            />
                            <v-btn
                                icon="mdi-pencil"
                                v-tooltip="'Edit requirement'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                @click="openDialog(item)"
                            />
                            <v-btn
                                icon="mdi-delete"
                                v-tooltip="'Delete requirement'"
                                size="small"
                                variant="outlined"
                                color="error"
                                @click="remove(item)"
                            />
                        </div>
                    </template>
                </v-data-table>
                <TableLoader v-else key="req-loader" label="requirements" icon="mdi-clipboard-check-outline" compact style="flex: 1 1 auto" />
                </Transition>
                </div>
            </v-card-text>
        </v-card>

        <v-dialog v-model="bindDialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>
                    Bind stations: {{ bindTarget?.name }}
                    <div class="text-caption text-medium-emphasis font-weight-bold">{{ bindTarget?.code }}</div>
                </v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-caption text-medium-emphasis mb-3">
                        Tick the stations this checklist item appears on.
                        <b>Required</b> items block moving forward until checked.
                        Saves apply to running transactions immediately.
                    </div>
                    <v-autocomplete
                        v-model="bindStationIds"
                        :items="stationOptions"
                        item-title="label"
                        item-value="id"
                        label="Stations bound to this item"
                        multiple
                        chips
                        closable-chips
                        :loading="stationsLoading"
                    />
                    <v-divider class="my-3" />
                    <div class="text-subtitle-2 mb-2">
                        Per-station overrides (order + required/optional)
                    </div>
                    <v-alert v-if="!bindRows.length" type="info" variant="tonal">
                        Not bound to any station — pick at least one above, or save empty to unbind everywhere.
                    </v-alert>
                    <v-data-table
                        v-else
                        :headers="bindHeaders"
                        :items="bindRows"
                        item-key="workflow_step_id"
                        :items-per-page="25"
                        density="compact"
                        hover
                        class="lgu-table"
                    >
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
                                :items="bindRequiredOptions"
                                density="compact"
                                hide-details
                                style="max-width: 200px"
                            />
                        </template>
                    </v-data-table>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="bindDialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="bindSaving"
                        @click="saveBind"
                    >
                        Save binding
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="dialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>
                    {{ form.id ? "Edit Requirement" : "New Requirement" }}
                </v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-caption text-medium-emphasis mb-3">
                        Each item becomes a tick-box on its station's Checklist. <b>Required</b> items block moving forward until checked.
                    </div>
                    <v-text-field
                        v-model.number="form.order_number"
                        type="number"
                        label="Order # (position in the list)"
                    />
                    <v-text-field
                        v-model="form.code"
                        label="Code (lowercase_with_underscores)"
                        hint="System name, e.g. signed_pr_pdf. Used behind the scenes."
                        persistent-hint
                    />
                    <v-text-field
                        v-model="form.name"
                        label="Checklist label"
                        hint="What workers see, e.g. Signed PR PDF attached."
                        persistent-hint
                    />
                    <v-textarea
                        v-model="form.description"
                        label="Help text (optional)"
                        hint="Extra guidance shown under the label."
                        persistent-hint
                        rows="3"
                    />
                    <v-switch v-model="form.is_active" label="Active" />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="dialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="saving"
                        :disabled="!selectedWorkflowId"
                        @click="save"
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
import { useApi } from "@/composables/useApi";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import TableLoader from '@/components/TableLoader.vue';

const { api } = useApi();
const { items, fetchAll, create, update, destroy, syncSteps } = useRequirementDefinitions();
const { items: txTypes, fetchAll: fetchTypes } = useTransactionTypes();

const error = ref("");

const wfLoading = ref(false);
const workflows = ref([]);
const selectedWorkflowId = ref(null);
const search = ref("");

const reqLoading = ref(true);

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

// Stations of the picked process (for the Stations column dialog).
const stations = ref([]);
const stationsLoading = ref(false);

const stationOptions = computed(() =>
    [...(stations.value || [])]
        .sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0))
        .map((s) => ({
            id: s.id,
            label: `${s.order_number}. ${s.name} (${s.code})`,
        })),
);

async function loadStations() {
    if (!selectedWorkflowId.value) {
        stations.value = [];
        return;
    }
    stationsLoading.value = true;
    try {
        const res = await api.get(
            `/api/admin/workflow-definitions/${selectedWorkflowId.value}/steps`,
        );
        stations.value = res.data.data ?? res.data;
    } catch {
        stations.value = [];
    } finally {
        stationsLoading.value = false;
    }
}

// Bind-stations dialog (view + modify the requirement's stations).
const bindDialog = ref(false);
const bindSaving = ref(false);
const bindTarget = ref(null);
const bindStationIds = ref([]);

const bindRequiredOptions = [
    { title: "Required (blocks transition)", value: true },
    { title: "Optional (does not block)", value: false },
];

const bindHeaders = [
    { title: "Station", key: "label", sortable: false },
    { title: "Display Order", key: "display_order", sortable: false },
    { title: "Required?", key: "is_required", sortable: false },
];

const bindRows = computed(() => {
    const boundMap = new Map(
        ((bindTarget.value?.steps || [])).map((s) => [Number(s.id), s]),
    );
    return (bindStationIds.value || [])
        .map((sid) => {
            const st = (stations.value || []).find((x) => Number(x.id) === Number(sid));
            if (!st) return null;
            const prev = boundMap.get(Number(sid));
            const pivot = prev?.pivot_meta || prev?.pivot || {};
            return {
                workflow_step_id: st.id,
                label: `${st.order_number}. ${st.name} (${st.code})`,
                display_order: pivot.display_order ?? 0,
                is_required: pivot.is_required ?? true,
            };
        })
        .filter(Boolean)
        .sort((x, y) => (x.display_order ?? 0) - (y.display_order ?? 0));
});

function openBindDialog(item) {
    bindTarget.value = item;
    bindStationIds.value = ((item?.steps || []).map((s) => s.id));
    bindDialog.value = true;
}

async function saveBind() {
    if (!selectedWorkflowId.value || !bindTarget.value) return;
    bindSaving.value = true;
    error.value = "";
    try {
        const payload = bindRows.value.map((r) => ({
            workflow_step_id: r.workflow_step_id,
            display_order: Number(r.display_order ?? 0),
            is_required: !!r.is_required,
        }));
        await syncSteps(selectedWorkflowId.value, bindTarget.value.id, {
            steps: payload,
        });
        bindDialog.value = false;
        await loadRequirements();
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Save failed.";
    } finally {
        bindSaving.value = false;
    }
}

const headers = [
    { title: "#", key: "order_number" },
    { title: "Code", key: "code" },
    { title: "Checklist label", key: "name" },
    { title: "Stations", key: "stations", sortable: false },
    { title: "Status", key: "is_active" },
    { title: "", key: "actions", sortable: false },
];

const filteredItems = computed(() => {
    const q = (search.value || "").trim().toLowerCase();
    if (!q) return items.value || [];
    return (items.value || []).filter((r) =>
        `${r?.name || ""} ${r?.code || ""} ${r?.description || ""}`.toLowerCase().includes(q),
    );
});

// Latest-only: one entry per transaction type = its latest published
// (live) version. Drafts and retired versions stay out of the picker.
const liveByType = computed(() => {
    const map = {};
    for (const w of (workflows.value || [])) {
        if (w.status !== "published") continue;
        const tid = w.transaction_type_id;
        if (!map[tid] || Number(w.version) > Number(map[tid].version)) map[tid] = w;
    }
    return Object.values(map);
});

const typeNameOf = (tid) =>
    (txTypes.value || []).find((t) => Number(t.id) === Number(tid))?.name || `Type #${tid}`;

const vanillaName = (w) => {
    const raw = w.name || typeNameOf(w.transaction_type_id);
    return String(raw).replace(/\s+v\d+\s*$/i, "").trim() || raw;
};

const workflowOptions = computed(() =>
    liveByType.value.map((w) => ({
        id: w.id,
        label: vanillaName(w),
    })),
);

async function loadWorkflows() {
    wfLoading.value = true;
    error.value = "";
    try {
        const res = await api.get("/api/admin/workflow-definitions");
        workflows.value = res.data.data ?? res.data;
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load workflow definitions.";
    } finally {
        wfLoading.value = false;
    }
}

async function loadRequirements() {
    if (!selectedWorkflowId.value) return;
    reqLoading.value = true;
    error.value = "";
    try {
        await fetchAll(selectedWorkflowId.value);
        await loadStations();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load requirements.";
    } finally {
        reqLoading.value = false;
    }
}

function openDialog(item = null) {
    error.value = "";
    if (!selectedWorkflowId.value) {
        error.value = "Pick a process above first.";
        return;
    }

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

async function save() {
    if (!selectedWorkflowId.value) return;
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
            await update(selectedWorkflowId.value, form.value.id, payload);
        } else {
            await create(selectedWorkflowId.value, payload);
        }

        dialog.value = false;
        await loadRequirements();
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Save failed.";
    } finally {
        saving.value = false;
    }
}

async function remove(item) {
    if (!selectedWorkflowId.value) return;
    error.value = "";

    try {
        await destroy(selectedWorkflowId.value, item.id);
        await loadRequirements();
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete failed.";
    }
}

onMounted(async () => {
    await loadWorkflows();
    fetchTypes().catch(() => {});
    // Latest-only: default to the first live version so drafts and
    // retired versions never appear unless opened elsewhere.
    const live = liveByType.value;
    if (!selectedWorkflowId.value && live.length) {
        selectedWorkflowId.value = live[0].id;
        await loadRequirements();
    } else if (!selectedWorkflowId.value) {
        reqLoading.value = false;
    }
});

// Picking another process loads its checklist at once — no extra button press.
watch(selectedWorkflowId, async (id, prev) => {
    if (!id || id === prev) return;
    await loadRequirements();
});
</script>

<style scoped>
/* Loader <-> table swap glides instead of popping: no perceived shift */
.swap-enter-active,
.swap-leave-active {
    transition: opacity 0.22s ease, transform 0.22s ease;
}
.swap-enter-from {
    opacity: 0;
    transform: translateY(10px);
}
.swap-leave-to {
    opacity: 0;
    transform: translateY(-10px);
}
</style>
