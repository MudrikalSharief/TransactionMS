<template>
    <!-- After a clerk signs in: their in-tray folder. The paper is ruled
         like a receiving logbook; what is due is marked RUSH / LATE in the
         margin, and the office's Received stamp is pressed on (one entrance
         sequence: folder pulled up, stamp pressed, dater rolls to now). -->
    <v-dialog
        v-model="open"
        max-width="620"
        transition="tray-pull"
        scrim="#0E1F52"
        class="tray-dialog"
        @after-leave="markSeen"
    >
        <div class="tray" role="document" aria-labelledby="tray-greet" aria-describedby="tray-summary">
            <svg class="tray-defs" width="0" height="0" aria-hidden="true" focusable="false">
                <!-- Uneven stamp-pad ink: speckled coverage, slightly wobbly edges. -->
                <filter id="tray-ink" x="-4%" y="-4%" width="108%" height="108%">
                    <feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="2" seed="11" result="grain" />
                    <feColorMatrix in="grain" type="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 -1.25 1.6" result="cover" />
                    <feComposite in="SourceGraphic" in2="cover" operator="in" result="inked" />
                    <feTurbulence type="fractalNoise" baseFrequency="0.035" numOctaves="2" seed="4" result="wave" />
                    <feDisplacementMap in="inked" in2="wave" scale="2.4" xChannelSelector="R" yChannelSelector="G" />
                </filter>
            </svg>

            <div class="tray-top">
                <div class="tray-tab">
                    <img class="tab-seal" :src="'/zamboanga-seal.png'" alt="" width="22" height="22" />
                    <span class="tab-code">{{ officeCode }}</span>
                    <span class="tab-count" :aria-label="`${total} waiting`">{{ total }}</span>
                </div>
                <button type="button" class="tray-close" aria-label="Close" @click="open = false">
                    <v-icon size="20">mdi-close</v-icon>
                </button>
            </div>

            <div class="tray-paper">
                <div class="paper-head">
                    <h2 id="tray-greet" class="paper-greet">{{ greeting }}, {{ user?.name }}.</h2>
                    <p id="tray-summary" class="paper-summary">
                        Your in-tray has {{ total }} {{ total === 1 ? "document" : "documents" }} waiting for approval.
                        {{ detailLine }}
                    </p>
                </div>

                <!-- Receiving stamp, as used at city hall receiving desks. -->
                <div class="rcv" aria-hidden="true">
                    <div class="rcv-ink">
                        <div class="rcv-org">City Government of Zamboanga</div>
                        <div class="rcv-office">{{ officeName }}</div>
                        <div class="rcv-word">Received</div>
                        <div class="rcv-line">
                            <span class="rcv-k">Date</span>
                            <span class="rcv-v dater">
                                <template v-for="(c, i) in dateChars" :key="`d${i}`">
                                    <span v-if="c.digit" class="dg" :style="{ '--d': c.value, '--i': i }"><span><i v-for="n in 20" :key="n">{{ (n - 1) % 10 }}</i></span></span>
                                    <span v-else class="dg-fixed">{{ c.value }}</span>
                                </template>
                            </span>
                        </div>
                        <div class="rcv-line">
                            <span class="rcv-k">Time</span>
                            <span class="rcv-v dater">
                                <template v-for="(c, i) in timeChars" :key="`t${i}`">
                                    <span v-if="c.digit" class="dg" :style="{ '--d': c.value, '--i': i + 8 }"><span><i v-for="n in 20" :key="n">{{ (n - 1) % 10 }}</i></span></span>
                                    <span v-else class="dg-fixed">{{ c.value }}</span>
                                </template>
                            </span>
                        </div>
                        <div class="rcv-line">
                            <span class="rcv-k">By</span>
                            <span class="rcv-v rcv-by">{{ user?.name }}</span>
                        </div>
                    </div>
                </div>

                <!-- Logbook: ruled lines, red margin; rows sit on the rules. -->
                <div class="ledger" role="list">
                    <div class="ledger-cols" aria-hidden="true">
                        <span class="lc-margin" />
                        <span>Control no.</span>
                        <span>Particulars</span>
                        <span class="lc-due">Due</span>
                    </div>

                    <div
                        v-for="item in due.slice(0, SHOW)"
                        :key="`due-${item.tx.id}`"
                        class="ledger-row"
                        role="listitem"
                        tabindex="0"
                        @click="go(item.tx)"
                        @keydown.enter.prevent="go(item.tx)"
                    >
                        <span class="mark" :class="item.left < 0 ? 'mark--late' : 'mark--rush'">{{ item.left < 0 ? "Late" : "Rush" }}</span>
                        <span class="lr-ref">{{ item.tx.reference_number || `#${item.tx.id}` }}</span>
                        <span class="lr-what">
                            <span class="lr-title">{{ item.tx.title || item.tx.transaction_type?.name }}</span>
                            <span class="lr-step">{{ item.tx.current_step?.name }}</span>
                        </span>
                        <span class="lr-due" :class="{ 'is-late': item.left < 0 }">{{ leftLabel(item.left) }}</span>
                    </div>

                    <div
                        v-for="tx in fresh.slice(0, SHOW)"
                        :key="`new-${tx.id}`"
                        class="ledger-row"
                        role="listitem"
                        tabindex="0"
                        @click="go(tx)"
                        @keydown.enter.prevent="go(tx)"
                    >
                        <span class="mark mark--new">New</span>
                        <span class="lr-ref">{{ tx.reference_number || `#${tx.id}` }}</span>
                        <span class="lr-what">
                            <span class="lr-title">{{ tx.title || tx.transaction_type?.name }}</span>
                            <span class="lr-step">{{ tx.current_step?.name }}</span>
                        </span>
                        <span class="lr-due lr-due--quiet">Arrived {{ ago(tx.entered_at) }}</span>
                    </div>

                    <div v-if="hidden > 0" class="ledger-more">{{ hidden }} more in Approvals.</div>
                </div>

                <div class="paper-foot">
                    <v-btn variant="text" rounded="0" color="grey-darken-3" @click="open = false">Remind me later</v-btn>
                    <v-btn variant="flat" rounded="0" color="primary" class="paper-cta" @click="openApprovals">Open approvals</v-btn>
                </div>
            </div>
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

// Log lines shown per kind; the rest are counted as "more in Approvals".
const SHOW = 3;
// "Almost due": a quarter or less of the step's time limit is left
// (overdue rows count too, marked Late).
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
            return { tx, sla, left: entered + sla * 60000 - now.value };
        })
        .filter((d) => d && d.left <= d.sla * 60000 * DUE_SHARE)
        .sort((a, b) => a.left - b.left),
);
const dueIds = computed(() => new Set(due.value.map((d) => d.tx.id)));

// New = arrived at the clerk's step since the last notice (not already
// logged as due).
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

const officeCode = computed(() => user.value?.office?.code || "In-tray");
const officeName = computed(() => user.value?.office?.name || "Receiving");

const manila = (opts) => new Date(now.value).toLocaleString("en-US", { timeZone: "Asia/Manila", ...opts });
const greeting = computed(() => {
    const h = Number(manila({ hour: "numeric", hour12: false })) % 24;
    if (h < 12) return "Good morning";
    if (h < 18) return "Good afternoon";
    return "Good evening";
});

// Dater band characters: digits roll, the rest stay put.
const chars = (s) => [...s].map((ch) => (/\d/.test(ch) ? { digit: true, value: Number(ch) } : { digit: false, value: ch }));
const dateChars = computed(() =>
    chars(manila({ month: "short", day: "2-digit", year: "numeric" }).replace(",", "").toUpperCase()),
);
const timeChars = computed(() => chars(manila({ hour: "2-digit", minute: "2-digit", hour12: true })));

function span(ms) {
    const m = Math.max(1, Math.round(Math.abs(ms) / 60000));
    if (m < 60) return `${m}m`;
    const h = Math.floor(m / 60);
    if (h < 24) return m % 60 ? `${h}h ${m % 60}m` : `${h}h`;
    const d = Math.floor(h / 24);
    return h % 24 ? `${d}d ${h % 24}h` : `${d}d`;
}
const leftLabel = (left) => (left < 0 ? `${span(left)} late` : `${span(left)} left`);
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
/* Teleported dialog: global styles, prefixed "tray" / "paper" / "ledger" /
   "rcv". Palette: system navy + seal gold, logbook rules, stamp-pad ink. */
@property --ink-r {
    syntax: "<percentage>";
    inherits: false;
    initial-value: 160%;
}

.tray-dialog .v-overlay__scrim {
    opacity: 0.6;
}
.tray {
    --navy: #16307c;
    --deep: #0e1f52;
    --gold: #d9ab3c;
    --rule: #d6e0f2;
    --margin: #e8a3a3;
    --ink: #2c2799;
    --red: #b3261e;
    --text: #1d2433;
    --muted: #5b6475;
    --line: 28px;
    font-family: "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif;
    color: var(--text);
}
.tray-defs {
    position: absolute;
}

/* Folder tab (navy, angled edge) sitting on the paper; close on the right. */
.tray-top {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
}
.tray-tab {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    height: 40px;
    padding: 0 34px 0 14px;
    background: var(--navy);
    color: #fff;
    clip-path: polygon(0 0, calc(100% - 22px) 0, 100% 100%, 0 100%);
}
.tab-seal {
    border-radius: 50%;
    background: #fff;
    padding: 1px;
}
.tab-code {
    font-weight: 800;
    font-size: 0.95rem;
    letter-spacing: 0.04em;
}
.tab-count {
    min-width: 24px;
    padding: 1px 7px;
    background: var(--gold);
    color: var(--deep);
    font-weight: 800;
    font-size: 0.8rem;
    text-align: center;
    font-variant-numeric: tabular-nums;
}
.tray-close {
    display: grid;
    place-items: center;
    width: 36px;
    height: 36px;
    margin-bottom: 4px;
    color: #fff;
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.45);
    cursor: pointer;
}
.tray-close:hover,
.tray-close:focus-visible {
    background: rgba(255, 255, 255, 0.12);
    outline: none;
}

/* Paper: navy folder edge on top, logbook margin line on the left. */
.tray-paper {
    position: relative;
    background: #fff;
    border-top: 4px solid var(--navy);
    box-shadow: 0 1px 0 var(--gold), 0 26px 60px rgba(8, 18, 52, 0.45);
    max-height: min(80vh, 640px);
    overflow-x: hidden;
    overflow-y: auto;
}
.tray-paper::before {
    content: "";
    position: absolute;
    top: 0;
    bottom: 0;
    left: 64px;
    width: 1px;
    background: var(--margin);
    pointer-events: none;
}

.paper-head {
    padding: 22px 252px 10px 80px;
    min-height: 196px;
}
.paper-greet {
    margin: 0 0 6px;
    font-size: 1.3rem;
    font-weight: 800;
    line-height: 1.25;
    color: var(--deep);
}
.paper-summary {
    margin: 0;
    font-size: 0.98rem;
    line-height: 1.55;
    color: var(--text);
    max-width: 40ch;
}

/* ---- Receiving stamp ---------------------------------------------------- */
.rcv {
    position: absolute;
    top: 18px;
    right: 22px;
    width: 214px;
    transform: rotate(-4deg);
}
/* The stamp's shadow coming down before contact. */
.rcv::before {
    content: "";
    position: absolute;
    inset: 6px;
    background: rgba(8, 18, 52, 0.55);
    filter: blur(14px);
    opacity: 0;
    animation: rcv-shadow 0.32s ease-in 0.3s both;
    pointer-events: none;
}
.rcv-ink {
    position: relative;
    padding: 7px 10px 8px;
    border: 2.5px solid var(--ink);
    outline: 1px solid var(--ink);
    outline-offset: 2px;
    color: var(--ink);
    text-align: center;
    mix-blend-mode: multiply;
    filter: url(#tray-ink);
    -webkit-mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    animation: rcv-press 0.5s cubic-bezier(0.3, 0.7, 0.2, 1) 0.58s both;
}
.rcv-org {
    font-size: 0.6rem;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}
.rcv-office {
    font-size: 0.66rem;
    font-weight: 800;
    letter-spacing: 0.02em;
    text-transform: uppercase;
    line-height: 1.2;
    margin-top: 1px;
}
.rcv-word {
    margin: 4px -10px 5px;
    padding: 2px 0;
    border-top: 2px solid currentColor;
    border-bottom: 2px solid currentColor;
    font-size: 1.35rem;
    font-weight: 900;
    letter-spacing: 0.24em;
    text-transform: uppercase;
    line-height: 1.15;
}
.rcv-line {
    display: flex;
    align-items: baseline;
    gap: 6px;
    text-align: left;
    font-size: 0.72rem;
    line-height: 1.5;
}
.rcv-k {
    flex: none;
    width: 34px;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 0.6rem;
    letter-spacing: 0.06em;
}
.rcv-v {
    flex: 1 1 auto;
    min-width: 0;
    border-bottom: 1px solid currentColor;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
}
.rcv-by {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    font-weight: 700;
}

/* Dater: each digit is a band of 0-9 0-9 that rolls to the right number. */
.dater {
    display: inline-flex;
    align-items: flex-end;
}
.dg {
    display: inline-block;
    height: 1.25em;
    overflow: hidden;
    line-height: 1.25em;
    width: 0.66em;
    text-align: center;
}
.dg > span {
    display: block;
    transform: translateY(calc(var(--d) * -1.25em));
    animation: dater-roll 0.55s cubic-bezier(0.25, 0.9, 0.3, 1.05) calc(1.02s + var(--i) * 0.035s) both;
}
.dg > span > i {
    display: block;
    height: 1.25em;
    font-style: normal;
}
.dg-fixed {
    white-space: pre;
}

/* ---- Logbook ------------------------------------------------------------- */
.ledger {
    position: relative;
    margin-top: 6px;
    background-image: repeating-linear-gradient(
        to bottom,
        transparent 0,
        transparent calc(var(--line) - 1px),
        var(--rule) calc(var(--line) - 1px),
        var(--rule) var(--line)
    );
}
.ledger-cols,
.ledger-row {
    display: grid;
    grid-template-columns: 64px 142px minmax(0, 1fr) auto;
    column-gap: 14px;
    padding-right: 22px;
}
.ledger-cols {
    height: var(--line);
    align-items: center;
    font-size: 0.75rem;
    font-weight: 700;
    color: var(--navy);
}
.lc-due {
    text-align: right;
}
.ledger-row {
    min-height: calc(var(--line) * 2);
    align-items: center;
    cursor: pointer;
    transition: background-color 0.15s ease;
}
.ledger-row:hover,
.ledger-row:focus-visible {
    background-color: rgba(22, 48, 124, 0.06);
    outline: none;
}
.ledger-row:focus-visible {
    box-shadow: inset 3px 0 0 var(--navy);
}

/* Margin marks: little hand stamps, as on paper documents. */
.mark {
    justify-self: center;
    padding: 1px 5px;
    border: 1.5px solid currentColor;
    font-size: 0.64rem;
    font-weight: 900;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    line-height: 1.3;
    transform: rotate(-7deg);
}
.mark--rush {
    color: var(--red);
}
.mark--late {
    color: #fff;
    background: var(--red);
    border-color: var(--red);
}
.mark--new {
    color: var(--navy);
    transform: none;
}

.lr-ref {
    font-weight: 800;
    font-size: 0.82rem;
    color: var(--navy);
    font-variant-numeric: tabular-nums;
}
.lr-what {
    display: flex;
    flex-direction: column;
    min-width: 0;
    line-height: var(--line);
}
.lr-title,
.lr-step {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.lr-title {
    font-weight: 600;
    font-size: 0.92rem;
}
.lr-step {
    font-size: 0.8rem;
    color: var(--muted);
}
.lr-due {
    justify-self: end;
    font-size: 0.8rem;
    font-weight: 700;
    color: var(--text);
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
}
.lr-due.is-late {
    color: var(--red);
}
.lr-due--quiet {
    font-weight: 500;
    color: var(--muted);
}
.ledger-more {
    height: var(--line);
    line-height: var(--line);
    padding-left: 78px;
    font-size: 0.82rem;
    color: var(--muted);
}

.paper-foot {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    padding: 16px 22px 20px 78px;
}
.paper-cta {
    min-width: 168px;
}

/* ---- Entrance: pulled from the tray, then the stamp is pressed ---------- */
.tray-pull-enter-active {
    animation: tray-pull 0.34s cubic-bezier(0.2, 0.8, 0.25, 1) both;
}
.tray-pull-enter-active .tray-paper {
    animation: paper-jolt 0.16s ease-out 0.62s;
}
.tray-pull-leave-active {
    transition: opacity 0.18s ease, transform 0.18s ease;
}
.tray-pull-leave-to {
    opacity: 0;
    transform: translateY(14px);
}
@keyframes tray-pull {
    from {
        opacity: 0;
        transform: translateY(46px);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes rcv-shadow {
    0% {
        opacity: 0;
        transform: scale(1.35) translate(10px, -14px);
    }
    85% {
        opacity: 0.55;
    }
    100% {
        opacity: 0;
        transform: scale(1) translate(0, 0);
    }
}
@keyframes rcv-press {
    0% {
        --ink-r: 0%;
        opacity: 0;
        transform: scale(1.06);
    }
    12% {
        opacity: 1;
    }
    100% {
        --ink-r: 160%;
        opacity: 0.92;
        transform: scale(1);
    }
}
@keyframes paper-jolt {
    0%,
    100% {
        transform: none;
    }
    45% {
        transform: translateY(2px);
    }
}
@keyframes dater-roll {
    from {
        transform: translateY(calc((var(--d) + 10) * -1.25em));
    }
    to {
        transform: translateY(calc(var(--d) * -1.25em));
    }
}

/* ---- Phones: stamp sits under the greeting, ledger loses the margin ---- */
@media (max-width: 600px) {
    .tray-paper::before {
        left: 40px;
    }
    .paper-head {
        padding: 18px 18px 4px 52px;
        min-height: 0;
    }
    .rcv {
        position: relative;
        top: auto;
        right: auto;
        margin: 10px auto 6px;
    }
    .ledger-cols {
        display: none;
    }
    .ledger-row {
        grid-template-columns: 40px minmax(0, 1fr) auto;
        grid-template-areas:
            "mark ref due"
            "mark what what";
        padding: 4px 14px 4px 0;
        row-gap: 0;
    }
    .ledger-row .mark {
        grid-area: mark;
        font-size: 0.56rem;
        padding: 1px 3px;
    }
    .lr-ref {
        grid-area: ref;
        line-height: var(--line);
    }
    .lr-due {
        grid-area: due;
    }
    .lr-what {
        grid-area: what;
    }
    .ledger-more {
        padding-left: 52px;
    }
    .paper-foot {
        flex-direction: column-reverse;
        padding: 14px 16px 18px 52px;
    }
    .paper-foot .v-btn {
        width: 100%;
    }
}

@media (prefers-reduced-motion: reduce) {
    .tray-pull-enter-active,
    .tray-pull-enter-active .tray-paper,
    .rcv::before,
    .rcv-ink,
    .dg > span {
        animation: none !important;
    }
    .rcv-ink {
        -webkit-mask-image: none;
        mask-image: none;
        opacity: 0.92;
    }
}
</style>
