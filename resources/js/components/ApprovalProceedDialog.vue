<template>
    <v-dialog v-model="open" max-width="800" scrollable>
        <v-card rounded="xl" style="overflow: hidden">
            <div class="px-6 pt-4"><StepBadge :tx="tx" /></div>
            <v-card-title>
                {{ proceedModalTitle }}
                <div v-if="tx" class="text-caption text-medium-emphasis">
                    {{ tx.reference_number }} · {{ tx.title || 'N/A' }} · at {{ tx.current_step?.name }}
                </div>
            </v-card-title>
            <v-divider />
            <v-card-text class="proceed-scroll">
                    <ReturnBanner :info="null" />
                    <TableLoader v-if="loading" label="transaction" compact />

                <template v-else-if="tx">
                    <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-3">
                        {{ error }}
                    </v-alert>

                    <v-alert v-if="!forwardActions.length" type="info" variant="tonal" density="compact">
                        No forward move is available from this station for you. Open the transaction for other actions.
                    </v-alert>

                    <template v-else>
                        <!-- Only when a station has several forward routes. -->
                        <v-select
                            v-if="forwardActions.length > 1"
                            v-model="selectedRouteId"
                            :items="forwardOptions"
                            item-title="label"
                            item-value="value"
                            label="Proceed to"
                            variant="outlined"
                            density="compact"
                            rounded="0"
                            class="mb-3"
                            @update:model-value="resetWizardForRoute"
                        />

                        <ProceedWizard
                            v-if="selectedRouteId"
                            ref="wizardRef"
                            v-model:step="wizardStep"
                            v-model:remarks="remarks"
                            v-model:proceed-attachments="proceedAttachments"
                            v-model:attachment-name="attachmentName"
                            v-model:step-data-form="stepDataForm"
                            :tx-id="tx.id"
                            :requirements="tx.current_step_requirements || []"
                            :checklist="tx.current_step_checklist || []"
                            :fields="tx.current_step_fields"
                            :step-data="tx.current_step_data || []"
                            :prev-context="tx.previous_step_context || null"
                            :form="form"
                            :selected-action-label="selectedActionLabel"
                            :selected-route-id="selectedRouteId"
                            :is-return-selected="false"
                            :show-checklist="!skipReview"
                            :missing-required-upload-labels="missingRequiredUploadLabels"
                            :missing-required-tick-labels="missingRequiredTickLabels"
                            :missing-required-checklist-labels="missingRequiredChecklistLabels"
                            :missing-required-fields="missingRequiredFields"
                            :execute-error="executeError"
                            :saving="saving"
                            :saving-checklist="savingChecklist"
                            :saving-checklist-item-id="savingChecklistItemId"
                            :saving-requirement-id="savingRequirementId"
                            remarks-placeholder="Explain what you changed or fixed"
                            attachments-title="Additional files"
                            @toggle-requirement="onRequirementToggle"
                            @toggle-checklist="onChecklistToggle"
                            @requirement-uploaded="refreshTxPreservingForm"
                            @attachment-deleted="onAttachmentDeleted"
                        />
                    </template>
                </template>

                <v-alert v-else-if="error" type="error" variant="tonal" density="compact">
                    {{ error }}
                </v-alert>
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end">
                <v-btn v-if="tx" variant="text" prepend-icon="mdi-open-in-new" @click="openTransaction">Open transaction</v-btn>
                <v-spacer />
                <v-btn variant="text" @click="open = false">Cancel</v-btn>
                <template v-if="tx && selectedRouteId">
                    <v-btn v-if="wizardStep === 2 && !isSingleStepProceed && !skipReview" variant="text" @click="wizardStep = 1">Back</v-btn>
                    <v-btn v-if="wizardStep === 1 && !isSingleStepProceed && !skipReview" color="grey-darken-3" rounded="0" :disabled="saving || savingChecklist" @click="goWizardNext">Next</v-btn>
                    <v-btn v-if="wizardStep === 2 || skipReview || isSingleStepProceed" color="grey-darken-3" rounded="0" :loading="saving" :disabled="missingRequiredUploadLabels.length > 0 || missingRequiredTickLabels.length > 0 || missingRequiredChecklistLabels.length > 0 || missingRequiredFields.length > 0 || missingRequiredStepDataLabels.length > 0" @click="executeSelected">Proceed</v-btn>
                </template>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
// Proceed modal for the Approvals page. Mirrors the Proceed flow of
// pages/my/MyTransactionDetail.vue (same ProceedWizard, same gating), limited
// to forward moves — returns, jumps and finalize stay on the transaction page.
// Keep the gating computeds in sync with that page when its rules change.
import { computed, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useMyTransactions } from "@/composables/useMyTransactions";
import { useApi } from "@/composables/useApi";
import ProceedWizard from "@/components/ProceedWizard.vue";
import ReturnBanner from "@/components/ReturnBanner.vue";
import StepBadge from "@/components/StepBadge.vue";
import TableLoader from "@/components/TableLoader.vue";

const open = defineModel("open", { default: false });
const props = defineProps({
    txId: { type: [Number, String, null], default: null },
});
const emit = defineEmits(["proceeded", "changed"]);

const router = useRouter();
const { api } = useApi();
const { getOne, execute } = useMyTransactions();

const tx = ref(null);
const availableActions = ref([]);
const visitedStepIds = ref([]);
const loading = ref(false);
const saving = ref(false);
const error = ref("");
const executeError = ref("");

const wizardStep = ref(1);
const wizardRef = ref(null);
const selectedRouteId = ref(null);
const remarks = ref("");
const proceedAttachments = ref([]);
const attachmentName = ref("");
const form = ref({});
// Step-data draft keyed by definition code, prefilled from latest values.
const stepDataForm = ref({});

function hydrateStepDataForm() {
    const next = {};
    for (const row of tx.value?.current_step_data ?? []) {
        const code = row?.definition?.code;
        if (!code) continue;
        next[code] = row.value ?? "";
    }
    stepDataForm.value = next;
}
const savingChecklist = ref(false);
const savingChecklistItemId = ref(null);
const savingRequirementId = ref(null);

function formatApiError(e, fallback) {
    const errs = e?.response?.data?.errors;
    if (errs) {
        const detail = Object.values(errs).flat().join(" ");
        if (detail) return `${e?.response?.data?.message || fallback} ${detail}`;
    }
    return e?.response?.data?.message || fallback;
}

const forwardActions = computed(() => (availableActions.value || []).filter((a) => !a.is_return_route));

function labelForAction(a) {
    const name = a?.to_step?.name ?? `Step #${a.to_step_id ?? ""}`;
    const n = a?.to_step?.order_number;
    return n != null && n !== "" ? `${n}. ${name}` : `${name}`;
}

const forwardOptions = computed(() =>
    forwardActions.value.map((a) => ({ value: a.route_id, label: `Proceed → ${labelForAction(a)}` })),
);

const selectedAction = computed(() =>
    (availableActions.value || []).find((x) => Number(x.route_id) === Number(selectedRouteId.value)),
);
const selectedActionLabel = computed(() => (selectedAction.value ? labelForAction(selectedAction.value) : ""));

// Proceed modal title: Proceeding to "stepname" (office code). Name comes from
// the destination step (workflow_routes.to_step_id → workflow_steps); office
// code comes from the CURRENT step's Destination Office (where the paper is
// being sent from, e.g. General Service Office when on step 1).
function destStepForTitle() {
    const direct = selectedAction.value?.to_step;
    const routeId = Number(selectedRouteId.value);
    const route = (tx.value?.workflow_routes || []).find((r) => Number(r.id) === routeId);
    const toId = direct?.id ?? route?.to_step_id;
    if (toId != null) {
        const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(toId));
        if (s) return { ...direct, ...s, office: s.office ?? direct?.office ?? null };
    }
    return direct ?? null;
}
function currentOfficeForTitle() {
    const cur = tx.value?.current_step;
    if (cur?.office?.code || cur?.office?.name || cur?.stage) return cur;
    const cid = cur?.id;
    if (cid != null) {
        const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(cid));
        if (s) return s;
    }
    return cur ?? null;
}

// Single-line Proceed modal title: destination step name + current office code.
const proceedModalTitle = computed(() => {
    if (!selectedRouteId.value || !selectedAction.value) return "Proceed";
    const dest = destStepForTitle();
    const n = dest?.order_number;
    const name = dest?.name || dest?.code || (n != null && n !== "" ? `Step ${n}` : "");
    if (!name) return "Proceed";
    const cur = currentOfficeForTitle();
    const office = String(
        cur?.office?.code ?? cur?.office?.name ?? cur?.stage ??
        dest?.office?.code ?? dest?.office?.name ?? dest?.stage ?? "",
    ).trim();
    return office ? `Proceeding to "${name}" (${office})` : `Proceeding to "${name}"`;
});

// Step 1 → step 2 shows requirements only (same rule as the transaction page).
const isFirstStepTransition = computed(() =>
    Number(tx.value?.current_step?.order_number) === 1 &&
    Number(selectedAction.value?.to_step?.order_number) === 2,
);
// Step 1 stations skip the Review page entirely: step 1 holds no
// predecessor checklist, so Review would only ever be its empty state.
const isAtFirstStep = computed(() => Number(tx.value?.current_step?.order_number) === 1);
const skipReview = computed(() => isFirstStepTransition.value || isAtFirstStep.value);
const hasProceedRequirements = computed(() => (tx.value?.current_step_requirements || []).length > 0);
const isSingleStepProceed = computed(() => !hasProceedRequirements.value);

const missingRequiredUploadLabels = computed(() =>
    (tx.value?.current_step_requirements ?? [])
        .filter((r) => r?.pivot?.is_upload_required ?? r?.pivot?.is_required)
        .filter((r) => {
            const existing = (r.attachments || []).length;
            const staged = wizardRef.value?.getReqFiles?.(r.definition.id)?.length ?? 0;
            return existing + staged === 0;
        })
        .map((r) => r.definition?.name)
        .filter(Boolean),
);

const missingRequiredChecklistLabels = computed(() => {
    if (skipReview.value) return [];
    return (tx.value?.current_step_checklist ?? [])
        .filter((c) => c.is_required && !c.checked)
        .map((c) => c.name)
        .filter(Boolean);
});

// Every required requirement (tick-only AND upload rows like AR/Payroll)
// must be ticked: the top tick unlocks the upload card below.
const missingRequiredTickLabels = computed(() =>
    (tx.value?.current_step_requirements ?? [])
        .filter((r) => r?.pivot?.is_required)
        .filter((r) => !r.checked)
        .map((r) => r.definition?.name)
        .filter(Boolean),
);

const missingRequiredFields = computed(() => {
    const out = [];
    for (const row of tx.value?.current_step_fields ?? []) {
        if (!row?.definition?.required) continue;
        const v = form.value?.[row.definition.code];
        const empty = v === null || v === undefined || v === "" || (Array.isArray(v) && v.length === 0);
        if (empty) out.push(row.definition.name);
    }
    return out;
});

// Required step-data values still empty in the draft. Approval moves are
// forward-only, so no return exemption here.
const missingRequiredStepDataLabels = computed(() => {
    const out = [];
    for (const row of tx.value?.current_step_data ?? []) {
        if (!row?.definition?.is_required) continue;
        const v = stepDataForm.value?.[row.definition.code];
        if (v === null || v === undefined || String(v).trim() === "") {
            out.push(row.definition.display_name || row.definition.code);
        }
    }
    return out;
});

function hydrateForm() {
    const next = {};
    for (const row of tx.value?.current_step_fields ?? []) {
        const def = row.definition;
        const val = row.value;
        if (def.type === "multiselect") next[def.code] = Array.isArray(val) ? val : [];
        else if (def.type === "boolean") next[def.code] = !!val;
        else next[def.code] = val ?? null;
    }
    form.value = next;
}

function applyResponse(nextTx, meta) {
    tx.value = nextTx;
    availableActions.value = meta?.available_actions ?? [];
    visitedStepIds.value = meta?.visited_step_ids ?? [];
}

// Files already saved on this station, prefilled when re-walking a station.
// Move-level only: requirement files already show in their requirement
// sections above, so they are excluded from the below-remarks list.
function currentStepAttachments() {
    const cur = Number(tx.value?.current_step?.id);
    return (tx.value?.attachments || [])
        .filter((a) => Number(a.workflow_step_id) === cur)
        .filter((a) => a.requirement_definition_id == null || Number(a.requirement_definition_id) === 0);
}

function resetWizardForRoute() {
    const destId = selectedAction.value?.to_step?.id;
    const destVisited = destId != null && (visitedStepIds.value || []).map(Number).includes(Number(destId));
    proceedAttachments.value = destVisited ? [...currentStepAttachments()] : [];
    attachmentName.value = "";
    executeError.value = "";
    // Single-page mode (step 1 → step 2): everything happens on the
    // Requirements page (now page 2). Otherwise start on Review (page 1).
    wizardStep.value = skipReview.value ? 2 : 1;
    wizardRef.value?.clearReqFiles?.();
}

async function load() {
    if (!props.txId) return;
    loading.value = true;
    error.value = "";
    tx.value = null;
    remarks.value = "";
    attachmentName.value = "";
    try {
        const res = await getOne(props.txId);
        applyResponse(res.tx, res.meta);
        hydrateForm();
        hydrateStepDataForm();
        // The usual case is exactly one forward route: pick it for the user.
        selectedRouteId.value = forwardActions.value.length === 1 ? forwardActions.value[0].route_id : null;
        if (selectedRouteId.value) resetWizardForRoute();
    } catch (e) {
        error.value = formatApiError(e, "Failed to load transaction.");
    } finally {
        loading.value = false;
    }
}

watch(open, (isOpen) => {
    if (isOpen) load();
});

// Re-fetch without wiping staged station-info `form` (uploads refresh the
// requirement list only; fields persist on Proceed).
async function refreshTxPreservingForm() {
    try {
        const res = await getOne(props.txId);
        applyResponse(res.tx, res.meta);
        emit("changed", res.tx);
    } catch (e) {
        error.value = formatApiError(e, "Failed to refresh transaction.");
    }
}

function onAttachmentDeleted(id) {
    wizardRef.value?.removeReqFile?.(id);
    refreshTxPreservingForm();
}

async function goWizardNext() {
    await refreshTxPreservingForm();
    wizardStep.value = 2;
}

async function onChecklistToggle(item, checked) {
    if (!item?.id || !!item.checked === !!checked) return;
    savingChecklist.value = true;
    savingChecklistItemId.value = item.id;
    error.value = "";
    try {
        const url = `/api/transactions/${props.txId}/checklist/${item.id}/check`;
        const res = checked ? await api.post(url) : await api.delete(url);
        applyResponse(res.data.data ?? res.data, res.data.meta);
        emit("changed", tx.value);
    } catch (e) {
        error.value = formatApiError(e, checked ? "Checklist check failed." : "Checklist uncheck failed.");
    } finally {
        savingChecklist.value = false;
        savingChecklistItemId.value = null;
    }
}

async function onRequirementToggle(req, checked) {
    if (!req?.definition?.id || !!req.checked === !!checked) return;
    savingChecklist.value = true;
    savingRequirementId.value = req.definition.id;
    error.value = "";
    try {
        const url = `/api/transactions/${props.txId}/requirements/${req.definition.id}/check`;
        const res = checked ? await api.post(url) : await api.delete(url);
        applyResponse(res.data.data ?? res.data, res.data.meta);
        emit("changed", tx.value);
    } catch (e) {
        error.value = formatApiError(e, checked ? "Requirement check failed." : "Requirement uncheck failed.");
    } finally {
        savingChecklist.value = false;
        savingRequirementId.value = null;
    }
}

async function executeSelected() {
    saving.value = true;
    error.value = "";
    executeError.value = "";
    try {
        const payloadFields = { ...form.value };
        for (const row of tx.value?.current_step_fields ?? []) {
            const def = row.definition;
            if (def.type === "multiselect" && !Array.isArray(payloadFields[def.code])) payloadFields[def.code] = [];
            if ((def.type === "number" || def.type === "currency") &&
                payloadFields[def.code] !== null && payloadFields[def.code] !== "") {
                payloadFields[def.code] = Number(payloadFields[def.code]);
            }
            if (def.type === "boolean") payloadFields[def.code] = !!payloadFields[def.code];
        }

        const res = await execute(props.txId, {
            route_id: selectedRouteId.value,
            remarks: remarks.value || null,
            field_values: payloadFields,
            attachment_ids: (proceedAttachments.value || []).map((a) => a.id),
            step_data: { ...(stepDataForm.value || {}) },
        });

        open.value = false;
        emit("proceeded", res.tx);
    } catch (e) {
        executeError.value = formatApiError(e, "Proceed failed.");
    } finally {
        saving.value = false;
    }
}

function openTransaction() {
    open.value = false;
    router.push(`/my/transactions/${props.txId}`);
}
</script>

<style scoped>
/* Slim inner scroll: keeps scrolling inside the curved modal. */
.proceed-scroll {
    max-height: 70vh;
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: rgba(0, 0, 0, 0.3) transparent;
    padding-right: 8px;
}
.proceed-scroll::-webkit-scrollbar {
    width: 4px;
}
.proceed-scroll::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.25);
    border-radius: 999px;
}
.proceed-scroll::-webkit-scrollbar-track {
    background: transparent;
}
</style>
