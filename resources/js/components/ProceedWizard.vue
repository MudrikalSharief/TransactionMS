<template>
    <div>
        <v-stepper v-if="showChecklist && hasProceedContent" v-model="step" flat hide-actions alt-labels class="wizard-stepper mb-2">
            <v-stepper-header>
                <v-stepper-item :value="1" title="Review" subtitle="Checklist & proceed" complete-icon="mdi-check" />
                <v-divider />
                <v-stepper-item :value="2" title="Requirements" subtitle="Upload files" complete-icon="mdi-check" />
            </v-stepper-header>
        </v-stepper>

        <v-window v-model="step">
            <!-- PAGE 1: review — requirements status + checklist ticks.
                 First page in two-page mode; the only page in single-step
                 (checklist-only) mode where its footer allows Proceed. -->
            <v-window-item v-if="showChecklist" :value="1">
                <!-- Single-step fallback: no requirements, so station info lives here -->
                <template v-if="!hasRequirements && ((fields || []).length || (stepData || []).length)">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />
                    <StepDataFields v-model:form="stepDataForm" :step-data="stepData" :saving="saving" />
                    <v-divider class="my-3" />
                </template>

                <!-- Checklist: tick to confirm. Required ticks block Proceed. -->
                <div class="text-subtitle-2 font-weight-bold mb-1">Checklist</div>
                <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                    Return action — checklist not required.
                </div>
                <div v-else-if="!(checklist || []).length" class="text-caption text-medium-emphasis mb-2">
                    No checklist items for this station.
                </div>
                <div v-else>
                    <div v-if="hasPrevColumnChecklist" class="text-caption text-medium-emphasis mb-2">
                        <b>Prev</b> shows what the previous station ticked (read-only).
                        <b>Verify</b> is your tick — mark it only when you've seen the hard copy. Required items must be verified before you can Proceed.
                    </div>
                    <div v-else class="text-caption text-medium-emphasis mb-2">
                        Tick each item as done. Required items must be ticked before you can Proceed.
                    </div>
                    <div v-if="hasPrevColumnChecklist" class="d-flex align-center ga-2">
                        <span style="width: 44px" class="text-caption text-medium-emphasis text-center">Prev</span>
                        <span class="text-caption text-medium-emphasis">Verify</span>
                    </div>
                    <div
                        v-for="c in (checklist || [])"
                        :key="c.id"
                        class="d-flex align-center ga-2 py-1"
                    >
                        <div v-if="hasPrevColumnChecklist" style="width: 44px" class="d-flex justify-center">
                        <v-checkbox
                            :model-value="!!c.prev_checked"
                            :class="{ 'prev-tick-done': c.prev_checked }"
                            disabled
                            density="compact"
                            hide-details="auto"
                            style="flex: 0 0 auto; margin: 0"
                            :title="prevCheckTitle(c)"
                        />
                        </div>
                        <v-checkbox
                            :model-value="!!c.checked"
                            :label="`${c.name}${c.is_required ? ' (required)' : ''}`"
                            density="compact"
                            hide-details="auto"
                            style="flex: 1 1 auto"
                            :disabled="saving || savingChecklist"
                            :loading="savingChecklist && savingChecklistItemId === c.id"
                            @update:model-value="(v) => emit('toggle-checklist', c, v)"
                        />
                        <v-btn
                            v-for="a in viewableFiles(c)"
                            :key="a.id"
                            size="x-small"
                            variant="tonal"
                            color="info"
                            rounded="0"
                            :href="fileViewUrl(a)"
                            target="_blank"
                            rel="noopener"
                            :title="`View ${a.original_name}`"
                            @click.stop
                        >
                            <v-icon start size="x-small">mdi-eye</v-icon>View
                        </v-btn>
                    </div>
                </div>

                <!-- Single-step mode only (no requirements): remarks + move
                     attachments live here so checklist-only flows can Proceed. -->
                <ProceedFooter
                    v-if="!hasRequirements"
                    v-model:remarks="remarks"
                    v-model:proceed-attachments="proceedAttachments"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :is-return-selected="isReturnSelected"
                    :show-checklist="showChecklist"
                    :missing-required-upload-labels="missingRequiredUploadLabels"
                    :missing-required-tick-labels="missingRequiredTickLabels"
                    :missing-required-checklist-labels="missingRequiredChecklistLabels"
                    :missing-required-fields="missingRequiredFields"
                    :execute-error="executeError"
                    :remarks-label="remarksLabel"
                    :remarks-placeholder="remarksPlaceholder"
                    :attachments-title="attachmentsTitle"
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                />
            </v-window-item>

            <!-- PAGE 2: current-step requirements + per-item uploads + station info.
                 Last page in two-page mode; the only page in single-page mode
                 (step 1 → step 2, no checklist): remarks + move attachments
                 render below so it never shows a second screen. -->
            <v-window-item v-if="hasRequirements || hasStepData || !showChecklist" :value="2">
                <template v-if="(fields || []).length">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />

                    <v-divider class="my-3" />
                </template>
                <StepDataFields v-model:form="stepDataForm" :step-data="stepData" :saving="saving" />
                <div class="d-flex justify-space-between align-baseline mb-2">
                    <div class="text-subtitle-2 font-weight-bold">Requirements to proceed</div>
                    <div v-if="(requirements || []).length" class="text-caption" :class="requirementsComplete ? 'text-success' : 'text-medium-emphasis'">
                        {{ checkedRequirementsCount }} of {{ (requirements || []).length }} complete
                    </div>
                </div>

                <div v-if="!(isReturnSelected && !(requirements || []).length) && (requirements || []).length" class="d-flex flex-column ga-3">
                    <!-- Tick group: previous-station mirror (Prev, display-only)
                        + current verify tick. Ticking a required row unlocks
                        its section below. Step 1 has no predecessor, so it
                        renders today's single checkbox. -->
                    <div v-if="sortedRequirements.length" class="d-flex flex-column">
                        <div v-if="hasPrevColumn" class="d-flex align-center ga-2">
                            <span style="width: 44px" class="text-caption text-medium-emphasis text-center">Prev</span>
                            <span class="text-caption text-medium-emphasis">Verify</span>
                        </div>
                        <div
                            v-for="r in sortedRequirements"
                            :key="r.definition.id"
                            class="d-flex align-center ga-2 py-1"
                        >
                            <div v-if="hasPrevColumn" style="width: 44px" class="d-flex justify-center">
                            <v-checkbox
                                :model-value="!!r.prev_checked"
                                :class="{ 'prev-tick-done': r.prev_checked }"
                                disabled
                                density="compact"
                                hide-details="auto"
                                style="flex: 0 0 auto; margin: 0"
                                :title="prevTickTitle(r)"
                            />
                            </div>
                            <v-checkbox
                                :model-value="!!r.checked"
                                :label="r.definition.name"
                                density="compact"
                                hide-details="auto"
                                style="flex: 0 1 auto"
                                :disabled="saving || savingChecklist"
                                :loading="savingChecklist && savingRequirementId === r.definition.id"
                                @update:model-value="(v) => emit('toggle-requirement', r, v)"
                            />
                            <v-chip v-if="r?.pivot?.is_required" size="x-small" variant="tonal" :color="r.checked ? 'success' : 'warning'" rounded="lg"><v-icon v-if="r.checked" start size="x-small">mdi-check</v-icon>Required</v-chip>
                            <v-chip v-else size="x-small" variant="tonal" color="grey" rounded="lg">optional</v-chip>
                        </div>
                    </div>
                    <v-card
                        v-if="sortedRequirements.length"
                        rounded="lg"
                        border
                        variant="outlined"
                        class="pa-3"
                    >
                        <div
                            v-for="(r, idx) in uploadFirstRequirements"
                            :key="r.definition.id"
                        >
                            <v-divider v-if="idx > 0" class="my-3" />
                            <div :style="isUploadLocked(r) ? 'opacity: 0.6' : ''">
                        <!-- Upload rows: status flip chip. Tick-only rows: optional chip. -->
                        <div class="d-flex align-center ga-2 mb-2">
                            <span class="font-weight-medium text-body-1">{{ r.definition.name }}</span>
                            <v-spacer />
                            <v-chip v-if="uploadRequired(r)" size="x-small" variant="tonal" :color="hasReqFiles(r) ? 'success' : 'error'" rounded="lg">
                                <v-icon start size="x-small">{{ hasReqFiles(r) ? 'mdi-check' : 'mdi-upload' }}</v-icon>{{ hasReqFiles(r) ? 'file uploaded' : 'upload required' }}
                            </v-chip>
                            <v-chip v-else size="x-small" variant="tonal" color="grey" rounded="lg">optional</v-chip>
                            <v-chip
                                v-if="mergedReqAttachments(r).length"
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                rounded="lg"
                            >
                                <v-icon start size="x-small">mdi-paperclip</v-icon>{{ mergedReqAttachments(r).length }}
                            </v-chip>
                        </div>
                        <!-- Picker above, uploaded files at the bottom. -->
                        <AttachmentUploader
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            :requirement-id="r.definition.id"
                            :model-value="getReqFiles(r.definition.id)"
                            :hint-text="uploadRequired(r) ? reqHintText(r) : ''"
                            :hint-type="reqHintType(r)"
                            :show-list="false"
                            minimal
                            :show-header="false"
                            file-action="download"
                            :disabled="isUploadLocked(r) || saving || savingChecklist"
                            @update:model-value="(files) => setReqFiles(r.definition.id, files)"
                            @uploaded="() => emit('requirement-uploaded', r.definition.id)"
                            @deleted="(id) => emit('attachment-deleted', id)"
                        />
                        <AttachmentList
                            :items="mergedReqAttachments(r)"
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            detailed
                            action="download"
                            @deleted="(id) => onReqAttachmentDeleted(r, id)"
                        />
                            </div>
                        </div>
                    </v-card>
                    <div class="text-caption text-medium-emphasis">PDF only, up to 20 MB per file. Tick a box above to enable its uploads.</div>
                </div>
                <ProceedFooter
                    v-model:remarks="remarks"
                    v-model:proceed-attachments="proceedAttachments"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :is-return-selected="isReturnSelected"
                    :show-checklist="showChecklist"
                    :missing-required-upload-labels="missingRequiredUploadLabels"
                    :missing-required-tick-labels="missingRequiredTickLabels"
                    :missing-required-checklist-labels="missingRequiredChecklistLabels"
                    :missing-required-fields="missingRequiredFields"
                    :execute-error="executeError"
                    :remarks-label="remarksLabel"
                    :remarks-placeholder="remarksPlaceholder"
                    :attachments-title="attachmentsTitle"
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                />
            </v-window-item>
        </v-window>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import StepInfoFields from '@/components/StepInfoFields.vue'
import StepDataFields from '@/components/StepDataFields.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import AttachmentList from '@/components/AttachmentList.vue'
import ProceedFooter from '@/components/ProceedFooter.vue'
import { fileViewUrl, isOfficeDoc } from '@/composables/useFileView'

// Wizard step + remarks + move-level attachments are two-way bound to the parent
// so staged station-info `form` (mutated in place) is never wiped.
const step = defineModel('step', { default: 1 })
const remarks = defineModel('remarks', { default: '' })
const proceedAttachments = defineModel('proceedAttachments', { default: () => [] })
// Step-data draft keyed by definition code; sent as `step_data` on Proceed.
const stepDataForm = defineModel('stepDataForm', { default: () => ({}) })

const props = defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    // tx.current_step_requirements — current step only.
    requirements: { type: Array, default: () => [] },
    // tx.current_step_checklist — mirrors the previous station's requirements.
    checklist: { type: Array, default: () => [] },
    // tx.current_step_fields
    fields: { type: Array, default: () => [] },
    // tx.current_step_data — per-step text values (e.g. receipt number).
    stepData: { type: Array, default: () => [] },
    // Shared page draft object, mutated in place by StepInfoFields.
    form: { type: Object, required: true },
    selectedActionLabel: { type: String, default: '' },
    selectedRouteId: { type: [Number, String, null], default: null },
    isReturnSelected: { type: Boolean, default: false },
    // False for step 1 → step 2: requirements only, checklist hidden entirely.
    showChecklist: { type: Boolean, default: true },
    missingRequiredUploadLabels: { type: Array, default: () => [] },
    missingRequiredTickLabels: { type: Array, default: () => [] },
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    saving: { type: Boolean, default: false },
    savingChecklist: { type: Boolean, default: false },
    savingChecklistItemId: { type: [Number, String, null], default: null },
    savingRequirementId: { type: [Number, String, null], default: null },
    remarksLabel: { type: String, default: 'Remarks (optional)' },
    remarksPlaceholder: { type: String, default: '' },
    attachmentsTitle: { type: String, default: 'Other attachments (optional)' },
})

// Page 2 holds the uploads. In single-page mode (step 1 → step 2) it is the
// only page: remarks + move attachments render below the uploads.
const hasRequirements = computed(() => (props.requirements || []).length > 0)
// Per-step text data present on this station (receipt number, etc.).
const hasStepData = computed(() => (props.stepData || []).length > 0)
// Header counter (visual only): ticked / total. Gating still uses parents' missingRequired*.
const checkedRequirementsCount = computed(() => (props.requirements || []).filter((r) => !!r.checked).length)
const requirementsComplete = computed(
    () => (props.requirements || []).length > 0 && checkedRequirementsCount.value >= (props.requirements || []).length,
)
const hasProceedContent = computed(
    () => hasRequirements.value || hasStepData.value || (props.checklist || []).length > 0 || (props.fields || []).length > 0,
)

// Page 2 display order: required first, then tick-only rows before
// file-input (uploader) rows within each band. Further ties keep backend
// display_order, then name. Length/empty checks keep using props.requirements.
const sortedRequirements = computed(() => {
    return [...(props.requirements || [])]
        .map((r, i) => ({ r, i }))
        .sort((a, b) => {
            const ar = a.r?.pivot?.is_required ? 0 : 1
            const br = b.r?.pivot?.is_required ? 0 : 1
            if (ar !== br) return ar - br
            const au = uploadRequired(a.r) ? 1 : 0
            const bu = uploadRequired(b.r) ? 1 : 0
            if (au !== bu) return au - bu
            const ao = a.r?.pivot?.display_order ?? a.i
            const bo = b.r?.pivot?.display_order ?? b.i
            if (ao !== bo) return ao - bo
            return String(a.r?.definition?.name ?? '').localeCompare(String(b.r?.definition?.name ?? ''))
        })
        .map((x) => x.r)
})

// First (Prev) column shows only when some requirement carries a
// previous-station tick — step 1 has no predecessor, so it keeps the
// single-checkbox layout.
const hasPrevColumn = computed(() => (props.requirements || []).some((r) => !!r.prev_step))

function prevTickTitle(r) {
    if (!r.prev_step) return 'No previous station'
    const who = r.prev_checked_by?.name ? ` by ${r.prev_checked_by.name}` : ''
    const where = r.prev_step?.name ? ` at ${r.prev_step.name}` : ''
    return r.prev_checked ? `Checked${where}${who}` : `Not checked${where}`
}

// Same mirror for the Review checklist: first column shows only when
// some item carries its predecessor requirement's tick.
const hasPrevColumnChecklist = computed(() => (props.checklist || []).some((c) => !!c.prev_step))

function prevCheckTitle(c) {
    if (!c.prev_step) return 'No previous station'
    const who = c.prev_checked_by?.name ? ` by ${c.prev_checked_by.name}` : ''
    const where = c.prev_step?.name ? ` at ${c.prev_step.name}` : ''
    return c.prev_checked ? `Checked${where}${who}` : `Not checked${where}`
}

// Group card order: true upload inputs first, then tick-only sections.
// Stable sort preserves the required-first order inside each band.
const uploadFirstRequirements = computed(() => [...sortedRequirements.value].sort(
    (a, b) => (uploadRequired(a) ? 0 : 1) - (uploadRequired(b) ? 0 : 1),
))

const emit = defineEmits([
    'toggle-requirement',
    'toggle-checklist',
    'requirement-uploaded',
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
])

function hasReqFiles(r) {
    return mergedReqAttachments(r).length > 0
}

// Required rows stay locked until their top tick is checked
// (upload cards + optional pickers alike; return mode exempts the
// lock; optional rows never lock).
function isUploadLocked(r) {
    if (props.isReturnSelected) return false
    if (!r?.pivot?.is_required) return false
    return !r.checked
}

// Inline status beside the picker button. Success shows no text — the
// section and top chips flip to their done states instead.
function reqHintText(r) {
    if (isUploadLocked(r)) return `Tick ${r.definition.name} above to enable uploads.`
    if (hasReqFiles(r)) return ''
    if (!props.isReturnSelected) return 'Attach at least one file to unlock Proceed.'
    return ''
}

function reqHintType(r) {
    return 'error'
}

// Single list above the input: server files + staged session files,
// deduped by id (server copy wins after refresh).
function mergedReqAttachments(r) {
    const server = r.attachments || []
    const staged = getReqFiles(r.definition.id) || []
    const seen = new Set(server.map((a) => a.id))
    return [...server, ...staged.filter((a) => !seen.has(a.id))]
}

// Delete from the merged list: staged files drop from local state,
// server files go through the parent's persisted-delete path.
function onReqAttachmentDeleted(r, id) {
    const staged = getReqFiles(r.definition.id) || []
    if (staged.some((a) => a.id === id)) {
        setReqFiles(r.definition.id, staged.filter((a) => a.id !== id))
        return
    }
    emit('attachment-deleted', id)
}

// LINE 1 marker reads is_required; LINE 2 gate reads is_upload_required
// (falls back to is_required for payloads that predate the split).
function uploadRequired(r) {
    return !!((r?.pivot?.is_upload_required ?? r?.pivot?.is_required) ?? false)
}

// Files opened in a new tab: PDFs/images/text render natively, office
// docs (docx/xlsx/ppt) go through the Google Docs viewer fallback.
function isViewable(a) {
    if (isOfficeDoc(a)) return true
    const mime = String(a?.mime || '').toLowerCase()
    if (
        mime === 'application/pdf' ||
        mime.startsWith('image/') ||
        mime.startsWith('text/')
    ) return true
    return /\.(pdf|png|jpe?g|gif|webp|svg|bmp|txt|csv|log|docx?|xlsx?|pptx?|odt|ods|odp|rtf)$/i.test(String(a?.original_name || ''))
}

function viewableFiles(c) {
    return (c?.attachments || []).filter(isViewable)
}

// Files uploaded per requirement in this wizard session. Server already
// persists them (requirement_definition_id), this is only for instant counts.
const reqFiles = ref({})

function getReqFiles(id) {
    return reqFiles.value[id] || []
}

function setReqFiles(id, files) {
    reqFiles.value = { ...reqFiles.value, [id]: [...(files || [])] }
}

function clearReqFiles() {
    reqFiles.value = {}
}

defineExpose({ clearReqFiles, getReqFiles })
</script>

<style scoped>
.wizard-stepper {
    background: transparent;
}

/* Auto-filled Prev ticks: subtle green when checked. Unchecked Prev
   boxes keep Vuetify's default grey. Dynamic class (not Vuetify state
   classes) so only checked mirrors are recolored. */
:deep(.prev-tick-done.v-input--disabled),
:deep(.prev-tick-done.v-selection-control--disabled) {
    opacity: 1;
}
:deep(.prev-tick-done .v-selection-control__input > .v-icon) {
    color: #81C784;
    opacity: .9;
}
</style>
