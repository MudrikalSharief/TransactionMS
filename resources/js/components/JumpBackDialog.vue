<template>
    <v-dialog :model-value="open" max-width="560" @update:model-value="(v) => emit('update:open', v)">
        <v-card rounded="0">
            <v-card-title class="pa-5">
                <div class="text-h6 font-weight-bold">Go back to {{ destinationLabel }}</div>
                <div class="text-caption text-medium-emphasis font-weight-bold mt-1">
                    From {{ currentLabel }}. Saved checks at other stations are kept.
                </div>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-5">
                <v-textarea
                    v-model="remarks"
                    label="Remarks (required)"
                    placeholder="Why are you going back?"
                    rows="4"
                    auto-grow
                    :disabled="saving"
                    :error-messages="remarksError"
                    @update:model-value="remarksError = ''"
                />
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end ga-2">
                <v-btn variant="text" :disabled="saving" @click="emit('update:open', false)">Cancel</v-btn>
                <v-btn
                    color="grey-darken-3"
                    rounded="0"
                    :loading="saving"
                    :disabled="!remarks.trim() || saving"
                    @click="confirm"
                >{{ confirmLabel }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
    open: { type: Boolean, default: false },
    currentLabel: { type: String, default: 'current station' },
    destinationLabel: { type: String, default: 'the selected station' },
    confirmLabel: { type: String, default: 'Go back' },
    saving: { type: Boolean, default: false },
})

const emit = defineEmits(['update:open', 'confirm'])

const remarks = ref('')
const remarksError = ref('')

watch(() => props.open, (v) => {
    if (v) {
        remarks.value = ''
        remarksError.value = ''
    }
})

function confirm() {
    if (!remarks.value.trim()) {
        remarksError.value = 'Remarks are required to go back.'
        return
    }
    emit('confirm', remarks.value.trim())
}
</script>
