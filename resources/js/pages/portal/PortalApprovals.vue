<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <!-- Same header as Portal Transactions; on phones the buttons keep
                 only their icons so the one-line header still fits. -->
            <v-card-title class="d-flex align-center ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#16307C">mdi-clipboard-check-multiple-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Task</span>
                <v-chip
                    v-if="!loading"
                    size="small"
                    rounded="0"
                    variant="flat"
                    :color="rows.length ? 'error' : 'success'"
                    class="font-weight-bold"
                >
                    {{ rows.length }} waiting
                </v-chip>
                <v-spacer />
                <v-btn
                    variant="outlined"
                    color="grey-darken-3"
                    rounded="0"
                    height="40"
                    :loading="loading"
                    :icon="xs"
                    :prepend-icon="xs ? undefined : 'mdi-refresh'"
                    aria-label="Refresh"
                    @click="load"
                >
                    <v-icon v-if="xs">mdi-refresh</v-icon>
                    <template v-else>Refresh</template>
                </v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

                <v-alert type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Transactions waiting at a step for your role and office. Open one to review and proceed.
                </v-alert>

                <v-text-field
                    v-model="search"
                    prepend-inner-icon="mdi-magnify"
                    label="Search . . ."
                    variant="outlined"
                    density="compact"
                    rounded="0"
                    hide-details
                    clearable
                    class="mb-3"
                    style="max-width: 420px"
                />

                <div class="d-flex flex-column" style="min-height: 458px">
                    <v-data-table
                        v-show="!loading || rows.length"
                        v-model:page="page"
                        :items="filtered"
                        :headers="headers"
                        item-key="id"
                        density="compact"
                        height="398"
                        fixed-header
                        :items-per-page="PER_PAGE"
                        hide-default-footer
                        :sort-by="[{ key: 'created_at', order: 'asc' }]"
                        hover
                        class="lgu-table table-search"
                        @click:row="(_, row) => open(row.item)"
                    >
                        <template #no-data>
                            <div class="pa-6 text-medium-emphasis">
                                {{ search ? "No tasks match your search." : "You have no pending tasks." }}
                            </div>
                        </template>
                        <template v-slot:[`item.reference_number`]="{ item }">
                            <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
                                {{ item.reference_number || `#${item.id}` }}
                            </v-chip>
                        </template>
                        <template v-slot:[`item.title`]="{ item }">
                            <span class="font-weight-bold">{{ item.title || "N/A" }}</span>
                        </template>
                        <template v-slot:[`item.type`]="{ item }">
                            <v-chip color="info" variant="tonal" rounded="0" size="small">
                                <v-icon start size="small">mdi-tag-outline</v-icon>
                                {{ item.transaction_type?.name || "N/A" }}
                            </v-chip>
                        </template>
                        <template v-slot:[`item.current_step`]="{ item }">
                            <v-chip color="primary" variant="tonal" rounded="0" size="small">
                                <v-icon start size="small">mdi-map-marker-radius-outline</v-icon>
                                {{ item.current_step?.name || item.current_step?.code || "—" }}
                            </v-chip>
                        </template>
                        <template v-slot:[`item.entered_at`]="{ item }">
                            <span class="text-medium-emphasis">{{ waited(item.entered_at) }}</span>
                        </template>
                        <template v-slot:[`item.created_at`]="{ item }">
                            <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
                            <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
                        </template>
                        <template v-slot:[`item.actions`]="{ item }">
                            <v-btn
                                color="primary"
                                rounded="0"
                                size="small"
                                append-icon="mdi-arrow-right"
                                @click.stop="open(item)"
                            >
                                Open
                            </v-btn>
                        </template>
                    </v-data-table>
                    <div v-if="pageCount > 1" class="d-flex justify-center py-3">
                        <v-pagination v-model="page" :length="pageCount" :total-visible="5" density="compact" />
                    </div>
                    <TableLoader v-if="loading && !rows.length" label="tasks" icon="mdi-clipboard-check-multiple-outline" style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useDisplay } from "vuetify";
import { useApi } from "@/composables/useApi";
import { useApprovalBadge } from "@/composables/useApprovalBadge";
import { useSmartPoll } from "@/composables/useSmartPoll";
import TableLoader from "@/components/TableLoader.vue";

// Clerk approvals: every transaction waiting at a step the clerk may work
// (their role + their office; the server applies the same rule as Proceed).
const router = useRouter();
const { api } = useApi();
const { xs } = useDisplay();
const approvalBadge = useApprovalBadge();

const PER_PAGE = 7;
const rows = ref([]);
const loading = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Waiting", key: "entered_at" },
    { title: "Created At", key: "created_at" },
    { title: "", key: "actions", sortable: false, align: "end" },
];

const filtered = computed(() => {
    const q = String(search.value || "").trim().toLowerCase();
    if (!q) return rows.value;
    return rows.value.filter((t) =>
        [t.reference_number, t.title, t.transaction_type?.name, t.current_step?.name]
            .some((v) => String(v || "").toLowerCase().includes(q)),
    );
});
const pageCount = computed(() => Math.max(1, Math.ceil(filtered.value.length / PER_PAGE)));
watch(search, () => { page.value = 1; });
watch(pageCount, (n) => { if (page.value > n) page.value = n; });

// The inbox is small per clerk: read every page (100 rows each) so search,
// sorting and the count cover all of it.
async function fetchAll({ silent = false } = {}) {
    if (!silent) loading.value = true;
    try {
        const all = [];
        let p = 1;
        let last = 1;
        do {
            const res = await api.get("/api/approvals", { params: { page: p, per_page: 100 } });
            all.push(...(res.data?.data ?? []));
            last = res.data?.meta?.last_page ?? 1;
            p += 1;
        } while (p <= last && p <= 20);
        rows.value = all;
        // Keep the sidebar count in step with what this page shows.
        approvalBadge.pendingTransactions.value = all.length;
        error.value = "";
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load tasks.";
    } finally {
        loading.value = false;
    }
}

const load = () => fetchAll();

function open(tx) {
    router.push(`/transactions/${tx.id}`);
}

function waited(iso) {
    if (!iso) return "—";
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
    if (s < 3600) return `${Math.max(1, Math.floor(s / 60))}m`;
    if (s < 86400) return `${Math.floor(s / 3600)}h`;
    return `${Math.floor(s / 86400)}d`;
}

function fmtDate(iso) {
    if (!iso) return "N/A";
    return new Date(iso).toLocaleDateString("en-PH", {
        timeZone: "Asia/Manila",
        month: "short",
        day: "numeric",
        year: "numeric",
    });
}

function timeAgo(iso) {
    if (!iso) return "";
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
    if (s < 60) return "just now";
    if (s < 3600) return `${Math.floor(s / 60)}m ago`;
    if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
    if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`;
    return fmtDate(iso);
}

onMounted(load);
useSmartPoll(() => fetchAll({ silent: true }));
</script>

<style scoped>
/* Boxed table header: dark-blue fill, white text (same as the admin tables). */
.lgu-table :deep(thead tr th.v-data-table__th) {
    background-color: #0e1f52 !important;
    color: #ffffff !important;
    border-top: 2px solid #0e1f52 !important;
    border-bottom: 3px solid #0e1f52 !important;
    border-left: none !important;
    border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
    border-left: 2px solid #0e1f52 !important;
    padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
    border-right: 2px solid #0e1f52 !important;
    padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
    color: #ffffff !important;
}
</style>
