<template>
    <div>
        <div v-if="layoutChanged" class="d-flex justify-end mb-1">
            <v-btn
                variant="text"
                size="small"
                color="grey-darken-3"
                prepend-icon="mdi-restore"
                @click="resetLayout"
            >
                Reset layout
            </v-btn>
        </div>
        <!-- Cards render in the user's saved order; drag events are handled here for every card. -->
        <v-row
            align="stretch"
            @dragstart="onDragStart"
            @dragover="onDragOver"
            @dragleave="onDragLeave"
            @drop="onDrop"
            @dragend="endDrag"
            @keydown="onGripKey"
        >
            <template v-for="id in cardOrder" :key="id">
                <v-col v-if="id === 'graph'" cols="12" lg="8" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4">
                            <CardGrip />
                            <v-avatar color="#7C3AED" rounded="0" size="34" class="mr-3">
                                <v-icon color="white" size="22">mdi-chart-bar</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">{{ DASHBOARD_OFFICE.code }} Transactions per Process</span>
                            <span class="text-caption text-medium-emphasis ml-2 text-truncate">{{ DASHBOARD_OFFICE.name }}</span>
                            <v-spacer />
                            <v-select
                                v-model="graphPeriod"
                                :items="monthOptions"
                                label="Month"
                                variant="outlined"
                                density="compact"
                                rounded="0"
                                hide-details
                                class="process-filter mr-2"
                            />
                            <v-select
                                v-model="processFilter"
                                :items="processOptions"
                                label="Process"
                                placeholder="All processes"
                                persistent-placeholder
                                variant="outlined"
                                density="compact"
                                rounded="0"
                                hide-details
                                multiple
                                clearable
                                class="process-filter"
                            >
                                <template v-slot:selection="{ item, index }">
                                    <span v-if="index === 0" class="text-truncate">
                                        {{ processFilter.length === 1 ? item.raw.value : `${processFilter.length} processes` }}
                                    </span>
                                </template>
                            </v-select>
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-3 d-flex flex-column" style="flex: 1 1 auto">
                            <GroupedBarChart
                                :series="graphSeries"
                                :group-labels="graphWeeks"
                                :loading="loading"
                                :height="190"
                                :empty-text="`No ${DASHBOARD_OFFICE.code} transactions in ${graphPeriodLabel}`"
                                :aria-label="`${DASHBOARD_OFFICE.code} transactions per process per week, ${graphPeriodLabel}`"
                            />
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'start'" cols="12" lg="4" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4">
                            <CardGrip />
                            <v-avatar color="#5C6BC0" rounded="0" size="34" class="mr-3">
                                <v-icon color="white" size="22">mdi-rocket-launch-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Get Started</span>
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-0 d-flex flex-column" style="flex: 1 1 auto">
                            <div
                                v-for="link in startLinks"
                                :key="link.title"
                                class="start-row d-flex align-center px-4"
                                style="flex: 1 1 0"
                                @click="link.go"
                            >
                                <v-avatar :color="link.color" rounded="0" size="34" class="mr-3">
                                    <v-icon color="white" size="20">{{ link.icon }}</v-icon>
                                </v-avatar>
                                <div class="flex-grow-1" style="min-width: 0">
                                    <div class="font-weight-bold start-title">{{ link.title }}</div>
                                    <div class="text-caption text-medium-emphasis">{{ link.subtitle }}</div>
                                </div>
                                <v-icon size="small" color="grey">mdi-chevron-right</v-icon>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'summary'" cols="12" class="dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card summary-card">
                        <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4">
                            <CardGrip />
                            <v-avatar color="#4A3AA7" rounded="0" size="34" class="mr-1">
                                <v-icon color="white" size="22">mdi-clipboard-text-clock-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Transaction Summary</span>
                            <span class="text-caption text-medium-emphasis ml-1">{{ DASHBOARD_OFFICE.code }} · {{ summaryScopeText }}</span>
                            <v-spacer />
                            <v-select
                                v-model="summaryPeriod"
                                :items="periodOptions"
                                label="Period"
                                variant="outlined"
                                density="compact"
                                rounded="0"
                                hide-details
                                class="process-filter"
                            />
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-4">
                            <v-alert v-if="summaryError" type="error" variant="tonal" density="compact" class="mb-3">
                                {{ summaryError }}
                            </v-alert>
                            <v-row :class="{ 'summary-stale': summaryLoading && summary }">
                                <v-col cols="12" md="7">
                                    <div class="summary-tiles">
                                        <div
                                            v-for="tile in summaryTiles"
                                            :key="tile.key"
                                            :ref="(el) => (tileEls[tile.key] = el)"
                                            class="summary-tile"
                                            :style="{ '--tile-accent': tile.accent }"
                                            role="button"
                                            tabindex="0"
                                            :aria-label="`${tile.label}: ${tile.value}. Press Enter for the full list`"
                                            @keydown.enter.prevent="openDetail(tile.key, tileEls[tile.key])"
                                            @keydown.space.prevent="openDetail(tile.key, tileEls[tile.key])"
                                        >
                                            <SummaryPopover
                                                :category="tile.key"
                                                :query="summaryQuery"
                                                :period-label="summaryScopeText"
                                                :disabled="!summary"
                                                @expand="openDetail(tile.key, tileEls[tile.key])"
                                            />
                                            <div class="d-flex align-center ga-2 summary-tile-label">
                                                <v-icon :color="tile.color" size="20" class="summary-tile-icon">{{ tile.icon }}</v-icon>
                                                {{ tile.label }}
                                            </div>
                                            <div class="summary-tile-value">
                                                <v-progress-circular v-if="summaryLoading && !summary" indeterminate size="22" width="3" color="grey" />
                                                <template v-else>{{ tile.value }}</template>
                                            </div>
                                            <div class="text-caption text-medium-emphasis">{{ tile.hint }}</div>
                                            <div class="summary-tile-cta">
                                                Show list <v-icon size="14">mdi-chevron-down</v-icon>
                                            </div>
                                        </div>
                                    </div>
                                </v-col>
                                <v-col cols="12" md="5">
                                    <div class="summary-tile-label mb-2">
                                        <v-icon size="20" color="grey-darken-1">mdi-format-list-bulleted-type</v-icon>
                                        Transactions by process
                                    </div>
                                    <div v-if="summary && !byProcessRows.length" class="text-caption text-medium-emphasis">
                                        No transactions created in this period.
                                    </div>
                                    <div
                                        v-for="row in byProcessRows"
                                        :key="row.id"
                                        :ref="(el) => (barEls[row.id] = el)"
                                        class="process-bar-row"
                                        role="button"
                                        tabindex="0"
                                        :aria-label="`${row.name}: ${row.count} transactions. Press Enter for the full list`"
                                        @keydown.enter.prevent="openDetail('process', barEls[row.id], row)"
                                    >
                                        <SummaryPopover
                                            category="process"
                                            :process-id="row.id"
                                            :process-name="`${row.name} transactions`"
                                            :query="summaryQuery"
                                            :period-label="summaryScopeText"
                                            @expand="openDetail('process', barEls[row.id], row)"
                                        />
                                        <div class="process-bar-name text-truncate">{{ row.name }}</div>
                                        <div class="process-bar-track">
                                            <div class="process-bar-fill" :style="{ width: row.pct + '%', background: processBarColor }" />
                                        </div>
                                        <div class="process-bar-count">{{ row.count }}</div>
                                    </div>
                                </v-col>
                            </v-row>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'recent'" cols="12" lg="4" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4">
                            <CardGrip />
                            <v-avatar color="#8B5CF6" rounded="0" size="34" class="mr-3">
                                <v-icon color="white" size="22">mdi-history</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Recent Activity</span>
                            <v-spacer />
                            <v-btn
                                variant="text"
                                size="small"
                                color="grey-darken-3"
                                append-icon="mdi-arrow-right"
                                @click="goToQueue"
                            >
                                View all
                            </v-btn>
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-2">
                            <div v-if="loading" class="d-flex align-center justify-center" style="height: 200px">
                                <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
                            </div>
                            <v-alert
                                v-else-if="!recent.length"
                                type="info"
                                variant="tonal"
                                rounded="0"
                                class="ma-2"
                            >
                                Nothing here yet — new transactions will show up here.
                            </v-alert>
                            <v-list v-else lines="two" class="py-0">
                                <v-list-item
                                    v-for="tx in recent"
                                    :key="tx.id"
                                    rounded="0"
                                    class="recent-row"
                                    @click="openTx(tx)"
                                >
                                    <template v-slot:prepend>
                                        <v-avatar color="grey-darken-3" variant="tonal" rounded="0" size="34">
                                            <v-icon color="grey-darken-3" size="20">mdi-file-document-outline</v-icon>
                                        </v-avatar>
                                    </template>
                                    <v-list-item-title class="font-weight-bold">
                                        {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                    </v-list-item-title>
                                    <v-list-item-subtitle>
                                        {{ txSubtitle(tx) }} · {{ timeAgo(tx.created_at) }}
                                    </v-list-item-subtitle>
                                    <template v-slot:append>
                                        <v-icon size="small" color="grey">mdi-chevron-right</v-icon>
                                    </template>
                                </v-list-item>
                            </v-list>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'action'" cols="12" lg="8" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4">
                            <CardGrip />
                            <v-avatar color="#6D28D9" rounded="0" size="34" class="mr-3">
                                <v-icon color="white" size="22">mdi-tray-full</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Needs My Action</span>
                            <v-spacer />
                            <v-btn
                                variant="text"
                                size="small"
                                color="grey-darken-3"
                                append-icon="mdi-arrow-right"
                                @click="goToQueue"
                            >
                                My queue
                            </v-btn>
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-0">
                            <div v-if="loading" class="d-flex align-center justify-center" style="height: 200px">
                                <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
                            </div>
                            <v-alert
                                v-else-if="!actionQueue.length"
                                type="success"
                                variant="tonal"
                                rounded="0"
                                class="ma-4"
                            >
                                All clear — nothing is waiting on you.
                            </v-alert>
                            <v-table v-else density="compact" class="action-table">
                                <thead>
                                    <tr>
                                        <th class="text-left">Transaction</th>
                                        <th class="text-left">Current Step</th>
                                        <th class="text-left">Waiting</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="tx in actionQueue"
                                        :key="tx.id"
                                        class="action-row"
                                        @click="openTx(tx)"
                                    >
                                        <td>
                                            <div class="font-weight-bold action-title">
                                                {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                            </div>
                                            <div class="text-caption text-medium-emphasis">
                                                {{ txSubtitle(tx) }}
                                            </div>
                                        </td>
                                        <td>
                                            <v-chip size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
                                                {{ tx.current_step?.name || tx.current_step?.code || 'Unassigned' }}
                                            </v-chip>
                                        </td>
                                        <td class="font-weight-bold">{{ timeAgo(tx.entered_at || tx.created_at) }}</td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-card-text>
                    </v-card>
                </v-col>
            </template>
        </v-row>
        <SummaryDetailDialog
            v-if="isSuperadmin"
            v-model:open="detail.open"
            :category="detail.category"
            :process-id="detail.processId"
            :process-name="detail.processName"
            :origin-el="detail.originEl"
            :query="summaryQuery"
            :period-label="summary?.period?.label || 'Last week'"
        />
    </div>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, reactive, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTheme } from 'vuetify'
import { useAuth } from '@/composables/useAuth'
import { useApi } from '@/composables/useApi'
import { useTransactions } from '@/composables/useTransactions'
import { useMyTransactions } from '@/composables/useMyTransactions'
import { useDashboardLayout } from '@/composables/useDashboardLayout'
import { useSmartPoll } from '@/composables/useSmartPoll'
import CardGrip from '@/components/CardGrip.vue'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import SummaryDetailDialog from '@/components/SummaryDetailDialog.vue'
import SummaryPopover from '@/components/SummaryPopover.vue'
import { isCached, readCache, writeCache, CacheKeys } from '@/composables/useCache'

const router = useRouter()
const auth = useAuth()
const { api } = useApi()

const txStore = useTransactions()
const myStore = useMyTransactions()

const loading = ref(false)
const refreshedAt = ref(null)

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? []
    return roles.some((r) => r.code === 'superadmin')
})

// ---- Movable cards: drag a card's grip onto another card to take its place ----
// Default order; Transaction Summary is superadmin only.
const cardIds = computed(() =>
    ['summary', 'graph', 'start', 'recent', 'action'].filter((id) => id !== 'summary' || isSuperadmin.value)
)
const {
    order: cardOrder,
    changed: layoutChanged,
    move: moveCard,
    shift: shiftCard,
    reset: resetLayout,
} = useDashboardLayout(computed(() => auth.user.value?.id), cardIds)

const dragId = ref(null)
const overId = ref(null)

// The card column an event happened in (drag events can target text nodes).
function cardAt(e) {
    const el = e.target.nodeType === 1 ? e.target : e.target.parentElement
    return el?.closest('[data-card]') ?? null
}

function cardClass(id) {
    return { 'dash-dragging': dragId.value === id, 'dash-drop-target': overId.value === id && dragId.value !== id }
}

function onDragStart(e) {
    const col = e.target.closest?.('.card-grip') && cardAt(e)
    if (!col) return
    dragId.value = col.dataset.card
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData('text/plain', dragId.value)
    // Carry the whole card under the pointer, not just the grip.
    const card = col.querySelector('.v-card')
    const box = card.getBoundingClientRect()
    e.dataTransfer.setDragImage(card, e.clientX - box.left, e.clientY - box.top)
}

function onDragOver(e) {
    if (!dragId.value) return
    e.preventDefault()
    e.dataTransfer.dropEffect = 'move'
    overId.value = cardAt(e)?.dataset.card ?? null
}

function onDragLeave(e) {
    if (!e.currentTarget.contains(e.relatedTarget)) overId.value = null
}

function onDrop(e) {
    if (!dragId.value) return
    e.preventDefault()
    const target = cardAt(e)?.dataset.card
    if (target) moveCard(dragId.value, target)
    endDrag()
}

function endDrag() {
    dragId.value = null
    overId.value = null
}

// Keyboard: Up/Down on a focused grip moves its card one slot.
function onGripKey(e) {
    if (e.key !== 'ArrowUp' && e.key !== 'ArrowDown') return
    if (!e.target.closest?.('.card-grip')) return
    e.preventDefault()
    const row = e.currentTarget
    const id = cardAt(e).dataset.card
    shiftCard(id, e.key === 'ArrowUp' ? -1 : 1)
    // Moving the card can drop focus; put it back on the same grip.
    nextTick(() => row.querySelector(`[data-card="${id}"] .card-grip`)?.focus())
}

// Scope: superadmin sees everything, everyone else sees their own queue.
const scopeSource = computed(() =>
    isSuperadmin.value ? (txStore.items.value || []) : (myStore.items.value || [])
)

// Series colors: validated categorical palette (dataviz reference
// palette, adjacent-pair safe in both modes), light and dark steps.
// Gray is reserved for the folded "Other processes" bar.
const SERIES_PALETTE = {
    light: ['#2a78d6', '#eb6834', '#1baf7a', '#eda100', '#e87ba4', '#008300', '#4a3aa7'],
    dark: ['#3987e5', '#d95926', '#199e70', '#c98500', '#d55181', '#008300', '#9085e9'],
}
const OTHER_PROCESSES = 'Other processes'
const OTHER_COLOR = { light: '#898781', dark: '#898781' }
const MAX_PROCESS_BARS = SERIES_PALETTE.light.length

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

// The graph and the Transaction Summary card cover this one office only.
const DASHBOARD_OFFICE = { code: 'CSD', name: 'Computer Service Division' }

// ---- Graph: the office's transactions per process, one bar per process per week ----
const monthValue = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`

// The last 12 months, newest first (shared with the summary card's Period).
const monthOptions = computed(() => {
    const now = new Date()
    return Array.from({ length: 12 }, (_, i) => {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
        return { title: d.toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }), value: monthValue(d) }
    })
})

// Graph month 'YYYY-MM' (default: the current month). One group of bars per week.
const graphPeriod = ref(monthValue(new Date()))
const DAY_MS = 86400000

function weekLabel(start, endExclusive) {
    const last = new Date(endExclusive.getTime() - DAY_MS)
    const md = (d) => d.toLocaleDateString('en-PH', { month: 'short', day: 'numeric' })
    if (last.getTime() <= start.getTime()) return md(start)
    return start.getMonth() === last.getMonth() ? `${md(start)}–${last.getDate()}` : `${md(start)}–${md(last)}`
}

// Weekly windows for the chosen month: its calendar weeks (1–7, 8–14, …),
// never reaching past today. For the current month, only weeks that have started.
const weekWindows = computed(() => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const endOfToday = new Date(today.getTime() + DAY_MS)
    const windows = []

    const [y, m] = graphPeriod.value.split('-').map(Number)
    const monthStart = new Date(y, m - 1, 1)
    const monthEnd = new Date(y, m, 1)
    for (let start = monthStart; start < monthEnd && start < endOfToday;) {
        const end = new Date(Math.min(start.getTime() + 7 * DAY_MS, monthEnd.getTime()))
        windows.push({ start, end, label: weekLabel(start, end) })
        start = end
    }
    return windows
})
const graphWeeks = computed(() => weekWindows.value.map((w) => w.label))

const graphPeriodLabel = computed(
    () => monthOptions.value.find((o) => o.value === graphPeriod.value)?.title || graphPeriod.value,
)

function weekIndexOf(tx) {
    if (!tx.created_at) return -1
    const t = new Date(tx.created_at).getTime()
    return weekWindows.value.findIndex((w) => t >= w.start.getTime() && t < w.end.getTime())
}

function txTypeLabel(tx) {
    return tx.transaction_type?.name || tx.transaction_type_name || 'Unclassified'
}

// The office's transactions created in the chosen month.
const graphTx = computed(() =>
    scopeSource.value.filter(
        (tx) => tx.office?.code?.toUpperCase() === DASHBOARD_OFFICE.code && weekIndexOf(tx) >= 0,
    )
)

// Per-process weekly counts, busiest process first.
const processRanking = computed(() => {
    const byName = new Map()
    for (const tx of graphTx.value) {
        const name = txTypeLabel(tx)
        if (!byName.has(name)) byName.set(name, weekWindows.value.map(() => 0))
        byName.get(name)[weekIndexOf(tx)]++
    }
    return [...byName.entries()]
        .map(([label, values]) => ({ label, values, total: values.reduce((s, v) => s + v, 0) }))
        .sort((a, b) => b.total - a.total || a.label.localeCompare(b.label))
})

// Process filter: empty = a bar for every process. Picking processes keeps
// only their bars.
const processFilter = ref([])

const processOptions = computed(() =>
    processRanking.value.map((p) => ({ title: `${p.label} (${p.total})`, value: p.label }))
)

// Drop picks that have no transactions in the month now shown.
watch(processOptions, (options) => {
    const names = new Set(options.map((o) => o.value))
    if (processFilter.value.some((name) => !names.has(name))) {
        processFilter.value = processFilter.value.filter((name) => names.has(name))
    }
})

// Stable color slot per process: alphabetical position among ALL processes
// in the month, so the Process filter never repaints a bar. Past 7 processes
// this can't be global, so the slot falls back to the position among the
// bars currently drawn.
const processColorSlot = computed(() => {
    const names = processRanking.value.map((p) => p.label).sort()
    return names.length <= MAX_PROCESS_BARS ? new Map(names.map((n, i) => [n, i])) : null
})

// Bars: up to 7 named processes (the busiest), the rest folded into one
// gray "Other processes" bar.
const graphSeries = computed(() => {
    const picked = processFilter.value
    const shown = picked.length
        ? processRanking.value.filter((p) => picked.includes(p.label))
        : processRanking.value
    const named = shown.slice(0, MAX_PROCESS_BARS)
    const rest = shown.slice(MAX_PROCESS_BARS)

    const palette = SERIES_PALETTE[themeMode.value]
    const slots = processColorSlot.value
    const series = [...named]
        .sort((a, b) => a.label.localeCompare(b.label))
        .map((p, i) => ({ label: p.label, color: palette[slots ? slots.get(p.label) : i], values: p.values }))

    if (rest.length) {
        series.push({
            label: OTHER_PROCESSES,
            color: OTHER_COLOR[themeMode.value],
            values: weekWindows.value.map((_, wi) => rest.reduce((s, p) => s + p.values[wi], 0)),
        })
    }
    return series
})

// ---- Transaction Summary card (superadmin) ----
// Period: last week (the previous Mon–Sun week), or one of the last 12
// months (Manila calendar).
// Completed counts by finalize date, the rest by created date (server side).
const summaryPeriod = ref('last_week')
const periodOptions = computed(() => [{ title: 'Last week', value: 'last_week' }, ...monthOptions.value])

const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// Same office as the graph, but independent of the graph's Month and
// Process filters: the card counts the office's transactions for its own Period.
const summaryQuery = computed(() => ({
    month: summaryPeriod.value === 'last_week' ? undefined : summaryPeriod.value,
    office_code: DASHBOARD_OFFICE.code,
}))

let summaryRequest = 0
async function loadSummary() {
    if (!isSuperadmin.value) return
    const mine = ++summaryRequest
    // Instant illusion: last summary for this period/office paints at once
    // (template already dims stale tiles via .summary-stale), then the
    // network refreshes silently. Spinner only shows with zero cached data.
    const cacheKey = `${CacheKeys.summary}:${JSON.stringify(summaryQuery.value)}`
    const cached = readCache(cacheKey)
    if (cached != null && mine === summaryRequest) summary.value = cached
    const quiet = cached != null
    if (!quiet) summaryLoading.value = true
    summaryError.value = ''
    try {
        const res = await api.get('/api/admin/dashboard/summary', { params: summaryQuery.value })
        if (mine === summaryRequest) {
            summary.value = res.data
            writeCache(cacheKey, res.data)
        }
    } catch (e) {
        if (mine === summaryRequest && summary.value == null) summaryError.value = e?.response?.data?.message || 'Failed to load the summary.'
    } finally {
        if (mine === summaryRequest) summaryLoading.value = false
    }
}
watch(summaryQuery, loadSummary, { deep: true })

const summaryScopeText = computed(
    () => summary.value?.period?.label || periodOptions.value.find((o) => o.value === summaryPeriod.value)?.title || 'Last week',
)

// Status tiles: the icon carries the status color, the number stays in text ink.
const summaryTiles = computed(() => {
    const s = summary.value || {}
    const dark = themeMode.value === 'dark'
    return [
        { key: 'completed', label: 'Completed', icon: 'mdi-check-circle', color: 'success', accent: dark ? '#2fa84f' : '#008300', value: s.completed ?? '—', hint: 'Finalized in this period' },
        { key: 'in_process', label: 'In-process', icon: 'mdi-progress-clock', color: 'grey-darken-1', accent: dark ? '#3987e5' : '#2a78d6', value: s.in_process ?? '—', hint: 'Created in this period, still open' },
        { key: 'overdue', label: 'Overdue', icon: 'mdi-alert', color: 'warning', accent: dark ? '#e0a526' : '#c98500', value: s.overdue ?? '—', hint: 'Open and past their station’s time limit' },
        { key: 'deleted', label: 'Deleted', icon: 'mdi-delete-outline', color: 'grey', accent: dark ? '#a3a19b' : '#6f6d68', value: s.deleted ?? '—', hint: 'Created in this period, then deleted' },
    ]
})

// ---- Detail pop-up: grows out of the tile / process bar that was clicked ----
const tileEls = {}
const barEls = {}
const detail = reactive({ open: false, category: null, processId: null, processName: '', originEl: null })

function openDetail(category, el, processRow = null) {
    if (!summary.value) return
    detail.category = category
    detail.processId = processRow?.id ?? null
    detail.processName = processRow?.name ?? ''
    detail.originEl = el
    detail.open = true
}

// By-process bars: one hue (it's a magnitude comparison); processes picked in
// the Process filter stay full strength, the rest are faded but visible.
const processBarColor = computed(() => SERIES_PALETTE[themeMode.value][0])
const byProcessRows = computed(() => {
    const rows = summary.value?.by_process || []
    const max = Math.max(1, ...rows.map((r) => r.count))
    return rows.map((r) => ({
        ...r,
        pct: Math.max(4, Math.round((r.count / max) * 100)),
    }))
})

// Oldest first: longest-waiting items the user can act on (max 5).
// Superadmin uses the full queue (My Transactions is hidden as redundant).
const actionQueue = computed(() => {
    const base = isSuperadmin.value
        ? [...(txStore.items.value || [])]
        : [...(myStore.items.value || [])]
    base.sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0))
    return base.slice(0, 5)
})

const recent = computed(() => {
    const list = [...(scopeSource.value || [])]
    list.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
    return list.slice(0, 4)
})

// Evenly-distributed shortcut rows that always fill the Get Started card.
const startLinks = computed(() => {
    const links = [
        { title: 'Help guide', subtitle: 'Step-by-step instructions', icon: 'mdi-book-open-outline', color: '#5C6BC0', go: goToHelp },
        isSuperadmin.value
            ? { title: 'Transactions', subtitle: 'All requests in the system', icon: 'mdi-tray-full', color: '#26A69A', go: goToQueue }
            : { title: 'My queue', subtitle: 'Continue where you left off', icon: 'mdi-tray-full', color: '#26A69A', go: goToQueue },
    ]
    if (isSuperadmin.value) {
        links.push({
            title: 'Manage offices',
            subtitle: 'Offices, steps, and assignments',
            icon: 'mdi-office-building-outline',
            color: '#7C3AED',
            go: () => router.push('/admin/offices'),
        })
    }
    return links
})

function txSubtitle(tx) {
    return [tx.reference_number, tx.transaction_type?.name || tx.transaction_type_name]
        .filter(Boolean)
        .join(' · ') || tx.current_step?.name || ''
}

function timeAgo(iso) {
    if (!iso) return ''
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000)
    if (s < 60) return 'just now'
    if (s < 3600) return `${Math.floor(s / 60)}m ago`
    if (s < 86400) return `${Math.floor(s / 3600)}h ago`
    if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`
    return new Date(iso).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })
}

function openTx(tx) {
    router.push(isSuperadmin.value ? `/transactions/${tx.id}` : `/my/transactions/${tx.id}`)
}

function goToQueue() {
    router.push(isSuperadmin.value ? '/transactions' : '/my/transactions')
}

function goToHelp() {
    router.push('/help')
}

onMounted(async () => {
    // Dashboard only: hide the page scrollbar (restored on leave).
    document.documentElement.classList.add('hide-page-scroll')

    // Instant paint from cache when available; the fetches below
    // then refresh everything silently in the background.
    const warm =
        isCached(CacheKeys.transactionTypes) ||
        (isSuperadmin.value
            ? isCached(CacheKeys.transactions)
            : isCached(CacheKeys.myTransactions))
    loading.value = !warm
    const opts = { silent: warm }
    loadSummary()

    try {
        if (isSuperadmin.value) {
            await txStore.fetchAll(opts)
        } else {
            await myStore.fetchAll(opts)
        }
    } catch { /* keep defaults */ }

    refreshedAt.value = new Date()
    loading.value = false
})

// Silent 20s smart-poll: recent/action/graph cards stay fresh in place.
// All fetches are silent so cards never flash, drag order and filters
// are preserved, and the page never reloads or scrolls.
useSmartPoll(async () => {
    const opts = { silent: true }
    try {
        if (isSuperadmin.value) {
            await txStore.fetchAll(opts)
            loadSummary()
        } else {
            await myStore.fetchAll(opts)
        }
        refreshedAt.value = new Date()
    } catch {
        /* next tick retries */
    }
})

onUnmounted(() => {
    document.documentElement.classList.remove('hide-page-scroll')
})
</script>

<style scoped>
/* ---- Movable cards ---- */
/* Each card keeps its width but grows to fill its row, so no order leaves a gap. */
.dash-col {
    flex-grow: 1;
    max-width: 100%;
}
.dash-dragging {
    opacity: 0.45;
}
.dash-drop-target > .v-card {
    outline: 2px dashed rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.recent-row {
    cursor: pointer;
}
.recent-row:hover {
    background: #f1f5f9;
}
/* Slimmer recent rows: smaller type instead of cramped spacing */
.recent-row :deep(.v-list-item-title) {
    font-size: 0.85rem;
    line-height: 1.25;
}
.recent-row :deep(.v-list-item-subtitle) {
    font-size: 0.72rem;
    line-height: 1.3;
}
.recent-row :deep(.v-list-item__prepend) {
    padding-right: 10px;
}
.action-table {
    --v-table-header-height: 40px;
}
.action-row {
    cursor: pointer;
}
.action-row:hover {
    background: #f1f5f9;
}
.action-title {
    font-size: 0.85rem;
    line-height: 1.25;
}
.action-table :deep(th) {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #94a3b8;
}
.action-table :deep(td) {
    padding-top: 6px;
    padding-bottom: 6px;
}
.process-filter {
    flex: 0 1 240px;
    min-width: 160px;
}
/* ---- Transaction Summary card ---- */
.summary-tiles {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 12px;
}
.summary-tile {
    position: relative;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    padding: 12px 14px 26px;
    min-width: 0;
    cursor: pointer;
    background: rgb(var(--v-theme-surface));
    transition: transform 0.22s cubic-bezier(.2, .9, .25, 1), box-shadow 0.22s, border-color 0.22s;
}
.summary-tile:hover,
.summary-tile:focus-visible {
    transform: translateY(-3px);
    border-color: var(--tile-accent);
    box-shadow: 0 10px 22px -12px color-mix(in srgb, var(--tile-accent) 55%, transparent);
    outline: none;
}
.summary-tile:focus-visible {
    box-shadow: 0 0 0 2px var(--tile-accent);
}
.summary-tile-icon {
    transition: transform 0.3s cubic-bezier(.3, 1.6, .5, 1);
}
.summary-tile:hover .summary-tile-icon {
    transform: scale(1.18) rotate(-6deg);
}
.summary-tile-cta {
    position: absolute;
    left: 14px;
    bottom: 7px;
    font-size: 0.75rem;
    font-weight: 700;
    color: var(--tile-accent);
    opacity: 0;
    transform: translateX(-6px);
    transition: opacity 0.2s, transform 0.2s;
}
.summary-tile:hover .summary-tile-cta,
.summary-tile:focus-visible .summary-tile-cta {
    opacity: 1;
    transform: none;
}
@media (prefers-reduced-motion: reduce) {
    .summary-tile,
    .summary-tile-icon,
    .summary-tile-cta {
        transition: none;
    }
    .summary-tile:hover,
    .summary-tile:focus-visible,
    .summary-tile:hover .summary-tile-icon {
        transform: none;
    }
}
.summary-tile-label {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.78rem;
    font-weight: 700;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
    text-transform: uppercase;
    letter-spacing: 0.04em;
}
.summary-tile-value {
    font-size: 2.1rem;
    font-weight: 800;
    line-height: 1.15;
    margin: 6px 0 2px;
    min-height: 2.4rem;
    color: rgb(var(--v-theme-on-surface));
}
.summary-stale {
    opacity: 0.6;
    transition: opacity 0.15s;
}
.process-bar-row {
    display: grid;
    grid-template-columns: minmax(80px, 120px) 1fr 32px;
    align-items: center;
    gap: 10px;
    padding: 5px 6px;
    margin: 0 -6px;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.15s;
}
.process-bar-row:hover,
.process-bar-row:focus-visible {
    background: rgba(var(--v-theme-on-surface), 0.05);
    outline: none;
}
.process-bar-row.faded {
    opacity: 0.3;
}
.process-bar-name {
    font-size: 0.85rem;
    font-weight: 700;
    color: rgb(var(--v-theme-on-surface));
}
.process-bar-track {
    height: 10px;
    background: rgba(var(--v-theme-on-surface), 0.06);
    border-radius: 0 4px 4px 0;
    overflow: hidden;
}
.process-bar-fill {
    height: 100%;
    border-radius: 0 4px 4px 0;
}
.process-bar-count {
    font-size: 0.85rem;
    font-weight: 800;
    text-align: right;
    color: rgb(var(--v-theme-on-surface));
}
.start-row {
    cursor: pointer;
    min-height: 64px;
}
.start-row + .start-row {
    border-top: 1px solid #eef2f7;
}
.start-row:hover {
    background: #f1f5f9;
}
.start-title {
    font-size: 0.85rem;
    line-height: 1.25;
}
</style>
