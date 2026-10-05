<template>
    <v-menu
        ref="menuRef"
        v-model="menuOpen"
        activator="parent"
        open-on-hover
        open-on-click
        :open-delay="280"
        :close-delay="180"
        :close-on-content-click="false"
        location="bottom center"
        :offset="14"
        transition="sd-pop"
        :disabled="disabled"
        content-class="sd-pop-overlay"
    >
        <div
            ref="popRef"
            class="sd-pop"
            :class="{ above: arrow.side === 'bottom' }"
            :style="{ '--sd-accent': accent, '--sd-arrow-x': arrow.x + 'px' }"
            role="dialog"
            :aria-label="title"
        >
            <span class="sd-pop-arrow" :class="arrow.side" aria-hidden="true" />
            <header class="sd-pop-head">
                <span class="sd-pop-icon"><v-icon :color="accent" size="20">{{ meta.icon }}</v-icon></span>
                <div class="flex-grow-1" style="min-width: 0">
                    <div class="sd-pop-title">{{ title }}</div>
                    <div class="sd-pop-period">{{ periodLabel }}</div>
                </div>
                <div class="sd-pop-count">{{ loading ? '…' : count }}</div>
            </header>

            <div class="sd-pop-body">
                <div v-if="error" class="sd-pop-note text-error">{{ error }}</div>
                <div v-else-if="loading" class="px-3 py-2">
                    <v-skeleton-loader v-for="i in 3" :key="i" type="list-item-two-line" />
                </div>
                <div v-else-if="!rows.length" class="sd-pop-note">{{ meta.empty }}</div>
                <ul v-else class="sd-pop-list">
                    <li
                        v-for="r in rows.slice(0, PREVIEW)"
                        :key="r.id"
                        class="sd-pop-row"
                        :class="{ clickable: category !== 'deleted' }"
                        @click="openTx(r)"
                    >
                        <div class="sd-pop-row-main">
                            <div class="d-flex align-center ga-2" style="min-width: 0">
                                <span class="sd-pop-ref">{{ r.reference_number }}</span>
                                <span class="sd-pop-name text-truncate">{{ r.title || 'Untitled' }}</span>
                            </div>
                            <div class="sd-pop-brief text-truncate">{{ view(r).brief }}</div>
                        </div>
                        <div class="sd-pop-metric" :class="view(r).metric.tone">
                            <v-icon v-if="view(r).metric.icon" size="14" class="mr-1">{{ view(r).metric.icon }}</v-icon>{{ view(r).metric.value }}
                        </div>
                    </li>
                </ul>
            </div>

            <footer class="sd-pop-foot">
                <span v-if="!loading && rows.length > PREVIEW" class="sd-pop-more">
                    {{ rows.length - PREVIEW }} more
                </span>
                <v-spacer />
                <v-btn
                    variant="text"
                    size="small"
                    :color="accent"
                    append-icon="mdi-arrow-expand"
                    class="font-weight-bold"
                    :disabled="loading || !!error"
                    @click="expand"
                >
                    See full list
                </v-btn>
            </footer>
        </div>
    </v-menu>
</template>

<script setup>
import { computed, nextTick, reactive, ref, unref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTheme } from 'vuetify'
import { useApi } from '@/composables/useApi'
import { fetchSummaryRows, rowView, summaryMeta } from '@/composables/useSummaryRows'

const props = defineProps({
    category: { type: String, required: true },
    processId: { type: Number, default: null },
    processName: { type: String, default: '' },
    query: { type: Object, default: () => ({}) },
    periodLabel: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
})
const emit = defineEmits(['expand'])

const PREVIEW = 5
const router = useRouter()
const { api } = useApi()
const theme = useTheme()

const meta = computed(() => summaryMeta(props.category))
const accent = computed(() => (theme.global.name.value === 'pixivDark' ? meta.value.dark : meta.value.light))
const title = computed(() => (props.category === 'process' ? props.processName : meta.value.short))
const view = (r) => rowView(props.category, r)

const menuOpen = ref(false)
const rows = ref([])
const count = ref(0)
const loading = ref(false)
const error = ref('')
let requestId = 0

async function load() {
    const mine = ++requestId
    loading.value = true
    error.value = ''
    try {
        const data = await fetchSummaryRows(api, props.category, props.query, props.processId)
        if (mine !== requestId) return
        rows.value = data.rows
        count.value = data.count
    } catch (e) {
        if (mine === requestId) error.value = e?.response?.data?.message || 'Couldn’t load this list.'
    } finally {
        if (mine === requestId) loading.value = false
    }
}

// Pointer: on whichever side faces the box (the menu flips above it when
// there's no room below) and aimed at the box's center, even when the
// popover is nudged sideways near a screen edge.
const menuRef = ref(null)
const popRef = ref(null)
const arrow = reactive({ side: 'top', x: 190 })

function placeArrow() {
    // Vuetify forwards activatorEl as a ref; unwrap it to the element.
    const act = unref(menuRef.value?.activatorEl)
    const pop = popRef.value
    if (!act || !pop) return
    const a = act.getBoundingClientRect()
    const p = pop.getBoundingClientRect()
    if (!p.width) return
    arrow.side = p.top >= a.top + a.height / 2 ? 'top' : 'bottom'
    arrow.x = Math.min(p.width - 20, Math.max(20, a.left + a.width / 2 - p.left))
}

// Vuetify settles the placement (and may flip above the box) a few frames
// after opening or after the content resizes, so keep re-aiming the pointer
// every frame for a short window instead of measuring once.
let trackUntil = 0
function trackArrow(ms = 700) {
    const running = trackUntil > performance.now()
    trackUntil = performance.now() + ms
    if (running) return
    const step = () => {
        placeArrow()
        if (menuOpen.value && performance.now() < trackUntil) requestAnimationFrame(step)
    }
    requestAnimationFrame(step)
}

watch(menuOpen, async (open) => {
    if (!open) return
    load()
    await nextTick()
    trackArrow()
})
// Rows arriving change the popover's height, which can change its placement.
watch(loading, (isLoading) => {
    if (!isLoading && menuOpen.value) nextTick(() => trackArrow())
})

function openTx(r) {
    if (props.category === 'deleted') return
    menuOpen.value = false
    router.push(`/transactions/${r.id}`)
}

function expand() {
    menuOpen.value = false
    emit('expand')
}
</script>

<style scoped>
.sd-pop {
    position: relative;
    width: min(380px, 92vw);
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    border-radius: 12px;
    border-top: 3px solid var(--sd-accent);
    box-shadow: 0 18px 40px -18px rgba(15, 23, 42, 0.45), 0 2px 8px rgba(15, 23, 42, 0.08);
}
/* Pointer toward the box that opened it */
.sd-pop-arrow {
    position: absolute;
    left: var(--sd-arrow-x, 50%);
    width: 14px;
    height: 14px;
    transform: translateX(-50%) rotate(45deg);
    z-index: 0;
    transition: left 0.15s;
}
.sd-pop-arrow.top {
    top: -9px;
    background: var(--sd-accent);
    border-radius: 3px 0 0 0;
}
.sd-pop-arrow.bottom {
    bottom: -7px;
    background: rgb(var(--v-theme-surface));
    border-radius: 0 0 3px 0;
    box-shadow: 3px 3px 6px -2px rgba(15, 23, 42, 0.25);
}
/* Opened above the box: accent moves to the edge that faces it. */
.sd-pop.above {
    border-top: none;
    border-bottom: 3px solid var(--sd-accent);
}
.sd-pop.above .sd-pop-arrow.bottom {
    bottom: -9px;
    background: var(--sd-accent);
    box-shadow: none;
}
.sd-pop.above .sd-pop-head {
    border-radius: 12px 12px 0 0;
}
.sd-pop-foot {
    position: relative;
    z-index: 1;
    background: rgb(var(--v-theme-surface));
    border-radius: 0 0 9px 9px;
}
.sd-pop-head {
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 14px 10px;
    background: rgb(var(--v-theme-surface));
    border-radius: 9px 9px 0 0;
}
.sd-pop-icon {
    display: grid;
    place-items: center;
    width: 34px;
    height: 34px;
    border-radius: 10px;
    background: color-mix(in srgb, var(--sd-accent) 14%, transparent);
    flex-shrink: 0;
}
.sd-pop-title {
    font-family: 'Roboto', sans-serif;
    font-weight: 800;
    font-size: 1rem;
    line-height: 1.2;
}
.sd-pop-period {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-pop-count {
    font-family: 'Roboto', sans-serif;
    font-weight: 800;
    font-size: 1.6rem;
    color: var(--sd-accent);
    font-variant-numeric: tabular-nums;
}
.sd-pop-body {
    max-height: 300px;
    overflow-y: auto;
    border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.sd-pop-note {
    padding: 18px 14px;
    font-size: 0.85rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-pop-list {
    list-style: none;
    margin: 0;
    padding: 4px 0;
}
.sd-pop-row {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 14px;
    border-left: 3px solid transparent;
    transition: background-color 0.15s, border-color 0.15s;
}
.sd-pop-row.clickable {
    cursor: pointer;
}
.sd-pop-row.clickable:hover {
    background: color-mix(in srgb, var(--sd-accent) 7%, transparent);
    border-left-color: var(--sd-accent);
}
.sd-pop-row-main {
    flex: 1 1 auto;
    min-width: 0;
}
.sd-pop-ref {
    flex-shrink: 0;
    font-size: 0.7rem;
    font-weight: 800;
    padding: 1px 6px;
    border-radius: 5px;
    background: rgba(var(--v-theme-on-surface), 0.07);
    font-variant-numeric: tabular-nums;
}
.sd-pop-name {
    font-weight: 700;
    font-size: 0.85rem;
}
.sd-pop-brief {
    margin-top: 2px;
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-pop-metric {
    flex-shrink: 0;
    display: inline-flex;
    align-items: center;
    font-weight: 800;
    font-size: 0.85rem;
    font-variant-numeric: tabular-nums;
}
.sd-pop-metric.warn {
    color: #a86f00;
}
.sd-pop-metric.good {
    color: #008300;
}
.sd-pop-metric.muted {
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-pop-foot {
    display: flex;
    align-items: center;
    padding: 4px 6px 6px 14px;
    border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.sd-pop-more {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
</style>

<style>
/* Pop-in from the box: grows from the side facing it (teleported, so global). */
.sd-pop-enter-active {
    transition: opacity 0.2s ease-out, transform 0.24s cubic-bezier(.2, .9, .25, 1);
}
.sd-pop-leave-active {
    transition: opacity 0.14s ease-in, transform 0.14s ease-in;
}
.sd-pop-enter-from,
.sd-pop-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(0.94);
}
.sd-pop-overlay {
    transform-origin: var(--v-overlay-anchor-origin, top center);
}
.v-theme--pixivDark .sd-pop-metric.warn {
    color: #e0a526;
}
.v-theme--pixivDark .sd-pop-metric.good {
    color: #2fa84f;
}
@media (prefers-reduced-motion: reduce) {
    .sd-pop-enter-active,
    .sd-pop-leave-active {
        transition: opacity 0.12s;
    }
    .sd-pop-enter-from,
    .sd-pop-leave-to {
        transform: none;
    }
}
</style>
