<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center flex-wrap ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-chart-box-outline</v-icon>
                </v-avatar>
                <div class="head-text">
                    <div class="text-h6 font-weight-bold">Monitoring Reports</div>
                    <div class="text-caption text-medium-emphasis">{{ scopeText }}</div>
                </div>
                <v-spacer />
                <v-btn
                    variant="outlined"
                    color="success"
                    rounded="0"
                    height="40"
                    prepend-icon="mdi-microsoft-excel"
                    :disabled="!report"
                    @click="exportExcel"
                >
                    Excel
                </v-btn>
                <v-btn
                    variant="outlined"
                    color="error"
                    rounded="0"
                    height="40"
                    prepend-icon="mdi-file-pdf-box"
                    :disabled="!report"
                    @click="exportPdf"
                >
                    Print / PDF
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
                <div class="filter-bar mb-4">
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
                    <v-select
                        v-if="isSuperadmin"
                        v-model="offices"
                        :items="officeOptions"
                        label="Filing offices"
                        placeholder="All offices"
                        persistent-placeholder
                        prepend-inner-icon="mdi-office-building-outline"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        multiple
                        clearable
                        class="fb-offices"
                    >
                        <template #selection="{ item }">
                            <v-chip size="small" variant="tonal" rounded="0" class="mr-1">{{ item.raw.code }}</v-chip>
                        </template>
                    </v-select>
                </div>

                <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

                <div class="report-tiles mb-4" :class="{ 'is-stale': loading && report }">
                    <StatCard
                        v-for="t in tiles"
                        :key="t.key"
                        :label="t.label"
                        :value="t.value"
                        :hint="t.hint"
                        :variant="t.variant"
                        :icon="t.icon"
                        :loading="loading && !report"
                    />
                </div>

                <v-tabs v-model="tab" color="primary" density="comfortable" class="mb-1">
                    <v-tab v-for="s in sections" :key="s.key" :value="s.key" class="font-weight-bold">
                        <v-icon start>{{ s.icon }}</v-icon>
                        {{ s.title }}
                        <span class="tab-count">{{ s.rows.length }}</span>
                    </v-tab>
                </v-tabs>
                <v-divider class="mb-3" />

                <template v-for="s in sections" :key="s.key">
                    <div v-if="tab === s.key">
                        <v-alert type="info" variant="tonal" density="compact" rounded="0" class="mb-3">{{ s.note }}</v-alert>
                        <div class="table-wrap">
                            <v-table density="compact" class="lgu-table report-table" fixed-header :height="tableHeight">
                                <thead>
                                    <tr>
                                        <th v-for="c in s.columns" :key="c.label" :class="{ 'text-end': c.num }">{{ c.label }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-if="!s.rows.length">
                                        <td :colspan="s.columns.length" class="text-center text-medium-emphasis pa-6">
                                            {{ loading ? "Loading…" : s.empty }}
                                        </td>
                                    </tr>
                                    <tr v-for="(r, i) in s.rows" :key="i" :class="s.rowClass?.(r)">
                                        <td v-for="c in s.columns" :key="c.label" :class="{ 'text-end': c.num, 'font-weight-bold': c.strong }">
                                            {{ c.value(r) }}
                                        </td>
                                    </tr>
                                </tbody>
                            </v-table>
                        </div>
                    </div>
                </template>

                <p class="text-caption text-medium-emphasis mt-3 mb-0">
                    Times are working time: Saturdays and Sundays are not counted. Filed and in-process counts use the
                    date filed; completed uses the date finalized.
                </p>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth, isSuperadminUser, isOfficeAdminUser } from "@/composables/useAuth";
import { useOffices } from "@/composables/useOffices";
import { toast } from "@/composables/useToast";
import { periodOptions as dashPeriodOptions } from "@/utils/dashPeriod";
import { downloadCsv, printReport, fmtMinutes } from "@/utils/reportExport";
import StatCard from "@/components/StatCard.vue";

const { api } = useApi();
const { user } = useAuth();
const officeStore = useOffices();

const isSuperadmin = computed(() => isSuperadminUser(user.value));
const period = ref("all");
const periodOptions = computed(() => dashPeriodOptions());
const offices = ref([]);
const officeOptions = computed(() =>
    [...(officeStore.items.value || [])]
        .sort((a, b) => String(a.name).localeCompare(String(b.name)))
        .map((o) => ({ title: o.code ? `${o.name} (${o.code})` : o.name, value: o.id, code: o.code || o.name })),
);

const report = ref(null);
const loading = ref(false);
const error = ref("");
const tab = ref("offices");
const tableHeight = 420;

let request = 0;
async function load() {
    const mine = ++request;
    loading.value = true;
    try {
        const res = await api.get("/api/admin/reports/monitoring", {
            params: { period: period.value, ...(offices.value.length ? { offices: offices.value } : {}) },
        });
        if (mine !== request) return;
        report.value = res.data;
        error.value = "";
    } catch (e) {
        if (mine === request) error.value = e?.response?.data?.message || "Failed to load the report.";
    } finally {
        if (mine === request) loading.value = false;
    }
}
watch([period, offices], load, { deep: true });
onMounted(() => {
    load();
    if (isSuperadmin.value) officeStore.fetchAll({ silent: true }).catch(() => {});
});

const scopeText = computed(() => {
    const label = report.value?.period?.label || "All time";
    if (!isSuperadmin.value && isOfficeAdminUser(user.value)) {
        return `${label} · ${user.value?.office?.name || "Your office"} (filed by or passing through it)`;
    }
    const picked = offices.value.map((id) => officeOptions.value.find((o) => o.value === id)?.code).filter(Boolean);
    return `${label} · ${picked.length ? picked.join(", ") : "All offices"}`;
});

const totals = computed(() => report.value?.totals || {});
const tiles = computed(() => [
    { key: "filed", label: "Filed", value: totals.value.filed ?? "—", hint: "Created in the period", variant: "info", icon: "mdi-file-plus-outline" },
    { key: "in_process", label: "In process", value: totals.value.in_process ?? "—", hint: "Filed in the period, still open", variant: "warning", icon: "mdi-timer-sand" },
    { key: "completed", label: "Completed", value: totals.value.completed ?? "—", hint: "Finalized in the period", variant: "success", icon: "mdi-check-bold" },
    { key: "overdue", label: "Overdue", value: totals.value.overdue ?? "—", hint: "Open and past the station's limit", variant: "danger", icon: "mdi-alert" },
    {
        key: "avg",
        label: "Avg. completion",
        value: fmtMinutes(totals.value.avg_completion_minutes),
        hint: "Filed to finalized, working time",
        variant: "orange",
        icon: "mdi-clock-check-outline",
    },
]);

const officeLabel = (o) => (o ? (o.code ? `${o.code} — ${o.name}` : o.name) : "—");
const countColumns = [
    { label: "Filed", num: true, value: (r) => r.filed },
    { label: "In process", num: true, value: (r) => r.in_process },
    { label: "Completed", num: true, value: (r) => r.completed },
    { label: "Overdue", num: true, value: (r) => r.overdue },
    { label: "Avg. completion", num: true, value: (r) => fmtMinutes(r.avg_completion_minutes) },
];

const sections = computed(() => {
    const d = report.value || {};
    return [
        {
            key: "offices",
            title: "By office",
            icon: "mdi-office-building-outline",
            note: "Transactions per filing office.",
            empty: "No transactions in this period.",
            rows: d.by_office || [],
            columns: [{ label: "Office", strong: true, value: (r) => officeLabel(r.item) }, ...countColumns],
        },
        {
            key: "processes",
            title: "By process",
            icon: "mdi-swap-horizontal",
            note: "Transactions per transaction type.",
            empty: "No transactions in this period.",
            rows: d.by_process || [],
            columns: [{ label: "Process", strong: true, value: (r) => r.item?.name || "—" }, ...countColumns],
        },
        {
            key: "steps",
            title: "Time per station",
            icon: "mdi-timer-alert-outline",
            note: "How long papers stay at each station. Worst first: stations most often over their time limit, then those holding the most papers now.",
            empty: "No station activity in this period.",
            rows: d.steps || [],
            rowClass: (r) => (r.over_limit_pct >= 50 ? "row-hot" : r.over_limit ? "row-warm" : ""),
            columns: [
                { label: "Station", strong: true, value: (r) => r.step },
                { label: "Office", value: (r) => r.office?.code || r.office?.name || "—" },
                { label: "Process", value: (r) => r.process || "—" },
                { label: "Limit", num: true, value: (r) => (r.sla_minutes ? fmtMinutes(r.sla_minutes) : "None") },
                { label: "Handled", num: true, value: (r) => r.handled },
                { label: "Waiting now", num: true, value: (r) => r.waiting_now },
                { label: "Avg. stay", num: true, value: (r) => fmtMinutes(r.avg_wait_minutes) },
                { label: "Longest stay", num: true, value: (r) => fmtMinutes(r.max_wait_minutes) },
                { label: "Avg. to receive", num: true, value: (r) => fmtMinutes(r.avg_receipt_minutes) },
                { label: "Over limit", num: true, value: (r) => `${r.over_limit} (${r.over_limit_pct}%)` },
            ],
        },
        {
            key: "requirements",
            title: "Missing requirements",
            icon: "mdi-file-alert-outline",
            note: "Required items still incomplete on open transactions filed in the period, at their current station: physical copy not checked, or no file attached.",
            empty: "No missing requirements on open transactions.",
            rows: d.requirements || [],
            columns: [
                { label: "Requirement", strong: true, value: (r) => r.requirement },
                { label: "Process", value: (r) => r.process || "—" },
                { label: "Station", value: (r) => r.step },
                { label: "Office", value: (r) => r.office?.code || r.office?.name || "—" },
                { label: "Transactions", num: true, value: (r) => r.transactions },
                { label: "Not checked", num: true, value: (r) => r.not_checked },
                { label: "No file", num: true, value: (r) => r.no_file },
            ],
        },
    ];
});

const exportPayload = () => ({
    title: "Monitoring Report",
    subtitle: `${scopeText.value} · Times are working time (weekends not counted)`,
    sections: [
        { title: "Summary", columns: [{ label: "Measure", value: (r) => r.label }, { label: "Value", value: (r) => r.value }], rows: tiles.value },
        ...sections.value,
    ],
});

function exportExcel() {
    const key = report.value?.period?.key || "all";
    downloadCsv(`monitoring-report-${key}.csv`, exportPayload());
}

function exportPdf() {
    if (!printReport({ ...exportPayload(), printedBy: user.value?.name })) {
        toast.warning("Allow pop-ups for this site to print the report.");
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
    gap: 10px;
}
.fb-period {
    flex: 0 1 240px;
    min-width: 180px;
}
.fb-offices {
    flex: 1 1 280px;
    max-width: 480px;
}
.report-tiles {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
    gap: 12px;
    transition: opacity 0.2s ease;
}
.report-tiles.is-stale {
    opacity: 0.6;
}
.tab-count {
    margin-left: 8px;
    min-width: 22px;
    padding: 0 6px;
    background: rgba(var(--v-theme-primary), 0.12);
    font-size: 0.75rem;
    text-align: center;
}
.table-wrap {
    overflow-x: auto;
}
.report-table {
    min-width: 760px;
}
.report-table :deep(thead th) {
    background-color: #1A1F2B !important;
    color: #fff !important;
    font-weight: 700 !important;
    white-space: nowrap;
}
.report-table :deep(td) {
    font-variant-numeric: tabular-nums;
}
.report-table .row-hot {
    background: rgba(var(--v-theme-error), 0.08);
}
.report-table .row-warm {
    background: rgba(var(--v-theme-warning), 0.08);
}
</style>
