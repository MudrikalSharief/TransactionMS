<template>
    <v-dialog :model-value="open" max-width="640" @update:model-value="(v) => emit('update:open', v)">
        <v-card rounded="xl" style="overflow: hidden">
            <v-card-title class="px-6 pt-5 pb-1">
                <div class="text-h6 font-weight-bold"><span :class="{ 'text-warning': !isForward }">{{ titleHead }}</span>{{ titleTail }}</div>
                <div class="d-flex align-center ga-2 mt-3 flex-wrap">
                    <v-chip variant="outlined" color="grey" rounded="lg" size="small">{{ currentLabel }}</v-chip>
                    <v-icon size="small" :color="isForward ? 'grey' : 'warning'">mdi-arrow-right</v-icon>
                    <v-chip rounded="lg" size="small" :style="isForward ? 'background: #DCE9FD; color: #1E4ED8' : 'background: #FEF3C7; color: #92400E'">{{ destinationLabel }}</v-chip>
                </div>
            </v-card-title>
            <v-card-text class="px-6 pt-2 pb-4">
                <div v-if="!isForward && (checklist || []).length" class="mb-4">
                    <div class="text-subtitle-1 font-weight-bold mb-1">Documentary requirements for return</div>
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
                <div class="d-flex align-center ga-2 mb-2 mt-1">
                    <span class="text-subtitle-1 font-weight-bold">Reason for {{ isForward ? 'resending' : 'returning' }}</span>
                    <v-chip size="x-small" variant="tonal" color="error" rounded="lg">Required</v-chip>
                </div>
                <v-textarea
                    v-model="remarks"
                    variant="outlined"
                    :placeholder="isForward ? 'Why are you resending it?' : 'Why are you returning it?'"
                    rows="4"
                    auto-grow
                    maxlength="500"
                    :disabled="saving"
                    :error-messages="remarksError"
                    hide-details="auto"
                    @update:model-value="remarksError = ''"
                />
                <div class="d-flex justify-space-between align-center mt-1">
                    <span class="text-caption text-medium-emphasis">This note will be shown to {{ shortDestination }}.</span>
                    <span class="text-caption text-medium-emphasis">{{ remarks.length }} / 500</span>
                </div>
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end ga-2 px-6 py-4">
                <v-btn variant="outlined" rounded="lg" :disabled="saving" @click="emit('update:open', false)">Cancel</v-btn>
                <v-btn
                    variant="outlined"
                    rounded="lg"
                    :color="isForward ? 'purple-darken-2' : 'warning'"
                    :loading="saving"
                    :disabled="!remarks.trim() || saving"
                    @click="confirm"
                >{{ confirmLabel }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from 'vue'

const props = defineProps({
    open: { type: Boolean, default: false },
    currentLabel: { type: String, default: 'current station' },
    destinationLabel: { type: String, default: 'the selected station' },
    // Transaction title/code shown in the heading (e.g. "Return DTR to Station 1").
    subject: { type: String, default: '' },
    confirmLabel: { type: String, default: 'Return' },
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

// Yellow head on returns ("Return to Station 1"), plain tail
// (" · Submit PR to GSO"). Forwards keep the single plain title.
const titleHead = computed(() => {
    if (props.isForward) return dialogTitle.value
    const verb = 'Return'
    if (props.subject && shortDestination.value) return `${verb} ${props.subject} to ${shortDestination.value}`
    return `${verb} to ${shortDestination.value}`
})
const titleTail = computed(() => {
    if (props.isForward) return ''
    const full = dialogTitle.value
    const head = titleHead.value
    return full.startsWith(head) ? full.slice(head.length) : ''
})

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
