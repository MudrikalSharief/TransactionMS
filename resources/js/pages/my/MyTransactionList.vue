<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-file-document-multiple</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">{{ officeAdmin ? 'Office Transactions' : 'My Transactions' }}</span>
                <ScopeChip v-if="officeAdmin" class="ml-3" />
                <v-spacer />
                <v-btn
                    v-if="officeAdmin"
                    variant="outlined"
                    color="primary"
                    rounded="0"
                    prepend-icon="mdi-plus"
                    class="mr-2"
                    @click="openCreate"
                >
                    New Transaction
                </v-btn>
                <v-tooltip location="bottom" max-width="480">
                    <template #activator="{ props }">
                        <v-btn
                            icon="mdi-help-circle-outline"
                            variant="text"
                            color="grey-darken-3"
                            v-bind="props"
                            class="mr-1"
                        />
                    </template>
                    <GuideTable title="Column guide" :sections="guideSections" horizontal />
                </v-tooltip>
                <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-refresh" @click="load" :loading="loading">Refresh</v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>

                <v-alert v-if="!items.length && !loading" type="info" variant="tonal" class="mb-3">
                    {{ officeAdmin
                        ? 'No transactions filed by or passing through your office yet.'
                        : 'No transactions assigned to your role on the current step.' }}
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
                    :items="filtered"
                    :headers="headers"
                    :loading="loading"
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
                    <template v-slot:[`item.reference_number`]="{ item }">
                        <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
                            {{ item.reference_number || `#${item.id}` }}
                        </v-chip>
                    </template>

                    <template v-slot:[`item.title`]="{ item }">
                        <span class="font-weight-bold">{{ item.title || 'N/A' }}</span>
                    </template>

                    <template v-slot:[`item.type`]="{ item }">
                        <v-chip color="info" variant="tonal" rounded="0" size="small">
                            <v-icon start size="small">mdi-tag-outline</v-icon>
                            {{ item.transaction_type?.name || item.transaction_type_name || 'N/A' }}
                        </v-chip>
                    </template>

                    <template v-slot:[`item.office`]="{ item }">
                        <span v-if="item.office?.name" class="text-medium-emphasis">
                            {{ item.office.name }}
                        </span>
                        <span v-else class="text-medium-emphasis">—</span>
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
                                    {{ item.current_step?.name || item.current_step?.code || 'Unassigned' }}
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
                <TableLoader v-if="loading" label="my transactions" icon="mdi-file-document-multiple" style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>

        <!-- Office admins start transactions for processes their office files. -->
        <v-dialog v-model="createDialog" max-width="640">
            <v-card rounded="0">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                        <v-icon color="#1E40AF">mdi-file-document-plus-outline</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">New Transaction</span>
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" color="grey-darken-3" @click="createDialog = false" />
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-5">
                    <v-alert v-if="createError" type="error" variant="tonal" density="compact" rounded="0" class="mb-3">
                        {{ createError }}
                    </v-alert>
                    <v-select
                        v-model="createForm.transaction_type_id"
                        :items="officeTypes"
                        item-title="name"
                        item-value="id"
                        label="Process"
                        :loading="typesLoading"
                        :no-data-text="typesLoading ? 'Loading…' : 'Your office has no processes to file yet. Ask a superadmin to link one.'"
                    />
                    <v-text-field v-model="createForm.title" label="Title (optional)" />
                    <div class="text-caption text-medium-emphasis">
                        Filed under <b>{{ auth.user.value?.office?.name }}</b>. It follows the live steps of the chosen process.
                    </div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end pa-4">
                    <v-btn variant="text" @click="createDialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="creating"
                        :disabled="!createForm.transaction_type_id"
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
import { useRouter } from "vue-router";
import { useMyTransactions } from "@/composables/useMyTransactions";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { useAuth, isOfficeAdminUser } from "@/composables/useAuth";
import { useApi } from "@/composables/useApi";
import TableLoader from '@/components/TableLoader.vue';
import StepProgress from '@/components/StepProgress.vue';
import GuideTable from '@/components/GuideTable.vue';
import ScopeChip from '@/components/ScopeChip.vue';

const router = useRouter();
const auth = useAuth();
const { api } = useApi();
const { items, loading, meta, fetchAll } = useMyTransactions();
const page = ref(1);

// Office admins see their office's whole scope here and can file new ones.
const officeAdmin = computed(() => isOfficeAdminUser(auth.user.value));

const createDialog = ref(false);
const createForm = ref({ transaction_type_id: null, title: "" });
const createError = ref("");
const creating = ref(false);
const officeTypes = ref([]);
const typesLoading = ref(false);

async function openCreate() {
    createError.value = "";
    createForm.value = { transaction_type_id: null, title: "" };
    createDialog.value = true;
    if (officeTypes.value.length) return;
    typesLoading.value = true;
    try {
        const res = await api.get("/api/office/transaction-types");
        officeTypes.value = res.data.data ?? res.data;
    } catch (e) {
        createError.value = e?.response?.data?.message || "Failed to load your office's processes.";
    } finally {
        typesLoading.value = false;
    }
}

async function createTx() {
    creating.value = true;
    createError.value = "";
    try {
        const res = await api.post("/api/transactions", {
            transaction_type_id: createForm.value.transaction_type_id,
            title: createForm.value.title || null,
        });
        const tx = res.data.data ?? res.data;
        createDialog.value = false;
        router.push(`/my/transactions/${tx.id}`);
    } catch (e) {
        createError.value = e?.response?.data?.message || "Create failed.";
    } finally {
        creating.value = false;
    }
}

const error = ref("");
const search = ref("");

const guideSections = [
    {
        title: "COLUMNS",
        rows: [
            { term: "REFERENCE", text: "UNIQUE TRACKING CODE — QUOTE IT WHEN FOLLOWING UP" },
            { term: "TITLE", text: "SHORT NAME OF THE REQUEST" },
            { term: "TRANSACTION TYPE", text: "WHAT KIND OF REQUEST IT IS" },
            { term: "OFFICE", text: "THE OFFICE THE REQUEST BELONGS TO (BLANK IF NONE)" },
            { term: "CURRENT STEP", text: "WHERE IT IS RIGHT NOW (HOVER THE CHIP FOR PROGRESS)" },
            { term: "CREATED AT", text: "WHEN THE REQUEST WAS SUBMITTED" },
        ],
    },
];

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Office", key: "office", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Created At", key: "created_at" },
];

// Server-filtered (?q= + 25-row pages): avoids client filtering of heavy
// rows on weak CPUs and keeps bad-network payloads small.
const filtered = computed(() => items.value || []);

let searchTimer = null;
watch(search, () => {
    if (searchTimer) clearTimeout(searchTimer);
    searchTimer = setTimeout(async () => {
        page.value = 1;
        try {
            await fetchAll({ q: search.value, page: 1 });
        } catch {
            /* keep current rows */
        }
    }, 400);
});

async function goToPage(p) {
    page.value = p;
    try {
        await fetchAll({ q: search.value, page: p });
    } catch {
        /* keep current rows */
    }
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

async function load() {
    error.value = "";
    try {
        await fetchAll({ q: search.value, page: page.value });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load transactions.";
    }
}

function open(tx) {
    router.push(`/my/transactions/${tx.id}`);
}

onMounted(load);

// Silent 20s smart-poll: version changed → refresh rows in place.
// Silent fetch keeps search text, sort, pagination, and scroll untouched;
// no loader flash, no page reload.
useSmartPoll(async () => {
    try {
        await fetchAll({ silent: true, q: search.value, page: page.value });
    } catch {
        /* next tick retries */
    }
});
</script>
