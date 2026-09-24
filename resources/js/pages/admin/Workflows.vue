<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-source-branch</v-icon>
                </v-avatar>
                <div>
                    <span class="text-h6 font-weight-bold">Workflows</span>
                    <div v-if="selectedTypeName" class="text-caption text-medium-emphasis font-weight-bold">{{ selectedTypeName }}</div>
                    <div v-else class="text-caption text-medium-emphasis">Select a process</div>
                    <div v-if="activeDef" class="d-flex flex-wrap align-center ga-2 mt-1">
                        <v-chip
                            rounded="0"
                            size="small"
                            variant="tonal"
                            :color="activeDef.status === 'published' ? 'success' : activeDef.status === 'draft' ? 'warning' : 'grey'"
                            class="font-weight-bold"
                        >
                            {{ activeDef.status === "draft" ? "Draft" : isLiveDef(activeDef) ? "Current process" : "Previous" }}
                        </v-chip>
                        <v-chip rounded="0" size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
                            {{ (activeDef.steps || []).length }} steps
                        </v-chip>
                    </div>
                </div>
                <v-spacer />
                <div class="d-flex gap-2 align-center">
                    <v-btn
                        variant="text"
                        color="grey-darken-3"
                        prepend-icon="mdi-arrow-left"
                        @click="$router.push('/admin/transaction-types')"
                    >
                        Back
                    </v-btn>
                    <v-tooltip location="bottom" max-width="480">
                        <template #activator="{ props }">
                            <v-btn
                                icon="mdi-help-circle-outline"
                                variant="text"
                                color="grey-darken-3"
                                v-bind="props"
                            />
                        </template>
                        <GuideTable title="Column guide" :sections="guideSections" horizontal />
                    </v-tooltip>
                </div>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>
                <v-alert v-if="notice" type="success" variant="tonal" class="mb-3">
                    {{ notice }}
                </v-alert>
                <v-alert
                    v-if="!selectedTypeId && !loading"
                    type="warning"
                    variant="tonal"
                    rounded="0"
                    class="mb-3"
                >
                    No process selected. Pick one below, or go to
                    <b>Processes</b> and open <b>Steps</b> for one process.
                </v-alert>
                <v-select
                    v-if="!selectedTypeId && !loading && (types || []).length"
                    :model-value="null"
                    :items="typePickerOptions"
                    item-title="label"
                    item-value="id"
                    label="Select process"
                    density="compact"
                    class="mb-3"
                    @update:model-value="onPickType"
                />

                <template v-if="!activeDef && selectedTypeId">
                    <div class="d-flex align-center mb-2">
                        <div class="text-subtitle-1 font-weight-bold">Steps</div>
                        <v-spacer />
                        <v-btn
                            color="grey-darken-3"
                            rounded="0"
                            prepend-icon="mdi-plus"
                            :loading="saving"
                            @click="clickAddStep"
                        >
                            Add Step
                        </v-btn>
                    </div>
                    <div class="d-flex flex-column" style="min-height: 510px">
                        <template v-if="loading">
                            <v-skeleton-loader type="table-thead" />
                            <v-skeleton-loader type="table-tbody" class="mt-2" />
                            <TableLoader compact label="steps" icon="mdi-source-branch" style="flex: 1 1 auto" />
                        </template>
                        <v-alert v-else type="info" variant="tonal" class="mb-3">
                            No process yet for this process — click <b>Add Step</b> to create step 1.
                        </v-alert>
                    </div>

                    <v-divider class="my-3" />

                    <div class="d-flex align-center mb-2 mt-6">
                        <div class="text-subtitle-1 font-weight-bold">Routes</div>
                    </div>
                    <div class="d-flex flex-column" style="min-height: 510px">
                        <template v-if="loading">
                            <v-skeleton-loader type="table-thead" />
                            <v-skeleton-loader type="table-tbody" class="mt-2" />
                            <TableLoader compact label="routes" icon="mdi-source-branch" style="flex: 1 1 auto" />
                        </template>
                    </div>
                </template>

                <template v-if="activeDef">

                <div class="d-flex align-center mb-2">
                    <div class="text-subtitle-1 font-weight-bold">Steps ({{ flatStepRows.length }})</div>
                    <v-spacer />
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        prepend-icon="mdi-plus"
                        :disabled="!selectedTypeId"
                        @click="clickAddStep"
                    >
                        Add Step
                    </v-btn>
                </div>
                <div class="d-flex flex-column" style="min-height: 510px">
                <v-alert v-if="!loading && activeDef && !flatStepRows.length" type="info" variant="tonal" class="mb-3">
                    This process has no steps yet — click <b>Add Step</b> to create step 1.
                </v-alert>
                <v-data-table
                    v-show="!loading"
                    v-model:page="stepPage"
                    :items="flatStepRows"
                    :headers="stepHeaders"
                    item-key="id"
                    density="compact"
                    height="330"
                    fixed-header
                    :items-per-page="STEP_PAGE_SIZE"
                    :items-per-page-options="[STEP_PAGE_SIZE]"
                    hover
                    class="lgu-table table-pages"
                >
                    <template v-slot:[`item.order_number`]="{ item }">
                        <v-chip rounded="0" size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
                            {{ item._num }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.name`]="{ item }">
                        <div class="d-flex align-center" :style="`padding-left: ${item._depth * 28}px`">
                            <v-icon v-if="item._depth > 0" size="small" color="grey" class="mr-1">mdi-subdirectory-arrow-right</v-icon>
                            <span class="font-weight-medium">{{ item.name }}</span>
                        </div>
                        <div v-if="item.parent_name" class="text-caption text-medium-emphasis" :style="`padding-left: ${item._depth * 28 + 22}px`">
                            sub of {{ item.parent_name }}
                        </div>
                    </template>
                    <template v-slot:[`item.flags`]="{ item }">
                        <v-chip
                            v-if="item.is_start"
                            rounded="0"
                            size="small"
                            variant="tonal"
                            color="success"
                            class="mr-1"
                            ><v-icon start size="small">mdi-play-circle</v-icon>start</v-chip
                        >
                        <v-chip v-if="item.is_end" rounded="0" size="small" variant="tonal" color="info"
                            ><v-icon start size="small">mdi-stop-circle</v-icon>end</v-chip
                        >
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn
                                icon="mdi-clipboard-list-outline"
                                v-tooltip="'Requirements'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                @click="goStepRequirements(item)"
                            />
                            <v-btn
                                icon="mdi-clipboard-check-outline"
                                v-tooltip="'Checklist'"
                                size="small"
                                variant="outlined"
                                color="info"
                                @click="goStepChecklist(item)"
                            />
                            <v-btn
                                icon="mdi-pencil"
                                v-tooltip="'Edit step'"
                                size="small"
                                variant="outlined"
                                color="warning"
                                @click="editStep(item)"
                            />
                            <v-btn
                                icon="mdi-delete"
                                v-tooltip="'Delete step'"
                                size="small"
                                variant="outlined"
                                color="error"
                                @click="deleteStep(item)"
                            />
                        </div>
                    </template>
                    <template #[`body.append`]>
                        <tr v-for="n in stepFillerCount" :key="`step-skel-${n}`" class="skel-fill">
                            <td :colspan="stepHeaders.length">&nbsp;</td>
                        </tr>
                    </template>
                </v-data-table>
                <template v-if="loading">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" class="mt-2" />
                    <TableLoader compact label="steps" icon="mdi-source-branch" style="flex: 1 1 auto" />
                </template>
                </div>

                <v-divider class="my-3" />

                <div class="d-flex align-center mb-2 mt-6">
                    <div class="text-subtitle-1 font-weight-bold">Routes</div>
                    <v-spacer />
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        prepend-icon="mdi-plus"
                        :disabled="!selectedTypeId"
                        @click="clickAddRoute"
                    >
                        Add Route
                    </v-btn>
                </div>
                <div class="d-flex flex-column" style="min-height: 510px">
                <v-data-table
                    v-show="!loading"
                    v-model:page="routePage"
                    :items="sortedRoutes"
                    :headers="routeHeaders"
                    item-key="id"
                    density="compact"
                    height="330"
                    fixed-header
                    :items-per-page="ROUTE_PAGE_SIZE"
                    :items-per-page-options="[ROUTE_PAGE_SIZE]"
                    hover
                    class="lgu-table table-pages"
                >
                    <template v-slot:[`item.from_step_id`]="{ item }">
                        <v-chip
                            rounded="0"
                            size="x-small"
                            variant="tonal"
                            :color="stepLabel(item.from_step_id).deleted ? 'error' : 'grey-darken-3'"
                            class="font-weight-bold route-step-chip"
                            :title="stepLabel(item.from_step_id).text"
                        >
                            {{ stepLabel(item.from_step_id).text }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.to_step_id`]="{ item }">
                        <v-chip
                            rounded="0"
                            size="x-small"
                            variant="tonal"
                            :color="stepLabel(item.to_step_id).deleted ? 'error' : 'primary'"
                            class="font-weight-bold route-step-chip"
                            :title="stepLabel(item.to_step_id).text"
                        >
                            {{ stepLabel(item.to_step_id).text }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.condition_expression`]="{ item }">
                        <code
                            class="route-cond"
                            :title="pretty(item.condition_expression) || 'No condition'"
                            >{{ pretty(item.condition_expression) || "—" }}</code
                        >
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn
                                icon="mdi-pencil"
                                v-tooltip="'Edit route'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                @click="editRoute(item)"
                            />
                            <v-btn
                                icon="mdi-delete"
                                v-tooltip="'Delete route'"
                                size="small"
                                variant="outlined"
                                color="error"
                                @click="deleteRoute(item)"
                            />
                        </div>
                    </template>
                    <template #[`body.append`]>
                        <tr v-for="n in routeFillerCount" :key="`route-skel-${n}`" class="skel-fill">
                            <td :colspan="routeHeaders.length">&nbsp;</td>
                        </tr>
                    </template>
                </v-data-table>
                <template v-if="loading">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" class="mt-2" />
                    <TableLoader compact label="routes" icon="mdi-source-branch" style="flex: 1 1 auto" />
                </template>
                </div>

                <v-expansion-panels v-if="!loading && historyDefs.length" variant="accordion" class="mt-4">
                    <v-expansion-panel rounded="0" title="History (previous processes, read-only)">
                        <template #text>
                            <v-list density="compact" class="py-0">
                                <v-list-item
                                    v-for="d in historyDefs"
                                    :key="d.id"
                                    rounded="lg"
                                    @click="viewDef(d)"
                                >
                                    <template #prepend>
                                        <v-icon :color="wfStatusColor(d.status)" size="small">{{ wfStatusIcon(d.status) }}</v-icon>
                                    </template>
                                    <v-list-item-title class="font-weight-bold">
                                        {{ d.name || "Process" }} · {{ (d.steps || []).length }} steps
                                    </v-list-item-title>
                                    <v-list-item-subtitle>{{ wfStatusLabel(d.status) }}</v-list-item-subtitle>
                                    <template #append>
                                        <v-btn
                                            icon="mdi-eye"
                                            v-tooltip="'View (read-only)'"
                                            size="small"
                                            variant="text"
                                            color="primary"
                                            @click.stop="viewDef(d)"
                                        />
                                    </template>
                                </v-list-item>
                            </v-list>
                        </template>
                    </v-expansion-panel>
                </v-expansion-panels>
                </template>
            </v-card-text>
        </v-card>

        <!-- Step Dialog -->
        <v-dialog v-model="stepDialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>{{
                    stepForm.id ? "Edit Step" : "New Step"
                }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-text-field
                        v-model="stepForm.order_number"
                        type="number"
                        label="Order #"
                    />
                    <v-select
                        v-model="stepForm.parent_id"
                        :items="parentStepOptions"
                        item-title="label"
                        item-value="id"
                        label="Parent step (empty = top level)"
                        :hint="!parentStepOptions.length ? 'No steps yet — save this as the first top-level step, then nest others under it.' : ''"
                        persistent-hint
                        clearable
                    />
                    <v-text-field v-model="stepForm.name" label="Name" />
                    <v-text-field
                        v-model="stepForm.stage"
                        label="Stage (Budget/Accounting/...)"
                    />
                    <v-text-field
                        v-model="stepForm.sla_minutes"
                        type="number"
                        label="SLA Minutes"
                    />
                    <v-switch v-model="stepForm.is_start" label="Is Start" />
                    <v-switch v-model="stepForm.is_end" label="Is End" />

                    <v-select
                        v-model="stepForm.role_ids"
                        :items="roleOptions"
                        item-title="label"
                        item-value="id"
                        label="Roles allowed for this step"
                        multiple
                        chips
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="stepDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="saveStep"
                        >Save</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Route Dialog -->
        <v-dialog v-model="routeDialog" max-width="900">
            <v-card rounded="0">
                <v-card-title>{{
                    routeForm.id ? "Edit Route" : "New Route"
                }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-select
                        v-model="routeForm.from_step_id"
                        :items="stepOptions"
                        item-title="label"
                        item-value="id"
                        label="From Step"
                    />
                    <v-select
                        v-model="routeForm.to_step_id"
                        :items="stepOptions"
                        item-title="label"
                        item-value="id"
                        label="To Step"
                    />
                    <v-text-field
                        v-model="routeForm.action_code"
                        label="Action Code (submit/approve/return/reject)"
                    />
                    <v-switch
                        v-model="routeForm.is_return_route"
                        label="Is Return Route (controlled rollback)"
                    />
                    <v-text-field
                        v-model="routeForm.route_group"
                        label="Route Group / Lane (optional)"
                    />
                    <v-text-field
                        v-model="routeForm.required_approvals_count"
                        type="number"
                        label="Required approvals (optional)"
                    />

                    <v-textarea
                        v-model="routeForm.condition_expression_json"
                        label="Condition Expression JSON (optional, JSON logic-ish)"
                        rows="6"
                        :hint="conditionHint"
                        persistent-hint
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="routeDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="saveRoute"
                        >Save</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useWorkflows } from "@/composables/useWorkflows";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import { useRoles } from "@/composables/useRoles";
import TableLoader from '@/components/TableLoader.vue';
import GuideTable from '@/components/GuideTable.vue';
import { wfStatusColor, wfStatusIcon, wfStatusLabel } from '@/utils/workflowStatus';

const {
    defs,
    loading,
    fetchDefinitions,
    createDraft,
    publish,
    addStep,
    updateStep,
    deleteStep: apiDeleteStep,
    addRoute,
    updateRoute,
    deleteRoute: apiDeleteRoute,
} = useWorkflows();

const { items: types, fetchAll: fetchTypes } = useTransactionTypes();
const { roles, fetchRoles } = useRoles();

const selectedTypeId = ref(null);
const activeDef = ref(null);
const error = ref("");
const notice = ref("");
const saving = ref(false);
const route = useRoute();
const router = useRouter();

const guideSections = [
    {
        title: "PROCESSES",
        rows: [
            { term: "PROCESS", text: "CURRENT = LIVE FLOW, DRAFT = EDITABLE, PREVIOUS = RETIRED" },
            { term: "STATUS", text: "DRAFT = EDITABLE, PUBLISHED = LIVE, ARCHIVED = RETIRED" },
            { term: "NAME", text: "PROCESS LABEL" },
        ],
    },
    {
        title: "STEPS",
        rows: [
            { term: "FLAGS", text: "START = FIRST STEP, END = FINAL STEP" },
            { term: "SLA (MIN)", text: "TARGET MINUTES TO FINISH THE STEP" },
            { term: "STAGE", text: "WHICH OFFICE / PHASE HANDLES IT" },
        ],
    },
    {
        title: "ROUTES",
        rows: [
            { term: "FROM → TO", text: "WHICH STEP MOVES TO WHICH ON AN ACTION" },
            { term: "RETURN", text: "SENDS THE WORK BACKWARD FOR CORRECTION" },
        ],
    },
];

const conditionHint =
    'Store as JSON (not PHP). Example: {">=":[{"var":"fields.amount"},50000]}';

const roleOptions = computed(
    () => (roles.value || []).map((r) => ({ id: r.id, label: `${r.name}` })), // use ${r.code} to show Role Code
);

const selectedTypeName = computed(() => {
    const t = (types.value || []).find((x) => Number(x.id) === Number(selectedTypeId.value));
    return t ? `${t.name} (${t.code})` : "";
});

const typePickerOptions = computed(() =>
    (types.value || []).map((t) => ({
        id: Number(t.id),
        label: `${t.name} (${t.code})`,
    })),
);

function onPickType(id) {
    const nid = Number(id);
    if (!nid || Number.isNaN(nid)) return;
    router.replace({ path: "/admin/workflows", query: { type: nid } });
}

const stepOptions = computed(() =>
    flatStepRows.value.map((s) => ({
        id: s.id,
        label: `${s._num}. ${s.name} `,
    })),
);

// Hierarchy: flat step rows → depth-first tree → flat display rows
// with dotted numbers (1, 1.1, 1.2, 2…). Editable afterwards.
const flatStepRows = computed(() => {
    const list = activeDef.value?.steps || [];
    const byId = new Map(list.map((s) => [s.id, s]));
    const byParent = new Map();
    for (const s of list) {
        const key = s.parent_id ?? 0;
        if (!byParent.has(key)) byParent.set(key, []);
        byParent.get(key).push(s);
    }
    for (const arr of byParent.values()) {
        arr.sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0));
    }
    const out = [];
    const walk = (parentKey, depth, prefix) => {
        for (const s of (byParent.get(parentKey) || [])) {
            const num = prefix ? `${prefix}.${s.order_number}` : `${s.order_number}`;
            out.push({
                ...s,
                _depth: depth,
                _num: num,
                parent_name: s.parent_id ? byId.get(s.parent_id)?.name ?? null : null,
            });
            walk(s.id, depth + 1, num);
        }
    };
    walk(0, 0, "");
    for (const s of list) {
        if (s.parent_id && !byId.has(s.parent_id) && !out.some((r) => r.id === s.id)) {
            out.push({ ...s, _depth: 0, _num: `${s.order_number}`, parent_name: null });
        }
    }
    return out;
});

function descendantsOfStep(id) {
    const ids = new Set([id]);
    let grew = true;
    while (grew) {
        grew = false;
        for (const s of (activeDef.value?.steps || [])) {
            if (s.parent_id && ids.has(s.parent_id) && !ids.has(s.id)) {
                ids.add(s.id);
                grew = true;
            }
        }
    }
    return ids;
}

// Routes table: forwards read start→end by station order,
// return arrows group at the bottom (never first).
const sortedRoutes = computed(() => {
    const orderOf = (id) =>
        Number((activeDef.value?.steps || []).find((s) => Number(s.id) === Number(id))?.order_number ?? 9999);
    return [...(activeDef.value?.routes || [])].sort((a, b) => {
        const ra = a.is_return_route ? 1 : 0;
        const rb = b.is_return_route ? 1 : 0;
        if (ra !== rb) return ra - rb;
        return orderOf(a.from_step_id) - orderOf(b.from_step_id) || orderOf(a.to_step_id) - orderOf(b.to_step_id);
    });
});

// Fixed page size (7) keeps both tables the same height; short last pages
// are padded with skeleton rows so the footer never jumps.
const STEP_PAGE_SIZE = 7;
const ROUTE_PAGE_SIZE = 7;
const stepPage = ref(1);
const routePage = ref(1);

const stepFillerCount = computed(() => {
    if (loading.value) return 0;
    const total = flatStepRows.value.length;
    if (!total) return 0;
    const rest = total - (stepPage.value - 1) * STEP_PAGE_SIZE;
    return STEP_PAGE_SIZE - Math.min(Math.max(rest, 0), STEP_PAGE_SIZE);
});

const routeFillerCount = computed(() => {
    if (loading.value) return 0;
    const total = sortedRoutes.value.length;
    if (!total) return 0;
    const rest = total - (routePage.value - 1) * ROUTE_PAGE_SIZE;
    return ROUTE_PAGE_SIZE - Math.min(Math.max(rest, 0), ROUTE_PAGE_SIZE);
});

// Keep the current page valid when rows are added/removed.
watch([flatStepRows, sortedRoutes], () => {
    const maxStep = Math.max(1, Math.ceil(flatStepRows.value.length / STEP_PAGE_SIZE));
    if (stepPage.value > maxStep) stepPage.value = maxStep;
    const maxRoute = Math.max(1, Math.ceil(sortedRoutes.value.length / ROUTE_PAGE_SIZE));
    if (routePage.value > maxRoute) routePage.value = maxRoute;
});

// Route endpoints as names: id → "1 · Create PR" (dotted for sub-steps).
// Missing step (deleted) announces itself instead of rendering blank.
function stepLabel(id) {
    const s = flatStepRows.value.find((x) => Number(x.id) === Number(id));
    if (!s) return { text: `#${id} (deleted)`, deleted: true };
    return { text: `${s._num} · ${s.name}`, deleted: false };
}

// Parent picker: every step except self + own sub-steps (would cycle).
const parentStepOptions = computed(() => {
    const banned = stepForm.value.id ? descendantsOfStep(stepForm.value.id) : new Set();
    return flatStepRows.value
        .filter((s) => !banned.has(s.id))
        .map((s) => ({ id: s.id, label: `${s._num}. ${s.name}` }));
});

const stepHeaders = [
    { title: "#", key: "order_number" },
    { title: "Code", key: "code" },
    { title: "Name", key: "name" },
    { title: "Stage", key: "stage" },
    { title: "SLA (min)", key: "sla_minutes" },
    { title: "Flags", key: "flags", sortable: false },
    { title: "", key: "actions", sortable: false },
];

const routeHeaders = [
    { title: "From", key: "from_step_id" },
    { title: "To", key: "to_step_id" },
    { title: "Action", key: "action_code" },
    { title: "Return", key: "is_return_route" },
    { title: "Group", key: "route_group" },
    { title: "Req Approvals", key: "required_approvals_count" },
    { title: "Condition", key: "condition_expression", sortable: false },
    { title: "", key: "actions", sortable: false },
];

function pretty(obj) {
    if (!obj) return "";
    try {
        return JSON.stringify(obj);
    } catch {
        return String(obj);
    }
}

watch(selectedTypeId, async (id) => {
    // Clear first so the previous type's tables never linger while the new
    // type loads (the skeleton state keeps the container size stable).
    activeDef.value = null;
    stepPage.value = 1;
    routePage.value = 1;
    if (!id) {
        return;
    }
    error.value = "";
    try {
        await fetchDefinitions(id);
        selectEffective();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load processes.";
        activeDef.value = null;
    }
});

// Latest = live. Effective editor target: the open draft if any,
// otherwise the latest published. Everything older is history.
const draftDef = computed(() => (defs.value || []).find((d) => d.status === "draft") || null);

const publishedDefs = computed(() =>
    (defs.value || []).filter((d) => d.status === "published"),
);

const currentDef = computed(() => publishedDefs.value[0] || null);

function isLiveDef(def) {
    return !!def && def.status === "published" && currentDef.value && Number(currentDef.value.id) === Number(def.id);
}

const historyDefs = computed(() =>
    (defs.value || []).filter((d) => !activeDef.value || Number(d.id) !== Number(activeDef.value.id)),
);

function selectEffective() {
    activeDef.value = draftDef.value || currentDef.value || defs.value[0] || null;
}

// Save-button flow: every edit ensures a draft, applies, then goes
// live — invisibly. Admins see one list + Save; versioning, pins and
// guards keep working backstage. Running papers stay on their version.
async function ensureDraft() {
    if (!draftDef.value) {
        await createDraft({
            transaction_type_id: selectedTypeId.value,
            clone_latest_published: true,
        });
        await fetchDefinitions(selectedTypeId.value);
    }
    selectEffective();
    return activeDef.value;
}

// Publish the working draft. A flow missing start/end stays a draft
// with a plain message instead of an error (mid-construction state).
async function goLive() {
    await fetchDefinitions(selectedTypeId.value);
    selectEffective();
    try {
        await publish(activeDef.value.id, {});
        await fetchDefinitions(selectedTypeId.value);
        selectEffective();
        notice.value = "Saved — live for new transactions.";
    } catch (e) {
        const msg = e?.response?.data?.message || "";
        if (e?.response?.status === 422 && /start step|end step/i.test(msg)) {
            notice.value = "Saved as draft — add a start and an end step to go live.";
        } else {
            throw e;
        }
    }
}

// Add Step: reuse the open draft (one-draft-max, enforced server-side
// too); create one only if none exists. Then open the step form.
async function clickAddStep() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await ensureDraft();
        openStepDialog();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function clickAddRoute() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await ensureDraft();
        openRouteDialog();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

function stepInDraft(oldSteps, item) {
    // Clones preserve codes (unique per flow): map the viewed step to
    // its draft twin so edits always land on the draft.
    const code = (oldSteps || []).find((s) => Number(s.id) === Number(item?.id))?.code || item?.code;
    return (
        (activeDef.value?.steps || []).find((s) => code && s.code === code) || item
    );
}

async function editStep(item) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        openStepDialog(stepInDraft(oldSteps, item));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function goStepFields(item) {
    error.value = "";
    notice.value = "";
    try {
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        const fresh = stepInDraft(oldSteps, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${activeDef.value.id}/steps/${fresh.id}/fields`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step fields.";
    }
}

function liveEditableTarget() {
    // Requirements/checklist apply to running papers immediately, so
    // open them on the published process — not an open draft clone.
    return currentDef.value || activeDef.value;
}

function stepOnDef(def, item) {
    return (def?.steps || []).find((s) => s.code && s.code === item?.code) || item;
}

async function goStepRequirements(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${target.id}/steps/${fresh.id}/requirements`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step requirements.";
    }
}

async function goStepChecklist(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${target.id}/steps/${fresh.id}/checklist`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step checklist.";
    }
}

function routeInDraft(oldSteps, route) {
    // Routes have no codes: match by endpoint step codes + action.
    const oldCode = (id) => (oldSteps || []).find((s) => Number(s.id) === Number(id))?.code;
    const newCode = (id) => (activeDef.value?.steps || []).find((s) => Number(s.id) === Number(id))?.code;
    const from = oldCode(route?.from_step_id);
    const to = oldCode(route?.to_step_id);
    return (
        (activeDef.value?.routes || []).find(
            (r) =>
                newCode(r.from_step_id) === from &&
                newCode(r.to_step_id) === to &&
                r.action_code === route?.action_code,
        ) || route
    );
}

async function editRoute(route) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        openRouteDialog(routeInDraft(oldSteps, route));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

function viewDef(def) {
    activeDef.value = def;
}

// Steps
const stepDialog = ref(false);
const stepForm = ref({});

function openStepDialog(step = null) {
    error.value = "";
    if (step) {
        stepForm.value = {
            id: step.id,
            order_number: step.order_number,
            parent_id: step.parent_id ?? null,
            name: step.name,
            stage: step.stage ?? "",
            sla_minutes: step.sla_minutes ?? 0,
            is_start: !!step.is_start,
            is_end: !!step.is_end,
            role_ids: step.role_ids ?? [],
        };
    } else {
        const topLevel = (activeDef.value.steps || []).filter((s) => !s.parent_id);
        stepForm.value = {
            id: null,
            order_number: (topLevel.length || 0) + 1,
            parent_id: null,
            name: "",
            stage: "",
            sla_minutes: 0,
            is_start: false,
            is_end: false,
            role_ids: [],
        };
    }
    stepDialog.value = true;
}

async function saveStep() {
    saving.value = true;
    error.value = "";
    notice.value = "";
    try {
        const payload = {
            parent_id: stepForm.value.parent_id ?? null,
            order_number: Number(stepForm.value.order_number),
            name: stepForm.value.name,
            stage: stepForm.value.stage || null,
            sla_minutes: Number(stepForm.value.sla_minutes || 0),
            is_start: !!stepForm.value.is_start,
            is_end: !!stepForm.value.is_end,
            role_ids: stepForm.value.role_ids || [],
        };

        if (stepForm.value.id)
            await updateStep(activeDef.value.id, stepForm.value.id, payload);
        else await addStep(activeDef.value.id, payload);

        stepDialog.value = false;
        await goLive();
    } catch (e) {
        error.value = e?.response?.data?.message || "Save step failed.";
    } finally {
        saving.value = false;
    }
}

async function deleteStep(step) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await ensureDraft();
        const target =
            (activeDef.value?.steps || []).find((s) => step?.code && s.code === step.code) || step;
        await apiDeleteStep(activeDef.value.id, target.id);
        await goLive();
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete step failed.";
    } finally {
        saving.value = false;
    }
}

// Routes
const routeDialog = ref(false);
const routeForm = ref({});

function openRouteDialog(route = null) {
    error.value = "";
    if (route) {
        routeForm.value = {
            id: route.id,
            from_step_id: route.from_step_id,
            to_step_id: route.to_step_id,
            action_code: route.action_code,
            is_return_route: !!route.is_return_route,
            route_group: route.route_group ?? "",
            required_approvals_count: route.required_approvals_count ?? "",
            condition_expression_json: route.condition_expression
                ? JSON.stringify(route.condition_expression, null, 2)
                : "",
        };
    } else {
        routeForm.value = {
            id: null,
            from_step_id: null,
            to_step_id: null,
            action_code: "submit",
            is_return_route: false,
            route_group: "",
            required_approvals_count: "",
            condition_expression_json: "",
        };
    }
    routeDialog.value = true;
}

async function saveRoute() {
    saving.value = true;
    error.value = "";
    notice.value = "";
    try {
        let cond = null;
        if (routeForm.value.condition_expression_json?.trim()) {
            cond = JSON.parse(routeForm.value.condition_expression_json);
        }

        const payload = {
            from_step_id: Number(routeForm.value.from_step_id),
            to_step_id: Number(routeForm.value.to_step_id),
            action_code: routeForm.value.action_code,
            is_return_route: !!routeForm.value.is_return_route,
            route_group: routeForm.value.route_group || null,
            required_approvals_count: routeForm.value.required_approvals_count
                ? Number(routeForm.value.required_approvals_count)
                : null,
            condition_expression: cond,
        };

        if (routeForm.value.id)
            await updateRoute(activeDef.value.id, routeForm.value.id, payload);
        else await addRoute(activeDef.value.id, payload);

        routeDialog.value = false;
        await goLive();
    } catch (e) {
        error.value =
            e?.response?.data?.message || e?.message || "Save route failed.";
    } finally {
        saving.value = false;
    }
}

async function deleteRoute(route) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        const oldSteps = activeDef.value?.steps || [];
        const oldRoutes = activeDef.value?.routes || [];
        await ensureDraft();
        const from = oldSteps.find((s) => Number(s.id) === Number(route?.from_step_id))?.code;
        const to = oldSteps.find((s) => Number(s.id) === Number(route?.to_step_id))?.code;
        const newCode = (id) => (activeDef.value?.steps || []).find((s) => Number(s.id) === Number(id))?.code;
        const target =
            (activeDef.value?.routes || []).find(
                (r) =>
                    newCode(r.from_step_id) === from &&
                    newCode(r.to_step_id) === to &&
                    r.action_code === route?.action_code,
            ) ||
            oldRoutes.find((r) => Number(r.id) === Number(route?.id)) ||
            route;
        await apiDeleteRoute(activeDef.value.id, target.id);
        await goLive();
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete route failed.";
    }
}

function applyTypeFromQuery() {
    const deepType = Number(route.query.type);
    if (deepType && (types.value || []).some((t) => Number(t.id) === deepType)) {
        if (Number(selectedTypeId.value) !== deepType) selectedTypeId.value = deepType;
    } else {
        // Isolated per-type viewing: no type in the URL means nothing
        // selected. Reach this page via Transaction Types → Steps.
        selectedTypeId.value = null;
        loading.value = false;
    }
}

watch(
    () => route.query.type,
    () => applyTypeFromQuery(),
);

onMounted(async () => {
    await fetchTypes();
    await fetchRoles();
    applyTypeFromQuery();
});
</script>

<style scoped>
.skel-fill td {
    height: 38px;
    background: #fff;
}
</style>
