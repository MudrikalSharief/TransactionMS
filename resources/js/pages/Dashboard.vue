<template>
    <div>
        <v-row align="stretch">
            <v-col cols="12" lg="8" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
                        <v-avatar color="#7C3AED" rounded="0" size="34" class="mr-3">
                            <v-icon color="white" size="22">mdi-chart-areaspline</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Transactions per Office</span>
                        <v-spacer />
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
                            class="process-filter mr-2"
                        >
                            <template v-slot:selection="{ item, index }">
                                <span v-if="index === 0" class="text-truncate">
                                    {{ processFilter.length === 1 ? item.raw.value : `${processFilter.length} processes` }}
                                </span>
                            </template>
                        </v-select>
                        <v-select
                            v-model="officeFilter"
                            :items="officeOptions"
                            label="Office"
                            placeholder="All offices"
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
                                    {{ officeFilter.length === 1 ? item.raw.value : `${officeFilter.length} offices` }}
                                </span>
                            </template>
                        </v-select>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-3 d-flex flex-column" style="flex: 1 1 auto">
                        <AreaWaveChart
                            :points="weeklyOfficeVolume"
                            :series="weeklyByOffice.series"
                            :week-labels="weeklyByOffice.weeks"
                            :highlight="officeFilter"
                            :loading="loading"
                            :height="190"
                            aria-label="Transactions per office per week, last 10 weeks"
                        />
                        <div v-if="!loading && (noOfficeCount || processFilter.length)" class="text-caption text-medium-emphasis mt-1">
                            <template v-if="processFilter.length">Counting {{ processFilter.join(', ') }} only.&nbsp;</template>
                            <template v-if="noOfficeCount">
                                {{ noOfficeCount }} transaction{{ noOfficeCount === 1 ? '' : 's' }} without an office
                                {{ noOfficeCount === 1 ? 'is' : 'are' }} not shown.
                            </template>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" lg="4" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
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
        </v-row>

        <v-row v-if="isSuperadmin" class="mt-2">
            <v-col cols="12">
                <v-card rounded="0" elevation="1" class="lgu-card summary-card">
                    <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4">
                        <v-avatar color="#4A3AA7" rounded="0" size="34" class="mr-1">
                            <v-icon color="white" size="22">mdi-clipboard-text-clock-outline</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Transaction Summary</span>
                        <span class="text-caption text-medium-emphasis ml-1">{{ summaryScopeText }}</span>
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
                                    <div v-for="tile in summaryTiles" :key="tile.key" class="summary-tile">
                                        <div class="d-flex align-center ga-2 summary-tile-label">
                                            <v-icon :color="tile.color" size="20">{{ tile.icon }}</v-icon>
                                            {{ tile.label }}
                                        </div>
                                        <div class="summary-tile-value">
                                            <v-progress-circular v-if="summaryLoading && !summary" indeterminate size="22" width="3" color="grey" />
                                            <template v-else>{{ tile.value }}</template>
                                        </div>
                                        <div class="text-caption text-medium-emphasis">{{ tile.hint }}</div>
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
                                    v-tooltip:top="`${row.name}: ${row.count} transaction${row.count === 1 ? '' : 's'} created`"
                                    class="process-bar-row"
                                    :class="{ faded: row.faded }"
                                >
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
        </v-row>

        <v-row class="mt-2" align="stretch">
            <v-col cols="12" lg="4" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
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
            <v-col cols="12" lg="8" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
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
        </v-row>
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTheme } from 'vuetify'
import { useAuth } from '@/composables/useAuth'
import { useApi } from '@/composables/useApi'
import { useTransactions } from '@/composables/useTransactions'
import { useMyTransactions } from '@/composables/useMyTransactions'
import AreaWaveChart from '@/components/AreaWaveChart.vue'
import { isCached, CacheKeys } from '@/composables/useCache'

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

// Scope: superadmin sees everything, everyone else sees their own queue.
const scopeSource = computed(() =>
    isSuperadmin.value ? (txStore.items.value || []) : (myStore.items.value || [])
)

// Office line colors: validated categorical palette (dataviz reference
// palette, adjacent-pair safe in both modes), light and dark steps.
// Gray is reserved for the folded "Other offices" line.
const OFFICE_PALETTE = {
    light: ['#2a78d6', '#eb6834', '#1baf7a', '#eda100', '#e87ba4', '#008300', '#4a3aa7'],
    dark: ['#3987e5', '#d95926', '#199e70', '#c98500', '#d55181', '#008300', '#9085e9'],
}
const OTHER_OFFICES = 'Other offices'
const OTHER_COLOR = { light: '#898781', dark: '#898781' }
const MAX_OFFICE_LINES = OFFICE_PALETTE.light.length

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

// 10 full 7-day windows ending today, shared by the wave totals + type stack.
const weekWindows = computed(() => {
    const windows = []
    const now = new Date()
    now.setHours(0, 0, 0, 0)
    for (let w = 9; w >= 0; w--) {
        const start = new Date(now.getTime() - w * 7 * 86400000)
        start.setHours(0, 0, 0, 0)
        windows.push({
            start,
            end: new Date(start.getTime() + 7 * 86400000),
            label: start.toLocaleDateString('en-PH', { month: 'short', day: 'numeric' }),
        })
    }
    return windows
})

function weekIndexOf(tx) {
    if (!tx.created_at) return -1
    const t = new Date(tx.created_at).getTime()
    return weekWindows.value.findIndex((w) => t >= w.start.getTime() && t < w.end.getTime())
}

function txTypeLabel(tx) {
    return tx.transaction_type?.name || tx.transaction_type_name || 'Unclassified'
}

// All transactions in the 10-week window (drives the Process options).
const windowTxAll = computed(() => scopeSource.value.filter((tx) => weekIndexOf(tx) >= 0))

// Process filter: empty = all processes; otherwise only the picked ones
// are counted in every office line.
const processFilter = ref([])

const processOptions = computed(() => {
    const counts = new Map()
    for (const tx of windowTxAll.value) {
        if (!tx.office?.code) continue
        const label = txTypeLabel(tx)
        counts.set(label, (counts.get(label) || 0) + 1)
    }
    return [...counts.entries()]
        .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
        .map(([label, n]) => ({ title: `${label} (${n})`, value: label }))
})

// Window transactions after the Process filter, split by office presence.
const windowTx = computed(() => {
    const picked = processFilter.value
    if (!picked.length) return windowTxAll.value
    return windowTxAll.value.filter((tx) => picked.includes(txTypeLabel(tx)))
})
const noOfficeCount = computed(() => windowTx.value.filter((tx) => !tx.office?.code).length)

// Per-office weekly counts inside the window, keyed by office code.
const officeRanking = computed(() => {
    const byCode = new Map()
    for (const tx of windowTx.value) {
        const code = tx.office?.code
        if (!code) continue
        if (!byCode.has(code)) {
            byCode.set(code, { code, name: tx.office.name || code, values: weekWindows.value.map(() => 0) })
        }
        byCode.get(code).values[weekIndexOf(tx)]++
    }
    return [...byCode.values()]
        .map((o) => ({ ...o, total: o.values.reduce((s, v) => s + v, 0) }))
        .sort((a, b) => b.total - a.total || a.code.localeCompare(b.code))
})

// Office filter: selected offices stay full color, the rest are faded.
const officeFilter = ref([])

const officeOptions = computed(() =>
    officeRanking.value.map((o) => ({
        title: `${o.code} — ${o.name} (${o.total})`,
        value: o.code,
        props: {
            disabled: officeFilter.value.length >= MAX_OFFICE_LINES && !officeFilter.value.includes(o.code),
        },
    }))
)

// Stable color slot per office: position among ALL offices with data in the
// window (ignoring the Process filter), by code. So neither filter ever
// repaints a line. Past 7 offices this can't be global, so the slot falls
// back to the office's position among the lines currently drawn.
const officeColorSlot = computed(() => {
    const codes = [...new Set(windowTxAll.value.map((tx) => tx.office?.code).filter(Boolean))].sort()
    return codes.length <= MAX_OFFICE_LINES ? new Map(codes.map((c, i) => [c, i])) : null
})

// Lines: up to 7 named offices (selected ones always included, then the
// busiest), the rest folded into one gray "Other offices" line.
const weeklyByOffice = computed(() => {
    const ranked = officeRanking.value
    const picked = new Set(officeFilter.value)
    const named = [
        ...ranked.filter((o) => picked.has(o.code)),
        ...ranked.filter((o) => !picked.has(o.code)),
    ].slice(0, MAX_OFFICE_LINES)
    const namedCodes = new Set(named.map((o) => o.code))
    const rest = ranked.filter((o) => !namedCodes.has(o.code))

    const palette = OFFICE_PALETTE[themeMode.value]
    const slots = officeColorSlot.value
    const series = [...named]
        .sort((a, b) => a.code.localeCompare(b.code))
        .map((o, i) => ({ label: o.code, color: palette[slots ? slots.get(o.code) : i], values: o.values }))

    if (rest.length) {
        series.push({
            label: OTHER_OFFICES,
            color: OTHER_COLOR[themeMode.value],
            values: weekWindows.value.map((_, wi) => rest.reduce((s, o) => s + o.values[wi], 0)),
        })
    }

    return { weeks: weekWindows.value.map((w) => w.label), series }
})

// Weekly totals across offices (the chart's fallback when no office has data).
const weeklyOfficeVolume = computed(() =>
    weekWindows.value.map((w, wi) => ({
        label: w.label,
        value: officeRanking.value.reduce((s, o) => s + o.values[wi], 0),
    }))
)

// ---- Transaction Summary card (superadmin) ----
// Period: last 4 weeks, or one of the last 12 months (Manila calendar).
// Completed counts by finalize date, the rest by created date (server side).
const summaryPeriod = ref('last_4_weeks')
const periodOptions = computed(() => {
    const opts = [{ title: 'Last 4 weeks', value: 'last_4_weeks' }]
    const now = new Date()
    for (let i = 0; i < 12; i++) {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
        opts.push({
            title: d.toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }),
            value: `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`,
        })
    }
    return opts
})

const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// The graph filters hold process names / office codes; the API wants ids.
const processIdByName = computed(() => {
    const m = new Map()
    for (const tx of scopeSource.value) if (tx.transaction_type?.id) m.set(tx.transaction_type.name, tx.transaction_type.id)
    return m
})
const officeIdByCode = computed(() => {
    const m = new Map()
    for (const tx of scopeSource.value) if (tx.office?.id) m.set(tx.office.code, tx.office.id)
    return m
})
const summaryQuery = computed(() => ({
    month: summaryPeriod.value === 'last_4_weeks' ? undefined : summaryPeriod.value,
    processes: processFilter.value.map((n) => processIdByName.value.get(n)).filter(Boolean),
    offices: officeFilter.value.map((c) => officeIdByCode.value.get(c)).filter(Boolean),
}))

let summaryRequest = 0
async function loadSummary() {
    if (!isSuperadmin.value) return
    const mine = ++summaryRequest
    summaryLoading.value = true
    summaryError.value = ''
    try {
        const res = await api.get('/api/admin/dashboard/summary', { params: summaryQuery.value })
        if (mine === summaryRequest) summary.value = res.data
    } catch (e) {
        if (mine === summaryRequest) summaryError.value = e?.response?.data?.message || 'Failed to load the summary.'
    } finally {
        if (mine === summaryRequest) summaryLoading.value = false
    }
}
watch(summaryQuery, loadSummary, { deep: true })

const summaryScopeText = computed(() => {
    const parts = [summary.value?.period?.label || (summaryPeriod.value === 'last_4_weeks' ? 'Last 4 weeks' : '')]
    if (processFilter.value.length) parts.push(processFilter.value.join(', '))
    if (officeFilter.value.length) parts.push(officeFilter.value.join(', '))
    return parts.filter(Boolean).join(' · ')
})

// Status tiles: the icon carries the status color, the number stays in text ink.
const summaryTiles = computed(() => {
    const s = summary.value || {}
    return [
        { key: 'completed', label: 'Completed', icon: 'mdi-check-circle', color: 'success', value: s.completed ?? '—', hint: 'Finalized in this period' },
        { key: 'in_process', label: 'In-process', icon: 'mdi-progress-clock', color: 'grey-darken-1', value: s.in_process ?? '—', hint: 'Created in this period, still open' },
        { key: 'overdue', label: 'Overdue', icon: 'mdi-alert', color: 'warning', value: s.overdue ?? '—', hint: 'Open and past their station’s time limit' },
        { key: 'deleted', label: 'Deleted', icon: 'mdi-delete-outline', color: 'grey', value: s.deleted ?? '—', hint: 'Created in this period, then deleted' },
    ]
})

// By-process bars: one hue (it's a magnitude comparison); processes picked in
// the Process filter stay full strength, the rest are faded but visible.
const processBarColor = computed(() => OFFICE_PALETTE[themeMode.value][0])
const byProcessRows = computed(() => {
    const rows = summary.value?.by_process || []
    const max = Math.max(1, ...rows.map((r) => r.count))
    const picked = processFilter.value
    return rows.map((r) => ({
        ...r,
        pct: Math.max(4, Math.round((r.count / max) * 100)),
        faded: picked.length > 0 && !picked.includes(r.name),
    }))
})

// Oldest first: longest-waiting items the user can act on (max 5).
// Superadmins with an empty personal queue fall back to the oldest overall.
const actionQueue = computed(() => {
    const mine = [...(myStore.items.value || [])]
    const base =
        mine.length > 0
            ? mine
            : isSuperadmin.value
              ? [...(txStore.items.value || [])]
              : []
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
        { title: 'My queue', subtitle: 'Continue where you left off', icon: 'mdi-tray-full', color: '#26A69A', go: goToQueue },
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
        isCached(CacheKeys.myTransactions) ||
        (isSuperadmin.value && isCached(CacheKeys.transactions))
    loading.value = !warm
    const opts = { silent: warm }
    loadSummary()

    try {
        if (isSuperadmin.value) {
            await txStore.fetchAll(opts)
        }
    } catch { /* keep defaults */ }

    try {
        await myStore.fetchAll(opts)
    } catch { /* ignore */ }

    refreshedAt.value = new Date()
    loading.value = false
})

onUnmounted(() => {
    document.documentElement.classList.remove('hide-page-scroll')
})
</script>

<style scoped>
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
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    padding: 12px 14px;
    min-width: 0;
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
    padding: 5px 0;
    cursor: default;
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
