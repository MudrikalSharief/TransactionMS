<template>
    <div>
        <v-row align="stretch">
            <v-col cols="12" lg="8" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card d-flex flex-column" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
                        <v-avatar color="#7C3AED" rounded="0" size="34" class="mr-3">
                            <v-icon color="white" size="22">mdi-chart-areaspline</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Transactions per Week</span>
                        <v-spacer />
                        <v-select
                            v-model="processFilter"
                            :items="processOptions"
                            label="Process"
                            placeholder="Top 5"
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
                                    {{ processFilter.length === 1 ? item.raw.label : `${processFilter.length} processes` }}
                                </span>
                            </template>
                        </v-select>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-3 d-flex flex-column" style="flex: 1 1 auto">
                        <AreaWaveChart
                            :points="weeklyVolume"
                            :series="weeklyStack.series"
                            :week-labels="weeklyStack.weeks"
                            :totals="processFilter.length ? null : weeklyVolume.map((p) => p.value)"
                            :loading="loading"
                            :height="190"
                        />
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
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useTransactions } from '@/composables/useTransactions'
import { useMyTransactions } from '@/composables/useMyTransactions'
import AreaWaveChart from '@/components/AreaWaveChart.vue'
import { isCached, CacheKeys } from '@/composables/useCache'

const router = useRouter()
const auth = useAuth()

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

// Shared palette for the wave type layers.
const PALETTE = [
    '#7C3AED', '#26A69A', '#4CAF50', '#FFB300',
    '#EC407A', '#5C6BC0', '#FF7043', '#9E9E9E',
]

function txTypeLabel(tx) {
    return tx.transaction_type?.name || tx.transaction_type_name || 'Unclassified'
}

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

// Transactions created per week, last 10 full 7-day windows ending today.
const weeklyVolume = computed(() =>
    weekWindows.value.map((w) => ({
        label: w.label,
        value: scopeSource.value.filter((tx) => {
            if (!tx.created_at) return false
            const t = new Date(tx.created_at).getTime()
            return t >= w.start.getTime() && t < w.end.getTime()
        }).length,
    }))
)

// Per-process weekly counts inside the chart window, busiest first.
// Colors follow the rank so the top 5 always get distinct colors.
const processRanking = computed(() => {
    const windows = weekWindows.value
    const valuesByLabel = new Map()
    for (const tx of scopeSource.value) {
        if (!tx.created_at) continue
        const t = new Date(tx.created_at).getTime()
        const wi = windows.findIndex((w) => t >= w.start.getTime() && t < w.end.getTime())
        if (wi < 0) continue
        const label = txTypeLabel(tx)
        if (!valuesByLabel.has(label)) valuesByLabel.set(label, windows.map(() => 0))
        valuesByLabel.get(label)[wi]++
    }
    return [...valuesByLabel.entries()]
        .map(([label, values]) => ({ label, values, total: values.reduce((s, v) => s + v, 0) }))
        .sort((a, b) => b.total - a.total || a.label.localeCompare(b.label))
        .map((p, idx) => ({ ...p, color: p.label === 'Unclassified' ? '#9E9E9E' : PALETTE[idx % PALETTE.length] }))
})

// Line graph filter: empty = top 5 automatically, otherwise up to 5 picked processes.
const MAX_PROCESSES = 5
const processFilter = ref([])

const processOptions = computed(() =>
    processRanking.value.map((p) => ({
        title: `${p.label} (${p.total})`,
        value: p.label,
        label: p.label,
        props: {
            disabled: processFilter.value.length >= MAX_PROCESSES && !processFilter.value.includes(p.label),
        },
    }))
)

const weeklyStack = computed(() => {
    const ranked = processRanking.value
    const picked = processFilter.value
    const shown = picked.length ? ranked.filter((p) => picked.includes(p.label)) : ranked.slice(0, MAX_PROCESSES)
    return {
        weeks: weekWindows.value.map((w) => w.label),
        series: shown.map(({ label, color, values }) => ({ label, color, values })),
    }
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
