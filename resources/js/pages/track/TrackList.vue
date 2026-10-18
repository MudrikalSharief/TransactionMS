<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-map-marker-path</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Track Transactions</span>
                <v-spacer />
                <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-refresh" :loading="loading" @click="load">
                    Refresh
                </v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <v-alert type="info" variant="tonal" density="compact" rounded="0" class="mb-3" icon="mdi-eye-outline">
                    Viewer access: you can follow the progress of the transactions you created. Files and
                    attachments are not available to viewers.
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
                        v-show="!loading"
                        :items="items"
                        :headers="headers"
                        item-key="id"
                        density="compact"
                        height="398"
                        fixed-header
                        :items-per-page="25"
                        :sort-by="[{ key: 'created_at', order: 'desc' }]"
                        hover
                        class="lgu-table table-search"
                        @click:row="(_, row) => open(row.item)"
                    >
                        <template #no-data>
                            <div class="pa-6 text-medium-emphasis">
                                {{ search ? "No transactions match your search." : "You have no transactions to track yet." }}
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
                        <template v-slot:[`item.status`]="{ item }">
                            <v-chip :color="item.is_done ? 'success' : 'warning'" variant="tonal" rounded="0" size="small">
                                <v-icon start size="small">{{ item.is_done ? "mdi-check-circle-outline" : "mdi-progress-clock" }}</v-icon>
                                {{ item.is_done ? "Completed" : "In process" }}
                            </v-chip>
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
                            <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
                            <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
                        </template>
                    </v-data-table>
                    <div v-if="meta.lastPage > 1 && !loading" class="d-flex justify-center py-3">
                        <v-pagination v-model="page" :length="meta.lastPage" :total-visible="5" density="compact" @update:model-value="goToPage" />
                    </div>
                    <TableLoader v-if="loading" label="your transactions" icon="mdi-map-marker-path" style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useSmartPoll } from "@/composables/useSmartPoll";
import TableLoader from "@/components/TableLoader.vue";
import StepProgress from "@/components/StepProgress.vue";

const router = useRouter();
const { api } = useApi();

const items = ref([]);
const loading = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);
const meta = ref({ lastPage: 1 });

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Status", key: "status", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Created At", key: "created_at" },
];

async function fetchRows({ silent = false } = {}) {
    if (!silent) loading.value = true;
    try {
        const params = { page: page.value, per_page: 25 };
        if (search.value && search.value.trim()) params.q = search.value.trim();
        const res = await api.get("/api/viewer/transactions", { params });
        items.value = res.data?.data ?? [];
        meta.value = { lastPage: res.data?.meta?.last_page ?? 1 };
        error.value = "";
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load transactions.";
    } finally {
        loading.value = false;
    }
}

const load = () => fetchRows();

function goToPage(p) {
    page.value = p;
    fetchRows();
}

let searchTimer = null;
watch(search, () => {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(() => {
        page.value = 1;
        fetchRows({ silent: true });
    }, 400);
});

function open(tx) {
    router.push(`/track/${tx.id}`);
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
useSmartPoll(() => fetchRows({ silent: true }));
</script>
