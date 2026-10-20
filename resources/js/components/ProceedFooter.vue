<template>
    <div>
        <!-- Return mode: received checklist as tappable pills above remarks.
             Tapping toggles structured flags (stored on the run, never in
             the text) — tap again to remove. -->
        <div v-if="isReturnSelected && (checklist || []).length" class="mb-3">
            <v-divider class="my-3" />
            <div class="text-subtitle-2 font-weight-bold mb-1">Documentary requirements for return</div>
            <div class="text-caption text-medium-emphasis mb-2">Tap items to flag them for the next station — tap again to remove.</div>
            <div class="d-flex flex-wrap ga-1">
                <v-chip
                    v-for="c in (checklist || [])"
                    :key="flagKey(c)"
                    size="small"
                    :variant="isFlagged(c) ? 'flat' : 'outlined'"
                    :color="isFlagged(c) ? 'warning' : 'grey-darken-1'"
                    rounded="lg"
                    class="flag-pill"
                    :title="isFlagged(c) ? `${c.name} — tap to unflag` : `${c.name} — tap to flag`"
                    @click="toggleFlag(c)"
                ><v-icon start size="x-small">{{ isFlagged(c) ? 'mdi-check' : 'mdi-plus' }}</v-icon>{{ c.name }}</v-chip>
            </div>
        </div>
        <div :class="{ 'd-flex flex-column': modern }">
            <div :class="{ 'order-2': modern }">
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
            </div>
            <div :class="{ 'order-1': modern }">
                <div class="text-subtitle-2 font-weight-bold mb-2">{{ attachmentsTitle }}</div>
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
                    :show-existing-btn="showExistingBtn"
                    :existing-disabled="existingDisabled"
                    @update:model-value="(files) => emit('update:proceedAttachments', files)"
                    @update:file-label="(v) => emit('update:attachmentName', v)"
                    @deleted="(id) => emit('attachment-deleted', id)"
                    @open-existing="emit('open-existing')"
                />
            </div>
        </div>
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
// Structured return flags: [{requirement_definition_id, code, name}].
// Two-way bound to the page via ProceedWizard; sent as flagged_items on
// execute. Never written into the remarks text, so they cannot be erased.
const flagged = defineModel('flagged', { default: () => [] })

defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    isReturnSelected: { type: Boolean, default: false },
    // Received checklist (current_step_checklist): drives the return
    // flag-cards above remarks. Empty outside return mode.
    checklist: { type: Array, default: () => [] },
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
    // Redesign flag: Additional-files block renders before remarks (mockup order).
    modern: { type: Boolean, default: false },
    // Shows the inline "Existing files" reuse button beside Add file
    // (visible step 2+ only when the previous step has files).
    showExistingBtn: { type: Boolean, default: false },
    existingDisabled: { type: Boolean, default: false },
})

const emit = defineEmits([
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
    'update:attachmentName',
    'open-existing',
])

// Return flag pills: each checklist item toggles a structured entry in
// the `flagged` model (matched by requirement code, name fallback).
// Entries travel as flagged_items on execute — never in the remarks text,
// so they cannot be erased by editing.
function flagKey(c) {
    const code = String(c?.code || '').trim().toLowerCase()
    if (code) return `code:${code}`
    const reqId = c?.requirement_definition_id ?? c?.definition?.id
    if (reqId !== null && reqId !== undefined && reqId !== '') return `req:${reqId}`
    return `name:${String(c?.name || '').trim().toLowerCase()}`
}

function flagEntry(c) {
    return {
        requirement_definition_id: c?.requirement_definition_id ?? c?.definition?.id ?? null,
        code: String(c?.code || '').trim(),
        name: String(c?.name || '').trim(),
    }
}

function isFlagged(c) {
    const key = flagKey(c)
    return (flagged.value || []).some((f) => flagKey(f) === key)
}

function toggleFlag(c) {
    const key = flagKey(c)
    const list = [...(flagged.value || [])]
    const idx = list.findIndex((f) => flagKey(f) === key)
    if (idx >= 0) list.splice(idx, 1)
    else list.push(flagEntry(c))
    flagged.value = list
}
</script>

<style scoped>
/* Flag pills invite tapping: pointer cursor plus a hover lift/shadow so
   they read as pressable buttons, not static labels. */
.flag-pill {
    cursor: pointer;
    transition: box-shadow 0.15s ease, transform 0.15s ease;
}
.flag-pill:hover {
    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.3);
    transform: translateY(-1px);
}
</style>
