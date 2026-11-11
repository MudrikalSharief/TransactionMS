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
                :primary-disabled="!remarks.trim() || saving"
                @cancel="close"
                @primary="confirm"
            />
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
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
})

const emit = defineEmits(['update:open', 'confirm'])

const remarks = ref('')
const remarksError = ref('')

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
    emit('confirm', { remarks: remarks.value.trim(), flagged: [...(flagged.value || [])] })
}
</script>
