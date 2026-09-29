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
                    <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" density="compact" class="mt-2 mb-3">
                        Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                    </v-alert>
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
                        <v-icon size="small" :color="hasReqFiles(r) ? 'success' : (r?.pivot?.is_required && !isReturnSelected ? 'error' : 'grey')">
                            {{ hasReqFiles(r) ? 'mdi-check-circle' : (r?.pivot?.is_required && !isReturnSelected ? 'mdi-alert-circle-outline' : 'mdi-circle-outline') }}
                        </v-icon>
                        <span class="text-body-2">
                            {{ r.definition.name }}
                            <span v-if="r?.pivot?.is_required" class="text-error font-weight-bold">*</span>
                            <span v-else class="text-medium-emphasis">(optional)</span>
                        </span>
                        <v-chip v-if="hasReqFiles(r)" size="x-small" variant="tonal" color="success" rounded="0">file ready</v-chip>
                        <v-chip v-else-if="r?.pivot?.is_required && !isReturnSelected" size="x-small" variant="tonal" color="error" rounded="0">file required</v-chip>
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
                            :href="a.view_url || a.download_url"
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
                    <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" density="compact" class="mt-2 mb-3">
                        Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                    </v-alert>

                    <v-divider class="my-3" />
                </template>
                <div class="text-subtitle-2 font-weight-bold mb-1">Required uploads — this step only</div>
                <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                    Return action — uploads optional.
                </div>
                <div v-else-if="!(requirements || []).length" class="text-caption text-medium-emphasis mb-2">
                    No requirements for this station.
                </div>
                <div v-else class="text-caption text-medium-emphasis mb-2">
                    <b>Required</b> items need at least one file attached before you can Proceed.
                    Optional items can be skipped.
                </div>

                <v-alert
                    v-if="!isReturnSelected && missingRequiredUploadLabels.length"
                    type="warning"
                    variant="tonal"
                    density="compact"
                    class="mb-3"
                >
                    Missing files for required items: {{ missingRequiredUploadLabels.join(", ") }}.
                </v-alert>

                <v-expansion-panels v-if="!(isReturnSelected && !(requirements || []).length) && (requirements || []).length" variant="accordion">
                    <v-expansion-panel
                        v-for="r in (requirements || [])"
                        :key="r.definition.id"
                        rounded="0"
                    >
                        <v-expansion-panel-title>
                            <div class="d-flex align-center ga-2" style="width: 100%">
                                <v-icon size="small" :color="hasReqFiles(r) ? 'success' : (r?.pivot?.is_required && !isReturnSelected ? 'error' : 'grey')">
                                    {{ hasReqFiles(r) ? 'mdi-check-circle' : (r?.pivot?.is_required && !isReturnSelected ? 'mdi-alert-circle-outline' : 'mdi-clock-outline') }}
                                </v-icon>
                                <span class="font-weight-medium">{{ r.definition.name }}</span>
                                <v-chip v-if="r?.pivot?.is_required" size="x-small" variant="tonal" color="error" rounded="0">
                                    <v-icon start size="x-small">mdi-asterisk</v-icon>file required
                                </v-chip>
                                <v-chip v-else size="x-small" variant="tonal" color="grey" rounded="0">optional</v-chip>
                                <v-spacer />
                                <v-chip
                                    v-if="(r.attachments || []).length || (getReqFiles(r.definition.id) || []).length"
                                    size="x-small"
                                    variant="tonal"
                                    color="grey-darken-3"
                                    rounded="0"
                                >
                                    <v-icon start size="x-small">mdi-paperclip</v-icon>{{ (r.attachments || []).length + (getReqFiles(r.definition.id) || []).length }}
                                </v-chip>
                            </div>
                        </v-expansion-panel-title>
                        <v-expansion-panel-text>
                            <div v-if="r.definition.description" class="text-caption text-medium-emphasis mb-2">
                                {{ r.definition.description }}
                            </div>
                            <AttachmentList
                                :items="r.attachments || []"
                                :tx-id="txId"
                                :is-admin="isAdmin"
                                compact
                                @deleted="(id) => emit('attachment-deleted', id)"
                            />
                            <AttachmentUploader
                                :tx-id="txId"
                                :is-admin="isAdmin"
                                :requirement-id="r.definition.id"
                                :model-value="getReqFiles(r.definition.id)"
                                @update:model-value="(files) => setReqFiles(r.definition.id, files)"
                                @uploaded="() => emit('requirement-uploaded', r.definition.id)"
                                @deleted="(id) => emit('attachment-deleted', id)"
                            />
                            <div v-if="hasReqFiles(r)" class="text-caption text-success mt-1">
                                <v-icon size="x-small">mdi-check</v-icon>
                                File(s) attached — required condition met.
                            </div>
                            <div v-else-if="r?.pivot?.is_required" class="text-caption text-error mt-1">
                                <v-icon size="x-small">mdi-alert-circle-outline</v-icon>
                                Attach at least one file to unlock Proceed.
                            </div>
                            <div v-else-if="r.checked" class="text-caption text-medium-emphasis mt-1">
                                Previously marked done — still optional.
                            </div>
                        </v-expansion-panel-text>
                    </v-expansion-panel>
                </v-expansion-panels>
                <ProceedFooter
                    v-model:remarks="remarks"
                    v-model:proceed-attachments="proceedAttachments"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :is-return-selected="isReturnSelected"
                    :show-checklist="showChecklist"
                    :missing-required-upload-labels="missingRequiredUploadLabels"
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
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    saving: { type: Boolean, default: false },
    savingChecklist: { type: Boolean, default: false },
    savingChecklistItemId: { type: [Number, String, null], default: null },
})

// Page 2 holds the uploads. In single-page mode (step 1 → step 2) it is the
// only page: remarks + move attachments render below the uploads.
const hasRequirements = computed(() => (props.requirements || []).length > 0)
const hasProceedContent = computed(
    () => hasRequirements.value || (props.checklist || []).length > 0 || (props.fields || []).length > 0,
)

const emit = defineEmits([
    'toggle-requirement',
    'toggle-checklist',
    'requirement-uploaded',
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
])

function hasReqFiles(r) {
    return ((r.attachments || []).length + (getReqFiles(r.definition.id) || []).length) > 0
}

// Files the browser can render inline in a new tab (PDF, images,
// plain text). Anything else keeps Download-only on page 1.
function isViewable(a) {
    const mime = String(a?.mime || '').toLowerCase()
    if (
        mime === 'application/pdf' ||
        mime.startsWith('image/') ||
        mime.startsWith('text/')
    ) return true
    return /\.(pdf|png|jpe?g|gif|webp|svg|bmp|txt|csv|log)$/i.test(String(a?.original_name || ''))
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
