<template>
    <div>
        <v-stepper v-if="hasRequirements" v-model="step" flat hide-actions alt-labels class="wizard-stepper mb-2">
            <v-stepper-header>
                <v-stepper-item :value="1" title="Requirements" subtitle="Upload files" complete-icon="mdi-check" />
                <v-divider />
                <v-stepper-item :value="2" title="Review" subtitle="Check & proceed" complete-icon="mdi-check" />
            </v-stepper-header>
        </v-stepper>

        <v-window v-model="step">
            <!-- PAGE 1: current-step requirements + per-item uploads + station info -->
            <v-window-item v-if="hasRequirements" :value="1">
                <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                <StepInfoFields :fields="fields" :form="form" />
                <div v-if="!(fields || []).length" class="text-caption text-medium-emphasis mb-3">
                    No info fields on this station — uploads only.
                </div>
                <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" density="compact" class="mt-2 mb-3">
                    Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                </v-alert>

                <v-divider class="my-3" />
                <div class="text-subtitle-2 font-weight-bold mb-1">Needed requirements — this step only</div>
                <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                    Return action — checklist not required, uploads optional.
                </div>
                <div v-else-if="!(requirements || []).length" class="text-caption text-medium-emphasis mb-2">
                    No checklist items for this station — press Next.
                </div>

                <v-expansion-panels v-else variant="accordion">
                    <v-expansion-panel
                        v-for="r in (requirements || [])"
                        :key="r.definition.id"
                        rounded="0"
                    >
                        <v-expansion-panel-title>
                            <div class="d-flex align-center ga-2" style="width: 100%">
                                <v-icon size="small" :color="r.checked ? 'success' : 'grey'">
                                    {{ r.checked ? 'mdi-check-circle' : 'mdi-clock-outline' }}
                                </v-icon>
                                <span class="font-weight-medium">{{ r.definition.name }}</span>
                                <v-chip v-if="r?.pivot?.is_required" size="x-small" variant="tonal" color="error" rounded="0">
                                    <v-icon start size="x-small">mdi-asterisk</v-icon>required
                                </v-chip>
                                <v-chip v-else size="x-small" variant="tonal" color="grey" rounded="0">optional</v-chip>
                                <v-spacer />
                                <v-chip v-if="(r.attachments || []).length || (getReqFiles(r.definition.id) || []).length" size="x-small" variant="tonal" color="grey-darken-3" rounded="0">
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
                            <div v-if="r.checked" class="text-caption text-success mt-1">
                                <v-icon size="x-small">mdi-check</v-icon>
                                Submitted{{ r.checked_by?.name ? ` by ${r.checked_by.name}` : '' }}{{ r.checked_at ? ` · ${r.checked_at}` : '' }} — you can untick it on the next page if needed.
                            </div>
                        </v-expansion-panel-text>
                    </v-expansion-panel>
                </v-expansion-panels>
            </v-window-item>

            <!-- PAGE 2: checkbox review + remarks + final proceed -->
            <v-window-item :value="2">
                <!-- Single-step fallback: no requirements, so station info lives here -->
                <template v-if="!hasRequirements && (fields || []).length">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />
                    <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" density="compact" class="mt-2 mb-3">
                        Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                    </v-alert>
                    <v-divider class="my-3" />
                </template>
                <div class="text-subtitle-2 font-weight-bold mb-2">Confirm checklist</div>
                <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                    Return action — checklist not required.
                </div>
                <div v-else-if="!(requirements || []).length" class="text-caption text-medium-emphasis mb-2">
                    No checklist items for this station.
                </div>
                <div v-else>
                    <div class="text-caption text-medium-emphasis mb-2">
                        Tick = already submitted on page 1 or in the Checklist table. Untick to undo.
                    </div>
                    <v-checkbox
                        v-for="r in (requirements || [])"
                        :key="r.definition.id"
                        :model-value="!!r.checked"
                        :label="`${r.definition.name}${r?.pivot?.is_required ? ' (required)' : ''}`"
                        density="compact"
                        hide-details="auto"
                        :disabled="saving || savingChecklist"
                        :loading="savingChecklist && savingRequirementId === r.definition.id"
                        @update:model-value="(v) => emit('toggle-requirement', r, v)"
                    />
                </div>

                <v-divider class="my-3" />
                <v-textarea
                    :model-value="remarks"
                    label="Remarks (optional)"
                    rows="4"
                    @update:model-value="(v) => emit('update:remarks', v)"
                />
                <v-divider class="my-3" />
                <AttachmentUploader
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :model-value="proceedAttachments"
                    @update:model-value="(files) => emit('update:proceedAttachments', files)"
                    @deleted="(id) => emit('attachment-deleted', id)"
                />
                <v-alert v-if="executeError" type="error" variant="tonal" class="mt-3">
                    {{ executeError }}
                </v-alert>
                <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" class="mt-3">
                    Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                </v-alert>
                <v-alert v-if="!isReturnSelected && missingRequiredLabels.length" type="warning" variant="tonal" class="mt-3">
                    Required items missing: {{ missingRequiredLabels.join(", ") }}.
                </v-alert>
                <v-alert v-else-if="!missingRequiredFields.length" type="info" variant="tonal" class="mt-3">
                    Station info and remarks will be saved together with this move.
                </v-alert>
            </v-window-item>
        </v-window>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import StepInfoFields from '@/components/StepInfoFields.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import AttachmentList from '@/components/AttachmentList.vue'

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
    // tx.current_step_fields
    fields: { type: Array, default: () => [] },
    // Shared page draft object, mutated in place by StepInfoFields.
    form: { type: Object, required: true },
    selectedActionLabel: { type: String, default: '' },
    selectedRouteId: { type: [Number, String, null], default: null },
    isReturnSelected: { type: Boolean, default: false },
    missingRequiredLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    saving: { type: Boolean, default: false },
    savingChecklist: { type: Boolean, default: false },
    savingRequirementId: { type: [Number, String, null], default: null },
})

// Single-step mode when there are no requirements: skip page 1 entirely.
const hasRequirements = computed(() => (props.requirements || []).length > 0)

const emit = defineEmits([
    'toggle-requirement',
    'requirement-uploaded',
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
])

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

defineExpose({ clearReqFiles })
</script>

<style scoped>
.wizard-stepper {
    background: transparent;
}
</style>
