<template>
    <div
        class="welcome"
        :class="{ ready, leaving }"
        :style="{ '--auto': AUTO_MS + 'ms' }"
        role="dialog"
        aria-labelledby="welcome-title"
        @click="go"
    >
        <!-- The seal, pressed like an official stamp, inside guilloche rings
             that engrave themselves the way security paper is printed. -->
        <div class="mark">
            <svg class="rosette" viewBox="-240 -240 480 480" aria-hidden="true">
                <g v-for="(ring, i) in rings" :key="i" class="ring" :class="{ rev: i % 2 }">
                    <path
                        v-for="(d, j) in ring.paths"
                        :key="j"
                        :d="d"
                        pathLength="1"
                        :style="{ animationDelay: 0.15 + i * 0.16 + j * 0.05 + 's' }"
                    />
                </g>
            </svg>
            <span class="press" aria-hidden="true"></span>
            <img
                class="seal"
                :src="SEAL"
                alt="Official seal of the City of Zamboanga"
                width="256"
                height="256"
                decoding="async"
                fetchpriority="high"
                @load="onReady"
                @error="onReady"
            />
            <span class="glint" aria-hidden="true"></span>
        </div>

        <div class="words">
            <h1 id="welcome-title" class="hello">Mabuhay!</h1>
            <p class="lede">Welcome to the City Government of Zamboanga document tracker.</p>
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

const router = useRouter();

// Served from public/, bound as a string so Vite leaves it alone.
const SEAL = "/zamboanga-seal.png";

// Counted from the moment the seal has loaded.
const AUTO_MS = 5200;

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

const reduced = typeof window !== "undefined" && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

// Every animation waits for the seal, so nothing plays over an empty screen.
const ready = ref(false);
const leaving = ref(false);
const enterBtn = ref(null);
let timer = null;
let fallback = null;
let gone = false;

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
    --seal: clamp(150px, 30vh, 232px);
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
.welcome:not(.ready) * {
    animation-play-state: paused !important;
}
.welcome.leaving {
    opacity: 0;
}

/* ---- The mark: rosette, impression ring, seal ---- */
.mark {
    position: relative;
    width: var(--seal);
    height: var(--seal);
    flex: none;
    /* Room for the rosette, which reaches past the seal. */
    margin: calc(var(--seal) * 0.3) 0;
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
    animation: turn 120s linear 2.4s infinite;
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

/* Lands from above and presses down like a stamp. */
.seal {
    position: relative;
    display: block;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    box-shadow: 0 18px 50px rgba(2, 8, 28, 0.55);
    view-transition-name: city-seal;
    animation:
        land 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) 0.2s both,
        stamp 0.32s ease-out 1s;
}
/* The impression spreading out from the stamp. */
.press {
    position: absolute;
    inset: -2px;
    border-radius: 50%;
    border: 2px solid var(--gold);
    opacity: 0;
    pointer-events: none;
    /* forwards, not both: stays hidden until the stamp lands. */
    animation: impress 1s cubic-bezier(0.2, 0.7, 0.2, 1) 1s forwards;
}
/* One pass of light across the seal (shaped by the seal itself). */
.glint {
    position: absolute;
    inset: 0;
    background: linear-gradient(115deg, transparent 35%, rgba(255, 250, 230, 0.75) 50%, transparent 65%) no-repeat;
    background-size: 250% 100%;
    background-position: 150% 0;
    -webkit-mask: url('/zamboanga-seal.png') center / contain no-repeat;
    mask: url('/zamboanga-seal.png') center / contain no-repeat;
    mix-blend-mode: soft-light;
    pointer-events: none;
    animation: glint 1.1s ease-in-out 1.45s both;
}

/* ---- Words ---- */
.words {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    max-width: 560px;
    animation: rise 0.8s cubic-bezier(0.2, 0.7, 0.2, 1) 1.2s both;
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
@keyframes land {
    from {
        opacity: 0;
        transform: translateY(-6%) scale(1.45);
    }
    to {
        opacity: 1;
        transform: none;
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
        --seal: clamp(110px, 26vh, 160px);
    }
}

@media (prefers-reduced-motion: reduce) {
    .welcome * {
        animation: none !important;
    }
    .ring path {
        stroke-dashoffset: 0;
    }
    .press,
    .glint {
        display: none;
    }
    .vinta span {
        clip-path: none;
    }
}
</style>

<!-- The handover to the tracker (global: view-transition pseudo-elements
     live outside any component). -->
<style>
::view-transition-group(city-seal) {
    animation-duration: 0.75s;
    animation-timing-function: cubic-bezier(0.2, 0.7, 0.2, 1);
}
::view-transition-old(root),
::view-transition-new(root) {
    animation-duration: 0.55s;
    animation-timing-function: ease;
}
</style>
