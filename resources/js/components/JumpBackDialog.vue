<template>
    <v-dialog :model-value="open" max-width="640" @update:model-value="(v) => emit('update:open', v)">
        <v-card rounded="xl" style="overflow: hidden">
            <v-card-title class="px-6 pt-5 pb-1">
                <div class="text-h6 font-weight-bold">{{ dialogTitle }}</div>
                <div class="d-flex align-center ga-2 mt-3 flex-wrap">
                    <v-chip variant="outlined" color="grey" rounded="lg" size="small">{{ currentLabel }}</v-chip>
                    <v-icon size="small" color="grey">mdi-arrow-right</v-icon>
                    <v-chip rounded="lg" size="small" style="background: #DCE9FD; color: #1E4ED8">{{ destinationLabel }}</v-chip>
                </div>
            </v-card-title>
            <v-card-text class="px-6 pt-2 pb-4">
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
                <span v-if="!remarks.trim()" class="text-caption text-medium-emphasis mr-auto">Add a reason to enable {{ isForward ? 'resend' : 'return' }}.</span>
                <v-btn variant="outlined" rounded="lg" :disabled="saving" @click="emit('update:open', false)">Cancel</v-btn>
                <v-btn
                    variant="outlined"
                    rounded="lg"
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

watch(() => props.open, (v) => {
    if (v) {
        remarks.value = ''
        remarksError.value = ''
    }
})

function confirm() {
    if (!remarks.value.trim()) {
        remarksError.value = props.isForward ? 'Remarks are required to resend.' : 'Remarks are required to return.'
        return
    }
    emit('confirm', remarks.value.trim())
}
</script>
