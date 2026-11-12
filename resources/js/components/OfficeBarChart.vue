<template>
    <!-- Horizontal bars, one per office, busiest first. Hover or focus shows a
         few of its transactions and who is assigned; click or Enter opens the
         office's full list. -->
    <div ref="rootEl" class="ob" :style="{ '--ob-color': color }" role="group" :aria-label="ariaLabel">
        <div
            v-for="row in rows"
            :key="row.key"
            :ref="(el) => (rowEls[row.key] = el)"
            class="ob-row"
            :class="{ 'is-hot': hover === row.key, 'is-cold': hover && hover !== row.key }"
            role="button"
            tabindex="0"
            :aria-label="`${row.name}: ${row.count} ${unit(row.count)}. Press Enter for the list`"
            @mouseenter="show(row)"
            @mouseleave="hide"
            @focus="show(row)"
            @blur="hide"
            @click="emit('open', row, rowEls[row.key])"
            @keydown.enter.prevent="emit('open', row, rowEls[row.key])"
        >
            <!-- Office in charge, with the people in charge under it. -->
            <span class="ob-label">
                <span class="ob-name" :title="row.name">{{ row.name }}</span>
                <span v-if="row.people?.length" class="ob-people" :title="row.people.join(', ')">{{ row.people.join(', ') }}</span>
            </span>
            <span class="ob-track" aria-hidden="true">
                <span class="ob-fill" :style="{ width: barWidth(row) }" />
            </span>
            <span class="ob-count">{{ row.count }}</span>
        </div>

        <!-- Tooltip under (or over) the hovered bar, same look as the pie's. -->
        <div v-if="tip" class="ob-tip" :class="`is-${tip.side}`" :style="{ top: tip.y + 'px' }" role="status">
            <div class="ob-tip-name">
                <i aria-hidden="true" />
                <span>{{ tip.row.name }}</span>
            </div>
            <div class="ob-tip-val"><b>{{ tip.row.count }}</b> {{ unit(tip.row.count) }}</div>
            <ul v-if="tip.row.samples?.length" class="ob-tip-list">
                <li v-for="s in tip.row.samples" :key="s.reference_number">
                    <b>{{ s.reference_number }}</b>
                    <span>{{ s.assigned?.length ? s.assigned.join(', ') : 'No one assigned yet' }}</span>
                </li>
            </ul>
            <div v-if="more(tip.row)" class="ob-tip-more">+{{ more(tip.row) }} more · click for the list</div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
    // [{ key, id, code, name, count, transactions, samples: [{ reference_number, assigned: [] }] }]
    rows: { type: Array, default: () => [] },
    color: { type: String, default: '#005EED' },
    // Singular / plural name of what is counted.
    noun: { type: Array, default: () => ['transaction', 'transactions'] },
    label: { type: String, default: 'Transactions by office' },
})
const emit = defineEmits(['open'])

const rootEl = ref(null)
const rowEls = {}
const hover = ref(null)
const tip = ref(null)

const max = computed(() => Math.max(1, ...props.rows.map((r) => r.count)))
const unit = (n) => (n === 1 ? props.noun[0] : props.noun[1])
// A sliver stays visible for the smallest office.
const barWidth = (row) => `${Math.max(4, (row.count / max.value) * 100)}%`
const more = (row) => Math.max(0, (row.transactions ?? row.count) - (row.samples?.length || 0))

function show(row) {
    hover.value = row.key
    const el = rowEls[row.key]
    const box = rootEl.value
    if (!el || !box) return
    // Below the bar in the top half, above it in the bottom half.
    const below = el.offsetTop + el.offsetHeight / 2 < box.clientHeight / 2
    tip.value = { row, side: below ? 'below' : 'above', y: below ? el.offsetTop + el.offsetHeight : el.offsetTop }
}

function hide() {
    hover.value = null
    tip.value = null
}

const ariaLabel = computed(() => `${props.label}: ` + props.rows.map((r) => `${r.name} ${r.count}`).join(', '))
</script>

<style scoped>
.ob {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    height: 100%;
    min-height: 0;
}
.ob-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(60px, 0.8fr) auto;
    align-items: center;
    gap: 10px;
    flex: 1 1 0;
    max-height: 48px;
    min-height: 26px;
    padding: 0 8px;
    border-radius: 8px;
    cursor: pointer;
    outline: none;
    transition: background-color 0.15s ease, opacity 0.15s ease;
}
.ob-row:hover,
.ob-row:focus-visible,
.ob-row.is-hot {
    background: rgba(var(--v-theme-on-surface), 0.04);
}
.ob-row:focus-visible {
    box-shadow: inset 0 0 0 2px color-mix(in srgb, var(--ob-color) 45%, transparent);
}
.ob-row.is-cold {
    opacity: 0.45;
}
.ob-label {
    display: flex;
    flex-direction: column;
    min-width: 0;
    line-height: 1.25;
}
.ob-name,
.ob-people {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.ob-name {
    font-size: 0.8rem;
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.ob-people {
    font-size: 0.7rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.ob-track {
    position: relative;
    height: 12px;
    border-radius: 999px;
    background: rgba(var(--v-theme-on-surface), 0.06);
    overflow: hidden;
}
.ob-fill {
    position: absolute;
    inset: 0 auto 0 0;
    border-radius: inherit;
    background: linear-gradient(90deg, color-mix(in srgb, var(--ob-color) 72%, white), var(--ob-color));
    transition: width 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
}
.ob-count {
    min-width: 1.6em;
    text-align: right;
    font-size: 0.95rem;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    color: rgb(var(--v-theme-on-surface));
}
.ob-tip {
    position: absolute;
    z-index: 3;
    right: 8px;
    width: max-content;
    min-width: 150px;
    max-width: min(260px, 90%);
    padding: 7px 10px;
    border-radius: 8px;
    background: rgb(var(--v-theme-surface));
    border: 1px solid rgba(var(--v-border-color), 0.18);
    box-shadow: 0 6px 18px -6px rgba(15, 23, 42, 0.35);
    pointer-events: none;
    font-size: 12px;
    line-height: 1.35;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.ob-tip.is-below {
    transform: translateY(4px);
}
.ob-tip.is-above {
    transform: translateY(calc(-100% - 4px));
}
.ob-tip-name {
    display: flex;
    align-items: flex-start;
    gap: 6px;
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.ob-tip-name i {
    flex: none;
    margin-top: 4px;
    width: 9px;
    height: 9px;
    border-radius: 2px;
    background: var(--ob-color);
}
.ob-tip-name span {
    overflow-wrap: break-word;
}
.ob-tip-val b {
    color: rgb(var(--v-theme-on-surface));
}
.ob-tip-list {
    margin: 5px 0 0;
    padding: 5px 0 0;
    list-style: none;
    border-top: 1px solid rgba(var(--v-border-color), 0.12);
}
.ob-tip-list li {
    display: flex;
    flex-direction: column;
    padding: 2px 0;
}
.ob-tip-list b {
    color: rgb(var(--v-theme-on-surface));
    font-variant-numeric: tabular-nums;
}
.ob-tip-more {
    margin-top: 3px;
    font-style: italic;
}
@media (prefers-reduced-motion: reduce) {
    .ob-row,
    .ob-fill {
        transition: none;
    }
}
</style>
