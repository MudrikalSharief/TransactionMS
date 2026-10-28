<template>
    <div>
        <div class="dash-hello">
            <div class="dash-hello-text">
                <div class="dash-hello-title">{{ greeting }}, {{ firstName }}</div>
                <div class="dash-hello-sub">
                    <v-icon size="15">mdi-calendar-today</v-icon>{{ todayLabel }}
                    <template v-if="scopeLabel"><span class="dash-hello-dot" />{{ scopeLabel }}</template>
                    <template v-if="refreshedLabel"><span class="dash-hello-dot" />Updated {{ refreshedLabel }}</template>
                </div>
            </div>
            <div class="dash-hello-actions">
                <template v-if="canSeeSummary">
                    <v-select
                        v-model="summaryPeriod"
                        :items="periodOptions"
                        label="Period"
                        prepend-inner-icon="mdi-calendar-range"
                        variant="outlined"
                        density="compact"
                        rounded="lg"
                        hide-details
                        class="dash-filter"
                    />
                    <v-select
                        v-if="isSuperadmin"
                        v-model="officeFilter"
                        :items="officeOptions"
                        label="Offices"
                        placeholder="All offices"
                        persistent-placeholder
                        prepend-inner-icon="mdi-office-building-outline"
                        variant="outlined"
                        density="compact"
                        rounded="lg"
                        hide-details
                        multiple
                        clearable
                        class="dash-filter"
                    >
                        <template v-slot:selection="{ item }">
                            <v-chip size="small" variant="tonal" class="mr-1">{{ item.raw.code }}</v-chip>
                        </template>
                    </v-select>
                </template>
                <v-btn
                    v-if="layoutChanged"
                    variant="tonal"
                    size="small"
                    color="primary"
                    rounded="pill"
                    prepend-icon="mdi-restore"
                    @click="resetLayout"
                >
                    Reset layout
                </v-btn>
            </div>
        </div>
        <!-- Cards render in the user's saved order; press-and-hold a card
             for 2s, then drag it onto another card to swap them. -->
        <v-row
            align="stretch"
            :class="{ 'dash-staff': isStaff }"
            @pointerdown="onHoldStart"
            @pointermove="onHoldMove"
            @pointerup="onHoldEnd"
            @pointercancel="onHoldCancel"
            @click.capture="onRowClickCapture"
            @contextmenu="onRowContextMenu"
        >
            <template v-for="id in cardOrder" :key="id">
                <v-col v-if="id === 'graph'" cols="12" lg="8" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">mdi-chart-bar</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">{{ scopeProcessTitle }}</span>
                            <v-spacer />
                            <v-select
                                v-model="graphPeriod"
                                :items="monthOptions"
                                label="Month"
                                prepend-inner-icon="mdi-calendar-blank-outline"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                hide-details
                                class="process-filter mr-2"
                            />
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
                                :empty-text="graphEmptyText"
                                :aria-label="graphAriaLabel"
                            />
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'start'" cols="12" :lg="isStaff ? 4 : 12" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card v-if="!isStaff" rounded="0" elevation="1" class="lgu-card dash-panel start-hero" style="width: 100%">
                        <div class="start-hero-intro">
                            <v-icon class="start-hero-rocket" size="40">mdi-rocket-launch</v-icon>
                            <div>
                                <div class="start-hero-title">Get Started</div>
                                <div class="start-hero-sub">Quick access to the most important tools and resources.</div>
                            </div>
                        </div>
                        <div class="start-hero-links">
                            <div
                                v-for="link in startLinks"
                                :key="link.title"
                                class="start-tile"
                                role="button"
                                tabindex="0"
                                @click="link.go"
                                @keydown.enter.prevent="link.go"
                            >
                                <div class="start-tile-icon" :style="{ background: link.tile }">
                                    <v-icon color="white" size="22">{{ link.icon }}</v-icon>
                                </div>
                                <div class="flex-grow-1" style="min-width: 0">
                                    <div class="start-tile-title">{{ link.title }}</div>
                                    <div class="start-tile-sub text-truncate">{{ link.subtitle }}</div>
                                </div>
                                <v-icon size="small" color="primary">mdi-chevron-right</v-icon>
                            </div>
                        </div>
                    </v-card>
                    <v-card v-else rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">mdi-rocket-launch-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Get Started</span>
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-0 d-flex" :class="isStaff ? 'flex-column' : 'start-wide'" style="flex: 1 1 auto">
                            <div
                                v-for="link in startLinks"
                                :key="link.title"
                                class="start-row d-flex align-center px-4"
                                style="flex: 1 1 0"
                                @click="link.go"
                            >
                                <v-avatar :color="link.color" rounded="lg" size="38" class="mr-3">
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
                    <v-card rounded="0" elevation="0" class="summary-bare">
                        <v-alert v-if="summaryError" type="error" variant="tonal" density="compact" class="mb-3">
                            {{ summaryError }}
                        </v-alert>
                        <div class="summary-tiles" :class="{ 'summary-stale': summaryLoading && summary }">
                            <StatCard
                                v-for="tile in summaryTiles"
                                :key="tile.key"
                                :ref="(el) => (tileEls[tile.key] = el?.$el ?? null)"
                                :label="tile.label"
                                :value="tile.value"
                                :hint="tile.hint"
                                :variant="tile.variant"
                                :icon="tile.icon"
                                :loading="summaryLoading && !summary"
                                cta="Show list"
                                @activate="openDetail(tile.key, tileEls[tile.key])"
                            >
                                <SummaryPopover
                                    :category="tile.key"
                                    :query="summaryQuery"
                                    :period-label="summaryScopeText"
                                    :disabled="!summary"
                                    @expand="openDetail(tile.key, tileEls[tile.key])"
                                />
                            </StatCard>
                        </div>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'byprocess'" cols="12" lg="4" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">mdi-format-list-bulleted-type</v-icon>
                            </v-avatar>
                            <div style="min-width: 0">
                                <div class="text-subtitle-1 font-weight-bold">By Process</div>
                                <div class="dash-panel-sub text-truncate">{{ summaryScopeText }}</div>
                            </div>
                            <v-spacer />
                            <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="goToQueue">
                                View all
                            </v-btn>
                        </v-card-title>
                        <v-card-text class="pa-4 process-bars" :class="{ 'summary-stale': summaryLoading && summary }">
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
                                <div class="bp-icon" :style="{ background: processColor(row.name) }">
                                    <v-icon color="white" size="20">{{ processIcon(row.name) }}</v-icon>
                                </div>
                                <div class="bp-main">
                                    <div class="process-bar-name text-truncate" :title="row.name">{{ row.name }}</div>
                                    <div class="process-bar-track">
                                        <div class="process-bar-fill" :style="{ width: row.pct + '%', background: processBarColor }" />
                                    </div>
                                </div>
                                <div class="process-bar-count">{{ row.count }}</div>
                            </div>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'recent'" cols="12" :lg="isStaff ? 8 : 4" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">mdi-history</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">Recent Activity</span>
                            <v-spacer />
                            <v-btn
                                variant="text"
                                size="small"
                                color="primary"
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
                                        <div class="row-icon" :style="tintStyle(txProcessName(tx))">
                                            <v-icon size="20">mdi-file-document-outline</v-icon>
                                        </div>
                                    </template>
                                    <v-list-item-title class="font-weight-bold">
                                        {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                    </v-list-item-title>
                                    <v-list-item-subtitle>{{ txSubtitle(tx) }}</v-list-item-subtitle>
                                    <template v-slot:append>
                                        <span class="row-time">{{ timeAgo(tx.created_at) }}</span>
                                        <v-icon size="small" color="primary">mdi-chevron-right</v-icon>
                                    </template>
                                </v-list-item>
                            </v-list>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'action'" cols="12" lg="8" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">{{ isSuperadmin ? 'mdi-account-clock-outline' : 'mdi-tray-full' }}</v-icon>
                            </v-avatar>
                            <div>
                                <div class="text-subtitle-1 font-weight-bold">Needs My Action</div>
                                <div v-if="isSuperadmin" class="dash-panel-sub">Accounts waiting for approval</div>
                            </div>
                            <v-spacer />
                            <v-btn
                                variant="text"
                                size="small"
                                color="primary"
                                append-icon="mdi-arrow-right"
                                @click="isSuperadmin ? goToAccounts() : goToQueue()"
                            >
                                {{ isSuperadmin ? 'All accounts' : 'My queue' }}
                            </v-btn>
                        </v-card-title>
                        <v-divider />
                        <!-- Superadmin: new sign-ups to approve or reject. -->
                        <v-card-text v-if="isSuperadmin" class="pa-0">
                            <div v-if="accountsLoading && !pendingAccounts.length" class="d-flex align-center justify-center" style="height: 200px">
                                <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
                            </div>
                            <v-alert v-if="accountError" type="error" variant="tonal" rounded="0" density="compact" class="ma-4">
                                {{ accountError }}
                            </v-alert>
                            <v-alert
                                v-if="!accountsLoading && !pendingAccounts.length"
                                type="success"
                                variant="tonal"
                                rounded="0"
                                class="ma-4"
                            >
                                All clear — no accounts waiting for approval.
                            </v-alert>
                            <v-table v-else-if="pendingAccounts.length" class="action-table">
                                <thead>
                                    <tr>
                                        <th class="text-left">Account</th>
                                        <th class="text-left">Office · Role</th>
                                        <th class="text-left">Requested</th>
                                        <th class="text-right">Approve / Reject</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="u in pendingAccounts" :key="u.id">
                                        <td>
                                            <div class="d-flex align-center ga-3">
                                                <div class="row-icon account-icon">
                                                    <v-icon size="20">mdi-account-outline</v-icon>
                                                </div>
                                                <div style="min-width: 0">
                                                    <div class="font-weight-bold action-title">{{ u.name }}</div>
                                                    <div class="text-caption text-medium-emphasis">{{ u.email }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-body-2">{{ accountScope(u) }}</td>
                                        <td class="font-weight-bold">{{ timeAgo(u.created_at) }}</td>
                                        <td class="text-right">
                                            <div class="d-inline-flex ga-2">
                                                <v-btn
                                                    icon="mdi-check"
                                                    size="small"
                                                    variant="tonal"
                                                    color="success"
                                                    rounded="0"
                                                    v-tooltip="'Approve: let this person sign in'"
                                                    :aria-label="`Approve ${u.name}`"
                                                    :loading="accountBusyId === u.id"
                                                    :disabled="accountBusyId != null && accountBusyId !== u.id"
                                                    @click="approveAccount(u)"
                                                />
                                                <v-btn
                                                    icon="mdi-close"
                                                    size="small"
                                                    variant="tonal"
                                                    color="error"
                                                    rounded="0"
                                                    v-tooltip="'Reject: remove this request'"
                                                    :aria-label="`Reject ${u.name}`"
                                                    :disabled="accountBusyId != null"
                                                    @click="rejectAccount(u)"
                                                />
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-card-text>
                        <v-card-text v-else class="pa-0">
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
                            <v-table v-else class="action-table">
                                <thead>
                                    <tr>
                                        <th class="text-left">Transaction</th>
                                        <th class="text-left">Current Step</th>
                                        <th class="text-left">Waiting</th>
                                        <th style="width: 40px" />
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
                                            <div class="d-flex align-center ga-3">
                                                <div class="row-icon" :style="tintStyle(txProcessName(tx))">
                                                    <v-icon size="20">{{ processIcon(txProcessName(tx)) }}</v-icon>
                                                </div>
                                                <div style="min-width: 0">
                                                    <div class="font-weight-bold action-title">
                                                        {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                                    </div>
                                                    <div class="text-caption text-medium-emphasis">
                                                        {{ txSubtitle(tx) }}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="step-pill" :style="tintStyle(txProcessName(tx))">
                                                {{ tx.current_step?.name || tx.current_step?.code || 'Unassigned' }}
                                            </span>
                                        </td>
                                        <td
                                            class="font-weight-bold"
                                            :class="{ 'waiting-late': isPastLimit(tx) }"
                                            :title="isPastLimit(tx) ? 'Past this station’s time limit' : undefined"
                                        >
                                            {{ timeAgo(tx.entered_at || tx.created_at) }}
                                        </td>
                                        <td class="text-right"><v-icon size="small" color="primary">mdi-chevron-right</v-icon></td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </v-card-text>
                    </v-card>
                </v-col>
                <v-col v-else-if="id === 'intransit'" cols="12" lg="4" class="d-flex dash-col" :class="cardClass(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center pa-4 lgu-head">
                            <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                <v-icon color="#005EED" size="24">mdi-truck-fast-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold">In Transit</span>
                            <v-spacer />
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-2">
                            <div v-if="loading" class="d-flex align-center justify-center" style="height: 200px">
                                <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
                            </div>
                            <v-alert
                                v-else-if="!inTransit.length"
                                type="info"
                                variant="tonal"
                                rounded="0"
                                class="ma-2"
                            >
                                Nothing in transit — everything your office owns is with you.
                            </v-alert>
                            <v-list v-else lines="two" class="py-0">
                                <v-list-item
                                    v-for="tx in inTransit"
                                    :key="tx.id"
                                    rounded="0"
                                    class="recent-row"
                                    @click="openTx(tx)"
                                >
                                    <template v-slot:prepend>
                                        <div class="row-icon" :style="tintStyle(txProcessName(tx))">
                                            <v-icon size="20">mdi-truck-fast-outline</v-icon>
                                        </div>
                                    </template>
                                    <v-list-item-title class="font-weight-bold">
                                        {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                    </v-list-item-title>
                                    <v-list-item-subtitle>{{ transitSubtitle(tx) }}</v-list-item-subtitle>
                                    <template v-slot:append>
                                        <span class="row-time">{{ timeAgo(tx.entered_at || tx.created_at) }}</span>
                                        <v-icon size="small" color="primary">mdi-chevron-right</v-icon>
                                    </template>
                                </v-list-item>
                            </v-list>
                        </v-card-text>
                    </v-card>
                </v-col>
            </template>
        </v-row>
        <SummaryDetailDialog
            v-if="canSeeSummary"
            v-model:open="detail.open"
            :category="detail.category"
            :process-id="detail.processId"
            :process-name="detail.processName"
            :origin-el="detail.originEl"
            :query="summaryQuery"
            :period-label="summary?.period?.label || 'All time'"
            :scope-chips="officeScopeChips"
        />
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTheme } from 'vuetify'
import { useAuth, isOfficeAdminUser } from '@/composables/useAuth'
import { summaryApiBase } from '@/composables/useSummaryRows'
import { useApi } from '@/composables/useApi'
import { useTransactions } from '@/composables/useTransactions'
import { useTransactionTypes } from '@/composables/useTransactionTypes'
import { useOffices } from '@/composables/useOffices'
import { useDashboardLayout } from '@/composables/useDashboardLayout'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { confirm } from '@/composables/useConfirm'
import { useSmartPoll } from '@/composables/useSmartPoll'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import SummaryDetailDialog from '@/components/SummaryDetailDialog.vue'
import SummaryPopover from '@/components/SummaryPopover.vue'
import StatCard from '@/components/StatCard.vue'
import { processColor, processIcon, txProcessName, isPastLimit } from '@/utils/processColor'
import { isCached, readCache, writeCache, CacheKeys, scopedKey, storedUserId } from '@/composables/useCache'

const router = useRouter()
const auth = useAuth()
const { api } = useApi()

const txStore = useTransactions()
const typeStore = useTransactionTypes()
const officeStore = useOffices()

const loading = ref(false)
const refreshedAt = ref(null)

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? []
    return roles.some((r) => r.code === 'superadmin')
})

// Office admins get the Transaction Summary for their own office's scope.
const isOfficeAdmin = computed(() => isOfficeAdminUser(auth.user.value))
const canSeeSummary = computed(() => isSuperadmin.value || isOfficeAdmin.value)

// Standard users (role-based staff) get an action-first dashboard: no
// analytics, queue tightened to what is actually waiting on them, and an
// in-transit card showing where their office's papers currently sit.
const isStaff = computed(() => !canSeeSummary.value)

// ---- Greeting strip ----
const greeting = computed(() => {
    const h = new Date().getHours()
    return h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening'
})
const firstName = computed(() => (auth.user.value?.name || '').trim().split(/\s+/)[0] || 'there')
const todayLabel = new Date().toLocaleDateString('en-PH', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' })
const scopeLabel = computed(() => {
    const u = auth.user.value
    if (isSuperadmin.value) return 'All offices'
    return u?.office?.name || u?.office?.code || ''
})
const refreshedLabel = computed(() =>
    refreshedAt.value ? refreshedAt.value.toLocaleTimeString('en-PH', { hour: 'numeric', minute: '2-digit' }) : '',
)

// ---- Movable cards: press and hold a card for 2s, then drag it onto
// another card to take its place ----
// Default order; Transaction Summary is superadmin / office admin only,
// and the staff layout swaps the graph + Get Started hero for the queue.
const cardIds = computed(() => {
    if (canSeeSummary.value) {
        return ['summary', 'graph', 'byprocess', 'action', 'recent', 'start']
    }
    return ['action', 'intransit', 'recent', 'start']
})
const {
    order: cardOrder,
    changed: layoutChanged,
    move: moveCard,
    reset: resetLayout,
} = useDashboardLayout(computed(() => auth.user.value?.id), cardIds)

const HOLD_MS = 2000
const HOLD_TOLERANCE_PX = 10

const dragId = ref(null)
const overId = ref(null)
let holdTimer = null
let holdStart = null
let suppressClick = false

// The card column an event happened in (pointer events can target text nodes).
function cardAt(e) {
    const el = e.target.nodeType === 1 ? e.target : e.target.parentElement
    return el?.closest('[data-card]') ?? null
}

// Presses that start on controls keep their normal behavior and never arm a move.
function onInteractiveTarget(e) {
    return !!e.target.closest?.(
        'button, a, input, select, textarea, [role="button"], [role="link"], [role="option"], ' +
        '.v-field, .v-btn, .v-list-item, .v-overlay, .v-menu, .v-select'
    )
}

function cardClass(id) {
    return { 'dash-dragging': dragId.value === id, 'dash-drop-target': overId.value === id && dragId.value !== id }
}

function clearHoldTimer() {
    if (holdTimer) {
        clearTimeout(holdTimer)
        holdTimer = null
    }
    holdStart = null
}

function armCard(id) {
    holdTimer = null
    holdStart = null
    dragId.value = id
    try {
        navigator.vibrate?.(40)
    } catch { /* haptics unsupported: visual cue is enough */ }
}

function onHoldStart(e) {
    if (!e.isPrimary) return
    if (e.pointerType === 'mouse' && e.button !== 0) return
    if (dragId.value || onInteractiveTarget(e)) return
    const col = cardAt(e)
    if (!col) return
    const id = col.dataset.card
    holdStart = { x: e.clientX, y: e.clientY, id }
    clearTimeout(holdTimer)
    holdTimer = setTimeout(() => armCard(id), HOLD_MS)
}

function onHoldMove(e) {
    if (dragId.value) {
        // Armed: track the drop target under the pointer (works for mouse + touch).
        const el = document.elementFromPoint(e.clientX, e.clientY)
        const col = el?.closest?.('[data-card]')
        const id = col?.dataset.card ?? null
        overId.value = id && id !== dragId.value ? id : null
        return
    }
    if (!holdStart) return
    // Finger/mouse wandered before the hold completed: not a hold, stand down.
    if (Math.hypot(e.clientX - holdStart.x, e.clientY - holdStart.y) > HOLD_TOLERANCE_PX) {
        clearHoldTimer()
    }
}

function endHold() {
    clearHoldTimer()
    dragId.value = null
    overId.value = null
}

function onHoldEnd() {
    if (dragId.value) {
        // A hold happened: drop onto the tracked card, then swallow the
        // click the pointer release would otherwise trigger.
        if (overId.value) moveCard(dragId.value, overId.value)
        suppressClick = true
    }
    endHold()
}

function onHoldCancel() {
    endHold()
}

function onRowClickCapture(e) {
    if (!suppressClick) return
    suppressClick = false
    e.preventDefault()
    e.stopPropagation()
}

// Long-press on touch fires a context menu; not while a card is armed.
function onRowContextMenu(e) {
    if (dragId.value || holdStart) e.preventDefault()
}

function onEscapeWhileArmed(e) {
    if (e.key === 'Escape' && dragId.value) endHold()
}

onMounted(() => {
    window.addEventListener('keydown', onEscapeWhileArmed)
})

onUnmounted(() => {
    window.removeEventListener('keydown', onEscapeWhileArmed)
})

// Scope: the Transactions endpoint already narrows rows per user; superadmins
// see everything while regular users see their office/role queue.
const scopeSource = computed(() => txStore.items.value || [])

// Series colors: validated categorical palette (dataviz reference
// palette, adjacent-pair safe in both modes), light and dark steps.
// Gray is reserved for the folded "Other processes" bar.
const SERIES_PALETTE = {
    light: ['#005EED', '#F26B21', '#1A1F2B', '#FFA94D', '#4D94FF', '#B84A0F', '#8FBBFF'],
    dark: ['#4D94FF', '#FF8A4C', '#B9D4FF', '#FFB27A', '#1F6FFF', '#D9622B', '#8FBBFF'],
}
const OTHER_PROCESSES = 'Other processes'
const OTHER_COLOR = { light: '#898781', dark: '#898781' }
const MAX_PROCESS_BARS = SERIES_PALETTE.light.length

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

// Scope: the account's office when one is assigned, otherwise everything
// visible to the user (superadmins are usually unassigned, so all offices).
// Labels always state the scope, so the numbers are never ambiguous.
const myOffice = computed(() => auth.user.value?.office ?? null)
const scopeCode = computed(() => myOffice.value?.code?.toUpperCase() ?? null)

const officeFilter = ref([])
const officeById = computed(() => new Map((officeStore.items.value || []).map((o) => [o.id, o])))
const officeIds = computed(() => new Set(officeFilter.value || []))
const officeOptions = computed(() =>
    [...(officeStore.items.value || [])]
        .sort((a, b) => String(a.name).localeCompare(String(b.name)))
        .map((o) => ({ title: o.code ? `${o.name} (${o.code})` : o.name, value: o.id, code: o.code || o.name }))
)
const officeScopeChips = computed(() =>
    officeFilter.value
        .map((id) => officeById.value.get(id)?.code?.toUpperCase())
        .filter(Boolean)
)
const officeScopeLabel = computed(() => {
    if (!officeScopeChips.value.length) return scopeCode.value
    return officeScopeChips.value.length <= 2
        ? officeScopeChips.value.join('/')
        : `${officeScopeChips.value.length} offices`
})
const scopeProcessTitle = computed(() =>
    officeScopeLabel.value ? `${officeScopeLabel.value} Transactions per Process` : 'All Transactions per Process'
)

function inOfficeScope(tx) {
    if (officeIds.value.size) return officeIds.value.has(tx.office?.id)
    return !scopeCode.value || tx.office?.code?.toUpperCase() === scopeCode.value
}

watch(officeOptions, (options) => {
    const ids = new Set(options.map((o) => o.value))
    if (officeFilter.value?.some((id) => !ids.has(id))) {
        officeFilter.value = officeFilter.value.filter((id) => ids.has(id))
    }
})

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

const graphEmptyText = computed(() =>
    officeScopeLabel.value
        ? `No ${officeScopeLabel.value} transactions in ${graphPeriodLabel.value}`
        : `No transactions in ${graphPeriodLabel.value}`
)
const graphAriaLabel = computed(() =>
    officeScopeLabel.value
        ? `${officeScopeLabel.value} transactions per process per week, ${graphPeriodLabel.value}`
        : `Transactions per process per week, ${graphPeriodLabel.value}`
)

function weekIndexOf(tx) {
    if (!tx.created_at) return -1
    const t = new Date(tx.created_at).getTime()
    return weekWindows.value.findIndex((w) => t >= w.start.getTime() && t < w.end.getTime())
}

function txTypeLabel(tx) {
    return tx.transaction_type?.name || tx.transaction_type_name
}

// Visible transactions created in the chosen month (own office, if assigned,
// or the offices picked by a superadmin).
const graphTx = computed(() =>
    scopeSource.value.filter((tx) => inOfficeScope(tx) && weekIndexOf(tx) >= 0)
)

// Per-process weekly counts, busiest process first.
const processRanking = computed(() => {
    const byName = new Map()
    for (const tx of graphTx.value) {
        const name = txTypeLabel(tx)
        if (!name) continue
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

// Every active process in the system. The lookup is an admin endpoint, so
// other users only get the processes found in their own transactions.
const systemProcessNames = computed(() =>
    isSuperadmin.value
        ? (typeStore.items.value || []).filter((t) => t.is_active !== false && t.name).map((t) => t.name)
        : []
)

// Options: every process, with its count for the month (0 when it has none),
// busiest first.
const processOptions = computed(() => {
    const totals = new Map(processRanking.value.map((p) => [p.label, p.total]))
    for (const name of systemProcessNames.value) if (!totals.has(name)) totals.set(name, 0)
    return [...totals.entries()]
        .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
        .map(([label, total]) => ({ title: `${label} (${total})`, value: label }))
})

// Drop picks that are no longer offered.
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
// Period: all time by default so pending work never hides on a week/month
// rollover; switchable to this week (current Mon–Sun week) or one of the
// last 12 months (Manila calendar).
// Completed counts by finalize date, the rest by created date (server side).
const summaryPeriod = ref('all')
const periodOptions = computed(() => [
    { title: 'All time', value: 'all' },
    { title: 'This week', value: 'this_week' },
    ...monthOptions.value,
])

const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// Same scope as the graph, but independent of the graph's Month and
// Process filters. No office assigned: the backend aggregates all offices.
// Office admins send no office: the server forces their office's full scope
// (filed by it or passing through it), which an office_code would narrow.
const summaryQuery = computed(() => ({
    month: summaryPeriod.value === 'this_week' ? undefined : summaryPeriod.value,
    ...(isSuperadmin.value && scopeCode.value ? { office_code: scopeCode.value } : {}),
    ...(officeFilter.value?.length ? { offices: [...officeFilter.value].sort((a, b) => a - b) } : {}),
}))

let summaryRequest = 0
async function loadSummary() {
    if (!canSeeSummary.value) return
    const mine = ++summaryRequest
    // Instant illusion: last summary for this period/office paints at once
    // (template already dims stale tiles via .summary-stale), then the
    // network refreshes silently. Spinner only shows with zero cached data.
    const cacheKey = scopedKey(`${CacheKeys.summary}:${JSON.stringify(summaryQuery.value)}`, auth.user.value?.id)
    const cached = readCache(cacheKey)
    if (cached != null && mine === summaryRequest) summary.value = cached
    const quiet = cached != null
    if (!quiet) summaryLoading.value = true
    summaryError.value = ''
    try {
        const res = await api.get(summaryApiBase(), { params: summaryQuery.value })
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
    () => summary.value?.period?.label || periodOptions.value.find((o) => o.value === summaryPeriod.value)?.title || 'All time',
)

// Status tiles: each card takes its color and illustration from its variant.
const summaryTiles = computed(() => {
    const s = summary.value || {}
    return [
        { key: 'completed', label: 'Completed', icon: 'mdi-check-bold', variant: 'success', value: s.completed ?? '—', hint: 'Finalized in this period' },
        { key: 'in_process', label: 'In-process', icon: 'mdi-timer-sand', variant: 'warning', value: s.in_process ?? '—', hint: 'Created in this period, still open' },
        { key: 'overdue', label: 'Overdue', icon: 'mdi-alert', variant: 'danger', value: s.overdue ?? '—', hint: 'Open and past their station’s time limit' },
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
// Admins keep the office/system queue; staff only see rows the server
// flags as waiting on them (same gate the write endpoints enforce), so
// the queue never lists a paper parked at another office.
const actionQueue = computed(() => {
    const base = [...(txStore.items.value || [])].filter(
        (tx) => !isStaff.value || tx.needs_action,
    )
    base.sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0))
    return base.slice(0, 5)
})

// Staff only: the office's own papers currently parked at another office
// (not waiting on this user), longest-waiting first.
const inTransit = computed(() => {
    const myOfficeId = myOffice.value?.id ?? null
    if (myOfficeId == null) return []
    const list = (scopeSource.value || []).filter(
        (tx) =>
            !tx.is_done &&
            !tx.needs_action &&
            Number(tx.office?.id) === Number(myOfficeId) &&
            tx.current_step?.office_id != null &&
            Number(tx.current_step.office_id) !== Number(myOfficeId),
    )
    list.sort((a, b) => new Date(a.entered_at || a.created_at || 0) - new Date(b.entered_at || b.created_at || 0))
    return list.slice(0, 5)
})
const inTransitIds = computed(() => new Set(inTransit.value.map((tx) => tx.id)))

const recent = computed(() => {
    const source = scopeSource.value || []
    const list = officeIds.value.size
        ? source.filter((tx) => officeIds.value.has(tx.office?.id))
        : [...source]
    // Staff: the feed holds the rest — never duplicates the queue or the
    // in-transit card.
    const feed = isStaff.value
        ? list.filter((tx) => !tx.needs_action && !inTransitIds.value.has(tx.id))
        : list
    feed.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
    return feed.slice(0, 4)
})

// Evenly-distributed shortcut rows that always fill the Get Started card.
const startLinks = computed(() => {
    // Staff with papers already have a queue shortcut in Needs My Action;
    // Get Started shrinks to Help. The full card is the empty state.
    if (isStaff.value && scopeSource.value.length) {
        return [
            { title: 'Help guide', subtitle: 'Step-by-step instructions', icon: 'mdi-book-open-outline', color: '#005EED', tile: '#0B2B66', go: goToHelp },
        ]
    }
    const links = [
        { title: 'Help guide', subtitle: 'Step-by-step instructions', icon: 'mdi-book-open-outline', color: '#005EED', tile: '#0B2B66', go: goToHelp },
        isSuperadmin.value
            ? { title: 'Transactions', subtitle: 'All requests in the system', icon: 'mdi-tray-full', color: '#005EED', tile: '#0EA5A4', go: goToQueue }
            : isOfficeAdmin.value
              ? { title: 'Office transactions', subtitle: 'Filed by or passing through your office', icon: 'mdi-tray-full', color: '#005EED', tile: '#0EA5A4', go: goToQueue }
              : { title: 'My queue', subtitle: 'Continue where you left off', icon: 'mdi-tray-full', color: '#005EED', tile: '#0EA5A4', go: goToQueue },
    ]
    if (isOfficeAdmin.value) {
        links.push({
            title: 'Office users',
            subtitle: 'People and roles in your office',
            icon: 'mdi-account-group',
            color: '#005EED',
            tile: '#8B5CF6',
            go: () => router.push('/office/users'),
        })
    }
    if (isSuperadmin.value) {
        links.push({
            title: 'Manage offices',
            subtitle: 'Offices, steps, and assignments',
            icon: 'mdi-office-building-outline',
            color: '#005EED',
            tile: '#8B5CF6',
            go: () => router.push('/admin/offices'),
        })
    }
    return links
})

// Tinted chip/icon in the process's color (same color on every card).
function tintStyle(name) {
    const c = processColor(name)
    return { color: c, background: `color-mix(in srgb, ${c} 14%, transparent)` }
}

function txSubtitle(tx) {
    return [tx.reference_number, tx.transaction_type?.name || tx.transaction_type_name]
        .filter(Boolean)
        .join(' · ') || tx.current_step?.name || ''
}

// In Transit rows: where the paper sits now (station + office).
function transitSubtitle(tx) {
    const step = tx.current_step?.name || tx.current_step?.code
    const office = tx.current_step?.office?.code || tx.current_step?.office?.name
    return [step, office].filter(Boolean).join(' · ') || 'With another office'
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
    router.push(`/transactions/${tx.id}`)
}

function goToQueue() {
    router.push('/transactions')
}

// ---- Superadmin: accounts waiting for approval (Needs My Action) ----
const accountStore = useAdminUsers()
const accountsLoading = computed(() => accountStore.loading.value)
const accountBusyId = ref(null)
const accountError = ref('')

// Oldest request first, same as the transaction queue.
const pendingAccounts = computed(() =>
    (accountStore.users.value || [])
        .filter((u) => u.pending_approval)
        .sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0)),
)

function accountScope(u) {
    const office = u.office?.code || u.office?.name
    const roles = (u.roles || []).map((r) => r.name || r.code).join(', ')
    return [office, roles].filter(Boolean).join(' · ') || '—'
}

function loadAccounts(opts = {}) {
    if (!isSuperadmin.value) return
    return accountStore.fetchUsers(opts).catch(() => {})
}

async function approveAccount(u) {
    accountError.value = ''
    accountBusyId.value = u.id
    try {
        await accountStore.approveUser(u.id)
        await loadAccounts({ silent: true })
    } catch (e) {
        accountError.value = e?.response?.data?.message || 'Approve failed.'
    } finally {
        accountBusyId.value = null
    }
}

// Same wording as the Users page.
async function rejectAccount(u) {
    const ok = await confirm({
        title: 'Reject this request?',
        message: `${u.name} (${u.email}) will not get access, and the request will be removed. They can sign up again.`,
        confirmLabel: 'Reject',
        cancelLabel: 'Keep',
    })
    if (!ok) return
    accountError.value = ''
    accountBusyId.value = u.id
    try {
        await accountStore.rejectUser(u.id)
        await loadAccounts({ silent: true })
    } catch (e) {
        accountError.value = e?.response?.data?.message || 'Reject failed.'
    } finally {
        accountBusyId.value = null
    }
}

function goToAccounts() {
    router.push('/admin/users')
}

function goToHelp() {
    router.push('/help')
}

onMounted(async () => {
    // Dashboard only: hide the page scrollbar (restored on leave).
    document.documentElement.classList.add('hide-page-scroll')

    // Instant paint from cache when available; the fetches below
    // then refresh everything silently in the background. List caches
    // are per-user; check the current user's slot.
    const uid = auth.user.value?.id ?? storedUserId()
    const warm =
        isCached(CacheKeys.transactionTypes) ||
        isCached(scopedKey(CacheKeys.transactions, uid))
    loading.value = !warm
    const opts = { silent: warm }
    loadSummary()
    // Process/office filter options; cached, so these never hold up the page.
    if (isSuperadmin.value) {
        typeStore.fetchAll({ silent: true }).catch(() => {})
        officeStore.fetchAll({ silent: true }).catch(() => {})
        loadAccounts()
    }

    try {
        await txStore.fetchAll(opts)
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
        // Everyone reads the shared Transactions list now (My Transactions
        // was retired); the summary is for superadmins and office admins.
        await txStore.fetchAll(opts)
        if (canSeeSummary.value) loadSummary()
        loadAccounts({ silent: true })
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
/* ---- Greeting strip ---- */
.dash-hello {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
    margin: 0 0 14px;
}
.dash-hello-title {
    font-size: 1.45rem;
    font-weight: 800;
    line-height: 1.2;
    color: rgb(var(--v-theme-on-surface));
}
.dash-hello-sub {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    margin-top: 2px;
    font-size: 0.85rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.dash-hello-dot {
    width: 4px;
    height: 4px;
    border-radius: 50%;
    background: currentColor;
    opacity: 0.6;
    margin: 0 4px;
}

/* ---- Movable cards (press and hold 2s, then drag) ---- */
/* Each card keeps its width but grows to fill its row, so no order leaves a gap. */
.dash-col {
    flex-grow: 1;
    max-width: 100%;
}
/* Staff layout: the two rows stretch to fill the viewport instead of
   hugging the top and leaving dead space below (desktop only; on small
   screens the cards stack and size to content). */
@media (min-width: 1280px) {
    .dash-staff {
        align-content: stretch;
        min-height: calc(100vh - 190px);
    }
}
/* Keep Get Started shortcut rows at their natural height so a single
   row doesn't balloon to fill the taller card; content stays top-aligned. */
.dash-staff [data-card='start'] /* ---- Row icons, step pills, waiting ---- */
.row-icon {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 38px;
    height: 38px;
    border-radius: 10px;
    margin-right: 12px;
}
.action-table .row-icon {
    margin-right: 0;
}
.row-icon .v-icon {
    color: inherit;
}
.account-icon {
    color: #005EED;
    background: color-mix(in srgb, #005EED 14%, transparent);
}
.row-time {
    font-size: 0.75rem;
    white-space: nowrap;
    margin-right: 10px;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.step-pill {
    display: inline-block;
    max-width: 260px;
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 0.78rem;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    vertical-align: middle;
}
.waiting-late {
    color: #e5383b;
}
/* ---- Get Started hero strip (admin layout) ---- */
.start-hero {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 18px;
    padding: 20px 24px;
    background: linear-gradient(100deg, #eaf2ff 0%, #f4f8ff 55%, #e2edff 100%) !important;
}
.start-hero-intro {
    display: flex;
    align-items: center;
    gap: 16px;
    flex: 1 1 280px;
    min-width: 0;
}
.start-hero-rocket {
    color: rgb(var(--v-theme-primary));
    transform: rotate(-12deg);
}
.start-hero-title {
    font-size: 1.3rem;
    font-weight: 800;
    color: rgb(var(--v-theme-on-surface));
}
.start-hero-sub {
    font-size: 0.85rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.start-hero-links {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 14px;
    flex: 3 1 640px;
    min-width: 0;
}
.start-tile {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 16px;
    border-radius: 12px;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 6px 16px -12px rgba(15, 23, 42, 0.35);
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
}
.start-tile:hover,
.start-tile:focus-visible {
    transform: translateY(-2px);
    box-shadow: 0 12px 22px -14px rgba(0, 94, 237, 0.55);
    outline: none;
}
.start-tile-icon {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 44px;
    height: 44px;
    border-radius: 12px;
}
.start-tile-title {
    font-size: 0.9rem;
    font-weight: 800;
    color: rgb(var(--v-theme-on-surface));
}
.start-tile-sub {
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.start-row {
    flex: 0 0 auto !important;
}
/* Armed card: lifted, grabbing cursor, frozen scroll/selection while moving. */
.dash-dragging {
    cursor: grabbing;
}
.dash-dragging > .v-card {
    box-shadow: 0 16px 36px rgba(0, 94, 237, 0.35);
    outline: 2px solid rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.dash-dragging,
.dash-dragging * {
    user-select: none;
    -webkit-user-select: none;
    touch-action: none;
}
.dash-drop-target > .v-card {
    outline: 2px dashed rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.recent-row {
    cursor: pointer;
}
.recent-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
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
    --v-table-header-height: 44px;
}
.action-row {
    cursor: pointer;
}
.action-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
}
.action-title {
    font-size: 0.9rem;
    line-height: 1.35;
    margin-bottom: 2px;
}
.action-table :deep(th) {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
    padding-bottom: 10px;
}
.action-table :deep(td) {
    padding-top: 12px;
    padding-bottom: 12px;
    vertical-align: middle;
}
.action-table :deep(tbody tr:not(:last-child) td) {
    border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.action-table :deep(td:last-child) {
    white-space: nowrap;
}
.process-filter {
    flex: 0 1 240px;
    min-width: 160px;
}
/* ---- Transaction Summary card ---- */
.summary-tiles {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 16px;
}
.summary-bare {
    background: transparent !important;
    box-shadow: none !important;
}
.dash-hello-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
}
/* Explicit width too: Firefox sizes the wrapping row from the select's
   content, not its flex-basis, and stacked the two filters. */
.dash-filter {
    flex: 0 0 200px;
    width: 200px;
    min-width: 170px;
}
.dash-panel-sub {
    font-size: 0.75rem;
    font-weight: 400;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
/* By Process card: one column of bars, scrolls when there are many */
.process-bars {
    display: flex;
    flex-direction: column;
    gap: 4px;
    flex: 1 1 auto;
    max-height: 300px;
    overflow-y: auto;
}
/* Get Started as a horizontal strip of shortcuts (admin layout) */
.start-wide {
    flex-direction: row;
    flex-wrap: wrap;
}
.start-wide .start-row {
    flex: 1 1 260px !important;
    min-height: 72px;
}
.start-wide .start-row + .start-row {
    border-top: none;
    border-left: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
@media (max-width: 960px) {
    .start-wide .start-row + .start-row {
        border-left: none;
        border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    }
}
.summary-stale {
    opacity: 0.6;
    transition: opacity 0.15s;
}
.process-bar-row {
    display: grid;
    grid-template-columns: 40px minmax(0, 1fr) 36px;
    align-items: center;
    gap: 14px;
    padding: 8px 6px;
    margin: 0 -6px;
    border-radius: 10px;
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
.bp-icon {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    border-radius: 10px;
}
.bp-main {
    min-width: 0;
}
.bp-main .process-bar-name {
    margin-bottom: 6px;
}
.process-bar-name {
    font-size: 0.85rem;
    font-weight: 700;
    min-width: 0;
    color: rgb(var(--v-theme-on-surface));
}
.process-bar-track {
    height: 10px;
    min-width: 0;
    background: rgba(var(--v-theme-on-surface), 0.07);
    border-radius: 999px;
    overflow: hidden;
}
.process-bar-fill {
    height: 100%;
    border-radius: 999px;
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
    border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.start-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
}
.start-title {
    font-size: 0.85rem;
    line-height: 1.25;
}
</style>
