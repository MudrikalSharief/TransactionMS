<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-multiple-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Approvals</span>
                <v-spacer />
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
                    <GuideTable title="Approval guide" :sections="guideSections" horizontal />
                </v-tooltip>
                <v-btn color="grey-darken-3" rounded="0" prepend-icon="mdi-refresh" @click="load" :loading="loading">Refresh</v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>

                <div class="d-flex flex-wrap align-center ga-3 mb-4">
                    <v-select
                        v-model="processFilter"
                        :items="processOptions"
                        item-title="title"
                        item-value="value"
                        label="Process"
                        variant="outlined"
                        density="compact"
                        rounded="0"
                        hide-details
                        clearable
                        style="max-width: 360px; min-width: 240px"
                    />
                    <v-switch
                        v-model="pendingOnly"
                        label="Pending only"
                        color="primary"
                        density="compact"
                        hide-details
                        inset
                    />
                </div>

                <TableLoader v-if="loading && !items.length" label="approvals" icon="mdi-clipboard-check-multiple-outline" />

                <v-alert v-else-if="!groups.length" type="info" variant="tonal">
                    Nothing waiting for your approval.
                </v-alert>

                <v-card
                    v-for="group in groups"
                    :key="group.step.id"
                    rounded="0"
                    variant="outlined"
                    class="mb-4"
                >
                    <v-card-title class="d-flex align-center flex-wrap ga-2 py-3">
                        <v-icon color="primary">mdi-map-marker-radius-outline</v-icon>
                        <span class="font-weight-bold">{{ group.step.name || group.step.code }}</span>
                        <v-chip v-if="group.step.stage" size="small" rounded="0" variant="tonal" color="info">
                            {{ group.step.stage }}
                        </v-chip>
                        <v-spacer />
                        <v-chip size="small" rounded="0" variant="flat" :color="group.pendingCount ? 'warning' : 'success'">
                            {{ group.pendingCount }} pending · {{ group.transactions.length }} total
                        </v-chip>
                    </v-card-title>

                    <v-divider />

                    <v-expansion-panels v-model="openPanels" multiple variant="accordion" rounded="0">
                        <v-expansion-panel
                            v-for="tx in group.transactions"
                            :key="tx.id"
                            :value="tx.id"
                            rounded="0"
                        >
                            <v-expansion-panel-title>
                                <div class="d-flex align-center flex-wrap ga-2" style="width: 100%">
                                    <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
                                        {{ tx.reference_number || `#${tx.id}` }}
                                    </v-chip>
                                    <span class="font-weight-bold">{{ tx.title || "N/A" }}</span>
                                    <v-chip color="info" variant="tonal" rounded="0" size="small">
                                        <v-icon start size="small">mdi-tag-outline</v-icon>
                                        {{ tx.transaction_type?.name || "N/A" }}
                                    </v-chip>
                                    <v-spacer />
                                    <span class="text-caption text-medium-emphasis mr-2">
                                        waiting {{ waited(tx.entered_at) }}
                                    </span>
                                    <v-chip
                                        size="small"
                                        rounded="0"
                                        variant="flat"
                                        :color="progress(tx).done === progress(tx).total ? 'success' : 'warning'"
                                        class="mr-2"
                                    >
                                        {{ progress(tx).done }}/{{ progress(tx).total }} validated
                                    </v-chip>
                                </div>
                            </v-expansion-panel-title>

                            <v-expansion-panel-text>
                                <template v-for="section in sections(tx)" :key="section.key">
                                    <div class="text-subtitle-2 font-weight-bold mb-1">
                                        {{ section.title }}
                                    </div>
                                    <v-list density="compact" class="py-0 mb-3">
                                        <v-list-item
                                            v-for="item in section.items"
                                            :key="item.id"
                                            class="px-0 approval-item"
                                        >
                                            <template #prepend>
                                                <v-checkbox-btn
                                                    :model-value="item.checked"
                                                    :disabled="isBusy(tx.id) || (item.checked && !canUnvalidate(item))"
                                                    color="primary"
                                                    @update:model-value="(v) => onValidate(tx, item, v)"
                                                />
                                            </template>
                                            <v-list-item-title class="font-weight-bold">
                                                {{ item.name }}
                                                <v-chip
                                                    size="x-small"
                                                    rounded="0"
                                                    variant="tonal"
                                                    :color="item.is_required ? 'error' : 'grey'"
                                                    class="ml-2"
                                                >
                                                    {{ item.is_required ? "Required" : "Optional" }}
                                                </v-chip>
                                            </v-list-item-title>
                                            <v-list-item-subtitle class="mb-1">
                                                <span v-if="item.checked">
                                                    Validated by {{ item.checked_by?.name || "someone" }} · {{ fmtDateTime(item.checked_at) }}
                                                </span>
                                                <span v-else>Not validated yet</span>
                                            </v-list-item-subtitle>
                                            <AttachmentList
                                                v-if="item.attachments?.length"
                                                :items="item.attachments"
                                                :tx-id="tx.id"
                                                compact
                                            />
                                            <div
                                                v-else-if="section.key !== 'custom'"
                                                class="text-caption text-warning"
                                            >
                                                No files uploaded.
                                            </div>
                                        </v-list-item>
                                    </v-list>
                                </template>

                                <div class="d-flex align-center">
                                    <v-alert
                                        v-if="missingRequired(tx).length"
                                        type="warning"
                                        variant="tonal"
                                        density="compact"
                                        class="mr-3"
                                    >
                                        Validate before Proceed: {{ missingRequired(tx).join(", ") }}.
                                    </v-alert>
                                    <v-alert v-else type="success" variant="tonal" density="compact" class="mr-3">
                                        All required items validated. Open the transaction to Proceed.
                                    </v-alert>
                                    <v-spacer />
                                    <v-btn
                                        color="grey-darken-3"
                                        rounded="0"
                                        append-icon="mdi-arrow-right"
                                        @click="openTx(tx)"
                                    >
                                        Open
                                    </v-btn>
                                </div>
                            </v-expansion-panel-text>
                        </v-expansion-panel>
                    </v-expansion-panels>
                </v-card>
            </v-card-text>
        </v-card>

        <v-snackbar v-model="snack.show" :color="snack.color" timeout="4000">
            {{ snack.text }}
        </v-snackbar>
    </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useApprovals } from "@/composables/useApprovals";
import { useAuth } from "@/composables/useAuth";
import TableLoader from "@/components/TableLoader.vue";
import GuideTable from "@/components/GuideTable.vue";
import AttachmentList from "@/components/AttachmentList.vue";

const router = useRouter();
const auth = useAuth();
const { items, loading, fetchAll, setValidated } = useApprovals();

const error = ref("");
const processFilter = ref(null);
const pendingOnly = ref(true);
const openPanels = ref([]);
const busyTxIds = ref(new Set());
const snack = reactive({ show: false, text: "", color: "error" });

const guideSections = [
    {
        title: "HOW IT WORKS",
        rows: [
            { term: "INBOX", text: "TRANSACTIONS AT YOUR STATION WAITING FOR YOU TO CHECK WHAT THE PREVIOUS STATION SUBMITTED" },
            { term: "FILES", text: "CLICK A FILE TO DOWNLOAD WHAT THE PREVIOUS STATION UPLOADED" },
            { term: "VALIDATE", text: "TICK AN ITEM ONCE ITS FILES ARE CORRECT — REQUIRED ITEMS MUST BE VALIDATED BEFORE PROCEED" },
            { term: "UNDO", text: "ONLY THE PERSON WHO VALIDATED IT (OR A SUPERADMIN) CAN UNTICK IT" },
            { term: "OPEN", text: "GO TO THE TRANSACTION TO PROCEED TO THE NEXT STATION" },
        ],
    },
];

const isSuperadmin = computed(() =>
    (auth.user.value?.roles ?? []).some((r) => r.code === "superadmin"),
);

// Checklist items grouped by the station whose requirement they mirror;
// admin-added custom items (no source station) go last.
function sections(tx) {
    const bySource = new Map();
    for (const item of tx.current_step_checklist || []) {
        const src = item.source_step;
        const key = src ? `s-${src.id}` : "custom";
        if (!bySource.has(key)) {
            bySource.set(key, {
                key,
                title: src ? `Requirements from ${src.name}` : "Other checklist items",
                order: src ? Number(src.order_number ?? 0) : Number.MAX_SAFE_INTEGER,
                items: [],
            });
        }
        bySource.get(key).items.push(item);
    }
    return [...bySource.values()].sort((a, b) => a.order - b.order);
}

function missingRequired(tx) {
    return (tx.current_step_checklist || [])
        .filter((i) => i.is_required && !i.checked)
        .map((i) => i.name);
}

function progress(tx) {
    const all = tx.current_step_checklist || [];
    return { done: all.filter((i) => i.checked).length, total: all.length };
}

function isPending(tx) {
    return missingRequired(tx).length > 0;
}

const processOptions = computed(() => {
    const seen = new Map();
    for (const tx of items.value || []) {
        const t = tx.transaction_type;
        if (t && !seen.has(t.id)) seen.set(t.id, { title: t.name, value: t.id });
    }
    return [...seen.values()];
});

const groups = computed(() => {
    const byStep = new Map();
    for (const tx of items.value || []) {
        const s = tx.current_step;
        if (!s) continue;
        if (processFilter.value && tx.transaction_type?.id !== processFilter.value) continue;
        // Keep an expanded row visible even once it's fully validated, so it
        // doesn't vanish from under the user mid-review.
        if (pendingOnly.value && !isPending(tx) && !openPanels.value.includes(tx.id)) continue;
        if (!byStep.has(s.id)) byStep.set(s.id, { step: s, transactions: [], pendingCount: 0 });
        const g = byStep.get(s.id);
        g.transactions.push(tx);
        if (isPending(tx)) g.pendingCount += 1;
    }
    return [...byStep.values()];
});

function canUnvalidate(item) {
    return isSuperadmin.value || item.checked_by?.id === auth.user.value?.id;
}

function isBusy(txId) {
    return busyTxIds.value.has(txId);
}

async function onValidate(tx, item, validated) {
    busyTxIds.value = new Set([...busyTxIds.value, tx.id]);
    try {
        const updated = await setValidated(tx.id, item.id, validated);
        const idx = items.value.findIndex((t) => t.id === updated.id);
        if (idx !== -1) items.value.splice(idx, 1, updated);
    } catch (e) {
        snack.text = e?.response?.data?.message || "Update failed.";
        snack.color = "error";
        snack.show = true;
    } finally {
        const next = new Set(busyTxIds.value);
        next.delete(tx.id);
        busyTxIds.value = next;
    }
}

function openTx(tx) {
    router.push(`/my/transactions/${tx.id}`);
}

function fmtDateTime(iso) {
    if (!iso) return "";
    return new Date(iso).toLocaleString("en-PH", {
        timeZone: "Asia/Manila",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
    });
}

function waited(iso) {
    if (!iso) return "—";
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
    if (s < 3600) return `${Math.max(1, Math.floor(s / 60))}m`;
    if (s < 86400) return `${Math.floor(s / 3600)}h`;
    return `${Math.floor(s / 86400)}d`;
}

async function load() {
    error.value = "";
    try {
        await fetchAll();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load approvals.";
    }
}

onMounted(load);
</script>

<style scoped>
/* Let the file chips wrap under the title instead of truncating the row */
.approval-item :deep(.v-list-item__content) {
    overflow: visible;
}
</style>
