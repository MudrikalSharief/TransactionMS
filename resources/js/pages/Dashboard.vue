<template>
    <div class="fit-page">
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
                <!-- Period drives every card and the graph (all accounts);
                     Offices narrows them for superadmins. -->
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
                <template v-if="isSuperadmin">
                    <v-select
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
        <!-- The headline numbers stay on top. -->
        <div v-if="canSeeSummary">
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
        </div>
        <!-- Cards render in the user's saved order, each in the next slot of
             the grid; press-and-hold a card for 2s, then drag it onto another
             card to swap them. -->
        <div
            class="dash-grid"
            @pointerdown="onHoldStart"
            @pointermove="onHoldMove"
            @pointerup="onHoldEnd"
            @pointercancel="onHoldCancel"
            @click.capture="onRowClickCapture"
            @contextmenu="onRowContextMenu"
        >
            <template v-for="id in cardOrder" :key="id">
                <div v-if="id === 'graph'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-chart-bar</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">{{ scopeProcessTitle }}</span>
                            <v-spacer />
                            <!-- The period comes from the Period filter at the top. -->
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
                                                <v-card-text class="pa-2 d-flex flex-column dash-body">
                            <GroupedBarChart
                                :series="graphSeries"
                                :group-labels="graphGroups"
                                :loading="loading"
                                :height="fit ? 80 : 190"
                                :empty-text="graphEmptyText"
                                :aria-label="graphAriaLabel"
                            />
                        </v-card-text>
                    </v-card>
                </div>
                <div v-else-if="id === 'start'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-rocket-launch-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">Get Started</span>
                        </v-card-title>
                        <v-card-text class="pa-0 d-flex flex-column dash-body">
                            <div
                                v-for="link in startLinks"
                                :key="link.title"
                                class="start-row d-flex align-center px-3"
                                role="button"
                                tabindex="0"
                                @click="link.go"
                                @keydown.enter.prevent="link.go"
                            >
                                <div class="start-icon mr-3" :style="{ background: link.tile }">
                                    <v-icon color="white" size="18">{{ link.icon }}</v-icon>
                                </div>
                                <div class="flex-grow-1" style="min-width: 0">
                                    <div class="font-weight-bold start-title text-truncate">{{ link.title }}</div>
                                    <div class="start-sub text-truncate" :title="link.subtitle">{{ link.subtitle }}</div>
                                </div>
                                <v-icon size="small" color="primary">mdi-chevron-right</v-icon>
                            </div>
                        </v-card-text>
                    </v-card>
                </div>
                <div v-else-if="id === 'byprocess'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-chart-pie</v-icon>
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
                        <v-card-text v-fit-body="'pie'" class="pa-2 px-3 process-pie-body dash-body" :class="{ 'summary-stale': summaryLoading && summary }">
                            <div v-if="summary && !byProcessRows.length" class="text-caption text-medium-emphasis">
                                No transactions created in this period.
                            </div>
                            <template v-else-if="byProcessRows.length">
                                <ProcessPie
                                    v-model:hover="byProcessHover"
                                    :slices="byProcessRows"
                                    :size="pieSize"
                                    @open="(s) => openDetail('process', barEls[s.id], s)"
                                />
                                <!-- Legend: name, count and share for every slice;
                                     hover links to its slice, Enter or the pop-up
                                     opens the full list. -->
                                <div class="pp-legend" :class="{ 'pp-legend--tight': legendTight }">
                                    <div
                                        v-for="row in legendRows"
                                        :key="row.key"
                                        :ref="(el) => row.id != null && (barEls[row.id] = el)"
                                        class="process-bar-row"
                                        :class="{ 'is-hot': byProcessHover === row.key, 'is-cold': byProcessHover && byProcessHover !== row.key }"
                                        :role="row.id != null ? 'button' : undefined"
                                        :tabindex="row.id != null ? 0 : undefined"
                                        :aria-label="`${row.name}: ${row.count} transactions, ${row.pct}%${row.id != null ? '. Press Enter for the full list' : ''}`"
                                        @mouseenter="byProcessHover = row.key"
                                        @mouseleave="byProcessHover = null"
                                        @focus="byProcessHover = row.key"
                                        @blur="byProcessHover = null"
                                        @keydown.enter.prevent="row.id != null && openDetail('process', barEls[row.id], row)"
                                    >
                                        <SummaryPopover
                                            v-if="row.id != null"
                                            category="process"
                                            :process-id="row.id"
                                            :process-name="`${row.name} transactions`"
                                            :query="summaryQuery"
                                            :period-label="summaryScopeText"
                                            @expand="openDetail('process', barEls[row.id], row)"
                                        />
                                        <i class="pp-swatch" :style="{ background: row.color }" aria-hidden="true" />
                                        <span class="pp-name" :title="row.name">{{ row.name }}</span>
                                        <span class="pp-num">
                                            <span class="pp-count">{{ row.count }}</span>
                                            <span class="pp-pct">{{ row.pct }}%</span>
                                        </span>
                                    </div>
                                    <div v-if="legendHidden" class="pp-more">and {{ legendHidden }} more</div>
                                </div>
                            </template>
                        </v-card-text>
                    </v-card>
                </div>
                <div v-else-if="id === 'recent'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-history</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">Recent Activity</span>
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
                                                <v-card-text v-fit-body="'recent'" class="pa-1 dash-body">
                            <div v-if="loading" class="d-flex align-center justify-center dash-loading">
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
                                    v-for="tx in recent.slice(0, rows('recent', LIST_ROW_PX, 4))"
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
                </div>
                <div v-else-if="id === 'action'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">{{ isSuperadmin ? 'mdi-account-clock-outline' : 'mdi-tray-full' }}</v-icon>
                            </v-avatar>
                            <div class="dash-head-title">
                                <div class="text-subtitle-1 font-weight-bold">Needs My Action</div>
                                <div v-if="actionSub" class="dash-panel-sub text-truncate">{{ actionSub }}</div>
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
                                                <!-- Superadmin: new sign-ups to approve or reject. -->
                        <v-card-text v-if="isSuperadmin" v-fit-body="'action'" class="pa-0 dash-body">
                            <div v-if="accountsLoading && !pendingAccounts.length" class="d-flex align-center justify-center dash-loading">
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
                                        <th class="text-left col-side">Office · Role</th>
                                        <th class="text-left col-when">Requested</th>
                                        <th class="text-right col-acts">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="u in pendingAccounts.slice(0, actionRowsFit)" :key="u.id">
                                        <td>
                                            <div class="d-flex align-center ga-3">
                                                <div class="row-icon account-icon">
                                                    <v-icon size="20">mdi-account-outline</v-icon>
                                                </div>
                                                <div style="min-width: 0">
                                                    <div class="font-weight-bold action-title text-truncate">{{ u.name }}</div>
                                                    <div class="text-caption text-medium-emphasis text-truncate only-wide" :title="u.email">{{ u.email }}</div>
                                                    <div class="text-caption text-medium-emphasis text-truncate only-narrow">{{ accountScope(u) }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-body-2 col-side text-truncate" :title="accountScope(u)">{{ accountScope(u) }}</td>
                                        <td class="font-weight-bold col-when">{{ timeAgo(u.created_at) }}</td>
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
                        <v-card-text v-else v-fit-body="'action'" class="pa-0 dash-body">
                            <div v-if="loading" class="d-flex align-center justify-center dash-loading">
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
                                        <th class="text-left col-side">Current Step</th>
                                        <th class="text-left col-when">Waiting</th>
                                        <th style="width: 40px" />
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="tx in actionQueue.slice(0, actionRowsFit)"
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
                                                    <div class="font-weight-bold action-title text-truncate">
                                                        {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                                                    </div>
                                                    <div class="text-caption text-medium-emphasis text-truncate only-wide">
                                                        {{ txSubtitle(tx) }}
                                                    </div>
                                                    <div class="text-caption text-medium-emphasis text-truncate only-narrow">
                                                        {{ tx.current_step?.name || tx.current_step?.code || 'Unassigned' }}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="col-side">
                                            <span class="step-pill" :style="tintStyle(txProcessName(tx))">
                                                {{ tx.current_step?.name || tx.current_step?.code || 'Unassigned' }}
                                            </span>
                                        </td>
                                        <td
                                            class="font-weight-bold col-when"
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
                </div>
                <div v-else-if="id === 'intransit'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-truck-fast-outline</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">In Transit</span>
                            <v-spacer />
                        </v-card-title>
                                                <v-card-text v-fit-body="'intransit'" class="pa-1 dash-body">
                            <div v-if="loading" class="d-flex align-center justify-center dash-loading">
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
                                    v-for="tx in inTransit.slice(0, rows('intransit', LIST_ROW_PX, 5))"
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
                </div>
            </template>
        </div>
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
import { useFitScreen } from '@/composables/useFitScreen'
import { confirm } from '@/composables/useConfirm'
import { useSmartPoll } from '@/composables/useSmartPoll'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import SummaryDetailDialog from '@/components/SummaryDetailDialog.vue'
import SummaryPopover from '@/components/SummaryPopover.vue'
import ProcessPie from '@/components/ProcessPie.vue'
import StatCard from '@/components/StatCard.vue'
import { processColor, processIcon, txProcessName, isPastLimit } from '@/utils/processColor'
import {
    periodOptions as dashPeriodOptions,
    periodBuckets,
    periodStart,
    bucketIndexOf,
    bucketUnit,
} from '@/utils/dashPeriod'
import { isCached, readCache, writeCache, CacheKeys, scopedKey, storedUserId } from '@/composables/useCache'

const router = useRouter()
const auth = useAuth()
const { api } = useApi()

const txStore = useTransactions()
const typeStore = useTransactionTypes()
const officeStore = useOffices()

const loading = ref(false)
const refreshedAt = ref(null)

// The page fills the screen on desktop: lists show the rows that fit (no
// scroll, no half rows) and the pie follows its card's height.
const { fit, sizes, vFitBody, rows } = useFitScreen()
const LIST_ROW_PX = 46
const TABLE_ROW_PX = 42
const TABLE_HEAD_PX = 28
const LEGEND_ROW_PX = 38
const LEGEND_TIGHT_ROW_PX = 24
const actionRowsFit = computed(() => rows('action', TABLE_ROW_PX, 5, TABLE_HEAD_PX))

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
// Default order; the staff layout swaps the graph for the queue. The
// Transaction Summary numbers sit above the grid and don't move.
const cardIds = computed(() => {
    if (canSeeSummary.value) {
        return ['graph', 'byprocess', 'action', 'recent', 'start']
    }
    return ['action', 'intransit', 'recent', 'start']
})
// Width of each grid slot, out of 12 columns; two rows.
const slotSpans = computed(() => (canSeeSummary.value ? [8, 4, 5, 4, 3] : [8, 4, 8, 4]))
function slotStyle(id) {
    return { '--span': slotSpans.value[cardOrder.value.indexOf(id)] ?? 4 }
}
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
        window.getSelection()?.removeAllRanges()
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

// Series colors for the bar chart and the By Process pie, light and dark
// steps; adjacent pairs pass the colour-blind separation checks in both
// modes. Slot 3 is violet (no black in the charts). Gray is reserved for
// the folded "Other processes" bar/slice.
const SERIES_PALETTE = {
    light: ['#005EED', '#F26B21', '#6250D6', '#FFA94D', '#4D94FF', '#B84A0F', '#8FBBFF'],
    dark: ['#4D94FF', '#FF8A4C', '#9085E9', '#FFB27A', '#1F6FFF', '#D9622B', '#8FBBFF'],
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

// ---- Period filter ----
// All time by default so pending work never hides on a week/month
// rollover; switchable to this week (current Mon–Sun week) or one of the
// last 12 months (Manila calendar). It drives the tiles, the By Process pie,
// the graph and Recent Activity. Completed counts by finalize date, the rest
// by created date (server side). Declared before the graph: its computeds
// can run during setup when the transaction list is already cached (e.g.
// clicking Dashboard from another page).
const summaryPeriod = ref('all')
const periodOptions = computed(() => dashPeriodOptions())

// ---- Graph: the office's transactions per process over the Period filter ----
// One group of bars per day (this week), week (a month) or month (all time),
// never past today; see utils/dashPeriod.js.
const oldestInScope = computed(() => {
    let oldest = null
    for (const tx of scopeSource.value) {
        if (tx.created_at && inOfficeScope(tx) && (!oldest || tx.created_at < oldest)) oldest = tx.created_at
    }
    return oldest
})
const graphBuckets = computed(() => periodBuckets(summaryPeriod.value, { oldest: oldestInScope.value }))
const graphGroups = computed(() => graphBuckets.value.map((b) => b.label))
const graphUnit = computed(() => bucketUnit(summaryPeriod.value, graphBuckets.value))

const graphEmptyText = computed(() =>
    officeScopeLabel.value
        ? `No ${officeScopeLabel.value} transactions in ${summaryScopeText.value}`
        : `No transactions in ${summaryScopeText.value}`
)
const graphAriaLabel = computed(() =>
    officeScopeLabel.value
        ? `${officeScopeLabel.value} transactions per process per ${graphUnit.value}, ${summaryScopeText.value}`
        : `Transactions per process per ${graphUnit.value}, ${summaryScopeText.value}`
)

const groupIndexOf = (tx) => bucketIndexOf(graphBuckets.value, tx.created_at)

function txTypeLabel(tx) {
    return tx.transaction_type?.name || tx.transaction_type_name
}

// Visible transactions created in the period (own office, if assigned,
// or the offices picked by a superadmin).
const graphTx = computed(() =>
    scopeSource.value.filter((tx) => inOfficeScope(tx) && groupIndexOf(tx) >= 0)
)

// Per-process counts per bar group, busiest process first.
const processRanking = computed(() => {
    const byName = new Map()
    for (const tx of graphTx.value) {
        const name = txTypeLabel(tx)
        if (!name) continue
        if (!byName.has(name)) byName.set(name, graphBuckets.value.map(() => 0))
        byName.get(name)[groupIndexOf(tx)]++
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

// Options: every process, with its count for the period (0 when it has none),
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
// in the period, so the Process filter never repaints a bar. Past 7 processes
// this can't be global, so the slot falls back to the position among the
// bars currently drawn.
// One colour per process, shared by the bar chart and the By Process pie:
// every process either shows, alphabetical, takes the next palette slot.
const processColorSlot = computed(() => {
    const names = [
        ...new Set([...processRanking.value.map((p) => p.label), ...(summary.value?.by_process || []).map((r) => r.name)]),
    ].sort()
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
            values: graphBuckets.value.map((_, wi) => rest.reduce((s, p) => s + p.values[wi], 0)),
        })
    }
    return series
})

// ---- Transaction Summary card (superadmin) ----
// (The Period filter, summaryPeriod, is declared above the graph.)

const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// Same scope and period as the graph, but independent of its Process
// filter. No office assigned: the backend aggregates all offices.
// Office admins send no office: the server forces their office's full scope
// (filed by it or passing through it), which an office_code would narrow.
const summaryQuery = computed(() => ({
    month: summaryPeriod.value === 'this_week' ? undefined : summaryPeriod.value,
    ...(isSuperadmin.value && scopeCode.value ? { office_code: scopeCode.value } : {}),
    ...(officeFilter.value?.length ? { offices: [...officeFilter.value].sort((a, b) => a - b) } : {}),
}))

// One key for both the setup paint and refreshes. storedUserId() covers the
// first render before auth.init() has restored the session.
const summaryCacheKey = () =>
    scopedKey(
        `${CacheKeys.summary}:${JSON.stringify(summaryQuery.value)}`,
        auth.user.value?.id ?? storedUserId(),
    )

// Paint the last summary during setup (not onMounted) so switching back to
// the Dashboard or reloading shows the tiles/chart immediately, then the
// network refresh below replaces them silently.
const _cachedSummary = readCache(summaryCacheKey())
if (_cachedSummary != null) summary.value = _cachedSummary

let summaryRequest = 0
async function loadSummary() {
    if (!canSeeSummary.value) return
    const mine = ++summaryRequest
    // Instant illusion: last summary for this period/office paints at once
    // (template already dims stale tiles via .summary-stale), then the
    // network refreshes silently. Spinner only shows with zero cached data.
    const cacheKey = summaryCacheKey()
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

// By Process pie: share of the period's transactions per process, in the
// same colours as the bar chart. Up to 7 named slices (the busiest); the
// rest fold into one gray "Other processes" slice. Slices and legend run in
// palette order, so neighbouring slices are validated palette neighbours.
const byProcessHover = ref(null)
const byProcessRows = computed(() => {
    const rows = [...(summary.value?.by_process || [])].filter((r) => r.count > 0)
    const total = rows.reduce((s, r) => s + r.count, 0)
    if (!total) return []
    const pct = (n) => Math.round((n / total) * 1000) / 10
    const palette = SERIES_PALETTE[themeMode.value]
    const busiest = rows.sort((a, b) => b.count - a.count || a.name.localeCompare(b.name))
    const named = busiest.slice(0, MAX_PROCESS_BARS)
    const rest = busiest.slice(MAX_PROCESS_BARS)
    const slots = processColorSlot.value
    const fallback = new Map([...named].map((r) => r.name).sort().map((n, i) => [n, i]))
    const slotOf = (name) => (slots?.has(name) ? slots.get(name) : fallback.get(name))
    const out = named
        .map((r) => ({ ...r, key: `p${r.id}`, pct: pct(r.count), color: palette[slotOf(r.name)], slot: slotOf(r.name) }))
        .sort((a, b) => a.slot - b.slot)
    if (rest.length) {
        const count = rest.reduce((s, r) => s + r.count, 0)
        out.push({ key: 'other', id: null, name: OTHER_PROCESSES, count, pct: pct(count), color: OTHER_COLOR[themeMode.value] })
    }
    return out
})

// Oldest first: longest-waiting items the user can act on.
// Admins keep the office/system queue; staff only see rows the server
// flags as waiting on them (same gate the write endpoints enforce), so
// the queue never lists a paper parked at another office.
const actionQueue = computed(() => {
    const base = [...(txStore.items.value || [])].filter(
        (tx) => !isStaff.value || tx.needs_action,
    )
    base.sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0))
    return base
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
    return list
})
const inTransitIds = computed(() => new Set(inTransit.value.map((tx) => tx.id)))

// Created in the Period filter's range (all time: everything).
const recentFrom = computed(() => periodStart(summaryPeriod.value)?.getTime() ?? null)
const recentTo = computed(() => {
    const buckets = summaryPeriod.value === 'all' ? null : periodBuckets(summaryPeriod.value)
    return buckets?.length ? buckets[buckets.length - 1].end.getTime() : null
})
const recent = computed(() => {
    const source = scopeSource.value || []
    const from = recentFrom.value
    const to = recentTo.value
    const list = source.filter((tx) => {
        if (officeIds.value.size && !officeIds.value.has(tx.office?.id)) return false
        if (from == null) return true
        const at = new Date(tx.created_at || 0).getTime()
        return at >= from && (to == null || at < to)
    })
    // Staff: the feed holds the rest — never duplicates the queue or the
    // in-transit card.
    const feed = isStaff.value
        ? list.filter((tx) => !tx.needs_action && !inTransitIds.value.has(tx.id))
        : list
    feed.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
    return feed
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

// By Process: the pie takes the card's height; the legend lists what fits.
const pieSize = computed(() => {
    const s = sizes.pie
    if (!fit.value || !s) return 168
    return Math.round(Math.min(200, Math.max(84, Math.min(s.h, s.w * 0.45))))
})
const legendTight = computed(() => fit.value && (sizes.pie?.h ?? 999) < 150)
const legendRows = computed(() => {
    const all = byProcessRows.value
    const room = rows('pie', legendTight.value ? LEGEND_TIGHT_ROW_PX : LEGEND_ROW_PX, all.length)
    return all.length <= room ? all : all.slice(0, Math.max(1, room - 1))
})
const legendHidden = computed(() => byProcessRows.value.length - legendRows.value.length)

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
// Says so when the card has more rows than fit.
const actionSub = computed(() => {
    const total = isSuperadmin.value ? pendingAccounts.value.length : actionQueue.value.length
    const more = total > actionRowsFit.value ? `Showing ${actionRowsFit.value} of ${total}` : ''
    if (isSuperadmin.value) return more ? `Accounts waiting for approval: ${more.toLowerCase()}` : 'Accounts waiting for approval'
    return more
})

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
}
.dash-hello-title {
    font-size: 1.25rem;
    font-weight: 800;
    line-height: 1.2;
    color: rgb(var(--v-theme-on-surface));
}
.dash-hello-sub {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    font-size: 0.8rem;
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

/* ---- Card grid (shared rules: "Dashboards" in app.css) ---- */
@media (min-width: 1100px) and (min-height: 560px) {
    .dash-grid {
        grid-template-rows: minmax(0, 1fr) minmax(0, 1fr);
    }
    .dash-body .start-row {
        flex: 1 1 0;
        max-height: 72px;
        min-height: 0;
    }
    /* The pie's tooltip may rise over the card head. */
    .dash-slot[data-card='byprocess'] > .v-card,
    .dash-slot[data-card='byprocess'] .process-pie-body {
        overflow: visible !important;
    }
}
.dash-loading {
    height: 100%;
    min-height: 120px;
}
/* Narrow card: the side column's text moves under the row title. */
.only-narrow {
    display: none;
}
@container (max-width: 460px) {
    .col-side,
    .only-wide {
        display: none;
    }
    .only-narrow {
        display: block;
    }
}
/* Small screens: the head's filters wrap below the title. */
@media (max-width: 1099.98px) {
    .dash-slot[data-card='graph'] .dash-head {
        flex-wrap: wrap;
        row-gap: 10px;
    }
    .dash-slot[data-card='graph'] .process-filter {
        flex: 1 1 140px;
    }
}
/* ---- Row icons, step pills, waiting ---- */
.row-icon {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 32px;
    height: 32px;
    border-radius: 8px;
}
.row-icon .v-icon {
    color: inherit;
}
.account-icon {
    color: #005EED;
    background: color-mix(in srgb, #005EED 14%, transparent);
}
.row-time {
    font-size: 0.72rem;
    white-space: nowrap;
    margin-right: 6px;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.step-pill {
    display: inline-block;
    max-width: 100%;
    padding: 3px 10px;
    border-radius: 999px;
    font-size: 0.75rem;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    vertical-align: middle;
}
.waiting-late {
    color: #e5383b;
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
    min-height: 46px !important;
    padding-block: 2px !important;
    padding-inline: 8px !important;
}
.recent-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
}
/* One line each, so every row is the same height. */
.recent-row :deep(.v-list-item-title) {
    font-size: 0.85rem;
    line-height: 1.25;
}
.recent-row :deep(.v-list-item-subtitle) {
    display: block;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    -webkit-line-clamp: unset;
    line-clamp: unset;
    font-size: 0.72rem;
    line-height: 1.3;
}
.recent-row :deep(.v-list-item__prepend) {
    width: 42px;
}
.recent-row :deep(.v-list-item__spacer) {
    display: none;
}
.action-table {
    --v-table-header-height: 28px;
    --v-table-row-height: 42px;
    background: transparent;
}
.action-table :deep(table) {
    table-layout: fixed;
}
.action-row {
    cursor: pointer;
}
.action-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
}
.action-title {
    font-size: 0.85rem;
    line-height: 1.3;
}
.action-table :deep(th) {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.action-table :deep(th),
.action-table :deep(td) {
    padding-inline: 12px !important;
}
.action-table :deep(td) {
    height: 42px !important;
    vertical-align: middle;
}
.action-table .col-side {
    width: 26%;
}
.action-table .col-when {
    width: 112px;
    font-size: 0.8rem;
    white-space: nowrap;
}
.action-table .col-acts {
    width: 112px;
}
.action-table :deep(.v-btn--icon) {
    width: 32px;
    height: 32px;
}
.action-table :deep(tbody tr:not(:last-child) td) {
    border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.action-table :deep(td:last-child) {
    white-space: nowrap;
}
/* The filters give up width before the title does. */
.process-filter {
    flex: 0 20 224px;
    min-width: 120px;
}
.process-filter :deep(.v-field__input) {
    font-size: 0.875rem;
}
@container (max-width: 720px) {
    .process-filter :deep(.v-field__prepend-inner) {
        display: none;
    }
}
/* ---- Transaction Summary card ---- */
.summary-tiles {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 12px;
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
/* By Process card: pie beside its legend; stacks only on small screens. */
.process-pie-body {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 12px 16px;
    flex: 1 1 auto;
}
@media (min-width: 1100px) {
    .process-pie-body {
        flex-wrap: nowrap;
    }
}
.pp-legend {
    flex: 1 1 180px;
    min-width: 0;
    max-width: 320px;
    display: flex;
    flex-direction: column;
    gap: 2px;
}
.pp-legend--tight {
    gap: 0;
}
.pp-legend--tight .pp-name {
    -webkit-line-clamp: 1;
    line-clamp: 1;
}
.pp-legend--tight .pp-num {
    flex-direction: row;
    align-items: baseline;
    gap: 6px;
}
.pp-more {
    padding: 2px 8px;
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.summary-stale {
    opacity: 0.6;
    transition: opacity 0.15s;
}
.process-bar-row {
    display: grid;
    grid-template-columns: 12px minmax(0, 1fr) auto;
    align-items: center;
    gap: 8px;
    padding: 2px 8px;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.15s, opacity 0.15s;
}
.process-bar-row:not([role="button"]) {
    cursor: default;
}
.process-bar-row:hover,
.process-bar-row:focus-visible,
.process-bar-row.is-hot {
    background: rgba(var(--v-theme-on-surface), 0.06);
    outline: none;
}
.process-bar-row.is-cold {
    opacity: 0.55;
}
.pp-swatch {
    width: 12px;
    height: 12px;
    border-radius: 3px;
}
.pp-name {
    font-size: 0.8rem;
    font-weight: 600;
    min-width: 0;
    /* Long process names wrap to two lines instead of being cut. */
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    overflow: hidden;
    /* Wrap between words; only an over-long single word breaks. */
    overflow-wrap: break-word;
    line-height: 1.25;
    color: rgb(var(--v-theme-on-surface));
}
/* Count over its share, right-aligned, so names keep the width. */
.pp-num {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    line-height: 1.2;
}
.pp-count {
    font-size: 0.85rem;
    font-weight: 800;
    text-align: right;
    color: rgb(var(--v-theme-on-surface));
}
.pp-pct {
    font-size: 0.72rem;
    text-align: right;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.start-row {
    cursor: pointer;
    min-height: 56px;
}
.start-row + .start-row {
    border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.start-row:hover,
.start-row:focus-visible {
    background: rgba(var(--v-theme-on-surface), 0.05);
    outline: none;
}
.start-icon {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 32px;
    height: 32px;
    border-radius: 8px;
}
.start-title {
    font-size: 0.85rem;
    line-height: 1.25;
}
.start-sub {
    font-size: 0.72rem;
    line-height: 1.25;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
</style>
