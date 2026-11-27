<template>
    <div class="fit-page workspace-dashboard workspace-dashboard--staff">
        <!-- Full-page loader on every visit; later polls refresh quietly. -->
        <LoadingVeil :show="loading" label="home" icon="mdi-home-city-outline" />

        <!-- View + Period filters above the work cards. -->
        <div class="portal-toolbar">
            <v-select
                v-model="view"
                :items="viewOptions"
                label="View"
                prepend-inner-icon="mdi-account-switch-outline"
                variant="outlined"
                density="compact"
                rounded="lg"
                hide-details
                class="home-period home-view"
            />
            <v-select
                v-model="period"
                :items="periodOptions"
                label="Period"
                prepend-inner-icon="mdi-calendar-range"
                variant="outlined"
                density="compact"
                rounded="lg"
                hide-details
                class="home-period"
            />
        </div>

        <v-alert
            v-if="user && !user.office"
            type="warning"
            variant="tonal"
            rounded="lg"
            class="portal-office-warning"
        >
            <template v-if="isClerk">Your account needs an assigned office before step counts can be shown.</template>
            <template v-else>Your account has no office assigned yet, so you will only see transactions waiting on your role.</template>
            Ask an administrator to assign your office.
        </v-alert>

        <!-- Numbers for the user's office / role -->
                <div class="portal-tiles" :class="{ 'clerk-personal-tiles': isClerk && !isOfficeView }">
                    <template v-for="tile in tiles" :key="tile.key">
                    <component
                        :is="tile.go ? 'button' : 'div'"
                        v-if="isClerk"
                        :type="tile.go ? 'button' : undefined"
                        class="summary-strip clerk-summary-card"
                        :class="{ 'clerk-summary-card--static': !tile.go }"
                        :role="tile.go ? undefined : 'group'"
                        :aria-label="`${tile.label}: ${tile.value}`"
                        @click="tile.go && tile.go()"
                    >
                        <span class="summary-seg" :class="`summary-seg--${tile.variant}`">
                            <span class="summary-seg-icon" aria-hidden="true"><v-icon size="28">{{ tile.icon }}</v-icon></span>
                            <span class="summary-seg-num">
                                <v-progress-circular v-if="loading" indeterminate tag="span" size="22" width="3" color="grey-darken-1" />
                                <template v-else>{{ tile.value }}</template>
                            </span>
                            <span class="summary-seg-copy">
                                <span class="summary-seg-label">{{ tile.label }}</span>
                                <span class="summary-seg-hint">{{ tile.hint }}</span>
                            </span>
                        </span>
                        <span v-if="tile.go" class="clerk-card-cta" aria-hidden="true">View list <v-icon size="16">mdi-chevron-down</v-icon></span>
                    </component>
                    <StatCard
                        v-else
                        :label="tile.label"
                        :value="tile.value"
                        :hint="tile.hint"
                        :variant="tile.variant"
                        :icon="tile.icon"
                        :loading="loading"
                        :clickable="Boolean(tile.go)"
                        :cta="tile.go ? 'View list' : ''"
                        @activate="tile.go && tile.go()"
                    />
                    </template>
                </div>

        <v-dialog v-model="stepListOpen" max-width="720" scrollable>
            <v-card>
                <v-card-title class="d-flex align-center flex-wrap ga-2">
                    Needs My Action
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" aria-label="Close step list" @click="stepListOpen = false" />
                </v-card-title>
                <v-card-text>
                    <v-alert v-if="!selectedStepRows.length" type="info" variant="tonal">No matching steps.</v-alert>
                    <v-list v-else lines="three">
                        <v-list-item v-for="step in selectedStepRows" :key="step.id">
                            <v-list-item-title>{{ step.reference_number }}</v-list-item-title>
                            <v-list-item-subtitle class="text-wrap">{{ step.step_name }}<template v-if="step.title"> · {{ step.title }}</template></v-list-item-subtitle>
                            <v-list-item-subtitle>{{ step.reason }}</v-list-item-subtitle>
                            <template #append>
                                <v-btn variant="text" color="primary" @click="router.push(`/portal/transactions/${step.transaction_id}`)">Open</v-btn>
                            </template>
                        </v-list-item>
                    </v-list>
                </v-card-text>
            </v-card>
        </v-dialog>

        <div class="dash-grid" :class="{ 'clerk-bottom-grid': isClerk }">
            <!-- Transaction Status for the account's office: the same chart
                 as the admin dashboard, scoped to the papers this office
                 filed. Needs an office to have anything to show. -->
            <div v-if="user?.office" class="dash-slot" :data-card="isClerk ? 'graph' : undefined" :style="{ '--span': isClerk ? 8 : 12 }">
                <TransactionStatusCard :view="view" />
            </div>

            <!-- Steps this user can act on: received work, returns, and
                 arrivals for their role. Top three rows; View all opens the
                 full step list. -->
            <div class="dash-slot" style="--span: 6">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center lgu-head dash-head">
                        <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                            <v-icon color="#005EED" size="20">mdi-tray-arrow-down</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Needs My Action</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="stepListOpen = true">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text class="pa-1 dash-body">
                        <TxMiniList
                            :rows="needsActionRows"
                            :loading="loading"
                            empty="No steps are waiting for your action."
                            @open="(tx) => router.push(`/portal/transactions/${tx.id}`)"
                        />
                    </v-card-text>
                </v-card>
            </div>

            <!-- In my office (oldest first); full width when it is the only list -->
            <div v-if="!isClerk" class="dash-slot" style="--span: 6">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center lgu-head dash-head">
                        <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                            <v-icon color="#005EED" size="20">mdi-office-building-outline</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Office Transactions</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="openList('office')">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text v-fit-body="'office'" class="pa-1 dash-body">
                        <TxMiniList
                            :rows="officeRows.slice(0, rows('office', LIST_ROW_PX, SUMMARY_ROWS))"
                            :loading="loading"
                            empty="No transactions in your office yet."
                            @open="(tx) => router.push({ path: `/portal/transactions/${tx.id}`, query: { from: 'portal' } })"
                        />
                    </v-card-text>
                </v-card>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import LoadingVeil from "@/components/LoadingVeil.vue";
import { useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { markWorkspaceRefreshed } from "@/composables/useWorkspaceHeader";
import { useFitScreen } from "@/composables/useFitScreen";
import StatCard from "@/components/StatCard.vue";
import TxMiniList from "@/components/portal/TxMiniList.vue";
import TransactionStatusCard from "@/components/portal/TransactionStatusCard.vue";
import { monthValue, periodOptions as dashPeriodOptions } from "@/utils/dashPeriod";

const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const { vFitBody, rows } = useFitScreen();

const loading = ref(true);
const summary = ref(null);
const officeSummary = ref(null);
const officeRows = ref([]);

// Period filter: every work card below follows it. The shared option list is
// filtered so the staff portal offers Today, This week and months, without
// All time. View switches the five cards and the chart between Personal and
// whole-office scope; Needs My Action always stays personal.
const period = ref(monthValue(new Date()));
const periodOptions = computed(() => dashPeriodOptions().filter((option) => option.value !== "all"));
const view = ref("personal");
const viewOptions = [
    { title: "Personal", value: "personal" },
    { title: "Office", value: "office" },
];
const isOfficeView = computed(() => view.value === "office");
const periodPhrase = computed(() => {
    if (period.value === "today") return "today";
    if (period.value === "this_week") return "this week";
    if (period.value === "all") return "across all time";
    const label = periodOptions.value.find((option) => option.value === period.value)?.title || period.value;
    return `in ${label}`;
});

// Clerk layout puts the chart and Needs My Action side by side; other staff
// use the full-width chart row with two list cards underneath.
const isClerk = computed(() => user.value?.roles?.some((role) => role.code === "clerk") === true);
const stepListOpen = ref(false);
const selectedStepRows = computed(() => summary.value?.needs_action?.rows ?? []);

// Personal step cards, in the order requested for the staff home.
const personalTiles = computed(() => {
    const m = summary.value?.step_metrics || {};
    return [
        {
            key: "entered_today",
            label: "Entered",
            value: m.entered ?? 0,
            hint: `Steps for your role that entered your office ${periodPhrase.value}.`,
            icon: "mdi-door-open",
            variant: "success",
        },
        {
            key: "received_today",
            label: "Received",
            value: m.received ?? 0,
            hint: `Steps you received ${periodPhrase.value}.`,
            icon: "mdi-inbox-arrow-down",
            variant: "info",
        },
        {
            key: "in_process",
            label: "In progress",
            value: summary.value?.in_process ?? 0,
            hint: `Office transactions still moving ${periodPhrase.value}.`,
            icon: "mdi-timer-sand",
            variant: "warning",
            go: () => openList("office"),
        },
        {
            key: "overdue_work",
            label: "Overdue Steps",
            value: m.overdue_work ?? 0,
            hint: `Your open received steps ${periodPhrase.value} — overdue or in progress.`,
            icon: "mdi-timer-alert-outline",
            variant: "danger",
        },
        {
            key: "released",
            label: "Release",
            value: m.released ?? 0,
            hint: `Steps you completed ${periodPhrase.value}.`,
            icon: "mdi-send-check-outline",
            variant: "info",
        },
    ];
});

// Office view mirrors the office-admin dashboard cards and their order.
const officeTiles = computed(() => {
    const m = officeSummary.value?.office_step_metrics || {};
    const s = officeSummary.value || {};
    return [
        {
            key: "office_entered",
            label: "Entered",
            value: m.entered ?? 0,
            hint: `Steps that entered your office ${periodPhrase.value}.`,
            icon: "mdi-door-open",
            variant: "success",
        },
        {
            key: "office_received",
            label: "Received",
            value: m.received ?? 0,
            hint: `Steps received by your office ${periodPhrase.value}.`,
            icon: "mdi-inbox-arrow-down",
            variant: "info",
        },
        {
            key: "office_in_progress",
            label: "In progress",
            value: m.in_progress ?? 0,
            hint: `Steps received by your office ${periodPhrase.value} and still in progress.`,
            icon: "mdi-timer-sand",
            variant: "warning",
        },
        {
            key: "office_released",
            label: "Release",
            value: m.released ?? 0,
            hint: `Steps completed by your office ${periodPhrase.value}.`,
            icon: "mdi-send-check-outline",
            variant: "info",
        },
        {
            key: "office_overdue_steps",
            label: "Overdue Steps",
            value: s.overdue_steps ?? 0,
            hint: `Individual steps over SLA at your office ${periodPhrase.value}.`,
            icon: "mdi-timer-alert-outline",
            variant: "danger",
        },
        {
            key: "office_overdue_transactions",
            label: "Overdue Transactions",
            value: s.overdue_transactions ?? 0,
            hint: `Transactions over their total SLA at your office ${periodPhrase.value}.`,
            icon: "mdi-file-clock-outline",
            variant: "danger",
        },
    ];
});

const tiles = computed(() => (isOfficeView.value ? officeTiles.value : personalTiles.value));

const NEEDS_ACTION_META = {
    receive: { label: "Receive", color: "primary" },
    return: { label: "Return", color: "warning" },
    release: { label: "Release", color: "success" },
};
const needsActionRows = computed(() => [...(summary.value?.needs_action?.rows ?? [])]
    .sort((a, b) => Number(b.id) - Number(a.id))
    .slice(0, 3)
    .map((step) => {
        const meta = NEEDS_ACTION_META[step.action];
        return {
            id: step.transaction_id,
            reference_number: step.reference_number,
            title: [step.step_name, step.reason, step.title].filter(Boolean).join(" · "),
            action_label: meta?.label,
            action_color: meta?.color,
        };
    }));

function openList(tab) {
    router.push({ path: "/portal/transactions", query: { tab } });
}

// Home is a summary: each list shows the rows that fit its card (3 on small
// screens), the oldest first (ascending by creation time). The lists come
// newest-first from the server, so the oldest rows sit on the last page(s):
// read page 1 for the total, then the last page, plus the one before it when
// the last page is short.
const SUMMARY_ROWS = 3;
const FETCH_ROWS = 12;
const LIST_ROW_PX = 46;

const byCreatedAsc = (a, b) =>
    new Date(a.created_at).getTime() - new Date(b.created_at).getTime() || Number(a.id) - Number(b.id);

async function oldestRows(url) {
    const params = { per_page: FETCH_ROWS };
    const first = await api.get(url, { params });
    const total = first.data?.meta?.total ?? (first.data?.data ?? []).length;
    const last = first.data?.meta?.last_page ?? 1;
    let rows = first.data?.data ?? [];
    if (last > 1) {
        const pages = total % FETCH_ROWS ? [last - 1, last] : [last];
        const res = await Promise.all(pages.map((page) => api.get(url, { params: { ...params, page } })));
        rows = res.flatMap((r) => r.data?.data ?? []);
    }
    return { rows: [...rows].sort(byCreatedAsc).slice(0, FETCH_ROWS), total };
}

// Latest request wins, so a quick filter switch never shows older numbers.
let summaryRequest = 0;
const fetchSummary = () => api.get("/api/portal/summary", {
    params: { period: period.value },
});
const fetchOfficeSummary = () => api.get("/api/portal/office-summary", {
    params: { period: period.value },
});

async function loadMetrics() {
    const mine = ++summaryRequest;
    const [sum, office] = await Promise.allSettled([
        fetchSummary(),
        isOfficeView.value ? fetchOfficeSummary() : Promise.resolve(null),
    ]);
    if (mine !== summaryRequest) return;
    if (sum.status === "fulfilled") summary.value = sum.value.data;
    if (office.status === "fulfilled" && office.value) officeSummary.value = office.value.data;
    if (sum.status === "fulfilled" || (office.status === "fulfilled" && office.value)) {
        markWorkspaceRefreshed();
    }
}
watch([period, view], loadMetrics);

async function load() {
    const officeRowsPromise = isClerk.value
        ? Promise.resolve({ rows: [] })
        : oldestRows("/api/admin/transactions");
    await Promise.all([
        loadMetrics(),
        officeRowsPromise.then((result) => { officeRows.value = result.rows; }).catch(() => {}),
    ]);
    loading.value = false;
}

onMounted(() => {
    load();
});
useSmartPoll(load);
</script>

<style src="../../../css/workspace-dashboard.css"></style>

<style scoped>
.portal-toolbar {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    flex-wrap: wrap;
    gap: 12px;
}
.portal-office-warning {
    margin-bottom: 14px;
}
@media (max-width: 600px) {
    .portal-toolbar {
        justify-content: stretch;
    }
    .portal-toolbar .home-period {
        flex: 1 1 100%;
        min-width: 0;
    }
}
/* Cap the staff tiles at three columns so the icon + number + copy have
   enough room. Six cards then sit as two rows of three instead of being
   squeezed into one row where labels and hints clip. */
.workspace-shell .workspace-dashboard--staff .portal-tiles {
    grid-template-columns: repeat(3, minmax(0, 1fr));
}
@media (max-width: 1359px) {
    .workspace-shell .workspace-dashboard--staff .portal-tiles {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}
@media (max-width: 759px) {
    .workspace-shell .workspace-dashboard--staff .portal-tiles {
        grid-template-columns: minmax(0, 1fr);
    }
}
@media (min-width: 1100px) {
    .workspace-shell .workspace-dashboard--staff .portal-tiles.clerk-personal-tiles {
        grid-template-columns: repeat(6, minmax(0, 1fr));
    }
    .clerk-personal-tiles > :nth-child(-n + 2) {
        grid-column: span 3;
    }
    .clerk-personal-tiles > :nth-child(n + 3) {
        grid-column: span 2;
    }
}
.clerk-summary-card {
    padding: 0;
    font: inherit;
    text-align: left;
    cursor: pointer;
    transition: transform 0.22s ease, box-shadow 0.22s ease;
}
.clerk-summary-card:hover,
.clerk-summary-card:focus-visible {
    transform: translateY(-3px);
    box-shadow: 0 16px 28px -16px rgba(0, 85, 237, 0.55);
}
.clerk-summary-card--static {
    cursor: default;
}
.clerk-summary-card--static:hover,
.clerk-summary-card--static:focus-visible {
    transform: none;
    box-shadow: none;
}
.workspace-dashboard--staff .clerk-summary-card .summary-seg {
    --clerk-icon: #005eed;
}
.workspace-dashboard--staff .clerk-summary-card .summary-seg--warning {
    --clerk-icon: #f59e0b;
}
.workspace-dashboard--staff .clerk-summary-card .summary-seg--danger {
    --clerk-icon: #e5383b;
}
.workspace-dashboard--staff .clerk-summary-card .summary-seg--success {
    --clerk-icon: #16a34a;
}
.workspace-dashboard--staff .clerk-summary-card.summary-strip .summary-seg-label {
    color: #000;
}
.workspace-dashboard--staff .clerk-summary-card.summary-strip .summary-seg-icon {
    color: var(--clerk-icon);
    background: color-mix(in srgb, var(--clerk-icon) 11%, var(--ws-surface, #fff));
    transition: transform 0.3s ease;
}
.clerk-summary-card:hover .summary-seg-icon {
    transform: scale(1.06) rotate(-4deg);
}
.clerk-summary-card--static:hover .summary-seg-icon {
    transform: none;
}
.clerk-card-cta {
    position: absolute;
    top: 10px;
    right: 14px;
    color: var(--ws-blue, #0055ed);
    font-size: var(--tms-text-xs);
    font-weight: 700;
    opacity: 0;
    transition: opacity 0.15s ease;
}
.clerk-summary-card:hover .clerk-card-cta,
.clerk-summary-card:focus-visible .clerk-card-cta {
    opacity: 1;
}
:global(html.dark .workspace-dashboard--staff .clerk-summary-card.summary-strip .summary-seg-label) {
    color: var(--ws-ink, #f4f7ff);
}
.clerk-summary-card:focus-visible {
    outline: 2px solid var(--ws-blue, #0055ed);
    outline-offset: 3px;
}
.workspace-dashboard--staff .clerk-bottom-grid {
    grid-template-columns: minmax(0, 2fr) minmax(0, 1fr);
}
.clerk-bottom-grid > .dash-slot {
    grid-column: auto !important;
}
@media (prefers-reduced-motion: reduce) {
    .clerk-summary-card,
    .clerk-summary-card .summary-seg-icon,
    .clerk-card-cta {
        transition: none;
    }
    .clerk-summary-card:hover,
    .clerk-summary-card:focus-visible,
    .clerk-summary-card:hover .summary-seg-icon {
        transform: none;
    }
}
@media (max-width: 600px) {
    .workspace-dashboard--staff .clerk-bottom-grid {
        grid-template-columns: minmax(0, 1fr);
    }
}
</style>
