<template>
    <div class="fit-page">
        <Teleport v-if="!isSuperadmin" defer to="#app-bar-time-meta">
            <div class="dash-time-meta" :title="`${todayLabel}${scopeLabel ? ' · ' + scopeLabel : ''}`">
                <span>{{ todayLabel }}</span>
                <span v-if="scopeLabel" class="dash-time-dot" aria-hidden="true">·</span>
                <span v-if="scopeLabel">{{ scopeLabel }}</span>
            </div>
        </Teleport>
        <LoadingVeil :show="entering" label="dashboard" icon="mdi-view-dashboard-outline" />
        <div class="dash-hello">
            <div class="dash-hello-text">
                <div class="dash-hello-title">{{ greeting }}, {{ firstName }}</div>
                <div class="dash-hello-sub">
                    <template v-if="refreshedLabel">Updated {{ refreshedLabel }}</template>
                </div>
            </div>
            <div class="dash-hello-actions">
                <!-- Overview cards, or the monitoring Reports (superadmins and
                     office admins); both follow Period / Offices below. -->
                <v-btn-toggle
                    v-if="canSeeSummary"
                    v-model="view"
                    mandatory
                    density="comfortable"
                    color="primary"
                    variant="outlined"
                    divided
                    rounded="lg"
                    class="dash-view"
                >
                    <v-btn value="overview" prepend-icon="mdi-view-dashboard-outline" class="text-none">Overview</v-btn>
                    <v-btn value="reports" prepend-icon="mdi-chart-box-outline" class="text-none">Reports</v-btn>
                </v-btn-toggle>
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
                    <v-menu
                        v-model="officeMenuOpen"
                        :close-on-content-click="false"
                        location="bottom end"
                        offset="8"
                    >
                        <template #activator="{ props }">
                            <button
                                v-bind="props"
                                type="button"
                                class="office-trigger"
                                :class="{ 'is-open': officeMenuOpen }"
                                aria-haspopup="listbox"
                                aria-controls="dash-office-panel"
                            >
                                <span class="office-seal" :class="{ 'is-empty': !officePickerSeal }" aria-hidden="true">
                                    <img v-if="officePickerSeal?.icon" :src="officePickerSeal.icon" alt="" />
                                    <span v-else-if="officePickerSeal">{{ officePickerSeal.initials }}</span>
                                    <v-icon v-else size="16">mdi-office-building-outline</v-icon>
                                </span>
                                <span class="office-trigger-copy">
                                    <span class="office-trigger-label">Offices</span>
                                    <span class="office-trigger-value" :title="officeFilterSummary">{{ officeFilterSummary }}</span>
                                </span>
                                <v-icon class="office-trigger-chevron" size="18" aria-hidden="true">mdi-chevron-down</v-icon>
                            </button>
                        </template>
                        <v-card
                            id="dash-office-panel"
                            class="office-panel"
                            rounded="lg"
                            elevation="8"
                            role="dialog"
                            aria-label="Choose offices"
                        >
                            <div class="office-panel-head">
                                <input
                                    ref="officeSearchEl"
                                    v-model="officeSearch"
                                    class="office-search"
                                    type="search"
                                    placeholder="Search by name or abbreviation"
                                    aria-label="Search offices"
                                />
                                <button type="button" class="office-clear" @click="clearOfficeFilter">
                                    Show all offices
                                </button>
                            </div>
                            <div
                                class="office-grid"
                                role="listbox"
                                aria-label="Offices"
                                aria-multiselectable="true"
                            >
                                <button
                                    v-for="o in filteredOfficeOptions"
                                    :key="o.value"
                                    type="button"
                                    class="office-card"
                                    :class="{ 'is-selected': officeIds.has(o.value) }"
                                    role="option"
                                    :aria-selected="officeIds.has(o.value) ? 'true' : 'false'"
                                    :aria-label="o.office?.name || o.title"
                                    v-tooltip="o.office?.name || o.title"
                                    @click="toggleOffice(o.value)"
                                    @mouseenter="officeHover = o"
                                    @mouseleave="officeHover = null"
                                    @focus="officeHover = o"
                                    @blur="officeHover = null"
                                >
                                    <span class="office-seal" aria-hidden="true">
                                        <img v-if="o.icon" :src="o.icon" alt="" />
                                        <span v-else>{{ o.initials }}</span>
                                    </span>
                                    <span class="office-card-abbr">{{ o.code }}</span>
                                </button>
                                <div v-if="!filteredOfficeOptions.length" class="office-no-match">
                                    No offices match “{{ officeSearch }}”. Try the abbreviation.
                                </div>
                            </div>
                            <div class="office-panel-foot">
                                <template v-if="officeHover">
                                    <b>{{ officeHover.code }}</b> · {{ officeHover.office?.name || officeHover.title }}
                                </template>
                                <template v-else-if="selectedOffices.length">
                                    Selected: <b>{{ selectedOfficeNames }}</b>
                                </template>
                                <template v-else>
                                    Hover or focus an office to see its full name.
                                </template>
                            </div>
                        </v-card>
                    </v-menu>
                </template>
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
        <!-- The headline numbers stay on top. -->
        <div v-if="canSeeSummary">
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
                <MonitoringReportPanel :period="summaryPeriod" :offices="officeFilter" :scope-label="reportScopeLabel" />
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
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-chart-bar</v-icon>
                            </v-avatar>
                            <span class="text-subtitle-1 font-weight-bold dash-head-title">{{ scopeOverviewTitle }}</span>
                        </v-card-title>
                                                <v-card-text class="pa-2 d-flex flex-column dash-body">
                            <GroupedBarChart
                                :series="graphSeries"
                                :group-labels="graphGroups"
                                :loading="summaryLoading && !summary"
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
                        </v-card-title>
                        <v-card-text v-fit-body="'transactionsPie'" class="pa-2 px-3 process-pie-body dash-body" :class="{ 'summary-stale': summaryLoading && summary }">
                            <OfficeDonut
                                v-if="overdueOfficeRows.length"
                                :slices="overdueOfficeRows"
                                :size="transactionsPieSize"
                                aria-label="Overdue transactions by office"
                            />
                            <div v-else-if="summary" class="text-caption text-medium-emphasis">
                                No overdue transactions.
                            </div>
                        </v-card-text>
                    </v-card>
                </div>
                <div v-else-if="id === 'stepsoffice'" class="dash-slot" :class="cardClass(id)" :style="slotStyle(id)" :data-card="id">
                    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
                        <v-card-title class="d-flex align-center lgu-head dash-head">
                            <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                                <v-icon color="#005EED" size="20">mdi-chart-donut</v-icon>
                            </v-avatar>
                            <div style="min-width: 0">
                                <div class="text-subtitle-1 font-weight-bold">Overdue Steps by Office</div>
                                <div class="dash-panel-sub">Which offices hold the most late steps</div>
                            </div>
                        </v-card-title>
                        <v-card-text v-fit-body="'stepsPie'" class="pa-2 px-3 process-pie-body dash-body" :class="{ 'summary-stale': summaryLoading && summary }">
                            <OfficeDonut
                                v-if="overdueStepOfficeRows.length"
                                :slices="overdueStepOfficeRows"
                                :size="stepsPieSize"
                                aria-label="Overdue steps by office"
                            />
                            <div v-else-if="summary" class="text-caption text-medium-emphasis">
                                No overdue steps.
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
                                <div v-if="actionSub" class="dash-panel-sub text-truncate">{{ actionSub }}</div>
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
                                v-if="!accountsLoading && !pendingAccounts.length"
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
import GroupedBarChart from '@/components/GroupedBarChart.vue'
import OfficeDonut from '@/components/OfficeDonut.vue'
import MonitoringReportPanel from '@/components/MonitoringReportPanel.vue'
import LoadingVeil from '@/components/LoadingVeil.vue'
import { processColor, processIcon, txProcessName, isPastLimit } from '@/utils/processColor'
import { officeIcon } from '@/utils/officeIcons'
import {
    periodOptions as dashPeriodOptions,
    periodBuckets,
    periodStart,
} from '@/utils/dashPeriod'
import { isCached, readCache, writeCache, CacheKeys, scopedKey, storedUserId } from '@/composables/useCache'

const router = useRouter()
const route = useRoute()
const auth = useAuth()
const { api } = useApi()

const txStore = useTransactions()
const officeStore = useOffices()

const loading = ref(false)
// Full-page loader shown each time the Dashboard is opened, until the
// first fetch of the cards and lists finishes.
const entering = ref(true)
const refreshedAt = ref(null)

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
const reportScopeLabel = computed(() => {
    if (!isSuperadmin.value) {
        const office = auth.user.value?.office
        return `${office?.code || office?.name || 'Your office'} (filed by or passing through it)`
    }
    return officeScopeChips.value.length ? officeScopeLabel.value : 'All offices'
})

// Superadmins approve accounts from any office; office admins approve
// sign-ups that chose their office.
const canApproveAccounts = computed(() => isSuperadmin.value || isOfficeAdmin.value)
const myOfficeId = computed(
    () => auth.user.value?.office_id ?? auth.user.value?.office?.id ?? null,
)

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
        return ['graph', 'byprocess', 'stepsoffice', 'action', 'recent']
    }
    return ['action', 'intransit', 'recent', 'start']
})
// Width of each grid slot, out of 12 columns; two rows.
const slotSpans = computed(() => {
    return canSeeSummary.value ? [6, 3, 3, 6, 6] : [8, 4, 8, 4]
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

// Muted series colors for the overdue-by-office pie. They sit close to the
// app's blue/teal/slate design; gray is reserved for "Other offices".
const SERIES_PALETTE = {
    light: ['#4F7FBF', '#5F9A93', '#7E80B8', '#B08345', '#8C7B9E', '#6F8FA8'],
    dark: ['#7FA6DD', '#8AC2BA', '#A9A9DC', '#D8B173', '#B7A5C9', '#94B2C9'],
}
const OTHER_OFFICES = 'Other offices'
const OTHER_COLOR = { light: '#8B95A5', dark: '#7E8899' }
const MAX_OFFICE_SLICES = 3

// Monthly status bars: calmer sage/ochre/rose so the chart reads comfortably
// while Completed, In progress, and Overdue stay distinguishable.
const STATUS_COLORS = {
    light: { completed: '#4F8A6E', in_process: '#B08345', overdue: '#B0616B' },
    dark: { completed: '#86C2A4', in_process: '#D8B173', overdue: '#D99AA2' },
}

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

const officeOptions = computed(() =>
    [...(officeStore.items.value || [])]
        .sort((a, b) => String(a.name).localeCompare(String(b.name)))
        .map((o) => {
            const title = o.code ? `${o.name} (${o.code})` : o.name
            return {
                title,
                value: o.id,
                code: o.code || o.name,
                office: o,
                icon: officeIcon(o),
                initials: officeInitials(o),
            }
        })
)

const officeMenuOpen = ref(false)
const officeSearch = ref('')
const officeSearchEl = ref(null)
const officeHover = ref(null)

const selectedOffices = computed(() =>
    officeOptions.value.filter((o) => officeIds.value.has(o.value))
)
const officePickerSeal = computed(() => selectedOffices.value[0] || null)
const officeFilterSummary = computed(() => {
    const count = officeFilter.value?.length || 0
    if (!count) return 'All offices'
    const codes = selectedOffices.value.map((o) => o.code)
    if (!codes.length) return 'All offices'
    return codes.length <= 2 ? codes.join(', ') : `${codes.length} offices`
})
const selectedOfficeNames = computed(() => {
    const names = selectedOffices.value.map((o) => o.office?.name || o.code)
    if (names.length <= 2) return names.join(', ')
    return `${names.slice(0, 2).join(', ')} +${names.length - 2} more`
})
const filteredOfficeOptions = computed(() => {
    const q = officeSearch.value.trim().toLowerCase()
    if (!q) return officeOptions.value
    return officeOptions.value.filter((o) =>
        `${o.code} ${o.office?.name || ''}`.toLowerCase().includes(q)
    )
})

function toggleOffice(id) {
    const next = new Set(officeFilter.value || [])
    if (next.has(id)) next.delete(id)
    else next.add(id)
    officeFilter.value = [...next]
}

function clearOfficeFilter() {
    officeFilter.value = []
}

watch(officeMenuOpen, async (open) => {
    officeSearch.value = ''
    officeHover.value = null
    if (!open) return
    await nextTick()
    officeSearchEl.value?.focus()
})
watch(officeSearch, () => {
    officeHover.value = null
})
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
const scopeOverviewTitle = computed(() =>
    officeScopeLabel.value ? `${officeScopeLabel.value} Transaction Status` : 'Transaction Status'
)

watch(officeOptions, (options) => {
    const ids = new Set(options.map((o) => o.value))
    if (officeFilter.value?.some((id) => !ids.has(id))) {
        officeFilter.value = officeFilter.value.filter((id) => ids.has(id))
    }
})

// ---- Period filter ----
// All time by default so pending work never hides on a week/month
// rollover; switchable to this week (current Mon–Sun week) or one of the
// last 12 months (Manila calendar). It drives the tiles, the By Process pie
// and Recent Activity. Completed counts by finalize date, the rest by
// created date (server side). The status graph has its own fixed 3-month
// window. Declared before the graph: its computeds can run during setup when
// the transaction list is already cached (e.g. clicking Dashboard from
// another page).
const summaryPeriod = ref('all')
const periodOptions = computed(() => dashPeriodOptions())

// ---- Graph: transactions by status over the last two months + this month ----
// Server-side counts: completed by finalize date, open rows by created date.
const graphGroups = computed(() => (summary.value?.monthly || []).map((m) => m.label))

const graphEmptyText = computed(() =>
    officeScopeLabel.value
        ? `No ${officeScopeLabel.value} transactions in the last 3 months`
        : 'No transactions in the last 3 months'
)
const graphAriaLabel = computed(() =>
    officeScopeLabel.value
        ? `${officeScopeLabel.value} transactions by status per month, last 3 months`
        : 'Transactions by status per month, last 3 months'
)

// One bar per status in each month: green completed, amber in process, red overdue.
const graphSeries = computed(() => {
    const rows = summary.value?.monthly || []
    const palette = STATUS_COLORS[themeMode.value]
    return [
        { label: 'Completed', color: palette.completed, values: rows.map((r) => r.completed || 0) },
        { label: 'In progress', color: palette.in_process, values: rows.map((r) => r.in_process || 0) },
        { label: 'Overdue', color: palette.overdue, values: rows.map((r) => r.overdue || 0) },
    ]
})

// ---- Transaction Summary card (superadmin) ----
// (The Period filter, summaryPeriod, is declared above the graph.)

const summary = ref(null)
const summaryLoading = ref(false)
const summaryError = ref('')

// Same scope and period as the tiles/pie. Also carries the fixed 3-month
// monthly status series used by the graph.
// No office assigned: the backend aggregates all offices.
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
                ? 'The transaction summary took too long to load. Change the period or refresh the page.'
                : (e?.response?.data?.message || 'Failed to load the summary.')
        }
    } finally {
        if (mine === summaryRequest) summaryLoading.value = false
    }
}
watch(summaryQuery, loadSummary, { deep: true })

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
    for (const source of [summary.value?.overdue_by_office, summary.value?.overdue_steps_by_office]) {
        for (const row of sortedOfficeRows(source).slice(0, MAX_OFFICE_SLICES)) {
            if (row.id != null) seen.set(row.id, row)
        }
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

const overdueOfficeRows = computed(() => officePieRows(summary.value?.overdue_by_office))
const overdueStepOfficeRows = computed(() => officePieRows(summary.value?.overdue_steps_by_office))

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
const stepsPieSize = donutSize('stepsPie')

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
    router.push(isSuperadmin.value ? '/admin/users' : '/office/users')
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

    // Critical path first. The full-page veil waits only for this fetch, so
    // it must not queue behind summary/filter/account requests — on the
    // single-threaded dev server every request is processed in order.
    try {
        // Cap the first list fetch so a stalled request can never keep the
        // full-page veil up forever. The list still updates if it finishes
        // after the timeout; the page just stops blocking on it.
        await txStore.fetchAll({ ...opts, timeout: 8000 })
    } catch { /* keep defaults */ }

    refreshedAt.value = new Date()
    loading.value = false
    entering.value = false

    // The page is usable now. Fill the remaining cards in the background:
    // summary first (most visible), then accounts, then filter lookups.
    loadSummary().catch(() => {})
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
/* Date + office scope, teleported into the app bar above the clock. */
.dash-time-meta {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 10px;
    font-weight: 600;
    line-height: 1.1;
    color: rgba(var(--v-theme-on-surface), 0.55);
    white-space: nowrap;
}
.dash-time-dot {
    opacity: 0.55;
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
        grid-template-rows: minmax(0, 1.25fr) minmax(0, 1fr);
    }
    /* Reports view: one card takes the whole grid height. */
    .dash-grid--single {
        grid-template-rows: minmax(0, 1fr);
    }
    .dash-body .start-row {
        flex: 1 1 0;
        max-height: 72px;
        min-height: 0;
    }
    /* The pie's tooltip may rise over the card head. */
    .dash-slot[data-card='byprocess'] > .v-card,
    .dash-slot[data-card='byprocess'] .process-pie-body,
    .dash-slot[data-card='stepsoffice'] > .v-card,
    .dash-slot[data-card='stepsoffice'] .process-pie-body {
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
/* Small screens: the graph head wraps below the title. */
@media (max-width: 1099.98px) {
    .dash-slot[data-card='graph'] .dash-head {
        flex-wrap: wrap;
        row-gap: 10px;
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
/* ---- Transaction Summary cards ---- */
.summary-row {
    display: flex;
    align-items: stretch;
    flex-wrap: wrap;
    gap: 12px;
}
.summary-strip {
    display: grid;
    grid-template-columns: minmax(0, 1fr);
    flex: 1 1 320px;
    max-width: 360px;
    border: 1px solid rgba(var(--v-theme-on-surface), 0.12);
    border-radius: 14px;
    background: rgb(var(--v-theme-surface));
    overflow: hidden;
}
.summary-seg {
    --strip-accent: #c62f3b;
    display: flex;
    align-items: center;
    gap: 16px;
    min-width: 0;
    padding: 18px 24px;
    border: 0;
    border-right: 1px solid rgba(var(--v-theme-on-surface), 0.12);
    background: color-mix(in srgb, var(--strip-accent) 7%, rgb(var(--v-theme-surface)));
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
    text-align: left;
}
.summary-seg:last-child {
    border-right: 0;
}
.summary-seg--danger {
    --strip-accent: #c62f3b;
}
html.dark .summary-seg--danger {
    --strip-accent: #ff7a85;
}
.summary-seg-num {
    flex: 0 0 auto;
    display: flex;
    align-items: center;
    min-width: 0;
    font-size: 56px;
    font-weight: 700;
    letter-spacing: -0.03em;
    line-height: 1;
    font-variant-numeric: tabular-nums;
    color: rgb(var(--v-theme-on-surface));
}
.summary-seg-copy {
    display: flex;
    flex-direction: column;
    gap: 2px;
    min-width: 0;
}
.summary-seg-label {
    font-size: 17px;
    font-weight: 700;
    line-height: 1.2;
    color: var(--strip-accent);
}
.summary-seg-hint {
    font-size: 12px;
    line-height: 1.2;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
@media (max-width: 760px) {
    .summary-row {
        flex-direction: column;
    }
    .summary-strip {
        flex: 0 0 auto;
        width: 100%;
        max-width: none;
    }
    .summary-seg {
        padding: 14px 18px;
    }
    .summary-seg-num {
        font-size: 44px;
    }
}
.dash-hello-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
}
.dash-view {
    height: 40px !important;
}
.dash-view :deep(.v-btn) {
    height: 40px !important;
    letter-spacing: 0;
    font-weight: 600;
}
/* Explicit width too: Firefox sizes the wrapping row from the select's
   content, not its flex-basis, and stacked the two filters. */
.dash-filter {
    flex: 0 0 200px;
    width: 200px;
    min-width: 170px;
}
/* ---- Office picker (dashboard header) ---- */
.office-trigger {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 230px;
    max-width: 260px;
    min-height: 44px;
    padding: 6px 12px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 10px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
    text-align: left;
    cursor: pointer;
    transition: border-color 0.15s ease, box-shadow 0.15s ease, background-color 0.15s ease;
}
.office-trigger:hover {
    border-color: rgba(var(--v-theme-primary), 0.55);
}
.office-trigger.is-open {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 2px rgba(var(--v-theme-primary), 0.16);
}
.office-seal {
    display: grid;
    place-items: center;
    width: 26px;
    height: 26px;
    flex: none;
    overflow: hidden;
    border: 2px solid rgb(var(--v-theme-surface));
    border-radius: 50%;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 1px rgba(var(--v-border-color), 0.35);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.02em;
    line-height: 1;
}
.office-seal.is-empty {
    background: rgba(var(--v-theme-on-surface), 0.1);
    color: rgba(var(--v-theme-on-surface), 0.6);
}
.office-seal img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
}
.office-trigger-copy {
    display: flex;
    flex: 1 1 auto;
    flex-direction: column;
    min-width: 0;
}
.office-trigger-label {
    color: rgba(var(--v-theme-on-surface), 0.6);
    font-size: 11px;
    line-height: 1;
}
.office-trigger-value {
    display: block;
    overflow: hidden;
    font-weight: 600;
    line-height: 1.3;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.office-trigger-chevron {
    flex: none;
    color: rgba(var(--v-theme-on-surface), 0.55);
    transition: transform 0.15s ease;
}
.office-trigger.is-open .office-trigger-chevron {
    transform: rotate(180deg);
}
.office-panel {
    width: min(640px, calc(100vw - 32px));
    padding: 16px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    background: rgb(var(--v-theme-surface));
}
.office-panel-head {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 14px;
}
.office-search {
    flex: 1 1 auto;
    min-width: 0;
    min-height: 40px;
    padding: 10px 12px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 8px;
    background: rgba(var(--v-theme-on-surface), 0.035);
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
}
.office-search:focus-visible {
    outline: 3px solid rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.office-clear {
    padding: 8px;
    border: 0;
    background: none;
    color: rgb(var(--v-theme-primary));
    font: inherit;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
}
.office-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 10px;
    max-height: 340px;
    padding: 4px 4px 8px;
    overflow-y: auto;
}
.office-card {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    padding: 14px 8px 12px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
    cursor: pointer;
    transition: border-color 0.12s ease, background-color 0.12s ease, transform 0.12s ease;
}
.office-card:hover {
    border-color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.08);
    transform: translateY(-2px);
}
.office-card.is-selected {
    border-color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.12);
    box-shadow: 0 0 0 2px rgba(var(--v-theme-primary), 0.25);
}
.office-card.is-selected::after {
    content: "✓";
    position: absolute;
    top: 6px;
    right: 6px;
    display: grid;
    place-items: center;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
    font-size: 12px;
    font-weight: 700;
}
.office-card .office-seal {
    width: 48px;
    height: 48px;
    border-width: 3px;
    font-size: 13px;
}
.office-card-abbr {
    max-width: 100%;
    overflow: hidden;
    font-size: 14px;
    font-weight: 700;
    text-align: center;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.office-no-match {
    grid-column: 1 / -1;
    padding: 24px;
    color: rgba(var(--v-theme-on-surface), 0.55);
    text-align: center;
}
.office-panel-foot {
    min-height: 34px;
    margin-top: 10px;
    padding-top: 12px;
    border-top: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    color: rgba(var(--v-theme-on-surface), 0.55);
    font-size: 13px;
}
.office-panel-foot b {
    color: rgb(var(--v-theme-on-surface));
}
@media (max-width: 620px) {
    .office-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
    }
    .office-trigger {
        min-width: 200px;
    }
}
.dash-panel-sub {
    font-size: 0.75rem;
    font-weight: 400;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
/* Office donut card body: the donut component fills the available space. */
.process-pie-body {
    display: flex;
    align-items: center;
    flex: 1 1 auto;
    min-height: 0;
}
.summary-stale {
    opacity: 0.6;
    transition: opacity 0.15s;
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
