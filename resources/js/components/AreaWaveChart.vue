<template>
    <div ref="wrapRef" class="wave-stage d-flex flex-column justify-center" :style="{ minHeight: stageHeight + 'px' }">
        <div v-if="loading" class="d-flex align-center justify-center" :style="{ height: stageHeight + 'px' }">
            <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
        </div>
        <div v-else-if="!total" class="text-center text-medium-emphasis">
            <v-icon size="40" color="grey-lighten-1">mdi-chart-areaspline</v-icon>
            <div class="mt-2 font-weight-bold">No data yet</div>
        </div>
        <template v-else>
            <div v-if="inStackMode && layers.length" class="wave-legend">
                <span
                    v-for="layer in layers"
                    :key="layer.label"
                    class="wave-legend-item"
                    :class="{ active: isolateLabel === layer.label, dimmed: isolateLabel && isolateLabel !== layer.label }"
                    @mouseenter="legendHover = layer.label"
                    @mouseleave="legendHover = null"
                >
                    <span class="wave-legend-dot" :style="{ background: layer.color }" />
                    {{ layer.label }}
                </span>
            </div>
            <div ref="svgWrapRef" class="wave-svg-wrap" @mousemove="onHover" @mouseleave="hoverIndex = -1">
                <svg
                    ref="svgRef"
                    :viewBox="`0 0 ${viewW} ${viewH}`"
                    width="100%"
                    height="100%"
                    role="img"
                    aria-label="Transactions per week by type"
                >
                    <!-- gridlines + y labels at every tick -->
                    <line
                        v-for="t in yTicks"
                        :key="'g' + t"
                        :x1="leftPad"
                        :x2="viewW - rightPad"
                        :y1="yFor(t)"
                        :y2="yFor(t)"
                        stroke="#eef2f7"
                        stroke-width="1"
                    />
                    <text
                        v-for="t in yTicks"
                        :key="'y' + t"
                        :x="leftPad - 6"
                        :y="yFor(t) + 4"
                        text-anchor="end"
                        font-size="11"
                        fill="#94a3b8"
                        font-weight="700"
                    >
                        {{ t }}
                    </text>
                    <!-- grey base line (weekly totals) -->
                    <path :d="baseLine" fill="none" stroke="#334155" stroke-width="2.5" stroke-linejoin="round" />
                    <!-- thin colored line per type -->
                    <path
                        v-for="layer in layers"
                        :key="layer.label"
                        :d="typeLine(layer)"
                        fill="none"
                        :stroke="layer.color"
                        stroke-width="2"
                        stroke-linejoin="round"
                        :opacity="lineOpacity(layer)"
                    />
                    <!-- hover guide -->
                    <line
                        v-if="hoverIndex >= 0"
                        :x1="hoverX"
                        :x2="hoverX"
                        :y1="topPad"
                        :y2="topPad + plotH"
                        stroke="#94a3b8"
                        stroke-width="1"
                        stroke-dasharray="4 3"
                    />
                    <!-- hover dots on each type line -->
                    <circle
                        v-for="layer in layers"
                        v-show="hoverIndex >= 0"
                        :key="'d' + layer.label"
                        :cx="hoverX"
                        :cy="yFor(layer.values[hoverIndex] || 0)"
                        r="4"
                        :fill="layer.color"
                        stroke="#fff"
                        stroke-width="2"
                        :opacity="isolateLabel && isolateLabel !== layer.label ? 0.15 : 1"
                    />
                    <!-- x labels, edge-anchored so nothing clips -->
                    <text
                        v-for="(x, i) in weekX"
                        v-show="labelEvery === 1 || i % labelEvery === 0 || i === weekX.length - 1"
                        :key="'l' + i"
                        :x="x"
                        :y="viewH - 4"
                        :text-anchor="i === 0 ? 'start' : i === weekX.length - 1 ? 'end' : 'middle'"
                        :font-size="i === hoverIndex ? 12 : 11"
                        :fill="i === hoverIndex ? '#334155' : '#94a3b8'"
                        font-weight="700"
                    >
                        {{ weeks[i] }}
                    </text>
                </svg>
                <!-- hover breakdown tooltip -->
                <div
                    v-if="hoverIndex >= 0"
                    class="wave-tip"
                    :style="tipStyle"
                >
                    <div class="wave-tip-week">{{ weeks[hoverIndex] }}</div>
                    <div v-for="layer in tipRows" :key="layer.label" class="wave-tip-row">
                        <span class="wave-legend-dot" :style="{ background: layer.color }" />
                        <span class="wave-tip-label">{{ layer.label }}</span>
                        <span class="wave-tip-value">{{ layer.values[hoverIndex] || 0 }}</span>
                    </div>
                    <div class="wave-tip-row wave-tip-total">
                        <span class="wave-tip-label">Total</span>
                        <span class="wave-tip-value">{{ weekTotals[hoverIndex] || 0 }}</span>
                    </div>
                </div>
            </div>
        </template>
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'

const props = defineProps({
    points: { type: Array, default: () => [] }, // fallback [{ label, value }]
    series: { type: Array, default: () => [] }, // per-type [{ label, color, values: [] }]
    weekLabels: { type: Array, default: () => [] },
    totals: { type: Array, default: null }, // optional weekly totals incl. series not drawn; else sum of series
    loading: { type: Boolean, default: false },
    height: { type: Number, default: 190 },
    isolate: { type: String, default: null }, // externally isolated type label (e.g. from donut hover)
})

const wrapRef = ref(null)
const svgRef = ref(null)
const svgWrapRef = ref(null)
const wrapW = ref(640)
const wrapH = ref(null)
const hoverIndex = ref(-1)
const legendHover = ref(null)
let observer = null

// Isolated type: external prop (donut hover) wins, else wave legend hover.
const isolateLabel = computed(() => props.isolate ?? legendHover.value)

function lineOpacity(layer) {
    if (isolateLabel.value && isolateLabel.value !== layer.label) return 0.07
    if (hoverIndex.value >= 0 && (layer.values[hoverIndex.value] || 0) === 0) return 0.2
    return 0.9
}

// Render the SVG in true pixels (viewBox matches rendered size 1:1)
// so strokes and text stay crisp at any container size.
const viewW = computed(() => Math.max(280, Math.round(wrapW.value || 640)))
const viewH = computed(() => Math.max(140, Math.round(wrapH.value || props.height)))

const leftPad = 30
const rightPad = 14
const topPad = 8
const xLabelH = 20
const plotH = computed(() => viewH.value - topPad - xLabelH)

const stageHeight = computed(() => props.height + 8)

const inStackMode = computed(() => (props.series || []).length > 0)

const weeks = computed(() =>
    inStackMode.value ? props.weekLabels : props.points.map((p) => p.label)
)

// One entry per type, in stack order. Zero-total series are dropped
// but keep their assigned colors so the donut matches.
const layers = computed(() => {
    if (!inStackMode.value) {
        return props.points.length
            ? [{ label: 'Transactions', color: '#334155', values: props.points.map((p) => p.value || 0) }]
            : []
    }
    return (props.series || []).filter((s) => (s.values || []).some((v) => v > 0))
})

const weekCount = computed(() => layers.value[0]?.values?.length || 0)

const weekTotals = computed(() => {
    const n = weekCount.value
    if (props.totals?.length === n) return props.totals
    const totals = Array(n).fill(0)
    for (const layer of layers.value) {
        ;(layer.values || []).forEach((v, i) => {
            totals[i] += v || 0
        })
    }
    return totals
})

const max = computed(() => Math.max(0, ...weekTotals.value))

// Y ticks: every integer when the max is small (so 1 and 2 never go
// missing), otherwise 0 / quartiles / max with duplicates removed.
const yTicks = computed(() => {
    const m = max.value
    if (m <= 0) return [0]
    if (m <= 4) return Array.from({ length: m + 1 }, (_, i) => i)
    const ticks = new Set([0, m])
    for (const g of [0.25, 0.5, 0.75]) ticks.add(Math.round(m * g))
    return [...ticks].sort((a, b) => a - b)
})

const total = computed(() => weekTotals.value.reduce((s, v) => s + v, 0))

// X pixel for each week (shared by all lines).
const weekX = computed(() => {
    const n = weekCount.value
    if (!n) return []
    const left = leftPad
    const right = viewW.value - rightPad
    if (n === 1) return [(left + right) / 2]
    const step = (right - left) / (n - 1)
    return Array.from({ length: n }, (_, i) => left + step * i)
})

function yFor(value) {
    if (!max.value) return topPad + plotH.value
    return topPad + plotH.value * (1 - value / max.value)
}

function smoothPath(pts) {
    if (!pts.length) return ''
    if (pts.length === 1) return `M ${pts[0].x} ${pts[0].y}`
    let d = `M ${pts[0].x} ${pts[0].y}`
    for (let i = 0; i < pts.length - 1; i++) {
        const mx = (pts[i].x + pts[i + 1].x) / 2
        d += ` Q ${pts[i].x} ${pts[i].y} ${mx} ${(pts[i].y + pts[i + 1].y) / 2}`
    }
    const last = pts[pts.length - 1]
    d += ` L ${last.x} ${last.y}`
    return d
}

function lineFor(values) {
    return smoothPath(weekX.value.map((x, i) => ({ x, y: yFor(values[i] || 0) })))
}

const baseLine = computed(() => lineFor(weekTotals.value))

function typeLine(layer) {
    return lineFor(layer.values || [])
}

const hoverX = computed(() => (hoverIndex.value >= 0 ? (weekX.value[hoverIndex.value] ?? 0) : 0))

// Tooltip rows: isolated type only when isolating, else top 5 by value
// so the tip never outgrows the card.
const tipRows = computed(() => {
    if (hoverIndex.value < 0) return []
    let rows = [...layers.value]
    if (isolateLabel.value) rows = rows.filter((l) => l.label === isolateLabel.value)
    return rows
        .sort((a, b) => (b.values[hoverIndex.value] || 0) - (a.values[hoverIndex.value] || 0))
        .slice(0, 5)
})

const tipStyle = computed(() => {
    const flip = hoverX.value > viewW.value * 0.62
    return {
        top: '4px',
        bottom: 'auto',
        left: flip ? 'auto' : `${Math.max(4, Math.min(hoverX.value + 12, viewW.value - 190))}px`,
        right: flip ? `${Math.max(4, viewW.value - hoverX.value + 12)}px` : 'auto',
    }
})

// Show every label when there is room, otherwise thin them out.
const labelEvery = computed(() => {
    const n = weekX.value.length
    if (n <= 6) return 1
    const plotW = viewW.value - leftPad - rightPad
    if (plotW / n >= 64) return 1
    return 2
})

function onHover(e) {
    const n = weekCount.value
    if (n <= 1) {
        hoverIndex.value = 0
        return
    }
    // Measure the wrapper (not the svg) so hovering anywhere in the
    // chart area — including padding around the plot — still resolves.
    const rect = svgWrapRef.value?.getBoundingClientRect()
    if (!rect || !rect.width) return
    const scale = viewW.value / rect.width
    const x = (e.clientX - rect.left) * scale
    const left = leftPad
    const step = (viewW.value - rightPad - left) / (n - 1)
    hoverIndex.value = Math.max(0, Math.min(n - 1, Math.round((x - left) / step)))
}

onMounted(() => {
    const target = svgWrapRef.value || wrapRef.value
    if (target) {
        wrapW.value = target.clientWidth || 640
        wrapH.value = target.clientHeight || props.height
    }
    if (typeof ResizeObserver !== 'undefined' && target) {
        observer = new ResizeObserver((entries) => {
            const rect = entries[0]?.contentRect
            // Deadband: ignore subpixel jitter so the observer can settle.
            if (rect?.width && Math.abs(wrapW.value - rect.width) > 0.5) wrapW.value = rect.width
            if (rect?.height && Math.abs((wrapH.value ?? props.height) - rect.height) > 0.5) {
                wrapH.value = rect.height
            }
        })
        observer.observe(target)
    }
})

onUnmounted(() => {
    observer?.disconnect()
    observer = null
})
</script>

<style scoped>
.wave-stage {
    position: relative;
    width: 100%;
    max-width: 100%;
    min-width: 0;
    height: 100%;
    flex: 1 1 auto;
    overflow: hidden;
}
.wave-stage svg {
    /* Absolute: the svg must not contribute to the flex layout,
       otherwise measured size -> viewBox -> content size loops forever. */
    position: absolute;
    inset: 0;
    display: block;
    width: 100%;
    height: 100%;
    max-width: 100%;
}
.wave-stage svg text {
    font-family: inherit;
}
.wave-legend {
    display: flex;
    flex-wrap: wrap;
    gap: 4px 14px;
    padding: 2px 2px 8px;
    font-size: 11px;
    font-weight: 700;
    color: #475569;
}
.wave-legend-item {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 1px 7px;
    border-radius: 6px;
    cursor: default;
}
.wave-legend-item.active {
    background: #f1f5f9;
}
.wave-legend-item.dimmed {
    opacity: 0.45;
}
.wave-legend-dot {
    width: 10px;
    height: 10px;
    border-radius: 3px;
    flex-shrink: 0;
}
.wave-svg-wrap {
    position: relative;
    flex: 1 1 auto;
    min-height: 0;
    min-width: 0;
    max-width: 100%;
    overflow: hidden;
}
.wave-tip {
    position: absolute;
    min-width: 158px;
    max-width: 210px;
    background: #1e293b;
    color: #f1f5f9;
    border-radius: 8px;
    padding: 8px 10px;
    font-size: 11px;
    font-weight: 600;
    pointer-events: none;
    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.35);
    z-index: 2;
}
.wave-tip-row {
    display: flex;
    align-items: center;
    gap: 6px;
}
.wave-tip-week {
    font-weight: 800;
    margin-bottom: 6px;
    color: #fff;
}
.wave-tip-row {
    margin-top: 3px;
}
.wave-tip-label {
    flex: 1 1 auto;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.wave-tip-value {
    font-weight: 800;
    color: #fff;
}
.wave-tip-total {
    margin-top: 6px;
    padding-top: 6px;
    border-top: 1px solid rgba(255, 255, 255, 0.18);
}
</style>
