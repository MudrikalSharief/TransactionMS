<template>
    <!-- Login hero: the artwork (public/login-hero.webp) with glows laid
         over it. The frame keeps the picture's 3:2 shape and is fitted
         whole into the panel; a matching soft sky fills any spare edges. Glow
         positions are in the picture's own pixels (1536 x 1024). -->
    <div class="lh" :class="{ 'is-in': loaded }">
        <div class="lh-fill" aria-hidden="true" />
        <div class="lh-frame">
            <img
                class="lh-img"
                :src="'/login-hero.webp'"
                alt=""
                width="1536"
                height="1024"
                decoding="async"
                @load="loaded = true"
            />

            <div class="lh-fx" aria-hidden="true">
                <!-- light dots on the orbit ring -->
                <!-- ring beads light up one at a time, in order round the ring -->
                <span
                    v-for="(d, i) in dots"
                    :key="`d${i}`"
                    class="lh-dot"
                    :style="{ ...at(d[0], d[1], 66, 66), animationDuration: `${dots.length * DOT_STEP}s`, animationDelay: `${i * DOT_STEP}s` }"
                />
                <!-- headline accent bar -->
                <span class="lh-bar" :style="at(1079, 257, 128, 8)" />
                <!-- twinkles -->
                <span v-for="(s, i) in sparkles" :key="`s${i}`" class="lh-spark" :style="{ ...at(s[0], s[1], s[2], s[2]), '--delay': `${s[3]}s` }" />
            </div>
        </div>

        <!-- Text for screen readers (the artwork is decorative). -->
        <div class="sr-only">
            <h3>One place for city transactions</h3>
            <p>Process requests, approvals and records across departments.</p>
            <ul>
                <li v-for="m in modules" :key="m">{{ m }}</li>
            </ul>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue";

const W = 1536;
const H = 1024;

const loaded = ref(false);

// Centre (x, y), size (w x h) in picture pixels -> percent of the frame.
function at(x, y, w, h) {
    return {
        left: `${(x / W) * 100}%`,
        top: `${(y / H) * 100}%`,
        width: `${(w / W) * 100}%`,
        height: `${(h / H) * 100}%`,
    };
}

// The modules shown on the buttons in the artwork.
const modules = ["Procurement", "Payroll", "Budget", "Disbursement", "Permits", "Records"];

// The ring's 8 beads as drawn in the artwork, clockwise from the top-left
// of the tower. Each lights up for one DOT_STEP in turn and trails off.
const dots = [
    [435, 222], [598, 220], [923, 394], [868, 624], [605, 763], [230, 671], [130, 596], [106, 359],
];
const DOT_STEP = 0.12; // seconds per bead: fast, so the light reads as a running dashed line

// [x, y, size, delay]
const sparkles = [
    [536, 132, 30, 0], [1180, 228, 26, 1.6], [300, 330, 22, 2.4],
    [960, 330, 24, 0.8], [1440, 560, 22, 3.1], [690, 880, 26, 1.2],
];
</script>

<style scoped>
.lh {
    position: absolute;
    inset: 0;
    overflow: hidden;
    container-type: size;
    background: #EAF2FD;
}
/* Soft sky in the artwork's own colours fills any space around the
   frame (tall or very wide panels); the picture's edges fade into it. */
.lh-fill {
    position: absolute;
    inset: 0;
    background:
        radial-gradient(70% 45% at 100% 100%, rgba(96, 165, 250, 0.45) 0%, transparent 70%),
        radial-gradient(60% 40% at 0% 0%, rgba(191, 219, 254, 0.6) 0%, transparent 70%),
        linear-gradient(180deg, #F3F7FD 0%, #EAF2FD 55%, #DCEAFB 100%);
}

/* The picture, whole, at its 3:2 shape. */
.lh-frame {
    position: absolute;
    left: 50%;
    top: 50%;
    width: min(100cqw, 150cqh);
    aspect-ratio: 3 / 2;
    transform: translate(-50%, -50%) scale(1.03);
    opacity: 0;
    transition: opacity 0.9s ease, transform 1.2s cubic-bezier(0.2, 0.8, 0.2, 1);
    container-type: inline-size;
}
.is-in .lh-frame {
    opacity: 1;
    transform: translate(-50%, -50%);
}
.lh-img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    /* Feather all four edges into the blurred fill (no seams). */
    -webkit-mask-image:
        linear-gradient(to bottom, transparent 0, #000 7%, #000 93%, transparent 100%),
        linear-gradient(to right, transparent 0, #000 5%, #000 95%, transparent 100%);
    -webkit-mask-composite: source-in;
    mask-image:
        linear-gradient(to bottom, transparent 0, #000 7%, #000 93%, transparent 100%),
        linear-gradient(to right, transparent 0, #000 5%, #000 95%, transparent 100%);
    mask-composite: intersect;
}

.lh-fx {
    position: absolute;
    inset: 0;
    pointer-events: none;
}

.lh-fx > span {
    position: absolute;
    transform: translate(-50%, -50%);
}


/* ---- ring beads ---- */
/* Bright blue: a white-hot core, a vivid blue ring and a soft halo.
   Duration (beads x step) and delay (index x step) are set per bead, so
   they light in order round the ring. */
.lh-dot {
    border-radius: 50%;
    /* One smooth gradient that fades to nothing: no hard rim, and the
       glow stays clear of the buttons. */
    background: radial-gradient(
        circle,
        #ffffff 0 11%,
        #a8dcff 18%,
        #2f8bff 30%,
        rgba(30, 110, 255, 0.5) 42%,
        rgba(30, 110, 255, 0.16) 56%,
        rgba(30, 110, 255, 0) 68%
    );
    opacity: 0;
    animation-name: bead;
    animation-timing-function: ease-out;
    animation-iteration-count: infinite;
    will-change: transform, opacity;
}

/* ---- headline accent ---- */
.lh-bar {
    border-radius: 4px;
    box-shadow: 0 0 1.2cqw 0.25cqw rgba(37, 99, 235, 0.65);
    animation: breathe 3.2s ease-in-out infinite;
}

/* ---- sparkles: four-point stars ---- */
.lh-spark {
    background: radial-gradient(circle, #fff 0 12%, rgba(186, 230, 253, 0.8) 22%, transparent 60%);
    clip-path: polygon(50% 0, 58% 42%, 100% 50%, 58% 58%, 50% 100%, 42% 58%, 0 50%, 42% 42%);
    animation: sparkle 4.2s var(--delay) ease-in-out infinite;
    opacity: 0;
}

@keyframes breathe {
    0%, 100% { opacity: 0.55; }
    50% { opacity: 1; }
}
/* 8 beads: each step is 12.5% of the cycle. Flash up, hold through its
   step, then trail off during the next bead's step (gone by 25%), which
   gives the running dashed-line look; dark until its turn comes round. */
@keyframes bead {
    0% { opacity: 0; transform: translate(-50%, -50%) scale(0.7); }
    2% { opacity: 1; transform: translate(-50%, -50%) scale(1.1); }
    9% { opacity: 1; transform: translate(-50%, -50%) scale(1); }
    25%, 100% { opacity: 0; transform: translate(-50%, -50%) scale(0.75); }
}
@keyframes sparkle {
    0%, 60%, 100% { opacity: 0; transform: translate(-50%, -50%) scale(0.4) rotate(0deg); }
    75% { opacity: 1; transform: translate(-50%, -50%) scale(1) rotate(45deg); }
}

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    overflow: hidden;
    clip: rect(0 0 0 0);
    white-space: nowrap;
}

@media (prefers-reduced-motion: reduce) {
    .lh-frame {
        transition: none;
    }
    .lh-dot,
    .lh-bar {
        animation: none;
        opacity: 0.8;
    }
    .lh-spark {
        display: none;
    }
}
</style>
