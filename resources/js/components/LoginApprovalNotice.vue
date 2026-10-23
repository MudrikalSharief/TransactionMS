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
                    <feColorMatrix in="grain" type="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 -0.8 1.65" result="cover" />
                    <feComposite in="SourceGraphic" in2="cover" operator="in" result="inked" />
                    <feTurbulence type="fractalNoise" baseFrequency="0.035" numOctaves="2" seed="4" result="wave" />
                    <feDisplacementMap in="inked" in2="wave" scale="1.3" xChannelSelector="R" yChannelSelector="G" />
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
                <!-- Summary only: how many are pending at the office, and a
                     tally of what needs attention (no per-document list). -->
                <div class="paper-head">
                    <p id="tray-greet" class="paper-greet">{{ greeting }}, {{ user?.name }}.</p>
                    <h2 id="tray-summary" class="paper-summary">
                        {{ total }} {{ total === 1 ? "Pending Task" : "Pending Tasks" }} in office {{ officeCode }}.
                    </h2>
                    <p class="paper-office">{{ officeName }}</p>
                    <ul v-if="tally.length" class="tally">
                        <li v-for="t in tally" :key="t.key" :class="{ 'is-zero': !t.n }">
                            <span class="slip-mark" :class="`slip-mark--${t.key}`">{{ t.mark }}</span>
                            <span class="tally-n">{{ t.n }}</span> {{ t.label }}
                        </li>
                    </ul>
                </div>

                <!-- Round official receiving seal: city and office around the
                     rings, the flag's three stars, a RECEIVED ribbon across,
                     then the dater (date, time, clerk's initials). -->
                <div class="rcv" aria-hidden="true">
                    <div class="rcv-ink">
                        <svg class="rcv-svg" viewBox="0 0 228 200" width="228" height="200">
                            <defs>
                                <path id="rcv-arc-top" d="M 44 100 A 70 70 0 0 1 184 100" />
                                <path id="rcv-arc-bottom" d="M 35 100 A 79 79 0 0 0 193 100" />
                            </defs>
                            <circle cx="114" cy="100" r="93" class="rcv-stroke" stroke-width="3" />
                            <circle cx="114" cy="100" r="88" class="rcv-stroke" stroke-width="1" />
                            <circle cx="114" cy="100" r="62" class="rcv-stroke" stroke-width="1.5" />
                            <text class="rcv-arc" :style="{ fontSize: `${arcSize(TOP_TEXT)}px` }">
                                <textPath href="#rcv-arc-top" startOffset="50%" text-anchor="middle">{{ TOP_TEXT }}</textPath>
                            </text>
                            <text class="rcv-arc" :style="{ fontSize: `${arcSize(officeName)}px` }">
                                <textPath href="#rcv-arc-bottom" startOffset="50%" text-anchor="middle">{{ officeName.toUpperCase() }}</textPath>
                            </text>
                            <!-- Three stars inside the inner ring -->
                            <g class="rcv-fill" transform="translate(114 62)">
                                <path v-for="x in [-18, 0, 18]" :key="x" :transform="`translate(${x} ${x === 0 ? -4 : 0}) scale(${x === 0 ? 1.15 : 0.9})`" :d="STAR" />
                            </g>
                            <!-- RECEIVED ribbon over the rings -->
                            <rect x="8" y="80" width="212" height="38" fill="#fff" />
                            <rect x="8" y="80" width="212" height="38" class="rcv-stroke" stroke-width="2.5" />
                            <rect x="12" y="84" width="204" height="30" class="rcv-stroke" stroke-width="0.8" />
                            <text x="114" y="108" text-anchor="middle" class="rcv-word">RECEIVED</text>
                        </svg>
                        <div class="rcv-dater">
                            <span class="dater rcv-date">
                                <template v-for="(c, i) in dateChars" :key="`d${i}`">
                                    <span v-if="c.digit" class="dg" :style="{ '--d': c.value, '--i': i }"><span><i v-for="n in 20" :key="n">{{ (n - 1) % 10 }}</i></span></span>
                                    <span v-else class="dg-fixed">{{ c.value }}</span>
                                </template>
                            </span>
                            <span class="rcv-time">
                                <span class="dater">
                                    <template v-for="(c, i) in timeChars" :key="`t${i}`">
                                        <span v-if="c.digit" class="dg" :style="{ '--d': c.value, '--i': i + 8 }"><span><i v-for="n in 20" :key="n">{{ (n - 1) % 10 }}</i></span></span>
                                        <span v-else class="dg-fixed">{{ c.value }}</span>
                                    </template>
                                </span>
                                <span class="rcv-by">{{ initials }}</span>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="paper-foot">
                    <v-btn variant="text" rounded="0" color="grey-darken-3" @click="open = false">Remind me later</v-btn>
                    <v-btn variant="flat" rounded="0" color="primary" class="paper-cta" @click="openApprovals">Open tasks</v-btn>
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

// "Almost due": a quarter or less of the step's time limit is left.
const DUE_SHARE = 0.25;
// First sign-in on this device: "new" means arrived in the last day.
const FIRST_LOOK_MS = 24 * 3600 * 1000;

const open = ref(false);
const rows = ref([]);
const seenAt = ref(null);
const now = ref(Date.now());

// Pending items whose step has a time limit, with the time left (ms).
const timed = computed(() =>
    rows.value
        .map((tx) => {
            const sla = Number(tx.current_step?.sla_minutes || 0);
            const entered = Date.parse(tx.entered_at || "");
            if (!sla || !Number.isFinite(entered)) return null;
            return { tx, sla, left: entered + sla * 60000 - now.value };
        })
        .filter(Boolean),
);
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
        { key: "past", mark: "Past due", n: pastDue.value.length, label: "past the time limit", always: true },
        {
            key: "due",
            mark: "Due",
            n: dueNow.value.length,
            label: almost ? `on time, ${almost} almost due` : "on time",
            always: true,
        },
        { key: "new", mark: "New", n: fresh.value.length, label: "since your last sign-in" },
    ].filter((t) => t.always || t.n > 0);
});

const officeCode = computed(() => user.value?.office?.code || "In-tray");
const officeName = computed(() => user.value?.office?.name || "Receiving");

// Seal text: the city on the top arc, the office on the bottom arc. Long
// names get a smaller size so they stay inside the ring.
const TOP_TEXT = "CITY GOVERNMENT OF ZAMBOANGA";
// ~0.86em per uppercase glyph incl. tracking; the top arc is ~210px long.
const arcSize = (text) => Math.max(6.5, Math.min(10.5, 196 / (String(text).length * 0.86)));
const STAR = "M0,-7 L2.06,-2.84 L6.66,-2.16 L3.33,1.08 L4.11,5.66 L0,3.5 L-4.11,5.66 L-3.33,1.08 L-6.66,-2.16 L-2.06,-2.84 Z";
// Clerk's initials on the dater line (e.g. Rhea Lyn Francisco -> RLF).
const initials = computed(() =>
    String(user.value?.name || "")
        .split(/\s+/)
        .filter(Boolean)
        .map((w) => w[0].toUpperCase())
        .join("")
        .slice(0, 4),
);

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
        try {
            rows.value = await loadAll();
        } catch {
            return;
        }
        seenAt.value = approvalsSeenAt(id);
        now.value = Date.now();
        if (total.value > 0) open.value = true;
        else markApprovalsSeen(id);
    },
    { immediate: true },
);

function markSeen() {
    if (user.value?.id) markApprovalsSeen(user.value.id, now.value);
}

function openApprovals() {
    open.value = false;
    router.push("/portal/approvals");
}
</script>

<style>
/* Teleported dialog: global styles, prefixed "tray" / "paper" / "tally" /
   "rcv". Palette: system navy + seal gold, logbook margin, stamp-pad ink. */
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
    --ink: #1c2a8a;
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
    padding: 26px 262px 12px 84px;
    min-height: 230px;
}
.paper-greet {
    margin: 0 0 10px;
    font-size: 0.95rem;
    color: var(--muted);
}
/* The summary is the message: one formal headline. */
.paper-summary {
    margin: 0;
    font-size: 1.6rem;
    font-weight: 800;
    line-height: 1.2;
    letter-spacing: -0.01em;
    color: var(--deep);
    max-width: 16ch;
}
.paper-office {
    margin: 8px 0 0;
    padding-top: 8px;
    border-top: 2px solid var(--gold);
    display: inline-block;
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--navy);
}
.tally {
    margin: 18px 0 0;
    padding: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.tally li {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.9rem;
    color: var(--text);
}
.tally .slip-mark {
    min-width: 74px;
    text-align: center;
}
.tally li.is-zero {
    opacity: 0.5;
}
.tally-n {
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    color: var(--deep);
}

/* ---- Receiving stamp ---------------------------------------------------- */
.rcv {
    position: absolute;
    top: 10px;
    right: 14px;
    width: 228px;
    height: 200px;
    transform: rotate(-8deg);
}
/* The stamp's shadow coming down before contact (round, like the seal). */
.rcv::before {
    content: "";
    position: absolute;
    left: 24px;
    top: 10px;
    width: 180px;
    height: 180px;
    border-radius: 50%;
    background: rgba(8, 18, 52, 0.5);
    filter: blur(16px);
    opacity: 0;
    animation: rcv-shadow 0.32s ease-in 0.3s both;
    pointer-events: none;
}
.rcv-ink {
    position: relative;
    width: 228px;
    height: 200px;
    color: var(--ink);
    mix-blend-mode: multiply;
    filter: url(#tray-ink);
    -webkit-mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    animation: rcv-press 0.5s cubic-bezier(0.3, 0.7, 0.2, 1) 0.58s both;
}
.rcv-svg {
    position: absolute;
    inset: 0;
    overflow: visible;
}
.rcv-stroke {
    fill: none;
    stroke: currentColor;
}
.rcv-fill {
    fill: currentColor;
}
.rcv-arc {
    fill: currentColor;
    font-family: "Public Sans", system-ui, sans-serif;
    font-weight: 800;
    letter-spacing: 0.08em;
}
.rcv-word {
    fill: currentColor;
    font-family: "Public Sans", system-ui, sans-serif;
    font-size: 24px;
    font-weight: 900;
    letter-spacing: 0.2em;
}
/* Dater under the ribbon, inside the inner ring. */
.rcv-dater {
    position: absolute;
    left: 0;
    right: 0;
    top: 122px;
    display: flex;
    flex-direction: column;
    align-items: center;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    line-height: 1;
}
.rcv-date {
    font-size: 13px;
    letter-spacing: 0.04em;
}
.rcv-time {
    display: inline-flex;
    align-items: flex-end;
    gap: 6px;
    margin-top: 2px;
    font-size: 9.5px;
    letter-spacing: 0.05em;
}
.rcv-by {
    padding-left: 6px;
    border-left: 1px solid currentColor;
    line-height: 1.25em;
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

.slip-mark {
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
.slip-mark--due {
    color: var(--red);
}
.slip-mark--past {
    color: #fff;
    background: var(--red);
    border-color: var(--red);
}
.slip-mark--new {
    color: var(--navy);
    transform: none;
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
        transform: rotate(-6deg) scale(1.07);
    }
    12% {
        opacity: 1;
    }
    55% {
        transform: rotate(0.6deg) scale(0.985);
    }
    100% {
        --ink-r: 160%;
        opacity: 0.94;
        transform: rotate(0) scale(1);
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
    .paper-summary {
        font-size: 1.35rem;
    }
    .rcv {
        position: relative;
        top: auto;
        right: auto;
        margin: 10px auto 6px;
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
