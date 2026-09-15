<template>
    <div>
        <div class="d-flex align-center flex-wrap mb-5">
            <div>
                <h1 class="text-h5 font-weight-bold">{{ greeting }}, {{ firstName }}</h1>
            </div>
            <v-spacer />
            <v-chip
                variant="flat"
                class="font-weight-bold"
                style="background: #f1f5f9; color: #334155"
            >
                <v-icon start color="grey-darken-3">mdi-check-circle</v-icon>
                {{ stats.mine }} in my queue
            </v-chip>
        </div>

        <v-row>
            <v-col cols="12" md="4">
                <v-card rounded="0" elevation="1" class="lgu-card pa-2">
                    <v-card-text class="d-flex align-center">
                        <v-avatar color="grey-darken-3" rounded="0" size="52" class="mr-4">
                            <v-icon color="white" size="28">mdi-format-list-bulleted-type</v-icon>
                        </v-avatar>
                        <div>
                            <div class="text-h4 font-weight-bold">{{ stats.transactionTypes }}</div>
                            <div class="text-subtitle-1 text-medium-emphasis">Transaction Types</div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card rounded="0" elevation="1" class="lgu-card pa-2">
                    <v-card-text class="d-flex align-center">
                        <v-avatar color="grey-darken-3" rounded="0" size="52" class="mr-4">
                            <v-icon color="white" size="28">mdi-swap-horizontal</v-icon>
                        </v-avatar>
                        <div>
                            <div class="text-h4 font-weight-bold">{{ stats.transactions }}</div>
                            <div class="text-subtitle-1 text-medium-emphasis">Transactions</div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" md="4">
                <v-card rounded="0" elevation="1" class="lgu-card pa-2">
                    <v-card-text class="d-flex align-center">
                        <v-avatar color="grey-darken-3" rounded="0" size="52" class="mr-4">
                            <v-icon color="white" size="28">mdi-file-document-multiple</v-icon>
                        </v-avatar>
                        <div>
                            <div class="text-h4 font-weight-bold">{{ stats.mine }}</div>
                            <div class="text-subtitle-1 text-medium-emphasis">My Transactions</div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <v-row class="mt-2" align="stretch">
            <v-col cols="12" lg="4" md="6" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
                        <v-avatar color="grey-darken-3" rounded="0" size="34" class="mr-3">
                            <v-icon color="white" size="22">mdi-chart-donut</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Transactions by Type</span>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-4">
                        <DonutChart :items="byType" center-label="TOTAL" :size="170" :loading="loading" :updated-at="refreshedAt" />
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" lg="4" md="6" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
                        <v-avatar color="grey-darken-3" rounded="0" size="34" class="mr-3">
                            <v-icon color="white" size="22">mdi-chart-donut-variant</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">My Queue by Step</span>
                    </v-card-title>
                    <v-divider />
                    <v-card-text class="pa-4">
                        <DonutChart :items="byStep" center-label="QUEUED" :size="170" :loading="loading" :updated-at="refreshedAt" />
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col cols="12" lg="4" md="12" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card" style="height: 100%; width: 100%">
                    <v-card-title class="d-flex align-center pa-4">
                        <v-avatar color="grey-darken-3" rounded="0" size="34" class="mr-3">
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
                    <v-card-text class="pa-2 d-flex flex-column justify-center" style="min-height: 272px">
                        <div v-if="loading" class="d-flex align-center justify-center" style="height: 272px">
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
</style>
