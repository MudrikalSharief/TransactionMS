<template>
    <div
        class="route-flow"
        role="img"
        :aria-label="ariaLabel"
    >
        <!-- Previous station -->
        <div class="flow-node">
            <v-avatar
                color="white"
                size="46"
                class="flow-circle flow-ring"
            >
                <span v-if="prevNumber !== ''" class="font-weight-bold text-grey-darken-3">{{ prevNumber }}</span>
                <v-icon v-else size="20" color="grey-darken-1">mdi-flag-start</v-icon>
            </v-avatar>
            <div class="flow-caption">
                <div class="flow-caption-name" :title="prevName || 'Start'">{{ prevName || 'Start' }}</div>
                <v-chip size="x-small" variant="tonal" color="grey" rounded="0" class="mt-1">Previous</v-chip>
            </div>
        </div>

        <!-- Static link: prev -> current -->
        <div class="flow-link is-static" aria-hidden="true"><span class="flow-line"></span></div>

        <!-- Current station (left emphasis) -->
        <div class="flow-node">
            <v-avatar color="white" size="46" class="flow-circle flow-ring is-current">
                <span class="font-weight-bold text-primary">{{ currentNumber !== '' ? currentNumber : '•' }}</span>
            </v-avatar>
            <div class="flow-caption">
                <div class="flow-caption-name font-weight-bold" :title="currentName || 'Current station'">{{ currentName || 'Current station' }}</div>
                <v-chip size="x-small" variant="flat" color="primary" rounded="0" class="mt-1">You are here</v-chip>
            </div>
        </div>

        <!-- Animated link: current -> destination. The chevron sits
             between two dash segments in one flex row, so icon and
             dashes share the same vertical center by construction. -->
        <div
            class="flow-link is-animated"
            :class="directionClass"
            aria-hidden="true"
        >
            <span class="flow-line"></span>
            <v-icon :size="20" :color="arrowColor" class="flow-arrow-icon">{{ arrowIcon }}</v-icon>
            <span class="flow-line"></span>
        </div>

        <!-- Destination preview -->
        <div class="flow-node">
            <v-avatar
                v-if="hasSelection && destStep"
                color="white"
                size="46"
                :class="['flow-circle', 'flow-ring', destRingClass]"
            >
                <span class="font-weight-bold" :class="destNumberClass">{{ destNumber !== '' ? destNumber : '→' }}</span>
            </v-avatar>
            <v-avatar
                v-else
                color="white"
                size="46"
                class="flow-circle flow-ring is-placeholder"
            >
                <v-icon size="20" color="grey-darken-1">mdi-help</v-icon>
            </v-avatar>
            <div class="flow-caption">
                <div
                    class="flow-caption-name"
                    :class="{ 'font-weight-bold': hasSelection }"
                    :title="hasSelection ? (destName || 'Selected station') : 'Select an action'"
                >{{ hasSelection ? (destName || 'Selected station') : 'Select an action' }}</div>
                <v-chip
                    size="x-small"
                    variant="tonal"
                    :color="actionChipColor"
                    rounded="0"
                    class="mt-1"
                >{{ actionChipLabel }}</v-chip>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'

// Prev - Current - Dest graphical preview of where the selected action
// goes. Read-only: the parent owns selection (dropdown) and passes the
// resolved destination + direction down.
const props = defineProps({
    prevStep: { type: Object, default: null },
    currentStep: { type: Object, default: null },
    destStep: { type: Object, default: null },
    workflowSteps: { type: Array, default: () => [] },
    // 'forward' | 'return' | 'resend' | null (null = nothing selected)
    direction: { type: String, default: null },
    hasSelection: { type: Boolean, default: false },
})

function lookupNumber(step) {
    if (!step) return ''
    if (step.order_number !== undefined && step.order_number !== null && step.order_number !== '') {
        return step.order_number
    }
    const match = (props.workflowSteps || []).find((s) => String(s?.id) === String(step?.id))
    if (match?.order_number !== undefined && match?.order_number !== null && match?.order_number !== '') {
        return match.order_number
    }
    return ''
}

function lookupName(step) {
    if (!step) return ''
    return step.name || step.code || ''
}

const prevNumber = computed(() => lookupNumber(props.prevStep))
const prevName = computed(() => lookupName(props.prevStep))
const currentNumber = computed(() => lookupNumber(props.currentStep))
const currentName = computed(() => lookupName(props.currentStep))
const destNumber = computed(() => lookupNumber(props.destStep))
const destName = computed(() => lookupName(props.destStep))

const directionClass = computed(() => {
    if (!props.hasSelection || !props.direction) return 'is-idle'
    if (props.direction === 'return') return 'is-return'
    if (props.direction === 'resend') return 'is-resend'
    return 'is-forward'
})

const arrowColor = computed(() => {
    if (!props.hasSelection || !props.direction) return 'grey-lighten-1'
    if (props.direction === 'return') return 'warning'
    if (props.direction === 'resend') return 'purple-darken-2'
    return 'primary'
})

// Return flows backwards, so the chevron points back toward the left.
const arrowIcon = computed(() => {
    if (!props.hasSelection || !props.direction) return 'mdi-chevron-double-right'
    if (props.direction === 'return') return 'mdi-chevron-double-left'
    return 'mdi-chevron-double-right'
})

const destRingClass = computed(() => {
    if (props.direction === 'return') return 'is-dest-return'
    if (props.direction === 'resend') return 'is-dest-resend'
    return 'is-dest-forward'
})

const destNumberClass = computed(() => {
    if (props.direction === 'return') return 'text-warning'
    if (props.direction === 'resend') return 'text-purple-darken-2'
    return 'text-primary'
})

const actionChipColor = computed(() => {
    if (!props.hasSelection || !props.direction) return 'grey'
    if (props.direction === 'return') return 'warning'
    if (props.direction === 'resend') return 'purple-darken-2'
    return 'primary'
})

const actionChipLabel = computed(() => {
    if (!props.hasSelection || !props.direction) return 'No action selected'
    if (props.direction === 'return') return 'Return to'
    if (props.direction === 'resend') return 'Resend to'
    return 'Proceed to'
})

const ariaLabel = computed(() => {
    const prev = prevName.value ? `Previous ${prevNumber.value} ${prevName.value}` : 'No previous station'
    const cur = currentName.value ? `Current ${currentNumber.value} ${currentName.value}` : 'Current station'
    if (!props.hasSelection || !props.destStep) return `${prev}, ${cur}, no action selected`
    const verb = actionChipLabel.value
    return `${prev}, ${cur}, ${verb} ${destNumber.value} ${destName.value}`
})
</script>

<style scoped>
.route-flow {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    padding: 12px 4px 4px;
    overflow-x: auto;
}

.flow-node {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex: 0 0 auto;
    width: 110px;
    text-align: center;
}

/* White-fill circles with colored rings (header-icon colors).
   !important: Vuetify's own .v-avatar resets border-width. */
.flow-circle {
    border: 2px solid transparent;
}

.flow-ring {
    border: 2px solid #e0e0e0 !important;
}

.flow-ring.is-current {
    border-color: rgb(var(--v-theme-primary)) !important;
    box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15);
}

.flow-ring.is-dest-forward {
    border-color: rgb(var(--v-theme-primary)) !important;
}

.flow-ring.is-dest-return {
    border-color: #fb8c00 !important;
}

.flow-ring.is-dest-resend {
    border-color: #7c3aed !important;
}

.flow-ring.is-placeholder {
    border-style: dashed !important;
    border-color: #bdbdbd !important;
    background: transparent;
}

.flow-caption {
    margin-top: 6px;
    max-width: 110px;
    min-width: 110px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

/* Fixed 2-line slot: one-line names ("Start", short stations) and
   two-line names occupy the same box, so picking a dropdown value
   never changes the block height or pushes content below. */
.flow-caption-name {
    font-size: 0.78rem;
    line-height: 1.25;
    min-height: 2.5em;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    overflow-wrap: break-word;
}

.flow-link {
    flex: 1 1 32px;
    min-width: 28px;
    height: 46px;
    margin-top: 0;
    position: relative;
}

/* The horizontal rule itself, pinned to the vertical center so it
   always meets the avatar middles (all avatars are 46px). */
.flow-link .flow-line {
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    height: 2px;
    transform: translateY(-50%);
    border-radius: 2px;
    background: #e0e0e0;
}

/* Static prev -> current connector */
.flow-link.is-static .flow-line {
    background: #e0e0e0;
}

/* Animated current -> destination connector: moving dashes.
   Single flex row (dash segment, chevron, dash segment) sharing one
   vertical center, so the arrow can never drift off the line. */
.flow-link.is-animated {
    color: #bdbdbd;
    display: flex;
    align-items: center;
}

.flow-link.is-animated .flow-line {
    flex: 1 1 0;
    position: static;
    height: 2px;
    transform: none;
    background: transparent;
    background-image: linear-gradient(to right, currentColor 55%, transparent 45%);
    background-size: 12px 2px;
    background-repeat: repeat-x;
    animation: flow-dash 1.1s linear infinite;
}

.flow-link.is-animated.is-forward {
    color: #1e40af;
}

.flow-link.is-animated.is-return {
    color: #fb8c00;
}

.flow-link.is-animated.is-resend {
    color: #7c3aed;
}

.flow-link.is-animated.is-return .flow-line {
    animation-direction: reverse;
}

.flow-link.is-animated.is-idle .flow-line {
    background-image: linear-gradient(to right, #bdbdbd 55%, transparent 45%);
    animation: none;
}

.flow-arrow-icon {
    flex: 0 0 auto;
    margin: 0 3px;
    line-height: 1;
}

@keyframes flow-dash {
    to {
        background-position: 24px 0;
    }
}

@media (prefers-reduced-motion: reduce) {
    .flow-link.is-animated {
        animation: none;
    }
}
</style>
