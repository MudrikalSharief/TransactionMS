<template>
    <v-dialog :model-value="open" max-width="560" @update:model-value="(v) => emit('update:open', v)">
        <v-card class="pm-dialog" flat>
            <ProceedModalHeader
                :tx="tx"
                :prefix="isForward ? 'Resending to' : 'Returning to'"
                :destination-name="headerDestinationName"
                :destination-office="destinationOffice"
                :fallback-title="dialogTitle"
                @close="close"
            />
            <div class="pm-body">
                <div class="pm-route-pair">
                    <span class="pm-route-chip">{{ currentLabel }}</span>
                    <v-icon size="16">mdi-arrow-right</v-icon>
                    <span class="pm-route-chip is-dest">{{ destinationLabel }}</span>
                </div>

                <!-- Returned checklist shown only on a forward resend. The
                     returned files are optional requirements: the resender
                     can upload a corrected copy or resend unchanged. -->
                <section v-if="isForward && (resendChecklist || []).length" class="pm-section">
                    <div class="pm-sh">
                        <h3>Returned checklist</h3>
                        <span class="pm-count">{{ updatedCount }} of {{ resendChecklist.length }} updated</span>
                    </div>
                    <p class="pm-hint">
                        Optional. Upload an updated file only if you fixed it —
                        resending does not require an upload.
                    </p>
                    <div class="pm-upload-list">
                        <div
                            v-for="row in resendChecklist"
                            :key="row.key"
                            class="pm-upload"
                            :class="{ 'is-ok': rowFiles(row).length }"
                        >
                            <div class="pm-uh">
                                <span class="pm-sico">
                                    <v-icon size="17">{{ rowFiles(row).length ? 'mdi-check' : 'mdi-file-check-outline' }}</v-icon>
                                </span>
                                <div class="pm-ut">
                                    <b :title="row.name">{{ row.name }}</b>
                                    <span class="pm-meta">
                                        Optional
                                        <i v-if="row.owner_step">Step {{ row.owner_step.order_number }}</i>
                                    </span>
                                </div>
                                <AttachmentUploader
                                    :tx-id="txId"
                                    :is-admin="isAdmin"
                                    :model-value="rowFiles(row)"
                                    :file-label="`Updated: ${String(row.name || '').slice(0, 110)}`"
                                    :show-list="false"
                                    minimal
                                    :disabled="saving"
                                    @update:model-value="(files) => setRowFiles(row, files)"
                                    @uploading="(value) => setRowUploading(row, value)"
                                >
                                    <template #header="{ open, uploading, disabled }">
                                        <button
                                            type="button"
                                            class="pm-lnk"
                                            :disabled="disabled || saving"
                                            @click="open"
                                        >
                                            <v-icon v-if="!uploading" size="15">mdi-paperclip</v-icon>
                                            {{ uploading ? 'Uploading…' : (rowFiles(row).length ? 'Add another file' : 'Choose files') }}
                                        </button>
                                    </template>
                                </AttachmentUploader>
                            </div>

                            <div v-if="(row.attachments || []).length" class="mt-3">
                                <span class="pm-meta">Returned file</span>
                                <AttachmentList
                                    :items="row.attachments"
                                    :tx-id="txId"
                                    :is-admin="isAdmin"
                                    action="download"
                                    :show-details="false"
                                    redesign
                                    hide-delete
                                />
                            </div>
                            <div v-if="rowFiles(row).length" class="mt-3">
                                <span class="pm-meta">Updated file</span>
                                <AttachmentList
                                    :items="rowFiles(row)"
                                    :tx-id="txId"
                                    :is-admin="isAdmin"
                                    :current-step-id="currentStepId"
                                    action="download"
                                    :show-details="false"
                                    redesign
                                    @deleted="(id) => removeRowFile(row, id)"
                                />
                            </div>
                        </div>
                    </div>
                </section>

                <div v-if="!isForward && (checklist || []).length" class="pm-warn-card">
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

                <div class="pm-field" :data-pm-task="reasonTaskLabel">
                    <div class="pm-field-head">
                        <label>Reason for {{ isForward ? 'resending' : 'returning' }}</label>
                        <span class="pm-tag w">Required</span>
                    </div>
                    <textarea
                        v-model="remarks"
                        class="pm-textarea"
                        :placeholder="isForward ? 'Why are you resending it?' : 'Why are you returning it?'"
                        maxlength="500"
                        :disabled="saving"
                        :aria-invalid="!!remarksError"
                        @input="remarksError = ''"
                    ></textarea>
                    <div v-if="remarksError" class="pm-hint is-error">{{ remarksError }}</div>
                    <div v-else class="pm-hint">This note will be shown to {{ shortDestination }}.</div>
                    <div class="pm-hint">{{ remarks.length }} / 500</div>
                </div>
            </div>
            <ProceedModalFooter
                :tasks="reasonTasks"
                :busy="saving"
                :primary-label="isForward ? 'Resend' : 'Return'"
                :primary-tone="isForward ? 'resend' : 'warn'"
                :primary-disabled="!remarks.trim() || saving || uploadingAny"
                @cancel="close"
                @primary="confirm"
            />
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import AttachmentList from '@/components/AttachmentList.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import ProceedModalHeader from '@/components/ProceedModalHeader.vue'
import ProceedModalFooter from '@/components/ProceedModalFooter.vue'

const props = defineProps({
    open: { type: Boolean, default: false },
    currentLabel: { type: String, default: 'current station' },
    destinationLabel: { type: String, default: 'the selected station' },
    // Transaction title/code shown when no destination name is available.
    subject: { type: String, default: '' },
    // Optional header source: step label, segmented progress and title.
    tx: { type: Object, default: null },
    destinationName: { type: String, default: '' },
    destinationOffice: { type: String, default: '' },
    saving: { type: Boolean, default: false },
    isForward: { type: Boolean, default: false },
    // Received checklist (current_step_checklist): drives the return
    // flag-cards above the reason box. Empty outside return mode.
    checklist: { type: Array, default: () => [] },
    // Optional returned checklist (latest return run) shown on forward
    // resends. Each row can take an updated file, but nothing is required.
    resendChecklist: { type: Array, default: () => [] },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
    currentStepId: { type: [Number, String], default: null },
})

const emit = defineEmits(['update:open', 'confirm'])

const remarks = ref('')
const remarksError = ref('')
// Updated files staged against each returned-checklist row. Uploads are
// persisted immediately on the current step; on confirm their IDs are sent
// as attachment_targets so the server can re-file them under the returned
// requirement before stamping them to the resend run.
const updatedFiles = ref({})
const uploadingRows = ref({})

watch(() => [props.txId, props.currentStepId], () => {
    updatedFiles.value = {}
    uploadingRows.value = {}
}, { immediate: true })

const uploadingAny = computed(() =>
    Object.values(uploadingRows.value || {}).some(Boolean),
)

const updatedCount = computed(() =>
    (props.resendChecklist || []).filter((row) => rowFiles(row).length > 0).length,
)

function rowFiles(row) {
    return updatedFiles.value?.[row?.key] || []
}

function setRowUploading(row, value) {
    if (!row?.key) return
    uploadingRows.value = {
        ...uploadingRows.value,
        [row.key]: !!value,
    }
}

function setRowFiles(row, files) {
    if (!row?.key) return
    updatedFiles.value = {
        ...updatedFiles.value,
        [row.key]: [...(files || [])],
    }
}

function removeRowFile(row, id) {
    setRowFiles(row, rowFiles(row).filter((f) => Number(f.id) !== Number(id)))
}

function buildAttachmentTargets() {
    if (!props.isForward) return []
    const targets = []
    for (const row of (props.resendChecklist || [])) {
        const stepId = Number(row?.owner_step?.id)
        if (!Number.isFinite(stepId) || !stepId) continue
        const reqId = row?.requirement_definition_id
        for (const file of rowFiles(row)) {
            if (!file?.id) continue
            targets.push({
                attachment_id: Number(file.id),
                workflow_step_id: stepId,
                requirement_definition_id: reqId !== null && reqId !== undefined && reqId !== ''
                    ? Number(reqId)
                    : null,
            })
        }
    }
    return targets
}

// Short destination for the heading/caption (e.g. "Station 1 · Collect DTR" -> "Station 1").
const shortDestination = computed(() => (props.destinationLabel || '').split('·')[0].trim() || props.destinationLabel)

const dialogTitle = computed(() => {
    const verb = props.isForward ? 'Resend' : 'Return'
    if (props.subject && shortDestination.value) return `${verb} ${props.subject} to ${shortDestination.value}`
    return `${verb} to ${props.destinationLabel}`
})

const headerDestinationName = computed(() => {
    if (props.destinationName) return props.destinationName
    const label = String(props.destinationLabel || '').trim()
    const parts = label.split('·')
    return (parts.length > 1 ? parts.slice(1).join('·') : parts[0]).trim()
})

const reasonTaskLabel = computed(() => (props.isForward ? 'Resend reason' : 'Return reason'))
const reasonTasks = computed(() =>
    remarks.value.trim() ? [] : [{ label: reasonTaskLabel.value }],
)

function close() {
    emit('update:open', false)
}

watch(() => props.open, (v) => {
    if (v) {
        remarks.value = ''
        remarksError.value = ''
        flagged.value = []
    }
})

// Return flag pills: each checklist item toggles a structured entry in
// local `flagged` state (matched by requirement code, name fallback).
// Entries travel as flagged_items on confirm — never in the reason text,
// so they cannot be erased by editing.
const flagged = ref([])

function flagKey(c) {
    const code = String(c?.code || '').trim().toLowerCase()
    if (code) return `code:${code}`
    const reqId = c?.requirement_definition_id
    if (reqId !== null && reqId !== undefined && reqId !== '') return `req:${reqId}`
    return `name:${String(c?.name || '').trim().toLowerCase()}`
}

function flagEntry(c) {
    return {
        requirement_definition_id: c?.requirement_definition_id ?? null,
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

function confirm() {
    if (!remarks.value.trim()) {
        remarksError.value = props.isForward ? 'Remarks are required to resend.' : 'Remarks are required to return.'
        return
    }
    emit('confirm', {
        remarks: remarks.value.trim(),
        flagged: [...(flagged.value || [])],
        attachment_targets: buildAttachmentTargets(),
    })
}
</script>
