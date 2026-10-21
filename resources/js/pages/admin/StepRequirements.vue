<template>
    <div>
        <LoadingVeil :show="loading || !ready" label="step requirements" icon="mdi-clipboard-list-outline" />
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
                    </div>
                </div>
            </v-card-text>
        </v-card>

        <v-dialog
            v-model="addDialog"
            max-width="540"
            content-class="req-dialog-content"
            @after-enter="focusAddName"
        >
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar color="primary" variant="tonal" rounded="lg" size="44" class="req-badge">
                        <v-icon>mdi-clipboard-check-outline</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Add requirement</div>
                        <div class="req-sub">Add a checklist item that workers must complete for this step.</div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="req-x"
                        aria-label="Close add requirement dialog"
                        @click="addDialog = false"
                    />
                </v-card-title>

                <form class="req-form" novalidate @submit.prevent="addRequirement">
                    <v-card-text class="req-bd">
                        <v-alert v-if="addError" type="error" variant="tonal" density="compact" class="mb-4">
                            {{ addError }}
                        </v-alert>

                        <div class="req-f">
                            <label class="req-lb" for="req-name">Name <span class="req-required">*</span></label>
                            <v-text-field
                                id="req-name"
                                ref="addNameField"
                                v-model="addForm.name"
                                placeholder="e.g. Signed PR (PDF)"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                :error="!!addFieldErrors.name"
                                class="req-in"
                                @update:model-value="onAddNameInput"
                            />
                            <div v-if="addFieldErrors.name" class="req-error">{{ addFieldErrors.name }}</div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-code">Code</label>
                            <v-text-field
                                id="req-code"
                                ref="addCodeField"
                                v-model="addForm.code"
                                placeholder="signed_pr_pdf"
                                maxlength="64"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                spellcheck="false"
                                :error="!!addFieldErrors.code"
                                class="req-in req-in-mono"
                                @update:model-value="onAddCodeInput"
                            />
                            <div v-if="addFieldErrors.code" class="req-error">{{ addFieldErrors.code }}</div>
                            <div v-else class="req-help">System code. Auto-generated from the name, or type your own.</div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-remarks">
                                Remarks
                                <span class="req-opt">(instructions for workers)</span>
                            </label>
                            <v-textarea
                                id="req-remarks"
                                v-model="addForm.description"
                                placeholder="Tell workers what to check or attach"
                                rows="3"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                class="req-in req-in-area"
                            />
                        </div>

                        <section class="req-sec">
                            <div class="req-sec-t">Rules</div>

                            <div class="req-rule">
                                <span class="req-rule-ic">
                                    <v-icon size="20">mdi-checkbox-marked-outline</v-icon>
                                </span>
                                <div class="req-rule-copy">
                                    <b>Required item</b>
                                    <span>
                                        {{
                                            addForm.is_required
                                                ? "Must be completed before the step can proceed"
                                                : "Workers can skip this item"
                                        }}
                                    </span>
                                </div>
                                <button
                                    class="req-tg"
                                    type="button"
                                    role="switch"
                                    :aria-checked="addForm.is_required ? 'true' : 'false'"
                                    aria-label="Required item"
                                    @click="addForm.is_required = !addForm.is_required"
                                ></button>
                            </div>

                            <div class="req-rule">
                                <span class="req-rule-ic">
                                    <v-icon size="20">mdi-paperclip</v-icon>
                                </span>
                                <div class="req-rule-copy">
                                    <b>Upload required</b>
                                    <span>
                                        {{
                                            addForm.is_upload_required
                                                ? "Workers must attach a file"
                                                : "No file needed"
                                        }}
                                    </span>
                                </div>
                                <button
                                    class="req-tg"
                                    type="button"
                                    role="switch"
                                    :aria-checked="addForm.is_upload_required ? 'true' : 'false'"
                                    aria-label="Upload required"
                                    @click="addForm.is_upload_required = !addForm.is_upload_required"
                                ></button>
                            </div>
                        </section>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="req-ft">
                        <v-btn type="button" variant="outlined" rounded="lg" class="req-b" @click="addDialog = false">
                            Cancel
                        </v-btn>
                        <v-btn
                            color="primary"
                            rounded="lg"
                            class="req-b req-b-pri"
                            type="submit"
                            :loading="adding"
                        >
                            Add requirement
                        </v-btn>
                    </v-card-actions>
                </form>
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
import { useToast } from "@/composables/useToast";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import LoadingVeil from '@/components/LoadingVeil.vue';
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
const { success: toastSuccess } = useToast();

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
// First-load gate: rows only map after a fetch settles, so keep the veil up
// until then (loading alone clears on warm cache before rows exist).
const ready = ref(false);

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
const addFieldErrors = ref({ name: "", code: "" });
const addNameField = ref(null);
const addCodeField = ref(null);
// Once the user edits Code themselves, stop regenerating it from Name.
const codeTouched = ref(false);

function snakeCase(value) {
    return String(value || "")
        .toLowerCase()
        .trim()
        .replace(/[^a-z0-9]+/g, "_")
        .replace(/^_+|_+$/g, "");
}

function nextRequirementCode(base) {
    const taken = new Set(
        (requirements.value || [])
            .map((r) => String(r.code || "").toLowerCase())
            .filter(Boolean),
    );
    const bucket = typeId.value ? staging.buckets.get(String(typeId.value)) : null;
    for (const def of bucket?.reqDefs || []) {
        if (def.code) taken.add(String(def.code).toLowerCase());
    }

    let code = base;
    let suffix = 2;
    while (taken.has(code)) code = `${base}_${suffix++}`;
    return code;
}

function onAddNameInput(value) {
    if (!codeTouched.value) {
        const base = snakeCase(value).slice(0, 50);
        addForm.value.code = base ? nextRequirementCode(base) : "";
        addFieldErrors.value.code = "";
    }
    if (addFieldErrors.value.name) addFieldErrors.value.name = "";
}

function onAddCodeInput(value) {
    codeTouched.value = !!String(value || "").trim();
    if (addFieldErrors.value.code) addFieldErrors.value.code = "";
}

function focusAddName() {
    addNameField.value?.focus();
}

function validateAddForm() {
    const name = addForm.value.name?.trim() || "";
    const code = addForm.value.code?.trim() || "";
    const errors = { name: "", code: "" };

    if (!name) errors.name = "Enter a requirement name.";
    if (code && !/^[a-z][a-z0-9_]*$/.test(code)) {
        errors.code = "Use snake_case, starting with a letter (for example signed_pr_pdf).";
    }

    addFieldErrors.value = errors;
    if (errors.name) {
        addNameField.value?.focus();
        return false;
    }
    if (errors.code) {
        addCodeField.value?.focus();
        return false;
    }
    return true;
}

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        label: `${s.order_number}. ${s.name} (${s.code})`,
    })),
);

function openAdd() {
    addError.value = "";
    addFieldErrors.value = { name: "", code: "" };
    codeTouched.value = false;
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
        name: r.name ?? "",
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
    if (adding.value) return;
    if (!validateAddForm()) return;
    if (!typeId.value) {
        addError.value = "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    adding.value = true;
    addError.value = "";
    try {
        // Staged requirement definition (server mints id + code on save).
        const { row: created } = staging.upsertReqDef(typeId.value, {
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
        toastSuccess(`Requirement "${created.name}" added to this step.`);
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
    if (!selectedStepId.value) {
        ready.value = true;
        return;
    }
    ready.value = false;
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
    } finally {
        ready.value = true;
    }
}

async function afterBulkSaved() {
    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await fetchReqs(workflowDefinitionId.value);
    await loadAssigned();
}

watch(selectedStepId, async () => {
    assigned.value = [];
    assignmentRows.value = [];
    if (!selectedStepId.value) return;
    await loadAssigned();
});

onMounted(async () => {
    // Requirement catalog and step list are independent: fetch in parallel.
    await Promise.allSettled([fetchReqs(workflowDefinitionId.value), loadSteps()]);

    const sid = stepIdFromUrl.value;
    if (sid && !Number.isNaN(sid)) {
        selectedStepId.value = sid;
        await loadAssigned();
    } else {
        ready.value = true; // nothing to load: show the picker UI, no veil
    }
});
</script>

<style scoped>
/* ---- Add requirement modal (design mockup port) ---- */
.req-card {
    display: flex;
    flex-direction: column;
    max-height: 90vh;
    overflow: hidden;
}

.req-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 14px;
}

.req-badge {
    flex: none;
}

.req-hd-t {
    min-width: 0;
}

.req-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}

.req-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}

.req-x {
    margin-left: auto;
    flex: none;
}

.req-form {
    display: flex;
    flex: 1 1 auto;
    flex-direction: column;
    min-height: 0;
}

.req-bd {
    flex: 1 1 auto;
    min-height: 0;
    padding: 4px 24px 10px;
    overflow-y: auto;
}

.req-f {
    margin-bottom: 18px;
}

.req-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}

.req-required {
    color: rgb(var(--v-theme-error));
}

.req-opt {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}

.req-help {
    margin: 6px 2px 0;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

.req-error {
    margin: 6px 2px 0;
    font-size: 12.5px;
    font-weight: 600;
    color: rgb(var(--v-theme-error));
}

.req-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}

.req-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}

.req-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(22, 48, 124, 0.18);
}

.req-in :deep(.v-field--error) {
    background: rgb(var(--v-theme-surface));
}

.req-in-area :deep(.v-field) {
    min-height: 96px;
}

.req-in-area :deep(textarea) {
    padding-top: 12px;
    line-height: 1.45;
}

.req-in-mono :deep(input) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14.5px;
}

.req-sec {
    margin: 0;
}

.req-sec-t {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 0 0 12px;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}

.req-sec-t::after {
    content: "";
    flex: 1;
    height: 1px;
    background: rgba(var(--v-border-color), var(--v-border-opacity));
}

.req-rule {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 10px;
    padding: 12px 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}

.req-rule-ic {
    display: grid;
    flex: none;
    width: 38px;
    height: 38px;
    border-radius: 10px;
    color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.12);
    place-items: center;
}

.req-rule-copy {
    min-width: 0;
}

.req-rule-copy b {
    display: block;
    font-size: 14.5px;
}

.req-rule-copy span {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

.req-tg {
    position: relative;
    flex: none;
    width: 48px;
    height: 28px;
    margin-left: auto;
    padding: 0;
    border: 0;
    border-radius: 99px;
    background: #98a2b8;
    cursor: pointer;
    transition: background 0.2s;
}

.req-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
    content: "";
    transition: transform 0.2s;
}

.req-tg[aria-checked="true"] {
    background: #1b7a3d;
}

.req-tg[aria-checked="true"]::after {
    transform: translateX(20px);
}

.req-tg:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.req-ft {
    flex: none;
    gap: 10px;
    padding: 16px 24px max(20px, env(safe-area-inset-bottom, 0px));
}

.req-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}

.req-b-pri {
    min-width: 150px;
}

html.dark .req-in :deep(.v-field) {
    background: #232b45;
}

html.dark .req-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}

html.dark .req-rule-ic {
    background: rgba(147, 197, 253, 0.14);
    color: #93c5fd;
}

html.dark .req-tg[aria-checked="true"] {
    background: #3fbf6f;
}

@media (max-width: 520px) {
    :global(.req-dialog-content) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }

    :global(.req-dialog-content .req-card) {
        max-height: 94vh;
        border-radius: 24px 24px 0 0 !important;
    }

    .req-ft {
        flex-direction: column-reverse;
    }

    .req-b {
        width: 100%;
    }
}
</style>
