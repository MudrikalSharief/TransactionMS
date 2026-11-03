<template>
    <!-- Same weekly per-process graph as the admin dashboard, limited to what
         the server lets this account see: its office's transactions plus
         rows waiting on one of its roles at its office. -->
    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
        <v-card-title class="d-flex align-center ga-2 lgu-head dash-head">
            <v-avatar color="white" rounded="0" size="34" class="lgu-head-avatar">
                <v-icon color="#005EED" size="20">mdi-chart-bar</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold dash-head-title">{{ title }}</span>
            <v-spacer />
            <!-- The period comes from the Home page's Period filter. -->
            <v-select
                v-model="processFilter"
                :items="processOptions"
                label="Process"
                placeholder="All processes"
                persistent-placeholder
                prepend-inner-icon="mdi-swap-horizontal"
                variant="outlined"
                density="compact"
                rounded="lg"
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
        <v-card-text class="pa-2 d-flex flex-column dash-body">
            <GroupedBarChart
                :series="series"
                :group-labels="groupLabels"
                :loading="loading"
                :height="fit ? 80 : 190"
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
import { useFitScreen } from '@/composables/useFitScreen'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import { periodBuckets, periodLabel as labelOf, periodStart, bucketIndexOf, bucketUnit } from '@/utils/dashPeriod'

// 'all' | 'this_week' | 'YYYY-MM' (the Home page's Period filter).
const props = defineProps({
    period: { type: String, default: 'all' },
})

const { api } = useApi()
const { user } = useAuth()
const { fit } = useFitScreen()

// Same palette as the admin dashboard graph; gray is the folded "Other" bar.
const SERIES_PALETTE = {
    light: ['#005EED', '#F26B21', '#1A1F2B', '#FFA94D', '#4D94FF', '#B84A0F', '#8FBBFF'],
    dark: ['#4D94FF', '#FF8A4C', '#B9D4FF', '#FFB27A', '#1F6FFF', '#D9622B', '#8FBBFF'],
}
const OTHER_PROCESSES = 'Other processes'
const OTHER_COLOR = '#898781'
const MAX_PROCESS_BARS = SERIES_PALETTE.light.length
// The list endpoint pages newest first; stop once a page reaches before the
// period's start (or at this many pages).
const PER_PAGE = 100
const MAX_PAGES = 10

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

const officeCode = computed(() => user.value?.office?.code?.toUpperCase() || null)
const title = computed(() =>
    officeCode.value ? `${officeCode.value} Transactions per Process` : 'Transactions per Process',
)

const periodLabel = computed(() => labelOf(props.period))

// ---- Data: the account's visible transactions for the period ----
const rows = ref([])
const loading = ref(true)
let request = 0

// One bar group per day (this week), week (a month) or month (all time).
const oldest = computed(() => rows.value.reduce((o, tx) => (tx.created_at && (!o || tx.created_at < o) ? tx.created_at : o), null))
const groups = computed(() => periodBuckets(props.period, { oldest: oldest.value }))
const groupLabels = computed(() => groups.value.map((g) => g.label))
const unit = computed(() => bucketUnit(props.period, groups.value))

async function load({ quiet = false } = {}) {
    const mine = ++request
    if (!quiet) loading.value = true
    const monthStart = periodStart(props.period)?.getTime() ?? -Infinity
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

watch(() => props.period, () => load())
onMounted(() => load())
useSmartPoll(() => load({ quiet: true }))

// Per-process counts per bar group, busiest first.
const ranking = computed(() => {
    const byName = new Map()
    for (const tx of rows.value) {
        const wi = bucketIndexOf(groups.value, tx.created_at)
        if (wi < 0) continue
        const name = tx.transaction_type?.name || tx.transaction_type_name
        if (!name) continue
        if (!byName.has(name)) byName.set(name, groups.value.map(() => 0))
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
            values: groups.value.map((_, wi) => rest.reduce((s, p) => s + p.values[wi], 0)),
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
    `${officeCode.value ? officeCode.value + ' t' : 'T'}ransactions per process per ${unit.value}, ${periodLabel.value}`,
)
</script>

<style scoped>
/* The filters give up width before the title does. */
.graph-filter {
    flex: 0 20 224px;
    min-width: 120px;
}
.graph-filter :deep(.v-field__input) {
    font-size: 0.875rem;
}
@container (max-width: 720px) {
    .graph-filter :deep(.v-field__prepend-inner) {
        display: none;
    }
}
</style>
