<template>
    <div class="pm-extra">
        <!-- Return mode: received checklist as tappable flags. Tapping toggles
             structured flags (stored on the run, never in the text). -->
        <div v-if="isReturnSelected && (checklist || []).length" class="pm-warn-card">
            <div class="pm-warn-title">
                <v-icon size="17">mdi-flag-outline</v-icon>
                Documentary requirements for return
            </div>
            <p>Tap items to flag them for the next station — tap again to remove.</p>
            <div class="pm-flag-row">
                <button
                    v-for="c in (checklist || [])"
                    :key="flagKey(c)"
                    type="button"
                    class="pm-flag-pill"
                    :class="{ 'is-on': isFlagged(c) }"
                    :title="isFlagged(c) ? `${c.name} — tap to unflag` : `${c.name} — tap to flag`"
                    @click="toggleFlag(c)"
                >
                    <v-icon size="14">{{ isFlagged(c) ? 'mdi-check' : 'mdi-plus' }}</v-icon>
                    {{ c.name }}
                </button>
            </div>
        </div>

        <!-- Remarks -->
        <div class="pm-dis" :class="{ 'is-open': remarksOpen }" data-pm-task="Remarks|Return reason">
            <button type="button" class="pm-dsb" :class="{ 'is-open': remarksOpen }" @click="remarksOpen = !remarksOpen">
                <v-icon size="18">mdi-text-box-outline</v-icon>
                <span>
                    {{ remarksTitle }}
                    <span v-if="remarksRequired" class="pm-tag w" style="margin-left: 6px">Required</span>
                    <span v-else class="pm-opt">(optional)</span>
                </span>
                <span v-if="remarksPreview" class="pm-dv">{{ remarksPreview }}</span>
                <v-icon size="18">mdi-chevron-down</v-icon>
            </button>
            <div v-if="remarksOpen" class="pm-dp">
                <textarea
                    class="pm-textarea"
                    :value="remarks"
                    :placeholder="remarksPlaceholder || 'Explain what you changed or fixed.'"
                    :aria-label="remarksLabel"
                    @input="emit('update:remarks', $event.target.value)"
                ></textarea>
            </div>
        </div>

        <!-- Additional files -->
        <div class="pm-dis" :class="{ 'is-open': filesOpen }">
            <button type="button" class="pm-dsb" :class="{ 'is-open': filesOpen }" @click="filesOpen = !filesOpen">
                <v-icon size="18">mdi-paperclip</v-icon>
                <span>
                    {{ attachmentsTitle }}
                    <span class="pm-opt">(optional)</span>
                </span>
                <span v-if="(proceedAttachments || []).length" class="pm-dv">{{ fileCountLabel }}</span>
                <v-icon size="18">mdi-chevron-down</v-icon>
            </button>
            <div v-if="filesOpen" class="pm-dp">
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
                    list-collapsible-groups
                    show-label-input
                    redesign
                    :show-existing-btn="showExistingBtn"
                    :existing-disabled="existingDisabled"
                    @update:model-value="(files) => emit('update:proceedAttachments', files)"
                    @update:file-label="(v) => emit('update:attachmentName', v)"
                    @deleted="(id) => emit('attachment-deleted', id)"
                    @open-existing="emit('open-existing')"
                />
            </div>
        </div>

        <div v-if="executeError" class="pm-alert">
            <v-icon size="17">mdi-alert-circle-outline</v-icon>
            {{ executeError }}
        </div>
    </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'

// Remarks + move-level attachments below the wizard pages. Rendered once
// per visible screen by ProceedWizard (page 1 in single-page mode, page 2
// otherwise), so each screen shows exactly one footer.
const remarks = defineModel('remarks', { default: '' })
const proceedAttachments = defineModel('proceedAttachments', { default: () => [] })
const attachmentName = defineModel('attachmentName', { default: '' })
// Structured return flags: [{requirement_definition_id, code, name}].
const flagged = defineModel('flagged', { default: () => [] })

const props = defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    isReturnSelected: { type: Boolean, default: false },
    checklist: { type: Array, default: () => [] },
    showChecklist: { type: Boolean, default: true },
    missingRequiredUploadLabels: { type: Array, default: () => [] },
    missingRequiredTickLabels: { type: Array, default: () => [] },
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    remarksLabel: { type: String, default: 'Remarks (optional)' },
    remarksPlaceholder: { type: String, default: '' },
    attachmentsTitle: { type: String, default: 'Additional files' },
    modern: { type: Boolean, default: false },
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

const remarksRequired = computed(() => {
    const label = String(props.remarksLabel || '').toLowerCase()
    return label.includes('required') && !label.includes('optional')
})

// Keep the caller's label ("Reason for returning", "Reply to …") while the
// Required/Optional tag carries the suffix. Falls back to plain Remarks.
const remarksTitle = computed(() => {
    const title = String(props.remarksLabel || '')
        .replace(/\((?:required|optional)\)/gi, '')
        .trim()
    return title || 'Remarks'
})

const remarksOpen = ref(false)
const filesOpen = ref(false)

// Open required remarks automatically; optional sections start collapsed.
watch(remarksRequired, (required) => {
    if (required) remarksOpen.value = true
}, { immediate: true })

const remarksPreview = computed(() => {
    const text = String(remarks.value || '').replace(/\s+/g, ' ').trim()
    if (!text) return ''
    return text.length > 48 ? `${text.slice(0, 48)}…` : text
})

const fileCountLabel = computed(() => {
    const n = (proceedAttachments.value || []).length
    return n === 1 ? '1 file' : `${n} files`
})

// Return flag pills: each checklist item toggles a structured entry in
// the `flagged` model (matched by requirement code, name fallback).
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
.pm-extra {
    margin-top: 4px;
}
</style>
