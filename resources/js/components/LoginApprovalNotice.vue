<template>
    <!-- After a clerk signs in: how many tasks wait at their office. A navy
         folder tab (seal, office code, count) on a rounded card; the summary
         and its tally on the left, the office's RECEIVED stamp on the right
         (pressed on as it opens, the dater rolling to now), actions below. -->
    <v-dialog
        v-model="open"
        max-width="780"
        transition="tray-pull"
        scrim="#1A1F2B"
        class="tray-dialog"
        @after-leave="markSeen"
    >
        <div class="tray" role="document" aria-labelledby="tray-greet" aria-describedby="tray-summary">
            <div class="tray-top">
                <div class="tray-tab">
                    <!-- Folder tab: rounded on the left, curving down into
                         the card's navy top edge on the right. -->
                    <svg class="tab-shape" viewBox="0 0 360 64" preserveAspectRatio="none" aria-hidden="true">
                        <defs>
                            <linearGradient id="tray-tab-fill" x1="0" y1="0" x2="0" y2="1">
                                <stop offset="0" stop-color="#1f3f7e" />
                                <stop offset="1" stop-color="#0f2a5c" />
                            </linearGradient>
                        </defs>
                        <path d="M0 64 V30 Q0 0 30 0 H262 C292 0 300 18 312 36 C322 54 332 64 360 64 Z" fill="url(#tray-tab-fill)" />
                    </svg>
                    <img class="tab-seal" :src="'/zamboanga-seal.png'" alt="" width="34" height="34" />
                    <span class="tab-code">{{ officeCode }}</span>
                    <span class="tab-sep" aria-hidden="true"></span>
                    <span class="tab-count" :aria-label="`${total} waiting`">{{ total }}</span>
                </div>
                <button type="button" class="tray-close" aria-label="Close" @click="open = false">
                    <v-icon size="26">mdi-close</v-icon>
                </button>
            </div>

            <div class="tray-card">
                <div class="tray-body">
                    <!-- Summary only: how many are pending at the office, and a
                         tally of what needs attention (no per-document list). -->
                    <div class="tray-info">
                        <p id="tray-greet" class="tray-greet">
                            <v-icon size="24" aria-hidden="true">mdi-account-outline</v-icon>
                            {{ greeting }}, {{ user?.name }}.
                        </p>
                        <div class="tray-headline">
                            <span class="tray-icon" aria-hidden="true">
                                <v-icon size="40">mdi-clipboard-check-outline</v-icon>
                            </span>
                            <div>
                                <h2 id="tray-summary" class="tray-summary">
                                    {{ total }} {{ total === 1 ? "Pending Task" : "Pending Tasks" }} in office {{ officeCode }}.
                                </h2>
                                <span class="tray-rule" aria-hidden="true"></span>
                            </div>
                        </div>
                        <p class="tray-office">
                            <v-icon size="24" aria-hidden="true">mdi-sitemap-outline</v-icon>
                            {{ officeName }}
                        </p>
                        <ul v-if="tally.length" class="tally">
                            <li v-for="t in tally" :key="t.key" :class="{ 'is-zero': !t.n }">
                                <span class="tally-pill" :class="`tally-pill--${t.key}`">
                                    <v-icon size="20" aria-hidden="true">{{ t.icon }}</v-icon>
                                    {{ t.mark }}
                                </span>
                                <span class="tally-n">{{ t.n }}</span>
                                <span class="tally-label">{{ t.label }}</span>
                            </li>
                        </ul>
                    </div>

                    <!-- Round official receiving seal: city and office around the
                         rings, the flag's three stars, a RECEIVED band across,
                         then the dater (date, time, clerk's initials) between
                         two laurel sprigs. -->
                    <div class="rcv" aria-hidden="true">
                        <div class="rcv-ink">
                            <svg class="rcv-svg" viewBox="0 0 240 240" width="240" height="240">
                                <defs>
                                    <path id="rcv-arc-top" d="M 34 120 A 86 86 0 0 1 206 120" />
                                    <path id="rcv-arc-bottom" d="M 23 120 A 97 97 0 0 0 217 120" />
                                </defs>
                                <circle cx="120" cy="120" r="112" class="rcv-stroke" stroke-width="5" />
                                <circle cx="120" cy="120" r="105" class="rcv-stroke" stroke-width="1.5" />
                                <circle cx="120" cy="120" r="80" class="rcv-stroke" stroke-width="2" />
                                <text class="rcv-arc" :style="{ fontSize: `${arcSize(TOP_TEXT)}px` }">
                                    <textPath href="#rcv-arc-top" startOffset="50%" text-anchor="middle">{{ TOP_TEXT }}</textPath>
                                </text>
                                <text class="rcv-arc" :style="{ fontSize: `${arcSize(officeName)}px` }">
                                    <textPath href="#rcv-arc-bottom" startOffset="50%" text-anchor="middle">{{ officeName.toUpperCase() }}</textPath>
                                </text>
                                <!-- Three stars inside the inner ring -->
                                <g class="rcv-fill" transform="translate(120 66)">
                                    <path v-for="x in [-20, 0, 20]" :key="x" :transform="`translate(${x} ${x === 0 ? -4 : 0}) scale(${x === 0 ? 1.3 : 1.05})`" :d="STAR" />
                                </g>
                                <!-- Laurel sprigs either side of the dater -->
                                <g v-for="side in [1, -1]" :key="side" :transform="side < 0 ? 'translate(240 0) scale(-1 1)' : undefined">
                                    <path :d="LAUREL_STEM" class="rcv-stroke" stroke-width="1.6" stroke-linecap="round" />
                                    <path v-for="(l, i) in LAUREL" :key="i" :d="l" class="rcv-fill" />
                                </g>
                                <!-- RECEIVED band over the rings -->
                                <rect x="6" y="92" width="228" height="46" rx="8" fill="#fff" />
                                <rect x="6" y="92" width="228" height="46" rx="8" class="rcv-stroke" stroke-width="4" />
                                <rect x="12" y="98" width="216" height="34" rx="5" class="rcv-stroke" stroke-width="1.5" />
                                <text x="120" y="125" text-anchor="middle" class="rcv-word">RECEIVED</text>
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
                </div>

                <div class="tray-foot">
                    <button type="button" class="tray-btn tray-btn--later" @click="open = false">
                        <v-icon size="24" aria-hidden="true">mdi-clock-outline</v-icon>
                        Remind me later
                    </button>
                    <button type="button" class="tray-btn tray-btn--open" @click="openApprovals">
                        <v-icon size="24" aria-hidden="true">mdi-open-in-new</v-icon>
                        Open tasks
                    </button>
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
import { takeLoginNotice, approvalsSeenAt, markApprovalsSeen, trayBusy } from "@/composables/useLoginNotice";
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
            const entered = Date.parse(tx.entered_at || "");
            if (!sla || !Number.isFinite(entered)) return null;
            return { tx, sla, left: sla * 60000 - workingMs(entered, now.value) };
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

// Seal text: the city on the top arc, the office on the bottom arc. Long
// names get a smaller size so they stay inside the ring.
const TOP_TEXT = "CITY GOVERNMENT OF ZAMBOANGA";
// ~0.93em per bold uppercase glyph incl. tracking; kept to ~236 of the
// ~270-unit arcs so the ends never get cut.
const arcSize = (text) => Math.max(7, Math.min(12, 236 / (String(text).length * 0.93)));
// Laurel sprig left of the dater (mirrored for the right): a stem and
// five almond leaves, each given as centre x, y and angle.
const LAUREL_STEM = "M66 176 Q56 160 60 139";
const leaf = (cx, cy, deg) => {
    const a = (deg * Math.PI) / 180;
    const [ux, uy] = [Math.cos(a) * 7, Math.sin(a) * 7];
    const [nx, ny] = [-Math.sin(a) * 4, Math.cos(a) * 4];
    const p = (x, y) => `${x.toFixed(1)} ${y.toFixed(1)}`;
    return `M${p(cx + ux, cy + uy)} Q${p(cx + nx, cy + ny)} ${p(cx - ux, cy - uy)} Q${p(cx - nx, cy - ny)} ${p(cx + ux, cy + uy)} Z`;
};
const LAUREL = [
    leaf(60, 142, -95),
    leaf(65, 150, -60),
    leaf(57, 156, -115),
    leaf(64, 163, -55),
    leaf(61, 170, -125),
];
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
/* Teleported dialog: global styles, prefixed "tray" / "tally" / "rcv".
   Palette: deep navy tab and actions, seal gold, light blue-grey panels. */
@property --ink-r {
    syntax: "<percentage>";
    inherits: false;
    initial-value: 160%;
}

.tray-dialog .v-overlay__scrim {
    opacity: 0.6;
}
.tray {
    --navy: #0f2a5c;
    --navy-2: #1f3f7e;
    --blue: #1d56c4;
    --gold: #f2b33d;
    --ink: #0f2a6b;
    --red: #c62828;
    --text: #13213f;
    --muted: #4a5672;
    --panel: #eef3fa;
    position: relative;
    font-family: "Inter", "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif;
    color: var(--text);
}

/* ---- Folder tab and close button ---- */
.tray-top {
    position: relative;
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    height: 64px;
}
.tray-tab {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 14px;
    width: 360px;
    max-width: 82%;
    height: 64px;
    padding: 0 0 4px 24px;
    color: #fff;
}
.tab-shape {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
}
.tray-tab > :not(.tab-shape) {
    position: relative;
}
.tab-seal {
    border-radius: 50%;
    background: #fff;
    padding: 1px;
    box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.35);
}
.tab-code {
    font-family: "Montserrat", "Inter", sans-serif;
    font-weight: 800;
    font-size: 1.45rem;
    letter-spacing: 0.02em;
}
.tab-sep {
    width: 2px;
    height: 30px;
    background: rgba(255, 255, 255, 0.55);
}
.tab-count {
    display: grid;
    place-items: center;
    min-width: 38px;
    height: 38px;
    padding: 0 8px;
    border-radius: 8px;
    background: linear-gradient(180deg, #f7c255, var(--gold));
    color: #fff;
    font-family: "Montserrat", "Inter", sans-serif;
    font-weight: 800;
    font-size: 1.3rem;
    font-variant-numeric: tabular-nums;
    text-shadow: 0 1px 1px rgba(120, 70, 0, 0.35);
}
.tray-close {
    position: absolute;
    right: 0;
    top: 0;
    z-index: 2;
    display: grid;
    place-items: center;
    width: 54px;
    height: 54px;
    border: 2px solid rgba(255, 255, 255, 0.85);
    border-radius: 12px;
    background: linear-gradient(180deg, #2b3a58, #1a2540);
    color: #fff;
    cursor: pointer;
    box-shadow: 0 8px 18px -8px rgba(8, 18, 52, 0.8);
    transition: filter 0.15s ease;
}
.tray-close:hover,
.tray-close:focus-visible {
    filter: brightness(1.2);
    outline: none;
}

/* ---- The card: navy top edge joining the tab, rounded corners ---- */
.tray-card {
    position: relative;
    overflow: hidden;
    border-top: 12px solid var(--navy);
    border-radius: 0 28px 28px 28px;
    background: #fff;
    box-shadow: 0 30px 70px -20px rgba(8, 18, 52, 0.6);
    max-height: min(82vh, 680px);
    overflow-y: auto;
}

.tray-body {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 1px 270px;
    gap: 0 26px;
    padding: 26px 30px 22px 30px;
}
/* Thin divider between the summary and the stamp. */
.tray-body::before {
    content: "";
    grid-column: 2;
    grid-row: 1;
    width: 1px;
    background: #dde4ef;
}
.tray-info {
    grid-column: 1;
    grid-row: 1;
    min-width: 0;
}
.tray-greet {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 0 0 18px;
    padding-left: 12px;
    border-left: 3px solid var(--gold);
    font-size: 1.05rem;
    color: var(--text);
}
.tray-greet .v-icon {
    color: var(--navy);
}
.tray-headline {
    display: flex;
    align-items: flex-start;
    gap: 18px;
}
.tray-icon {
    flex: none;
    display: grid;
    place-items: center;
    width: 72px;
    height: 72px;
    border-radius: 16px;
    background: #e3ecfb;
    color: var(--navy);
}
.tray-summary {
    margin: 0;
    font-family: "Montserrat", "Inter", sans-serif;
    font-size: 1.85rem;
    font-weight: 800;
    line-height: 1.15;
    letter-spacing: -0.01em;
    color: var(--text);
    max-width: 15ch;
}
.tray-rule {
    display: block;
    width: 72%;
    height: 3px;
    margin-top: 12px;
    border-radius: 2px;
    background: var(--gold);
}
.tray-office {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 16px 0 0 90px;
    font-size: 1.12rem;
    font-weight: 700;
    color: var(--blue);
}
.tally {
    margin: 18px 0 0 18px;
    padding: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 10px;
}
.tally li {
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 1.02rem;
    color: var(--text);
}
.tally-pill {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-width: 150px;
    padding: 8px 16px;
    border-radius: 12px;
    font-family: "Montserrat", "Inter", sans-serif;
    font-size: 0.92rem;
    font-weight: 800;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    white-space: nowrap;
}
.tally-pill--past {
    background: #fde3e1;
    color: var(--red);
}
.tally-pill--due {
    background: #dde8fb;
    color: var(--navy);
}
.tally-pill--new {
    background: #e3ecfb;
    color: var(--blue);
}
.tally li.is-zero .tally-pill--past {
    background: #f1f3f7;
    color: #7a8396;
}
.tally-n {
    min-width: 22px;
    font-family: "Montserrat", "Inter", sans-serif;
    font-size: 1.35rem;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    color: var(--text);
}
.tally-label {
    color: var(--text);
}

/* ---- Receiving stamp ---------------------------------------------------- */
.rcv {
    grid-column: 3;
    grid-row: 1;
    position: relative;
    align-self: center;
    width: 270px;
    height: 270px;
    transform: rotate(-6deg);
}
/* The stamp's shadow coming down before contact. */
.rcv::before {
    content: "";
    position: absolute;
    left: 30px;
    top: 30px;
    width: 210px;
    height: 210px;
    border-radius: 50%;
    background: rgba(8, 18, 52, 0.5);
    filter: blur(16px);
    opacity: 0;
    animation: rcv-shadow 0.32s ease-in 0.3s both;
    pointer-events: none;
}
.rcv-ink {
    position: relative;
    width: 270px;
    height: 270px;
    color: var(--ink);
    -webkit-mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    mask-image: radial-gradient(circle at 50% 50%, #000 var(--ink-r), transparent calc(var(--ink-r) + 18%));
    animation: rcv-press 0.5s cubic-bezier(0.3, 0.7, 0.2, 1) 0.58s both;
}
.rcv-svg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
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
    font-family: "Montserrat", "Public Sans", system-ui, sans-serif;
    font-weight: 800;
    letter-spacing: 0.06em;
}
.rcv-word {
    fill: currentColor;
    font-family: "Montserrat", "Public Sans", system-ui, sans-serif;
    font-size: 27px;
    font-weight: 800;
    letter-spacing: 0.14em;
}
/* Dater under the band, inside the inner ring (240-unit stamp scaled to
   270px: positions below are in px). */
.rcv-dater {
    position: absolute;
    left: 0;
    right: 0;
    top: 158px;
    display: flex;
    flex-direction: column;
    align-items: center;
    font-family: "Montserrat", "Inter", sans-serif;
    font-weight: 800;
    font-variant-numeric: tabular-nums;
    line-height: 1;
}
.rcv-date {
    font-size: 15px;
    letter-spacing: 0.03em;
}
.rcv-time {
    display: inline-flex;
    align-items: flex-end;
    gap: 6px;
    margin-top: 3px;
    font-size: 11.5px;
    letter-spacing: 0.04em;
}
.rcv-by {
    padding-left: 6px;
    border-left: 1.5px solid currentColor;
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
    width: 0.68em;
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

/* ---- Actions: light panel with the city hall faintly at the left ---- */
.tray-foot {
    position: relative;
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    padding: 20px 26px 22px;
    background: var(--panel);
}
.tray-foot::before {
    content: "";
    position: absolute;
    left: -10px;
    bottom: -6px;
    width: 300px;
    height: 120px;
    background: url("/footer-hall.webp") left bottom / auto 92% no-repeat;
    opacity: 0.13;
    pointer-events: none;
}
.tray-foot::after {
    content: "";
    position: absolute;
    left: -40px;
    bottom: -38px;
    width: 420px;
    height: 70px;
    border-radius: 50%;
    background: rgba(29, 86, 196, 0.08);
    pointer-events: none;
}
.tray-btn {
    position: relative;
    z-index: 1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    min-width: 230px;
    height: 58px;
    padding: 0 24px;
    border: 0;
    border-radius: 12px;
    font-family: "Montserrat", "Inter", sans-serif;
    font-size: 1rem;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    cursor: pointer;
    transition: filter 0.15s ease, transform 0.15s ease;
}
.tray-btn:hover {
    filter: brightness(1.05);
    transform: translateY(-1px);
}
.tray-btn:focus-visible {
    outline: 3px solid rgba(29, 86, 196, 0.45);
    outline-offset: 3px;
}
.tray-btn--later {
    background: linear-gradient(180deg, #f3f6fb, #dfe7f3);
    color: var(--navy);
    box-shadow: inset 0 0 0 1px #cfd9ea, 0 6px 14px -10px rgba(15, 42, 92, 0.6);
}
.tray-btn--open {
    background: linear-gradient(180deg, #1f3f7e, var(--navy));
    color: #fff;
    box-shadow: 0 12px 22px -12px rgba(15, 42, 92, 0.9);
}

/* ---- Entrance: pulled up, then the stamp is pressed ---------- */
.tray-pull-enter-active {
    animation: tray-pull 0.34s cubic-bezier(0.2, 0.8, 0.25, 1) both;
}
.tray-pull-enter-active .tray-card {
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
        opacity: 1;
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

/* ---- Narrow screens: the stamp sits under the summary ---- */
@media (max-width: 760px) {
    .tray-tab {
        width: 280px;
        gap: 10px;
        padding-left: 16px;
    }
    .tab-code {
        font-size: 1.15rem;
    }
    .tray-close {
        width: 44px;
        height: 44px;
    }
    .tray-body {
        grid-template-columns: minmax(0, 1fr);
        padding: 20px 18px 14px;
    }
    .tray-body::before {
        display: none;
    }
    .rcv {
        grid-column: 1;
        grid-row: 2;
        justify-self: center;
        margin-top: 10px;
        width: 220px;
        height: 220px;
    }
    .rcv-ink {
        transform-origin: top left;
        scale: 0.815;
    }
    .tray-summary {
        font-size: 1.45rem;
    }
    .tray-icon {
        width: 56px;
        height: 56px;
    }
    .tray-office {
        margin-left: 74px;
        font-size: 1rem;
    }
    .tally {
        margin-left: 0;
    }
    .tally-pill {
        min-width: 128px;
        padding: 7px 12px;
    }
    .tray-foot {
        flex-direction: column-reverse;
        padding: 16px 18px 18px;
    }
    .tray-btn {
        width: 100%;
        min-width: 0;
    }
}

@media (prefers-reduced-motion: reduce) {
    .tray-pull-enter-active,
    .tray-pull-enter-active .tray-card,
    .rcv::before,
    .rcv-ink,
    .dg > span {
        animation: none !important;
    }
    .rcv-ink {
        -webkit-mask-image: none;
        mask-image: none;
    }
}
</style>
