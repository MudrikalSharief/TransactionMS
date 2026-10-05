<template>
    <v-alert
        v-if="info && (info.remarks || info.sender || info.fromStep)"
        type="warning"
        variant="tonal"
        density="comfortable"
        rounded="lg"
        class="mb-3"
    >
        <div class="d-flex ga-2">
            <v-icon size="small" class="mt-1">mdi-corner-up-left</v-icon>
            <div>
                <div class="text-body-2 font-weight-bold">
                    Returned{{ senderLabel }}{{ stepLabel }}
                </div>
                <div v-if="info.remarks" class="text-body-2 font-italic mt-1">"{{ info.remarks }}"</div>
            </div>
        </div>
    </v-alert>
</template>

<script setup>
import { computed } from 'vue'

// Shared returned-reason banner (requirements redesign).
// `info` shape: { remarks, sender, fromStep } — same as autoReturnInfo in detail pages.
const props = defineProps({
    info: { type: Object, default: null },
})

const senderLabel = computed(() => (props.info?.sender ? ` by ${props.info.sender}` : ''))
const stepLabel = computed(() => {
    const n = props.info?.fromStep?.order_number
    return n != null && n !== '' ? ` from Step ${n}` : ''
})
</script>
