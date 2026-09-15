<template>
    <div class="dashboard">
        <!-- Header -->
        <div class="d-flex align-center flex-wrap mb-5 ga-3">
            <div class="min-w-0">
                <h1 class="text-h5 font-weight-bold text-truncate">{{ greeting }}, {{ firstName }}</h1>
                <p class="text-body-2 text-medium-emphasis mb-0 mt-1">
                    Here's what's happening today · {{ todayLabel }}
                </p>
            </div>
            <v-spacer />
            <v-chip
                variant="tonal"
                color="primary"
                class="font-weight-bold"
                prepend-icon="mdi-inbox-outline"
            >
                {{ stats.mine }} in my queue
            </v-chip>
            <v-btn
                variant="tonal"
                color="primary"
                size="small"
                prepend-icon="mdi-arrow-right"
                @click="goToQueue"
            >
                Open queue
            </v-btn>
        </div>

        <!-- Stat cards -->
        <v-row dense>
            <v-col cols="12" md="4">
                <v-card rounded="xl" elevation="0" class="stat-card pa-1">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar rounded="lg" size="52" class="mr-4 stat-icon is-purple">
                            <v-icon color="#7C3AED" size="26">mdi-format-list-bulleted-type</v-icon>
                        </v-avatar>
                        <div class="min-w-0 flex-grow-1">
                            <div class="text-h4 font-weight-bold leading-none">{{ stats.transactionTypes }}</div>
                            <div class="text-subtitle-2 font-weight-bold mt-1">Transaction Types</div>
                            <div class="text-caption text-medium-emphasis">Active categories</div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card rounded="xl" elevation="0" class="stat-card pa-1">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar rounded="lg" size="52" class="mr-4 stat-icon is-blue">
                            <v-icon color="#0284C7" size="26">mdi-swap-horizontal</v-icon>
                        </v-avatar>
                        <div class="min-w-0 flex-grow-1">
                            <div class="text-h4 font-weight-bold leading-none">{{ stats.transactions }}</div>
                            <div class="text-subtitle-2 font-weight-bold mt-1">Transactions</div>
                            <div class="text-caption text-medium-emphasis">
                                {{ isSuperadmin ? 'All records' : 'Assigned to me' }}
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card rounded="xl" elevation="0" class="stat-card pa-1">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar rounded="lg" size="52" class="mr-4 stat-icon is-green">
                            <v-icon color="#047857" size="26">mdi-file-document-multiple</v-icon>
                        </v-avatar>
                        <div class="min-w-0 flex-grow-1">
                            <div class="text-h4 font-weight-bold leading-none">{{ stats.mine }}</div>
                            <div class="text-subtitle-2 font-weight-bold mt-1">My Transactions</div>
                            <div class="text-caption text-medium-emphasis">Awaiting my action</div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <!-- Charts + activity -->
        <v-row class="mt-4" align="stretch" dense>
            <v-col cols="12" lg="4" md="6" class="d-flex">
                <v-card rounded="xl" elevation="0" class="panel-card flex-grow-1 d-flex flex-column">
                    <v-card-title class="d-flex align-center pa-4 pb-3">
                        <v-avatar rounded="lg" size="36" class="mr-3 stat-icon is-purple">
                            <v-icon color="#7C3AED" size="20">mdi-chart-donut</v-icon>
                        </v-avatar>
                        <div class="min-w-0">
                            <div class="text-subtitle-1 font-weight-bold leading-none">Transactions by Type</div>
                            <div class="text-caption text-medium-emphasis mt-1">Distribution overview</div>
                        </div>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-4 flex-grow-1">
                        <DonutChart :items="byType" center-label="TOTAL" :size="168" :loading="loading" :updated-at="refreshedAt" />
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" lg="4" md="6" class="d-flex">
                <v-card rounded="xl" elevation="0" class="panel-card flex-grow-1 d-flex flex-column">
                    <v-card-title class="d-flex align-center pa-4 pb-3">
                        <v-avatar rounded="lg" size="36" class="mr-3 stat-icon is-blue">
                            <v-icon color="#0284C7" size="20">mdi-chart-donut-variant</v-icon>
                        </v-avatar>
                        <div class="min-w-0">
                            <div class="text-subtitle-1 font-weight-bold leading-none">My Queue by Step</div>
                            <div class="text-caption text-medium-emphasis mt-1">Where work is waiting</div>
                        </div>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-4 flex-grow-1">
                        <DonutChart :items="byStep" center-label="QUEUED" :size="168" :loading="loading" :updated-at="refreshedAt" />
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" lg="4" md="12" class="d-flex">
                <v-card rounded="xl" elevation="0" class="panel-card flex-grow-1 d-flex flex-column">
                    <v-card-title class="d-flex align-center pa-4 pb-3">
                        <v-avatar rounded="lg" size="36" class="mr-3 stat-icon is-green">
                            <v-icon color="#047857" size="20">mdi-history</v-icon>
                        </v-avatar>
                        <div class="min-w-0 flex-grow-1">
                            <div class="text-subtitle-1 font-weight-bold leading-none">Recent Activity</div>
                            <div class="text-caption text-medium-emphasis mt-1">Latest updates</div>
                        </div>
                        <v-btn
                            variant="text"
                            size="small"
                            color="primary"
                            class="text-none font-weight-bold"
                            append-icon="mdi-arrow-right"
                            @click="goToQueue"
                        >
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-2 flex-grow-1 d-flex flex-column justify-center" style="min-height: 272px">
                        <div v-if="loading" class="d-flex align-center justify-center" style="height: 272px">
                            <v-progress-circular indeterminate color="primary" size="44" width="4" />
                        </div>
                        <v-alert
                            v-else-if="!recent.length"
                            type="info"
                            variant="tonal"
                            rounded="lg"
                            class="ma-2"
                        >
                            Nothing here yet — new transactions will show up here.
                        </v-alert>
                        <v-list v-else lines="two" class="py-1 bg-transparent">
                            <v-list-item
                                v-for="tx in recent"
                                :key="tx.id"
                                rounded="lg"
                                class="recent-row mx-1"
                                @click="openTx(tx)"
                            >
                                <template v-slot:prepend>
                                    <v-avatar rounded="lg" size="36" class="stat-icon is-soft mr-1">
                                        <v-icon color="#475569" size="20">mdi-file-document-outline</v-icon>
                                    </v-avatar>
                                </template>
                                <v-list-item-title class="font-weight-bold text-truncate">
                                    {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                </v-list-item-title>
                                <v-list-item-subtitle class="text-truncate">
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
        </v-row>
    </div>
</template>

<script setup>
import { computed, reactive, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useTransactions } from '@/composables/useTransactions'
import { useMyTransactions } from '@/composables/useMyTransactions'
import DonutChart from '@/components/DonutChart.vue'
import { isCached, CacheKeys } from '@/composables/useCache'

const router = useRouter()
const auth = useAuth()

const typeStore = useTransactionTypes()
const txStore = useTransactions()
const myStore = useMyTransactions()

const stats = reactive({
    transactionTypes: 0,
    transactions: 0,
    mine: 0,
})

const loading = ref(false)
const refreshedAt = ref(null)

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? []
    return roles.some((r) => r.code === 'superadmin')
})

const firstName = computed(() => {
    const name = auth.user.value?.name?.trim()
    if (name) return name.split(/\s+/)[0]
    return auth.user.value?.email?.split('@')[0] || 'there'
})

const greeting = computed(() => {
    const h = Number(
        new Date().toLocaleTimeString('en-PH', { timeZone: 'Asia/Manila', hour: '2-digit', hour12: false }).slice(0, 2)
    )
    if (h < 12) return 'Good morning'
    if (h < 18) return 'Good afternoon'
    return 'Good evening'
})

const todayLabel = computed(() =>
    new Date().toLocaleDateString('en-PH', {
        timeZone: 'Asia/Manila',
        weekday: 'long',
        month: 'long',
        day: 'numeric',
    })
)

// Dynamic pies: recompute live whenever the stores finish loading.
const byTypeSource = computed(() =>
    isSuperadmin.value ? (txStore.items.value || []) : (myStore.items.value || [])
)

const byType = computed(() => {
    const counts = {}
    for (const tx of byTypeSource.value) {
        const label = tx.transaction_type?.name || tx.transaction_type_name || 'Unclassified'
        counts[label] = (counts[label] || 0) + 1
    }
    return Object.entries(counts).map(([label, value]) => ({
        label,
        value,
        ...(label === 'Unclassified' ? { color: '#9E9E9E' } : {}),
    }))
})

const byStep = computed(() => {
    const counts = {}
    for (const tx of (myStore.items.value || [])) {
        const label = tx.current_step?.name || tx.current_step?.code || 'Unassigned'
        counts[label] = (counts[label] || 0) + 1
    }
    return Object.entries(counts).map(([label, value]) => ({
        label,
        value,
        ...(label === 'Unassigned' ? { color: '#9E9E9E' } : {}),
    }))
})

const recent = computed(() => {
    const list = [...(byTypeSource.value || [])]
    list.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
    return list.slice(0, 4)
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
        await typeStore.fetchAll(opts)
        stats.transactionTypes = typeStore.items.value?.length || 0
    } catch { /* keep 0 */ }

    try {
        if (isSuperadmin.value) {
            await txStore.fetchAll(opts)
            stats.transactions = txStore.items.value?.length || 0
        }
    } catch { /* keep 0 */ }

    try {
        await myStore.fetchAll(opts)
        stats.mine = myStore.items.value?.length || 0
        if (!isSuperadmin.value) stats.transactions = stats.mine
    } catch { /* keep 0 */ }

    refreshedAt.value = new Date()
    loading.value = false
})

onUnmounted(() => {
    document.documentElement.classList.remove('hide-page-scroll')
})
</script>

<style scoped>
.dashboard {
    max-width: 1280px;
    margin: 0 auto;
}
.leading-none {
    line-height: 1;
}
.min-w-0 {
    min-width: 0;
}

/* Clean cards: soft border, no harsh shadow */
.stat-card,
.panel-card {
    border: 1px solid rgba(15, 23, 42, 0.08);
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
    background: rgb(var(--v-theme-surface));
    transition: box-shadow 0.18s ease, transform 0.18s ease;
}
.stat-card:hover {
    box-shadow: 0 6px 20px rgba(124, 58, 237, 0.1);
    transform: translateY(-1px);
}

/* Soft tinted icon tiles instead of flat grey */
.stat-icon {
    flex-shrink: 0;
}
.stat-icon.is-purple {
    background: #ede9fe;
}
.stat-icon.is-blue {
    background: #e0f2fe;
}
.stat-icon.is-green {
    background: #d1fae5;
}
.stat-icon.is-soft {
    background: #f1f5f9;
}

/* Recent rows: roomier, rounded, subtle hover */
.recent-row {
    cursor: pointer;
    padding-top: 6px;
    padding-bottom: 6px;
}
.recent-row:hover {
    background: #f1f5f9;
}
.recent-row :deep(.v-list-item-title) {
    font-size: 0.86rem;
    line-height: 1.3;
}
.recent-row :deep(.v-list-item-subtitle) {
    font-size: 0.74rem;
    line-height: 1.35;
}
</style>
