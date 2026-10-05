<template>
    <div v-if="stepNumber || stepName" class="d-flex align-center ga-2">
        <v-chip size="x-small" variant="flat" color="primary" rounded="lg">{{ badgeText }}</v-chip>
        <span class="text-caption text-medium-emphasis">{{ stepName }}</span>
    </div>
</template>

<script setup>
import { computed } from 'vue'

// Curved blue badge above the proceed title: "Step 1 of 8" + step name.
// `tx` shape: { current_step: { order_number, name }, workflow_steps: [] }
const props = defineProps({
    tx: { type: Object, default: null },
})

const stepNumber = computed(() => props.tx?.current_step?.order_number ?? '')
const stepName = computed(() => props.tx?.current_step?.name || props.tx?.current_step?.code || '')
const totalSteps = computed(() => (props.tx?.workflow_steps || []).length || 0)

const badgeText = computed(() => {
    if (stepNumber.value !== '' && totalSteps.value > 0) return `Step ${stepNumber.value} of ${totalSteps.value}`
    if (stepNumber.value !== '') return `Step ${stepNumber.value}`
    return ''
})
</script>
