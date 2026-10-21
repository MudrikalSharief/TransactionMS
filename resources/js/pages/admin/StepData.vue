<template>
    <div class="sd-page">
        <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-4">
            {{ error }}
        </v-alert>

        <header class="sd-top">
            <div class="sd-badge">
                <v-icon size="24">mdi-text-box-outline</v-icon>
            </div>
            <div class="sd-title">
                <h1>Step Data</h1>
                <p>Choose a step and manage the values collected at Proceed.</p>
            </div>
            <button type="button" class="sd-back" @click="goBack">
                <v-icon size="18">mdi-arrow-left</v-icon>
                <span>Back</span>
            </button>
        </header>

        <div class="sd-info">
            <v-icon size="20" class="sd-info-ic">mdi-information-outline</v-icon>
            <span>
                <b>Template for this step.</b>
                Text values collected at Proceed (for example, a receipt number). Values keep history per visit.
            </span>
        </div>

        <p class="sd-lbl">Select step</p>

        <div ref="stepMenuRef" class="sd-dd" @focusout="onStepMenuFocusOut">
            <button
                ref="stepTrigger"
                type="button"
                class="sd-trigger"
                :class="{ 'sd-trigger-open': stepMenuOpen }"
                :disabled="stepsLoading || !stepOptions.length"
                aria-haspopup="listbox"
                aria-controls="sd-step-menu"
                :aria-expanded="stepMenuOpen ? 'true' : 'false'"
                @click="toggleStepMenu"
                @keydown="onTriggerKeydown"
            >
                <span class="sd-sr-only">Select step</span>
                <span class="sd-step-n">{{ selectedStep?.order_number ?? "–" }}</span>
                <span class="sd-step-tx">
                    <b>{{ selectedStep?.name || (stepsLoading ? "Loading steps…" : "Select a step") }}</b>
                    <small>{{ selectedStep?.code || "No step selected" }}</small>
                </span>
                <span v-if="selectedStep" class="sd-count">
                    {{ countLabel(stepFieldCount(selectedStep.id)) }}
                </span>
                <v-icon class="sd-chev" :class="{ 'sd-chev-open': stepMenuOpen }" size="20">
                    mdi-chevron-down
                </v-icon>
            </button>

            <div
                v-if="stepMenuOpen"
                id="sd-step-menu"
                class="sd-menu"
                role="listbox"
                aria-label="Steps"
            >
                <button
                    v-for="(option, index) in stepOptions"
                    :key="option.id"
                    :ref="(el) => setStepOptionEl(el, index)"
                    type="button"
                    class="sd-option"
                    :class="{ 'sd-option-selected': isSelectedStep(option.id) }"
                    role="option"
                    :aria-selected="isSelectedStep(option.id) ? 'true' : 'false'"
                    @click="selectStep(option.id)"
                    @keydown="onStepOptionKeydown($event, index)"
                >
                    <span class="sd-option-n">{{ option.order_number }}</span>
                    <span class="sd-option-tx">
                        <b>{{ option.name }}</b>
                        <small>{{ option.code }}</small>
                    </span>
                    <span class="sd-count">{{ countLabel(option.count) }}</span>
                    <v-icon
                        class="sd-option-ck"
                        :class="{ 'sd-option-ck-on': isSelectedStep(option.id) }"
                        size="20"
                        aria-hidden="true"
                    >
                        mdi-check
                    </v-icon>
                </button>
                <div v-if="!stepOptions.length" class="sd-option-empty">No steps available.</div>
            </div>
        </div>

        <section class="sd-card" aria-live="polite">
            <div class="sd-card-hd">
                <div>
                    <h2>Data fields for this step</h2>
                    <p>{{ cardSubtitle }}</p>
                </div>
                <button
                    type="button"
                    class="sd-add"
                    :disabled="!selectedStepId || loading || stepsLoading"
                    @click="openAdd"
                >
                    <v-icon size="18">mdi-plus</v-icon>
                    <span>Add data field</span>
                </button>
            </div>

            <div v-if="loading || stepsLoading" class="sd-loading">
                <TableLoader compact label="step data" icon="mdi-text-box-outline" />
            </div>

            <div v-else-if="!selectedStepId" class="sd-empty">
                <div class="sd-empty-icon">
                    <v-icon size="30">mdi-text-box-search-outline</v-icon>
                </div>
                <h3>Select a step</h3>
                <p>Choose a step above to manage its data fields.</p>
            </div>

            <div v-else-if="error && !sortedItems.length" class="sd-empty">
                <div class="sd-empty-icon sd-empty-icon-error">
                    <v-icon size="30">mdi-alert-circle-outline</v-icon>
                </div>
                <h3>Couldn't load data fields</h3>
                <p>Check the error above, then try again.</p>
                <button type="button" class="sd-add" @click="loadItems">
                    <v-icon size="18">mdi-refresh</v-icon>
                    <span>Try again</span>
                </button>
            </div>

            <div v-else-if="!sortedItems.length" class="sd-empty">
                <div class="sd-empty-icon">
                    <v-icon size="30">mdi-form-textbox</v-icon>
                </div>
                <h3>No data fields yet</h3>
                <p>Add a field to collect a value when this step proceeds.</p>
                <button type="button" class="sd-add" @click="openAdd">
                    <v-icon size="18">mdi-plus</v-icon>
                    <span>Add data field</span>
                </button>
            </div>

            <div v-else class="sd-rows" role="table" aria-label="Data fields">
                <div class="sd-row sd-row-head" role="row">
                    <div role="columnheader">Field</div>
                    <div role="columnheader">Required</div>
                    <div role="columnheader">Order</div>
                    <div role="columnheader"></div>
                </div>

                <div v-for="item in sortedItems" :key="item.id" class="sd-row sd-row-item" role="row">
                    <div class="sd-field" role="cell">
                        <b>{{ item.display_name }}</b>
                        <div class="sd-field-meta">
                            <span class="sd-code">{{ item.code }}</span>
                            <span v-if="formatLimit(item)" class="sd-limit">{{ formatLimit(item) }}</span>
                        </div>
                    </div>

                    <div class="sd-req" role="cell">
                        <button
                            type="button"
                            class="sd-tg"
                            role="switch"
                            :aria-checked="item.is_required ? 'true' : 'false'"
                            :disabled="requiredSaving.has(String(item.id))"
                            :aria-label="`Toggle required for ${item.display_name}`"
                            @click="toggleRequired(item)"
                        ></button>
                        <span :class="{ 'sd-on': item.is_required }">
                            {{ item.is_required ? "Required" : "Optional" }}
                        </span>
                    </div>

                    <div class="sd-order-cell" role="cell">
                        <span class="sd-order">{{ item.display_order ?? 0 }}</span>
                    </div>

                    <div class="sd-actions" role="cell">
                        <button
                            type="button"
                            class="sd-ib sd-ib-edit"
                            :disabled="deletingIds.has(String(item.id))"
                            :aria-label="`Edit ${item.display_name}`"
                            @click="openEdit(item)"
                        >
                            <v-icon size="19">mdi-pencil-outline</v-icon>
                        </button>
                        <button
                            type="button"
                            class="sd-ib sd-ib-delete"
                            :disabled="deletingIds.has(String(item.id))"
                            :aria-label="`Delete ${item.display_name}`"
                            @click="removeRow(item)"
                        >
                            <v-icon size="19">mdi-trash-can-outline</v-icon>
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <v-dialog
            v-model="dialog"
            max-width="520"
            :persistent="formSaving"
            content-class="df-dialog-content"
            @after-enter="focusName"
        >
            <v-card rounded="xl" class="df-card">
                <v-card-title class="df-hd">
                    <div class="df-title">{{ isEditing ? "Edit data field" : "Add data field" }}</div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="df-x"
                        aria-label="Close data field dialog"
                        :disabled="formSaving"
                        @click="dialog = false"
                    />
                </v-card-title>

                <form class="df-form" novalidate @submit.prevent="saveForm">
                    <v-card-text class="df-bd">
                        <v-alert v-if="formError" type="error" variant="tonal" density="compact" class="mb-4">
                            {{ formError }}
                        </v-alert>

                        <div class="df-f">
                            <label class="df-lb" for="df-name">
                                Display name <span class="df-required">*</span>
                            </label>
                            <v-text-field
                                id="df-name"
                                ref="nameField"
                                v-model="form.display_name"
                                placeholder="e.g. Receipt number"
                                maxlength="255"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                :error="!!fieldErrors.display_name"
                                class="df-in"
                                @update:model-value="onDisplayNameInput"
                            />
                            <div v-if="fieldErrors.display_name" class="df-error">
                                {{ fieldErrors.display_name }}
                            </div>
                        </div>

                        <div class="df-f">
                            <label class="df-lb" for="df-code">Code</label>
                            <v-text-field
                                id="df-code"
                                ref="codeField"
                                v-model="form.code"
                                placeholder="receipt_number"
                                maxlength="100"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                spellcheck="false"
                                :error="!!fieldErrors.code"
                                class="df-in df-in-mono"
                                @update:model-value="onCodeInput"
                            />
                            <div v-if="fieldErrors.code" class="df-error">{{ fieldErrors.code }}</div>
                            <div v-else class="df-help">
                                Auto-generated from the name, or type your own.
                            </div>
                        </div>

                        <div class="df-required-row">
                            <div class="df-required-copy">
                                <b>Required</b>
                                <span>
                                    {{
                                        form.is_required
                                            ? "Workers must fill this in"
                                            : "Workers can leave this empty"
                                    }}
                                </span>
                            </div>
                            <button
                                class="df-tg"
                                type="button"
                                role="switch"
                                :aria-checked="form.is_required ? 'true' : 'false'"
                                aria-label="Required"
                                @click="form.is_required = !form.is_required"
                            ></button>
                        </div>

                        <div class="df-g3">
                            <div class="df-f">
                                <label class="df-lb" for="df-order">Order</label>
                                <v-text-field
                                    id="df-order"
                                    v-model.number="form.display_order"
                                    type="number"
                                    min="0"
                                    inputmode="numeric"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details
                                    class="df-in"
                                />
                            </div>
                            <div class="df-f">
                                <label class="df-lb" for="df-min">
                                    Min <span class="df-opt">(opt.)</span>
                                </label>
                                <v-text-field
                                    id="df-min"
                                    ref="minField"
                                    v-model.number="form.min_length"
                                    type="number"
                                    min="0"
                                    inputmode="numeric"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details
                                    :error="!!fieldErrors.lengths"
                                    class="df-in"
                                    @update:model-value="clearLengthError"
                                />
                            </div>
                            <div class="df-f">
                                <label class="df-lb" for="df-max">
                                    Max <span class="df-opt">(opt.)</span>
                                </label>
                                <v-text-field
                                    id="df-max"
                                    ref="maxField"
                                    v-model.number="form.max_length"
                                    type="number"
                                    min="1"
                                    inputmode="numeric"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details
                                    :error="!!fieldErrors.lengths"
                                    class="df-in"
                                    @update:model-value="clearLengthError"
                                />
                            </div>
                        </div>
                        <div v-if="fieldErrors.lengths" class="df-error df-length-error">
                            {{ fieldErrors.lengths }}
                        </div>
                        <div v-else class="df-help df-length-help">
                            Counted in characters. Leave empty for no limit.
                        </div>

                        <section class="df-sec df-sec-preview">
                            <div class="df-sec-t">Preview</div>
                            <div class="df-preview">
                                <div class="df-preview-label">
                                    {{ form.display_name?.trim() || "Field name" }}
                                    <span v-if="form.is_required" class="df-required">*</span>
                                </div>
                                <div class="df-preview-input">
                                    <span>Text input</span>
                                    <span>{{ previewMeta }}</span>
                                </div>
                            </div>
                        </section>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="df-ft">
                        <v-btn
                            type="button"
                            variant="outlined"
                            rounded="lg"
                            class="df-b"
                            :disabled="formSaving"
                            @click="dialog = false"
                        >
                            Cancel
                        </v-btn>
                        <v-btn
                            color="primary"
                            rounded="lg"
                            class="df-b df-b-pri"
                            type="submit"
                            :loading="formSaving"
                        >
                            {{ isEditing ? "Save changes" : "Save field" }}
                        </v-btn>
                    </v-card-actions>
                </form>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { confirm } from "@/composables/useConfirm";
import { useStepData } from "@/composables/useStepData";
import { useToast } from "@/composables/useToast";
import TableLoader from "@/components/TableLoader.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { items, loading, fetchAll, create, update, remove } = useStepData();
const { success: toastSuccess, error: toastError } = useToast();

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
const stepsLoading = ref(true);
const selectedStepId = ref(null);
const stepCounts = ref({});

const stepMenuOpen = ref(false);
const stepMenuRef = ref(null);
const stepTrigger = ref(null);
const stepOptionEls = ref([]);

const requiredSaving = ref(new Set());
const deletingIds = ref(new Set());
let itemsRequest = 0;

const selectedStep = computed(
    () => steps.value.find((s) => String(s.id) === String(selectedStepId.value)) ?? null,
);

const stepOptions = computed(() =>
    steps.value.map((s) => ({
        id: s.id,
        order_number: s.order_number,
        name: s.name,
        code: s.code,
        count: stepFieldCount(s.id),
    })),
);

const sortedItems = computed(() =>
    [...(items.value || [])].sort(
        (a, b) =>
            Number(a.display_order ?? 0) - Number(b.display_order ?? 0) ||
            Number(a.id) - Number(b.id),
    ),
);

const cardSubtitle = computed(() => {
    if (stepsLoading.value) return "Loading steps…";
    if (!selectedStepId.value) return "Select a step to manage its data fields.";
    if (loading.value) return "Loading fields…";

    const count = sortedItems.value.length;
    if (!count) return "Nothing added yet";
    return `${count} ${count === 1 ? "field" : "fields"} for “${selectedStep.value?.name || "this step"}”`;
});

function stepFieldCount(id) {
    const key = String(id);
    const value = stepCounts.value[key];
    if (value !== undefined && value !== null) return Number(value) || 0;
    if (String(id) === String(selectedStepId.value)) return (items.value || []).length;
    return 0;
}

function setStepCount(id, count) {
    stepCounts.value = {
        ...stepCounts.value,
        [String(id)]: Math.max(0, Number(count) || 0),
    };
}

function countLabel(count) {
    return `${count} ${count === 1 ? "field" : "fields"}`;
}

function isSelectedStep(id) {
    return String(id) === String(selectedStepId.value);
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

    const index = stepOptions.value.findIndex((option) => isSelectedStep(option.id));
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
    if (stepMenuOpen.value && !stepMenuRef.value?.contains(event.relatedTarget)) {
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

function formatLimit(item) {
    const min = item.min_length;
    const max = item.max_length;
    if (min == null && max == null) return "";

    const parts = [];
    if (min != null) parts.push(`min ${min}`);
    if (max != null) parts.push(`max ${max}`);
    return parts.join(" · ");
}

async function toggleRequired(item) {
    const id = String(item.id);
    if (requiredSaving.value.has(id)) return;

    const previous = item.is_required;
    const next = !previous;
    item.is_required = next;
    requiredSaving.value.add(id);

    try {
        await update(workflowDefinitionId.value, Number(selectedStepId.value), item.id, {
            is_required: next,
        });
    } catch (e) {
        item.is_required = previous;
        toastError(e?.response?.data?.message || "Could not update required status.");
    } finally {
        requiredSaving.value.delete(id);
    }
}

async function removeRow(item) {
    const id = String(item.id);
    const stepId = Number(selectedStepId.value);
    if (deletingIds.value.has(id)) return;

    const ok = await confirm({
        title: "Delete data field?",
        message: `"${item.display_name}" will be removed from this step. Past entered values are kept for history.`,
        confirmLabel: "Delete",
        tone: "danger",
    });
    if (!ok) return;

    const remainingCount = Math.max(0, stepFieldCount(stepId) - 1);
    deletingIds.value.add(id);
    try {
        await remove(workflowDefinitionId.value, stepId, item.id);
        setStepCount(stepId, remainingCount);
        toastSuccess(`Field "${item.display_name}" deleted.`);
    } catch (e) {
        toastError(e?.response?.data?.message || "Delete failed.");
    } finally {
        deletingIds.value.delete(id);
    }
}

const dialog = ref(false);
const editingId = ref(null);
const formSaving = ref(false);
const formError = ref("");
const form = ref({ display_name: "", code: "", is_required: false, display_order: 0, min_length: null, max_length: null });
const fieldErrors = ref({ display_name: "", code: "", lengths: "" });
const nameField = ref(null);
const codeField = ref(null);
const minField = ref(null);
const maxField = ref(null);
// Once the user edits Code themselves, stop regenerating it from Display name.
const codeTouched = ref(false);

const isEditing = computed(() => editingId.value != null);

function slugify(v) {
    return String(v || "").toLowerCase().trim().replace(/[^a-z0-9]+/g, "_").replace(/^_+|_+$/g, "");
}

function codeFromName(value) {
    const base = slugify(value).slice(0, 95);
    if (!base) return "";
    return /^[a-z]/.test(base) ? base : `field_${base}`.slice(0, 95);
}

function optionalInt(value) {
    if (value === "" || value === null || value === undefined) return null;
    const n = Number(value);
    return Number.isFinite(n) ? n : NaN;
}

function nextFieldCode(base) {
    const taken = new Set(
        (items.value || [])
            .filter((item) => Number(item.id) !== Number(editingId.value))
            .map((item) => String(item.code || "").toLowerCase())
            .filter(Boolean),
    );

    let code = base;
    let suffix = 2;
    while (taken.has(code)) code = `${base}_${suffix++}`;
    return code;
}

function focusName() {
    nameField.value?.focus?.();
}

function clearFieldErrors() {
    fieldErrors.value = { display_name: "", code: "", lengths: "" };
}

function clearLengthError() {
    if (fieldErrors.value.lengths) fieldErrors.value.lengths = "";
}

function onDisplayNameInput(value) {
    if (!codeTouched.value) {
        const base = codeFromName(value);
        form.value.code = base ? nextFieldCode(base) : "";
        fieldErrors.value.code = "";
    }
    if (fieldErrors.value.display_name) fieldErrors.value.display_name = "";
}

function onCodeInput(value) {
    codeTouched.value = !!String(value ?? "").trim();
    if (fieldErrors.value.code) fieldErrors.value.code = "";
}

const previewMeta = computed(() => {
    const max = optionalInt(form.value.max_length);
    if (max !== null && !Number.isNaN(max)) return `0/${max}`;

    const min = optionalInt(form.value.min_length);
    if (min !== null && !Number.isNaN(min)) return `min ${min}`;

    return "";
});

function validateForm() {
    const name = form.value.display_name?.trim() || "";
    let code = form.value.code?.trim() || "";
    const min = optionalInt(form.value.min_length);
    const max = optionalInt(form.value.max_length);
    const errors = { display_name: "", code: "", lengths: "" };

    if (!name) {
        errors.display_name = "Enter a display name.";
    }

    if (!code && name) {
        code = nextFieldCode(codeFromName(name));
    }

    if (!code) {
        errors.code = "Enter a code or a display name to generate one.";
    } else if (!/^[a-z][a-z0-9_]*$/.test(code)) {
        errors.code = "Use snake_case, starting with a letter (for example receipt_number).";
    } else if (code.length > 100) {
        errors.code = "Keep the code to 100 characters or fewer.";
    } else {
        const duplicate = (items.value || []).some(
            (item) =>
                Number(item.id) !== Number(editingId.value) &&
                String(item.code || "").toLowerCase() === code.toLowerCase(),
        );
        if (duplicate) {
            errors.code = `Code "${code}" is already used by another field on this step.`;
        }
    }

    if (min !== null && (!Number.isInteger(min) || min < 0)) {
        errors.lengths = "Min must be a whole number, 0 or more.";
    } else if (max !== null && (!Number.isInteger(max) || max < 1)) {
        errors.lengths = "Max must be a whole number, 1 or more.";
    } else if (min !== null && max !== null && min > max) {
        errors.lengths = "Min can't be greater than max.";
    }

    form.value.code = code;
    const order = Number(form.value.display_order);
    form.value.display_order = Number.isFinite(order) ? Math.max(0, Math.floor(order)) : 0;
    fieldErrors.value = errors;

    if (errors.display_name) {
        focusName();
        return false;
    }
    if (errors.code) {
        codeField.value?.focus?.();
        return false;
    }
    if (errors.lengths) {
        const badMin = min !== null && (!Number.isInteger(min) || min < 0);
        (badMin ? minField.value : maxField.value)?.focus?.();
        return false;
    }
    return true;
}

function openAdd() {
    formError.value = "";
    editingId.value = null;
    codeTouched.value = false;
    clearFieldErrors();
    form.value = {
        display_name: "",
        code: "",
        is_required: false,
        display_order: items.value.length,
        min_length: null,
        max_length: null,
    };
    dialog.value = true;
}

function openEdit(item) {
    formError.value = "";
    editingId.value = item.id;
    codeTouched.value = true;
    clearFieldErrors();
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
    const code = form.value.code?.trim() || nextFieldCode(codeFromName(form.value.display_name));
    return {
        display_name: form.value.display_name.trim(),
        code,
        is_required: !!form.value.is_required,
        display_order: Number(form.value.display_order ?? 0),
        min_length: optionalInt(form.value.min_length),
        max_length: optionalInt(form.value.max_length),
    };
}

async function saveForm() {
    if (formSaving.value) return;
    if (!selectedStepId.value) {
        formError.value = "Pick a step first.";
        return;
    }
    if (!validateForm()) return;

    formError.value = "";
    const wasEditing = !!editingId.value;
    const stepId = Number(selectedStepId.value);
    formSaving.value = true;
    try {
        const payload = cleanPayload();
        if (wasEditing) {
            await update(workflowDefinitionId.value, stepId, editingId.value, payload);
        } else {
            await create(workflowDefinitionId.value, stepId, payload);
        }
        setStepCount(stepId, items.value.length);
        dialog.value = false;
        toastSuccess(
            wasEditing
                ? `Field "${payload.display_name}" updated.`
                : `Field "${payload.display_name}" added.`,
        );
    } catch (e) {
        formError.value = e?.response?.data?.message || "Save failed.";
    } finally {
        formSaving.value = false;
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
        steps.value = res.data.data ?? res.data ?? [];

        const counts = {};
        for (const step of steps.value) {
            counts[String(step.id)] = Number(step.step_data_count ?? 0);
        }
        stepCounts.value = counts;
    } catch (e) {
        error.value = e?.response?.data?.message || e?.message || "Failed to load steps.";
    } finally {
        stepsLoading.value = false;
    }
}

async function loadItems() {
    if (!selectedStepId.value) return;

    const stepId = Number(selectedStepId.value);
    const request = ++itemsRequest;
    error.value = "";

    try {
        await fetchAll(workflowDefinitionId.value, stepId);
        if (request !== itemsRequest || Number(selectedStepId.value) !== stepId) return;
        setStepCount(stepId, items.value.length);
    } catch (e) {
        if (request !== itemsRequest || Number(selectedStepId.value) !== stepId) return;
        error.value = e?.response?.data?.message || "Failed to load step data.";
    }
}

watch(selectedStepId, async (id, previous) => {
    if (!id) {
        itemsRequest += 1;
        items.value = [];
        return;
    }
    if (String(id) === String(previous)) return;
    items.value = [];
    await loadItems();
});

onMounted(async () => {
    document.addEventListener("mousedown", onDocumentPointerDown);
    document.addEventListener("keydown", onDocumentKeydown);

    await loadSteps();
    const sid = stepIdFromUrl.value;
    if (Number.isFinite(sid) && steps.value.some((step) => Number(step.id) === sid)) {
        selectedStepId.value = sid;
    } else if (steps.value.length) {
        selectedStepId.value = steps.value[0].id;
    }
});

onBeforeUnmount(() => {
    document.removeEventListener("mousedown", onDocumentPointerDown);
    document.removeEventListener("keydown", onDocumentKeydown);
});
</script>

<style scoped>
/* ---- Step Data page ---- */
.sd-page {
    --sd-field: #f4f6fb;
    --sd-hover: #f3f6fc;
    max-width: 980px;
    margin: 0 auto;
}

.sd-sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

.sd-top {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
}

.sd-badge {
    display: grid;
    flex: none;
    width: 48px;
    height: 48px;
    border-radius: 14px;
    background: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
    place-items: center;
}

.sd-title {
    min-width: 0;
}

.sd-title h1 {
    margin: 0;
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}

.sd-title p {
    margin: 2px 0 0;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}

.sd-back {
    display: inline-flex;
    align-items: center;
    flex: none;
    gap: 8px;
    height: 42px;
    margin-left: auto;
    padding: 0 16px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.15s, border-color 0.15s;
}

.sd-back:hover {
    background: var(--sd-hover);
}

.sd-back:focus-visible,
.sd-add:focus-visible,
.sd-trigger:focus-visible,
.sd-option:focus-visible,
.sd-ib:focus-visible,
.sd-tg:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.sd-info {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 22px;
    padding: 14px 16px;
    border-radius: 14px;
    background: rgba(var(--v-theme-primary), 0.1);
    font-size: 14px;
    line-height: 1.5;
}

.sd-info-ic {
    flex: none;
    margin-top: 1px;
    color: rgb(var(--v-theme-primary));
}

.sd-info b {
    color: rgb(var(--v-theme-primary));
}

.sd-lbl {
    margin: 0 0 10px;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}

/* ---- Step picker ---- */
.sd-dd {
    position: relative;
    margin-bottom: 22px;
}

.sd-trigger {
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    min-height: 68px;
    padding: 10px 14px 10px 10px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 16px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
    transition: border-color 0.15s, box-shadow 0.15s;
}

.sd-trigger:hover:not(:disabled) {
    border-color: rgba(var(--v-theme-primary), 0.45);
}

.sd-trigger:focus-visible,
.sd-trigger-open {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}

.sd-trigger:disabled {
    opacity: 0.65;
    cursor: default;
}

.sd-step-n {
    display: grid;
    flex: none;
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 16px;
    font-weight: 800;
    place-items: center;
}

.sd-step-tx {
    flex: 1;
    min-width: 0;
}

.sd-step-tx b {
    display: block;
    overflow: hidden;
    font-size: 16px;
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sd-step-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sd-count {
    flex: none;
    padding: 3px 10px;
    border-radius: 99px;
    background: var(--sd-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
}

.sd-chev {
    flex: none;
    color: rgb(var(--v-theme-secondary));
    transition: transform 0.2s;
}

.sd-chev-open {
    transform: rotate(180deg);
}

.sd-menu {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    left: 0;
    z-index: 20;
    max-height: 320px;
    padding: 8px;
    overflow: auto;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 18px;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 18px 40px -12px rgba(20, 33, 61, 0.3);
}

.sd-option {
    position: relative;
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    padding: 10px;
    border: 0;
    border-radius: 12px;
    background: transparent;
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
}

.sd-option:hover,
.sd-option:focus-visible {
    background: var(--sd-hover);
}

.sd-option-selected::before {
    position: absolute;
    top: 12px;
    bottom: 12px;
    left: -8px;
    width: 4px;
    border-radius: 0 4px 4px 0;
    background: rgb(var(--v-theme-primary));
    content: "";
}

.sd-option-n {
    display: grid;
    flex: none;
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 15px;
    font-weight: 800;
    place-items: center;
}

.sd-option-tx {
    flex: 1;
    min-width: 0;
}

.sd-option-tx b {
    display: block;
    overflow: hidden;
    font-size: 14.5px;
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sd-option-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12px;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sd-option-ck {
    flex: none;
    color: rgb(var(--v-theme-primary));
    opacity: 0;
}

.sd-option-ck-on {
    opacity: 1;
}

.sd-option-empty {
    padding: 18px 12px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
    text-align: center;
}

/* ---- Data fields card ---- */
.sd-card {
    overflow: hidden;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 20px;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
}

.sd-card-hd {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 18px 20px;
    border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.sd-card-hd h2 {
    margin: 0;
    font-size: 17px;
    font-weight: 800;
}

.sd-card-hd p {
    margin: 2px 0 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
}

.sd-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 8px;
    height: 44px;
    margin-left: auto;
    padding: 0 18px;
    border: 0;
    border-radius: 12px;
    background: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.15s, opacity 0.15s;
}

.sd-add:hover:not(:disabled) {
    filter: brightness(0.93);
}

.sd-add:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.sd-loading {
    display: flex;
    align-items: center;
    min-height: 260px;
    padding: 12px 0;
}

.sd-rows {
    width: 100%;
}

.sd-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 150px 90px 96px;
    align-items: center;
    gap: 12px;
    padding: 14px 20px;
    border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.sd-row:last-child {
    border-bottom: 0;
}

.sd-row-head {
    padding: 10px 20px;
    background: var(--sd-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}

.sd-row-item {
    transition: background 0.12s;
}

.sd-row-item:hover {
    background: var(--sd-hover);
}

.sd-field {
    min-width: 0;
}

.sd-field b {
    display: block;
    font-size: 15px;
    font-weight: 700;
    word-break: break-word;
}

.sd-field-meta {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 4px;
}

.sd-code {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 6px;
    background: var(--sd-field);
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12px;
}

.sd-limit {
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
}

.sd-req {
    display: flex;
    align-items: center;
    gap: 10px;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
    font-weight: 600;
}

.sd-on {
    color: #1b7a3d;
}

.sd-tg {
    position: relative;
    flex: none;
    width: 44px;
    height: 26px;
    padding: 0;
    border: 0;
    border-radius: 99px;
    background: #98a2b8;
    cursor: pointer;
    transition: background 0.2s, opacity 0.2s;
}

.sd-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
    content: "";
    transition: transform 0.2s;
}

.sd-tg[aria-checked="true"] {
    background: #1b7a3d;
}

.sd-tg[aria-checked="true"]::after {
    transform: translateX(18px);
}

.sd-tg:disabled {
    opacity: 0.55;
    cursor: wait;
}

.sd-order-cell {
    display: flex;
    align-items: center;
}

.sd-order {
    display: inline-grid;
    min-width: 34px;
    height: 30px;
    padding: 0 6px;
    border-radius: 9px;
    background: var(--sd-field);
    font-size: 14px;
    font-weight: 800;
    place-items: center;
}

.sd-actions {
    display: flex;
    gap: 6px;
    justify-content: flex-end;
}

.sd-ib {
    display: grid;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 0;
    border-radius: 10px;
    background: none;
    cursor: pointer;
    place-items: center;
    transition: background 0.15s, opacity 0.15s;
}

.sd-ib:disabled {
    opacity: 0.45;
    cursor: wait;
}

.sd-ib-edit {
    color: rgb(var(--v-theme-warning));
}

.sd-ib-edit:hover:not(:disabled) {
    background: rgba(var(--v-theme-warning), 0.12);
}

.sd-ib-delete {
    color: rgb(var(--v-theme-error));
}

.sd-ib-delete:hover:not(:disabled) {
    background: rgba(var(--v-theme-error), 0.1);
}

.sd-empty {
    padding: 56px 20px;
    text-align: center;
}

.sd-empty-icon {
    display: grid;
    width: 64px;
    height: 64px;
    margin: 0 auto 14px;
    border-radius: 20px;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    place-items: center;
}

.sd-empty-icon-error {
    background: rgba(var(--v-theme-error), 0.1);
    color: rgb(var(--v-theme-error));
}

.sd-empty h3 {
    margin: 0 0 4px;
    font-size: 17px;
}

.sd-empty p {
    margin: 0 0 18px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
}

.sd-empty .sd-add {
    margin: 0 auto;
}

/* ---- Add / Edit data field modal ---- */
.df-card {
    display: flex;
    flex-direction: column;
    max-height: 90vh;
    overflow: hidden;
}

.df-hd {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 20px 24px 12px;
}

.df-title {
    min-width: 0;
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}

.df-x {
    flex: none;
    margin-left: auto;
}

.df-form {
    display: flex;
    flex: 1 1 auto;
    flex-direction: column;
    min-height: 0;
}

.df-bd {
    flex: 1 1 auto;
    min-height: 0;
    padding: 4px 24px 10px;
    overflow-y: auto;
}

.df-f {
    margin-bottom: 16px;
}

.df-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}

.df-required {
    color: rgb(var(--v-theme-error));
}

.df-opt {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}

.df-help {
    margin: 6px 2px 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 12.5px;
}

.df-error {
    margin: 6px 2px 0;
    color: rgb(var(--v-theme-error));
    font-size: 12.5px;
    font-weight: 600;
}

.df-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}

.df-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}

.df-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}

.df-in :deep(.v-field--error) {
    background: rgb(var(--v-theme-surface));
}

.df-in-mono :deep(input) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14.5px;
}

.df-required-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 16px;
    padding: 12px 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}

.df-required-copy {
    min-width: 0;
}

.df-required-copy b {
    display: block;
    font-size: 14.5px;
}

.df-required-copy span {
    display: block;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

.df-tg {
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

.df-tg::after {
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

.df-tg[aria-checked="true"] {
    background: #1b7a3d;
}

.df-tg[aria-checked="true"]::after {
    transform: translateX(20px);
}

.df-tg:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.df-g3 {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
}

.df-g3 .df-f {
    margin-bottom: 0;
}

.df-length-error {
    margin-top: 8px;
}

.df-length-help {
    margin-top: 8px;
}

.df-sec-preview {
    margin: 16px 0 6px;
}

.df-sec-t {
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

.df-sec-t::after {
    flex: 1;
    height: 1px;
    background: rgba(var(--v-border-color), var(--v-border-opacity));
    content: "";
}

.df-preview {
    padding: 14px;
    border: 1.5px dashed rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}

.df-preview-label {
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: 600;
    word-break: break-word;
}

.df-preview-input {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    height: 44px;
    padding: 0 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
    background: #f4f6fb;
    color: rgb(var(--v-theme-secondary));
    font-size: 12.5px;
}

.df-preview-input span:first-child {
    margin-right: auto;
    color: #7b869e;
}

.df-preview-input span:last-child {
    white-space: nowrap;
}

.df-preview-input span:last-child:empty {
    display: none;
}

.df-ft {
    flex: none;
    justify-content: flex-end;
    gap: 10px;
    padding: 16px 24px max(20px, env(safe-area-inset-bottom, 0px));
}

.df-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}

.df-b-pri {
    min-width: 130px;
}

html.dark .sd-page {
    --sd-field: #1c2645;
    --sd-hover: #1d2745;
}

html.dark .sd-card {
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}

html.dark .sd-menu {
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.65);
}

html.dark .sd-info {
    background: rgba(var(--v-theme-primary), 0.14);
}

html.dark .sd-tg[aria-checked="true"],
html.dark .df-tg[aria-checked="true"] {
    background: #3fbf6f;
}

html.dark .sd-on {
    color: #3fbf6f;
}

html.dark .df-in :deep(.v-field) {
    background: #232b45;
}

html.dark .df-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.22);
}

html.dark .df-preview-input {
    background: #232b45;
}

html.dark .df-preview-input span:first-child {
    color: #9aa7c4;
}

@media (max-width: 720px) {
    :global(.df-dialog-content) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }

    :global(.df-dialog-content .df-card) {
        max-height: 94vh;
        border-radius: 24px 24px 0 0 !important;
    }

    .sd-back {
        padding: 0 12px;
    }

    .sd-back span {
        display: none;
    }

    .sd-card-hd {
        flex-wrap: wrap;
    }

    .sd-add {
        width: 100%;
        margin-left: 0;
    }

    .sd-row-head {
        display: none;
    }

    .sd-row {
        grid-template-columns: 1fr auto;
        grid-template-areas:
            "field actions"
            "req order";
        row-gap: 10px;
    }

    .sd-field {
        grid-area: field;
    }

    .sd-actions {
        grid-area: actions;
    }

    .sd-req {
        grid-area: req;
    }

    .sd-order-cell {
        grid-area: order;
        justify-self: end;
    }

    .df-g3 {
        grid-template-columns: 1fr;
    }

    .df-g3 .df-f + .df-f {
        margin-top: 12px;
    }

    .df-ft {
        flex-direction: column-reverse;
    }

    .df-b {
        width: 100%;
    }
}

@media (max-width: 520px) {
    .sd-top h1 {
        font-size: 22px;
    }

    .sd-badge {
        width: 44px;
        height: 44px;
    }

    .sd-step-tx b {
        font-size: 15px;
    }

    .sd-step-n {
        width: 40px;
        height: 40px;
    }

    .sd-menu {
        max-height: 280px;
    }

    .df-hd {
        padding: 20px 20px 12px;
    }

    .df-bd {
        padding: 4px 20px 10px;
    }

    .df-ft {
        padding: 16px 20px max(20px, env(safe-area-inset-bottom, 0px));
    }
}
</style>
