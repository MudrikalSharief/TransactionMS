<template>
    <v-dialog
        v-model="open"
        max-width="560"
        scrim="#cbd6e6"
        class="task-notice-dialog"
        @after-leave="markSeen"
    >
        <div class="task-notice" role="document" aria-labelledby="task-notice-title" aria-describedby="task-notice-intro">
            <button type="button" class="task-notice__close" aria-label="Close pending tasks notice" @click="open = false">
                <v-icon size="22" aria-hidden="true">mdi-close</v-icon>
            </button>

            <h2 id="task-notice-title" class="task-notice__title">
                {{ total }} {{ total === 1 ? "pending task" : "pending tasks" }}
            </h2>
            <p id="task-notice-intro" class="task-notice__intro">
                {{ greeting }}, {{ user?.name }}. Here is what needs attention in
                <strong>{{ officeName }} ({{ officeCode }})</strong>.
            </p>

            <ul class="task-notice__metrics" aria-label="Task status summary">
                <li v-for="t in tally" :key="t.key" :class="'task-notice__metric--' + t.key">
                    <span class="task-notice__metric-icon" aria-hidden="true">
                        <v-icon size="19">{{ t.icon }}</v-icon>
                    </span>
                    <span class="task-notice__metric-copy">
                        <span>{{ t.label }}</span>
                        <strong>{{ t.n }}</strong>
                    </span>
                </li>
            </ul>
            <p v-if="fresh.length || almostDue.length" class="task-notice__hint">
                <span v-if="fresh.length">{{ fresh.length }} new since your last sign-in</span>
                <span v-if="almostDue.length">{{ almostDue.length }} almost due</span>
            </p>

            <div class="task-notice__actions">
                <button type="button" class="task-notice__primary" @click="openApprovals">
                    Open tasks
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

// Three task states in the compact summary; new arrivals are noted below.
const tally = computed(() => {
    return [
        { key: "pending", icon: "mdi-tray-arrow-down", n: pending.value.length, label: "Waiting to receive" },
        { key: "past", icon: "mdi-alert-circle-outline", n: pastDue.value.length, label: "Past due" },
        { key: "due", icon: "mdi-check-circle-outline", n: dueNow.value.length, label: "On time" },
    ];
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
.task-notice-dialog .v-overlay__scrim {
    background-color: rgba(203, 214, 230, 0.45) !important;
    -webkit-backdrop-filter: blur(7px);
    backdrop-filter: blur(7px);
    opacity: 1;
}

.task-notice-dialog .v-overlay__content {
    max-height: calc(100dvh - 24px);
}

.task-notice {
    position: relative;
    overflow-y: auto;
    max-height: calc(100dvh - 24px);
    padding: 66px 36px 26px;
    border: 1px solid #e7edf5;
    border-radius: 16px;
    background: #fff;
    box-shadow: 0 25px 64px rgba(39, 62, 100, 0.18);
    color: #17233b;
    font-family: "Inter", "Public Sans", system-ui, sans-serif;
    text-align: center;
}

.task-notice__close {
    position: absolute;
    top: 12px;
    right: 12px;
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    border: 0;
    border-radius: 9px;
    background: transparent;
    color: #60708b;
    cursor: pointer;
}

.task-notice__close:hover {
    background: #eef3fb;
    color: #163a79;
}

.task-notice__title {
    margin: 0;
    font-size: clamp(1.4rem, 4vw, 1.75rem);
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.2;
}

.task-notice__intro {
    max-width: 46ch;
    margin: 10px auto 26px;
    color: #59677d;
    font-size: 0.9rem;
    line-height: 1.55;
    overflow-wrap: anywhere;
}

.task-notice__intro strong {
    color: #233f70;
    font-weight: 700;
}

.task-notice__metrics {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 10px;
    margin: 0;
    padding: 0;
    list-style: none;
    text-align: left;
}

.task-notice__metrics li {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    gap: 6px;
    min-width: 0;
    padding: 10px 7px;
    text-align: center;
}

.task-notice__metric-icon {
    display: grid;
    flex: none;
    place-items: center;
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: #e4faf2;
    color: #078755;
}

.task-notice__metric--past .task-notice__metric-icon {
    background: #fff0eb;
    color: #b4342d;
}

.task-notice__metric--due .task-notice__metric-icon {
    background: #e8f2ff;
    color: #145ab3;
}

.task-notice__metric-copy {
    display: grid;
    justify-items: center;
    min-width: 0;
    gap: 2px;
    color: #5c6a7e;
    font-size: 0.73rem;
    line-height: 1.2;
    text-align: center;
}

.task-notice__metric-copy strong {
    color: #17233b;
    font-size: 1rem;
    font-variant-numeric: tabular-nums;
}

.task-notice__hint {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 6px 18px;
    margin: 12px 0 0;
    color: #53647d;
    font-size: 0.77rem;
}

.task-notice__hint span::before {
    content: "•";
    margin-right: 6px;
    color: #1768e8;
}

.task-notice__actions {
    display: grid;
    gap: 8px;
    margin-top: 24px;
}

.task-notice__primary,
.task-notice__later {
    display: grid;
    place-items: center;
    min-height: 44px;
    border: 0;
    border-radius: 7px;
    font-family: inherit;
    font-size: 0.9rem;
    font-weight: 700;
    cursor: pointer;
}

.task-notice__primary {
    background: #1768e8;
    color: #fff;
    box-shadow: 0 5px 12px rgba(23, 104, 232, 0.16);
}

.task-notice__primary:hover {
    background: #0e56c7;
}

.task-notice__later {
    background: transparent;
    color: #22539a;
}

.task-notice__later:hover {
    background: #eef3fb;
}

.task-notice button:focus-visible {
    outline: 3px solid #f2b33d;
    outline-offset: 2px;
}

@media (max-width: 560px) {
    .task-notice {
        padding: 64px 16px 18px;
        border-radius: 14px;
    }

    .task-notice__intro {
        margin-bottom: 17px;
    }

    .task-notice__metrics {
        gap: 2px;
    }

    .task-notice__metrics li {
        padding: 8px 5px;
    }

    .task-notice__metric-copy {
        font-size: 0.69rem;
    }
}
</style>
