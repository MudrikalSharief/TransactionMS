<template>
    <!-- Full-content loading veil: solid cover over everything below the
         horizontal + vertical navbars (white light / #12121a dark), with
         skeleton bars + spinner. Loading always takes priority: the table
         stays hidden until loading is done and the veil drops instantly
         (no fade-out overlap), so the table can never flash before the
         loader. Offsets track Vuetify's layout vars, so rail/expanded/
         hover/mobile drawer states just work. -->
    <transition name="veil-fade">
        <div
            v-if="show"
            class="page-veil"
            role="status"
            aria-live="polite"
            :aria-label="`Loading ${label}`"
        >
            <div class="veil-stage">
                <div class="veil-skel" aria-hidden="true">
                    <div class="veil-bar head" />
                    <div
                        v-for="n in 7"
                        :key="n"
                        class="veil-bar"
                        :style="{ animationDelay: `${n * 0.12}s` }"
                    />
                </div>
                <div class="veil-inner">
                    <div class="veil-orbit" aria-hidden="true">
                        <span class="veil-ring outer" />
                        <span class="veil-ring middle" />
                        <v-avatar color="primary" size="64" class="veil-core">
                            <v-icon color="white" size="32">{{ icon }}</v-icon>
                        </v-avatar>
                    </div>
                    <div class="veil-text">
                        Loading {{ label }}<span class="veil-dots"><span>.</span><span>.</span><span>.</span></span>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script setup>
import { onUnmounted, watch } from 'vue'

// Visibility binds DIRECTLY to `show` with no grace timer: the table is
// v-show="!loading" on the same flag, so loader and table are mutually
// exclusive on the same tick and loading strictly comes first. Any delay
// here lets fast responses paint the table before the veil appears,
// which reads as table-then-loading.
const props = defineProps({
    // Bind the page's loading flag directly.
    show: { type: Boolean, default: false },
    label: { type: String, default: 'records' },
    icon: { type: String, default: 'mdi-database-sync' },
})

// Immersion: while the veil covers the page, the body scrollbar is
// hidden and the background can't scroll. Always restored on hide
// and on unmount (e.g. navigating away mid-load).
watch(
    () => props.show,
    (v) => {
        document.documentElement.style.overflow = v ? 'hidden' : ''
    },
    { immediate: true },
)

onUnmounted(() => {
    document.documentElement.style.overflow = ''
})
</script>

<style scoped>
.page-veil {
    position: fixed;
    top: var(--v-layout-top, 64px);
    left: var(--v-layout-left, 0px);
    right: var(--v-layout-right, 0px);
    bottom: var(--v-layout-bottom, 0px);
    z-index: 5;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Roboto', sans-serif;
    overflow-y: auto;
}

/* Skeleton bars behind the spinner: solid cover that fully masks the
   table rendering underneath while signaling incoming rows. */
.veil-stage {
    position: relative;
    width: min(880px, calc(100% - 48px));
}

.veil-skel {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.veil-bar {
    height: 44px;
    border-radius: 8px;
    background: linear-gradient(90deg, #e9eef5 25%, #f5f8fc 50%, #e9eef5 75%);
    background-size: 200% 100%;
    animation: veil-shimmer 1.8s linear infinite;
}

.veil-bar.head {
    height: 30px;
    border-radius: 6px;
}

.veil-inner {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: radial-gradient(
        circle at center,
        rgba(255, 255, 255, 0.95) 0%,
        rgba(255, 255, 255, 0.72) 45%,
        rgba(255, 255, 255, 0) 72%
    );
}

.veil-orbit {
    position: relative;
    width: 132px;
    height: 132px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.veil-ring {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
}

.veil-ring.outer {
    inset: 0;
    border: 5px solid #dbe3ef;
    border-top-color: #1e40af;
    border-right-color: #1e40af;
    animation: veil-spin 1.1s linear infinite;
}

.veil-ring.middle {
    inset: 18px;
    border: 3px dashed rgba(30, 64, 175, 0.45);
    animation: veil-spin-rev 2.6s linear infinite;
}

.veil-core {
    animation: veil-pulse 1.8s ease-in-out infinite;
    box-shadow: 0 6px 22px rgba(30, 64, 175, 0.35);
}

.veil-text {
    margin-top: 20px;
    color: #334155;
    font-size: 1rem;
    font-weight: 700;
    letter-spacing: 0.04em;
}

/* ---- Dark mode: same veil, dark surfaces so it never flashes white ---- */
html.dark .page-veil {
    background: #12121a;
}

html.dark .veil-bar {
    background: linear-gradient(90deg, #26263a 25%, #31314a 50%, #26263a 75%);
    background-size: 200% 100%;
}

html.dark .veil-inner {
    background: radial-gradient(
        circle at center,
        rgba(18, 18, 26, 0.95) 0%,
        rgba(18, 18, 26, 0.72) 45%,
        rgba(18, 18, 26, 0) 72%
    );
}

html.dark .veil-ring.outer {
    border-color: #33334d;
    border-top-color: #60a5fa;
    border-right-color: #60a5fa;
}

html.dark .veil-ring.middle {
    border-color: rgba(147, 197, 253, 0.45);
}

html.dark .veil-core {
    box-shadow: 0 6px 22px rgba(0, 0, 0, 0.55);
}

html.dark .veil-text {
    color: #cbd5e1;
}

.veil-dots span {
    display: inline-block;
    margin-left: 3px;
    animation: veil-bounce 1.2s ease-in-out infinite;
    font-weight: 800;
}

.veil-dots span:nth-child(2) {
    animation-delay: 0.15s;
}

.veil-dots span:nth-child(3) {
    animation-delay: 0.3s;
}

/* Enter fades in smoothly; leave is instant so the veil never overlaps
   the freshly painted table (that overlap read as table-then-loading). */
.veil-fade-enter-active {
    transition: opacity 0.25s ease;
}

.veil-fade-leave-active {
    transition: none;
}

.veil-fade-enter-from,
.veil-fade-leave-to {
    opacity: 0;
}

@keyframes veil-shimmer {
    to {
        background-position: -200% 0;
    }
}

@keyframes veil-spin {
    to {
        transform: rotate(360deg);
    }
}

@keyframes veil-spin-rev {
    to {
        transform: rotate(-360deg);
    }
}

@keyframes veil-pulse {
    0%,
    100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.08);
    }
}

@keyframes veil-bounce {
    0%,
    100% {
        transform: translateY(0);
    }
    40% {
        transform: translateY(-4px);
    }
}
</style>
