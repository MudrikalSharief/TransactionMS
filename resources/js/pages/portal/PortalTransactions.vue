<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center flex-wrap ga-2 pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-file-document-multiple</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Transactions</span>
                <v-spacer />
                <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-refresh" :loading="loading" @click="load">
                    Refresh
                </v-btn>
                <v-btn
                    v-if="canCreate"
                    color="primary"
                    rounded="0"
                    prepend-icon="mdi-plus"
                    @click="openCreate"
                >
                    New Transaction
                </v-btn>
            </v-card-title>

            <v-divider />

            <v-tabs v-model="tab" color="primary" density="comfortable" @update:model-value="onTab">
                <v-tab value="action" class="font-weight-bold">
                    <v-icon start>mdi-tray-full</v-icon>
                    Needs my action
                </v-tab>
                <v-tab value="office" class="font-weight-bold">
                    <v-icon start>mdi-office-building-outline</v-icon>
                    My office
                </v-tab>
            </v-tabs>
            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">{{ error }}</v-alert>

                <v-alert v-if="tab === 'action'" type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Transactions currently on a step assigned to your role at your office. Open one to work on it.
                </v-alert>
                <v-alert v-else type="info" variant="tonal" density="compact" rounded="0" class="mb-3">
                    Every transaction that belongs to your office, plus any waiting on your role.
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
                                {{ tab === "action" ? "Nothing is waiting on your role right now." : "No transactions in your office yet." }}
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
                            <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
                            <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
                        </template>
                    </v-data-table>
                    <div v-if="meta.lastPage > 1 && !loading" class="d-flex justify-center py-3">
                        <v-pagination v-model="page" :length="meta.lastPage" :total-visible="5" density="compact" @update:model-value="goToPage" />
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
                        <v-icon color="#1E40AF">mdi-plus</v-icon>
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
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import TableLoader from "@/components/TableLoader.vue";
import StepProgress from "@/components/StepProgress.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();
const typeStore = useTransactionTypes();

// "action" = rows waiting on my role (opens the working page);
// "office" = my office's rows (opens the read/track page).
const tab = ref(route.query.tab === "office" ? "office" : "action");
const items = ref([]);
const loading = ref(true);
const error = ref("");
const search = ref("");
const page = ref(1);
const meta = ref({ total: 0, lastPage: 1 });

const canCreate = computed(() => user.value?.office != null);

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Office", key: "office", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Created At", key: "created_at" },
];

const endpoint = () => (tab.value === "action" ? "/api/transactions" : "/api/admin/transactions");

async function fetchRows({ silent = false } = {}) {
    if (!silent) loading.value = true;
    try {
        const params = { page: page.value, per_page: 25 };
        if (search.value && search.value.trim()) params.q = search.value.trim();
        const res = await api.get(endpoint(), { params });
        items.value = res.data?.data ?? [];
        meta.value = {
            total: res.data?.meta?.total ?? items.value.length,
            lastPage: res.data?.meta?.last_page ?? 1,
        };
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
    if (route.query.new === "1" && canCreate.value) openCreate();
});

useSmartPoll(() => {
    if (dialog.value) return;
    return fetchRows({ silent: true });
});
</script>
