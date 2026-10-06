<template>
    <div>
        <v-divider class="my-3" />
        <div class="text-subtitle-2 font-weight-bold mb-2">{{ remarksLabel }}</div>
        <v-textarea
            :model-value="remarks"
            :label="remarksLabel"
            :placeholder="remarksPlaceholder"
            rows="3"
            variant="outlined"
            density="comfortable"
            @update:model-value="(v) => emit('update:remarks', v)"
        />
        <div class="text-subtitle-2 font-weight-bold mb-1">{{ attachmentsTitle }}</div>
        <div class="text-caption text-medium-emphasis mb-2">Input file name</div>
        <AttachmentUploader
            :tx-id="txId"
            :is-admin="isAdmin"
            :model-value="proceedAttachments"
            :show-header="false"
            file-action="view"
            :file-label="attachmentName"
            require-label
            list-show-eye
            list-detailed
            list-group-by-label
            show-label-input
            @update:model-value="(files) => emit('update:proceedAttachments', files)"
            @update:file-label="(v) => emit('update:attachmentName', v)"
            @deleted="(id) => emit('attachment-deleted', id)"
        />
        <v-alert v-if="executeError" type="error" variant="tonal" class="mt-3">
            {{ executeError }}
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
const attachmentName = defineModel('attachmentName', { default: '' })

defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    isReturnSelected: { type: Boolean, default: false },
    // False in single-page mode (step 1 → step 2): requirements only.
    showChecklist: { type: Boolean, default: true },
    missingRequiredUploadLabels: { type: Array, default: () => [] },
    missingRequiredTickLabels: { type: Array, default: () => [] },
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    remarksLabel: { type: String, default: 'Remarks (optional)' },
    remarksPlaceholder: { type: String, default: '' },
    attachmentsTitle: { type: String, default: 'Additional files' },
})

const emit = defineEmits([
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
    'update:attachmentName',
])
</script>
