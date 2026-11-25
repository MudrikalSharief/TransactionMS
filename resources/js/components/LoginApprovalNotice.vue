<template>
    <v-dialog
        v-model="open"
        max-width="520"
        scrim="#14213d"
        class="task-notice-dialog"
        @after-leave="markSeen"
    >
        <div class="task-notice" role="document" aria-labelledby="task-notice-title" aria-describedby="task-notice-intro">
            <button type="button" class="task-notice__close" aria-label="Close pending tasks notice" @click="open = false">
                <v-icon size="22" aria-hidden="true">mdi-close</v-icon>
            </button>

            <div class="task-notice__icon" aria-hidden="true">
                <v-icon size="34">mdi-clipboard-check-outline</v-icon>
            </div>
            <h2 id="task-notice-title" class="task-notice__title">
                {{ total }} {{ total === 1 ? "pending task" : "pending tasks" }}
            </h2>
            <p id="task-notice-intro" class="task-notice__intro">
                {{ greeting }}, {{ user?.name }}. Here is what needs attention in your office.
            </p>

            <div class="task-notice__office">
                <v-icon size="20" aria-hidden="true">mdi-domain</v-icon>
                <span>{{ officeName }}</span>
                <strong>{{ officeCode }}</strong>
            </div>

            <ul v-if="tally.length" class="task-notice__tally" aria-label="Task status summary">
                <li v-for="t in tally" :key="t.key">
                    <span class="task-notice__status" :class="'task-notice__status--' + t.key">
                        <v-icon size="18" aria-hidden="true">{{ t.icon }}</v-icon>
                        {{ t.mark }}
                    </span>
                    <strong>{{ t.n }}</strong>
                    <span class="task-notice__detail">{{ t.label }}</span>
                </li>
            </ul>

            <div class="task-notice__actions">
                <button type="button" class="task-notice__primary" @click="openApprovals">
                    Open tasks
                    <v-icon size="19" aria-hidden="true">mdi-arrow-right</v-icon>
                </button>
                <button type="button" class="task-notice__later" @click="open = false">
                    Remind me later
                </button>
            </div>
        </div>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth, canUseApprovals, userKind } from "@/composables/useAuth";
import { takeLoginNotice, approvalsSeenAt, markApprovalsSeen, trayBusy } from "@/composables/useLoginNotice";
import { greetingForHour } from "@/utils/greeting";
import { workingMs } from "@/utils/processColor";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();

// "Almost due": a quarter or less of the step's time limit is left.
const DUE_SHARE = 0.25;
// First sign-in on this device: "new" means arrived in the last day.
const FIRST_LOOK_MS = 24 * 3600 * 1000;

const open = ref(false);
const rows = ref([]);
const seenAt = ref(null);
const now = ref(Date.now());

// Pending items whose step has a time limit, with the working time left
// (ms, weekends skipped).
const timed = computed(() =>
    rows.value
        .map((tx) => {
            const sla = Number(tx.current_step?.sla_minutes || 0);
            const started = Date.parse(tx.work_started_at || "");
            if (!sla || !Number.isFinite(started)) return null;
            return { tx, sla, left: sla * 60000 - workingMs(started, now.value) };
        })
        .filter(Boolean),
);
// A paper still waiting to be received has no SLA clock yet.
const pending = computed(() => rows.value.filter((tx) => tx.pending_receipt || !tx.work_started_at));
// Past due: the time limit has passed. Due: still within it; "almost due"
// when a quarter or less of the time is left.
const pastDue = computed(() => timed.value.filter((d) => d.left < 0));
const dueNow = computed(() => timed.value.filter((d) => d.left >= 0));
const almostDue = computed(() => dueNow.value.filter((d) => d.left <= d.sla * 60000 * DUE_SHARE));

// New = arrived at the clerk's step since the last notice.
const fresh = computed(() => {
    const since = seenAt.value ?? now.value - FIRST_LOOK_MS;
    return rows.value.filter((tx) => Date.parse(tx.entered_at || "") > since);
});

const total = computed(() => rows.value.length);

// Tally under the summary; only the kinds that apply.
const tally = computed(() => {
    const almost = almostDue.value.length;
    return [
        { key: "pending", mark: "Pending", icon: "mdi-tray-arrow-down", n: pending.value.length, label: "waiting to be received" },
        { key: "past", mark: "Past due", icon: "mdi-alert", n: pastDue.value.length, label: "past the time limit", always: true },
        {
            key: "due",
            mark: "On time",
            icon: "mdi-check-circle-outline",
            n: dueNow.value.length,
            label: almost ? `on time, ${almost} almost due` : "on time",
            always: true,
        },
        { key: "new", mark: "New", icon: "mdi-bell-ring-outline", n: fresh.value.length, label: "since your last sign-in" },
    ].filter((t) => t.always || t.n > 0);
});

const officeCode = computed(() => user.value?.office?.code || "In-tray");
const officeName = computed(() => user.value?.office?.name || "Receiving");

const manila = (opts) => new Date(now.value).toLocaleString("en-US", { timeZone: "Asia/Manila", ...opts });
const greeting = computed(() => {
    const h = Number(manila({ hour: "numeric", hour12: false })) % 24;
    return greetingForHour(h);
});

async function loadAll() {
    const all = [];
    let page = 1;
    let last = 1;
    do {
        const res = await api.get("/api/approvals", { params: { page, per_page: 100 } });
        all.push(...(res.data?.data ?? []));
        last = res.data?.meta?.last_page ?? 1;
        page += 1;
    } while (page <= last && page <= 10);
    return all;
}

// Runs once the signed-in user has left the login page: only clerks (staff
// who may approve), only right after sign-in. A reminder: it shows whenever
// anything is pending; due and new items are marked.
watch(
    () => (route.name && route.name !== "login" ? user.value?.id : null),
    async (id) => {
        const u = user.value;
        if (!id || userKind(u) !== "staff" || !canUseApprovals(u)) return;
        if (!takeLoginNotice(id)) return;
        trayBusy.value = true;
        try {
            rows.value = await loadAll();
        } catch {
            trayBusy.value = false;
            return;
        }
        seenAt.value = approvalsSeenAt(id);
        now.value = Date.now();
        if (total.value > 0) open.value = true;
        else {
            markApprovalsSeen(id);
            trayBusy.value = false;
        }
    },
    { immediate: true },
);

function markSeen() {
    if (user.value?.id) markApprovalsSeen(user.value.id, now.value);
    trayBusy.value = false;
}

function openApprovals() {
    open.value = false;
    router.push("/portal/approvals");
}
</script>

<style>
.task-notice-dialog .v-overlay__scrim { opacity: 0.62; }
.task-notice-dialog .v-overlay__content { max-height: calc(100dvh - 32px); }
.task-notice {
    position: relative;
    overflow-y: auto;
    max-height: calc(100dvh - 32px);
    padding: 36px 38px 28px;
    border: 1px solid #e5ebf5;
    border-radius: 20px;
    background: #fff;
    box-shadow: 0 24px 70px rgba(13, 31, 65, 0.28);
    color: #14223e;
    text-align: center;
}
.task-notice__close {
    position: absolute;
    top: 16px;
    right: 16px;
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    border: 0;
    border-radius: 12px;
    background: transparent;
    color: #53627d;
    cursor: pointer;
}
.task-notice__close:hover,
.task-notice__close:focus-visible { background: #edf3fc; color: #0f2a5c; }
.task-notice__icon {
    display: grid;
    place-items: center;
    width: 66px;
    height: 66px;
    margin: 0 auto 20px;
    border: 7px solid #e5f0ff;
    border-radius: 50%;
    background: #1768e8;
    color: #fff;
    box-shadow: 0 0 0 1px #c8dcff;
}
.task-notice__title {
    margin: 0;
    font-family: "Montserrat", "Inter", sans-serif;
    font-size: clamp(1.4rem, 4vw, 1.75rem);
    font-weight: 800;
    line-height: 1.25;
}
.task-notice__intro {
    max-width: 38ch;
    margin: 10px auto 20px;
    color: #53627d;
    font-size: 0.95rem;
    line-height: 1.55;
    overflow-wrap: anywhere;
}
.task-notice__office {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 7px;
    margin: 0 0 20px;
    color: #1458c7;
    font-size: 0.93rem;
    font-weight: 600;
    overflow-wrap: anywhere;
}
.task-notice__office strong {
    padding: 3px 7px;
    border-radius: 5px;
    background: #eaf2ff;
    font-size: 0.76rem;
    letter-spacing: 0.03em;
}
.task-notice__tally {
    margin: 0;
    padding: 12px 16px;
    border: 1px solid #e7edf6;
    border-radius: 12px;
    background: #f8faff;
    list-style: none;
    text-align: left;
}
.task-notice__tally li {
    display: grid;
    grid-template-columns: 112px 26px minmax(0, 1fr);
    align-items: center;
    gap: 8px;
    min-height: 39px;
    font-size: 0.87rem;
}
.task-notice__tally li + li { border-top: 1px solid #e7edf6; }
.task-notice__status {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    color: #173e82;
    font-weight: 700;
}
.task-notice__status--past { color: #b42329; }
.task-notice__status--new { color: #1263bd; }
.task-notice__tally strong { font-size: 1rem; font-variant-numeric: tabular-nums; }
.task-notice__detail { color: #53627d; line-height: 1.35; }
.task-notice__actions { display: grid; gap: 8px; margin-top: 22px; }
.task-notice__primary,
.task-notice__later {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-height: 48px;
    border: 0;
    border-radius: 8px;
    font-family: inherit;
    font-size: 0.94rem;
    font-weight: 700;
    cursor: pointer;
}
.task-notice__primary {
    background: #1768e8;
    color: #fff;
    box-shadow: 0 5px 12px rgba(23, 104, 232, 0.18);
}
.task-notice__primary:hover { background: #0f55c6; }
.task-notice__later { background: transparent; color: #173e82; }
.task-notice__later:hover { background: #edf3fc; }
.task-notice button:focus-visible { outline: 3px solid #f2b33d; outline-offset: 2px; }
@media (max-width: 560px) {
    .task-notice { padding: 30px 20px 20px; border-radius: 16px; }
    .task-notice__icon { width: 58px; height: 58px; margin-bottom: 16px; }
    .task-notice__tally { padding: 9px 10px; }
    .task-notice__tally li {
        grid-template-columns: 98px 20px minmax(0, 1fr);
        gap: 6px;
        font-size: 0.78rem;
    }
}
</style>
