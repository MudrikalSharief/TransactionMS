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
            file-action="download"
            @update:model-value="(files) => emit('update:proceedAttachments', files)"
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
})

const emit = defineEmits([
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
])
</script>
