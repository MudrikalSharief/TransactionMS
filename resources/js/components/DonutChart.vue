<template>
    <div class="donut-stage d-flex flex-column align-center justify-center" :style="{ minHeight: stageHeight + 'px' }">
        <div v-if="loading" class="d-flex align-center justify-center" :style="{ height: stageHeight + 'px' }">
            <v-progress-circular indeterminate color="primary" size="48" width="4" />
        </div>
        <div v-else-if="!total" class="text-center text-medium-emphasis">
            <v-icon size="40" color="grey-lighten-1">mdi-chart-donut</v-icon>
            <div class="mt-2 font-weight-bold">No data yet</div>
        </div>
        <template v-else>
        <div class="donut-wrap" :style="{ width: size + 'px', height: size + 'px' }">
            <svg :viewBox="`0 0 ${size} ${size}`" :width="size" :height="size">
                <circle
                    :cx="size / 2"
                    :cy="size / 2"
                    :r="radius"
                    fill="none"
                    stroke="#eef2f7"
                    :stroke-width="thickness"
                />
                <circle
                    v-for="(seg, i) in segments"
                    :key="seg.label"
                    :cx="size / 2"
                    :cy="size / 2"
                    :r="radius"
                    fill="none"
                    :stroke="seg.color"
                    :stroke-width="hoverIndex === i ? thickness + 4 : thickness"
                    :stroke-dasharray="`${seg.length} ${circumference - seg.length}`"
                    :stroke-dashoffset="-seg.start"
                    stroke-linecap="butt"
                    class="donut-seg"
                    @mouseenter="hoverIndex = i"
                    @mouseleave="hoverIndex = -1"
                >
                    <title>{{ seg.label }}: {{ seg.value }} ({{ seg.pct }}%)</title>
                </circle>
            </svg>
            <div class="donut-center">
                <div class="text-h5 font-weight-bold">{{ total }}</div>
                <div class="text-caption text-medium-emphasis font-weight-bold">{{ centerLabel }}</div>
            </div>
        </div>

        <div class="donut-legend mt-4">
            <div
                v-for="(seg, i) in segments"
                :key="seg.label"
                class="d-flex align-center mb-1 legend-row"
                @mouseenter="hoverIndex = i"
                @mouseleave="hoverIndex = -1"
            >
                <span class="legend-dot mr-2" :style="{ background: seg.color }" />
                <span class="text-caption font-weight-bold text-truncate" style="max-width: 170px">
                    {{ seg.label }}
                </span>
                <v-spacer />
                <span class="text-caption font-weight-bold ml-3">{{ seg.value }}</span>
                <span class="text-caption text-medium-emphasis ml-3" style="min-width: 38px">
                    {{ seg.pct }}%
                </span>
            </div>
        </div>
        </template>
        <div v-if="!loading && updatedLabel" class="donut-date text-caption text-medium-emphasis font-weight-bold">
            As of {{ updatedLabel }}
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
    items: { type: Array, default: () => [] }, // [{ label, value, color? }]
    size: { type: Number, default: 180 },
    thickness: { type: Number, default: 28 },
    centerLabel: { type: String, default: 'TOTAL' },
    loading: { type: Boolean, default: false },
    updatedAt: { type: [Date, String, Number], default: null },
})

const PALETTE = [
    '#7C3AED', '#26A69A', '#4CAF50', '#FFB300',
    '#EC407A', '#5C6BC0', '#FF7043', '#9E9E9E',
]

const hoverIndex = ref(-1)

const total = computed(() => props.items.reduce((n, i) => n + (Number(i.value) || 0), 0))
const radius = computed(() => props.size / 2 - props.thickness / 2 - 4)
const circumference = computed(() => 2 * Math.PI * radius.value)
// Fixed stage reserves the same space while loading / empty / loaded,
// so the card never collapses or jumps on refresh.
const stageHeight = computed(() => props.size + 170)

const updatedLabel = computed(() => {
    if (!props.updatedAt) return ''
    const d = new Date(props.updatedAt)
    if (Number.isNaN(d.getTime())) return ''
    return d.toLocaleString('en-PH', {
        timeZone: 'Asia/Manila',
        month: 'short',
        day: 'numeric',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        hour12: true,
    })
})

const segments = computed(() => {
    if (!total.value) return []
    let acc = 0
    return props.items
        .filter((i) => Number(i.value) > 0)
        .map((i, idx) => {
            const fraction = Number(i.value) / total.value
            const seg = {
                label: i.label,
                value: Number(i.value),
                pct: Math.round(fraction * 100),
                color: i.color || PALETTE[idx % PALETTE.length],
                start: acc,
                length: Math.max(fraction * circumference.value - 2, 0.5),
            }
            acc += fraction * circumference.value
            return seg
        })
})
</script>

<style scoped>
.donut-stage {
    position: relative;
    /* Room for the absolute date caption so it never overlaps the legend */
    padding-bottom: 22px;
}
/* Date sits below the pie without taking part in layout: containers keep
   their exact size, no shifting when it appears after refresh. */
.donut-date {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    text-align: center;
}
.donut-wrap {
    position: relative;
}
.donut-wrap svg {
    transform: rotate(-90deg);
}
.donut-seg {
    transition: stroke-width 0.15s ease, stroke-dasharray 0.4s ease, stroke-dashoffset 0.4s ease;
    cursor: pointer;
}
.donut-center {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    pointer-events: none;
}
.donut-legend {
    width: 100%;
    max-width: 300px;
}
.legend-row {
    cursor: default;
    border-radius: 8px;
    padding: 2px 6px;
}
.legend-row:hover {
    background: #f1f5f9;
}
.legend-dot {
    width: 10px;
    height: 10px;
    border-radius: 3px;
    flex-shrink: 0;
}
</style>
