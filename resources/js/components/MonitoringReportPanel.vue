<template>
    <!-- Dashboard "Reports" view: the monitoring report in one card that
         fills the dashboard grid. Tables show only the rows that fit (pages
         instead of scrolling); Excel / Print-PDF export every row. -->
    <v-card rounded="0" elevation="1" class="lgu-card dash-panel d-flex flex-column" style="height: 100%; width: 100%">
        <v-card-title class="d-flex align-center flex-wrap ga-2 lgu-head dash-head report-head">
            <v-avatar color="white" rounded="0" size="34" class="mr-1 lgu-head-avatar">
                <v-icon color="#005EED" size="20">mdi-chart-box-outline</v-icon>
            </v-avatar>
            <div class="dash-head-title">
                <div class="text-subtitle-1 font-weight-bold">Reports</div>
                <div class="dash-panel-sub text-truncate">{{ scopeText }}</div>
            </div>
            <v-btn-toggle v-model="tab" mandatory density="compact" color="primary" variant="outlined" divided class="report-tabs">
                <v-btn v-for="s in sections" :key="s.key" :value="s.key" size="small" class="text-none">
                    <v-icon start size="16">{{ s.icon }}</v-icon>{{ s.title }}
                    <span class="tab-count">{{ s.rows.length }}</span>
                </v-btn>
            </v-btn-toggle>
            <v-spacer />
            <v-btn variant="outlined" color="success" rounded="0" size="small" prepend-icon="mdi-microsoft-excel" :disabled="!report" :loading="exporting === 'excel'" @click="exportAs('excel')">
                Excel
            </v-btn>
            <v-btn variant="outlined" color="error" rounded="0" size="small" prepend-icon="mdi-file-pdf-box" :disabled="!report" :loading="exporting === 'pdf'" @click="exportAs('pdf')">
                PDF
            </v-btn>
        </v-card-title>

        <v-alert v-if="error" type="error" variant="tonal" density="compact" rounded="0" class="ma-2">{{ error }}</v-alert>

        <div class="report-note text-caption text-medium-emphasis">
            <v-icon size="14" class="mr-1">mdi-information-outline</v-icon>{{ current.note }}
        </div>

        <v-card-text v-fit-body="'report'" class="pa-0 dash-body report-body" :class="{ 'is-stale': loading && report }">
            <div class="table-wrap">
                <table class="report-table">
                    <thead>
                        <tr>
                            <th v-for="c in current.columns" :key="c.label" :class="{ num: c.num }">{{ c.label }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="!current.rows.length">
                            <td :colspan="current.columns.length" class="empty">{{ loading ? "Loading…" : current.empty }}</td>
                        </tr>
                        <tr v-for="(r, i) in pageRows" :key="i" :class="current.rowClass?.(r)">
                            <td v-for="c in current.columns" :key="c.label" :class="{ num: c.num, strong: c.strong }">{{ c.value(r) }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </v-card-text>

        <div class="report-foot">
            <span class="text-caption text-medium-emphasis">Times are working time (weekends not counted).</span>
            <v-pagination v-if="pageCount > 1" v-model="page" :length="pageCount" :total-visible="5" density="compact" size="small" />
        </div>
    </v-card>
</template>

<script setup>
import { computed, ref, watch } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { useFitScreen } from "@/composables/useFitScreen";
import { toast } from "@/composables/useToast";
import { downloadXlsx, downloadPdf, fmtMinutes } from "@/utils/reportExport";

const props = defineProps({
    // Dashboard Period filter value ('all' | 'this_week' | 'YYYY-MM').
    period: { type: String, default: "all" },
    // Superadmin office filter (office admins are scoped by the server).
    offices: { type: Array, default: () => [] },
    // Label of the office scope shown under the title ("All offices", "CSD"…).
    scopeLabel: { type: String, default: "" },
});

const { api } = useApi();
const { user } = useAuth();
const { vFitBody, rows } = useFitScreen();

// Table rows that fit the card body: header 32px + 34px per row.
const ROW_PX = 34;
const HEAD_PX = 32;

const report = ref(null);
const loading = ref(false);
const error = ref("");
const tab = ref("offices");
const page = ref(1);

let request = 0;
async function load() {
    const mine = ++request;
    loading.value = true;
    try {
        const res = await api.get("/api/admin/reports/monitoring", {
            params: { period: props.period, ...(props.offices.length ? { offices: props.offices } : {}) },
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
watch(() => [props.period, props.offices], load, { deep: true, immediate: true });

const scopeText = computed(() => [report.value?.period?.label || "All time", props.scopeLabel].filter(Boolean).join(" · "));

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
            note: "How long papers stay at each station. Worst first: most often over the time limit, then most papers waiting now.",
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
const current = computed(() => sections.value.find((s) => s.key === tab.value) || sections.value[0]);

// Pages instead of a scrollbar: as many rows as the card body holds.
const perPage = computed(() => rows("report", ROW_PX, 10, HEAD_PX));
const pageCount = computed(() => Math.max(1, Math.ceil(current.value.rows.length / perPage.value)));
const pageRows = computed(() => current.value.rows.slice((page.value - 1) * perPage.value, page.value * perPage.value));
watch([tab, report], () => { page.value = 1; });
watch(pageCount, (n) => { if (page.value > n) page.value = n; });

// Exports cover every row of every section.
const exportPayload = () => {
    const t = report.value?.totals || {};
    return {
        title: "Monitoring Report",
        subtitle: `${scopeText.value} · Times are working time (weekends not counted)`,
        sections: [
            {
                title: "Summary",
                columns: [{ label: "Measure", value: (r) => r[0] }, { label: "Value", value: (r) => r[1] }],
                rows: [["Filed", t.filed ?? 0], ["In process", t.in_process ?? 0], ["Completed", t.completed ?? 0], ["Overdue", t.overdue ?? 0]],
            },
            ...sections.value,
        ],
    };
};
// Builds the file in the browser and downloads it right away.
const exporting = ref("");
async function exportAs(type) {
    exporting.value = type;
    const name = `monitoring-report-${report.value?.period?.key || "all"}`;
    try {
        if (type === "excel") await downloadXlsx(`${name}.xlsx`, exportPayload());
        else await downloadPdf(`${name}.pdf`, { ...exportPayload(), printedBy: user.value?.name });
    } catch {
        toast.error("The file could not be created. Please try again.");
    } finally {
        exporting.value = "";
    }
}

defineExpose({ reload: load });
</script>

<style scoped>
.report-head {
    row-gap: 6px;
}
/* Same small subtitle as the other dashboard cards. */
.dash-panel-sub {
    font-size: 0.75rem;
    font-weight: 400;
    line-height: 1.3;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.report-tabs {
    height: 32px !important;
}
.report-tabs :deep(.v-btn) {
    height: 32px !important;
    letter-spacing: 0;
    font-weight: 600;
}
.tab-count {
    margin-left: 6px;
    min-width: 20px;
    padding: 0 5px;
    background: rgba(var(--v-theme-primary), 0.12);
    font-size: 0.72rem;
    text-align: center;
}
.report-note {
    display: flex;
    align-items: center;
    padding: 6px 14px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
}
.report-body {
    transition: opacity 0.2s ease;
}
.report-body.is-stale {
    opacity: 0.6;
}
.table-wrap {
    overflow-x: auto;
    overflow-y: hidden;
}
.report-table {
    width: 100%;
    min-width: 720px;
    border-collapse: collapse;
    font-size: 0.82rem;
    font-variant-numeric: tabular-nums;
}
.report-table th {
    height: 32px;
    padding: 0 10px;
    background: #1A1F2B;
    color: #fff;
    font-weight: 700;
    text-align: left;
    white-space: nowrap;
}
.report-table td {
    height: 34px;
    padding: 0 10px;
    border-bottom: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    white-space: nowrap;
}
.report-table .num {
    text-align: right;
}
/* One line per row (the fit maths counts fixed-height rows); long names end in "…". */
.report-table .strong {
    max-width: 280px;
    overflow: hidden;
    text-overflow: ellipsis;
    font-weight: 700;
}
.report-table .empty {
    padding: 24px;
    text-align: center;
    color: rgba(var(--v-theme-on-surface), 0.6);
}
.report-table .row-hot {
    background: rgba(var(--v-theme-error), 0.08);
}
.report-table .row-warm {
    background: rgba(var(--v-theme-warning), 0.08);
}
.report-foot {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    padding: 4px 12px;
    border-top: 1px solid rgba(var(--v-theme-on-surface), 0.08);
    min-height: 36px;
}
</style>
