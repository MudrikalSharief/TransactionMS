<template>
    <div>
        <LoadingVeil :show="entering" label="tasks" icon="mdi-clipboard-check-multiple-outline" />
        <v-card rounded="0" elevation="0" class="pw-card">
            <header class="pw-head">
                <div class="pw-icon" aria-hidden="true">
                    <v-icon size="28">mdi-clipboard-check-multiple-outline</v-icon>
                </div>
                <div class="pw-head-main">
                    <div class="pw-title-row">
                        <h1 class="pw-title">Task</h1>
                        <span class="pw-count">{{ rows.length }} pending {{ rows.length === 1 ? "task" : "tasks" }}</span>
                    </div>
                    <p class="pw-sub">
                        Steps waiting for your role and office. Receive and release them here.
                        <template v-if="awaitingCount"> Tick the rows marked “Not received” to receive several at once.</template>
                    </p>
                </div>
                <div class="pw-tools">
                    <button
                        v-if="selected.length"
                        type="button"
                        class="pw-btn pw-btn--primary"
                        :disabled="receiving"
                        @click="receiveSelected"
                    >
                        <v-progress-circular v-if="receiving" indeterminate size="16" width="2" color="white" />
                        <v-icon v-else size="17">mdi-inbox-arrow-down</v-icon>
                        Receive selected ({{ selected.length }})
                    </button>
                    <button type="button" class="pw-btn" :disabled="loading" @click="load">
                        <v-icon size="17">mdi-refresh</v-icon>
                        Refresh
                    </button>
                </div>
            </header>

            <WorklistSummary :tiles="summaryTiles" />

            <div class="pw-filterbar">
                <v-text-field
                    v-model="search"
                    prepend-inner-icon="mdi-magnify"
                    placeholder="Search tasks"
                    aria-label="Search tasks by reference, title, type or step"
                    variant="outlined"
                    density="compact"
                    rounded="0"
                    hide-details
                    clearable
                    class="pw-search"
                />
            </div>

            <v-card-text class="pw-body">
                <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

                <div v-if="lgAndUp" class="pw-table-wrap">
                    <v-data-table
                        v-show="!loading || rows.length"
                        v-model:page="page"
                        v-model="selected"
                        :items="filtered"
                        :headers="headers"
                        item-value="id"
                        :show-select="awaitingCount > 0"
                        :item-selectable="(item) => !!item.awaiting_receipt"
                        density="compact"
                        height="476"
                        fixed-header
                        :items-per-page="PER_PAGE"
                        hide-default-footer
                        :sort-by="[{ key: 'created_at', order: 'asc' }]"
                        hover
                        class="pw-table"
                        @click:row="(_, row) => open(row.item)"
                    >
                        <template #no-data>
                            <div class="pw-empty" style="min-height: 220px">
                                <v-icon size="34">mdi-clipboard-check-outline</v-icon>
                                <span>{{ search ? "No tasks match your search." : "You have no pending tasks." }}</span>
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
                                {{ item.transaction_type?.name || "N/A" }}
                            </span>
                        </template>
                        <template v-slot:[`item.current_step`]="{ item }">
                            <span class="pw-chips">
                                <span class="pw-chip pw-chip--blue">
                                    <v-icon size="13">mdi-map-marker-radius-outline</v-icon>
                                    {{ item.current_step?.name || item.current_step?.code || "—" }}
                                </span>
                                <span v-if="item.awaiting_receipt" class="pw-chip pw-chip--amber">
                                    <v-icon size="13">mdi-inbox-arrow-down</v-icon>
                                    Not received
                                </span>
                            </span>
                        </template>
                        <template v-slot:[`item.entered_at`]="{ item }">
                            <span class="pw-chip pw-chip--amber">
                                <v-icon size="13">mdi-timer-outline</v-icon>
                                {{ waited(item.entered_at) }}
                            </span>
                        </template>
                        <template v-slot:[`item.created_at`]="{ item }">
                            <div class="pw-meta-date">
                                <b>{{ fmtDate(item.created_at) }}</b>
                                <span>{{ timeAgo(item.created_at) }}</span>
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
                    <div
                        v-for="item in pagedRows"
                        :key="item.id"
                        class="pw-mcard"
                        role="button"
                        tabindex="0"
                        @click="open(item)"
                        @keydown.enter.prevent="open(item)"
                        @keydown.space.prevent="open(item)"
                    >
                        <div class="pw-mcard-top">
                            <div v-if="item.awaiting_receipt" class="pw-mcard-checkbox" @click.stop @keydown.stop>
                                <v-checkbox-btn
                                    :model-value="selected.includes(item.id)"
                                    :aria-label="`Select ${item.reference_number || 'task'} for bulk receive`"
                                    @update:model-value="toggleSelect(item.id)"
                                />
                            </div>
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
                                {{ item.transaction_type?.name || "N/A" }}
                            </span>
                            <span class="pw-chip pw-chip--blue">
                                <v-icon size="13">mdi-map-marker-radius-outline</v-icon>
                                {{ item.current_step?.name || item.current_step?.code || "—" }}
                            </span>
                            <span v-if="item.awaiting_receipt" class="pw-chip pw-chip--amber">
                                <v-icon size="13">mdi-inbox-arrow-down</v-icon>
                                Not received
                            </span>
                        </div>
                        <div class="pw-mcard-foot">
                            <span class="pw-chip pw-chip--amber">
                                <v-icon size="13">mdi-timer-outline</v-icon>
                                Waiting {{ waited(item.entered_at) }}
                            </span>
                            <span>{{ fmtDate(item.created_at) }} · {{ timeAgo(item.created_at) }}</span>
                        </div>
                    </div>
                    <div v-if="!pagedRows.length && !loading" class="pw-empty">
                        <v-icon size="34">mdi-clipboard-check-outline</v-icon>
                        <span>{{ search ? "No tasks match your search." : "You have no pending tasks." }}</span>
                    </div>
                </div>

                <div v-if="pageCount > 1 && !loading" class="pw-pager">
                    <v-pagination v-model="page" :length="pageCount" :total-visible="5" density="compact" rounded="circle" />
                </div>
                <TableLoader v-if="loading && !rows.length" label="tasks" icon="mdi-clipboard-check-multiple-outline" />
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
import { toast } from "@/composables/useToast";
import { dueState } from "@/utils/processColor";
import TableLoader from "@/components/TableLoader.vue";
import LoadingVeil from "@/components/LoadingVeil.vue";
import WorklistSummary from "@/components/portal/WorklistSummary.vue";

// Clerk approvals: every transaction waiting at a step the clerk may work
// (their role + their office; the server applies the same rule as Proceed).
const router = useRouter();
const { api } = useApi();
const { lgAndUp } = useDisplay();
const approvalBadge = useApprovalBadge();

const PER_PAGE = 7;
const rows = ref([]);
const loading = ref(true);
// Full-page loader while the page opens; refreshes use the in-table loader.
const entering = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Waiting", key: "entered_at" },
    { title: "Created", key: "created_at" },
    { title: "", key: "actions", sortable: false, align: "end" },
];

const filtered = computed(() => {
    const q = String(search.value || "").trim().toLowerCase();
    const base = !q ? rows.value : rows.value.filter((t) =>
        [t.reference_number, t.title, t.transaction_type?.name, t.current_step?.name]
            .some((v) => String(v || "").toLowerCase().includes(q)),
    );
    return [...base].sort((a, b) => (
        new Date(a.created_at || 0) - new Date(b.created_at || 0) || a.id - b.id
    ));
});
const pageCount = computed(() => Math.max(1, Math.ceil(filtered.value.length / PER_PAGE)));
const pagedRows = computed(() => filtered.value.slice((page.value - 1) * PER_PAGE, page.value * PER_PAGE));
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

// ---- Bulk receive ----
// Only rows still waiting to be received can be ticked; each is received
// with the same endpoint (and the same office + role check) as the
// Receive button on a transaction's page, one after another.
const selected = ref([]);
const receiving = ref(false);
const awaitingCount = computed(() => rows.value.filter((t) => t.awaiting_receipt).length);
const summaryTiles = computed(() => {
    const list = rows.value;
    return [
        { key: "pending", label: "Pending tasks", value: list.length, icon: "mdi-clipboard-check-outline", tone: "info" },
        { key: "not_received", label: "Not received", value: awaitingCount.value, icon: "mdi-inbox-arrow-down", tone: "warning" },
        { key: "due", label: "Due soon", value: list.filter((t) => dueState(t) === "due").length, icon: "mdi-clock-alert-outline", tone: "warning" },
        { key: "overdue", label: "Overdue", value: list.filter((t) => dueState(t) === "overdue").length, icon: "mdi-alert-circle-outline", tone: "danger" },
    ];
});
watch(rows, (list) => {
    const open = new Set(list.filter((t) => t.awaiting_receipt).map((t) => t.id));
    selected.value = selected.value.filter((id) => open.has(id));
});

function toggleSelect(id) {
    const index = selected.value.indexOf(id);
    selected.value = index >= 0
        ? selected.value.filter((value) => value !== id)
        : [...selected.value, id];
}

async function receiveSelected() {
    const ids = [...selected.value];
    if (!ids.length) return;
    receiving.value = true;
    let ok = 0;
    const failed = [];
    for (const id of ids) {
        try {
            await api.post(`/api/transactions/${id}/receive`);
            ok += 1;
        } catch (e) {
            const tx = rows.value.find((t) => t.id === id);
            failed.push(`${tx?.reference_number || `#${id}`}: ${e?.response?.data?.message || "could not be received"}`);
        }
    }
    receiving.value = false;
    selected.value = [];
    if (ok) toast.success(`${ok} ${ok === 1 ? "transaction" : "transactions"} received.`);
    if (failed.length) toast.error(`Not received: ${failed.join("; ")}`, { timeout: 9000 });
    await fetchAll({ silent: true });
}

function open(tx) {
    router.push({ path: `/portal/transactions/${tx.id}`, query: { from: "portal-approvals" } });
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

onMounted(async () => {
    await load();
    entering.value = false;
});
useSmartPoll(() => fetchAll({ silent: true }));
</script>

<style src="../../../css/portal-worklist.css"></style>
