<template>
    <!-- Routing slip shown once after a clerk signs in: what arrived since
         their last sign-in and what is almost due. The slip drops in and the
         office "Received" stamp is pressed onto it (one entrance moment). -->
    <v-dialog
        v-model="open"
        max-width="580"
        transition="slip-drop"
        scrim="#0E1F52"
        class="slip-dialog"
        @after-leave="markSeen"
    >
        <div class="slip" role="document" aria-labelledby="slip-title" aria-describedby="slip-summary">
            <header class="slip-band">
                <img class="slip-seal" :src="'/zamboanga-seal.png'" alt="" width="40" height="40" />
                <div class="slip-who">
                    <div id="slip-title" class="slip-title">Routing slip for {{ user?.name }}</div>
                    <div class="slip-office">{{ user?.office?.name || "Your office" }}</div>
                </div>
                <v-btn icon="mdi-close" variant="text" color="white" size="small" aria-label="Close" @click="open = false" />
            </header>

            <div class="slip-body">
                <div class="slip-lead">
                    <p id="slip-summary" class="slip-summary">
                        <strong>{{ total }} {{ total === 1 ? "transaction is" : "transactions are" }}</strong>
                        waiting for your approval. {{ detailLine }}
                    </p>
                    <div class="stamp" aria-hidden="true">
                        <span class="stamp-word">Received</span>
                        <span class="stamp-date">{{ stampDate }}</span>
                        <span class="stamp-count">{{ total }} waiting</span>
                    </div>
                </div>

                <section v-if="due.length" class="slip-sec">
                    <h3 class="slip-h">
                        Almost due
                        <span class="slip-n slip-n--due">{{ due.length }}</span>
                    </h3>
                    <ul class="slip-list">
                        <li
                            v-for="item in due.slice(0, SHOW)"
                            :key="item.tx.id"
                            class="slip-row slip-row--due"
                            tabindex="0"
                            role="link"
                            @click="go(item.tx)"
                            @keydown.enter.prevent="go(item.tx)"
                        >
                            <div class="row-top">
                                <span class="row-ref">{{ item.tx.reference_number || `#${item.tx.id}` }}</span>
                                <span class="row-title">{{ item.tx.title || item.tx.transaction_type?.name }}</span>
                                <span class="row-when" :class="{ 'is-late': item.left < 0 }">{{ leftLabel(item.left) }}</span>
                            </div>
                            <div class="row-step">{{ item.tx.current_step?.name }}</div>
                            <div class="sla" :title="`Time limit at this step: ${slaLabel(item.sla)}`">
                                <i :style="{ '--used': `${Math.round(item.used * 100)}%` }" />
                            </div>
                        </li>
                    </ul>
                </section>

                <section v-if="fresh.length" class="slip-sec">
                    <h3 class="slip-h">
                        New since you last signed in
                        <span class="slip-n">{{ fresh.length }}</span>
                    </h3>
                    <ul class="slip-list">
                        <li
                            v-for="tx in fresh.slice(0, SHOW)"
                            :key="tx.id"
                            class="slip-row"
                            tabindex="0"
                            role="link"
                            @click="go(tx)"
                            @keydown.enter.prevent="go(tx)"
                        >
                            <div class="row-top">
                                <span class="row-ref">{{ tx.reference_number || `#${tx.id}` }}</span>
                                <span class="row-title">{{ tx.title || tx.transaction_type?.name }}</span>
                                <span class="row-when">Arrived {{ ago(tx.entered_at) }}</span>
                            </div>
                            <div class="row-step">{{ tx.current_step?.name }}</div>
                        </li>
                    </ul>
                </section>

                <p v-if="hidden > 0" class="slip-more">{{ hidden }} more in Approvals.</p>
            </div>

            <footer class="slip-foot">
                <v-btn variant="text" rounded="0" color="grey-darken-3" @click="open = false">Remind me later</v-btn>
                <v-btn variant="flat" rounded="0" color="primary" class="slip-cta" @click="openApprovals">Open approvals</v-btn>
            </footer>
        </div>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth, canUseApprovals, userKind } from "@/composables/useAuth";
import { takeLoginNotice, approvalsSeenAt, markApprovalsSeen } from "@/composables/useLoginNotice";

const route = useRoute();
const router = useRouter();
const { api } = useApi();
const { user } = useAuth();

// Rows shown per section; the rest are counted under "more in Approvals".
const SHOW = 3;
// "Almost due": a quarter or less of the step's time limit is left
// (overdue rows count too and say so).
const DUE_SHARE = 0.25;
// First sign-in on this device: "new" means arrived in the last day.
const FIRST_LOOK_MS = 24 * 3600 * 1000;

const open = ref(false);
const rows = ref([]);
const seenAt = ref(null);
const now = ref(Date.now());

const due = computed(() =>
    rows.value
        .map((tx) => {
            const sla = Number(tx.current_step?.sla_minutes || 0);
            const entered = Date.parse(tx.entered_at || "");
            if (!sla || !Number.isFinite(entered)) return null;
            const left = entered + sla * 60000 - now.value;
            return { tx, sla, left, used: Math.min(1, Math.max(0, 1 - left / (sla * 60000))) };
        })
        .filter((d) => d && d.left <= d.sla * 60000 * DUE_SHARE)
        .sort((a, b) => a.left - b.left),
);
const dueIds = computed(() => new Set(due.value.map((d) => d.tx.id)));

// New = arrived at the clerk's step since the last notice (not already
// listed under Almost due).
const fresh = computed(() => {
    const since = seenAt.value ?? now.value - FIRST_LOOK_MS;
    return rows.value
        .filter((tx) => !dueIds.value.has(tx.id) && Date.parse(tx.entered_at || "") > since)
        .sort((a, b) => Date.parse(b.entered_at) - Date.parse(a.entered_at));
});

const total = computed(() => rows.value.length);
const hidden = computed(
    () => Math.max(0, due.value.length - SHOW) + Math.max(0, fresh.value.length - SHOW),
);

const detailLine = computed(() => {
    const late = due.value.filter((d) => d.left < 0).length;
    const soon = due.value.length - late;
    const isAre = (n) => (n === 1 ? "is" : "are");
    const parts = [];
    if (late) parts.push(`${late} ${isAre(late)} overdue`);
    if (soon) parts.push(`${soon} ${isAre(soon)} almost due`);
    if (fresh.value.length) parts.push(`${fresh.value.length} arrived since you last signed in`);
    if (!parts.length) return "";
    const line = parts.length > 1 ? `${parts.slice(0, -1).join(", ")} and ${parts.at(-1)}` : parts[0];
    return line.charAt(0).toUpperCase() + line.slice(1) + ".";
});

const stampDate = computed(() =>
    new Date(now.value)
        .toLocaleDateString("en-PH", { timeZone: "Asia/Manila", month: "short", day: "numeric", year: "numeric" })
        .toUpperCase(),
);

function span(ms) {
    const m = Math.max(1, Math.round(Math.abs(ms) / 60000));
    if (m < 60) return `${m}m`;
    const h = Math.floor(m / 60);
    if (h < 24) return m % 60 ? `${h}h ${m % 60}m` : `${h}h`;
    const d = Math.floor(h / 24);
    return h % 24 ? `${d}d ${h % 24}h` : `${d}d`;
}
const leftLabel = (left) => (left < 0 ? `Overdue by ${span(left)}` : `${span(left)} left`);
const slaLabel = (min) => span(min * 60000);
const ago = (iso) => `${span(now.value - Date.parse(iso))} ago`;

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
// who may approve), only right after sign-in, only when there is news.
watch(
    () => (route.name && route.name !== "login" ? user.value?.id : null),
    async (id) => {
        const u = user.value;
        if (!id || userKind(u) !== "staff" || !canUseApprovals(u)) return;
        if (!takeLoginNotice(id)) return;
        try {
            rows.value = await loadAll();
        } catch {
            return;
        }
        seenAt.value = approvalsSeenAt(id);
        now.value = Date.now();
        if (due.value.length || fresh.value.length) open.value = true;
        else markApprovalsSeen(id);
    },
    { immediate: true },
);

function markSeen() {
    if (user.value?.id) markApprovalsSeen(user.value.id, now.value);
}

function go(tx) {
    open.value = false;
    router.push(`/transactions/${tx.id}`);
}

function openApprovals() {
    open.value = false;
    router.push("/portal/approvals");
}
</script>

<style>
/* Teleported dialog: global styles, every class prefixed "slip". */
.slip-dialog .v-overlay__scrim {
    opacity: 0.55;
}
.slip {
    --slip-navy: #16307c;
    --slip-deep: #0e1f52;
    --slip-gold: #d9ab3c;
    --slip-ink: #b3261e;
    --slip-rule: #e3e8f3;
    --slip-text: #1f2937;
    --slip-muted: #5b6475;
    position: relative;
    background: #fff;
    color: var(--slip-text);
    font-family: "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif;
    box-shadow: 0 18px 50px rgba(14, 31, 82, 0.35);
    overflow: hidden;
}

/* Band: navy with the same gold rule as the app bar. */
.slip-band {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 12px 14px 18px;
    background: var(--slip-deep);
    border-bottom: 2px solid var(--slip-gold);
    color: #fff;
}
.slip-seal {
    flex: none;
    border-radius: 50%;
    background: #fff;
    padding: 2px;
}
.slip-who {
    flex: 1 1 auto;
    min-width: 0;
}
.slip-title {
    font-size: 1.05rem;
    font-weight: 700;
    line-height: 1.25;
    overflow-wrap: anywhere;
}
.slip-office {
    font-size: 0.8rem;
    opacity: 0.8;
}

.slip-body {
    padding: 18px 22px 6px;
    max-height: min(62vh, 520px);
    overflow-x: hidden;
    overflow-y: auto;
}

/* Lead: summary sentence with the stamp in the corner. */
.slip-lead {
    position: relative;
    min-height: 96px;
    padding-right: 150px;
}
.slip-summary {
    margin: 0;
    font-size: 1.02rem;
    line-height: 1.55;
    max-width: 34ch;
}
.slip-summary strong {
    color: var(--slip-navy);
}

/* The rubber "Received" stamp: double-ruled, red ink, slightly crooked. */
.stamp {
    position: absolute;
    top: -4px;
    right: 0;
    width: 136px;
    padding: 7px 8px 6px;
    border: 3px double var(--slip-ink);
    color: var(--slip-ink);
    text-align: center;
    transform: rotate(-9deg);
    opacity: 0.88;
    mix-blend-mode: multiply;
    animation: slip-stamp 0.42s cubic-bezier(0.2, 0.9, 0.3, 1.2) 0.32s both;
}
.stamp-word {
    display: block;
    font-weight: 800;
    font-size: 1rem;
    letter-spacing: 0.16em;
    text-transform: uppercase;
}
.stamp-date {
    display: block;
    margin: 3px 0;
    padding: 2px 0;
    border-top: 1px solid currentColor;
    border-bottom: 1px solid currentColor;
    font-weight: 700;
    font-size: 0.78rem;
    letter-spacing: 0.08em;
    font-variant-numeric: tabular-nums;
}
.stamp-count {
    display: block;
    font-weight: 700;
    font-size: 0.82rem;
}

/* Sections */
.slip-sec {
    margin-top: 16px;
}
.slip-h {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 0 0 6px;
    font-size: 0.92rem;
    font-weight: 700;
    color: var(--slip-deep);
}
.slip-n {
    min-width: 22px;
    padding: 1px 7px;
    background: var(--slip-navy);
    color: #fff;
    font-size: 0.75rem;
    text-align: center;
    font-variant-numeric: tabular-nums;
}
.slip-n--due {
    background: var(--slip-ink);
}
.slip-list {
    margin: 0;
    padding: 0;
    list-style: none;
    border-top: 1px solid var(--slip-rule);
}
.slip-row {
    padding: 9px 10px 9px 12px;
    border-bottom: 1px solid var(--slip-rule);
    border-left: 3px solid var(--slip-navy);
    cursor: pointer;
    transition: background-color 0.15s ease;
}
.slip-row--due {
    border-left-color: var(--slip-ink);
}
.slip-row:hover,
.slip-row:focus-visible {
    background: #f3f6fc;
    outline: none;
}
.slip-row:focus-visible {
    box-shadow: inset 0 0 0 2px var(--slip-navy);
}
.row-top {
    display: flex;
    align-items: baseline;
    gap: 10px;
    min-width: 0;
}
.row-ref {
    flex: none;
    font-weight: 700;
    font-size: 0.8rem;
    color: var(--slip-navy);
    font-variant-numeric: tabular-nums;
}
.row-title {
    flex: 1 1 auto;
    min-width: 0;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    font-weight: 600;
    font-size: 0.9rem;
}
.row-when {
    flex: none;
    font-size: 0.78rem;
    color: var(--slip-muted);
    font-variant-numeric: tabular-nums;
}
.row-when.is-late {
    color: var(--slip-ink);
    font-weight: 700;
}
.row-step {
    margin-top: 1px;
    font-size: 0.8rem;
    color: var(--slip-muted);
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
/* Time used at this step, against its limit. */
.sla {
    height: 4px;
    margin-top: 7px;
    background: var(--slip-rule);
}
.sla i {
    display: block;
    height: 100%;
    width: var(--used);
    background: var(--slip-ink);
    animation: slip-fill 0.7s ease-out 0.55s both;
}
.slip-more {
    margin: 10px 0 0;
    font-size: 0.82rem;
    color: var(--slip-muted);
}

.slip-foot {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    padding: 14px 18px 18px;
}
.slip-cta {
    min-width: 160px;
}

/* Entrance: the slip drops onto the desk, then the stamp is pressed. */
.slip-drop-enter-active {
    animation: slip-drop 0.34s cubic-bezier(0.2, 0.8, 0.25, 1) both;
}
.slip-drop-enter-active .slip {
    animation: slip-jolt 0.18s ease-out 0.62s;
}
.slip-drop-leave-active {
    transition: opacity 0.18s ease, transform 0.18s ease;
}
.slip-drop-leave-to {
    opacity: 0;
    transform: translateY(10px);
}
@keyframes slip-drop {
    from {
        opacity: 0;
        transform: translateY(-36px) rotate(-1.2deg);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes slip-stamp {
    0% {
        opacity: 0;
        transform: rotate(-16deg) scale(1.9);
    }
    70% {
        opacity: 0.95;
        transform: rotate(-8deg) scale(0.94);
    }
    100% {
        opacity: 0.88;
        transform: rotate(-9deg) scale(1);
    }
}
@keyframes slip-jolt {
    0%,
    100% {
        transform: none;
    }
    40% {
        transform: translateY(2px);
    }
}
@keyframes slip-fill {
    from {
        width: 0;
    }
}

/* Phones: the stamp moves above the summary instead of beside it. */
@media (max-width: 520px) {
    .slip-lead {
        padding-right: 0;
        padding-top: 92px;
    }
    .stamp {
        left: 50%;
        right: auto;
        margin-left: -68px;
    }
    .slip-foot {
        flex-direction: column-reverse;
    }
    .slip-foot .v-btn {
        width: 100%;
    }
}

@media (prefers-reduced-motion: reduce) {
    .slip-drop-enter-active,
    .slip-drop-enter-active .slip,
    .stamp,
    .sla i {
        animation: none !important;
    }
    .slip-drop-enter-active {
        transition: opacity 0.2s ease;
    }
    .slip-drop-enter-from {
        opacity: 0;
    }
}
</style>
