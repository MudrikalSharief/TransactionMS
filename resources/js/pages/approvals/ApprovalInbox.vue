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
                                        <template v-if="progress(tx).total">{{ progress(tx).done }}/{{ progress(tx).total }} checked</template>
                                        <template v-else>Nothing to check</template>
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
                                <div class="text-caption mt-1">
                                    <span v-if="missingRequired(tx).length" class="text-warning">
                                        Needs: {{ missingRequired(tx).join(", ") }}
                                    </span>
                                    <span v-else class="text-medium-emphasis">
                                        All required items checked. Ready to proceed.
                                    </span>
                                </div>
                            </v-list-item>
                        </template>
                    </v-list>
                </v-card>
                <div v-if="meta.lastPage > 1 && !loading" class="d-flex justify-center py-3">
                    <v-pagination v-model="page" :length="meta.lastPage" :total-visible="5" density="compact" @update:model-value="goToPage" />
                </div>
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
import { useSmartPoll } from "@/composables/useSmartPoll";
import TableLoader from "@/components/TableLoader.vue";
import GuideTable from "@/components/GuideTable.vue";
import ApprovalProceedDialog from "@/components/ApprovalProceedDialog.vue";

const { items, loading, meta, fetchAll } = useApprovals();
const approvalBadge = useApprovalBadge();
const page = ref(1);

const error = ref("");
const ALL_PROCESSES = "all";
const processFilter = ref(ALL_PROCESSES);
const pendingOnly = ref(true);

async function goToPage(p) {
    page.value = p;
    try {
        await fetchAll({ page: p });
    } catch {
        /* keep current rows */
    }
}
const dialogOpen = ref(false);
const dialogTxId = ref(null);
const snack = reactive({ show: false, text: "", color: "success" });

const guideSections = [
    {
        title: "HOW IT WORKS",
        rows: [
            { term: "INBOX", text: "EVERY TRANSACTION WAITING AT YOUR STATION" },
            { term: "PENDING", text: "NOT CHECKED YET: A REQUIRED UPLOAD OR A PREVIOUS-STATION REQUIREMENT TO VALIDATE IS STILL MISSING" },
            { term: "REVIEW & PROCEED", text: "OPENS THE PROCEED MODAL: UPLOAD THIS STATION'S FILES, TICK THE PREVIOUS STATION'S REQUIREMENTS, THEN PROCEED" },
            { term: "PROCEED", text: "MOVES THE TRANSACTION TO THE NEXT STATION — IT THEN LEAVES THIS LIST" },
            { term: "OPEN TRANSACTION", text: "FOR RETURNS, JUMPS AND HISTORY, USE THE TRANSACTION PAGE" },
        ],
    },
];

// Everything to check at the transaction's current station, using the same
// rules that block Proceed: this station's uploads (done = a file is attached)
// and the previous station's requirements to validate (done = ticked). The
// checklist isn't enforced at station 1 (step 1 -> 2 is requirements-only).
function checkItems(tx) {
    const uploads = (tx.current_step_requirements || []).map((r) => ({
        name: r.definition?.name,
        kind: "upload",
        required: !!r.pivot?.is_required,
        done: (r.attachment_count ?? (r.attachments || []).length) > 0,
    }));
    const enforceChecklist = Number(tx.current_step?.order_number) !== 1;
    const validations = enforceChecklist
        ? (tx.current_step_checklist || []).map((c) => ({ name: c.name, kind: "validate", required: !!c.is_required, done: !!c.checked }))
        : [];
    return [...uploads, ...validations];
}

function missingRequired(tx) {
    return checkItems(tx)
        .filter((i) => i.required && !i.done)
        .map((i) => `${i.name} (${i.kind})`);
}

function progress(tx) {
    const all = checkItems(tx);
    return { done: all.filter((i) => i.done).length, total: all.length };
}

// Pending = not checked yet: a required upload or validation is still missing.
function isPending(tx) {
    return missingRequired(tx).length > 0;
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
        await fetchAll({ page: page.value });
        approvalBadge.refresh();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load approvals.";
    }
}

onMounted(load);

// Silent 20s smart-poll: someone else's tick/upload/move refreshes the
// inbox rows + badge in place. Skipped while the proceed dialog is open
// so staged uploads/remarks are never wiped; no loader flash, no reload.
useSmartPoll(
    async () => {
        try {
            await fetchAll({ silent: true, page: page.value });
            approvalBadge.refresh();
        } catch {
            /* next tick retries */
        }
    },
    { enabled: () => !dialogOpen.value },
);
</script>

<style scoped>
.approval-row {
    cursor: pointer;
}
</style>
