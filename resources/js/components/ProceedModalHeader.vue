<template>
    <div class="pm-hd">
        <div class="pm-top">
            <span v-if="stepLabel" class="pm-step">{{ stepLabel }}</span>
            <div class="pm-top-actions">
                <slot name="actions" />
                <button type="button" class="pm-close" aria-label="Close" @click="emit('close')">
                    <v-icon size="19">mdi-close</v-icon>
                </button>
            </div>
        </div>
        <h2 class="pm-title">
            <template v-if="destinationName">
                {{ prefix }} <em>&ldquo;{{ destinationName }}&rdquo;</em>
                <span v-if="destinationOffice" class="pm-office">{{ destinationOffice }}</span>
            </template>
            <template v-else>{{ fallbackTitle }}</template>
        </h2>
        <div v-if="totalSteps > 0" class="pm-progress" aria-hidden="true">
            <i
                v-for="n in totalSteps"
                :key="n"
                :class="{ on: n <= currentOrderValue }"
            ></i>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'

// Redesigned proceed-modal header: compact step line, destination title and
// segmented workflow progress. Used by both the Approvals and Transaction
// Detail proceed dialogs so their headers cannot drift apart.
const props = defineProps({
    tx: { type: Object, default: null },
    // "Proceeding to", "Returning to", "Resending to", "Completing"...
    prefix: { type: String, default: 'Proceeding to' },
    destinationName: { type: String, default: '' },
    destinationOffice: { type: String, default: '' },
    // Shown when no destination is selected yet.
    fallbackTitle: { type: String, default: 'Proceed' },
})

const emit = defineEmits(['close'])

const currentStep = computed(() => props.tx?.current_step || null)
const currentOrderValue = computed(() => Number(currentStep.value?.order_number) || 0)
const totalSteps = computed(() => (props.tx?.workflow_steps || []).length)

const stepLabel = computed(() => {
    const n = currentStep.value?.order_number
    const name = currentStep.value?.name || currentStep.value?.code || ''
    if (n === null || n === undefined || n === '') return name
    const prefix = totalSteps.value > 0 ? `Step ${n} of ${totalSteps.value}` : `Step ${n}`
    return name ? `${prefix} · ${name}` : prefix
})
</script>
