<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <!-- Same header as the admin pages (outlined navy badge, outlined
                 buttons). On phones the buttons drop their labels so the
                 one-line card header still fits. -->
            <v-card-title class="d-flex align-center ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#005EED">{{ isHistory ? "mdi-archive-outline" : "mdi-file-document-multiple" }}</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">{{ isHistory ? "Transaction History" : "Transactions" }}</span>
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
                <v-btn
                    v-if="canCreate && !isHistory"
                    variant="outlined"
                    color="primary"
                    rounded="0"
                    height="40"
                    :icon="xs"
                    :prepend-icon="xs ? undefined : 'mdi-plus'"
                    aria-label="New Transaction"
                    @click="openCreate"
                >
                    <v-icon v-if="xs">mdi-plus</v-icon>
                    <template v-else>New Transaction</template>
                </v-btn>
            </v-card-title>

            <v-divider />

            <!-- Clerks only see My office: what waits on them is on Approvals.
                 History has no tabs: finished papers never need action. -->
            <v-tabs v-if="!isHistory" v-model="tab" color="primary" density="comfortable" @update:model-value="onTab">
                <v-tab v-if="!hasApprovals" value="action" class="font-weight-bold">
                    <v-icon start>mdi-tray-full</v-icon>
                    Needs my action
                </v-tab>
                <v-tab value="office" class="font-weight-bold">
                    <v-icon start>mdi-office-building-outline</v-icon>
                    My office
                </v-tab>
            </v-tabs>
            <v-divider v-if="!isHistory" />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <v-alert v-if="isHistory" type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Completed transactions from your office, kept here for reference.
                </v-alert>
                <v-alert v-else-if="tab === 'action'" type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Transactions currently on a step assigned to your role at your office. Open one to work on it.
                </v-alert>
                <v-alert v-else type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Every open transaction that belongs to your office, plus any waiting on your role.
                    Completed ones move to Transaction History.
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

                <!-- Filters: type, created date + time range, and order. -->
                <div class="filter-bar mb-3">
                    <v-select
                        v-model="filters.type"
                        :items="typeFilterOptions"
                        label="Transaction type"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        class="fb-type"
                    />
                    <v-text-field
                        v-model="filters.date"
                        type="date"
                        label="Created on"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        class="fb-date"
                    />
                    <!-- One box: click to switch between newest and oldest first. -->
                    <v-btn
                        variant="tonal"
                        rounded="0"
                        color="primary"
                        height="40"
                        class="fb-order"
                        :prepend-icon="filters.order === 'asc' ? 'mdi-sort-calendar-ascending' : 'mdi-sort-calendar-descending'"
                        :aria-label="`Sorted ${filters.order === 'asc' ? 'oldest' : 'newest'} first. Click to switch`"
                        v-tooltip="'Click to switch the order'"
                        @click="filters.order = filters.order === 'asc' ? 'desc' : 'asc'"
                    >
                        {{ filters.order === 'asc' ? 'Oldest first' : 'Newest first' }}
                    </v-btn>
                    <v-btn v-if="filtersActive" variant="text" rounded="0" color="grey-darken-3" prepend-icon="mdi-filter-remove-outline" @click="clearFilters">
                        Clear
                    </v-btn>
                </div>

                <div class="d-flex flex-column" style="min-height: 458px">
                    <v-data-table
                        v-show="!loading"
                        v-model:page="page"
                        :items="shown"
                        :headers="headers"
                        item-key="id"
                        density="compact"
                        height="398"
                        fixed-header
                        :items-per-page="PER_PAGE"
                        hide-default-footer
                        hover
                        class="lgu-table table-search"
                        @click:row="(_, row) => open(row.item)"
                    >
                        <template #no-data>
                            <div class="pa-6 text-medium-emphasis">
                                {{
                                    scoped.length && (filtersActive || search)
                                        ? "No transactions match your search or filters."
                                        : isHistory
                                          ? "No completed transactions yet."
                                          : tab === "action" ? "Nothing is waiting on your role right now." : "No open transactions in your office."
                                }}
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
                                {{ item.transaction_type?.name || item.transaction_type_name || "N/A" }}
                            </v-chip>
                        </template>
                        <template v-slot:[`item.office`]="{ item }">
                            <span class="text-medium-emphasis">{{ item.office?.name || "—" }}</span>
                        </template>
                        <template v-slot:[`item.current_step`]="{ item }">
                            <v-menu open-on-hover location="end" open-delay="250">
                                <template #activator="{ props }">
                                    <v-chip
                                        :color="stepColor(item.current_step)"
                                        variant="tonal"
                                        rounded="0"
                                        size="small"
                                        v-bind="props"
                                    >
                                        <v-icon start size="small">{{ stepIcon(item.current_step) }}</v-icon>
                                        {{ item.current_step?.name || item.current_step?.code || "Unassigned" }}
                                    </v-chip>
                                    <v-chip
                                        v-if="item.is_done"
                                        color="success"
                                        variant="flat"
                                        rounded="0"
                                        size="small"
                                        class="ml-1"
                                    >
                                        <v-icon start size="small">mdi-flag-checkered</v-icon>
                                        Done
                                    </v-chip>
                                </template>
                                <StepProgress
                                    :steps="item.workflow_steps"
                                    :current-step-id="item.current_step?.id"
                                    :current-step-code="item.current_step?.code"
                                    :title="item.current_step?.name || item.current_step?.code || 'Unassigned'"
                                />
                            </v-menu>
                        </template>
                        <template v-slot:[`item.created_at`]="{ item }">
                            <div class="font-weight-bold text-no-wrap">{{ fmtDate(item.created_at) }}</div>
                            <div class="text-caption text-medium-emphasis">{{ fmtTime(item.created_at) }} ({{ timeAgo(item.created_at) }})</div>
                        </template>
                    </v-data-table>
                    <div v-if="pageCount > 1 && !loading" class="d-flex justify-center py-3">
                        <v-pagination v-model="page" :length="pageCount" :total-visible="5" density="compact" />
                    </div>
                    <TableLoader v-if="loading" label="transactions" icon="mdi-file-document-multiple" style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>

        <!-- New transaction: created under the user's own office -->
        <v-dialog v-model="dialog" max-width="700">
            <v-card rounded="0">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                        <v-icon color="#005EED">mdi-plus</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">New Transaction</span>
                </v-card-title>
                <v-card-text class="pa-5">
                    <v-alert v-if="createError" type="error" variant="tonal" rounded="0" class="mb-3">
                        {{ createError }}
                    </v-alert>
                    <v-select
                        v-model="form.transaction_type_id"
                        :items="typeOptions"
                        item-title="label"
                        item-value="id"
                        label="Transaction Type"
                        variant="outlined"
                        rounded="0"
                    />
                    <v-text-field v-model="form.title" label="Title (optional)" variant="outlined" rounded="0" />
                    <v-alert type="info" variant="tonal" rounded="0">
                        It starts at your office ({{ user?.office?.name }}) and follows the current steps of the chosen type.
                    </v-alert>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end pa-4">
                    <v-btn variant="text" rounded="0" @click="dialog = false">Cancel</v-btn>
                    <v-btn
                        color="primary"
                        rounded="0"
                        :loading="saving"
                        :disabled="!form.transaction_type_id"
                        @click="createTx"
                    >
                        Create
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useDisplay } from "vuetify";
import { useApi } from "@/composables/useApi";
import { useAuth, canUseApprovals } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import TableLoader from "@/components/TableLoader.vue";
import StepProgress from "@/components/StepProgress.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const typeStore = useTransactionTypes();
const { xs } = useDisplay();

// 7 rows per page, like the admin tables. The whole list is loaded once so
// search, filters and ordering cover every row, then paged here.
const PER_PAGE = 7;

// "action" = rows waiting on my role (opens the working page);
// "office" = my office's rows (opens the read/track page).
// Clerks (anyone who may approve) have the Approvals page for "Needs my
// action", so they only get the office list here.
const hasApprovals = computed(() => canUseApprovals(user.value));
// Transaction History (/portal/history) is this page in archive mode:
// completed rows only. The normal page lists open rows only.
const isHistory = computed(() => !!route.meta.history);
const tab = ref(isHistory.value || hasApprovals.value || route.query.tab === "office" ? "office" : "action");
const items = ref([]);
const loading = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);

// Filters: transaction type, the day it was created, newest/oldest.
const emptyFilters = () => ({ type: null, date: null, order: "desc" });
const filters = ref(emptyFilters());
const filtersActive = computed(() => !!(filters.value.type || filters.value.date));
function clearFilters() {
    filters.value = { ...emptyFilters(), order: filters.value.order };
}
const typeName = (t) => t.transaction_type?.name || t.transaction_type_name || "";
// Open rows here, completed rows in History; filters work on this split.
const scoped = computed(() => items.value.filter((t) => !!t.is_done === isHistory.value));
const typeFilterOptions = computed(() => [...new Set(scoped.value.map(typeName).filter(Boolean))].sort());

const shown = computed(() => {
    const q = String(search.value || "").trim().toLowerCase();
    // "YYYY-MM-DD" -> that whole local day (built from parts: new Date("YYYY-MM-DD") is UTC).
    let from = null;
    let to = null;
    if (filters.value.date) {
        const [y, m, d] = filters.value.date.split("-").map(Number);
        from = new Date(y, m - 1, d).getTime();
        to = new Date(y, m - 1, d + 1).getTime();
    }
    const dir = filters.value.order === "asc" ? 1 : -1;
    return scoped.value
        .filter((t) => {
            if (filters.value.type && typeName(t) !== filters.value.type) return false;
            const at = new Date(t.created_at).getTime();
            if (from != null && (at < from || at >= to)) return false;
            if (!q) return true;
            return [t.reference_number, t.title, typeName(t), t.office?.name, t.current_step?.name]
                .some((v) => String(v || "").toLowerCase().includes(q));
        })
        .sort((a, b) => dir * (new Date(a.created_at) - new Date(b.created_at) || a.id - b.id));
});
const pageCount = computed(() => Math.max(1, Math.ceil(shown.value.length / PER_PAGE)));
watch([search, filters], () => { page.value = 1; }, { deep: true });
watch(pageCount, (n) => { if (page.value > n) page.value = n; });

const canCreate = computed(() => user.value?.office != null);

const headers = [
    { title: "Reference", key: "reference_number", sortable: false },
    { title: "Title", key: "title", sortable: false },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Office", key: "office", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Created", key: "created_at", sortable: false, width: 170 },
];

const endpoint = () => (tab.value === "action" ? "/api/transactions" : "/api/admin/transactions");

async function fetchRows({ silent = false } = {}) {
    if (!silent) loading.value = true;
    try {
        const all = [];
        let p = 1;
        let last = 1;
        do {
            const res = await api.get(endpoint(), { params: { page: p, per_page: 100 } });
            all.push(...(res.data?.data ?? []));
            last = res.data?.meta?.last_page ?? 1;
            p += 1;
        } while (p <= last && p <= 20);
        items.value = all;
        error.value = "";
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load transactions.";
    } finally {
        loading.value = false;
    }
}

const load = () => fetchRows();

function onTab() {
    page.value = 1;
    router.replace({ query: { ...route.query, tab: tab.value, new: undefined } });
    fetchRows();
}

function open(tx) {
    router.push(tab.value === "action" ? `/my/transactions/${tx.id}` : `/transactions/${tx.id}`);
}

function stepColor(step) {
    if (!step) return "grey";
    if (step.is_end) return "success";
    if (step.is_start) return "teal";
    return "primary";
}

function stepIcon(step) {
    if (!step) return "mdi-help-circle-outline";
    if (step.is_end) return "mdi-flag-checkered";
    if (step.is_start) return "mdi-play";
    return "mdi-dots-horizontal-circle-outline";
}

function fmtTime(iso) {
    if (!iso) return "";
    return new Date(iso).toLocaleTimeString("en-PH", { timeZone: "Asia/Manila", hour: "numeric", minute: "2-digit" });
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

// ---- New transaction ----
const dialog = ref(false);
const saving = ref(false);
const createError = ref("");
const form = ref({ transaction_type_id: null, title: "" });

// Only the types offered to the user's own office (empty = open to all).
const typeOptions = computed(() => {
    const officeId = user.value?.office?.id ?? null;
    return (typeStore.items.value || [])
        .filter((t) => {
            const ids = t.office_ids ?? (t.offices || []).map((o) => o.id);
            if (!ids.length) return true;
            return officeId != null && ids.some((id) => Number(id) === Number(officeId));
        })
        .map((t) => ({ id: t.id, label: `${t.name} (${t.code})` }));
});

function openCreate() {
    createError.value = "";
    form.value = { transaction_type_id: null, title: "" };
    typeStore.fetchAll({ silent: true }).catch(() => {});
    dialog.value = true;
}

async function createTx() {
    saving.value = true;
    createError.value = "";
    try {
        const res = await api.post("/api/admin/transactions", {
            transaction_type_id: form.value.transaction_type_id,
            title: form.value.title || null,
        });
        const tx = res.data?.data ?? res.data;
        dialog.value = false;
        router.push(`/transactions/${tx.id}`);
    } catch (e) {
        createError.value =
            e?.response?.data?.message ||
            Object.values(e?.response?.data?.errors || {})[0]?.[0] ||
            "Create failed.";
    } finally {
        saving.value = false;
    }
}

onMounted(async () => {
    await fetchRows();
    if (route.query.new === "1" && canCreate.value && !isHistory.value) openCreate();
});

useSmartPoll(() => {
    if (dialog.value) return;
    return fetchRows({ silent: true });
});
</script>

<style scoped>
/* Filter bar: wraps onto more lines on small screens. */
.filter-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 10px;
}
.fb-type {
    flex: 1 1 200px;
    max-width: 260px;
}
.fb-date {
    flex: 1 1 170px;
    max-width: 200px;
}
.fb-order {
    text-transform: none;
    font-weight: 600;
    min-width: 150px;
}
/* Boxed table header: dark-blue fill, white text (same as the admin tables). */
.lgu-table :deep(thead tr th.v-data-table__th) {
    background-color: #1A1F2B !important;
    color: #ffffff !important;
    border-top: 2px solid #1A1F2B !important;
    border-bottom: 3px solid #1A1F2B !important;
    border-left: none !important;
    border-right: none !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:first-child) {
    border-left: 2px solid #1A1F2B !important;
    padding-left: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th:last-child) {
    border-right: 2px solid #1A1F2B !important;
    padding-right: 20px !important;
}
.lgu-table :deep(thead tr th.v-data-table__th .v-data-table-header__content),
.lgu-table :deep(thead tr th.v-data-table__th .v-icon) {
    color: #ffffff !important;
}
</style>
