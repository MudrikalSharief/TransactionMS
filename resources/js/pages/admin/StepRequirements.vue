<template>
    <div class="sr-page">
        <v-alert
            v-if="error"
            type="error"
            variant="tonal"
            density="compact"
            class="mb-4"
        >
            {{ error }}
        </v-alert>

        <WorkflowPageHeader
            icon="mdi-clipboard-check-outline"
            title="Requirements"
            subtitle="Choose a step and manage what workers must complete or upload."
            :version="defVersion"
            :status="defStatus"
            :is-live="defIsLive"
            :dirty="stagingDirty"
            :save-disabled="!stagingDirty"
            @back="goBack"
            @discard="discardStaged"
            @save="openSaveDialog"
        />

        <div class="sr-info">
            <v-icon size="20" class="sr-info-ic"
                >mdi-information-outline</v-icon
            >
            <span>
                <b>Staged assignment.</b>
                Edits stay local until you press Save version.
            </span>
        </div>

        <StagingSaveBar
            ref="saveBarRef"
            :type-id="typeId"
            :def-id="workflowDefinitionId"
            :inline-actions="false"
            @saved="afterBulkSaved"
            @discarded="loadAssigned"
        />

        <p class="sr-lbl">Select step</p>

        <div ref="stepMenuRef" class="sr-dd" @focusout="onStepMenuFocusOut">
            <button
                ref="stepTrigger"
                type="button"
                class="sr-trigger"
                :class="{ 'sr-trigger-open': stepMenuOpen }"
                :disabled="stepsLoading || !stepOptions.length"
                aria-haspopup="listbox"
                aria-controls="sr-step-menu"
                :aria-expanded="stepMenuOpen ? 'true' : 'false'"
                @click="toggleStepMenu"
                @keydown="onTriggerKeydown"
            >
                <span class="sr-sr-only">Select step</span>
                <span class="sr-step-n">{{
                    selectedStep?.order_number ?? "-"
                }}</span>
                <span class="sr-step-tx">
                    <b>{{
                        selectedStep?.name ||
                        (stepsLoading ? "Loading steps…" : "Select a step")
                    }}</b>
                    <small>{{
                        selectedStep?.code || "No step selected"
                    }}</small>
                </span>
                <span v-if="selectedStep" class="sr-count">
                    {{ countLabel(stepRequirementCount(selectedStep.id)) }}
                </span>
                <v-icon
                    class="sr-chev"
                    :class="{ 'sr-chev-open': stepMenuOpen }"
                    size="20"
                >
                    mdi-chevron-down
                </v-icon>
            </button>

            <div
                v-if="stepMenuOpen"
                id="sr-step-menu"
                class="sr-menu"
                role="listbox"
                aria-label="Steps"
            >
                <button
                    v-for="(option, index) in stepOptions"
                    :key="option.id"
                    :ref="(el) => setStepOptionEl(el, index)"
                    type="button"
                    class="sr-option"
                    :class="{ 'sr-option-selected': isSelectedStep(option.id) }"
                    role="option"
                    :aria-selected="
                        isSelectedStep(option.id) ? 'true' : 'false'
                    "
                    @click="selectStep(option.id)"
                    @keydown="onStepOptionKeydown($event, index)"
                >
                    <span class="sr-option-n">{{ option.order_number }}</span>
                    <span class="sr-option-tx">
                        <b>{{ option.name }}</b>
                        <small>{{ option.code }}</small>
                    </span>
                    <span class="sr-count">{{ countLabel(option.count) }}</span>
                    <v-icon
                        class="sr-option-ck"
                        :class="{
                            'sr-option-ck-on': isSelectedStep(option.id),
                        }"
                        size="20"
                        aria-hidden="true"
                    >
                        mdi-check
                    </v-icon>
                </button>
                <div v-if="!stepOptions.length" class="sr-option-empty">
                    No steps available.
                </div>
            </div>
        </div>

        <section class="sr-card" aria-live="polite">
            <div class="sr-card-hd">
                <div>
                    <h2>Requirements for this step</h2>
                    <p>{{ cardSubtitle }}</p>
                </div>
                <button
                    type="button"
                    class="sr-add"
                    :disabled="!selectedStepId || showLoader"
                    @click="openAdd"
                >
                    <v-icon size="18">mdi-plus</v-icon>
                    <span>Add requirement</span>
                </button>
            </div>

            <div v-if="showLoader" class="sr-loading">
                <TableLoader
                    compact
                    label="step requirements"
                    icon="mdi-clipboard-list-outline"
                />
            </div>

            <div v-else class="sr-rows" role="table" aria-label="Requirements">
                <div class="sr-row sr-row-head" role="row">
                    <div role="columnheader">Name</div>
                    <div role="columnheader">Code</div>
                    <div role="columnheader">Required</div>
                    <div role="columnheader">Upload required</div>
                    <div role="columnheader"></div>
                </div>

                <div
                    v-for="item in assignmentRows"
                    :key="String(item.requirement_definition_id)"
                    class="sr-row sr-row-item"
                    role="row"
                >
                    <div class="sr-name" role="cell">
                        <b>{{ item.name }}</b>
                        <span v-if="item.description">{{
                            item.description
                        }}</span>
                    </div>

                    <div class="sr-code-cell" role="cell">
                        <input
                            v-if="
                                typeof item.requirement_definition_id !==
                                'number'
                            "
                            v-model="item.code"
                            type="text"
                            class="sr-code-in"
                            placeholder="e.g. dtr, pr, voucher"
                            maxlength="64"
                            autocomplete="off"
                            spellcheck="false"
                            :aria-label="`Code for ${item.name}`"
                            @update:model-value="stageBindings"
                        />
                        <code v-else class="sr-code">{{
                            item.code || "—"
                        }}</code>
                    </div>

                    <div class="sr-req sr-req-r" role="cell">
                        <button
                            type="button"
                            class="sr-tg"
                            role="switch"
                            :aria-checked="item.is_required ? 'true' : 'false'"
                            :aria-label="`Toggle required for ${item.name}`"
                            @click="toggleRequired(item)"
                        ></button>
                        <span :class="{ 'sr-on': item.is_required }">
                            {{ item.is_required ? "Required" : "Optional" }}
                        </span>
                    </div>

                    <div class="sr-req sr-req-u" role="cell">
                        <button
                            type="button"
                            class="sr-tg"
                            role="switch"
                            :aria-checked="
                                item.is_upload_required ? 'true' : 'false'
                            "
                            :aria-label="`Toggle upload required for ${item.name}`"
                            @click="toggleUploadRequired(item)"
                        ></button>
                        <span :class="{ 'sr-on': item.is_upload_required }">
                            {{
                                item.is_upload_required
                                    ? "File required"
                                    : "No file"
                            }}
                        </span>
                    </div>

                    <div class="sr-actions" role="cell">
                        <button
                            type="button"
                            class="sr-ib sr-ib-edit"
                            :aria-label="`Edit ${item.name}`"
                            @click="openEdit(item)"
                        >
                            <v-icon size="18">mdi-pencil</v-icon>
                        </button>
                        <button
                            type="button"
                            class="sr-ib sr-ib-delete"
                            :aria-label="`Remove ${item.name} from this step`"
                            @click="removeRow(item)"
                        >
                            <v-icon size="18">mdi-delete</v-icon>
                        </button>
                    </div>
                </div>

                <template v-if="!assignmentRows.length">
                    <div
                        v-for="n in 2"
                        :key="`empty-ghost-top-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>

                    <div class="sr-row sr-row-noitem" role="row">
                        <div
                            class="sr-noitem-cell"
                            role="cell"
                            aria-colspan="5"
                        >
                            <div class="sr-noitem-copy">
                                <b>{{ noItemTitle }}</b>
                                <span>{{ noItemText }}</span>
                            </div>
                            <button
                                v-if="noItemAction === 'add'"
                                type="button"
                                class="sr-add"
                                @click="openAdd"
                            >
                                <v-icon size="18">mdi-plus</v-icon>
                                <span>Add requirement</span>
                            </button>
                            <button
                                v-else-if="noItemAction === 'items'"
                                type="button"
                                class="sr-add"
                                @click="loadAssigned"
                            >
                                <v-icon size="18">mdi-refresh</v-icon>
                                <span>Try again</span>
                            </button>
                            <button
                                v-else-if="noItemAction === 'steps'"
                                type="button"
                                class="sr-add"
                                @click="retrySteps"
                            >
                                <v-icon size="18">mdi-refresh</v-icon>
                                <span>Try again</span>
                            </button>
                        </div>
                    </div>

                    <div
                        v-for="n in 2"
                        :key="`empty-ghost-bottom-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                </template>

                <template v-else>
                    <div
                        v-for="n in ghostRowCount"
                        :key="`ghost-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                </template>
            </div>
        </section>

        <v-dialog
            v-model="addDialog"
            max-width="540"
            content-class="req-dialog-content"
            @after-enter="focusAddName"
        >
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="req-badge"
                    >
                        <v-icon>mdi-clipboard-check-outline</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Add requirement</div>
                        <div class="req-sub">
                            Add a checklist item that workers must complete for
                            this step.
                        </div>
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

                <form
                    class="req-form"
                    novalidate
                    @submit.prevent="addRequirement"
                >
                    <v-card-text class="req-bd">
                        <v-alert
                            v-if="addError"
                            type="error"
                            variant="tonal"
                            density="compact"
                            class="mb-4"
                        >
                            {{ addError }}
                        </v-alert>

                        <div class="req-f">
                            <label class="req-lb" for="req-name"
                                >Name <span class="req-required">*</span></label
                            >
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
                            <div v-if="addFieldErrors.name" class="req-error">
                                {{ addFieldErrors.name }}
                            </div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-code"
                                >Code <span class="req-required">*</span></label
                            >
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
                            <div v-if="addFieldErrors.code" class="req-error">
                                {{ addFieldErrors.code }}
                            </div>
                            <div v-else class="req-help">
                                Type the system code manually in snake_case.
                            </div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-remarks">
                                Remarks
                                <span class="req-opt"
                                    >(instructions for workers)</span
                                >
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
                                    <v-icon size="20"
                                        >mdi-checkbox-marked-outline</v-icon
                                    >
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
                                    :aria-checked="
                                        addForm.is_required ? 'true' : 'false'
                                    "
                                    aria-label="Required item"
                                    @click="
                                        addForm.is_required =
                                            !addForm.is_required
                                    "
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
                                    :aria-checked="
                                        addForm.is_upload_required
                                            ? 'true'
                                            : 'false'
                                    "
                                    aria-label="Upload required"
                                    @click="
                                        addForm.is_upload_required =
                                            !addForm.is_upload_required
                                    "
                                ></button>
                            </div>
                        </section>

                        <section class="req-sec req-sec-preview">
                            <div class="req-sec-t">Preview</div>
                            <div class="req-preview">
                                <span class="req-preview-ck"></span>
                                <div class="req-preview-body">
                                    <div class="req-preview-name">
                                        <span>{{
                                            addForm.name?.trim() ||
                                            "Requirement name"
                                        }}</span>
                                        <span
                                            class="req-tag"
                                            :class="{
                                                'req-tag-optional':
                                                    !addForm.is_required,
                                            }"
                                        >
                                            {{
                                                addForm.is_required
                                                    ? "Required"
                                                    : "Optional"
                                            }}
                                        </span>
                                    </div>
                                    <p
                                        v-if="addForm.description?.trim()"
                                        class="req-preview-remark"
                                    >
                                        {{ addForm.description.trim() }}
                                    </p>
                                    <span
                                        v-if="addForm.is_upload_required"
                                        class="req-preview-attach"
                                    >
                                        <v-icon size="16">mdi-upload</v-icon>
                                        Attach file
                                    </span>
                                </div>
                            </div>
                        </section>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="req-ft">
                        <v-btn
                            type="button"
                            variant="outlined"
                            rounded="lg"
                            class="req-b"
                            @click="addDialog = false"
                        >
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

        <v-dialog
            v-model="editDialog"
            max-width="480"
            content-class="req-dialog-content"
            @after-enter="focusEditName"
        >
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="req-badge"
                    >
                        <v-icon>mdi-pencil-outline</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Edit requirement</div>
                        <div class="req-sub">
                            Change the requirement name. Its code and rules stay
                            unchanged.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="req-x"
                        aria-label="Close edit requirement dialog"
                        @click="editDialog = false"
                    />
                </v-card-title>

                <form class="req-form" novalidate @submit.prevent="saveEdit">
                    <v-card-text class="req-bd">
                        <v-alert
                            v-if="editError"
                            type="error"
                            variant="tonal"
                            density="compact"
                            class="mb-4"
                        >
                            {{ editError }}
                        </v-alert>

                        <div class="req-f">
                            <label class="req-lb" for="req-edit-name"
                                >Name <span class="req-required">*</span></label
                            >
                            <v-text-field
                                id="req-edit-name"
                                ref="editNameField"
                                v-model="editForm.name"
                                placeholder="e.g. Signed PR (PDF)"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                :error="!!editNameError"
                                class="req-in"
                                @update:model-value="editNameError = ''"
                            />
                            <div v-if="editNameError" class="req-error">
                                {{ editNameError }}
                            </div>
                        </div>

                        <div class="req-code-ro">
                            <span>Code</span>
                            <code>{{ editCode || "—" }}</code>
                        </div>
                        <div class="req-help">
                            The system code and requirement rules are not
                            changed here.
                        </div>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="req-ft">
                        <v-btn
                            type="button"
                            variant="outlined"
                            rounded="lg"
                            class="req-b"
                            @click="editDialog = false"
                        >
                            Cancel
                        </v-btn>
                        <v-btn
                            color="primary"
                            rounded="lg"
                            class="req-b req-b-pri"
                            type="submit"
                            :loading="editSaving"
                        >
                            Save name
                        </v-btn>
                    </v-card-actions>
                </form>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import {
    computed,
    nextTick,
    onBeforeUnmount,
    onMounted,
    ref,
    watch,
} from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useStepRequirements } from "@/composables/useStepRequirements";
import { useToast } from "@/composables/useToast";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import StagingSaveBar from "@/components/StagingSaveBar.vue";
import TableLoader from "@/components/TableLoader.vue";
import WorkflowPageHeader from "@/components/WorkflowPageHeader.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const returnTypeId = ref(null);
const defVersion = ref(null);
const defStatus = ref("");
const defIsLive = ref(false);

function goBack() {
    const qType = Number(route.query.type);
    const target =
        Number.isFinite(qType) && qType > 0
            ? qType
            : Number(returnTypeId.value);
    if (target > 0)
        router.push({ path: "/admin/workflows", query: { type: target } });
    else router.push("/admin/workflows");
}

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const { items: requirements, fetchAll: fetchReqs } =
    useRequirementDefinitions();
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

const saveBarRef = ref(null);
const stagingDirty = computed(() =>
    typeId.value ? staging.isDirty(typeId.value) : false,
);

function openSaveDialog() {
    saveBarRef.value?.openSaveDialog?.();
}

function discardStaged() {
    saveBarRef.value?.discard?.();
}

const steps = ref([]);
const stepsLoading = ref(false);
const selectedStepId = ref(null);

// Working rows for the current step: pivots joined with definitions.
const assignmentRows = ref([]);
// First-load gate: rows only map after a fetch settles, so keep the veil up
// until then (loading alone clears on warm cache before rows exist).
const ready = ref(false);

const stepMenuOpen = ref(false);
const stepMenuRef = ref(null);
const stepTrigger = ref(null);
const stepOptionEls = ref([]);

const selectedStep = computed(
    () =>
        steps.value.find(
            (step) => Number(step.id) === Number(selectedStepId.value),
        ) || null,
);

const showLoader = computed(
    () =>
        stepsLoading.value ||
        !ready.value ||
        (!!selectedStepId.value && loading.value),
);

function stepRequirementCount(id) {
    if (
        Number(id) === Number(selectedStepId.value) &&
        ready.value &&
        !loading.value
    ) {
        return assignmentRows.value.length;
    }
    const bucket = typeId.value
        ? staging.buckets.get(String(typeId.value))
        : null;
    const staged = bucket?.bindings?.[String(id)];
    if (staged) return staged.length;
    const step = steps.value.find((row) => Number(row.id) === Number(id));
    return Math.max(0, Number(step?.step_requirements_count ?? 0));
}

const stepOptions = computed(() =>
    steps.value.map((step) => ({
        id: step.id,
        order_number: step.order_number,
        name: step.name,
        code: step.code,
        count: stepRequirementCount(step.id),
    })),
);

function countLabel(count) {
    return `${count} ${count === 1 ? "requirement" : "requirements"}`;
}

const cardSubtitle = computed(() => {
    if (stepsLoading.value) return "Loading steps…";
    if (!steps.value.length) return "No steps available.";
    if (!selectedStepId.value)
        return "Select a step to manage its requirements.";
    if (loading.value) return "Loading requirements…";
    if (error.value) return "Couldn't load requirements.";
    const count = assignmentRows.value.length;
    if (!count) return "Nothing added yet";
    return `${countLabel(count)} for “${selectedStep.value?.name || "this step"}”`;
});

const noItemTitle = computed(() => {
    if (error.value && !selectedStepId.value) return "Couldn't load steps";
    if (!selectedStepId.value)
        return steps.value.length ? "Select a step" : "No steps available";
    if (error.value) return "Couldn't load requirements";
    return "No requirements yet";
});

const noItemText = computed(() => {
    if (error.value && !selectedStepId.value)
        return "Check the error above, then try again.";
    if (!selectedStepId.value) {
        return steps.value.length
            ? "Choose a step above to manage its requirements."
            : "This workflow doesn't have any steps yet.";
    }
    if (error.value) return "Check the error above, then try again.";
    return "Add a requirement that workers must complete for this step.";
});

const noItemAction = computed(() => {
    if (error.value) return selectedStepId.value ? "items" : "steps";
    if (!selectedStepId.value) return null;
    return "add";
});

const ghostRowCount = computed(() =>
    Math.max(0, 5 - assignmentRows.value.length),
);

function isSelectedStep(id) {
    return Number(id) === Number(selectedStepId.value);
}

function setStepOptionEl(el, index) {
    if (el) stepOptionEls.value[index] = el;
}

function focusStepOption(index) {
    const count = stepOptions.value.length;
    if (!count) return;
    const next = (index + count) % count;
    nextTick(() => stepOptionEls.value[next]?.focus?.());
}

function openStepMenu(index) {
    if (!stepOptions.value.length) return;
    stepMenuOpen.value = true;
    focusStepOption(index);
}

function closeStepMenu(restoreFocus = false) {
    stepMenuOpen.value = false;
    if (restoreFocus) nextTick(() => stepTrigger.value?.focus?.());
}

function toggleStepMenu() {
    if (stepMenuOpen.value) {
        closeStepMenu();
        return;
    }
    const index = stepOptions.value.findIndex((option) =>
        isSelectedStep(option.id),
    );
    openStepMenu(index >= 0 ? index : 0);
}

function onTriggerKeydown(event) {
    if (event.key !== "ArrowDown" && event.key !== "ArrowUp") return;
    event.preventDefault();
    openStepMenu(event.key === "ArrowUp" ? stepOptions.value.length - 1 : 0);
}

function onStepOptionKeydown(event, index) {
    if (event.key === "ArrowDown") {
        event.preventDefault();
        focusStepOption(index + 1);
    } else if (event.key === "ArrowUp") {
        event.preventDefault();
        focusStepOption(index - 1);
    } else if (event.key === "Home") {
        event.preventDefault();
        focusStepOption(0);
    } else if (event.key === "End") {
        event.preventDefault();
        focusStepOption(stepOptions.value.length - 1);
    }
}

function onStepMenuFocusOut(event) {
    if (
        stepMenuOpen.value &&
        !stepMenuRef.value?.contains(event.relatedTarget)
    ) {
        stepMenuOpen.value = false;
    }
}

function onDocumentPointerDown(event) {
    if (!stepMenuOpen.value) return;
    if (!stepMenuRef.value?.contains(event.target)) stepMenuOpen.value = false;
}

function onDocumentKeydown(event) {
    if (event.key === "Escape" && stepMenuOpen.value) {
        event.preventDefault();
        closeStepMenu(true);
    }
}

function selectStep(id) {
    const changed = !isSelectedStep(id);
    stepMenuOpen.value = false;
    if (changed) selectedStepId.value = id;
    nextTick(() => stepTrigger.value?.focus?.());
}

// Edit-name dialog
const editDialog = ref(false);
const editSaving = ref(false);
const editError = ref("");
const editNameError = ref("");
const editForm = ref({ name: "" });
const editCode = ref("");
const editKey = ref(null);
const editNameField = ref(null);

// Add-entry dialog
const addDialog = ref(false);
const adding = ref(false);
const addError = ref("");
const addForm = ref({
    name: "",
    code: "",
    description: "",
    is_required: true,
    is_upload_required: true,
});
const addFieldErrors = ref({ name: "", code: "" });
const addNameField = ref(null);
const addCodeField = ref(null);

function onAddNameInput() {
    if (addFieldErrors.value.name) addFieldErrors.value.name = "";
}

function onAddCodeInput() {
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
    if (!code) {
        errors.code = "Enter a code in snake_case (for example signed_pr_pdf).";
    } else if (!/^[a-z][a-z0-9_]*$/.test(code)) {
        errors.code =
            "Use snake_case, starting with a letter (for example signed_pr_pdf).";
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

function toggleRequired(item) {
    item.is_required = !item.is_required;
    stageBindings();
}

function toggleUploadRequired(item) {
    item.is_upload_required = !item.is_upload_required;
    stageBindings();
}

function openEdit(item) {
    editError.value = "";
    editNameError.value = "";
    editKey.value = item.requirement_definition_id;
    editCode.value = item.code || "";
    editForm.value = { name: item.name || "" };
    editDialog.value = true;
}

function focusEditName() {
    editNameField.value?.focus();
}

function saveEdit() {
    if (editSaving.value) return;
    const name = editForm.value.name?.trim() || "";
    if (!name) {
        editNameError.value = "Enter a requirement name.";
        editNameField.value?.focus();
        return;
    }
    if (!typeId.value) {
        editError.value =
            "Resolve the transaction type first (open this page from Workflows).";
        return;
    }

    const key = editKey.value;
    const row = assignmentRows.value.find(
        (item) => String(item.requirement_definition_id) === String(key),
    );
    if (!row) {
        editError.value = "Requirement not found.";
        return;
    }

    editSaving.value = true;
    editError.value = "";
    try {
        const bucket = staging.buckets.get(String(typeId.value));
        const currentDef = (bucket?.reqDefs || []).find(
            (def) => String(def.client_id ?? def.id) === String(key),
        );
        const patch = { name };
        if (typeof key === "number") patch.id = key;
        else patch.client_id = key;
        if (!currentDef) {
            patch.code = row.code || null;
            patch.description = row.description || null;
        }
        staging.upsertReqDef(typeId.value, patch);
        assignmentRows.value = assignmentRows.value.map((item) =>
            String(item.requirement_definition_id) === String(key)
                ? { ...item, name }
                : item,
        );
        stageBindings();
        editDialog.value = false;
        toastSuccess(`Requirement renamed to "${name}".`);
    } catch (e) {
        editError.value = e?.message || "Failed to rename requirement.";
    } finally {
        editSaving.value = false;
    }
}

function openAdd() {
    addError.value = "";
    addFieldErrors.value = { name: "", code: "" };
    addForm.value = {
        name: "",
        code: "",
        description: "",
        is_required: true,
        is_upload_required: true,
    };
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
        addError.value =
            "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    adding.value = true;
    addError.value = "";
    try {
        // Staged requirement definition (server mints the id on save).
        const { row: created } = staging.upsertReqDef(typeId.value, {
            name: addForm.value.name.trim(),
            code: addForm.value.code.trim(),
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
            const defRes = await api.get(
                `/api/admin/workflow-definitions/${wid}`,
            );
            const def = defRes.data?.data ?? defRes.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
            defVersion.value = def?.version ?? null;
            defStatus.value = def?.status ?? "";
            defIsLive.value = !!def?.is_live;
        } catch {
            /* type id and version metadata are best-effort */
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

function enrichStagedRow(r, idx) {
    // Names/labels for staged rows: staged defs first, then the server
    // catalog, then whatever the row itself carries.
    const key = String(r.req_key ?? r.requirement_definition_id ?? r.id);
    const b = typeId.value ? staging.buckets.get(String(typeId.value)) : null;
    const staged = (b?.reqDefs || []).find(
        (d) => String(d.client_id ?? d.id) === key,
    );
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

let loadAssignedToken = 0;

async function loadAssigned() {
    const token = ++loadAssignedToken;
    if (!selectedStepId.value) {
        assignmentRows.value = [];
        ready.value = true;
        return;
    }
    ready.value = false;
    error.value = "";
    try {
        await fetchAssigned(
            workflowDefinitionId.value,
            Number(selectedStepId.value),
        );
        if (token !== loadAssignedToken) return;
        const sid = Number(selectedStepId.value);
        // Prefer already-staged rows so revisit never shows stale server
        // state over unsaved edits; names resolve via staged defs/catalog.
        const staged = typeId.value
            ? staging.buckets.get(String(typeId.value))?.bindings?.[String(sid)]
            : null;
        if (staged) {
            assignmentRows.value = staged.map((r, idx) =>
                enrichStagedRow(r, idx),
            );
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
            is_upload_required:
                a.pivot_meta?.is_upload_required ??
                a.pivot_meta?.is_required ??
                true,
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
        if (token === loadAssignedToken) {
            error.value =
                e?.response?.data?.message ||
                "Failed to load assigned requirements.";
        }
    } finally {
        if (token === loadAssignedToken) ready.value = true;
    }
}

function selectInitialStep() {
    const sid = stepIdFromUrl.value;
    if (
        Number.isFinite(sid) &&
        steps.value.some((step) => Number(step.id) === sid)
    ) {
        selectedStepId.value = sid;
    } else if (steps.value.length) {
        selectedStepId.value = steps.value[0].id;
    }
}

async function retrySteps() {
    await loadSteps();
    if (
        !selectedStepId.value ||
        !steps.value.some(
            (step) => Number(step.id) === Number(selectedStepId.value),
        )
    ) {
        selectInitialStep();
    }
}

async function afterBulkSaved() {
    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await fetchReqs(workflowDefinitionId.value);
    await loadAssigned();
}

watch(selectedStepId, async () => {
    editDialog.value = false;
    assigned.value = [];
    assignmentRows.value = [];
    if (!selectedStepId.value) {
        ready.value = true;
        return;
    }
    await loadAssigned();
});

onMounted(async () => {
    document.addEventListener("mousedown", onDocumentPointerDown);
    document.addEventListener("keydown", onDocumentKeydown);

    // Requirement catalog and step list are independent: fetch in parallel.
    await Promise.allSettled([
        fetchReqs(workflowDefinitionId.value),
        loadSteps(),
    ]);
    selectInitialStep();
    if (!selectedStepId.value) ready.value = true;
});

onBeforeUnmount(() => {
    document.removeEventListener("mousedown", onDocumentPointerDown);
    document.removeEventListener("keydown", onDocumentKeydown);
});
</script>

<style scoped>
/* ---- Requirements page ---- */
.sr-page {
    --sr-field: #f4f6fb;
    --sr-hover: #f3f6fc;
    /* Cancel AppShell's v-container pa-6 so the page can use the
       mockup's adaptive full-width gutters. */
    width: auto;
    max-width: none;
    margin: 0 -24px;
    padding: 0 clamp(16px, 3vw, 48px) 16px;
}

.sr-page :deep(.v-alert) {
    border-radius: 0;
}

.sr-page :deep(.v-btn) {
    border-radius: 0;
}

.sr-add:focus-visible,
.sr-trigger:focus-visible,
.sr-option:focus-visible,
.sr-ib:focus-visible,
.sr-tg:focus-visible,
.sr-code-in:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.sr-info {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 22px;
    padding: 14px 16px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.1);
    font-size: 14px;
    line-height: 1.5;
}

.sr-info-ic {
    flex: none;
    margin-top: 1px;
    color: rgb(var(--v-theme-primary));
}

.sr-info b {
    color: rgb(var(--v-theme-primary));
}

.sr-lbl {
    margin: 0 0 10px;
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

/* ---- Step picker ---- */
.sr-dd {
    position: relative;
    margin-bottom: 22px;
}

.sr-trigger {
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    min-height: 68px;
    padding: 10px 14px 10px 10px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
    transition:
        border-color 0.15s,
        box-shadow 0.15s;
}

.sr-trigger:hover:not(:disabled) {
    border-color: rgba(var(--v-theme-primary), 0.45);
}

.sr-trigger:focus-visible,
.sr-trigger-open {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}

.sr-trigger:disabled {
    opacity: 0.65;
    cursor: default;
}

.sr-step-n {
    display: grid;
    flex: none;
    width: 44px;
    height: 44px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 16px;
    font-weight: 800;
    place-items: center;
}

.sr-step-tx {
    flex: 1;
    min-width: 0;
}

.sr-step-tx b {
    display: block;
    overflow: hidden;
    font-size: 16px;
    font-weight: 700;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-step-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-count {
    flex: none;
    padding: 3px 10px;
    border-radius: 0;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
}

.sr-chev {
    flex: none;
    color: rgb(var(--v-theme-secondary));
    transition: transform 0.2s;
}

.sr-chev-open {
    transform: rotate(180deg);
}

.sr-menu {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    left: 0;
    z-index: 20;
    max-height: 320px;
    padding: 8px;
    overflow: auto;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 18px 40px -12px rgba(20, 33, 61, 0.3);
}

.sr-option {
    position: relative;
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    padding: 10px;
    border: 0;
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
}

.sr-option:hover,
.sr-option:focus-visible {
    background: var(--sr-hover);
}

.sr-option-selected::before {
    position: absolute;
    top: 12px;
    bottom: 12px;
    left: -8px;
    width: 4px;
    border-radius: 0;
    background: rgb(var(--v-theme-primary));
    content: "";
}

.sr-option-n {
    display: grid;
    flex: none;
    width: 40px;
    height: 40px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 15px;
    font-weight: 800;
    place-items: center;
}

.sr-option-tx {
    flex: 1;
    min-width: 0;
}

.sr-option-tx b {
    display: block;
    overflow: hidden;
    font-size: 14.5px;
    font-weight: 700;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-option-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12px;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-option-ck {
    flex: none;
    color: rgb(var(--v-theme-primary));
    opacity: 0;
}

.sr-option-ck-on {
    opacity: 1;
}

.sr-option-empty {
    padding: 18px 12px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
    text-align: center;
}

.sr-sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

/* ---- Requirements card ---- */
.sr-card {
    overflow: hidden;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
}

.sr-card-hd {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 18px 20px;
    border-bottom: 1px solid
        rgba(var(--v-border-color), var(--v-border-opacity));
}

.sr-card-hd h2 {
    margin: 0;
    font-size: 17px;
    font-weight: 800;
    line-height: 1.2;
}

.sr-card-hd p {
    margin: 2px 0 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
    line-height: 1.2;
}

.sr-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 8px;
    height: 44px;
    margin-left: auto;
    padding: 0 18px;
    border: 0;
    border-radius: 0;
    background: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        opacity 0.15s;
}

.sr-add:hover:not(:disabled) {
    filter: brightness(0.93);
}

.sr-add:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.sr-loading {
    display: flex;
    align-items: center;
    min-height: 404px;
    padding: 12px 0;
}

.sr-rows {
    width: 100%;
}

.sr-row {
    display: grid;
    grid-template-columns:
        minmax(0, 2fr)
        minmax(0, 1.4fr)
        minmax(150px, 1fr)
        minmax(170px, 1fr)
        112px;
    align-items: center;
    gap: 12px;
    padding: 14px 20px;
    border-bottom: 1px solid
        rgba(var(--v-border-color), var(--v-border-opacity));
}

.sr-row:last-child {
    border-bottom: 0;
}

.sr-row-ghost {
    min-height: 74px;
    pointer-events: none;
}

.sr-row.sr-row-noitem {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 138px;
    padding: 24px;
    text-align: center;
}

.sr-noitem-cell {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
    width: 100%;
    max-width: 460px;
}

.sr-noitem-copy {
    width: 100%;
}

.sr-noitem-copy b {
    display: block;
    font-size: 16px;
    line-height: 1.2;
}

.sr-noitem-copy span {
    display: block;
    margin-top: 4px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
    line-height: 1.35;
}

.sr-row-noitem .sr-add {
    height: 40px;
    margin-left: 0;
}

.sr-row-head {
    padding: 10px 20px;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}

.sr-row-item {
    transition: background 0.12s;
}

.sr-row-item:hover {
    background: var(--sr-hover);
}

.sr-name {
    min-width: 0;
}

.sr-name b {
    display: block;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.2;
    word-break: break-word;
}

.sr-name span {
    display: -webkit-box;
    overflow: hidden;
    margin-top: 4px;
    color: rgb(var(--v-theme-secondary));
    font-size: 12.5px;
    line-height: 1.35;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
}

.sr-code-cell {
    min-width: 0;
}

.sr-code {
    display: inline-block;
    max-width: 100%;
    padding: 3px 9px;
    border-radius: 0;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.sr-code-in {
    width: 100%;
    max-width: 220px;
    height: 32px;
    padding: 0 9px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    outline: none;
    background: var(--sr-field);
    color: rgb(var(--v-theme-on-surface));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    transition:
        border-color 0.15s,
        box-shadow 0.15s;
}

.sr-code-in:focus {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 3px rgba(var(--v-theme-primary), 0.16);
}

.sr-code-in::placeholder {
    color: rgb(var(--v-theme-secondary));
    opacity: 0.75;
}

.sr-req {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
    font-weight: 600;
}

.sr-on {
    color: #1b7a3d;
}

.sr-tg {
    position: relative;
    flex: none;
    width: 44px;
    height: 26px;
    padding: 0;
    border: 0;
    border-radius: 0;
    background: #8b95aa;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.26);
    cursor: pointer;
    transition:
        background 0.2s,
        box-shadow 0.2s;
}

.sr-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    box-sizing: border-box;
    width: 20px;
    height: 20px;
    border: 1px solid rgba(0, 0, 0, 0.14);
    border-radius: 0;
    background: #f3f4f6;
    box-shadow:
        0 1px 2px rgba(0, 0, 0, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.65);
    content: "";
    transition: transform 0.2s;
}

.sr-tg[aria-checked="true"] {
    background: #1b7a3d;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.sr-tg[aria-checked="true"]::after {
    transform: translateX(18px);
}

.sr-actions {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}

.sr-ib {
    display: grid;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-secondary));
    cursor: pointer;
    place-items: center;
    transition:
        background 0.15s,
        border-color 0.15s,
        color 0.15s;
}

.sr-ib-edit {
    border-color: rgba(184, 110, 0, 0.35);
    color: #b86e00;
}

.sr-ib-edit:hover {
    border-color: rgba(184, 110, 0, 0.52);
    background: rgba(184, 110, 0, 0.12);
}

.sr-ib-delete {
    border-color: rgba(198, 40, 40, 0.28);
    color: #c62828;
}

.sr-ib-delete:hover {
    border-color: rgba(198, 40, 40, 0.45);
    background: rgba(198, 40, 40, 0.1);
}

html.dark .sr-page {
    --sr-field: #1c2645;
    --sr-hover: #1d2745;
}

html.dark .sr-card {
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}

html.dark .sr-menu {
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.65);
}

html.dark .sr-info {
    background: rgba(var(--v-theme-primary), 0.14);
}

html.dark .sr-tg[aria-checked="true"] {
    background: #3fbf6f;
}

html.dark .sr-on {
    color: #3fbf6f;
}

html.dark .sr-ib-edit {
    border-color: rgba(255, 191, 71, 0.4);
    color: #ffbf47;
}

html.dark .sr-ib-edit:hover {
    border-color: rgba(255, 191, 71, 0.65);
    background: rgba(255, 191, 71, 0.12);
}

html.dark .sr-ib-delete {
    border-color: rgba(255, 138, 128, 0.35);
    color: #ff8a80;
}

html.dark .sr-ib-delete:hover {
    border-color: rgba(255, 138, 128, 0.6);
    background: rgba(255, 138, 128, 0.12);
}

@media (min-width: 1200px) {
    .sr-card-hd {
        padding: 20px 28px;
    }

    .sr-row {
        padding: 16px 28px;
    }

    .sr-row-head {
        padding: 12px 28px;
    }

    .sr-name b {
        font-size: 16px;
    }

    .sr-code-in {
        max-width: 240px;
    }
}

@media (max-width: 720px) {
    .sr-card-hd {
        flex-wrap: wrap;
    }

    .sr-add {
        width: 100%;
        margin-left: 0;
    }

    .sr-loading {
        min-height: 244px;
    }

    .sr-row-head,
    .sr-row-ghost {
        display: none;
    }

    .sr-row {
        grid-template-columns: 1fr auto;
        grid-template-areas:
            "name actions"
            "code code"
            "reqr requ";
        row-gap: 10px;
    }

    .sr-name {
        grid-area: name;
    }

    .sr-code-cell {
        grid-area: code;
    }

    .sr-req-r {
        grid-area: reqr;
    }

    .sr-req-u {
        grid-area: requ;
    }

    .sr-actions {
        grid-area: actions;
        align-self: start;
    }

    .sr-code-in {
        max-width: none;
    }
}

@media (max-width: 520px) {
    .sr-step-tx b {
        font-size: 15px;
    }

    .sr-step-n {
        width: 40px;
        height: 40px;
    }

    .sr-count {
        padding: 3px 8px;
        font-size: 11px;
    }

    .sr-option {
        gap: 10px;
        padding: 8px;
    }

    .sr-option-n {
        width: 36px;
        height: 36px;
    }

    .sr-row {
        padding: 14px 20px;
    }

    .sr-req {
        font-size: 12.5px;
    }
}

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

.req-code-ro {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 12px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
}

.req-code-ro span {
    flex: none;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}

.req-code-ro code {
    min-width: 0;
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 13px;
    overflow-wrap: anywhere;
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
    background: #8b95aa;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.26);
    cursor: pointer;
    transition:
        background 0.2s,
        box-shadow 0.2s;
}

.req-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    box-sizing: border-box;
    width: 22px;
    height: 22px;
    border: 1px solid rgba(0, 0, 0, 0.14);
    border-radius: 50%;
    background: #f3f4f6;
    box-shadow:
        0 1px 2px rgba(0, 0, 0, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.65);
    content: "";
    transition: transform 0.2s;
}

.req-tg[aria-checked="true"] {
    background: #1b7a3d;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.req-tg[aria-checked="true"]::after {
    transform: translateX(20px);
}

.req-tg:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.req-sec-preview {
    margin: 0 0 6px;
}

.req-preview {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 14px;
    border: 1.5px dashed rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}

.req-preview-ck {
    flex: none;
    width: 22px;
    height: 22px;
    margin-top: 1px;
    border: 2px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 7px;
}

.req-preview-body {
    flex: 1;
    min-width: 0;
}

.req-preview-name {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    font-size: 14.5px;
    font-weight: 700;
    word-break: break-word;
}

.req-tag {
    display: inline-flex;
    align-items: center;
    padding: 2px 9px;
    border-radius: 99px;
    font-size: 11px;
    font-weight: 800;
    color: rgb(var(--v-theme-error));
    background: rgba(var(--v-theme-error), 0.12);
}

.req-tag-optional {
    color: rgb(var(--v-theme-secondary));
    background: rgba(var(--v-border-color), 0.08);
}

.req-preview-remark {
    margin: 4px 0 0;
    font-size: 13px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
    white-space: pre-wrap;
    word-break: break-word;
}

.req-preview-attach {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    height: 34px;
    margin-top: 10px;
    padding: 0 12px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 10px;
    font-size: 13px;
    font-weight: 700;
    color: rgb(var(--v-theme-primary));
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
