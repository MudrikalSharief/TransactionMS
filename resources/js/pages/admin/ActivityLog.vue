<template>
    <div>
        <LoadingVeil :show="entering" label="activity log" icon="mdi-history" />
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center flex-wrap ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-history</v-icon>
                </v-avatar>
                <div class="head-text">
                    <div class="text-h6 font-weight-bold">Activity Log</div>
                    <div class="text-caption text-medium-emphasis">{{ scopeText }}</div>
                </div>
                <v-spacer />
                <v-btn
                    variant="outlined"
                    color="success"
                    rounded="0"
                    height="40"
                    prepend-icon="mdi-microsoft-excel"
                    :loading="exporting === 'excel'"
                    :disabled="!total"
                    @click="exportAs('excel')"
                >
                    Excel
                </v-btn>
                <v-btn
                    variant="outlined"
                    color="error"
                    rounded="0"
                    height="40"
                    prepend-icon="mdi-file-pdf-box"
                    :loading="exporting === 'pdf'"
                    :disabled="!total"
                    @click="exportAs('pdf')"
                >
                    PDF
                </v-btn>
                <v-btn
                    variant="outlined"
                    color="grey-darken-3"
                    rounded="0"
                    height="40"
                    :loading="loading"
                    icon="mdi-refresh"
                    aria-label="Refresh"
                    @click="load"
                />
            </v-card-title>
            <v-divider />

            <v-card-text class="pa-4">
                <v-alert type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Who did what, and when: every transaction step (created, forwarded, received, returned, finalized)
                    <template v-if="canSeeSetup"> and changes to accounts, roles, offices and workflows</template>.
                    Read-only.
                </v-alert>

                <div class="filter-bar mb-3">
                    <v-text-field
                        v-model="search"
                        prepend-inner-icon="mdi-magnify"
                        label="Search name, reference, action . . ."
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        class="fb-search"
                    />
                    <v-select
                        v-model="period"
                        :items="periodOptions"
                        label="Period"
                        prepend-inner-icon="mdi-calendar-range"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        class="fb-period"
                    />
                    <v-btn-toggle
                        v-if="canSeeSetup"
                        v-model="kind"
                        mandatory
                        density="comfortable"
                        rounded="0"
                        color="primary"
                        variant="outlined"
                        divided
                    >
                        <v-btn value="all">All</v-btn>
                        <v-btn value="transactions">Transactions</v-btn>
                        <v-btn value="setup">Setup</v-btn>
                    </v-btn-toggle>
                </div>

                <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

                <div class="table-wrap">
                    <v-table density="compact" class="lgu-table log-table" fixed-header height="460">
                        <thead>
                            <tr>
                                <th>When</th>
                                <th>Action</th>
                                <th>Details</th>
                                <th>Transaction</th>
                                <th>By</th>
                                <th>Remarks</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="!rows.length">
                                <td colspan="6" class="text-center text-medium-emphasis pa-6">
                                    {{ loading ? "Loading…" : "No activity for these filters." }}
                                </td>
                            </tr>
                            <tr v-for="r in rows" :key="r.id">
                                <td class="text-no-wrap">
                                    <div class="font-weight-bold">{{ fmtDate(r.at) }}</div>
                                    <div class="text-caption text-medium-emphasis">{{ fmtTime(r.at) }}</div>
                                </td>
                                <td class="text-no-wrap">
                                    <v-chip :color="tone(r)" variant="tonal" rounded="0" size="small" class="font-weight-bold">
                                        {{ r.action }}
                                    </v-chip>
                                </td>
                                <td>{{ r.summary || "—" }}</td>
                                <td>
                                    <a
                                        v-if="r.transaction_id"
                                        href="#"
                                        class="tx-link font-weight-bold"
                                        @click.prevent="router.push(`/transactions/${r.transaction_id}`)"
                                        >{{ r.reference_number }}</a
                                    >
                                    <span v-else class="text-medium-emphasis">—</span>
                                    <div v-if="r.process" class="text-caption text-medium-emphasis">{{ r.process }}</div>
                                </td>
                                <td>
                                    {{ r.actor?.name || "—" }}
                                    <div v-if="r.office" class="text-caption text-medium-emphasis">{{ r.office.code || r.office.name }}</div>
                                </td>
                                <td class="remarks">{{ r.remarks || "" }}</td>
                            </tr>
                        </tbody>
                    </v-table>
                </div>
                <div class="d-flex align-center justify-space-between flex-wrap ga-2 pt-3">
                    <span class="text-caption text-medium-emphasis">{{ total }} {{ total === 1 ? "entry" : "entries" }}</span>
                    <v-pagination v-if="lastPage > 1" v-model="page" :length="lastPage" :total-visible="5" density="compact" />
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { toast } from "@/composables/useToast";
import { periodOptions as dashPeriodOptions } from "@/utils/dashPeriod";
import { downloadXlsx, downloadPdf } from "@/utils/reportExport";
import LoadingVeil from "@/components/LoadingVeil.vue";

const router = useRouter();
const { api } = useApi();
const { user } = useAuth();

const PER_PAGE = 50;
const period = ref("all");
const periodOptions = computed(() => dashPeriodOptions());
const kind = ref("all");
const search = ref("");
const page = ref(1);

const rows = ref([]);
const total = ref(0);
const lastPage = ref(1);
const periodLabel = ref("All time");
const canSeeSetup = ref(false);
const loading = ref(false);
// Full-page loader while the page opens; later filter changes reuse the
// in-table "Loading…" row instead.
const entering = ref(true);
const error = ref("");
const exporting = ref("");

const params = (extra = {}) => ({
    period: period.value,
    kind: kind.value,
    q: (search.value || "").trim() || undefined,
    ...extra,
});

let request = 0;
async function load() {
    const mine = ++request;
    loading.value = true;
    try {
        const res = await api.get("/api/admin/activity", { params: params({ page: page.value, per_page: PER_PAGE }) });
        if (mine !== request) return;
        rows.value = res.data?.data ?? [];
        total.value = res.data?.meta?.total ?? rows.value.length;
        lastPage.value = res.data?.meta?.last_page ?? 1;
        periodLabel.value = res.data?.period?.label || "All time";
        canSeeSetup.value = !!res.data?.can_see_setup;
        error.value = "";
    } catch (e) {
        if (mine === request) error.value = e?.response?.data?.message || "Failed to load the activity log.";
    } finally {
        if (mine === request) {
            loading.value = false;
            entering.value = false;
        }
    }
}

// Typing waits a moment before searching.
let searchTimer = null;
watch(search, () => {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(() => {
        page.value = 1;
        load();
    }, 350);
});
watch([period, kind], () => {
    page.value = 1;
    load();
});
watch(page, load);
onMounted(load);

const scopeText = computed(() =>
    canSeeSetup.value ? `${periodLabel.value} · All offices` : `${periodLabel.value} · ${user.value?.office?.name || "Your office"}`,
);

function tone(r) {
    if (r.kind === "setup") return "grey-darken-2";
    if (/Returned|Sent back/.test(r.action)) return "warning";
    if (r.action === "Finalized") return "success";
    if (r.action === "Received") return "teal";
    return "primary";
}

const fmtDate = (iso) =>
    iso ? new Date(iso).toLocaleDateString("en-PH", { timeZone: "Asia/Manila", month: "short", day: "numeric", year: "numeric" }) : "";
const fmtTime = (iso) => (iso ? new Date(iso).toLocaleTimeString("en-PH", { timeZone: "Asia/Manila", hour: "numeric", minute: "2-digit" }) : "");

// Exports cover every entry matching the filters (all pages).
async function exportAs(type) {
    exporting.value = type;
    try {
        const all = [];
        let p = 1;
        let last = 1;
        do {
            const res = await api.get("/api/admin/activity", { params: params({ page: p, per_page: 200 }) });
            all.push(...(res.data?.data ?? []));
            last = res.data?.meta?.last_page ?? 1;
            p += 1;
        } while (p <= last && p <= 30);
        const payload = {
            title: "Activity Log",
            subtitle: `${scopeText.value}${search.value ? ` · Search: "${search.value}"` : ""} · ${all.length} ${all.length === 1 ? "entry" : "entries"}`,
            sections: [
                {
                    title: "Activity",
                    rows: all,
                    columns: [
                        { label: "Date", value: (r) => fmtDate(r.at) },
                        { label: "Time", value: (r) => fmtTime(r.at) },
                        { label: "Action", value: (r) => r.action },
                        { label: "Details", value: (r) => r.summary },
                        { label: "Reference", value: (r) => r.reference_number || "" },
                        { label: "Process", value: (r) => r.process || "" },
                        { label: "By", value: (r) => r.actor?.name || "" },
                        { label: "Office", value: (r) => r.office?.code || r.office?.name || "" },
                        { label: "Remarks", value: (r) => r.remarks || "" },
                    ],
                },
            ],
        };
        if (type === "excel") await downloadXlsx(`activity-log-${period.value}.xlsx`, payload);
        else await downloadPdf(`activity-log-${period.value}.pdf`, { ...payload, printedBy: user.value?.name });
    } catch (e) {
        toast.error(e?.response?.data?.message || "Export failed. Please try again.");
    } finally {
        exporting.value = "";
    }
}
</script>

<style scoped>
.head-text {
    flex: 1 1 auto;
    min-width: 0;
}
.filter-bar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 10px;
}
.fb-search {
    flex: 1 1 260px;
    max-width: 420px;
}
.fb-period {
    flex: 0 1 220px;
    min-width: 170px;
}
.table-wrap {
    overflow-x: auto;
}
.log-table {
    min-width: 860px;
}
.log-table :deep(thead th) {
    background-color: #1A1F2B !important;
    color: #fff !important;
    font-weight: 700 !important;
}
.remarks {
    max-width: 260px;
    white-space: pre-line;
    font-size: 0.82rem;
}
.tx-link {
    color: rgb(var(--v-theme-primary));
    text-decoration: none;
}
.tx-link:hover {
    text-decoration: underline;
}
</style>
