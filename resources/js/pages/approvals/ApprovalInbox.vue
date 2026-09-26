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

                    <v-list class="py-0" lines="two">
                        <template v-for="(tx, i) in group.transactions" :key="tx.id">
                            <v-divider v-if="i > 0" />
                            <v-list-item class="approval-row" @click="review(tx)">
                                <div class="d-flex align-center flex-wrap ga-2">
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
                                        :color="isPending(tx) ? 'warning' : 'success'"
                                        class="mr-2"
                                    >
                                        {{ progress(tx).done }}/{{ progress(tx).total }} validated
                                    </v-chip>
                                    <v-btn
                                        color="grey-darken-3"
                                        rounded="0"
                                        size="small"
                                        append-icon="mdi-arrow-right"
                                        @click.stop="review(tx)"
                                    >
                                        Review &amp; Proceed
                                    </v-btn>
                                </div>
                                <div class="text-caption text-medium-emphasis mt-1">
                                    <template v-for="(src, j) in sources(tx)" :key="src">
                                        <span v-if="j > 0"> · </span>Requirements from {{ src }}
                                    </template>
                                    <span v-if="missingRequired(tx).length" class="text-warning">
                                        — to validate: {{ missingRequired(tx).join(", ") }}
                                    </span>
                                </div>
                            </v-list-item>
                        </template>
                    </v-list>
                </v-card>
            </v-card-text>
        </v-card>

        <ApprovalProceedDialog
            v-model:open="dialogOpen"
            :tx-id="dialogTxId"
            @changed="replaceTx"
            @proceeded="onProceeded"
        />

        <v-snackbar v-model="snack.show" :color="snack.color" timeout="4000">
            {{ snack.text }}
        </v-snackbar>
    </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { useApprovals } from "@/composables/useApprovals";
import { useApprovalBadge } from "@/composables/useApprovalBadge";
import TableLoader from "@/components/TableLoader.vue";
import GuideTable from "@/components/GuideTable.vue";
import ApprovalProceedDialog from "@/components/ApprovalProceedDialog.vue";

const { items, loading, fetchAll } = useApprovals();
const approvalBadge = useApprovalBadge();

const error = ref("");
const ALL_PROCESSES = "all";
const processFilter = ref(ALL_PROCESSES);
const pendingOnly = ref(true);
const dialogOpen = ref(false);
const dialogTxId = ref(null);
const snack = reactive({ show: false, text: "", color: "success" });

const guideSections = [
    {
        title: "HOW IT WORKS",
        rows: [
            { term: "INBOX", text: "TRANSACTIONS AT YOUR STATION WAITING FOR YOU TO CHECK WHAT THE PREVIOUS STATION SUBMITTED" },
            { term: "REVIEW & PROCEED", text: "OPENS THE PROCEED MODAL: UPLOAD THIS STATION'S FILES, TICK THE PREVIOUS STATION'S REQUIREMENTS, THEN PROCEED" },
            { term: "PROCEED", text: "MOVES THE TRANSACTION TO THE NEXT STATION — IT THEN LEAVES THIS LIST" },
            { term: "OPEN TRANSACTION", text: "FOR RETURNS, JUMPS AND HISTORY, USE THE TRANSACTION PAGE" },
        ],
    },
];

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

// Names of the previous station(s) whose requirements this row validates.
function sources(tx) {
    const names = new Set();
    for (const item of tx.current_step_checklist || []) {
        if (item.source_step?.name) names.add(item.source_step.name);
    }
    return [...names];
}

const processOptions = computed(() => {
    const seen = new Map();
    for (const tx of items.value || []) {
        const t = tx.transaction_type;
        if (t && !seen.has(t.id)) seen.set(t.id, { title: t.name, value: t.id });
    }
    const processes = [...seen.values()].sort((a, b) => a.title.localeCompare(b.title));
    return [{ title: "All processes", value: ALL_PROCESSES }, ...processes];
});

const groups = computed(() => {
    const byStep = new Map();
    for (const tx of items.value || []) {
        const s = tx.current_step;
        if (!s) continue;
        if (processFilter.value !== ALL_PROCESSES && tx.transaction_type?.id !== processFilter.value) continue;
        // Keep the row under review visible even once it's fully validated.
        const underReview = dialogOpen.value && tx.id === dialogTxId.value;
        if (pendingOnly.value && !isPending(tx) && !underReview) continue;
        if (!byStep.has(s.id)) byStep.set(s.id, { step: s, transactions: [], pendingCount: 0 });
        const g = byStep.get(s.id);
        g.transactions.push(tx);
        if (isPending(tx)) g.pendingCount += 1;
    }
    return [...byStep.values()];
});

function review(tx) {
    dialogTxId.value = tx.id;
    dialogOpen.value = true;
}

// Ticks/uploads inside the modal: keep the row's progress in step.
function replaceTx(updated) {
    if (!updated) return;
    const idx = items.value.findIndex((t) => t.id === updated.id);
    if (idx !== -1) items.value.splice(idx, 1, { ...items.value[idx], ...updated });
    approvalBadge.refresh();
}

async function onProceeded(movedTx) {
    const to = movedTx?.current_step?.name;
    snack.text = `${movedTx?.reference_number || "Transaction"} moved${to ? ` to ${to}` : ""}.`;
    snack.color = "success";
    snack.show = true;
    await load();
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
        approvalBadge.refresh();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load approvals.";
    }
}

onMounted(load);
</script>

<style scoped>
.approval-row {
    cursor: pointer;
}
</style>
