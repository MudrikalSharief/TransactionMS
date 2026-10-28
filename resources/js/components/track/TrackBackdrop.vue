<template>
    <!-- Flag-inspired backdrop for the viewer pages: blue and red washes, a
         gold sun drawn in fine line that turns slowly, three stars, and a
         light paper grain. Purely decorative; never takes clicks. -->
    <div class="tb" :class="{ quiet }" aria-hidden="true">
        <div class="wash"></div>

        <svg class="sun" viewBox="-100 -100 200 200">
            <g class="sun-spin">
                <circle r="21" class="disc" />
                <circle r="26" class="ring" />
                <circle r="96" class="halo" />
                <g v-for="a in rays" :key="a" :transform="`rotate(${a})`">
                    <path d="M0 -31 L5.5 -58 L0 -90 L-5.5 -58 Z" class="ray" />
                    <line x1="0" y1="-34" x2="0" y2="-74" class="beam" transform="rotate(-9)" />
                    <line x1="0" y1="-34" x2="0" y2="-74" class="beam" transform="rotate(9)" />
                </g>
            </g>
        </svg>

        <svg v-for="s in stars" :key="s.id" class="star" :style="s.style" viewBox="-12 -12 24 24">
            <path d="M0 -11 L2.6 -3.6 L10.5 -3.4 L4.2 1.4 L6.5 9 L0 4.5 L-6.5 9 L-4.2 1.4 L-10.5 -3.4 L-2.6 -3.6 Z" />
        </svg>

        <div class="grain"></div>
    </div>
</template>

<script setup>
// quiet: dims the motif while results are on screen so tables stay readable.
defineProps({ quiet: { type: Boolean, default: false } });

const rays = [0, 45, 90, 135, 180, 225, 270, 315];

const stars = [
    { id: 1, style: { left: "6%", top: "14%", width: "34px", animationDelay: "0s" } },
    { id: 2, style: { left: "9%", bottom: "12%", width: "26px", animationDelay: "1.6s" } },
    { id: 3, style: { right: "8%", top: "46%", width: "30px", animationDelay: "3.1s" } },
];
</script>

<style scoped>
.tb {
    --tb-blue: 30, 64, 175;
    --tb-red: 185, 28, 28;
    --tb-gold: 201, 162, 75;
    /* The whole page area: below the app bar, right of the sidebar
       (Vuetify's layout offsets), so the sun stays centred on the content. */
    position: fixed;
    top: var(--v-layout-top, 0px);
    left: var(--v-layout-left, 0px);
    right: var(--v-layout-right, 0px);
    bottom: var(--v-layout-bottom, 0px);
    z-index: 0;
    transition: left 0.2s ease;
    overflow: hidden;
    pointer-events: none;
    background: rgb(var(--v-theme-background));
}

.wash {
    position: absolute;
    inset: 0;
    background:
        radial-gradient(60% 55% at 50% 42%, rgba(var(--tb-gold), 0.16) 0%, transparent 70%),
        radial-gradient(55% 60% at 0% 0%, rgba(var(--tb-blue), 0.16) 0%, transparent 70%),
        radial-gradient(55% 60% at 100% 100%, rgba(var(--tb-red), 0.13) 0%, transparent 70%),
        linear-gradient(
            160deg,
            rgba(var(--tb-blue), 0.05) 0%,
            transparent 45%,
            transparent 55%,
            rgba(var(--tb-red), 0.05) 100%
        );
    transition: opacity 0.6s ease;
}

/* The sun sits behind the search bar's resting place. */
.sun {
    position: absolute;
    left: 50%;
    top: 46%;
    width: min(92vmin, 860px);
    height: min(92vmin, 860px);
    transform: translate(-50%, -50%);
    opacity: 1;
    transition: opacity 0.6s ease, transform 0.8s cubic-bezier(0.2, 0.7, 0.2, 1);
}
.sun-spin {
    transform-origin: 0 0;
    animation: turn 140s linear infinite;
}
.disc {
    fill: rgba(var(--tb-gold), 0.07);
}
.ring {
    fill: none;
    stroke: rgba(var(--tb-gold), 0.35);
    stroke-width: 0.5;
}
.halo {
    fill: none;
    stroke: rgba(var(--tb-gold), 0.16);
    stroke-width: 0.35;
    stroke-dasharray: 1.5 3;
}
.ray {
    fill: rgba(var(--tb-gold), 0.08);
    stroke: rgba(var(--tb-gold), 0.38);
    stroke-width: 0.45;
    stroke-linejoin: round;
}
.beam {
    stroke: rgba(var(--tb-gold), 0.26);
    stroke-width: 0.4;
    stroke-linecap: round;
}

.star {
    position: absolute;
    aspect-ratio: 1;
    fill: rgba(var(--tb-gold), 0.12);
    stroke: rgba(var(--tb-gold), 0.55);
    stroke-width: 0.8;
    stroke-linejoin: round;
    animation: glint 5s ease-in-out infinite;
}

/* Fine paper grain so the page doesn't read as flat digital fill. */
.grain {
    position: absolute;
    inset: 0;
    opacity: 0.05;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
}

/* Results on screen: the sun steps back and up, washes soften. */
.quiet .sun {
    opacity: 0.35;
    transform: translate(-50%, -62%) scale(0.85);
}
.quiet .wash {
    opacity: 0.7;
}

@keyframes turn {
    to {
        transform: rotate(360deg);
    }
}
@keyframes glint {
    0%,
    100% {
        opacity: 0.45;
        transform: scale(0.92);
    }
    50% {
        opacity: 1;
        transform: scale(1.06);
    }
}

@media (prefers-reduced-motion: reduce) {
    .sun-spin,
    .star {
        animation: none;
    }
    .sun,
    .wash {
        transition: none;
    }
}
</style>
