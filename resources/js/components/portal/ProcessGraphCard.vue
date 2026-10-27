<template>
    <!-- Same weekly per-process graph as the admin dashboard, limited to what
         the server lets this account see: its office's transactions plus
         rows waiting on one of its roles at its office. -->
    <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="width: 100%">
        <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4 graph-head">
            <v-avatar color="white" rounded="0" size="40" class="mr-3 graph-avatar">
                <v-icon color="#005EED" size="24">mdi-chart-bar</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold">{{ title }}</span>
            <v-spacer />
            <v-select
                v-model="period"
                :items="monthOptions"
                label="Month"
                variant="outlined"
                density="compact"
                rounded="0"
                hide-details
                class="graph-filter"
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
                class="graph-filter"
            >
                <template v-slot:selection="{ item, index }">
                    <span v-if="index === 0" class="text-truncate">
                        {{ processFilter.length === 1 ? item.raw.value : `${processFilter.length} processes` }}
                    </span>
                </template>
            </v-select>
        </v-card-title>
        <v-card-text class="pa-3 d-flex flex-column" style="flex: 1 1 auto">
            <GroupedBarChart
                :series="series"
                :group-labels="weekLabels"
                :loading="loading"
                :height="190"
                :empty-text="emptyText"
                :aria-label="ariaLabel"
            />
        </v-card-text>
    </v-card>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useTheme } from 'vuetify'
import { useApi } from '@/composables/useApi'
import { useAuth } from '@/composables/useAuth'
import { useSmartPoll } from '@/composables/useSmartPoll'
import GroupedBarChart from '@/components/GroupedBarChart.vue'

const { api } = useApi()
const { user } = useAuth()

// Same palette as the admin dashboard graph; gray is the folded "Other" bar.
const SERIES_PALETTE = {
    light: ['#005EED', '#F26B21', '#1A1F2B', '#FFA94D', '#4D94FF', '#B84A0F', '#8FBBFF'],
    dark: ['#4D94FF', '#FF8A4C', '#B9D4FF', '#FFB27A', '#1F6FFF', '#D9622B', '#8FBBFF'],
}
const OTHER_PROCESSES = 'Other processes'
const OTHER_COLOR = '#898781'
const MAX_PROCESS_BARS = SERIES_PALETTE.light.length
const DAY_MS = 86400000
// The list endpoint pages newest first; stop once a page reaches before the
// chosen month (or at this many pages).
const PER_PAGE = 100
const MAX_PAGES = 10

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

const officeCode = computed(() => user.value?.office?.code?.toUpperCase() || null)
const title = computed(() =>
    officeCode.value ? `${officeCode.value} Transactions per Process` : 'Transactions per Process',
)

const monthValue = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`
const monthOptions = computed(() => {
    const now = new Date()
    return Array.from({ length: 12 }, (_, i) => {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
        return { title: d.toLocaleDateString('en-PH', { month: 'long', year: 'numeric' }), value: monthValue(d) }
    })
})
const period = ref(monthValue(new Date()))
const periodLabel = computed(() => monthOptions.value.find((o) => o.value === period.value)?.title || period.value)

function weekLabel(start, endExclusive) {
    const last = new Date(endExclusive.getTime() - DAY_MS)
    const md = (d) => d.toLocaleDateString('en-PH', { month: 'short', day: 'numeric' })
    if (last.getTime() <= start.getTime()) return md(start)
    return start.getMonth() === last.getMonth() ? `${md(start)}–${last.getDate()}` : `${md(start)}–${md(last)}`
}

// Calendar weeks of the chosen month (1–7, 8–14, …), never past today.
const weeks = computed(() => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const endOfToday = new Date(today.getTime() + DAY_MS)
    const [y, m] = period.value.split('-').map(Number)
    const monthEnd = new Date(y, m, 1)
    const out = []
    for (let start = new Date(y, m - 1, 1); start < monthEnd && start < endOfToday;) {
        const end = new Date(Math.min(start.getTime() + 7 * DAY_MS, monthEnd.getTime()))
        out.push({ start, end, label: weekLabel(start, end) })
        start = end
    }
    return out
})
const weekLabels = computed(() => weeks.value.map((w) => w.label))

function weekIndexOf(tx) {
    if (!tx.created_at) return -1
    const t = new Date(tx.created_at).getTime()
    return weeks.value.findIndex((w) => t >= w.start.getTime() && t < w.end.getTime())
}

// ---- Data: the account's visible transactions for the chosen month ----
const rows = ref([])
const loading = ref(true)
let request = 0

async function load({ quiet = false } = {}) {
    const mine = ++request
    if (!quiet) loading.value = true
    const [y, m] = period.value.split('-').map(Number)
    const monthStart = new Date(y, m - 1, 1).getTime()
    const collected = []
    try {
        for (let page = 1; page <= MAX_PAGES; page++) {
            const res = await api.get('/api/admin/transactions', { params: { per_page: PER_PAGE, page } })
            const data = res.data?.data ?? []
            collected.push(...data)
            const lastPage = res.data?.meta?.last_page ?? 1
            const oldest = data[data.length - 1]
            if (page >= lastPage || !oldest || new Date(oldest.created_at).getTime() < monthStart) break
        }
        if (mine === request) rows.value = collected
    } catch {
        /* keep what is shown; the next poll retries */
    } finally {
        if (mine === request) loading.value = false
    }
}

watch(period, () => load())
onMounted(() => load())
useSmartPoll(() => load({ quiet: true }))

// Per-process weekly counts, busiest first.
const ranking = computed(() => {
    const byName = new Map()
    for (const tx of rows.value) {
        const wi = weekIndexOf(tx)
        if (wi < 0) continue
        const name = tx.transaction_type?.name || tx.transaction_type_name
        if (!name) continue
        if (!byName.has(name)) byName.set(name, weeks.value.map(() => 0))
        byName.get(name)[wi]++
    }
    return [...byName.entries()]
        .map(([label, values]) => ({ label, values, total: values.reduce((s, v) => s + v, 0) }))
        .sort((a, b) => b.total - a.total || a.label.localeCompare(b.label))
})

const processFilter = ref([])
const processOptions = computed(() =>
    ranking.value.map((p) => ({ title: `${p.label} (${p.total})`, value: p.label })),
)
watch(processOptions, (options) => {
    const names = new Set(options.map((o) => o.value))
    if (processFilter.value.some((n) => !names.has(n))) {
        processFilter.value = processFilter.value.filter((n) => names.has(n))
    }
})

// Up to 7 named processes (the busiest), the rest folded into one gray bar.
// Colors keep an alphabetical slot so filtering never repaints a bar.
const series = computed(() => {
    const picked = processFilter.value
    const shown = picked.length ? ranking.value.filter((p) => picked.includes(p.label)) : ranking.value
    const named = shown.slice(0, MAX_PROCESS_BARS)
    const rest = shown.slice(MAX_PROCESS_BARS)

    const palette = SERIES_PALETTE[themeMode.value]
    const allNames = ranking.value.map((p) => p.label).sort()
    const slots = allNames.length <= MAX_PROCESS_BARS ? new Map(allNames.map((n, i) => [n, i])) : null
    const out = [...named]
        .sort((a, b) => a.label.localeCompare(b.label))
        .map((p, i) => ({ label: p.label, color: palette[slots ? slots.get(p.label) : i], values: p.values }))
    if (rest.length) {
        out.push({
            label: OTHER_PROCESSES,
            color: OTHER_COLOR,
            values: weeks.value.map((_, wi) => rest.reduce((s, p) => s + p.values[wi], 0)),
        })
    }
    return out
})

const emptyText = computed(() =>
    officeCode.value
        ? `No ${officeCode.value} transactions in ${periodLabel.value}`
        : `No transactions in ${periodLabel.value}`,
)
const ariaLabel = computed(() =>
    `${officeCode.value ? officeCode.value + ' t' : 'T'}ransactions per process per week, ${periodLabel.value}`,
)
</script>

<style scoped>
.graph-head {
    background: transparent;
    border-bottom: 4px solid rgb(var(--v-theme-primary));
    border-image: var(--tms-grad-h) 1;
}
.graph-avatar {
    border: 2px solid rgb(var(--v-theme-primary));
}
.graph-filter {
    flex: 0 1 240px;
    min-width: 160px;
}
</style>
