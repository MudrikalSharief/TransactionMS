<template>
    <div class="bar-stage d-flex flex-column justify-center" :style="{ minHeight: stageHeight + 'px' }">
        <div v-if="loading" class="d-flex align-center justify-center" :style="{ height: stageHeight + 'px' }">
            <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
        </div>
        <div v-else-if="!total" class="text-center text-medium-emphasis">
            <v-icon size="40" color="grey-lighten-1">mdi-chart-bar</v-icon>
            <div class="mt-2 font-weight-bold">{{ emptyText }}</div>
        </div>
        <template v-else>
            <div class="bar-legend">
                <span
                    v-for="layer in layers"
                    :key="layer.label"
                    class="bar-legend-item"
                    :class="{ active: legendHover === layer.label, dimmed: legendHover && legendHover !== layer.label }"
                    @mouseenter="legendHover = layer.label"
                    @mouseleave="legendHover = null"
                >
                    <span class="bar-legend-dot" :style="{ background: layer.color }" />
                    {{ layer.label }}
                </span>
            </div>
            <div ref="plotRef" class="bar-svg-wrap" @mousemove="onHover" @mouseleave="hoverIndex = -1">
                <svg :viewBox="`0 0 ${viewW} ${viewH}`" width="100%" height="100%" role="img" :aria-label="ariaLabel">
                    <!-- hovered group wash -->
                    <rect
                        v-if="hoverIndex >= 0"
                        class="bar-band"
                        :x="leftPad + bandW * hoverIndex"
                        :y="topPad"
                        :width="bandW"
                        :height="plotH"
                    />
                    <!-- gridlines + y labels at every tick -->
                    <line
                        v-for="t in yTicks"
                        :key="'g' + t"
                        class="bar-grid"
                        :class="{ 'bar-baseline': t === 0 }"
                        :x1="leftPad"
                        :x2="viewW - rightPad"
                        :y1="yFor(t)"
                        :y2="yFor(t)"
                    />
                    <text
                        v-for="t in yTicks"
                        :key="'y' + t"
                        class="bar-axis-text"
                        :x="leftPad - 6"
                        :y="yFor(t) + 4"
                        text-anchor="end"
                    >
                        {{ t }}
                    </text>
                    <!-- one bar per series inside each group -->
                    <path
                        v-for="bar in bars"
                        :key="bar.key"
                        :d="bar.d"
                        :fill="bar.color"
                        :opacity="barOpacity(bar)"
                    />
                    <!-- x labels, one per group -->
                    <text
                        v-for="(label, i) in groupLabels"
                        v-show="labelEvery === 1 || i % labelEvery === 0"
                        :key="'l' + i"
                        class="bar-axis-text"
                        :class="{ 'bar-axis-text--active': i === hoverIndex }"
                        :x="leftPad + bandW * (i + 0.5)"
                        :y="viewH - 4"
                        text-anchor="middle"
                    >
                        {{ label }}
                    </text>
                </svg>
                <!-- hover breakdown tooltip -->
                <div v-if="hoverIndex >= 0" class="bar-tip" :style="tipStyle">
                    <div class="bar-tip-group">{{ groupLabels[hoverIndex] }}</div>
                    <div v-for="layer in tipRows" :key="layer.label" class="bar-tip-row">
                        <span class="bar-legend-dot" :style="{ background: layer.color }" />
                        <span class="bar-tip-label">{{ layer.label }}</span>
                        <span class="bar-tip-value">{{ layer.values[hoverIndex] || 0 }}</span>
                    </div>
                    <div class="bar-tip-row bar-tip-total">
                        <span class="bar-tip-label">Total</span>
                        <span class="bar-tip-value">{{ groupTotals[hoverIndex] || 0 }}</span>
                    </div>
                </div>
            </div>
            <!-- Same numbers as a table, for screen readers. -->
            <table class="d-sr-only">
                <caption>{{ ariaLabel }}</caption>
                <thead>
                    <tr>
                        <th scope="col" />
                        <th v-for="(label, i) in groupLabels" :key="i" scope="col">{{ label }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="layer in layers" :key="layer.label">
                        <th scope="row">{{ layer.label }}</th>
                        <td v-for="(label, i) in groupLabels" :key="i">{{ layer.values[i] || 0 }}</td>
                    </tr>
                </tbody>
            </table>
        </template>
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'

// Grouped bar chart: one cluster per group (e.g. a week), one bar per series.
const props = defineProps({
    series: { type: Array, default: () => [] }, // [{ label, color, values: [] }], values aligned to groupLabels
    groupLabels: { type: Array, default: () => [] },
    loading: { type: Boolean, default: false },
    height: { type: Number, default: 190 },
    emptyText: { type: String, default: 'No data yet' },
    ariaLabel: { type: String, default: 'Bar chart' },
})

const plotRef = ref(null)
const wrapW = ref(640)
const wrapH = ref(null)
const hoverIndex = ref(-1)
const legendHover = ref(null)
let observer = null

// Render the SVG in true pixels (viewBox matches rendered size 1:1)
// so bars and text stay crisp at any container size.
const viewW = computed(() => Math.max(280, Math.round(wrapW.value || 640)))
const viewH = computed(() => Math.max(140, Math.round(wrapH.value || props.height)))

const leftPad = 30
const rightPad = 8
const topPad = 8
const xLabelH = 20
const plotH = computed(() => viewH.value - topPad - xLabelH)

const stageHeight = computed(() => props.height + 8)

// Series with nothing to draw are dropped; the rest keep their given order.
const layers = computed(() => (props.series || []).filter((s) => (s.values || []).some((v) => v > 0)))

const groupTotals = computed(() =>
    props.groupLabels.map((_, i) => layers.value.reduce((sum, layer) => sum + (layer.values[i] || 0), 0)),
)
const total = computed(() => groupTotals.value.reduce((s, v) => s + v, 0))
const max = computed(() => Math.max(0, ...layers.value.flatMap((layer) => layer.values.map((v) => v || 0))))

// Y ticks on clean whole numbers (1, 2, 5, 10, …), topping out at or above the tallest bar.
const yTicks = computed(() => {
    const m = max.value
    if (m <= 0) return [0]
    const raw = m / 4
    const pow = 10 ** Math.floor(Math.log10(raw))
    const f = raw / pow
    const step = Math.max(1, (f <= 1 ? 1 : f <= 2 ? 2 : f <= 5 ? 5 : 10) * pow)
    const count = Math.ceil(m / step)
    return Array.from({ length: count + 1 }, (_, i) => i * step)
})
const yMax = computed(() => yTicks.value[yTicks.value.length - 1] || 1)

function yFor(value) {
    return topPad + plotH.value * (1 - value / yMax.value)
}

// Each group gets an equal band; its bars sit centered in it, thin (capped
// width) with a small gap, so the leftover band width stays empty.
const BAR_MAX = 24
const BAR_GAP = 2
const bandW = computed(() => {
    const n = props.groupLabels.length
    return n ? (viewW.value - leftPad - rightPad) / n : 0
})
const barW = computed(() => {
    const n = layers.value.length || 1
    return Math.max(2, Math.min(BAR_MAX, (bandW.value * 0.8 - (n - 1) * BAR_GAP) / n))
})

// Rounded at the top, square on the baseline.
function barPath(x, y, w, h) {
    const r = Math.min(4, w / 2, h)
    const bottom = y + h
    return `M ${x} ${bottom} L ${x} ${y + r} Q ${x} ${y} ${x + r} ${y} L ${x + w - r} ${y} Q ${x + w} ${y} ${x + w} ${y + r} L ${x + w} ${bottom} Z`
}

const bars = computed(() => {
    const n = layers.value.length
    const clusterW = n * barW.value + (n - 1) * BAR_GAP
    const out = []
    props.groupLabels.forEach((_, g) => {
        const x0 = leftPad + bandW.value * g + (bandW.value - clusterW) / 2
        layers.value.forEach((layer, s) => {
            const value = layer.values[g] || 0
            if (!value) return
            const h = (plotH.value * value) / yMax.value
            out.push({
                key: `${layer.label}-${g}`,
                group: g,
                label: layer.label,
                color: layer.color,
                d: barPath(x0 + s * (barW.value + BAR_GAP), topPad + plotH.value - h, barW.value, h),
            })
        })
    })
    return out
})

function barOpacity(bar) {
    if (legendHover.value && legendHover.value !== bar.label) return 0.15
    if (hoverIndex.value >= 0 && hoverIndex.value !== bar.group) return 0.45
    return 1
}

// Tooltip rows: every series with a bar in the hovered group, biggest first.
const tipRows = computed(() => {
    const i = hoverIndex.value
    if (i < 0) return []
    return layers.value
        .filter((layer) => (layer.values[i] || 0) > 0)
        .sort((a, b) => b.values[i] - a.values[i])
})

// Beside the hovered group, flipped to its left on the right half of the
// chart; clamped so a narrow chart never pushes the tip out of view.
const tipStyle = computed(() => {
    const bandLeft = leftPad + bandW.value * hoverIndex.value
    const flip = bandLeft + bandW.value / 2 > viewW.value * 0.5
    const limit = Math.max(4, viewW.value - 162)
    return {
        top: '4px',
        left: flip ? 'auto' : `${Math.min(bandLeft + bandW.value + 4, limit)}px`,
        right: flip ? `${Math.min(viewW.value - bandLeft + 4, limit)}px` : 'auto',
    }
})

// Show every label when there is room, otherwise every second one.
const labelEvery = computed(() => (bandW.value >= 58 ? 1 : 2))

function onHover(e) {
    const rect = plotRef.value?.getBoundingClientRect()
    const n = props.groupLabels.length
    if (!rect?.width || !n) return
    const x = (e.clientX - rect.left) * (viewW.value / rect.width)
    hoverIndex.value = Math.max(0, Math.min(n - 1, Math.floor((x - leftPad) / bandW.value)))
}

// The plot only exists once there is data, so follow the ref as it comes and goes.
watch(plotRef, (el) => {
    observer?.disconnect()
    if (el) observer?.observe(el)
})

onMounted(() => {
    if (typeof ResizeObserver === 'undefined') return
    observer = new ResizeObserver((entries) => {
        const rect = entries[0]?.contentRect
        // Deadband: ignore subpixel jitter so the observer can settle.
        if (rect?.width && Math.abs(wrapW.value - rect.width) > 0.5) wrapW.value = rect.width
        if (rect?.height && Math.abs((wrapH.value ?? props.height) - rect.height) > 0.5) {
            wrapH.value = rect.height
        }
    })
    if (plotRef.value) observer.observe(plotRef.value)
})

onUnmounted(() => {
    observer?.disconnect()
    observer = null
})
</script>

<style scoped>
.bar-stage {
    position: relative;
    width: 100%;
    max-width: 100%;
    min-width: 0;
    height: 100%;
    flex: 1 1 auto;
    overflow: hidden;
}
.bar-stage svg {
    /* Absolute: the svg must not contribute to the flex layout,
       otherwise measured size -> viewBox -> content size loops forever. */
    position: absolute;
    inset: 0;
    display: block;
    width: 100%;
    height: 100%;
    max-width: 100%;
}
.bar-stage svg text {
    font-family: inherit;
}
.bar-grid {
    stroke: rgba(var(--v-theme-on-surface), 0.08);
    stroke-width: 1;
}
.bar-baseline {
    stroke: rgba(var(--v-theme-on-surface), 0.24);
}
.bar-band {
    fill: rgba(var(--v-theme-on-surface), 0.05);
}
.bar-axis-text {
    font-size: 11px;
    font-weight: 700;
    fill: rgba(var(--v-theme-on-surface), 0.55);
}
.bar-axis-text--active {
    fill: rgb(var(--v-theme-on-surface));
}
.bar-legend {
    display: flex;
    flex-wrap: wrap;
    gap: 4px 14px;
    padding: 2px 2px 8px;
    font-size: 11px;
    font-weight: 700;
    color: rgba(var(--v-theme-on-surface), 0.7);
}
.bar-legend-item {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 1px 7px;
    border-radius: 6px;
    cursor: default;
}
.bar-legend-item.active {
    background: rgba(var(--v-theme-on-surface), 0.06);
}
.bar-legend-item.dimmed {
    opacity: 0.45;
}
.bar-legend-dot {
    width: 10px;
    height: 10px;
    border-radius: 3px;
    flex-shrink: 0;
}
.bar-svg-wrap {
    position: relative;
    flex: 1 1 auto;
    min-height: 0;
    min-width: 0;
    max-width: 100%;
    overflow: hidden;
}
.bar-tip {
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
.bar-tip-group {
    font-weight: 800;
    margin-bottom: 6px;
    color: #fff;
}
.bar-tip-row {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 3px;
}
.bar-tip-label {
    flex: 1 1 auto;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.bar-tip-value {
    font-weight: 800;
    color: #fff;
}
.bar-tip-total {
    margin-top: 6px;
    padding-top: 6px;
    border-top: 1px solid rgba(255, 255, 255, 0.18);
}
</style>
