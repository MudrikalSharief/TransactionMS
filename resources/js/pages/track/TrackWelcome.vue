<template>
    <div
        class="welcome"
        :class="{ ready }"
        :style="{ '--auto': AUTO_MS + 'ms' }"
        role="dialog"
        aria-labelledby="welcome-title"
        @click="go"
    >
        <!-- Dusk over the strait: night sky, warm horizon low on the right. -->
        <div class="sky" aria-hidden="true"></div>

        <!-- The one moving thing: the flag raised up the pole, then waving. -->
        <WavingFlag @ready="onReady" />

        <header class="city">
            <img :src="SEAL" alt="" width="40" height="40" />
            <span>City Government of Zamboanga</span>
        </header>

        <main class="greeting">
            <h1 id="welcome-title" class="hello">Mabuhay!</h1>
            <p class="hello-local" lang="cbk">Bienvenidos a Zamboanga.</p>
            <p class="lede">
                Follow your documents from office to office. You can see where each one is;
                attached files stay private.
            </p>
            <button ref="enterBtn" type="button" class="enter" @click.stop="go">Track my documents</button>
            <p class="auto">
                <span class="auto-bar" aria-hidden="true"><span></span></span>
                The tracker opens on its own in a few seconds.
            </p>
        </main>
    </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import WavingFlag from "@/components/track/WavingFlag.vue";

const router = useRouter();

// Served from public/, so bound as a string (a static src would be bundled).
const SEAL = "/zamboanga-seal.png";

// Counted from the moment the flag is up, not from page open.
const AUTO_MS = 5600;

// Every animation waits until the flag has drawn its first frame, so
// nothing plays over an empty screen.
const ready = ref(false);
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
    // Start anyway if the flag never reports in.
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
    --night: #08142e;
    --dusk: #13254f;
    --ember: 201, 120, 63;
    --ivory: #f3eee4;
    --gold: #e9b949;
    position: fixed;
    inset: 0;
    z-index: 2000;
    overflow: hidden;
    background: var(--night);
    color: var(--ivory);
    cursor: pointer;
    font-family: 'Public Sans', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
    /* The app shell sets nowrap globally; the greeting must wrap. */
    white-space: normal;
}
.welcome:not(.ready) * {
    animation-play-state: paused !important;
}

.sky {
    position: absolute;
    inset: 0;
    background:
        radial-gradient(90% 55% at 72% 112%, rgba(var(--ember), 0.42) 0%, rgba(var(--ember), 0.12) 45%, rgba(var(--ember), 0) 70%),
        linear-gradient(180deg, #050d22 0%, var(--night) 35%, var(--dusk) 100%);
}

/* ---- Who is welcoming you ---- */
.city {
    position: absolute;
    top: 28px;
    right: 32px;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 14px;
    font-weight: 500;
    line-height: 1.3;
    color: rgba(243, 238, 228, 0.82);
    animation: appear 0.8s ease-out 0.4s both;
}
.city img {
    width: 40px;
    height: 40px;
    flex: none;
}

/* ---- Greeting: lower right, clear of the flag ---- */
.greeting {
    position: absolute;
    left: 58vw;
    right: 6vw;
    bottom: 11vh;
    max-width: 560px;
    animation: appear 1s ease-out 1.1s both;
}
.hello {
    margin: 0;
    font-family: 'Alegreya', 'Iowan Old Style', 'Palatino Linotype', Palatino, Georgia, serif;
    font-weight: 700;
    font-size: clamp(64px, 8.2vw, 132px);
    line-height: 0.95;
    letter-spacing: -0.015em;
    color: var(--ivory);
}
.hello-local {
    margin: 0.3em 0 0;
    font-family: 'Alegreya', 'Iowan Old Style', 'Palatino Linotype', Palatino, Georgia, serif;
    font-style: italic;
    font-weight: 400;
    font-size: clamp(22px, 2.3vw, 34px);
    line-height: 1.25;
    color: var(--gold);
}
.lede {
    margin: 26px 0 30px;
    max-width: 40ch;
    font-size: 17px;
    line-height: 1.6;
    color: rgba(243, 238, 228, 0.78);
}
.enter {
    border: 0;
    border-radius: 3px;
    padding: 15px 26px;
    background: var(--gold);
    color: var(--night);
    font: inherit;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.15s ease;
}
.enter:hover {
    background: #f3c95f;
}
.enter:focus-visible {
    outline: 2px solid var(--ivory);
    outline-offset: 3px;
}
.auto {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 16px 0 0;
    font-size: 13px;
    line-height: 1.4;
    color: rgba(243, 238, 228, 0.6);
}
.auto-bar {
    position: relative;
    flex: none;
    width: 72px;
    height: 2px;
    background: rgba(243, 238, 228, 0.18);
    overflow: hidden;
}
.auto-bar span {
    position: absolute;
    inset: 0;
    background: var(--gold);
    transform: scaleX(0);
    transform-origin: left;
    animation: fill var(--auto) linear both;
}

@keyframes appear {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
@keyframes fill {
    to {
        transform: scaleX(1);
    }
}

/* ---- Portrait / phones: flag across the top, greeting below ---- */
@media (max-aspect-ratio: 1/1) {
    .city {
        top: 18px;
        right: 18px;
        font-size: 13px;
    }
    .city img {
        width: 32px;
        height: 32px;
    }
    .greeting {
        left: calc(12vw + 22px);
        right: 7vw;
        bottom: 7vh;
    }
    .hello {
        font-size: clamp(52px, 15vw, 96px);
    }
    .lede {
        font-size: 16px;
        margin: 18px 0 24px;
    }
}
@media (max-height: 560px) and (min-aspect-ratio: 1/1) {
    .lede {
        display: none;
    }
    .greeting {
        bottom: 7vh;
    }
}

@media (prefers-reduced-motion: reduce) {
    .city,
    .greeting {
        animation: none;
    }
}
</style>
