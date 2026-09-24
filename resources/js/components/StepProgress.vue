<template>
    <v-card rounded="0" min-width="320" :max-width="fluid ? undefined : 520" :style="fluid ? 'width: 100%' : ''" elevation="4">
        <v-card-title class="pa-5 pb-3">
            <div class="text-h6 font-weight-bold">{{ title }}</div>
            <div v-if="positionLabel" class="text-subtitle-2 text-medium-emphasis font-weight-bold mt-1">
                {{ positionLabel }}
            </div>
        </v-card-title>
        <v-divider />
        <v-card-text class="pa-5" style="overflow-x: auto">
            <div v-if="!ordered.length" class="text-caption text-medium-emphasis pa-2">
                Step details unavailable.
            </div>
            <div v-else-if="!useSnake" class="d-flex align-start">
                <template v-for="(s, i) in ordered" :key="s.id ?? s.code ?? i">
                    <StationNode
                        :s="s"
                        :index="i"
                        :state="stateOf(i)"
                        :is-last="isLast(i)"
                        :detail="detailFor(s)"
                        :move="moveFor(s)"
                    />
                    <div
                        v-if="i < ordered.length - 1"
                        class="step-link flex-shrink-0"
                        :class="i < currentIdx ? 'done' : ''"
                    />
                </template>
            </div>
            <div v-else class="snake-wrap" ref="snakeWrap">
                <svg v-if="turnPath" class="snake-svg" aria-hidden="true"><path :d="turnPath" :class="turnDone ? 'done' : ''" /></svg>
                <template v-for="(row, r) in snakeRows" :key="r">
                    <div class="d-flex align-start snake-row" :class="r === 1 ? 'snake-reverse' : ''">
                <template v-for="({ s, i }, j) in row" :key="s.id ?? s.code ?? i">
                            <StationNode
                                :s="s"
                                :index="i"
                                :state="stateOf(i)"
                                :is-last="isLast(i)"
                                :detail="detailFor(s)"
                                :move="moveFor(s)"
                                :data-node="i"
                            />
                            <div
                                v-if="showLink(r, j, i)"
                                class="step-link flex-shrink-0"
                                :class="i < currentIdx ? 'done' : ''"
                            />
                        </template>
                    </div>
                </template>
            </div>
        </v-card-text>
        <template v-if="$slots.actions">
            <v-divider />
            <div class="pa-4">
                <div class="d-flex align-center mb-3">
                    <v-icon color="grey-darken-3" class="mr-2">mdi-swap-horizontal</v-icon>
                    <span class="text-subtitle-1 font-weight-bold">Available Actions</span>
                </div>
                <slot name="actions" />
            </div>
        </template>
    </v-card>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import StationNode from '@/components/StationNode.vue'

const props = defineProps({
    // [{ id, order_number, code, name, is_start, is_end }]
    steps: { type: Array, default: () => [] },
    currentStepId: { type: [Number, String, null], default: null },
    currentStepCode: { type: String, default: '' },
    title: { type: String, default: 'Progress' },
    fluid: { type: Boolean, default: false },
    // When the caller pre-orders hierarchical rows depth-first
    // (1, 1.1, 1.2, 2…), skip the order_number sort.
    preserveOrder: { type: Boolean, default: false },
    // station_checklist entries [{ step, requirements, fields }] for hover detail.
    details: { type: Array, default: () => [] },
    // transaction_step_runs for the "moved" line per station.
    runs: { type: Array, default: () => [] },
    // Station ids the paper has already passed (from meta.visited_step_ids).
    // Visited stations behind current read green (done); visited stations
    // ahead read yellow (passed); never-visited ahead stay grey.
    visitedStepIds: { type: Array, default: () => [] },
})

const visitedSet = computed(() => new Set((props.visitedStepIds || []).map((v) => String(v))))

const ordered = computed(() => {
    const list = [...(props.steps || [])]
    if (props.preserveOrder) return list
    list.sort((a, b) => (a.order_number ?? 0) - (b.order_number ?? 0))
    return list
})

const currentIdx = computed(() => {
    if (!ordered.value.length) return -1
    if (props.currentStepId !== null && props.currentStepId !== undefined) {
        const i = ordered.value.findIndex((s) => String(s.id) === String(props.currentStepId))
        if (i >= 0) return i
    }
    if (props.currentStepCode) {
        const i = ordered.value.findIndex((s) => s.code === props.currentStepCode)
        if (i >= 0) return i
    }
    return -1
})

const positionLabel = computed(() => {
    if (currentIdx.value < 0 || !ordered.value.length) return ''
    return `STEP ${currentIdx.value + 1} OF ${ordered.value.length}`
})

// Serpentine: full-width trackers with more than a row's worth of
// stations wrap into 2 connected rows (across, down, back) instead of
// sliding out of view. Popouts and short flows keep the single row.
const SNAKE_WRAP_AT = 7

const useSnake = computed(() => props.fluid && ordered.value.length > SNAKE_WRAP_AT)

const snakeSplit = computed(() => Math.ceil(ordered.value.length / 2));

const snakeRows = computed(() => {
    if (!useSnake.value) return []
    const k = snakeSplit.value
    const first = ordered.value.slice(0, k).map((s, i) => ({ s, i }))
    const second = ordered.value.slice(k).map((s, j) => ({ s, i: k + j }))
    return [first, second]
});

// Row 1's tail link is suppressed: the measured SVG joint takes over,
// running avatar-center → lane → avatar-center so 7→8 truly connects.
function showLink(r, j, i) {
    if (i >= ordered.value.length - 1) return false
    if (useSnake.value && r === 0 && j === snakeRows.value[0].length - 1) return false
    return true
}

// The U-turn link joins row 1's last node to row 2's first node:
// green once the paper has passed the turn.
const turnDone = computed(() => {
    if (!useSnake.value) return false
    return currentIdx.value >= snakeSplit.value
});

// Measured joint: node centers + lane come from live layout, so the
// connector joins avatar to avatar whatever the label heights do.
const snakeWrap = ref(null);
const turnGeom = ref({ w: 0, y1: 0, y2: 0 });

function measureTurn() {
    const reset = { w: 0, y1: 0, y2: 0 };
    const wrap = snakeWrap.value;
    if (!wrap || !useSnake.value) {
        turnGeom.value = reset;
        return;
    }
    const k = snakeSplit.value;
    const a = wrap.querySelector(`[data-node="${k - 1}"] .v-avatar`);
    const b = wrap.querySelector(`[data-node="${k}"] .v-avatar`);
    if (!a || !b) {
        turnGeom.value = reset;
        return;
    }
    const wr = wrap.getBoundingClientRect();
    const ra = a.getBoundingClientRect();
    const rb = b.getBoundingClientRect();
    turnGeom.value = {
        w: wr.width,
        y1: ra.top - wr.top + ra.height / 2,
        y2: rb.top - wr.top + rb.height / 2,
    };
}

const turnPath = computed(() => {
    const { w, y1, y2 } = turnGeom.value;
    if (!w || !useSnake.value) return '';
    const xNode = w - 24 - 55; // node centers (110px columns, 24px turn lane)
    const xLane = w - 12; // turn lane center
    return `M ${xNode} ${y1} H ${xLane} V ${y2} H ${xNode}`;
});

let turnObserver = null;

watch([ordered, currentIdx, useSnake], () => {
    nextTick(measureTurn);
});

onMounted(() => {
    nextTick(measureTurn);
    window.addEventListener('resize', measureTurn);
    if (window.ResizeObserver) {
        turnObserver = new ResizeObserver(() => measureTurn());
        if (snakeWrap.value) turnObserver.observe(snakeWrap.value);
    }
});

onUnmounted(() => {
    window.removeEventListener('resize', measureTurn);
    if (turnObserver) turnObserver.disconnect();
});

function stateOf(i) {
    if (currentIdx.value < 0) return 'upcoming'
    if (i === currentIdx.value) return 'current'
    const s = ordered.value[i]
    if (s && visitedSet.value.has(String(s.id))) {
        return i < currentIdx.value ? 'done' : 'passed'
    }
    if (i < currentIdx.value) return 'done'
    return 'upcoming'
}

function isLast(i) {
    return i === ordered.value.length - 1
}

// station_checklist entry per step id for hover detail.
const detailById = computed(() => {
    const map = new Map()
    for (const d of (props.details || [])) {
        if (d?.step?.id !== undefined && d?.step?.id !== null) {
            map.set(String(d.step.id), d)
        }
    }
    return map
});

// Last departure run per station (from_step) for the "moved" line.
const moveByStep = computed(() => {
    const map = new Map()
    for (const r of (props.runs || [])) {
        const id = r?.from_step?.id ?? r?.from_step_id
        if (id !== undefined && id !== null) map.set(String(id), r)
    }
    return map
});

function detailFor(s) {
    return detailById.value.get(String(s.id)) || null
}

function moveFor(s) {
    return moveByStep.value.get(String(s.id)) || null
}
</script>

<style scoped>
.step-label {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.35;
    overflow-wrap: break-word;
    font-size: 0.85rem;
}
.step-link {
    flex: 1 1 24px;
    min-width: 16px;
    height: 2px;
    margin-top: 20px;
    background: #e0e0e0;
    border-radius: 2px;
}
.step-link.done {
    background: #4CAF50;
}
.snake-row {
    width: 100%;
    padding-right: 24px;
    position: relative;
    z-index: 1;
}
.snake-reverse {
    flex-direction: row-reverse;
}
.snake-wrap {
    position: relative;
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 34px;
}
.snake-svg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0;
}
.snake-svg path {
    stroke: #e0e0e0;
    stroke-width: 2;
    fill: none;
    stroke-linecap: round;
    stroke-linejoin: round;
}
.snake-svg path.done {
    stroke: #4CAF50;
}
</style>
