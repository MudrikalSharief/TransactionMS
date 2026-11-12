<template>
    <!-- Site footer: City Hall artwork (public/footer-hall.webp, sky cut
         out so it sits on any page background) over a see-through blue
         curve and band with the CSD credit. The swooshes are drawn here. -->
    <!-- Pages that fit the screen (dashboards on desktop) get the same
         footer, sized to the window height so the page never scrolls. -->
    <!-- hallLeft: City Hall in the bottom-left corner, the curve and the
         swooshes sloping down toward it (every page but the tracking page,
         which keeps it centred). -->
    <footer class="tf" :class="{ 'tf--fit': fit, 'tf--left': hallLeft }">
        <!-- The blue: the curve and the band are drawn solid and overlap, and
             the whole layer is made see-through at once, so there is no
             seam where they meet. -->
        <div class="tf-glass" aria-hidden="true">
            <svg class="tf-glass-curve" viewBox="0 0 1600 90" preserveAspectRatio="none">
                <path :d="shape.glass" />
            </svg>
            <div class="tf-glass-band"></div>
        </div>

        <div class="tf-skyline" aria-hidden="true">
            <svg class="tf-curve" viewBox="0 0 1600 120" preserveAspectRatio="none">
                <!-- Gold and blue swooshes, strong away from the building
                     and fading out behind it. -->
                <defs>
                    <linearGradient v-for="g in edgeGradients" :id="g.id" :key="g.id" x1="0" x2="1" y1="0" y2="0">
                        <stop v-for="(st, i) in shape.stops" :key="i" :offset="st[0]" :stop-color="g.color" :stop-opacity="st[1]" />
                    </linearGradient>
                </defs>
                <path class="tf-gold" :d="shape.gold" fill="none" stroke="url(#tf-edge-gold)" vector-effect="non-scaling-stroke" />
                <path class="tf-blue" :d="shape.blue" fill="none" stroke="url(#tf-edge-blue)" vector-effect="non-scaling-stroke" />
            </svg>

            <img class="tf-hall" :src="'/footer-hall.webp'" alt="" width="1000" height="310" decoding="async" />
        </div>

        <div class="tf-band">
            <div class="tf-credit">
                <span class="tf-credit-line" aria-hidden="true"></span>
                <span>Developed by <b>City Hall Computer Service Division</b> <span class="tf-office">- Mayor's Office</span></span>
                <span class="tf-credit-line" aria-hidden="true"></span>
            </div>
        </div>
    </footer>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
    fit: { type: Boolean, default: false },
    // City Hall in the bottom-left corner instead of the middle.
    hallLeft: { type: Boolean, default: false },
});

// Swooshes (0-1600 x 0-120) and the blue curve's top edge (its own 0-90
// box, starting where the swooshes' lowest line sits). Centred: a valley in
// the middle under the building. Left: one slope, high on the right and low
// in the left corner where the building stands.
const SHAPES = {
    centre: {
        gold: "M0 10 C520 78 1080 78 1600 10",
        blue: "M0 20 C520 88 1080 88 1600 20",
        glass: "M0 0 C520 68 1080 68 1600 0 L1600 90 L0 90 Z",
        stops: [[0, 1], [0.32, 0], [0.68, 0], [1, 1]],
    },
    left: {
        gold: "M0 78 C420 80 1020 64 1600 10",
        blue: "M0 88 C420 90 1020 74 1600 20",
        glass: "M0 68 C420 70 1020 54 1600 0 L1600 90 L0 90 Z",
        stops: [[0, 0], [0.24, 0], [0.62, 1], [1, 1]],
    },
};
const shape = computed(() => (props.hallLeft ? SHAPES.left : SHAPES.centre));

const edgeGradients = [
    { id: "tf-edge-gold", color: "#F2B33D" },
    { id: "tf-edge-blue", color: "#2563EB" },
];
</script>

<style scoped>
.tf {
    --tf-blue-solid: #005eed;
    --tf-blue-deep: #0046be;
    --tf-gold: #F2B33D;
    --tf-blue: #2563EB;
    /* Width of the City Hall artwork (1000 x 310); everything scales from
       it so the swooshes always meet the ground. Footer kept at 35% of its
       original size (2026-11-10). */
    --hw: clamp(115px, 17.57vw, 298px);
    position: relative;
    z-index: 1;
    margin-top: 8px;
    color: #fff;
}

/* ---- see-through blue layer (behind the artwork and the credit) ---- */
.tf-glass {
    position: absolute;
    left: 0;
    right: 0;
    /* From where the curve starts (the swoosh's lowest line) to the bottom. */
    top: calc(var(--hw) * (0.31 - 0.162 * 0.75));
    bottom: 0;
    opacity: 0.25;
    pointer-events: none;
}
.tf-glass-curve {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: calc(var(--hw) * 0.162 * 0.75 + 1px);
    fill: var(--tf-blue-solid);
}
.tf-glass-band {
    position: absolute;
    left: 0;
    right: 0;
    top: calc(var(--hw) * 0.162 * 0.75);
    bottom: 0;
    background:
        radial-gradient(120% 70% at 50% 135%, rgba(96, 165, 250, 0.6) 0%, transparent 60%),
        linear-gradient(180deg, var(--tf-blue-solid) 0%, var(--tf-blue-deep) 100%);
}

/* ---- skyline ---- */
.tf-skyline {
    position: relative;
    height: calc(var(--hw) * 0.31);
}
.tf-hall {
    position: absolute;
    left: 50%;
    bottom: 0;
    transform: translateX(-50%);
    width: var(--hw);
    height: auto;
    /* Blend the artwork's ground into the blue at both ends. */
    -webkit-mask-image:
        linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%),
        linear-gradient(to bottom, #000 0, #000 84%, transparent 96%);
    -webkit-mask-composite: source-in;
    mask-image:
        linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%),
        linear-gradient(to bottom, #000 0, #000 84%, transparent 96%);
    mask-composite: intersect;
}
/* Left layout: the building stands in the bottom-left corner. */
.tf--left .tf-hall {
    left: clamp(10px, 2.2vw, 36px);
    transform: none;
}
.tf-curve {
    position: absolute;
    left: 0;
    right: 0;
    bottom: -1px;
    width: 100%;
    height: calc(var(--hw) * 0.162);
}
.tf-gold { stroke-width: 1; }
.tf-blue { stroke-width: 2.5; }

/* ---- band with the credit ---- */
.tf-band {
    position: relative;
    overflow: hidden;
    /* The bottom room keeps the credit row above the curved swoosh
       (::after), which otherwise draws a line straight through it. */
    padding: 3px 18px 7px;
    text-align: center;
}
/* Lighter blue swoosh along the bottom edge. */
.tf-band::after {
    content: "";
    position: absolute;
    left: -10%;
    right: -10%;
    bottom: -58px;
    height: 60px;
    border-radius: 50%;
    border-top: 3px solid rgba(147, 197, 253, 0.5);
    box-shadow: 0 -10px 40px -10px rgba(147, 197, 253, 0.5);
    pointer-events: none;
}

.tf-credit {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin-top: 0;
    font-size: 0.66rem;
    /* Navy on the light (25%) blue, so it stays readable. */
    color: #0f2a6b;
}
.tf-credit b {
    color: #0b2357;
    font-weight: 800;
}
.tf-credit-line {
    width: 40px;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(15, 42, 107, 0.6));
}
.tf-credit-line:last-child {
    transform: scaleX(-1);
}

/* ---- fit-the-screen pages (same breakpoint as useFitScreen) ----
   The full footer, scaled by the window height: the City Hall artwork
   and spacing shrink on short screens so the dashboard above keeps
   its room and the page needs no scroll. */
@media (min-width: 1100px) and (min-height: 560px) {
    .tf--fit {
        --hw: clamp(91px, 12.25vh, 199px);
        flex: 0 0 auto;
        margin-top: 0;
    }
    .tf--fit .tf-band {
        padding: 2px 18px clamp(5px, 0.6vh, 7px);
    }
    /* Keep the bottom swoosh below the credit row at the smaller padding. */
    .tf--fit .tf-band::after {
        bottom: -58px;
    }
    .tf--fit .tf-credit {
        margin-top: 0;
        font-size: clamp(0.58rem, 1.05vh, 0.64rem);
    }
}

/* Phones: the artwork fills the width; the credit may wrap. */
@media (max-width: 700px) {
    .tf {
        --hw: min(35vw, 199px);
    }
    .tf-credit {
        flex-wrap: wrap;
        font-size: 0.62rem;
    }
    .tf-credit-line {
        display: none;
    }
}
</style>
