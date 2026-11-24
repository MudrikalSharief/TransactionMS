<template>
    <div class="fit-page workspace-dashboard workspace-dashboard--staff">
        <!-- Full-page loader on every visit; later polls refresh quietly. -->
        <LoadingVeil :show="loading" label="home" icon="mdi-home-city-outline" />
        <!-- Welcome: who you are, which office, which roles -->
        <div>
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel">
                    <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4 lgu-head" :class="{ 'clerk-home-header': isClerk }">
                        <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                            <v-icon color="#005EED" size="20">mdi-home-city-outline</v-icon>
                        </v-avatar>
                        <!-- The header stays one line: on phones the name and office
                             shorten with "…", role chips hide and the button
                             keeps only its icon. -->
                        <div class="head-text">
                            <!-- Role chips sit right after the name. -->
                            <div class="head-name">
                                <span class="text-subtitle-1 font-weight-bold head-name-text">Your workspace</span>
                                <v-chip
                                    v-for="r in user?.roles || []"
                                    :key="r.code"
                                    size="small"
                                    variant="tonal"
                                    color="primary"
                                    rounded="pill"
                                    class="font-weight-bold d-none d-sm-inline-flex head-role"
                                >
                                    {{ r.name || r.code }}
                                </v-chip>
                            </div>
                            <div class="text-caption text-medium-emphasis head-office">
                                {{ summary?.office?.name || 'No office assigned' }}
                            </div>
                        </div>
                        <v-spacer />
                        <!-- Period drives the number cards and the graph. -->
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
                        <v-btn
                            v-if="canCreate"
                            color="primary"
                            rounded="pill"
                            :icon="xs"
                            :prepend-icon="xs ? undefined : 'mdi-plus'"
                            aria-label="New Transaction"
                            @click="router.push({ path: '/portal/transactions', query: { new: '1' } })"
                        >
                            <v-icon v-if="xs">mdi-plus</v-icon>
                            <template v-else>New Transaction</template>
                        </v-btn>
                    </v-card-title>
                    <v-alert
                        v-if="user && !user.office"
                        type="warning"
                        variant="tonal"
                        rounded="0"
                        class="ma-4"
                    >
                        <template v-if="isClerk">Your account needs an assigned office before step counts can be shown.</template>
                        <template v-else>Your account has no office assigned yet, so you will only see transactions waiting on your role.</template>
                        Ask an administrator to assign your office.
                    </v-alert>
                </v-card>
        </div>

        <!-- Numbers for the user's office / role -->
                <div class="portal-tiles" :class="{ 'portal-tiles--clerk': isClerk }">
                    <template v-for="tile in topTiles" :key="tile.key">
                    <button
                        v-if="isClerk"
                        type="button"
                        class="summary-strip clerk-summary-card"
                        :aria-label="`${tile.label}: ${tile.value}`"
                        @click="tile.go"
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
                    </button>
                    <StatCard
                        v-else
                        :label="tile.label"
                        :value="tile.value"
                        :hint="tile.hint"
                        :variant="tile.variant"
                        :icon="tile.icon"
                        :loading="loading"
                        clickable
                        cta="View list"
                        @activate="tile.go"
                    />
                    </template>
                </div>

        <v-dialog v-model="stepListOpen" max-width="720" scrollable>
            <v-card>
                <v-card-title class="d-flex align-center flex-wrap ga-2">
                    {{ selectedStepTitle }}
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" aria-label="Close step list" @click="stepListOpen = false" />
                </v-card-title>
                <v-card-text>
                    <v-alert v-if="!selectedStepRows.length" type="info" variant="tonal">No matching steps.</v-alert>
                    <v-list v-else lines="three">
                        <v-list-item v-for="step in selectedStepRows" :key="step.id">
                            <v-list-item-title>{{ step.reference_number }}</v-list-item-title>
                            <v-list-item-subtitle class="text-wrap">{{ step.step_name }}<template v-if="step.title"> · {{ step.title }}</template></v-list-item-subtitle>
                            <v-list-item-subtitle v-if="selectedStepCard === 'needs_action'">{{ step.reason }}</v-list-item-subtitle>
                            <template v-if="selectedStepCard !== 'overdue_completed'" #append>
                                <v-btn variant="text" color="primary" @click="router.push(`/portal/transactions/${step.transaction_id}`)">Open</v-btn>
                            </template>
                        </v-list-item>
                    </v-list>
                </v-card-text>
            </v-card>
        </v-dialog>

        <div class="dash-grid" :class="{ 'clerk-bottom-grid': isClerk }">
            <!-- Weekly transactions per process, limited to the account's
                 office and role (needs an office to have anything to show). -->
            <div v-if="user?.office" class="dash-slot" :data-card="isClerk ? 'graph' : undefined" :style="{ '--span': hasApprovals ? 8 : 12 }">
                <ProcessGraphCard v-model:period="period" />
            </div>

            <!-- Waiting on my role: end users only. Clerks have the Approvals
                 page for this, so it would be a duplicate there. -->
            <div v-if="!hasApprovals" class="dash-slot" style="--span: 6">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center lgu-head dash-head">
                        <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                            <v-icon color="#005EED" size="20">mdi-tray-full</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Needs My Action</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="openList('action')">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text v-fit-body="'action'" class="pa-1 dash-body">
                        <TxMiniList
                            :rows="actionRows.slice(0, rows('action', LIST_ROW_PX, SUMMARY_ROWS))"
                            :loading="loading"
                            empty="Nothing is waiting on you right now."
                            @open="(tx) => router.push({ path: `/portal/transactions/${tx.id}`, query: { from: 'portal-action' } })"
                        />
                    </v-card-text>
                </v-card>
            </div>

            <!-- In my office (oldest first); full width when it is the only list -->
            <div v-if="!isClerk" class="dash-slot" :style="{ '--span': hasApprovals ? (user?.office ? 4 : 12) : 6 }">
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
            <div v-if="isClerk" class="dash-slot clerk-action-panel">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center lgu-head dash-head">
                        <v-avatar color="white" rounded="0" size="34" class="mr-2 lgu-head-avatar">
                            <v-icon color="#005EED" size="20">mdi-tray-arrow-down</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Needs My Action</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="openSteps('needs_action')">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text class="pa-1 dash-body">
                        <TxMiniList
                            :rows="clerkActionRows"
                            :loading="loading"
                            empty="No steps are waiting for your action."
                            @open="(tx) => router.push(`/portal/transactions/${tx.id}`)"
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
import { useDisplay } from "vuetify";
import { useApi } from "@/composables/useApi";
import { useAuth, canUseApprovals } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { markWorkspaceRefreshed } from "@/composables/useWorkspaceHeader";
import { useFitScreen } from "@/composables/useFitScreen";
import StatCard from "@/components/StatCard.vue";
import TxMiniList from "@/components/portal/TxMiniList.vue";
import ProcessGraphCard from "@/components/portal/ProcessGraphCard.vue";
import { periodOptions as dashPeriodOptions } from "@/utils/dashPeriod";

const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const { xs } = useDisplay();
const { vFitBody, rows } = useFitScreen();

const loading = ref(true);
const summary = ref(null);
const actionTotal = ref(0);
const actionRows = ref([]);
const officeRows = ref([]);

// Period filter (same options as the admin Dashboard): the In process,
// Completed and Created by me cards and the graph follow it. The
// "Needs my action" queue and the lists always show what is open now.
const period = ref("all");
const periodOptions = computed(() => dashPeriodOptions());

const canCreate = computed(() => user.value?.office != null);
// Clerks use their step cards; other approval roles retain the existing office view.
const hasApprovals = computed(() => canUseApprovals(user.value));
const isClerk = computed(() => user.value?.roles?.some((role) => role.code === "clerk") === true);
const stepListOpen = ref(false);
const selectedStepCard = ref("needs_action");
const stepCards = [
    { key: "overdue_completed", label: "Overdue Completed", hint: "Your completed steps that exceeded their time limit", icon: "mdi-check-circle-outline", variant: "warning" },
    { key: "overdue_pending", label: "Overdue Pending", hint: "Your current steps past their time limit", icon: "mdi-clock-alert-outline", variant: "danger" },
    { key: "needs_action", label: "Needs My Action", hint: "Steps awaiting receipt and returns assigned to you", icon: "mdi-tray-arrow-down", variant: "info" },
];
const selectedStepTitle = computed(() => stepCards.find((card) => card.key === selectedStepCard.value)?.label);
const selectedStepRows = computed(() => summary.value?.clerk_steps?.rows?.[selectedStepCard.value] ?? []);
function openSteps(key) {
    selectedStepCard.value = key;
    stepListOpen.value = true;
}

const tiles = computed(() => [
    !hasApprovals.value && {
        key: "action",
        label: "Needs my action",
        value: actionTotal.value,
        hint: "Waiting on your role at your office",
        icon: "mdi-tray-full",
        variant: "orange",
        go: () => openList("action"),
    },
    // Life of a transaction, left to right: created, in process, completed.
    {
        key: "mine",
        label: "Created by me",
        value: summary.value?.created_by_me ?? 0,
        hint: "Transactions you started",
        icon: "mdi-account-edit",
        variant: "info",
        go: () => openList("office"),
    },
    {
        key: "in_process",
        label: "In process",
        value: summary.value?.in_process ?? 0,
        hint: "Office transactions still moving",
        icon: "mdi-timer-sand",
        variant: "warning",
        go: () => openList("office"),
    },
    {
        key: "completed",
        label: "Completed",
        value: summary.value?.completed ?? 0,
        hint: "Office transactions finished",
        icon: "mdi-check-bold",
        variant: "success",
        go: () => openList("office"),
    },
    ...(isClerk.value ? stepCards.filter((card) => card.key !== "needs_action").map((card) => ({
        ...card,
        value: summary.value?.clerk_steps?.[card.key] ?? "—",
        go: () => openSteps(card.key),
    })) : []),
].filter(Boolean));

const topTiles = computed(() => isClerk.value ? [
    ...tiles.value.filter((tile) => tile.key.startsWith("overdue_")),
    ...tiles.value.filter((tile) => ["mine", "in_process", "completed"].includes(tile.key)),
] : tiles.value);
const clerkActionRows = computed(() => [...(summary.value?.clerk_steps?.rows?.needs_action ?? [])]
    .sort((a, b) => Number(b.id) - Number(a.id))
    .slice(0, 5)
    .map((step) => ({
        id: step.transaction_id,
        reference_number: step.reference_number,
        title: [step.step_name, step.reason, step.title].filter(Boolean).join(" · "),
    })));

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

// Latest request wins, so a quick period switch never shows older numbers.
let summaryRequest = 0;
const fetchSummary = () => api.get("/api/portal/summary", { params: { period: period.value } });

async function loadSummary() {
    const mine = ++summaryRequest;
    try {
        const res = await fetchSummary();
        if (mine === summaryRequest) {
            summary.value = res.data;
            markWorkspaceRefreshed();
        }
    } catch {
        /* keep the last numbers; the next poll retries */
    }
}
watch(period, loadSummary);

async function load() {
    const mine = ++summaryRequest;
    const [sum, queue, office] = await Promise.allSettled([
        fetchSummary(),
        hasApprovals.value ? Promise.resolve({ rows: [], total: 0 }) : oldestRows("/api/transactions"),
        isClerk.value ? Promise.resolve({ rows: [] }) : oldestRows("/api/admin/transactions"),
    ]);
    if (sum.status === "fulfilled" && mine === summaryRequest) summary.value = sum.value.data;
    if (queue.status === "fulfilled") {
        actionRows.value = queue.value.rows;
        actionTotal.value = queue.value.total;
    }
    if (office.status === "fulfilled") officeRows.value = office.value.rows;
    if (sum.status === "fulfilled" || queue.status === "fulfilled" || office.status === "fulfilled") markWorkspaceRefreshed();
    loading.value = false;
}

onMounted(() => {
    load();
});
useSmartPoll(load);
</script>

<style src="../../../css/workspace-dashboard.css"></style>

<style scoped>
.workspace-dashboard--staff .portal-tiles--clerk {
    grid-template-columns: repeat(6, minmax(0, 1fr));
}
.portal-tiles--clerk > .summary-strip {
    grid-column: span 2;
}
.portal-tiles--clerk > .summary-strip:nth-child(-n + 2) {
    grid-column: span 3;
}
.clerk-summary-card {
    padding: 0;
    font: inherit;
    text-align: left;
    cursor: pointer;
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
@media (max-width: 600px) {
    .workspace-dashboard--staff .portal-tiles--clerk,
    .workspace-dashboard--staff .clerk-bottom-grid {
        grid-template-columns: minmax(0, 1fr);
    }
    .portal-tiles--clerk > .summary-strip:nth-child(n) {
        grid-column: auto;
    }
    .clerk-home-header {
        flex-wrap: wrap !important;
    }
    .clerk-home-header .head-text {
        flex: 1 1 calc(100% - 60px);
    }
    .clerk-home-header .v-spacer {
        display: none;
    }
    .clerk-home-header .home-period {
        flex: 1 1 180px !important;
        min-width: 150px !important;
    }
}
</style>
