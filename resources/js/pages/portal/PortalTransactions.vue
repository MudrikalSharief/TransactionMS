<template>
    <div>
        <LoadingVeil :show="entering" :label="isHistory ? 'transaction archive' : 'transactions'" :icon="isHistory ? 'mdi-archive-outline' : 'mdi-file-document-multiple'" />
        <v-card rounded="0" elevation="0" class="pw-card">
            <header class="pw-head">
                <div class="pw-icon" aria-hidden="true">
                    <v-icon size="28">{{ isHistory ? "mdi-archive-outline" : "mdi-file-document-multiple" }}</v-icon>
                </div>
                <div class="pw-head-main">
                    <div class="pw-title-row">
                        <h1 class="pw-title">{{ isHistory ? "Archive" : "Transactions" }}</h1>
                        <span class="pw-count">{{ shown.length }} {{ shown.length === 1 ? "record" : "records" }}</span>
                        <button
                            v-if="showDue"
                            type="button"
                            class="pw-btn"
                            :class="{ 'pw-btn--danger': dueCount > 0 }"
                            :title="dueTitle"
                            :aria-label="dueTitle"
                            @click="router.push('/portal/approvals')"
                        >
                            <v-icon size="17">mdi-alert-circle-outline</v-icon>
                            {{ dueCount }} due
                        </button>
                    </div>
                    <p class="pw-sub">{{ listSubtitle }}</p>
                </div>
                <div class="pw-tools">
                    <button type="button" class="pw-btn" :disabled="loading" @click="load">
                        <v-icon size="17">mdi-refresh</v-icon>
                        Refresh
                    </button>
                    <button
                        v-if="canCreate && !isHistory"
                        type="button"
                        class="pw-btn pw-btn--primary"
                        @click="openCreate"
                    >
                        <v-icon size="18">mdi-plus</v-icon>
                        New Transaction
                    </button>
                </div>
            </header>

            <WorklistSummary :tiles="summaryTiles" />

            <div v-if="!isHistory && !hasApprovals" class="pw-filterbar pw-tabbar">
                <div class="pw-tabs" role="tablist" aria-label="Transaction view">
                    <button
                        type="button"
                        class="pw-tab"
                        :class="{ 'is-active': tab === 'action' }"
                        role="tab"
                        :aria-selected="tab === 'action' ? 'true' : 'false'"
                        @click="setTab('action')"
                    >
                        <v-icon size="16">mdi-tray-full</v-icon>
                        Needs my action
                    </button>
                    <button
                        type="button"
                        class="pw-tab"
                        :class="{ 'is-active': tab === 'office' }"
                        role="tab"
                        :aria-selected="tab === 'office' ? 'true' : 'false'"
                        @click="setTab('office')"
                    >
                        <v-icon size="16">mdi-office-building-outline</v-icon>
                        My office
                    </button>
                </div>
            </div>

            <div class="pw-filterbar">
                <v-text-field
                    v-model="search"
                    prepend-inner-icon="mdi-magnify"
                    placeholder="Search reference, title, type or office"
                    aria-label="Search transactions by reference, title, type or office"
                    variant="outlined"
                    density="compact"
                    rounded="0"
                    hide-details
                    clearable
                    class="pw-search"
                />
                <v-select
                    v-model="filters.type"
                    :items="typeFilterOptions"
                    label="Transaction type"
                    variant="outlined"
                    density="compact"
                    rounded="0"
                    hide-details
                    clearable
                    class="pw-filter-select"
                />
                <template v-if="isHistory">
                    <v-text-field
                        v-model="filters.from"
                        type="date"
                        label="From"
                        :max="filters.to || undefined"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        class="pw-filter-date"
                    />
                    <v-text-field
                        v-model="filters.to"
                        type="date"
                        label="To"
                        :min="filters.from || undefined"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        class="pw-filter-date"
                    />
                </template>
                <div class="pw-filter-actions">
                    <button
                        v-if="showLateButton"
                        type="button"
                        class="pw-btn"
                        :class="{ 'pw-btn--danger': filters.late }"
                        :aria-pressed="filters.late"
                        @click="toggleLate"
                    >
                        <v-icon size="16">mdi-alarm</v-icon>
                        Due / overdue
                        <span class="pw-count">{{ lateCount }}</span>
                    </button>
                    <button
                        type="button"
                        class="pw-btn pw-sort"
                        :aria-label="`Sorted ${filters.order === 'asc' ? 'oldest' : 'newest'} first. Click to switch`"
                        @click="filters.order = filters.order === 'asc' ? 'desc' : 'asc'"
                    >
                        <v-icon size="16">{{ filters.order === 'asc' ? 'mdi-sort-calendar-ascending' : 'mdi-sort-calendar-descending' }}</v-icon>
                        {{ filters.order === 'asc' ? 'Oldest first' : 'Newest first' }}
                    </button>
                    <button v-if="filtersActive" type="button" class="pw-btn" @click="clearFilters">
                        <v-icon size="16">mdi-filter-remove-outline</v-icon>
                        Clear
                    </button>
                </div>
            </div>

            <v-card-text class="pw-body">
                <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-3">{{ error }}</v-alert>

                <div v-if="lgAndUp" class="pw-table-wrap">
                    <v-data-table
                        v-show="!loading || items.length"
                        v-model:page="page"
                        :items="shown"
                        :headers="headers"
                        item-key="id"
                        density="compact"
                        height="476"
                        fixed-header
                        :items-per-page="PER_PAGE"
                        hide-default-footer
                        hover
                        class="pw-table"
                        @click:row="(_, row) => open(row.item)"
                    >
                        <template #no-data>
                            <div class="pw-empty" style="min-height: 220px">
                                <v-icon size="34">mdi-file-search-outline</v-icon>
                                <span>{{ emptyText }}</span>
                            </div>
                        </template>
                        <template v-slot:[`item.reference_number`]="{ item }">
                            <span class="pw-ref">{{ item.reference_number || `#${item.id}` }}</span>
                        </template>
                        <template v-slot:[`item.title`]="{ item }">
                            <span class="pw-title-cell" :title="item.title">{{ item.title || "N/A" }}</span>
                        </template>
                        <template v-slot:[`item.type`]="{ item }">
                            <span class="pw-chip pw-chip--violet">
                                <v-icon size="13">mdi-tag-outline</v-icon>
                                {{ item.transaction_type?.name || item.transaction_type_name || "N/A" }}
                            </span>
                        </template>
                        <template v-slot:[`item.office`]="{ item }">
                            <span class="pw-chip pw-chip--blue">
                                <v-icon size="13">mdi-office-building-outline</v-icon>
                                {{ item.office?.name || "—" }}
                            </span>
                        </template>
                        <template v-slot:[`item.current_step`]="{ item }">
                            <v-menu open-on-hover location="end" open-delay="250">
                                <template #activator="{ props }">
                                    <span class="pw-chips" v-bind="props">
                                        <span
                                            class="pw-chip"
                                            :class="item.current_step?.is_end ? 'pw-chip--green' : 'pw-chip--blue'"
                                        >
                                            <v-icon size="13">{{ stepIcon(item.current_step) }}</v-icon>
                                            {{ item.current_step?.name || item.current_step?.code || "Unassigned" }}
                                        </span>
                                        <span
                                            v-if="dueState(item)"
                                            class="pw-chip"
                                            :class="dueState(item) === 'overdue' ? 'pw-chip--red' : 'pw-chip--amber'"
                                        >
                                            <v-icon size="13">{{ dueState(item) === 'overdue' ? 'mdi-alert-circle' : 'mdi-clock-alert-outline' }}</v-icon>
                                            {{ dueState(item) === 'overdue' ? 'Overdue' : 'Due' }}
                                        </span>
                                        <span v-if="item.is_done" class="pw-chip pw-chip--green">
                                            <v-icon size="13">mdi-flag-checkered</v-icon>
                                            Done
                                        </span>
                                    </span>
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
                            <div class="pw-meta-date">
                                <b>{{ fmtDate(item.created_at) }}</b>
                                <span>{{ fmtTime(item.created_at) }} · {{ timeAgo(item.created_at) }}</span>
                            </div>
                        </template>
                        <template v-slot:[`item.actions`]>
                            <span class="pw-row-open" aria-hidden="true">
                                <v-icon size="18">mdi-chevron-right</v-icon>
                            </span>
                        </template>
                    </v-data-table>
                </div>

                <div v-else class="pw-cards">
                    <button
                        v-for="item in pagedShown"
                        :key="item.id"
                        type="button"
                        class="pw-mcard"
                        @click="open(item)"
                    >
                        <div class="pw-mcard-top">
                            <div class="pw-mcard-main">
                                <span class="pw-ref">{{ item.reference_number || `#${item.id}` }}</span>
                                <span class="pw-mcard-title" :title="item.title">{{ item.title || "N/A" }}</span>
                            </div>
                            <span class="pw-mcard-next" aria-hidden="true">
                                <v-icon size="18">mdi-chevron-right</v-icon>
                            </span>
                        </div>
                        <div class="pw-chips">
                            <span class="pw-chip pw-chip--violet">
                                <v-icon size="13">mdi-tag-outline</v-icon>
                                {{ item.transaction_type?.name || item.transaction_type_name || "N/A" }}
                            </span>
                            <span
                                class="pw-chip"
                                :class="item.current_step?.is_end ? 'pw-chip--green' : 'pw-chip--blue'"
                            >
                                <v-icon size="13">{{ stepIcon(item.current_step) }}</v-icon>
                                {{ item.current_step?.name || item.current_step?.code || "Unassigned" }}
                            </span>
                            <span
                                v-if="dueState(item)"
                                class="pw-chip"
                                :class="dueState(item) === 'overdue' ? 'pw-chip--red' : 'pw-chip--amber'"
                            >
                                <v-icon size="13">{{ dueState(item) === 'overdue' ? 'mdi-alert-circle' : 'mdi-clock-alert-outline' }}</v-icon>
                                {{ dueState(item) === 'overdue' ? 'Overdue' : 'Due' }}
                            </span>
                            <span v-if="item.is_done" class="pw-chip pw-chip--green">
                                <v-icon size="13">mdi-flag-checkered</v-icon>
                                Done
                            </span>
                        </div>
                        <div class="pw-mcard-foot">
                            <span class="pw-mcard-meta">
                                <v-icon size="14">mdi-office-building-outline</v-icon>
                                {{ item.office?.name || "—" }}
                            </span>
                            <span>{{ fmtDate(item.created_at) }} · {{ timeAgo(item.created_at) }}</span>
                        </div>
                    </button>
                    <div v-if="!pagedShown.length && !loading" class="pw-empty">
                        <v-icon size="34">mdi-file-search-outline</v-icon>
                        <span>{{ emptyText }}</span>
                    </div>
                </div>

                <div v-if="pageCount > 1 && !loading" class="pw-pager">
                    <v-pagination v-model="page" :length="pageCount" :total-visible="5" density="compact" rounded="circle" />
                </div>
                <TableLoader v-if="loading && !items.length" label="transactions" icon="mdi-file-document-multiple" />
            </v-card-text>
        </v-card>

        <!-- New transaction: created under the user's own office -->
        <v-dialog v-model="dialog" max-width="700">
            <v-card rounded="0" elevation="0" class="pw-card">
                <header class="pw-head">
                    <div class="pw-icon" aria-hidden="true">
                        <v-icon size="26">mdi-plus</v-icon>
                    </div>
                    <div class="pw-head-main">
                        <div class="pw-title-row">
                            <h2 class="pw-title">New Transaction</h2>
                        </div>
                        <p class="pw-sub">Start a new paper for {{ user?.office?.name || "your office" }}.</p>
                    </div>
                </header>
                <v-card-text class="pw-body">
                    <v-alert v-if="createError" type="error" variant="tonal" class="mb-3">
                        {{ createError }}
                    </v-alert>
                    <v-select
                        v-model="form.transaction_type_id"
                        :items="typeOptions"
                        item-title="label"
                        item-value="id"
                        label="Transaction Type"
                        variant="outlined"
                        class="mb-3"
                    />
                    <v-text-field v-model="form.title" label="Title (optional)" variant="outlined" />
                    <v-alert type="info" variant="tonal" class="mt-3">
                        It starts at your office and follows the current steps of the chosen type.
                    </v-alert>
                </v-card-text>
                <v-card-actions class="justify-end pa-4">
                    <v-btn variant="text" rounded="pill" @click="dialog = false">Cancel</v-btn>
                    <v-btn
                        color="primary"
                        rounded="pill"
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
import { useDueCount } from "@/composables/useDueCount";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import { txNoticeShown } from "@/composables/useLoginNotice";
import { dueState } from "@/utils/processColor";
import TableLoader from "@/components/TableLoader.vue";
import LoadingVeil from "@/components/LoadingVeil.vue";
import StepProgress from "@/components/StepProgress.vue";
import WorklistSummary from "@/components/portal/WorklistSummary.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const typeStore = useTransactionTypes();
const { lgAndUp } = useDisplay();

// 7 rows per page, like the admin tables. The whole list is loaded once so
// search, filters and ordering cover every row, then paged here.
const PER_PAGE = 7;

// "action" = rows waiting on my role (opens the working page);
// "office" = my office's rows (opens the read/track page).
// Clerks (anyone who may approve) have the Approvals page for "Needs my
// action", so they only get the office list here.
const hasApprovals = computed(() => canUseApprovals(user.value));
// Archive (/portal/history) is this page in archive mode:
// completed rows only. The normal page lists open rows only.
const isHistory = computed(() => !!route.meta.history);

// Due label (clerks, on the live list only; Archive has nothing pending).
const showDue = computed(() => hasApprovals.value && !isHistory.value);
const { pastDue, almostDue } = useDueCount({ enabled: showDue });
const dueCount = computed(() => pastDue.value + almostDue.value);
const dueTitle = computed(() =>
    dueCount.value
        ? `${pastDue.value} past due, ${almostDue.value} almost due. Open Task.`
        : "No transactions are due right now.",
);
const tab = ref(isHistory.value || hasApprovals.value || route.query.tab === "office" || route.query.late === "1" ? "office" : "action");const items = ref([]);
const loading = ref(true);
// Full-page loader while the page opens; tab switches and refreshes use
// the in-table loader instead.
const entering = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);

// Filters: transaction type, newest/oldest, "late" (overdue or due only,
// set by the Pending overdue transactions button) and, in the Archive, a
// From–To range of created dates ("YYYY-MM-DD", both days included).
const emptyFilters = () => ({ type: null, late: false, from: null, to: null, order: "desc" });
const filters = ref({ ...emptyFilters(), late: !isHistory.value && route.query.late === "1" });
const filtersActive = computed(() => !!(filters.value.type || filters.value.late || filters.value.from || filters.value.to));
// Local midnight of a "YYYY-MM-DD" day (new Date("YYYY-MM-DD") would be UTC).
const dayStart = (ymd, addDays = 0) => {
    const [y, m, d] = ymd.split("-").map(Number);
    return new Date(y, m - 1, d + addDays).getTime();
};
function clearFilters() {
    filters.value = { ...emptyFilters(), order: filters.value.order };
}
const typeName = (t) => t.transaction_type?.name || t.transaction_type_name || "";
// Open rows here, completed rows stay in the active list until archived;
// the Archive shows explicitly archived rows only.
const scoped = computed(() => {
    if (isHistory.value) return items.value;
    return tab.value === "action"
        ? items.value.filter((t) => !t.is_done)
        : items.value;
});
const typeFilterOptions = computed(() => [...new Set(scoped.value.map(typeName).filter(Boolean))].sort());

const listSubtitle = computed(() => {
    if (isHistory.value) return "Archived papers visible to your office. This view is read-only.";
    if (tab.value === "action") return "Steps currently assigned to your role and office. Open one to work on it.";
    return "Your office’s active papers, plus anything waiting on your role.";
});

const summaryTiles = computed(() => {
    const list = scoped.value;
    if (isHistory.value) {
        const month = new Date().toLocaleDateString("en-PH", { timeZone: "Asia/Manila", year: "numeric", month: "numeric" });
        const thisMonth = list.filter((t) => t.created_at && new Date(t.created_at).toLocaleDateString("en-PH", {
            timeZone: "Asia/Manila", year: "numeric", month: "numeric",
        }) === month).length;
        return [
            { key: "archived", label: "Archived", value: list.length, icon: "mdi-archive-outline", tone: "info" },
            { key: "month", label: "This month", value: thisMonth, icon: "mdi-calendar-month-outline", tone: "success" },
            { key: "types", label: "Transaction types", value: new Set(list.map(typeName).filter(Boolean)).size, icon: "mdi-tag-multiple-outline", tone: "violet" },
            { key: "offices", label: "Offices", value: new Set(list.map((t) => t.office?.name).filter(Boolean)).size, icon: "mdi-office-building-outline", tone: "warning" },
        ];
    }
    const open = list.filter((t) => !t.is_done);
    const today = new Date().toLocaleDateString("en-PH", { timeZone: "Asia/Manila" });
    const lastTile = tab.value === "action"
        ? {
            key: "today",
            label: "Created today",
            value: list.filter((t) => t.created_at && new Date(t.created_at).toLocaleDateString("en-PH", {
                timeZone: "Asia/Manila",
            }) === today).length,
            icon: "mdi-calendar-today",
            tone: "success",
        }
        : { key: "completed", label: "Completed", value: list.filter((t) => t.is_done).length, icon: "mdi-check-circle-outline", tone: "success" };
    return [
        { key: "open", label: "Open", value: open.length, icon: "mdi-file-document-outline", tone: "info" },
        { key: "due", label: "Due soon", value: open.filter((t) => dueState(t) === "due").length, icon: "mdi-clock-alert-outline", tone: "warning" },
        { key: "overdue", label: "Overdue", value: open.filter((t) => dueState(t) === "overdue").length, icon: "mdi-alert-circle-outline", tone: "danger" },
        lastTile,
    ];
});

// The header button appears once the sign-in overdue notice has been shown.
const lateCount = computed(() => scoped.value.filter((t) => dueState(t)).length);
const showLateButton = computed(
    () => !isHistory.value && (filters.value.late || (txNoticeShown(user.value?.id) && lateCount.value > 0)),
);
function toggleLate() {
    filters.value.late = !filters.value.late;
}
// A link to this page with another ?tab= (e.g. the overdue notice's
// "Go to Task" for end users) while it is already open.
watch(
    () => route.query.tab,
    (next) => {
        if (isHistory.value || (next !== "action" && next !== "office") || next === tab.value) return;
        if (next === "action" && hasApprovals.value) return;
        tab.value = next;
        page.value = 1;
        fetchRows();
    },
);
// ?late=1 while already on this page turns on the overdue/due filter.
watch(
    () => route.query.late,
    (late) => {
        if (late !== "1" || isHistory.value) return;
        filters.value.late = true;
        if (tab.value !== "office") {
            tab.value = "office";
            fetchRows();
        }
    },
);

const shown = computed(() => {
    const q = String(search.value || "").trim().toLowerCase();
    const dir = filters.value.order === "asc" ? 1 : -1;
    const from = isHistory.value && filters.value.from ? dayStart(filters.value.from) : null;
    const to = isHistory.value && filters.value.to ? dayStart(filters.value.to, 1) : null;
    return scoped.value
        .filter((t) => {
            if (filters.value.type && typeName(t) !== filters.value.type) return false;
            if (filters.value.late && !dueState(t)) return false;
            if (from != null || to != null) {
                const at = new Date(t.created_at).getTime();
                if ((from != null && at < from) || (to != null && at >= to)) return false;
            }
            if (!q) return true;
            return [t.reference_number, t.title, typeName(t), t.office?.name, t.current_step?.name]
                .some((v) => String(v || "").toLowerCase().includes(q));
        })
        .sort((a, b) => dir * (new Date(a.created_at) - new Date(b.created_at) || a.id - b.id));
});
const pageCount = computed(() => Math.max(1, Math.ceil(shown.value.length / PER_PAGE)));
const pagedShown = computed(() => shown.value.slice((page.value - 1) * PER_PAGE, page.value * PER_PAGE));
const emptyText = computed(() => (
    scoped.value.length && (filtersActive.value || search.value)
        ? "No transactions match your search or filters."
        : isHistory.value
            ? "No archived transactions yet."
            : tab.value === "action"
                ? "Nothing is waiting on your role right now."
                : "No active transactions in your office."
));
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
    { title: "", key: "actions", sortable: false, align: "end", width: 56 },
];

const endpoint = () => {
    if (isHistory.value) return "/api/admin/transactions/archive";
    return tab.value === "action" ? "/api/transactions" : "/api/admin/transactions";
};

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

function setTab(next) {
    if (isHistory.value || next === tab.value) return;
    if (next === "action" && hasApprovals.value) return;
    tab.value = next;
    onTab();
}

function onTab() {
    page.value = 1;
    router.replace({ query: { ...route.query, tab: tab.value, new: undefined } });
    fetchRows();
}

function open(tx) {
    const from = isHistory.value
        ? "portal-archive"
        : tab.value === "action"
          ? "portal-action"
          : "portal";
    router.push({ path: `/portal/transactions/${tx.id}`, query: { from } });
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
        router.push({ path: `/portal/transactions/${tx.id}`, query: { from: "portal" } });
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
    entering.value = false;
    if (route.query.new === "1" && canCreate.value && !isHistory.value) openCreate();
});

useSmartPoll(() => {
    if (dialog.value) return;
    return fetchRows({ silent: true });
});
</script>

<style src="../../../css/portal-worklist.css"></style>
