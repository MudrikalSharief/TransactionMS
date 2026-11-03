<template>
    <div
        class="welcome"
        :class="{ ready, leaving }"
        :style="{ '--auto': AUTO_MS + 'ms' }"
        role="dialog"
        aria-labelledby="welcome-title"
        @click="go"
    >
        <!-- Motion-graphics build, one medallion after the other: three
             rounded layers (gold, navy, ivory) pop out into a bullseye, then
             the emblem generates itself ring by ring from the centre out as
             they fold away, while a gold ring draws around it. The city seal (the authority)
             builds first, the system emblem (the service) answers it; their
             guilloche rings engrave and interlace, and a gold link ties them. -->
        <div class="pair">
            <div v-for="m in MEDALS" :key="m.key" class="medal" :class="`medal--${m.key}`">
                <svg class="rosette" viewBox="-240 -240 480 480" aria-hidden="true">
                    <g v-for="(ring, i) in rings" :key="i" class="ring" :class="{ rev: (i + m.flip) % 2 }">
                        <path
                            v-for="(d, j) in ring.paths"
                            :key="j"
                            :d="d"
                            pathLength="1"
                            :style="{ animationDelay: m.at + 0.15 + i * 0.16 + j * 0.05 + 's' }"
                        />
                    </g>
                </svg>
                <span class="press" aria-hidden="true"></span>
                <!-- Three rounded layers that pop out into a bullseye, then
                     collapse as the iris opens on the emblem. -->
                <span class="disc disc--1" aria-hidden="true"></span>
                <span class="disc disc--2" aria-hidden="true"></span>
                <span class="disc disc--3" aria-hidden="true"></span>
                <!-- Gold ring that draws itself around the emblem. -->
                <svg class="trace" viewBox="0 0 100 100" aria-hidden="true">
                    <circle cx="50" cy="50" r="48.5" pathLength="1" />
                </svg>
                <!-- The emblem generates itself layer by layer: copies of it,
                     each masked to one of its own rings (centre art, lettering
                     band, outer rim), build from the centre outward. Together
                     they make the exact picture; the full emblem then takes
                     over (it carries the shadow and the flight to the tracker). -->
                <div class="face">
                    <img
                        v-for="(L, k) in m.layers"
                        :key="k"
                        class="layer"
                        :class="`layer--${k + 1}`"
                        :src="m.src"
                        alt=""
                        aria-hidden="true"
                        :style="{ '--r0': L[0], '--r1': L[1] }"
                    />
                    <img
                        class="emblem"
                        :src="m.src"
                        :alt="m.alt"
                        :width="m.w"
                        :height="m.h"
                        decoding="async"
                        fetchpriority="high"
                        @load="onLoaded"
                        @error="onLoaded"
                    />
                    <span class="glint" aria-hidden="true"></span>
                </div>
            </div>
            <span class="tie" aria-hidden="true"><i></i></span>
        </div>

        <div class="words">
            <h1 id="welcome-title" class="hello">Mabuhay!</h1>
            <p class="lede">
                Welcome to the Transaction Management System of the City Government of Zamboanga.
            </p>
            <p class="note">Follow any document from office to office. Attached files stay private.</p>
            <button ref="enterBtn" type="button" class="enter" @click.stop="go">Track my documents</button>

            <!-- Countdown in the colours of the vinta's sail, from the seal. -->
            <div class="auto">
                <span class="vinta" aria-hidden="true"><span></span></span>
                <span>Opens on its own in a few seconds</span>
            </div>
        </div>
    </div>
</template>

<script setup>
import { nextTick, onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import { motionOff } from "@/composables/useMotion";

const router = useRouter();

// Served from public/, bound as a string so Vite leaves it alone.
// The pair, left to right. `at` is when its rings start to engrave (after the
// medallion has built); `flip` makes the
// two rosettes turn against each other so they weave where they overlap.
const MEDALS = [
    {
        key: "city",
        src: "/zamboanga-seal.png",
        alt: "Official seal of the City of Zamboanga",
        w: 256,
        h: 256,
        at: 1.75,
        flip: 0,
        // Its own rings, as fractions of the radius: white field with the
        // shield, yellow lettering band, black edge.
        layers: [
            [0, 0.7],
            [0.7, 0.965],
            [0.965, 9],
        ],
    },
    {
        key: "tms",
        src: "/tms-logo.png",
        alt: "Transaction Management System emblem, Local Government of Zamboanga City",
        w: 400,
        h: 416,
        at: 2.2,
        flip: 1,
        // Centre art; inner gold ring, white lettering band and gold line;
        // navy and gold rims with the ribbon.
        layers: [
            [0, 0.7],
            [0.7, 0.905],
            [0.905, 9],
        ],
    },
];

// Counted from the moment both emblems have loaded.
const AUTO_MS = 6000;

// Guilloche: bands whose radius ripples k times around the circle; several
// phase-shifted copies of each band interlace like engraved security lines.
function band(a, b, k, copies) {
    const STEPS = 720;
    const paths = [];
    for (let c = 0; c < copies; c++) {
        const phase = (2 * Math.PI * c) / copies;
        let d = "";
        for (let s = 0; s <= STEPS; s++) {
            const t = (2 * Math.PI * s) / STEPS;
            const r = a + b * Math.cos(k * t + phase);
            d += (s ? "L" : "M") + (r * Math.cos(t)).toFixed(1) + " " + (r * Math.sin(t)).toFixed(1);
        }
        paths.push(d + "Z");
    }
    return { paths };
}
const rings = [band(136, 6, 30, 5), band(156, 9, 22, 4), band(176, 5, 44, 3), band(192, 3, 60, 2)];

// Animations off (sidebar/login toggle, or a weak device): no fly-over.
const reduced = motionOff();

// Every animation waits for the seal, so nothing plays over an empty screen.
const ready = ref(false);
const leaving = ref(false);
const enterBtn = ref(null);
let timer = null;
let fallback = null;
let gone = false;

// Every emblem must be in before anything plays.
let loaded = 0;
function onLoaded() {
    if (++loaded >= MEDALS.length) onReady();
}

function onReady() {
    if (ready.value) return;
    ready.value = true;
    clearTimeout(fallback);
    timer = setTimeout(go, AUTO_MS);
    enterBtn.value?.focus({ preventScroll: true });
}

// Hand over to the tracker. Where the browser supports view transitions,
// the seal flies into the tracker's own seal while the page dissolves into
// it; elsewhere this screen simply fades out first.
function go() {
    if (gone) return;
    gone = true;
    clearTimeout(timer);
    clearTimeout(fallback);

    const to = () => router.replace("/track");
    if (!reduced && document.startViewTransition) {
        document.startViewTransition(async () => {
            await to();
            await nextTick();
        });
    } else if (!reduced) {
        leaving.value = true;
        setTimeout(to, 280);
    } else {
        to();
    }
}

function onKey(e) {
    if (e.key === "Enter" || e.key === "Escape" || e.key === " ") {
        e.preventDefault();
        go();
    }
}

onMounted(() => {
    fallback = setTimeout(onReady, 1500);
    window.addEventListener("keydown", onKey);
});

onUnmounted(() => {
    clearTimeout(timer);
    clearTimeout(fallback);
    window.removeEventListener("keydown", onKey);
});
</script>

<style scoped>
.welcome {
    --navy-deep: #081636;
    --navy: #0d2459;
    --navy-lit: #163a86;
    --gold: #e8b923;
    --ivory: #f5f1e6;
    /* Two medallions side by side: sized by height and by width. */
    --seal: clamp(104px, min(26vh, 27vw), 210px);
    --gap: calc(var(--seal) * 0.42);
    position: fixed;
    inset: 0;
    z-index: 2000;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: clamp(20px, 4vh, 40px);
    padding: 24px 20px;
    overflow: hidden;
    background: radial-gradient(circle at 50% 36%, var(--navy-lit) 0%, var(--navy) 38%, var(--navy-deep) 78%);
    color: var(--ivory);
    font-family: 'Public Sans', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
    white-space: normal;
    cursor: pointer;
    transition: opacity 0.28s ease;
}
.welcome:not(.ready) *,
.welcome:not(.ready) .tie::before {
    animation-play-state: paused !important;
}
.welcome.leaving {
    opacity: 0;
}

/* ---- The pair: a motion-graphics build, one medallion after the other ----
   Times are from the moment both emblems have loaded; the system emblem runs
   the same build --at (0.45s) after the city seal.
   0.05s  three rounded layers pop out with an overshoot: gold, navy, ivory
   0.72s  the emblem generates itself from the centre outward, one of its
          own rings at a time (centre art, lettering band, outer rim) while
          the coloured layers fold away and a gold ring draws around it
   1.72s  the medallion presses down; its guilloche rings start to engrave
   2.40s  the gold link draws between the pair; light sweeps each face */
.pair {
    position: relative;
    display: flex;
    align-items: flex-start;
    gap: var(--gap);
    flex: none;
    /* Room for the rosettes, which reach past the medallions. */
    margin: calc(var(--seal) * 0.3) 0 calc(var(--seal) * 0.34);
}
.medal {
    position: relative;
    width: var(--seal);
    height: var(--seal);
    flex: none;
}
.medal--city {
    --at: 0s;
}
.medal--tms {
    --at: 0.45s;
}

/* Rosette spans twice the seal, centred on it. */
.rosette {
    position: absolute;
    left: 50%;
    top: 50%;
    width: calc(var(--seal) * 2);
    height: calc(var(--seal) * 2);
    transform: translate(-50%, -50%);
    overflow: visible;
    pointer-events: none;
}
/* Turns about the seal's centre: the viewBox origin (0 0), which the
   view-box reference box puts at its top-left corner. */
.ring {
    transform-origin: 0 0;
    transform-box: view-box;
    animation: turn 120s linear 3.8s infinite;
}
.ring.rev {
    animation-direction: reverse;
}
.ring path {
    fill: none;
    stroke: var(--gold);
    stroke-width: 0.7;
    stroke-opacity: 0.46;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    animation: engrave 1.9s cubic-bezier(0.45, 0.05, 0.25, 1) both;
}

/* ---- The three rounded layers ----
   Nested circles centred on the medallion: gold (largest), navy, ivory.
   They pop out one after another, then fold away innermost first. */
.disc {
    position: absolute;
    left: 50%;
    top: 50%;
    border-radius: 50%;
    pointer-events: none;
    transform: translate(-50%, -50%) scale(0);
}
.disc--1 {
    width: calc(var(--seal) * 1.16);
    height: calc(var(--seal) * 1.16);
    background: var(--gold);
    animation:
        disc-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) calc(0.05s + var(--at)) forwards,
        disc-fold 0.42s cubic-bezier(0.55, 0, 0.75, 0) calc(1.02s + var(--at)) forwards;
}
.disc--2 {
    width: calc(var(--seal) * 0.9);
    height: calc(var(--seal) * 0.9);
    background: var(--navy-lit);
    box-shadow: 0 0 0 calc(var(--seal) * 0.025) var(--navy-deep);
    animation:
        disc-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) calc(0.17s + var(--at)) forwards,
        disc-fold 0.42s cubic-bezier(0.55, 0, 0.75, 0) calc(0.92s + var(--at)) forwards;
}
.disc--3 {
    width: calc(var(--seal) * 0.6);
    height: calc(var(--seal) * 0.6);
    background: var(--ivory);
    animation:
        disc-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) calc(0.29s + var(--at)) forwards,
        disc-fold 0.42s cubic-bezier(0.55, 0, 0.75, 0) calc(0.8s + var(--at)) forwards;
}

/* Gold ring drawn around the medallion (a "trim path"). */
.trace {
    position: absolute;
    left: 50%;
    top: 50%;
    width: calc(var(--seal) * 1.1);
    height: calc(var(--seal) * 1.1);
    transform: translate(-50%, -50%) rotate(-90deg);
    overflow: visible;
    pointer-events: none;
}
.trace circle {
    fill: none;
    stroke: var(--gold);
    stroke-width: 0.9;
    stroke-linecap: round;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    animation: trace 0.75s cubic-bezier(0.65, 0, 0.35, 1) calc(1.15s + var(--at)) forwards;
}

/* The emblem generates itself from the centre outward, one of its own rings
   at a time: the centre art grows in with a twist, the lettering band spins
   in around it, then the outer rim closes in. Each layer is a copy of the
   emblem masked to one ring (radii --r0..--r1, as fractions of the radius,
   centred on the emblem's circle); they meet edge to edge, so together they
   are the exact picture. The whole medallion presses down at the end. */
.face {
    position: relative;
    width: 100%;
    animation: stamp 0.34s ease-out calc(1.72s + var(--at));
}
.medal--city .face {
    height: 100%;
}
.layer {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    user-select: none;
    --c: calc(var(--seal) / 2);
    --in: calc(var(--c) * var(--r0) - 0.5px);
    --out: calc(var(--c) * var(--r1) + 0.5px);
    -webkit-mask-image: radial-gradient(circle at 50% var(--c), transparent var(--in), #000 var(--in), #000 var(--out), transparent var(--out));
    mask-image: radial-gradient(circle at 50% var(--c), transparent var(--in), #000 var(--in), #000 var(--out), transparent var(--out));
    transform-origin: 50% var(--c);
    opacity: 0;
}
.medal--tms .layer {
    height: auto;
    aspect-ratio: 400 / 416;
}
/* Centre art: grows from the middle with a counter-twist. */
.layer--1 {
    animation: layer-core 0.6s cubic-bezier(0.34, 1.5, 0.64, 1) calc(0.72s + var(--at)) forwards;
}
/* Lettering band: spins in around the centre. */
.layer--2 {
    animation: layer-band 0.75s cubic-bezier(0.22, 1.2, 0.36, 1) calc(0.92s + var(--at)) forwards;
}
/* Outer rim: closes in from wide to lock the medallion. */
.layer--3 {
    animation: layer-rim 0.5s cubic-bezier(0.34, 1.4, 0.64, 1) calc(1.22s + var(--at)) forwards;
}

/* The full emblem takes over once the layers have met (identical picture,
   so the hand-over is invisible); it brings the shadow and the flight. */
.emblem {
    position: relative;
    display: block;
    width: 100%;
    opacity: 0;
    animation: fade-in 0.25s ease-out calc(1.7s + var(--at)) forwards;
}
.medal--city .emblem {
    height: 100%;
    border-radius: 50%;
    box-shadow: 0 18px 50px rgba(2, 8, 28, 0.55);
    /* Flies into the tracker's own seal on the way out. */
    view-transition-name: city-seal;
}
/* The emblem is a little taller than wide (its ribbon hangs below the
   circle); the circle itself sits in the top square, level with the seal. */
.medal--tms .emblem {
    height: auto;
    aspect-ratio: 400 / 416;
    filter: drop-shadow(0 16px 26px rgba(2, 8, 28, 0.5));
    /* Flies into the tracker's own emblem on the way out. */
    view-transition-name: tms-emblem;
}
/* The impression spreading out as it presses (the round part only). */
.press {
    position: absolute;
    left: -2px;
    top: -2px;
    width: calc(var(--seal) + 4px);
    height: calc(var(--seal) + 4px);
    border-radius: 50%;
    border: 2px solid var(--gold);
    opacity: 0;
    pointer-events: none;
    /* forwards, not both: stays hidden until the press. */
    animation: impress 1s cubic-bezier(0.2, 0.7, 0.2, 1) calc(1.72s + var(--at)) forwards;
}
/* One pass of light across each emblem (shaped by the emblem itself). */
.glint {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    background: linear-gradient(115deg, transparent 35%, rgba(255, 250, 230, 0.75) 50%, transparent 65%) no-repeat;
    background-size: 250% 100%;
    background-position: 150% 0;
    mix-blend-mode: soft-light;
    pointer-events: none;
    animation: glint 1.1s ease-in-out calc(2.4s + var(--at)) both;
}
.medal--city .glint {
    height: 100%;
    -webkit-mask: url('/zamboanga-seal.png') center / contain no-repeat;
    mask: url('/zamboanga-seal.png') center / contain no-repeat;
}
.medal--tms .glint {
    aspect-ratio: 400 / 416;
    -webkit-mask: url('/tms-logo.png') center / contain no-repeat;
    mask: url('/tms-logo.png') center / contain no-repeat;
}

/* The gold link between the pair: a fine rule with a lozenge at its centre,
   drawn once both medallions have built. */
.tie {
    position: absolute;
    left: var(--seal);
    top: calc(var(--seal) / 2);
    width: var(--gap);
    height: 0;
    pointer-events: none;
}
.tie::before {
    content: "";
    position: absolute;
    left: 6%;
    right: 6%;
    top: -0.5px;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--gold) 30%, var(--gold) 70%, transparent);
    transform: scaleX(0);
    animation: grow 0.6s cubic-bezier(0.2, 0.7, 0.2, 1) 2.4s forwards;
}
.tie i {
    position: absolute;
    left: 50%;
    top: 0;
    width: 9px;
    height: 9px;
    margin: -4.5px 0 0 -4.5px;
    background: var(--gold);
    box-shadow: 0 0 10px rgba(232, 185, 35, 0.6);
    transform: rotate(45deg) scale(0);
    animation: lozenge 0.45s cubic-bezier(0.2, 0.8, 0.2, 1.4) 2.7s forwards;
}

@keyframes disc-pop {
    from {
        transform: translate(-50%, -50%) scale(0);
    }
    to {
        transform: translate(-50%, -50%) scale(1);
    }
}
@keyframes disc-fold {
    from {
        transform: translate(-50%, -50%) scale(1);
    }
    to {
        transform: translate(-50%, -50%) scale(0);
    }
}
@keyframes trace {
    to {
        stroke-dashoffset: 0;
    }
}
@keyframes fade-in {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
@keyframes layer-core {
    from {
        opacity: 0;
        transform: scale(0.2) rotate(-60deg);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes layer-band {
    from {
        opacity: 0;
        transform: scale(0.82) rotate(-220deg);
    }
    30% {
        opacity: 1;
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes layer-rim {
    from {
        opacity: 0;
        transform: scale(1.4);
    }
    to {
        opacity: 1;
        transform: none;
    }
}

/* ---- Words ---- */
.words {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    max-width: 560px;
    animation: rise 0.8s cubic-bezier(0.2, 0.7, 0.2, 1) 2.4s both;
}
.hello {
    margin: 0;
    font-family: 'Iowan Old Style', 'Palatino Linotype', Palatino, 'Book Antiqua', Georgia, serif;
    font-size: clamp(42px, 6.4vw, 72px);
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.01em;
}
.lede {
    margin: 14px 0 0;
    font-size: clamp(16px, 1.6vw, 19px);
    line-height: 1.5;
    color: rgba(245, 241, 230, 0.92);
    text-wrap: balance;
}
.note {
    margin: 6px 0 0;
    font-size: 14px;
    line-height: 1.5;
    color: rgba(245, 241, 230, 0.62);
}
.enter {
    margin-top: 26px;
    border: 0;
    border-radius: 3px;
    padding: 14px 28px;
    background: var(--gold);
    color: var(--navy-deep);
    font: inherit;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    transition: background-color 0.15s ease, transform 0.05s ease;
}
.enter:hover {
    background: #f3c93c;
}
.enter:active {
    transform: translateY(1px);
}
.enter:focus-visible {
    outline: 2px solid var(--ivory);
    outline-offset: 3px;
}
.auto {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 16px;
    font-size: 12.5px;
    color: rgba(245, 241, 230, 0.55);
}
/* Vinta sail stripes, revealed left to right as the countdown runs. */
.vinta {
    position: relative;
    width: 84px;
    height: 3px;
    background: rgba(245, 241, 230, 0.16);
    overflow: hidden;
}
.vinta span {
    position: absolute;
    inset: 0;
    background: linear-gradient(
        90deg,
        #c8102e 0 20%,
        #e8b923 20% 40%,
        #1f8a4c 40% 60%,
        #1e5bb8 60% 80%,
        #7a2e8c 80% 100%
    );
    clip-path: inset(0 100% 0 0);
    animation: reveal var(--auto) linear both;
}

@keyframes engrave {
    to {
        stroke-dashoffset: 0;
    }
}
@keyframes turn {
    to {
        transform: rotate(360deg);
    }
}
@keyframes stamp {
    40% {
        transform: scale(0.955);
    }
    100% {
        transform: none;
    }
}
@keyframes impress {
    0% {
        opacity: 0.85;
        transform: scale(1);
    }
    100% {
        opacity: 0;
        transform: scale(1.42);
    }
}
@keyframes glint {
    to {
        background-position: -50% 0;
    }
}
@keyframes rise {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes grow {
    to {
        transform: scaleX(1);
    }
}
@keyframes lozenge {
    to {
        transform: rotate(45deg) scale(1);
    }
}
@keyframes reveal {
    to {
        clip-path: inset(0 0 0 0);
    }
}

/* Short landscape screens: tighter. */
@media (max-height: 560px) {
    .note,
    .auto {
        display: none;
    }
    .welcome {
        --seal: clamp(96px, min(24vh, 26vw), 150px);
    }
}

@media (prefers-reduced-motion: reduce) {
    .welcome * {
        animation: none !important;
    }
    .emblem {
        opacity: 1;
    }
    .layer {
        display: none;
    }
    .ring path {
        stroke-dashoffset: 0;
    }
    .press,
    .glint,
    .disc,
    .trace {
        display: none;
    }
    .vinta span {
        clip-path: none;
    }
    .tie::before {
        transform: none;
    }
    .tie i {
        transform: rotate(45deg);
    }
}
</style>

<!-- The handover to the tracker (global: view-transition pseudo-elements
     live outside any component). -->
<style>
::view-transition-group(city-seal),
::view-transition-group(tms-emblem) {
    animation-duration: 0.75s;
    animation-timing-function: cubic-bezier(0.2, 0.7, 0.2, 1);
}
::view-transition-old(root),
::view-transition-new(root) {
    animation-duration: 0.55s;
    animation-timing-function: ease;
}
</style>
