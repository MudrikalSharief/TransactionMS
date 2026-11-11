<template>
    <!-- Part-to-whole pie (e.g. overdue transactions by office). Slices come in the colour
         palette's own order (the caller sorts them), so neighbouring slices
         are always palette neighbours, the pairs the palette is validated
         for. A 2px surface gap separates slices; names, counts and shares
         are in the legend beside it, so colour never carries identity alone. -->
    <div class="pp" :style="{ width: size + 'px', height: size + 'px' }">
        <svg
            :viewBox="`0 0 ${size} ${size}`"
            :width="size"
            :height="size"
            role="img"
            :aria-label="ariaLabel"
            @mouseleave="setHover(null)"
        >
            <g :transform="`translate(${size / 2} ${size / 2})`">
                <path
                    v-for="s in arcs"
                    :key="s.key"
                    :d="s.d"
                    :fill="s.color"
                    class="pp-slice"
                    :class="{ 'is-dim': hover && hover !== s.key, 'is-on': hover === s.key, 'is-open': s.id != null }"
                    :style="{ transform: hover === s.key ? `translate(${s.nx * 4}px, ${s.ny * 4}px)` : null }"
                    @mouseenter="setHover(s.key)"
                    @click="s.id != null && $emit('open', s)"
                />
            </g>
        </svg>

        <!-- Hover tooltip at the slice's middle; text in ink, not the
             series colour (the swatch carries identity). -->
        <div
            v-if="hovered"
            class="pp-tip"
            :class="`is-${hovered.vside || 'above'}`"
            :style="{ left: hovered.tx + 'px', top: hovered.ty + 'px' }"
            role="status"
        >
            <div class="pp-tip-name">
                <i :style="{ background: hovered.color }" />
                <span>{{ hovered.name }}</span>
            </div>
            <div class="pp-tip-val">
                <b>{{ hovered.count }}</b> · {{ hovered.pct }}%
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
    // [{ key, id, name, count, pct, color }], already in palette order
    slices: { type: Array, default: () => [] },
    size: { type: Number, default: 168 },
    hover: { type: [String, Number, null], default: null },
    // What the pie shows, for screen readers.
    label: { type: String, default: "Transactions by process" },
});
const emit = defineEmits(["update:hover", "open"]);

const total = computed(() => props.slices.reduce((s, x) => s + x.count, 0));

function setHover(key) {
    if (key !== props.hover) emit("update:hover", key);
}

// Arc paths from 12 o'clock, clockwise; a lone slice is a full circle.
const arcs = computed(() => {
    const r = props.size / 2 - 6; // room for the hover lift
    const list = props.slices.filter((s) => s.count > 0);
    if (!total.value) return [];
    if (list.length === 1) {
        const s = list[0];
        return [{ ...s, nx: 0, ny: 0, tx: props.size / 2, ty: -6, vside: "above", d: `M0 ${-r}A${r} ${r} 0 1 1 0 ${r}A${r} ${r} 0 1 1 0 ${-r}Z` }];
    }
    let a0 = -Math.PI / 2;
    return list.map((s) => {
        const sweep = (s.count / total.value) * Math.PI * 2;
        const a1 = a0 + sweep;
        const mid = a0 + sweep / 2;
        const p = (a) => `${(r * Math.cos(a)).toFixed(2)} ${(r * Math.sin(a)).toFixed(2)}`;
        const d = `M0 0L${p(a0)}A${r} ${r} 0 ${sweep > Math.PI ? 1 : 0} 1 ${p(a1)}Z`;
        a0 = a1;
        return {
            ...s,
            d,
            nx: Math.cos(mid),
            ny: Math.sin(mid),
            // Tooltip centred just above the pie: the card always has room
            // there (the space under the pie is the card edge), so it never
            // gets cut and never covers the slice.
            tx: props.size / 2,
            ty: -6,
            vside: "above",
        };
    });
});

const hovered = computed(() => arcs.value.find((s) => s.key === props.hover) || null);

const ariaLabel = computed(
    () =>
        props.label + ": " +
        props.slices.map((s) => `${s.name} ${s.count} (${s.pct}%)`).join(", "),
);
</script>

<style scoped>
.pp {
    position: relative;
    flex: none;
}
.pp svg {
    display: block;
    overflow: visible;
}
.pp-slice {
    /* 2px surface gap between neighbouring slices */
    stroke: rgb(var(--v-theme-surface));
    stroke-width: 2;
    stroke-linejoin: round;
    transition: opacity 0.15s ease, transform 0.15s ease;
}
.pp-slice.is-open {
    cursor: pointer;
}
.pp-slice.is-dim {
    opacity: 0.35;
}
/* Anchored at a point just outside the rim, opening away from the pie. */
.pp-tip {
    position: absolute;
    z-index: 2;
    width: max-content;
    min-width: 96px;
    max-width: 190px;
    padding: 6px 9px;
    border-radius: 8px;
    background: rgb(var(--v-theme-surface));
    border: 1px solid rgba(var(--v-border-color), 0.18);
    box-shadow: 0 6px 18px -6px rgba(15, 23, 42, 0.35);
    pointer-events: none;
    font-size: 12px;
    line-height: 1.35;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.pp-tip.is-above { transform: translate(-50%, -100%); }
.pp-tip.is-below { transform: translate(-50%, 0); }
.pp-tip-name {
    display: flex;
    align-items: flex-start;
    gap: 6px;
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.pp-tip-name i {
    flex: none;
    margin-top: 4px;
    width: 9px;
    height: 9px;
    border-radius: 2px;
}
.pp-tip-name span {
    /* Long names wrap instead of being cut. */
    overflow-wrap: break-word;
}
.pp-tip-val b {
    color: rgb(var(--v-theme-on-surface));
}
</style>
