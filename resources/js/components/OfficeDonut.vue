<template>
    <div class="od-wrap">
        <svg
            class="od-donut"
            :width="size"
            :height="size"
            viewBox="0 0 170 170"
            role="img"
            :aria-label="`${ariaLabel}, total ${total}`"
        >
            <circle class="od-track" cx="85" cy="85" r="64" fill="none" stroke-width="22" />
            <circle
                v-for="s in segments"
                :key="s.key"
                class="od-seg"
                :class="{ 'is-dim': activeKey && activeKey !== s.key, 'is-on': activeKey === s.key }"
                cx="85"
                cy="85"
                r="64"
                fill="none"
                :stroke="s.color"
                :stroke-width="activeKey === s.key ? 26 : 22"
                :stroke-dasharray="`${s.dash} ${circumference}`"
                :stroke-dashoffset="-s.offset"
                transform="rotate(-90 85 85)"
                tabindex="0"
                :aria-label="`${s.fullName || s.label}: ${s.count} (${s.pct}%)`"
                @mouseenter="activeKey = s.key"
                @mouseleave="activeKey = null"
                @focus="activeKey = s.key"
                @blur="activeKey = null"
            />
            <text class="od-big" x="85" y="87" text-anchor="middle">
                {{ active ? active.count : total }}
            </text>
            <text class="od-sub" x="85" y="105" text-anchor="middle">
                {{ active ? active.label : totalLabel }}
            </text>
        </svg>

        <ul class="od-list">
            <li
                v-for="s in slices"
                :key="s.key"
                class="od-row"
                :class="{ 'is-active': activeKey === s.key, 'is-dim': activeKey && activeKey !== s.key }"
                tabindex="0"
                :aria-label="`${s.fullName || s.label}: ${s.count} (${s.pct}%)`"
                @mouseenter="activeKey = s.key"
                @mouseleave="activeKey = null"
                @focus="activeKey = s.key"
                @blur="activeKey = null"
            >
                <div class="od-top">
                    <span class="od-dot" :style="{ background: s.color }" aria-hidden="true" />
                    <span class="od-name" :title="s.fullName">{{ s.label }}</span>
                    <span class="od-n">{{ s.count }}</span>
                    <span class="od-p">{{ s.pct }}%</span>
                </div>
                <div class="od-bar">
                    <i :style="{ width: `${s.pct}%`, background: s.color }" />
                </div>
            </li>
        </ul>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'

// Donut + legend for the overdue-by-office cards. Segments and rows share
// one hover/focus state: the centre shows the hovered office and the other
// slices dim. Nothing is clickable; these charts are display-only.
const props = defineProps({
    // [{ key, label, fullName, count, pct, color }], already in slice order.
    slices: { type: Array, default: () => [] },
    size: { type: Number, default: 140 },
    ariaLabel: { type: String, default: 'Overdue by office' },
    totalLabel: { type: String, default: 'Total overdue' },
})

const RADIUS = 64
const circumference = 2 * Math.PI * RADIUS
const activeKey = ref(null)

const total = computed(() => props.slices.reduce((sum, s) => sum + (s.count || 0), 0))
const active = computed(() => props.slices.find((s) => s.key === activeKey.value) || null)

const segments = computed(() => {
    if (!total.value) return []
    const gap = props.slices.length > 1 ? 3 : 0
    let offset = 0

    return props.slices.map((s) => {
        const length = ((s.count || 0) / total.value) * circumference
        const segment = {
            ...s,
            dash: Math.max(length - gap, 0),
            offset,
        }
        offset += length
        return segment
    })
})
</script>

<style scoped>
.od-wrap {
    display: flex;
    align-items: center;
    gap: 16px;
    width: 100%;
    min-width: 0;
}
.od-donut {
    flex: 0 0 auto;
    display: block;
    overflow: visible;
}
.od-track {
    stroke: rgba(var(--v-theme-on-surface), 0.08);
}
.od-seg {
    transition: opacity 0.15s ease, stroke-width 0.15s ease;
}
.od-seg.is-dim {
    opacity: 0.25;
}
.od-seg:focus-visible {
    outline: none;
    stroke-width: 26;
}
.od-big {
    font-size: 30px;
    font-weight: 700;
    fill: rgb(var(--v-theme-on-surface));
    font-variant-numeric: tabular-nums;
}
.od-sub {
    font-size: 11.5px;
    fill: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.od-list {
    flex: 1 1 0;
    min-width: 0;
    padding: 0;
    margin: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 2px;
}
.od-row {
    padding: 4px 6px;
    border-radius: 8px;
    transition: background-color 0.15s ease, opacity 0.15s ease;
}
.od-row.is-active,
.od-row:focus-visible {
    background: rgba(var(--v-theme-on-surface), 0.06);
    outline: none;
}
.od-row.is-dim {
    opacity: 0.45;
}
.od-top {
    display: flex;
    align-items: center;
    gap: 6px;
    min-width: 0;
    font-size: 12px;
    font-weight: 600;
}
.od-dot {
    flex: 0 0 auto;
    width: 8px;
    height: 8px;
    border-radius: 2px;
}
.od-name {
    flex: 1 1 auto;
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.od-n {
    font-weight: 700;
    font-variant-numeric: tabular-nums;
}
.od-p {
    width: 42px;
    text-align: right;
    font-size: 11px;
    font-variant-numeric: tabular-nums;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.od-bar {
    height: 3px;
    margin-top: 4px;
    border-radius: 2px;
    background: rgba(var(--v-theme-on-surface), 0.08);
    overflow: hidden;
}
.od-bar i {
    display: block;
    height: 100%;
    border-radius: 2px;
}
.od-row.is-active .od-bar,
.od-row:focus-visible .od-bar {
    background: rgba(var(--v-theme-on-surface), 0.12);
}
@container (max-width: 320px) {
    .od-wrap {
        gap: 10px;
    }
    .od-top {
        gap: 4px;
        font-size: 11px;
    }
    .od-row {
        padding: 3px 4px;
    }
    .od-p {
        width: 34px;
        font-size: 10px;
    }
}
</style>
