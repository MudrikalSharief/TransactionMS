<template>
    <div>
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
        <v-alert v-if="!isReturnSelected && missingRequiredUploadLabels.length" type="warning" variant="tonal" class="mt-3">
            Required items missing files: {{ missingRequiredUploadLabels.join(", ") }}.
        </v-alert>
        <v-alert v-if="showChecklist && !isReturnSelected && missingRequiredChecklistLabels.length" type="warning" variant="tonal" class="mt-3">
            Required checklist items not ticked: {{ missingRequiredChecklistLabels.join(", ") }}.
        </v-alert>
        <v-alert v-else-if="!missingRequiredUploadLabels.length && (!showChecklist || !missingRequiredChecklistLabels.length)" type="info" variant="tonal" class="mt-3">
            {{ showChecklist ? 'Files and checklist will be verified together with this move.' : 'Files will be verified with this move.' }}
        </v-alert>
    </div>
</template>

<script setup>
import AttachmentUploader from '@/components/AttachmentUploader.vue'

// Remarks + move-level attachments below the wizard pages. Rendered once
// per visible screen by ProceedWizard (page 1 in single-page mode, page 2
// otherwise), so each screen shows exactly one footer.
const remarks = defineModel('remarks', { default: '' })
const proceedAttachments = defineModel('proceedAttachments', { default: () => [] })

defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    isReturnSelected: { type: Boolean, default: false },
    // False in single-page mode (step 1 → step 2): requirements only.
    showChecklist: { type: Boolean, default: true },
    missingRequiredUploadLabels: { type: Array, default: () => [] },
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
})

const emit = defineEmits([
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
])
</script>
