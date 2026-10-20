<template>
    <div class="welcome" :class="{ ready }" role="dialog" aria-label="Welcome" @click="go">
        <!-- Tall screens letterbox the stage; the flag's colours fill the
             bands above and below. -->
        <div class="backdrop" aria-hidden="true"></div>

        <!-- Stage keeps a fixed 1408x768 shape, so every effect stays pinned
             to the same spot on the flag (sun, stars, greeting). -->
        <div class="stage">
            <div class="cam">
                <!-- The flag itself, rendered live and waving -->
                <WavingFlag :frame="FLAG" @ready="onReady" />

                <!-- Light moving across the satin, like wind in the cloth -->
                <div class="sheen" aria-hidden="true"></div>

                <!-- The sun: slow turning rays and a warm pulse -->
                <div class="sun" aria-hidden="true" :style="{ left: sunAt[0] + '%', top: sunAt[1] + '%' }">
                    <div class="sun-rays"></div>
                    <div class="sun-glow"></div>
                </div>

                <!-- The three stars glint in turn -->
                <span
                    v-for="(at, i) in starsAt"
                    :key="i"
                    class="star"
                    aria-hidden="true"
                    :style="{ left: at[0] + '%', top: at[1] + '%', animationDelay: 0.6 + i * 1.2 + 's' }"
                ></span>

                <!-- Warm glow behind the greeting and a passing shine across it -->
                <div class="greet-glow" aria-hidden="true"></div>
                <div class="greeting">
                    <h1 class="greet-title">Mabuhay!</h1>
                    <p class="greet-line">Welcome to the portal.<br />We are delighted to have you here.</p>
                </div>
                <div class="greet-shine" aria-hidden="true"></div>

                <!-- Gold motes drifting up -->
                <span
                    v-for="m in motes"
                    :key="m.id"
                    class="mote"
                    aria-hidden="true"
                    :style="{
                        left: m.left + '%',
                        width: m.size + 'px',
                        height: m.size + 'px',
                        animationDuration: m.dur + 's',
                        animationDelay: m.delay + 's',
                        '--sway': m.sway + 'px',
                    }"
                ></span>

                <!-- Our own line under the greeting, letter by letter -->
                <div class="city" aria-label="City Government of Zamboanga">
                    <span class="rule left" aria-hidden="true"></span>
                    <span class="city-text" aria-hidden="true">
                        <span
                            v-for="(ch, i) in cityChars"
                            :key="i"
                            class="ch"
                            :style="{ animationDelay: 0.9 + i * 0.025 + 's' }"
                        >{{ ch === " " ? " " : ch }}</span>
                    </span>
                    <span class="rule right" aria-hidden="true"></span>
                </div>
            </div>
        </div>

        <!-- Dark veil that lifts as the picture arrives -->
        <div class="veil" aria-hidden="true"></div>
        <div class="shade" aria-hidden="true"></div>

        <div class="foot">
            <div class="eyebrow">Viewer access · Read-only</div>
            <button type="button" class="enter" @click.stop="go">
                <span>Track my transactions</span>
                <v-icon aria-hidden="true">mdi-arrow-right</v-icon>
            </button>
        </div>

        <!-- Fills while the page waits, then moves on by itself -->
        <div class="timer" aria-hidden="true"><span></span></div>
    </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import WavingFlag from "@/components/track/WavingFlag.vue";
import { STARS, SUN, pointOnContainer } from "@/components/track/flagGeometry";

const router = useRouter();

// Where the flag sits on the stage: sun on the left, the right-hand star
// just behind the start of "Mabuhay!", and the field taller than the stage
// so its edges stay off screen as it waves.
const STAGE_ASPECT = 1408 / 768;
const FLAG = { sunX: 0.15, sunY: 0.42, height: 1.3 };
const sunAt = pointOnContainer(FLAG, STAGE_ASPECT, SUN);
const starsAt = STARS.map((p) => pointOnContainer(FLAG, STAGE_ASPECT, p));

// Counted from the moment the flag is drawn, not from page open.
const AUTO_MS = 4800;

const cityChars = Array.from("City Government of Zamboanga");

// Fixed pseudo-random motes so the layout is the same on every visit.
let seed = 11;
const rand = () => ((seed = (seed * 9301 + 49297) % 233280) / 233280);
const motes = Array.from({ length: 18 }, (_, id) => ({
    id,
    left: 4 + rand() * 92,
    size: 2 + Math.round(rand() * 3),
    dur: 7 + rand() * 6,
    delay: -rand() * 10,
    sway: Math.round((rand() - 0.5) * 60),
}));

// Every animation is paused until the flag has drawn, so nothing plays
// over an empty screen.
const ready = ref(false);
let timer = null;
let fallback = null;
let gone = false;

function onReady() {
    if (ready.value) return;
    ready.value = true;
    clearTimeout(fallback);
    timer = setTimeout(go, AUTO_MS);
}

function go() {
    if (gone) return;
    gone = true;
    clearTimeout(timer);
    clearTimeout(fallback);
    router.replace("/track");
}

function onKey(e) {
    if (e.key === "Enter" || e.key === "Escape" || e.key === " ") {
        e.preventDefault();
        go();
    }
}

onMounted(() => {
    // Very slow network: start anyway after a moment.
    fallback = setTimeout(onReady, 2500);
    window.addEventListener("keydown", onKey);
});

onUnmounted(() => {
    clearTimeout(timer);
    clearTimeout(fallback);
    window.removeEventListener("keydown", onKey);
});
</script>

<style scoped>
/* Only opacity and transform are animated (no blur, no filters), so every
   frame stays sharp and the GPU does the work. */
.welcome {
    --gold: #d9b66a;
    --cream: #fbf1da;
    position: fixed;
    inset: 0;
    z-index: 2000;
    overflow: hidden;
    background: #050a18;
    cursor: pointer;
    font-family: 'Iowan Old Style', 'Palatino Linotype', Palatino, 'Book Antiqua', Georgia, serif;
}
/* Hold every animation on its first frame until the picture is in. */
.welcome:not(.ready) *,
.welcome:not(.ready) *::after {
    animation-play-state: paused !important;
}

.backdrop {
    display: none;
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, #071431 0%, #0b1e52 46%, #4a0b16 54%, #22060c 100%);
}

/* ---- Stage: the picture's own shape, covering the screen ---- */
.stage {
    position: absolute;
    left: 50%;
    top: 50%;
    width: max(100vw, calc(100vh * 1.8333));
    aspect-ratio: 1408 / 768;
    transform: translate(-50%, -50%);
    container-type: inline-size;
}
/* Tall screens: fit the whole picture so the greeting is never cropped. */
@media (max-aspect-ratio: 5/4) {
    /* Letterboxed: fade the flag's top and bottom into the blue and red
       bands, and keep the sheen inside. */
    .stage {
        width: min(100vw, calc(100vh * 1.8333));
        overflow: hidden;
        -webkit-mask-image: linear-gradient(to bottom, transparent, #000 14%, #000 86%, transparent);
        mask-image: linear-gradient(to bottom, transparent, #000 14%, #000 86%, transparent);
    }
    .backdrop {
        display: block;
    }
}

/* Camera: eases in from slightly closer, then keeps drifting slowly. */
.cam {
    position: absolute;
    inset: 0;
    will-change: transform;
    animation:
        settle-cam 1.4s cubic-bezier(0.2, 0.7, 0.2, 1) both,
        drift 14s ease-in-out 1.4s forwards;
}

/* Bands of light rolling across the satin. */
.sheen {
    position: absolute;
    inset: -20% -40%;
    background: repeating-linear-gradient(
        112deg,
        rgba(255, 255, 255, 0) 0%,
        rgba(255, 236, 200, 0.22) 7%,
        rgba(255, 255, 255, 0) 14%,
        rgba(0, 0, 0, 0.12) 21%,
        rgba(255, 255, 255, 0) 28%
    );
    mix-blend-mode: soft-light;
    will-change: transform;
    animation: sheen 6s linear infinite;
    pointer-events: none;
}

/* ---- Sun (placed on the flag's sun from script) ---- */
.sun {
    position: absolute;
    width: 30%;
    aspect-ratio: 1;
    transform: translate(-50%, -50%);
    pointer-events: none;
    animation: fade-in 1s ease-out 0.5s both;
}
.sun-rays {
    position: absolute;
    inset: 0;
    border-radius: 50%;
    background: repeating-conic-gradient(
        from 0deg,
        rgba(255, 214, 140, 0.38) 0deg 3deg,
        rgba(255, 214, 140, 0) 3deg 22.5deg
    );
    -webkit-mask-image: radial-gradient(circle, transparent 17%, #000 27%, rgba(0, 0, 0, 0.6) 45%, transparent 68%);
    mask-image: radial-gradient(circle, transparent 17%, #000 27%, rgba(0, 0, 0, 0.6) 45%, transparent 68%);
    mix-blend-mode: screen;
    will-change: transform;
    animation: spin 48s linear infinite;
}
.sun-glow {
    position: absolute;
    inset: 22%;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 210, 120, 0.55) 0%, rgba(255, 190, 90, 0.18) 45%, transparent 70%);
    mix-blend-mode: screen;
    animation: breathe 3.2s ease-in-out infinite;
}

/* ---- Stars: four-point glints ---- */
.star {
    position: absolute;
    width: 7%;
    aspect-ratio: 1;
    transform: translate(-50%, -50%) scale(0);
    background:
        radial-gradient(circle, rgba(255, 244, 214, 0.95) 0%, rgba(255, 220, 150, 0.35) 18%, transparent 40%),
        linear-gradient(90deg, transparent 47%, rgba(255, 240, 200, 0.9) 50%, transparent 53%),
        linear-gradient(0deg, transparent 47%, rgba(255, 240, 200, 0.9) 50%, transparent 53%);
    -webkit-mask-image: radial-gradient(circle, #000 20%, transparent 70%);
    mask-image: radial-gradient(circle, #000 20%, transparent 70%);
    mix-blend-mode: screen;
    pointer-events: none;
    animation: twinkle 3.6s ease-in-out infinite;
}

/* ---- Greeting (centre of the stage) ---- */
.greeting {
    position: absolute;
    left: 0;
    right: 0;
    top: 30%;
    text-align: center;
    white-space: normal;
    color: var(--cream);
    pointer-events: none;
    animation: fade-in 0.9s ease-out 0.5s both;
}
.greet-title {
    margin: 0;
    font-weight: 500;
    font-size: 8.6cqw;
    line-height: 1.05;
    letter-spacing: 0.005em;
    text-shadow:
        0 0 2.6cqw rgba(255, 190, 110, 0.45),
        0 0.25cqw 1.4cqw rgba(2, 6, 20, 0.6);
}
.greet-line {
    margin: 1.6cqw 0 0;
    font-size: 2.75cqw;
    line-height: 1.38;
    text-shadow:
        0 0 1.6cqw rgba(255, 190, 110, 0.4),
        0 0.15cqw 0.9cqw rgba(2, 6, 20, 0.7);
}
/* Placed with left/top/size only (no transform), so the breathing scale
   below grows it in place instead of shifting it. */
.greet-glow {
    position: absolute;
    left: 20%;
    top: 25%;
    width: 60%;
    height: 50%;
    background: radial-gradient(ellipse, rgba(255, 196, 120, 0.3) 0%, transparent 62%);
    mix-blend-mode: screen;
    pointer-events: none;
    animation:
        fade-in 0.8s ease-out 0.6s both,
        breathe 4.2s ease-in-out 1.4s infinite;
}
.greet-shine {
    position: absolute;
    left: 22%;
    top: 28%;
    width: 56%;
    height: 44%;
    background: linear-gradient(
        104deg,
        transparent 38%,
        rgba(255, 246, 222, 0.9) 48%,
        rgba(255, 214, 140, 0.6) 52%,
        transparent 62%
    );
    background-size: 260% 100%;
    background-position: 160% 0;
    background-repeat: no-repeat;
    -webkit-mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 60%, transparent 100%);
    mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 60%, transparent 100%);
    mix-blend-mode: overlay;
    pointer-events: none;
    animation: shine 2.4s ease-in-out 1.1s infinite;
}

/* ---- Motes ---- */
.mote {
    position: absolute;
    bottom: -4%;
    border-radius: 50%;
    background: radial-gradient(circle, #fff3d0 0%, rgba(217, 182, 106, 0.7) 50%, transparent 75%);
    opacity: 0;
    pointer-events: none;
    will-change: transform, opacity;
    animation-name: rise-mote;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}

/* ---- Our own line under the greeting ---- */
.city {
    position: absolute;
    left: 50%;
    top: 71.5%;
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    gap: 1.2cqw;
    white-space: nowrap;
    pointer-events: none;
}
.city-text {
    font-size: max(11px, 1.25cqw);
    letter-spacing: 0.34em;
    text-transform: uppercase;
    color: var(--gold);
    text-shadow: 0 0 12px rgba(217, 182, 106, 0.45);
}
.ch {
    display: inline-block;
    opacity: 0;
    transform: translateY(0.6em);
    animation: letter 0.45s cubic-bezier(0.2, 0.7, 0.2, 1) both;
}
.rule {
    display: block;
    width: 6cqw;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--gold));
    transform: scaleX(0);
    animation: grow 0.7s cubic-bezier(0.2, 0.7, 0.2, 1) 1.2s forwards;
}
.rule.left {
    transform-origin: right center;
}
.rule.right {
    transform-origin: left center;
    background: linear-gradient(90deg, var(--gold), transparent);
}

.veil {
    position: absolute;
    inset: 0;
    background: #050a18;
    pointer-events: none;
    animation: lift 1.1s ease-out both;
}
.shade {
    position: absolute;
    inset: 0;
    pointer-events: none;
    background:
        radial-gradient(ellipse at 50% 45%, transparent 55%, rgba(2, 6, 20, 0.5) 100%),
        linear-gradient(to top, rgba(2, 6, 20, 0.8) 0%, rgba(2, 6, 20, 0) 32%);
}

.foot {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    padding: 0 20px 44px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
    animation: rise 0.7s cubic-bezier(0.2, 0.7, 0.2, 1) 1.2s both;
}
.eyebrow {
    font-size: 12px;
    letter-spacing: 0.32em;
    text-transform: uppercase;
    color: var(--gold);
}
.enter {
    position: relative;
    overflow: hidden;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 13px 26px;
    border: 1px solid rgba(217, 182, 106, 0.85);
    background: rgba(5, 10, 24, 0.55);
    color: var(--cream);
    font: inherit;
    font-size: 17px;
    letter-spacing: 0.02em;
    cursor: pointer;
    transition: background 0.2s ease, color 0.2s ease, border-color 0.2s ease;
}
.enter::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(100deg, transparent 30%, rgba(255, 236, 196, 0.35) 50%, transparent 70%);
    transform: translateX(-120%);
    animation: glint 3s ease-in-out 1.8s infinite;
}
.enter:hover,
.enter:focus-visible {
    background: var(--gold);
    color: #14213d;
    border-color: var(--gold);
    outline: none;
}
.enter .v-icon {
    font-size: 20px;
    transition: transform 0.2s ease;
}
.enter:hover .v-icon {
    transform: translateX(3px);
}

.timer {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 3px;
    background: rgba(217, 182, 106, 0.16);
}
.timer span {
    display: block;
    height: 100%;
    background: var(--gold);
    transform-origin: left center;
    transform: scaleX(0);
    animation: fill 3.6s linear 1.2s forwards;
}

/* ---- Keyframes (opacity and transform only) ---- */
@keyframes fade-in {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
@keyframes lift {
    from {
        opacity: 1;
    }
    to {
        opacity: 0;
    }
}
@keyframes settle-cam {
    from {
        transform: scale(1.08);
    }
    to {
        transform: scale(1);
    }
}
@keyframes drift {
    0% {
        transform: scale(1) translate(0, 0);
    }
    50% {
        transform: scale(1.05) translate(-1.2%, -0.6%);
    }
    100% {
        transform: scale(1.08) translate(0.6%, -1%);
    }
}
@keyframes sheen {
    from {
        transform: translateX(-12%);
    }
    to {
        transform: translateX(12%);
    }
}
@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}
@keyframes breathe {
    0%,
    100% {
        opacity: 0.55;
        transform: scale(0.96);
    }
    50% {
        opacity: 1;
        transform: scale(1.04);
    }
}
@keyframes twinkle {
    0%,
    62%,
    100% {
        transform: translate(-50%, -50%) scale(0) rotate(0deg);
        opacity: 0;
    }
    74% {
        transform: translate(-50%, -50%) scale(1) rotate(45deg);
        opacity: 1;
    }
    86% {
        transform: translate(-50%, -50%) scale(0.2) rotate(90deg);
        opacity: 0;
    }
}
@keyframes shine {
    0% {
        background-position: 160% 0;
    }
    60%,
    100% {
        background-position: -60% 0;
    }
}
@keyframes rise-mote {
    0% {
        opacity: 0;
        transform: translate(0, 0);
    }
    12% {
        opacity: 0.9;
    }
    80% {
        opacity: 0.6;
    }
    100% {
        opacity: 0;
        transform: translate(var(--sway), -90vh);
    }
}
@keyframes letter {
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
@keyframes rise {
    from {
        opacity: 0;
        transform: translateY(14px);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes glint {
    0% {
        transform: translateX(-120%);
    }
    50%,
    100% {
        transform: translateX(120%);
    }
}
@keyframes fill {
    to {
        transform: scaleX(1);
    }
}

@media (prefers-reduced-motion: reduce) {
    .cam,
    .sheen,
    .sun,
    .sun-rays,
    .sun-glow,
    .star,
    .greet-glow,
    .greet-shine,
    .greeting,
    .mote,
    .ch,
    .rule,
    .veil,
    .foot,
    .enter::after {
        animation: none;
    }
    .mote,
    .star,
    .greet-shine,
    .veil {
        display: none;
    }
    .ch {
        opacity: 1;
        transform: none;
    }
    .rule {
        transform: none;
    }
    .timer span {
        animation-duration: 0.01s;
        animation-delay: 0s;
    }
}
</style>
