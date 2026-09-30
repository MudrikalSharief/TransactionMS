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
                <template v-if="!hasRequirements && (fields || []).length">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />
                    <v-divider class="my-3" />
                </template>

                <!-- Requirements status: file presence only (required = must upload). -->
                <template v-if="hasRequirements">
                    <div class="text-subtitle-2 font-weight-bold mb-1">Requirements</div>
                    <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                        Return action — uploads optional.
                    </div>
                    <div v-else class="text-caption text-medium-emphasis mb-2">
                        Required items show as ready only when a file is attached — press Next to upload.
                    </div>
                    <div
                        v-for="r in (requirements || [])"
                        :key="`req-status-${r.definition.id}`"
                        class="d-flex align-center ga-2 py-1"
                    >
                        <v-icon size="small" :color="hasReqFiles(r) ? 'success' : ((r?.pivot?.is_upload_required ?? r?.pivot?.is_required) && !isReturnSelected ? 'error' : 'grey')">
                            {{ hasReqFiles(r) ? 'mdi-check-circle' : ((r?.pivot?.is_upload_required ?? r?.pivot?.is_required) && !isReturnSelected ? 'mdi-alert-circle-outline' : 'mdi-circle-outline') }}
                        </v-icon>
                        <span class="text-body-2">
                            {{ r.definition.name }}
                            <span v-if="(r?.pivot?.is_upload_required ?? r?.pivot?.is_required)" class="text-error font-weight-bold">*</span>
                            <span v-else class="text-medium-emphasis">(optional)</span>
                        </span>
                        <v-chip v-if="hasReqFiles(r)" size="x-small" variant="tonal" color="success" rounded="0">file ready</v-chip>
                        <v-chip v-else-if="(r?.pivot?.is_upload_required ?? r?.pivot?.is_required) && !isReturnSelected" size="x-small" variant="tonal" color="error" rounded="0">file required</v-chip>
                    </div>
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
                    <div class="text-caption text-medium-emphasis mb-2">
                        Tick each item as done. Required items must be ticked before you can Proceed.
                    </div>
                    <div
                        v-for="c in (checklist || [])"
                        :key="c.id"
                        class="d-flex align-center ga-2 py-1"
                    >
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
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                />
            </v-window-item>

            <!-- PAGE 2: current-step requirements + per-item uploads + station info.
                 Last page in two-page mode; the only page in single-page mode
                 (step 1 → step 2, no checklist): remarks + move attachments
                 render below so it never shows a second screen. -->
            <v-window-item v-if="hasRequirements || !showChecklist" :value="2">
                <template v-if="(fields || []).length">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />

                    <v-divider class="my-3" />
                </template>
                <div class="text-subtitle-2 font-weight-bold mb-2">Requirements to proceed</div>

                <div v-if="!(isReturnSelected && !(requirements || []).length) && (requirements || []).length" class="d-flex flex-column ga-3">
                    <!-- Tick group: every requirement (tick-only first, then uploads).
                        Ticking a required upload row unlocks its card below. -->
                    <div v-if="sortedRequirements.length" class="d-flex flex-column">
                        <div
                            v-for="r in sortedRequirements"
                            :key="r.definition.id"
                            class="d-flex align-center ga-2 py-1"
                        >
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
                            <v-chip v-if="r?.pivot?.is_required" size="x-small" variant="tonal" color="warning" rounded="0">required</v-chip>
                        </div>
                    </div>
                    <v-sheet
                        v-if="uploadRequirements.length"
                        rounded="0"
                        border
                        class="pa-3"
                    >
                        <div
                            v-for="(r, idx) in uploadRequirements"
                            :key="r.definition.id"
                        >
                            <v-divider v-if="idx > 0" class="my-3" />
                            <div :style="isUploadLocked(r) ? 'opacity: 0.6' : ''">
                        <!-- LINE 1: TITLE (is_required). Upload rows only reach here. -->
                        <div class="d-flex align-center ga-2">
                            <v-icon size="small" :color="reqStatusColor(r)">
                                {{ reqStatusIcon(r) }}
                            </v-icon>
                            <span class="font-weight-bold text-h6">{{ r.definition.name }}</span>
                            <span v-if="r?.pivot?.is_required" class="text-error font-weight-bold" title="Required item">*</span>
                            <v-chip v-if="r?.pivot?.is_required" size="x-small" variant="tonal" color="warning" rounded="0">required</v-chip>
                            <v-chip size="x-small" variant="tonal" color="error" rounded="0">
                                <v-icon start size="x-small">mdi-upload</v-icon>upload required
                            </v-chip>
                            <v-spacer />
                            <v-chip
                                v-if="mergedReqAttachments(r).length"
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                rounded="0"
                            >
                                <v-icon start size="x-small">mdi-paperclip</v-icon>{{ mergedReqAttachments(r).length }}
                            </v-chip>
                        </div>
                        <div v-if="r.definition.description" class="text-caption text-medium-emphasis mt-1 mb-2">
                            {{ r.definition.description }}
                        </div>
                        <!-- LINE 2: FILE INPUT (is_upload_required) -->
                        <AttachmentList
                            :items="mergedReqAttachments(r)"
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            compact
                            action="download"
                            @deleted="(id) => onReqAttachmentDeleted(r, id)"
                        />
                        <AttachmentUploader
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            :requirement-id="r.definition.id"
                            :model-value="getReqFiles(r.definition.id)"
                            :hint-text="reqHintText(r)"
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
                            </div>
                        </div>
                    </v-sheet>
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
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                />
            </v-window-item>
        </v-window>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import StepInfoFields from '@/components/StepInfoFields.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import AttachmentList from '@/components/AttachmentList.vue'
import ProceedFooter from '@/components/ProceedFooter.vue'
import { fileViewUrl, isOfficeDoc } from '@/composables/useFileView'

// Wizard step + remarks + move-level attachments are two-way bound to the parent
// so staged station-info `form` (mutated in place) is never wiped.
const step = defineModel('step', { default: 1 })
const remarks = defineModel('remarks', { default: '' })
const proceedAttachments = defineModel('proceedAttachments', { default: () => [] })

const props = defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    // tx.current_step_requirements — current step only.
    requirements: { type: Array, default: () => [] },
    // tx.current_step_checklist — mirrors the previous station's requirements.
    checklist: { type: Array, default: () => [] },
    // tx.current_step_fields
    fields: { type: Array, default: () => [] },
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
})

// Page 2 holds the uploads. In single-page mode (step 1 → step 2) it is the
// only page: remarks + move attachments render below the uploads.
const hasRequirements = computed(() => (props.requirements || []).length > 0)
const hasProceedContent = computed(
    () => hasRequirements.value || (props.checklist || []).length > 0 || (props.fields || []).length > 0,
)

// Page 2 display order: tick-only ("Received hard copy") cards first,
// file-input (uploader) cards below. Within each group preserve backend
// display_order, then name. Length/empty checks keep using props.requirements.
const sortedRequirements = computed(() => {
    return [...(props.requirements || [])]
        .map((r, i) => ({ r, i }))
        .sort((a, b) => {
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

// Page 2 split: tick-only rows first (plain), upload cards below.
const tickRequirements = computed(() => sortedRequirements.value.filter((r) => !uploadRequired(r)))
const uploadRequirements = computed(() => sortedRequirements.value.filter((r) => uploadRequired(r)))

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

// Required upload cards stay disabled until their top tick is checked
// (return mode exempts the lock; optional rows never lock).
function isUploadLocked(r) {
    if (props.isReturnSelected) return false
    if (!uploadRequired(r)) return false
    if (!r?.pivot?.is_required) return false
    return !r.checked
}

// Inline status beside the "Upload files" header in AttachmentUploader.
// Same visibility logic as the old below-input messages, just relocated.
function reqHintText(r) {
    if (isUploadLocked(r)) return `Tick ${r.definition.name} above to enable uploads.`
    if (hasReqFiles(r)) return 'File(s) attached — required condition met.'
    if (!props.isReturnSelected) return 'Attach at least one file to unlock Proceed.'
    return ''
}

function reqHintType(r) {
    if (isUploadLocked(r)) return 'error'
    return hasReqFiles(r) ? 'success' : 'error'
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

// Row done-state: upload rows need files (plus the top tick when locked);
// hard-copy rows need a tick.
function reqDone(r) {
    if (uploadRequired(r)) return !isUploadLocked(r) && hasReqFiles(r)
    return !!r.checked
}

function reqStatusColor(r) {
    if (reqDone(r)) return 'success'
    if (props.isReturnSelected) return 'grey'
    if (uploadRequired(r)) return 'error'
    return r?.pivot?.is_required ? 'warning' : 'grey'
}

function reqStatusIcon(r) {
    if (reqDone(r)) return 'mdi-check-circle'
    if (uploadRequired(r)) return props.isReturnSelected ? 'mdi-clock-outline' : 'mdi-alert-circle-outline'
    return r?.pivot?.is_required ? 'mdi-checkbox-blank-outline' : 'mdi-circle-outline'
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
</style>
