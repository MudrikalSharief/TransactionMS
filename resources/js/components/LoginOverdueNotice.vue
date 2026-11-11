<template>
    <!-- Once per sign-in (staff), on the first visit to the Transactions
         page: how many open transactions there are overdue or due.
         Afterwards the page shows a "Pending overdue transactions" button. -->
    <v-dialog v-model="open" max-width="560" @after-leave="onClosed">
        <v-card rounded="0">
            <v-card-title class="d-flex align-center pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-alarm</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Transactions need attention</span>
                <v-spacer />
                <v-btn icon="mdi-close" variant="text" color="grey-darken-3" aria-label="Close" @click="open = false" />
            </v-card-title>
            <v-card-text class="pa-6">
                <p class="od-summary">
                    There {{ overdue === 1 ? "is" : "are" }} <b>{{ overdue }}</b> overdue and
                    <b>{{ due }}</b> due {{ overdue + due === 1 ? "transaction" : "transactions" }}.
                </p>
                <div class="od-rows">
                    <div class="od-row od-row--overdue" :class="{ 'is-zero': !overdue }">
                        <v-icon size="22">mdi-alert-circle</v-icon>
                        <span class="od-n">{{ overdue }}</span>
                        <span><b>Overdue</b> · past their station's time limit</span>
                    </div>
                    <div class="od-row od-row--due" :class="{ 'is-zero': !due }">
                        <v-icon size="22">mdi-clock-alert-outline</v-icon>
                        <span class="od-n">{{ due }}</span>
                        <span><b>Due</b> · a quarter or less of the time limit left</span>
                    </div>
                </div>
            </v-card-text>
            <v-divider />
            <v-card-actions class="d-flex justify-space-between px-6 py-5">
                <v-btn variant="text" color="grey-darken-3" rounded="0" size="large" @click="open = false">Later</v-btn>
                <v-btn color="primary" variant="flat" rounded="0" size="large" prepend-icon="mdi-clipboard-check-multiple-outline" @click="view">
                    Go to Task
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth, userKind, canUseApprovals } from "@/composables/useAuth";
import { takeTxNotice, markTxNoticeShown, trayBusy } from "@/composables/useLoginNotice";
import { dueState } from "@/utils/processColor";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();

const open = ref(false);
const rows = ref([]);

const overdue = computed(() => rows.value.filter((tx) => dueState(tx) === "overdue").length);
const due = computed(() => rows.value.filter((tx) => dueState(tx) === "due").length);

// Same list as the Transactions page's "My office" tab.
async function loadAll() {
    const all = [];
    let page = 1;
    let last = 1;
    do {
        const res = await api.get("/api/admin/transactions", { params: { page, per_page: 100 } });
        all.push(...(res.data?.data ?? []));
        last = res.data?.meta?.last_page ?? 1;
        page += 1;
    } while (page <= last && page <= 20);
    return all.filter((tx) => !tx.is_done);
}

// Resolves once the clerk's in-tray notice (if any) has closed.
function trayDone() {
    if (!trayBusy.value) return Promise.resolve();
    return new Promise((resolve) => {
        const stop = watch(trayBusy, (busy) => {
            if (!busy) {
                stop();
                resolve();
            }
        });
    });
}

// Only on the Transactions page: the sign-in mark stays until the user
// first opens it, then is used up (one notice per sign-in).
const onTransactions = () => route.name === "portal.transactions";

watch(
    () => (onTransactions() ? user.value?.id : null),
    async (id) => {
        if (!id || userKind(user.value) !== "staff") return;
        if (!takeTxNotice(id)) return;
        try {
            rows.value = await loadAll();
        } catch {
            return;
        }
        if (!overdue.value && !due.value) return;
        await trayDone();
        if (user.value?.id !== id || !onTransactions()) return;
        markTxNoticeShown(id);
        open.value = true;
    },
    { immediate: true },
);

// "Go to Task": clerks open the Task page; staff without one (end users)
// get its equivalent, the Transactions page's "Needs my action" tab.
let goTask = false;
function view() {
    goTask = true;
    open.value = false;
}
function onClosed() {
    if (goTask) {
        router.push(
            canUseApprovals(user.value)
                ? "/portal/approvals"
                : { path: "/portal/transactions", query: { tab: "action" } },
        );
    }
    goTask = false;
}
</script>

<style scoped>
.od-summary {
    margin: 0 0 16px;
    font-size: 1.05rem;
    line-height: 1.5;
}
.od-rows {
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.od-row {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 14px;
    border-left: 4px solid currentColor;
    background: rgba(var(--v-theme-on-surface), 0.04);
    font-size: 0.92rem;
}
.od-row > span:last-child {
    color: rgb(var(--v-theme-on-surface));
}
.od-row--overdue {
    color: rgb(var(--v-theme-error));
}
.od-row--due {
    color: #c98500;
}
.od-row.is-zero {
    opacity: 0.5;
}
.od-n {
    min-width: 28px;
    font-size: 1.3rem;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    text-align: center;
}
</style>
