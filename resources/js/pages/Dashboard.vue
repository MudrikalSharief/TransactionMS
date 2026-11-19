<template>
    <div class="fit-page workspace-dashboard">
        <div class="dash-hello">
            <div class="dash-hello-actions">
                <!-- Overview cards, or the monitoring Reports (superadmins and
                     office admins). Transaction Status and Top Overdue Steps
                     share their filters. -->
                <v-btn-toggle
                    v-if="canSeeSummary"
                    v-model="view"
                    mandatory
                    density="comfortable"
                    color="primary"
                    variant="outlined"
                    rounded="lg"
                    class="dash-view"
                >
                    <v-btn value="overview" prepend-icon="mdi-view-dashboard-outline" class="text-none">Overview</v-btn>
                    <v-btn value="reports" prepend-icon="mdi-chart-box-outline" class="text-none">Reports</v-btn>
                </v-btn-toggle>
                <v-btn
                    v-if="layoutChanged && view === 'overview'"
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
        <!-- The headline numbers stay on top, overview only. -->
        <div v-if="canSeeSummary && view === 'overview'">
            <v-alert v-if="summaryError" type="error" variant="tonal" density="compact" class="mb-3">
                {{ summaryError }}
            </v-alert>
            <div class="summary-row">
                <div
                    v-for="tile in summaryTiles"
                    :key="tile.key"
                    class="summary-strip"
                    :class="{ 'summary-stale': summaryLoading && summary }"
                >
                    <div class="summary-seg" :class="`summary-seg--${tile.variant}`">
                        <span class="summary-seg-icon" aria-hidden="true">
                            <v-icon size="28">{{ tile.key === 'overdue_steps' ? 'mdi-timer-alert-outline' : 'mdi-file-clock-outline' }}</v-icon>
                        </span>
                        <span class="summary-seg-num">
                            <v-progress-circular
                                v-if="summaryLoading && !summary"
                                indeterminate
                                tag="span"
                                size="22"
                                width="3"
                                color="grey-darken-1"
                            />
                            <template v-else>{{ tile.value }}</template>
                        </span>
                        <span class="summary-seg-copy">
                            <span class="summary-seg-label">{{ tile.label }}</span>
                            <span class="summary-seg-hint">{{ tile.hint }}</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <!-- Cards render in the user's saved order, each in the next slot of
             the grid; press-and-hold a card for 2s, then drag it onto another
             card to swap them. -->
        <!-- Reports view: one card filling the grid's space (no page scroll). -->
        <div v-if="view === 'reports'" class="dash-grid dash-grid--single">
            <div class="dash-slot" style="--span: 12">
                <MonitoringReportPanel />
            </div>
        </div>
        <div
            v-else
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
                                            <span>{{ chartMonthLabel }}</span>
                                            <v-icon size="16">mdi-chevron-down</v-icon>
                                        </button>
                                    </template>
                                    <v-list density="compact" class="topsteps-month-list">
                                        <v-list-item
                                            v-for="m in chartMonthOptions"
                                            :key="m.value"
                                            :active="chartEndMonth === m.value"
                                            @click="chartEndMonth = m.value"
                                        >
                                            <v-list-item-title>{{ m.title }}</v-list-item-title>
                                            <template #append>
                                                <v-icon v-if="chartEndMonth === m.value" size="18">mdi-check</v-icon>
                                            </template>
                                        </v-list-item>
                                    </v-list>
                                </v-menu>
                                <v-menu
                                    v-if="isSuperadmin"
                                    v-model="chartOfficeMenuOpen"
                                    location="bottom end"
                                    offset="6"
                                    :close-on-content-click="false"
                                >
                                    <template #activator="{ props }">
                                        <button
                                            v-bind="props"
                                            type="button"
                                            class="topsteps-month chart-office-chip"
                                            aria-haspopup="listbox"
                                            :aria-expanded="chartOfficeMenuOpen ? 'true' : 'false'"
                                            aria-controls="chart-office-panel"
                                            :title="chartOfficeFilterSummary"
                                        >
                                            <span v-if="chartOfficePickerSeal" class="office-seal chart-office-seal" aria-hidden="true">
                                                <img v-if="chartOfficePickerSeal.icon" :src="chartOfficePickerSeal.icon" alt="" />
                                                <span v-else>{{ chartOfficePickerSeal.initials }}</span>
                                            </span>
                                            <v-icon v-else size="16">mdi-office-building-outline</v-icon>
                                            <span>{{ chartOfficeFilterSummary }}</span>
                                            <v-icon size="16">mdi-chevron-down</v-icon>
                                        </button>
                                    </template>
                                    <v-card
                                        id="chart-office-panel"
                                        class="office-panel"
                                        rounded="lg"
                                        elevation="8"
                                        role="dialog"
                                        aria-label="Choose offices"
                                    >
                                        <div class="office-panel-head">
                                            <input
                                                ref="chartOfficeSearchEl"
                                                v-model="chartOfficeSearch"
                                                class="office-search"
                                                type="search"
                                                placeholder="Search by name or abbreviation"
                                                aria-label="Search offices"
                                            />
                                            <button type="button" class="office-clear" @click="clearChartOfficeFilter">
                                                Show all offices
                                            </button>
                                        </div>
                                        <div class="office-grid" role="listbox" aria-label="Offices" aria-multiselectable="true">
                                            <button
                                                v-for="o in filteredChartOfficeOptions"
                                                :key="o.value"
                                                type="button"
                                                class="office-card"
                                                :class="{ 'is-selected': chartOfficeIds.includes(o.value) }"
                                                role="option"
                                                :aria-selected="chartOfficeIds.includes(o.value) ? 'true' : 'false'"
                                                :aria-label="o.office?.name || o.title"
                                                v-tooltip="o.office?.name || o.title"
                                                @click="toggleChartOffice(o.value)"
                                                @mouseenter="chartOfficeHover = o"
                                                @mouseleave="chartOfficeHover = null"
                                                @focus="chartOfficeHover = o"
                                                @blur="chartOfficeHover = null"
                                            >
                                                <span class="office-seal" aria-hidden="true">
                                                    <img v-if="o.icon" :src="o.icon" alt="" />
                                                    <span v-else>{{ o.initials }}</span>
                                                </span>
                                                <span class="office-card-abbr">{{ o.code }}</span>
                                            </button>
                                            <div v-if="!filteredChartOfficeOptions.length" class="office-no-match">
                                                No offices match “{{ chartOfficeSearch }}”. Try the abbreviation.
                                            </div>
                                        </div>
                                        <div class="office-panel-foot">
                                            <template v-if="chartOfficeHover">
                                                <b>{{ chartOfficeHover.code }}</b> · {{ chartOfficeHover.office?.name || chartOfficeHover.title }}
                                            </template>
                                            <template v-else-if="selectedChartOffices.length">
                                                Selected: <b>{{ selectedChartOffices.map((o) => o.code).join(', ') }}</b>
                                            </template>
                                            <template v-else>
                                                Hover or focus an office to see its full name.
                                            </template>
                                        </div>
                                    </v-card>
                                </v-menu>
                            </div>
                        </v-card-title>
                                                <v-card-text class="pa-2 d-flex flex-column dash-body">
                            <v-alert v-if="chartError" type="error" variant="tonal" density="compact" class="mb-2">
                                {{ chartError }}
                            </v-alert>
                            <GroupedBarChart
                                :series="graphSeries"
                                :group-labels="graphGroups"
                                :loading="chartLoading && !chartData"
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
                                <v-icon color="#005EED" size="20">mdi-chart-donut</v-icon>
                            </v-avatar>
                            <div style="min-width: 0">
                                <div class="text-subtitle-1 font-weight-bold">Overdue Transactions by Office</div>
                                <div class="dash-panel-sub">Which offices hold the most late items</div>
                            </div>
                            <v-spacer />
                            <v-menu location="bottom end" offset="6" :close-on-content-click="true">
                                <template #activator="{ props }">
                                    <button
                                        v-bind="props"
                                        type="button"
                                        class="topsteps-month"
                                        aria-label="Filter overdue transactions by month"
                                    >
                                        <v-icon size="16">mdi-calendar-range</v-icon>
                                        <span>{{ overduePieMonthLabel }}</span>
                                        <v-icon size="16">mdi-chevron-down</v-icon>
                                    </button>
                                </template>
                                <v-list density="compact" class="topsteps-month-list">
                                    <v-list-item
                                        v-for="m in overduePieMonthOptions"
                                        :key="m.value"
                                        :active="overduePieMonth === m.value"
                                        @click="overduePieMonth = m.value"
                                    >
                                        <v-list-item-title>{{ m.title }}</v-list-item-title>
                                        <template #append>
                                            <v-icon v-if="overduePieMonth === m.value" size="18">mdi-check</v-icon>
                                        </template>
                                    </v-list-item>
                                </v-list>
                            </v-menu>
                        </v-card-title>
                        <v-card-text v-fit-body="'transactionsPie'" class="pa-2 px-3 process-pie-body dash-body" :class="{ 'summary-stale': overduePieLoading && overduePieData }">
                            <v-alert v-if="overduePieError" type="error" variant="tonal" density="compact" class="ma-2">
                                {{ overduePieError }}
                            </v-alert>
                            <OfficeDonut
                                v-else-if="overdueOfficeRows.length"
                                :slices="overdueOfficeRows"
                                :size="transactionsPieSize"
                                aria-label="Overdue transactions by office"
                            />
                            <div v-else-if="overduePieLoading" class="d-flex align-center justify-center dash-loading">
                                <v-progress-circular indeterminate color="grey-darken-3" size="40" width="3" />
                            </div>
                            <div v-else-if="overduePieData" class="text-caption text-medium-emphasis">
                                No overdue transactions in {{ overduePieMonthLabel }}.
                            </div>
                        </v-card-text>
                    </v-card>
                </div>
                <div v-else-if="id === 'topsteps'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-format-list-numbered</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">Top Overdue Steps</span>
                            <v-spacer />
                            <v-menu location="bottom end" offset="6" :close-on-content-click="true">
                                <template #activator="{ props }">
                                    <button
                                        v-bind="props"
                                        type="button"
                                        class="topsteps-month"
                                        aria-label="Filter Top Overdue Steps by month"
                                    >
                                        <v-icon size="16">mdi-calendar-range</v-icon>
                                        <span>{{ topStepsMonthLabel }}</span>
                                        <v-icon size="16">mdi-chevron-down</v-icon>
                                    </button>
                                </template>
                                <v-list density="compact" class="topsteps-month-list">
                                    <v-list-item
                                        v-for="m in topStepsMonthOptions"
                                        :key="m.value"
                                        :active="topStepsMonth === m.value"
                                        @click="topStepsMonth = m.value"
                                    >
                                        <v-list-item-title>{{ m.title }}</v-list-item-title>
                                        <template #append>
                                            <v-icon v-if="topStepsMonth === m.value" size="18">mdi-check</v-icon>
                                        </template>
                                    </v-list-item>
                                </v-list>
                            </v-menu>
                        </v-card-title>
                        <v-card-text class="pa-3 d-flex flex-column dash-body">
                            <v-alert v-if="topStepsError" type="error" variant="tonal" density="compact" class="mb-2">
                                {{ topStepsError }}
                            </v-alert>
                            <div v-else-if="topStepsLoading && !topStepsData" class="d-flex align-center justify-center dash-loading">
                                <v-progress-circular indeterminate color="grey-darken-3" size="32" width="3" />
                            </div>
                            <ol v-else-if="topSteps.length" class="top-steps">
                                <li
                                    v-for="(s, i) in topSteps"
                                    :key="`${s.step_id}|${s.office?.id ?? 0}`"
                                    class="top-step-row"
                                >
                                    <span class="top-step-rank">{{ i + 1 }}</span>
                                    <div class="top-step-main">
                                        <div
                                            class="top-step-type"
                                            :title="s.transaction_type || 'No transaction type'"
                                        >
                                            {{ s.transaction_type || 'No type' }}
                                        </div>
                                        <div
                                            class="top-step-step"
                                            :title="`Step ${s.order_number}: ${s.step}`"
                                        >
                                            <span v-if="s.order_number" class="top-step-number">Step {{ s.order_number }}</span>
                                            <span class="top-step-label">{{ s.step }}</span>
                                        </div>
                                    </div>
                                    <span
                                        class="top-step-office"
                                        :title="s.office?.name || 'No office'"
                                    >
                                        {{ s.office?.code || s.office?.name || 'No office' }}
                                    </span>
                                    <span class="top-step-count">{{ s.count }}</span>
                                </li>
                            </ol>
                            <div v-else class="text-caption text-medium-emphasis pa-3">
                                No overdue steps in {{ topStepsMonthLabel }}.
                            </div>
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
                                        {{ txRef(tx) }}
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
                                <v-icon color="#005EED" size="20">{{ canApproveAccounts ? 'mdi-account-clock-outline' : 'mdi-tray-full' }}</v-icon>
                            </v-avatar>
                            <div class="dash-head-title">
                                <div class="text-subtitle-1 font-weight-bold">Needs My Action</div>
                                <div v-if="actionSub" class="dash-panel-sub">{{ actionSub }}</div>
                            </div>
                            <v-spacer />
                            <v-btn
                                variant="text"
                                size="small"
                                color="primary"
                                append-icon="mdi-arrow-right"
                                @click="canApproveAccounts ? goToAccounts() : goToQueue()"
                            >
                                {{ canApproveAccounts ? (isSuperadmin ? 'All accounts' : 'Office users') : 'My queue' }}
                            </v-btn>
                        </v-card-title>
                        <!-- Admins: new sign-ups to approve or reject. Office
                             admins only see people who chose their office. -->
                        <v-card-text v-if="canApproveAccounts" v-fit-body="'action'" class="pa-0 dash-body">
                            <div v-if="accountsLoading && !pendingAccounts.length" class="d-flex align-center justify-center dash-loading">
                                <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
                            </div>
                            <v-alert v-if="accountError" type="error" variant="tonal" rounded="0" density="compact" class="ma-4">
                                {{ accountError }}
                            </v-alert>
                            <v-alert
                                v-if="!accountsLoading && !pendingAccounts.length && !accountError"
                                type="success"
                                variant="tonal"
                                rounded="0"
                                class="ma-4"
                            >
                                {{ pendingEmptyText }}
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
                                                    <div class="text-caption text-medium-emphasis text-truncate only-wide" :title="u.username || u.email">{{ u.username || u.email }}</div>
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
                                                        {{ txRef(tx) }}
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
                                        {{ txRef(tx) }}
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
    </div>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useTheme } from 'vuetify'
import { useAuth, isOfficeAdminUser } from '@/composables/useAuth'
import { summaryApiBase } from '@/composables/useSummaryRows'
import { useApi } from '@/composables/useApi'
import { useTransactions } from '@/composables/useTransactions'
import { useOffices } from '@/composables/useOffices'
import { useDashboardLayout } from '@/composables/useDashboardLayout'
import { useAdminUsers } from '@/composables/useAdminUsers'
import { useFitScreen } from '@/composables/useFitScreen'
import { confirm } from '@/composables/useConfirm'
import { useSmartPoll } from '@/composables/useSmartPoll'
import { markWorkspaceRefreshed } from '@/composables/useWorkspaceHeader'
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import OfficeDonut from '@/components/OfficeDonut.vue'
import MonitoringReportPanel from '@/components/MonitoringReportPanel.vue'
import { processColor, processIcon, txProcessName, isPastLimit } from '@/utils/processColor'
import { officeIcon } from '@/utils/officeIcons'
import { monthOptions, monthValue } from '@/utils/dashPeriod'
import { isCached, readCache, writeCache, CacheKeys, scopedKey, storedUserId } from '@/composables/useCache'

const router = useRouter()
const route = useRoute()
const auth = useAuth()
const { api } = useApi()

const txStore = useTransactions()
const officeStore = useOffices()

const loading = ref(false)

// The page fills the screen on desktop: lists show the rows that fit (no
// scroll, no half rows) and the pie follows its card's height.
const { fit, sizes, vFitBody, rows } = useFitScreen()
const LIST_ROW_PX = 46
const TABLE_ROW_PX = 42
const TABLE_HEAD_PX = 28
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

// ---- Overview cards or the monitoring Reports (was its own page) ----
// Kept in the address (?view=reports) so links, refresh and Back keep it.
const view = ref(canSeeSummary.value && route.query.view === 'reports' ? 'reports' : 'overview')
watch(view, (v) => {
    router.replace({ query: { ...route.query, view: v === 'reports' ? 'reports' : undefined } })
})
watch(() => route.query.view, (v) => {
    view.value = canSeeSummary.value && v === 'reports' ? 'reports' : 'overview'
})

// Superadmins approve accounts from any office; office admins approve
// sign-ups that chose their office.
const canApproveAccounts = computed(() => isSuperadmin.value || isOfficeAdmin.value)
const myOfficeId = computed(
    () => auth.user.value?.office_id ?? auth.user.value?.office?.id ?? null,
)

// ---- Movable cards: press and hold a card for 2s, then drag it onto
// another card to take its place ----
// Default order; the staff layout swaps the graph for the queue. The
// Transaction Summary numbers sit above the grid and don't move.
const cardIds = computed(() => {
    if (canSeeSummary.value) {
        return ['graph', 'byprocess', 'action', 'topsteps']
    }
    return ['action', 'intransit', 'recent', 'start']
})
// Width of each grid slot, out of 12 columns; two rows.
const slotSpans = computed(() => {
    return canSeeSummary.value ? [6, 6, 6, 6] : [8, 4, 8, 4]
})
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

// Blue/cyan office series; gray is reserved for "Other offices".
const SERIES_PALETTE = {
    light: ['#1E63ED', '#38AFE3', '#83B8FF', '#66CEDA', '#727DE5', '#4C8BEE'],
    dark: ['#6399FF', '#58C2EE', '#A8CEFF', '#8ADFE6', '#A4ABF4', '#8AB6FA'],
}
const OTHER_OFFICES = 'Other offices'
const OTHER_COLOR = { light: '#8B95A5', dark: '#7E8899' }
const MAX_OFFICE_SLICES = 3

// Keep completed, in-progress and overdue bars semantically distinct.
const STATUS_COLORS = {
    light: { completed: '#35BD83', in_process: '#FFBD32', overdue: '#FF5262' },
    dark: { completed: '#72D7AB', in_process: '#FFD074', overdue: '#FF8B96' },
}

const theme = useTheme()
const themeMode = computed(() => (theme.global.name.value === 'pixivDark' ? 'dark' : 'light'))

// Scope: the account's office when one is assigned, otherwise everything
// visible to the user (superadmins are usually unassigned, so all offices).
const myOffice = computed(() => auth.user.value?.office ?? null)

// ---- Transaction Status: month and multi-office filters ----
const chartEndMonth = ref(monthValue(new Date()))
const chartMonthOptions = computed(() => monthOptions())

function officeInitials(office) {
    const code = String(office?.code || '').trim()
    if (code) return code.slice(0, 2).toUpperCase()
    return (
        String(office?.name || '?')
            .trim()
            .split(/\s+/)
            .slice(0, 2)
            .map((part) => part[0] || '')
            .join('')
            .toUpperCase() || '?'
    )
}

const chartOfficeIds = ref([])
const chartOfficeOptions = computed(() =>
    [...(officeStore.items.value || [])]
        .sort((a, b) => String(a.name).localeCompare(String(b.name)))
        .map((o) => ({
            title: o.code ? `${o.name} (${o.code})` : o.name,
            value: o.id,
            code: o.code || o.name,
            office: o,
            icon: officeIcon(o),
            initials: officeInitials(o),
        })),
)
const selectedChartOffices = computed(() =>
    chartOfficeOptions.value.filter((o) => chartOfficeIds.value.includes(o.value)),
)
const chartOfficePickerSeal = computed(() => selectedChartOffices.value[0] || null)
const chartOfficeFilterSummary = computed(() => {
    const codes = selectedChartOffices.value.map((o) => o.code)
    if (!codes.length) return 'All offices'
    return codes.length <= 2 ? codes.join(', ') : `${codes.length} offices`
})
const chartOfficeMenuOpen = ref(false)
const chartOfficeSearch = ref('')
const chartOfficeSearchEl = ref(null)
const chartOfficeHover = ref(null)
const filteredChartOfficeOptions = computed(() => {
    const q = chartOfficeSearch.value.trim().toLowerCase()
    if (!q) return chartOfficeOptions.value
    return chartOfficeOptions.value.filter((o) =>
        `${o.code} ${o.office?.name || ''}`.toLowerCase().includes(q),
    )
})
function toggleChartOffice(id) {
    const next = new Set(chartOfficeIds.value)
    if (next.has(id)) next.delete(id)
    else next.add(id)
    chartOfficeIds.value = [...next]
}
function clearChartOfficeFilter() {
    chartOfficeIds.value = []
}
watch(chartOfficeMenuOpen, async (open) => {
    chartOfficeSearch.value = ''
    chartOfficeHover.value = null
    if (!open) return
    await nextTick()
    chartOfficeSearchEl.value?.focus()
})
watch(chartOfficeSearch, () => {
    chartOfficeHover.value = null
})

// ---- Top Overdue Steps: its own month filter, independent of the chart ----
const topStepsMonth = ref(monthValue(new Date()))
const topStepsMonthOptions = computed(() => monthOptions())
const topStepsData = ref(null)
const topStepsLoading = ref(false)
const topStepsError = ref('')
let topStepsRequest = 0
const topStepsMonthLabel = computed(
    () => topStepsData.value?.label || topStepsMonthOptions.value.find((o) => o.value === topStepsMonth.value)?.title || topStepsMonth.value,
)
const topSteps = computed(() => topStepsData.value?.steps || [])

const chartData = ref(null)
const chartLoading = ref(false)
const chartError = ref('')
let chartRequest = 0

// The overdue-by-office pie always uses monthly data; it no longer falls back
// to the all-time summary. It has its own month filter, independent of the
// chart's Month/Office filters.
const overduePieMonth = ref(monthValue(new Date()))
const overduePieMonthOptions = computed(() => monthOptions())
const overduePieMonthLabel = computed(
    () => overduePieMonthOptions.value.find((o) => o.value === overduePieMonth.value)?.title || overduePieMonth.value,
)
const overduePieData = ref(null)
const overduePieLoading = ref(false)
const overduePieError = ref('')
let overduePieRequest = 0

async function loadChart({ silent = false } = {}) {
    if (!canSeeSummary.value) return
    const mine = ++chartRequest
    if (!silent && !chartData.value) chartLoading.value = true
    chartError.value = ''
    try {
        const res = await api.get(
            isSuperadmin.value
                ? '/api/admin/dashboard/overdue-overview'
                : '/api/office/dashboard/overdue-overview',
            {
                params: {
                    month: chartEndMonth.value,
                    ...(isSuperadmin.value && chartOfficeIds.value.length
                        ? { office_ids: chartOfficeIds.value }
                        : {}),
                },
                timeout: 10000,
            },
        )
        if (mine !== chartRequest) return
        chartData.value = res.data
    } catch (e) {
        if (mine !== chartRequest) return
        chartError.value = e?.code === 'ECONNABORTED'
            ? 'The overdue overview took too long to load.'
            : (e?.response?.data?.message || 'Failed to load the overdue overview.')
    } finally {
        if (mine === chartRequest) chartLoading.value = false
    }
}

watch([chartEndMonth, chartOfficeIds], () => {
    chartData.value = null
    chartLoading.value = true
    loadChart()
})

async function loadTopSteps({ silent = false } = {}) {
    if (!canSeeSummary.value) return
    const mine = ++topStepsRequest
    if (!silent && !topStepsData.value) topStepsLoading.value = true
    topStepsError.value = ''
    try {
        const res = await api.get(
            isSuperadmin.value
                ? '/api/admin/dashboard/overdue-overview'
                : '/api/office/dashboard/overdue-overview',
            {
                params: { month: topStepsMonth.value },
                timeout: 10000,
            },
        )
        if (mine !== topStepsRequest) return
        topStepsData.value = res.data
    } catch (e) {
        if (mine !== topStepsRequest) return
        topStepsError.value = e?.code === 'ECONNABORTED'
            ? 'The overdue steps took too long to load.'
            : (e?.response?.data?.message || 'Failed to load the overdue steps.')
    } finally {
        if (mine === topStepsRequest) topStepsLoading.value = false
    }
}

watch(topStepsMonth, () => {
    topStepsData.value = null
    topStepsLoading.value = true
    loadTopSteps()
})

async function loadOverduePie({ silent = false } = {}) {
    if (!canSeeSummary.value) return

    const mine = ++overduePieRequest
    overduePieError.value = ''
    if (!silent || overduePieData.value == null) {
        overduePieData.value = null
        overduePieLoading.value = true
    }
    try {
        const res = await api.get(
            isSuperadmin.value
                ? '/api/admin/dashboard/overdue-overview'
                : '/api/office/dashboard/overdue-overview',
            {
                params: { month: overduePieMonth.value },
                timeout: 10000,
            },
        )
        if (mine !== overduePieRequest) return
        overduePieData.value = res.data
    } catch (e) {
        if (mine !== overduePieRequest) return
        overduePieData.value = null
        overduePieError.value = e?.code === 'ECONNABORTED'
            ? 'The monthly office breakdown took too long to load.'
            : (e?.response?.data?.message || 'Failed to load the monthly office breakdown.')
    } finally {
        if (mine === overduePieRequest) overduePieLoading.value = false
    }
}

watch(overduePieMonth, () => {
    loadOverduePie()
})

const chartMonthLabel = computed(
    () => chartData.value?.label || chartMonthOptions.value.find((o) => o.value === chartEndMonth.value)?.title || chartEndMonth.value,
)
const chartMonths = computed(() => chartData.value?.months || [])
const graphGroups = computed(() => chartMonths.value.map((m) => m.label))
const graphEmptyText = computed(() => `No transactions in the 3 months ending ${chartMonthLabel.value}`)
const graphAriaLabel = computed(() => `Transactions by status for the 3 months ending ${chartMonthLabel.value}`)
const graphSeries = computed(() => {
    const rows = chartMonths.value
    const palette = STATUS_COLORS[themeMode.value]
    return [
        { label: 'Completed', color: palette.completed, values: rows.map((r) => r.completed || 0) },
        { label: 'In progress', color: palette.in_process, values: rows.map((r) => r.in_process || 0) },
        { label: 'Overdue', color: palette.overdue, values: rows.map((r) => r.overdue || 0) },
    ]
})
// ---- Transaction Summary cards (all-time) ----
const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// The pie's active source: the fetched month's office breakdown.
const overdueOfficeSource = computed(() => overduePieData.value?.overdue_by_office)

// Without the global Period/Offices filters, the summary tiles show all-time
// data. Office admins are still scoped by the server.
const summaryQuery = computed(() => ({ month: 'all' }))

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
        const res = await api.get(summaryApiBase(), {
            params: summaryQuery.value,
            timeout: 10000,
        })
        if (mine === summaryRequest) {
            summary.value = res.data
            writeCache(cacheKey, res.data)
        }
    } catch (e) {
        if (mine === summaryRequest && summary.value == null) {
            summaryError.value = e?.code === 'ECONNABORTED'
                ? 'The transaction summary took too long to load. Refresh the page.'
                : (e?.response?.data?.message || 'Failed to load the summary.')
        }
    } finally {
        if (mine === summaryRequest) summaryLoading.value = false
    }
}

// Status tiles: each card takes its color and illustration from its variant.
const summaryTiles = computed(() => {
    const s = summary.value || {}
    return [
        {
            key: 'overdue_steps',
            label: 'Overdue Steps',
            variant: 'danger',
            value: s.overdue_steps ?? '—',
            hint: 'Individual steps over SLA',
        },
        {
            key: 'overdue_transactions',
            label: 'Overdue Transactions',
            variant: 'danger',
            value: s.overdue_transactions ?? '—',
            hint: 'Total SLA exceeded',
        },
    ]
})

// Stable office colours across both pies: build one sorted map from the named
// offices shown in either pie (top 3 each, so at most six).
function sortedOfficeRows(source) {
    return [...(source || [])]
        .filter((r) => r.count > 0)
        .sort((a, b) => b.count - a.count || (a.code || a.name || '').localeCompare(b.code || b.name || ''))
}

const officeColorMap = computed(() => {
    const seen = new Map()
    for (const row of sortedOfficeRows(overdueOfficeSource.value).slice(0, MAX_OFFICE_SLICES)) {
        if (row.id != null) seen.set(row.id, row)
    }
    const sorted = [...seen.values()].sort((a, b) =>
        (a.code || a.name || '').localeCompare(b.code || b.name || ''),
    )
    return new Map(sorted.map((row, i) => [row.id, i]))
})

// Office pies: top 3 offices plus a folded "Other offices" slice. Slices are
// display-only, so they carry no id.
function officePieRows(source) {
    const rows = sortedOfficeRows(source)
    const total = rows.reduce((s, r) => s + r.count, 0)
    if (!total) return []
    const pct = (n) => Math.round((n / total) * 1000) / 10
    const palette = SERIES_PALETTE[themeMode.value]
    const slots = officeColorMap.value
    const named = rows.slice(0, MAX_OFFICE_SLICES)
    const rest = rows.slice(MAX_OFFICE_SLICES)

    const out = named.map((r, i) => ({
        ...r,
        key: `o${r.id ?? r.code ?? i}`,
        id: null,
        label: r.code || r.name || 'No office',
        fullName: r.name || r.code || 'No office',
        pct: pct(r.count),
        color: palette[(slots.get(r.id) ?? i) % palette.length],
    }))

    if (rest.length) {
        const count = rest.reduce((s, r) => s + r.count, 0)
        out.push({
            key: 'other',
            id: null,
            code: null,
            name: OTHER_OFFICES,
            label: OTHER_OFFICES,
            fullName: OTHER_OFFICES,
            count,
            pct: pct(count),
            color: OTHER_COLOR[themeMode.value],
        })
    }

    return out
}

const overdueOfficeRows = computed(() => officePieRows(overdueOfficeSource.value))

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

// Recent Activity: all-time feed (the global Period/Offices filters were
// removed; separate filters can be added here later).
const recent = computed(() => {
    const source = scopeSource.value || []
    // Staff: the feed holds the rest — never duplicates the queue or the
    // in-transit card.
    const feed = isStaff.value
        ? source.filter((tx) => !tx.needs_action && !inTransitIds.value.has(tx.id))
        : source
    return [...feed].sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
})

// Evenly-distributed shortcut rows that fill the staff Get Started card.
const startLinks = computed(() => {
    // Staff with papers already have a queue shortcut in Needs My Action;
    // Get Started shrinks to Help. The full card is the empty state.
    if (isStaff.value && scopeSource.value.length) {
        return [
            { title: 'Help guide', subtitle: 'Step-by-step instructions', icon: 'mdi-book-open-outline', color: '#005EED', tile: '#0B2B66', go: goToHelp },
        ]
    }
    return [
        { title: 'Help guide', subtitle: 'Step-by-step instructions', icon: 'mdi-book-open-outline', color: '#005EED', tile: '#0B2B66', go: goToHelp },
        { title: 'My queue', subtitle: 'Continue where you left off', icon: 'mdi-tray-full', color: '#005EED', tile: '#0EA5A4', go: goToQueue },
    ]
})

// Each donut uses its own measured body key so the two cards don't overwrite
// each other's size calculations.
function donutSize(key) {
    return computed(() => {
        const s = sizes[key]
        if (!fit.value || !s) return 140
        return Math.round(Math.min(156, Math.max(104, Math.min(s.h * 0.82, s.w * 0.48))))
    })
}

const transactionsPieSize = donutSize('transactionsPie')

// Tinted chip/icon in the process's color (same color on every card).
function tintStyle(name) {
    const c = processColor(name)
    return { color: c, background: `color-mix(in srgb, ${c} 14%, transparent)` }
}

// Rows lead with the reference code (every transaction has one; titles are
// optional), then the title and process underneath.
function txRef(tx) {
    return tx.reference_number || `Transaction #${tx.id}`
}

function txSubtitle(tx) {
    return [tx.title, tx.transaction_type?.name || tx.transaction_type_name]
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

// ---- Admins: accounts waiting for approval (Needs My Action) ----
// Superadmins use the system-wide list; office admins use the office
// endpoints, which only return people assigned to their own office.
const accountStore = useAdminUsers({ office: isOfficeAdmin.value })
const accountsLoading = computed(() => accountStore.loading.value)
const accountBusyId = ref(null)
const accountError = ref('')

// Oldest request first, same as the transaction queue.
const pendingAccounts = computed(() =>
    (accountStore.users.value || [])
        .filter((u) => u.pending_approval)
        // The office endpoint already scopes this; keep the guard so a
        // misconfigured source can never surface another office's request.
        .filter(
            (u) =>
                !isOfficeAdmin.value ||
                (myOfficeId.value != null && Number(u.office_id) === Number(myOfficeId.value)),
        )
        .sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0)),
)
// Says so when the card has more rows than fit.
const actionSub = computed(() => {
    if (canApproveAccounts.value) {
        const total = pendingAccounts.value.length
        const more = total > actionRowsFit.value ? `Showing ${actionRowsFit.value} of ${total}` : ''
        const label = isSuperadmin.value
            ? 'Accounts waiting for approval'
            : 'Accounts in your office waiting for approval'
        return more ? `${label}: ${more.toLowerCase()}` : label
    }

    const total = actionQueue.value.length
    return total > actionRowsFit.value ? `Showing ${actionRowsFit.value} of ${total}` : ''
})

const pendingEmptyText = computed(() =>
    isOfficeAdmin.value
        ? 'All clear — no accounts in your office are waiting for approval.'
        : 'All clear — no accounts waiting for approval.',
)

function accountScope(u) {
    const office = u.office?.code || u.office?.name
    const roles = (u.roles || []).map((r) => r.name || r.code).join(', ')
    return [office, roles].filter(Boolean).join(' · ') || '—'
}

function loadAccounts(opts = {}) {
    if (!canApproveAccounts.value) return
    return accountStore.fetchUsers(opts)
        .then(() => { accountError.value = '' })
        .catch((e) => { accountError.value = e?.response?.data?.message || 'Unable to load account requests.' })
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
        message: `${u.name}${u.username ? ` (@${u.username})` : ''} will not get access, and the request will be removed. They can sign up again.`,
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
    router.push(isSuperadmin.value ? '/admin/users' : '/office/users')
}

function goToHelp() {
    router.push('/help')
}

onMounted(async () => {
    // Instant paint from cache when available; the fetches below
    // then refresh everything silently in the background. List caches
    // are per-user; check the current user's slot.
    const uid = auth.user.value?.id ?? storedUserId()
    const warm =
        isCached(CacheKeys.transactionTypes) ||
        isCached(scopedKey(CacheKeys.transactions, uid))
    loading.value = !warm
    const opts = { silent: warm }

    // The visible dashboard cards come first. A slow transaction list must
    // not delay their requests or cover the page with a full-screen loader.
    const primaryCards = canSeeSummary.value ? [loadSummary(), loadChart()] : []
    if (canApproveAccounts.value) loadAccounts()
    if (primaryCards.length) {
        await Promise.allSettled(primaryCards)
        markWorkspaceRefreshed()
    }
    if (isSuperadmin.value) officeStore.fetchAll({ silent: true }).catch(() => {})

    // Populate secondary queues after the headline metrics and chart.
    try {
        await txStore.fetchAll({ ...opts, timeout: 8000 })
    } catch { /* keep defaults */ }

    markWorkspaceRefreshed()
    loading.value = false

    // The page is usable now. Fill the remaining cards in the background:
    // summary first (most visible), then the chart and accounts.
    loadSummary().catch(() => {})
    loadChart()
    loadTopSteps()
    loadOverduePie()
    if (canApproveAccounts.value) loadAccounts()
    if (isSuperadmin.value) {
        officeStore.fetchAll({ silent: true }).catch(() => {})
    }
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
        loadChart({ silent: true })
        loadTopSteps({ silent: true })
        loadOverduePie({ silent: true })
        markWorkspaceRefreshed()
    } catch {
        /* next tick retries */
    }
})

// Signups and approvals change independently of transaction activity.
useSmartPoll(() => loadAccounts({ silent: true }), {
    checkVersion: false,
    enabled: () => canApproveAccounts.value && accountBusyId.value == null,
})

</script>

<style src="../../css/workspace-dashboard.css"></style>
