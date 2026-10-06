<template>
    <div
        v-if="modern && info && (info.remarks || info.sender || info.fromStep)"
        class="mb-3 pa-4 rounded-lg d-flex ga-3"
        style="background: #FDEBC8; border: 1px solid #F5B942"
    >
        <v-avatar color="#7C4A03" size="32" class="flex-0-0">
            <span class="text-white text-h6 font-weight-bold">!</span>
        </v-avatar>
        <div style="min-width: 0">
            <div class="font-weight-bold" style="color: #7C4A03">
                Returned{{ senderLabel }}{{ stepLabel }}
            </div>
            <div v-if="info.remarks" class="text-body-1 mt-1">"{{ info.remarks }}"</div>
            <div class="text-body-2 text-medium-emphasis mt-1">Please fix this before you proceed.</div>
        </div>
    </div>
    <v-alert
        v-else-if="info && (info.remarks || info.sender || info.fromStep)"
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
// `modern` renders the amber mockup card (proceed modal redesign); default keeps the legacy alert.
const props = defineProps({
    info: { type: Object, default: null },
    modern: { type: Boolean, default: false },
})

const senderLabel = computed(() => (props.info?.sender ? ` by ${props.info.sender}` : ''))
const stepLabel = computed(() => {
    const n = props.info?.fromStep?.order_number
    return n != null && n !== '' ? ` from Step ${n}` : ''
})
</script>
