<template>
    <v-dialog
        :model-value="visible"
        :fullscreen="smAndDown"
        :transition="false"
        max-width="1040"
        :height="smAndDown ? undefined : 'min(82vh, 760px)'"
        scrollable
        class="summary-detail-dialog"
        @update:model-value="(v) => { if (!v) close() }"
    >
        <v-card
            ref="panelRef"
            class="sd-panel"
            :class="{ 'sd-pending': pending }"
            :style="{ '--sd-accent': accent }"
            rounded="xl"
        >
            <div ref="contentRef" class="sd-content d-flex flex-column" style="min-height: 0; height: 100%">
                <header class="sd-head">
                    <div class="d-flex align-center ga-3">
                        <span class="sd-icon"><v-icon :color="accent" size="26">{{ meta.icon }}</v-icon></span>
                        <div class="flex-grow-1" style="min-width: 0">
                            <h2 class="sd-title">{{ title }}</h2>
                            <div class="sd-scope">
                                <span>{{ periodLabel }}</span>
                                <span v-for="p in scopeChips" :key="p" class="sd-chip">{{ p }}</span>
                            </div>
                        </div>
                        <div class="sd-count" :aria-label="`${count} transactions`">
                            <span class="sd-count-num">{{ loading ? '…' : shownCount }}</span>
                            <span class="sd-count-label">transaction{{ count === 1 ? '' : 's' }}</span>
                        </div>
                        <v-btn icon="mdi-close" variant="text" size="small" aria-label="Close" @click="close" />
                    </div>
                    <p class="sd-explain">{{ meta.explain }}</p>
                    <v-text-field
                        v-model="search"
                        prepend-inner-icon="mdi-magnify"
                        placeholder="Search reference, title, office, station or person"
                        variant="outlined"
                        density="compact"
                        rounded="lg"
                        hide-details
                        clearable
                        class="mt-3"
                    />
                </header>

                <div class="sd-body">
                    <v-alert v-if="error" type="error" variant="tonal" density="compact" class="ma-4">{{ error }}</v-alert>

                    <div v-else-if="loading" class="pa-4">
                        <v-skeleton-loader v-for="i in 4" :key="i" type="list-item-three-line" class="mb-2" />
                    </div>

                    <div v-else-if="!filtered.length" class="sd-empty">
                        <v-icon size="36" color="grey">{{ search ? 'mdi-text-search' : meta.icon }}</v-icon>
                        <div class="mt-2">{{ search ? `Nothing matches “${search}”.` : meta.empty }}</div>
                    </div>

                    <ol v-else ref="listRef" class="sd-list" :class="{ revealed }">
                        <li
                            v-for="row in filtered"
                            :key="row.id"
                            class="sd-row"
                            :class="{ clickable: !isDeleted }"
                            :tabindex="isDeleted ? -1 : 0"
                            :role="isDeleted ? undefined : 'link'"
                            @click="openTx(row)"
                            @keydown.enter="openTx(row)"
                        >
                            <div class="sd-who">
                                <div class="d-flex align-center ga-2 flex-wrap">
                                    <span class="sd-ref">{{ row.reference_number }}</span>
                                    <span class="sd-name">{{ row.title || 'Untitled' }}</span>
                                </div>
                                <div class="sd-meta">
                                    <span v-if="row.process">{{ row.process.name }}</span>
                                    <span v-if="row.office" :title="row.office.name">{{ row.office.code }}</span>
                                    <span v-else class="text-disabled">No office</span>
                                </div>
                            </div>

                            <div class="sd-path">
                                <div class="sd-stop">
                                    <div class="sd-stop-label">{{ view(row).from.label }}</div>
                                    <div class="sd-stop-value">{{ view(row).from.value }}</div>
                                    <div v-if="view(row).from.sub" class="sd-stop-sub">{{ view(row).from.sub }}</div>
                                </div>
                                <v-icon class="sd-arrow" size="18">mdi-arrow-right-thin</v-icon>
                                <div class="sd-stop">
                                    <div class="sd-stop-label">{{ view(row).to.label }}</div>
                                    <div class="sd-stop-value">{{ view(row).to.value }}</div>
                                    <div v-if="view(row).to.sub" class="sd-stop-sub">{{ view(row).to.sub }}</div>
                                </div>
                            </div>

                            <div class="sd-metric" :class="view(row).metric.tone">
                                <div class="sd-metric-value">
                                    <v-icon v-if="view(row).metric.icon" size="18" class="mr-1">{{ view(row).metric.icon }}</v-icon>{{ view(row).metric.value }}
                                </div>
                                <div class="sd-metric-label">{{ view(row).metric.label }}</div>
                            </div>
                        </li>
                    </ol>
                </div>
            </div>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, nextTick, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useDisplay, useTheme } from 'vuetify'
import { useApi } from '@/composables/useApi'
import { fetchSummaryRows, rowView, summaryMeta } from '@/composables/useSummaryRows'

const open = defineModel('open', { default: false })
const props = defineProps({
    // completed | in_process | overdue | deleted | process
    category: { type: String, default: null },
    processId: { type: Number, default: null },
    processName: { type: String, default: '' },
    // Same period + filters as the Summary card, so lists match the tiles.
    query: { type: Object, default: () => ({}) },
    periodLabel: { type: String, default: '' },
    scopeChips: { type: Array, default: () => [] },
    // The tile/bar that was clicked: the panel grows out of it and back.
    originEl: { type: Object, default: null },
})

const router = useRouter()
const { api } = useApi()
const { smAndDown } = useDisplay()
const theme = useTheme()
const isDark = computed(() => theme.global.name.value === 'pixivDark')

const meta = computed(() => summaryMeta(props.category))
const accent = computed(() => (isDark.value ? meta.value.dark : meta.value.light))
const title = computed(() => (props.category === 'process' ? `${props.processName} transactions` : meta.value.title))
const isDeleted = computed(() => props.category === 'deleted')

// ---- data -------------------------------------------------------------
const rows = ref([])
const count = ref(0)
const loading = ref(false)
const error = ref('')
const search = ref('')
let requestId = 0

async function load() {
    const mine = ++requestId
    loading.value = true
    error.value = ''
    rows.value = []
    count.value = 0
    try {
        const data = await fetchSummaryRows(api, props.category, props.query, props.processId)
        if (mine !== requestId) return
        rows.value = data.rows
        count.value = data.count
        countUp(count.value)
    } catch (e) {
        if (mine === requestId) error.value = e?.response?.data?.message || 'Couldn’t load this list. Close it and try again.'
    } finally {
        if (mine === requestId) {
            loading.value = false
            revealList()
        }
    }
}

const filtered = computed(() => {
    const q = (search.value || '').trim().toLowerCase()
    if (!q) return rows.value
    return rows.value.filter((r) =>
        [
            r.reference_number, r.title, r.process?.name, r.office?.code, r.office?.name,
            r.current_step?.name, r.station_at_deletion?.name, ...(r.handled_by || []),
            r.created_by?.name, r.finalized_by?.name, r.deleted_by?.name,
        ].filter(Boolean).join(' ').toLowerCase().includes(q),
    )
})

// Row wording is shared with the popover (useSummaryRows).
const view = (r) => rowView(props.category, r)

function openTx(r) {
    if (isDeleted.value) return
    close().then(() => router.push(`/transactions/${r.id}`))
}

// ---- motion: the panel grows out of the clicked tile and back into it ----
const visible = ref(false)
const panelRef = ref(null)
const contentRef = ref(null)
const listRef = ref(null)
const revealed = ref(false)
const shownCount = ref(0)
let closing = null

const reduceMotion = () =>
    typeof window !== 'undefined' && window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

const panelEl = () => panelRef.value?.$el ?? panelRef.value

// Transform that maps the panel's box onto the origin tile's box.
function tileTransform() {
    const panel = panelEl()
    const origin = props.originEl?.$el ?? props.originEl
    if (!panel || !origin?.getBoundingClientRect) return null
    const to = panel.getBoundingClientRect()
    const from = origin.getBoundingClientRect()
    if (!to.width || !from.width) return null
    const dx = from.left + from.width / 2 - (to.left + to.width / 2)
    const dy = from.top + from.height / 2 - (to.top + to.height / 2)
    return `translate(${dx}px, ${dy}px) scale(${from.width / to.width}, ${from.height / to.height})`
}

// The panel stays invisible (sd-pending) until its first animation frame,
// so it never flashes at full size before growing from the tile.
const pending = ref(false)

async function animateIn() {
    pending.value = true
    await nextTick()
    await new Promise((r) => requestAnimationFrame(r))
    const panel = panelEl()
    if (!panel) {
        pending.value = false
        return
    }
    const from = !reduceMotion() && !smAndDown.value ? tileTransform() : null
    if (!from) {
        panel.animate([{ opacity: 0 }, { opacity: 1 }], { duration: 160, easing: 'ease-out' })
        pending.value = false
        return
    }
    const timing = { duration: 460, easing: 'cubic-bezier(.2, .9, .25, 1)' }
    panel.animate([{ transform: from, opacity: 0.35 }, { transform: 'none', opacity: 1 }], timing)
    // Hide the text while the box is stretched so it never looks squashed.
    contentRef.value?.animate([{ opacity: 0 }, { opacity: 0, offset: 0.45 }, { opacity: 1 }], timing)
    pending.value = false
}

async function animateOut() {
    const panel = panelEl()
    if (!panel) return
    const to = !reduceMotion() && !smAndDown.value ? tileTransform() : null
    const anim = to
        ? panel.animate([{ transform: 'none', opacity: 1 }, { transform: to, opacity: 0 }], { duration: 300, easing: 'cubic-bezier(.4, 0, .6, 1)', fill: 'forwards' })
        : panel.animate([{ opacity: 1 }, { opacity: 0 }], { duration: 140, fill: 'forwards' })
    contentRef.value?.animate([{ opacity: 1 }, { opacity: 0 }], { duration: to ? 150 : 140, fill: 'forwards' })
    await anim.finished.catch(() => {})
}

function close() {
    if (closing) return closing
    closing = animateOut().then(() => {
        visible.value = false
        open.value = false
        closing = null
    })
    return closing
}

// The count rolls up once when the list arrives (skipped for reduced motion).
function countUp(target) {
    if (reduceMotion() || target <= 1) {
        shownCount.value = target
        return
    }
    const start = performance.now()
    const tick = (now) => {
        const t = Math.min(1, (now - start) / 520)
        shownCount.value = Math.round(target * (1 - Math.pow(1 - t, 3)))
        if (t < 1) requestAnimationFrame(tick)
    }
    requestAnimationFrame(tick)
}

// One reveal for the whole list, not a cascade per row.
function revealList() {
    revealed.value = false
    nextTick(() => requestAnimationFrame(() => { revealed.value = true }))
}

watch(open, (isOpen) => {
    if (isOpen && !visible.value) {
        search.value = ''
        shownCount.value = 0
        visible.value = true
        animateIn()
        load()
    } else if (!isOpen && visible.value && !closing) {
        close()
    }
})
</script>

<style scoped>
/* Height is fixed on the dialog (desktop) so the panel never jumps when the
   list loads; the card fills it. */
.sd-panel {
    overflow: hidden;
    transform-origin: center center;
    will-change: transform, opacity;
    border-top: 4px solid var(--sd-accent);
}
.sd-pending {
    opacity: 0;
}
.sd-head {
    padding: 18px 20px 14px;
    border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.sd-icon {
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: color-mix(in srgb, var(--sd-accent) 14%, transparent);
    flex-shrink: 0;
}
.sd-title {
    font-family: 'Roboto', sans-serif;
    font-size: 1.25rem;
    font-weight: 800;
    line-height: 1.2;
    margin: 0;
}
.sd-scope {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 6px;
    margin-top: 4px;
    font-size: 0.8rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-chip {
    padding: 1px 8px;
    border-radius: 999px;
    background: rgba(var(--v-theme-on-surface), 0.07);
    font-weight: 700;
}
.sd-count {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    line-height: 1;
    padding-right: 4px;
}
.sd-count-num {
    font-family: 'Roboto', sans-serif;
    font-size: 2.4rem;
    font-weight: 800;
    color: var(--sd-accent);
    font-variant-numeric: tabular-nums;
}
.sd-count-label {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
    margin-top: 2px;
}
.sd-explain {
    margin: 10px 0 0;
    font-size: 0.85rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
    max-width: 70ch;
}
.sd-body {
    flex: 1 1 auto;
    overflow-y: auto;
    min-height: 0;
}
.sd-empty {
    display: grid;
    place-items: center;
    text-align: center;
    padding: 56px 16px;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}

/* Routing-slip rows: who -> where it went -> the number that matters */
.sd-list {
    list-style: none;
    margin: 0;
    padding: 6px 0;
    opacity: 0;
    transform: translateY(6px);
    transition: opacity 0.28s ease-out, transform 0.28s ease-out;
}
.sd-list.revealed {
    opacity: 1;
    transform: none;
}
.sd-row {
    display: grid;
    grid-template-columns: minmax(180px, 1.1fr) minmax(260px, 1.6fr) minmax(130px, 0.7fr);
    gap: 18px;
    align-items: center;
    padding: 12px 20px;
    border-left: 3px solid transparent;
    transition: background-color 0.15s, border-color 0.15s;
}
.sd-row + .sd-row {
    border-top: 1px solid rgba(var(--v-border-color), calc(var(--v-border-opacity) * 0.6));
}
.sd-row.clickable {
    cursor: pointer;
}
.sd-row.clickable:hover,
.sd-row.clickable:focus-visible {
    background: color-mix(in srgb, var(--sd-accent) 6%, transparent);
    border-left-color: var(--sd-accent);
    outline: none;
}
.sd-ref {
    font-size: 0.75rem;
    font-weight: 800;
    letter-spacing: 0.02em;
    padding: 2px 7px;
    border-radius: 6px;
    background: rgba(var(--v-theme-on-surface), 0.07);
    font-variant-numeric: tabular-nums;
}
.sd-name {
    font-weight: 700;
    font-size: 0.95rem;
}
.sd-meta {
    display: flex;
    gap: 10px;
    margin-top: 4px;
    font-size: 0.8rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-path {
    display: grid;
    grid-template-columns: 1fr auto 1fr;
    align-items: start;
    gap: 10px;
    min-width: 0;
}
.sd-arrow {
    margin-top: 16px;
    color: color-mix(in srgb, var(--sd-accent) 70%, rgb(var(--v-theme-on-surface)));
}
.sd-stop {
    min-width: 0;
}
.sd-stop-label {
    font-size: 0.72rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-stop-value {
    font-size: 0.87rem;
    font-weight: 700;
    overflow-wrap: anywhere;
}
.sd-stop-sub {
    font-size: 0.78rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-metric {
    text-align: right;
}
.sd-metric-value {
    display: inline-flex;
    align-items: center;
    font-family: 'Roboto', sans-serif;
    font-size: 1.05rem;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
}
.sd-metric-label {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.sd-metric.warn .sd-metric-value {
    color: var(--sd-warn, #a86f00);
}
.sd-metric.good .sd-metric-value {
    color: #008300;
}
.sd-metric.muted .sd-metric-value {
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}

@media (max-width: 860px) {
    .sd-row {
        grid-template-columns: 1fr;
        gap: 8px;
    }
    .sd-metric {
        text-align: left;
    }
}
@media (prefers-reduced-motion: reduce) {
    .sd-list,
    .sd-row {
        transition: none;
    }
}
</style>

<style>
/* Teleported overlay: soften what's behind the panel. */
.summary-detail-dialog > .v-overlay__scrim {
    backdrop-filter: blur(3px);
}
html.dark .sd-metric.warn .sd-metric-value,
.v-theme--pixivDark .sd-metric.warn .sd-metric-value {
    color: #e0a526;
}
</style>
