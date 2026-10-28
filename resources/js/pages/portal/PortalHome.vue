<template>
    <div>
        <v-row align="stretch">
            <!-- Welcome: who you are, which office, which roles -->
            <v-col cols="12">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel">
                    <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4 lgu-head">
                        <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                            <v-icon color="#005EED" size="24">mdi-home-city-outline</v-icon>
                        </v-avatar>
                        <!-- The header stays one line: on phones the name and office
                             shorten with "…", role chips hide and the button
                             keeps only its icon. -->
                        <div class="head-text">
                            <div class="text-subtitle-1 font-weight-bold">Welcome, {{ user?.name }}</div>
                            <div class="text-caption text-medium-emphasis">
                                {{ summary?.office?.name || 'No office assigned' }}
                            </div>
                        </div>
                        <v-spacer />
                        <v-chip
                            v-for="r in user?.roles || []"
                            :key="r.code"
                            size="small"
                            variant="tonal"
                            color="primary"
                            rounded="0"
                            class="font-weight-bold d-none d-sm-inline-flex"
                        >
                            {{ r.name || r.code }}
                        </v-chip>
                        <v-btn
                            v-if="canCreate"
                            color="primary"
                            rounded="0"
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
                        Your account has no office assigned yet, so you will only see transactions waiting on your
                        role. Ask an administrator to assign your office.
                    </v-alert>
                </v-card>
            </v-col>

            <!-- Numbers for the user's office / role -->
            <v-col cols="12">
                <div class="portal-tiles">
                    <StatCard
                        v-for="tile in tiles"
                        :key="tile.key"
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
                </div>
            </v-col>

            <!-- Weekly transactions per process, limited to the account's
                 office and role (needs an office to have anything to show). -->
            <v-col v-if="user?.office" cols="12" :lg="hasApprovals ? 8 : 12" class="d-flex">
                <ProcessGraphCard />
            </v-col>

            <!-- Waiting on my role: end users only. Clerks have the Approvals
                 page for this, so it would be a duplicate there. -->
            <v-col v-if="!hasApprovals" cols="12" lg="6" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center pa-4 lgu-head">
                        <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                            <v-icon color="#005EED" size="24">mdi-tray-full</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">Needs My Action</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="openList('action')">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text class="pa-2">
                        <TxMiniList
                            :rows="actionRows"
                            :loading="loading"
                            empty="Nothing is waiting on you right now."
                            @open="(tx) => router.push(`/my/transactions/${tx.id}`)"
                        />
                    </v-card-text>
                </v-card>
            </v-col>

            <!-- In my office (oldest 3 first); full width when it is the only list -->
            <v-col cols="12" :lg="hasApprovals ? (user?.office ? 4 : 12) : 6" class="d-flex">
                <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="width: 100%">
                    <v-card-title class="d-flex align-center pa-4 lgu-head">
                        <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                            <v-icon color="#005EED" size="24">mdi-office-building-outline</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">In My Office</span>
                        <v-spacer />
                        <v-btn variant="text" size="small" color="primary" append-icon="mdi-arrow-right" @click="openList('office')">
                            View all
                        </v-btn>
                    </v-card-title>
                    <v-card-text class="pa-2">
                        <TxMiniList
                            :rows="officeRows"
                            :loading="loading"
                            empty="No transactions in your office yet."
                            @open="(tx) => router.push(`/transactions/${tx.id}`)"
                        />
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { useDisplay } from "vuetify";
import { useApi } from "@/composables/useApi";
import { useAuth, canUseApprovals } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import StatCard from "@/components/StatCard.vue";
import TxMiniList from "@/components/portal/TxMiniList.vue";
import ProcessGraphCard from "@/components/portal/ProcessGraphCard.vue";

const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const { xs } = useDisplay();

const loading = ref(true);
const summary = ref(null);
const actionTotal = ref(0);
const actionRows = ref([]);
const officeRows = ref([]);

const canCreate = computed(() => user.value?.office != null);
// Clerks (anyone who may approve) work from the Approvals page, so the
// "Needs my action" tile and list are left out for them.
const hasApprovals = computed(() => canUseApprovals(user.value));

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
    {
        key: "mine",
        label: "Created by me",
        value: summary.value?.created_by_me ?? 0,
        hint: "Transactions you started",
        icon: "mdi-account-edit",
        variant: "info",
        go: () => openList("office"),
    },
].filter(Boolean));

function openList(tab) {
    router.push({ path: "/portal/transactions", query: { tab } });
}

// Home is a summary: each list shows at most 3 rows, the oldest first
// (ascending by creation time). The lists come newest-first from the server,
// so the oldest rows sit on the last page(s): read page 1 for the total,
// then the last page, plus the one before it when the last page is short.
const SUMMARY_ROWS = 3;

const byCreatedAsc = (a, b) =>
    new Date(a.created_at).getTime() - new Date(b.created_at).getTime() || Number(a.id) - Number(b.id);

async function oldestRows(url) {
    const params = { per_page: SUMMARY_ROWS };
    const first = await api.get(url, { params });
    const total = first.data?.meta?.total ?? (first.data?.data ?? []).length;
    const last = first.data?.meta?.last_page ?? 1;
    let rows = first.data?.data ?? [];
    if (last > 1) {
        const pages = total % SUMMARY_ROWS ? [last - 1, last] : [last];
        const res = await Promise.all(pages.map((page) => api.get(url, { params: { ...params, page } })));
        rows = res.flatMap((r) => r.data?.data ?? []);
    }
    return { rows: [...rows].sort(byCreatedAsc).slice(0, SUMMARY_ROWS), total };
}

async function load() {
    const [sum, queue, office] = await Promise.allSettled([
        api.get("/api/portal/summary"),
        hasApprovals.value ? Promise.resolve({ rows: [], total: 0 }) : oldestRows("/api/transactions"),
        oldestRows("/api/admin/transactions"),
    ]);
    if (sum.status === "fulfilled") summary.value = sum.value.data;
    if (queue.status === "fulfilled") {
        actionRows.value = queue.value.rows;
        actionTotal.value = queue.value.total;
    }
    if (office.status === "fulfilled") officeRows.value = office.value.rows;
    loading.value = false;
}

onMounted(load);
useSmartPoll(load);
</script>

<style scoped>
/* Name + office take the room that's left and shorten with "…". */
.head-text {
    flex: 1 1 0;
    min-width: 0;
}
.head-text > div {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.portal-tiles {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 16px;
}
</style>
