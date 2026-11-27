<template>
    <!-- Staff-portal copy of the admin Transaction Status chart: the same
         three monthly series, switched between Personal and Office scope. -->
    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
        <v-card-title class="d-flex align-center lgu-head dash-head chart-head">
            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                <v-icon color="#005EED" size="20">mdi-chart-bar</v-icon>
            </v-avatar>
            <span class="text-subtitle-1 font-weight-bold dash-head-title">Transaction Status</span>
            <v-spacer />
            <div class="chart-filters">
                <v-menu location="bottom end" offset="6" :close-on-content-click="true">
                    <template #activator="{ props }">
                        <button
                            v-bind="props"
                            type="button"
                            class="topsteps-month"
                            aria-label="Filter Transaction Status by month"
                        >
                            <v-icon size="16">mdi-calendar-range</v-icon>
                            <span>{{ monthLabel }}</span>
                            <v-icon size="16">mdi-chevron-down</v-icon>
                        </button>
                    </template>
                    <v-list density="compact" class="topsteps-month-list">
                        <v-list-item
                            v-for="m in monthChoices"
                            :key="m.value"
                            :active="selectedMonth === m.value"
                            @click="selectedMonth = m.value"
                        >
                            <v-list-item-title>{{ m.title }}</v-list-item-title>
                            <template #append>
                                <v-icon v-if="selectedMonth === m.value" size="18">mdi-check</v-icon>
                            </template>
                        </v-list-item>
                    </v-list>
                </v-menu>
            </div>
        </v-card-title>
        <v-card-text class="pa-2 d-flex flex-column dash-body">
            <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-2">
                {{ error }}
            </v-alert>
            <GroupedBarChart
                :series="series"
                :group-labels="groupLabels"
                :loading="loading && !data"
                :height="fit ? 80 : 190"
                :empty-text="emptyText"
                :aria-label="ariaLabel"
                show-zero-series
            />
        </v-card-text>
    </v-card>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useTheme } from 'vuetify'
import { useApi } from '@/composables/useApi'
import { useFitScreen } from '@/composables/useFitScreen'
import { useSmartPoll } from '@/composables/useSmartPoll'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import { monthOptions, monthValue } from '@/utils/dashPeriod'

// Same semantic colors as the admin dashboard chart.
const STATUS_COLORS = {
    light: { in_process: '#FFBD32', completed_late: '#FF5262', completed_on_time: '#35BD83' },
    dark: { in_process: '#FFD074', completed_late: '#FF8B96', completed_on_time: '#72D7AB' },
}

const props = defineProps({
    view: { type: String, default: 'personal' }, // personal | office
})

const { api } = useApi()
const { fit } = useFitScreen()
const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

const monthChoices = computed(() => monthOptions())
const selectedMonth = ref(monthValue(new Date()))

const data = ref(null)
const loading = ref(false)
const error = ref('')
let request = 0

const monthLabel = computed(
    () => data.value?.label || monthChoices.value.find((m) => m.value === selectedMonth.value)?.title || selectedMonth.value,
)
const months = computed(() => data.value?.months || [])
const groupLabels = computed(() => months.value.map((m) => m.label))
const series = computed(() => {
    const rows = months.value
    const palette = STATUS_COLORS[themeMode.value]
    return [
        { label: 'In progress', color: palette.in_process, values: rows.map((r) => r.in_process || 0) },
        { label: 'Overdue Completed', color: palette.completed_late, values: rows.map((r) => r.completed_late || 0) },
        { label: 'On-Time Completed', color: palette.completed_on_time, values: rows.map((r) => r.completed_on_time || 0) },
    ]
})
const emptyText = computed(() => `No transactions in the 3 months ending ${monthLabel.value}`)
const ariaLabel = computed(() => `Transactions by status for the 3 months ending ${monthLabel.value}`)

async function load({ silent = false } = {}) {
    const mine = ++request
    if (!silent && !data.value) loading.value = true
    error.value = ''
    try {
        const res = await api.get('/api/portal/transaction-status', {
            params: { month: selectedMonth.value, view: props.view },
            timeout: 10000,
        })
        if (mine !== request) return
        data.value = res.data
    } catch (e) {
        if (mine !== request) return
        error.value = e?.code === 'ECONNABORTED'
            ? 'The transaction status took too long to load.'
            : (e?.response?.data?.message || 'Failed to load the transaction status.')
    } finally {
        if (mine === request) loading.value = false
    }
}

watch(selectedMonth, () => {
    data.value = null
    loading.value = true
    load()
})

watch(() => props.view, () => {
    data.value = null
    loading.value = true
    load()
})

onMounted(() => load())
useSmartPoll(() => load({ silent: true }))
</script>
