<template>
    <!-- Site footer: City Hall artwork (public/footer-hall.webp, sky cut
         out so it sits on any page background) over a navy band with the
         CSD credit. The swooshes are drawn here. -->
    <!-- Pages that fit the screen (dashboards on desktop) get the same
         footer, sized to the window height so the page never scrolls. -->
    <footer class="tf" :class="{ 'tf--fit': fit }">
        <div class="tf-skyline" aria-hidden="true">
            <svg class="tf-curve" viewBox="0 0 1600 120" preserveAspectRatio="none">
                <!-- Gold and blue swooshes, strong at the edges, fading
                     out behind the building. -->
                <defs>
                    <linearGradient v-for="g in edgeGradients" :id="g.id" :key="g.id" x1="0" x2="1" y1="0" y2="0">
                        <stop offset="0" :stop-color="g.color" stop-opacity="1" />
                        <stop offset="0.32" :stop-color="g.color" stop-opacity="0" />
                        <stop offset="0.68" :stop-color="g.color" stop-opacity="0" />
                        <stop offset="1" :stop-color="g.color" stop-opacity="1" />
                    </linearGradient>
                </defs>
                <path class="tf-gold" d="M0 10 C520 78 1080 78 1600 10" fill="none" stroke="url(#tf-edge-gold)" vector-effect="non-scaling-stroke" />
                <path class="tf-blue" d="M0 20 C520 88 1080 88 1600 20" fill="none" stroke="url(#tf-edge-blue)" vector-effect="non-scaling-stroke" />
                <path class="tf-navy" d="M0 30 C520 98 1080 98 1600 30 L1600 120 L0 120 Z" />
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
defineProps({
    fit: { type: Boolean, default: false },
});

const edgeGradients = [
    { id: "tf-edge-gold", color: "#F2B33D" },
    { id: "tf-edge-blue", color: "#2563EB" },
];
</script>

<style scoped>
.tf {
    --tf-navy: #002D70;
    --tf-deep: #002056;
    --tf-gold: #F2B33D;
    --tf-blue: #2563EB;
    position: relative;
    z-index: 1;
    margin-top: 15px;
    color: #fff;
}

/* ---- skyline ---- */
.tf-skyline {
    position: relative;
    /* Width of the City Hall artwork (1000 x 310); everything below scales
       from it so the swooshes always meet the ground. */
    --hw: clamp(231px, calc(50.2vw - 97px), 755px);
    height: calc(var(--hw) * 0.31);
}
.tf-hall {
    position: absolute;
    left: 50%;
    bottom: 0;
    transform: translateX(-50%);
    width: var(--hw);
    height: auto;
    /* Blend the artwork's ground into the swoosh's navy at both ends. */
    -webkit-mask-image:
        linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%),
        linear-gradient(to bottom, #000 0, #000 84%, transparent 96%);
    -webkit-mask-composite: source-in;
    mask-image:
        linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%),
        linear-gradient(to bottom, #000 0, #000 84%, transparent 96%);
    mask-composite: intersect;
}
.tf-curve {
    position: absolute;
    left: 0;
    right: 0;
    bottom: -1px;
    width: 100%;
    height: calc(var(--hw) * 0.162);
}
.tf-navy { fill: var(--tf-navy); }
.tf-gold { stroke-width: 2; }
.tf-blue { stroke-width: 6; }

/* ---- navy band ---- */
.tf-band {
    position: relative;
    overflow: hidden;
    background:
        radial-gradient(120% 70% at 50% 135%, rgba(37, 99, 235, 0.55) 0%, transparent 60%),
        linear-gradient(180deg, var(--tf-navy) 0%, var(--tf-deep) 100%);
    /* The bottom room keeps the credit row above the curved swoosh
       (::after), which otherwise draws a line straight through it. */
    padding: 6px 18px 14px;
    text-align: center;
}
/* Lighter blue swoosh along the bottom edge. */
.tf-band::after {
    content: "";
    position: absolute;
    left: -10%;
    right: -10%;
    bottom: -52px;
    height: 60px;
    border-radius: 50%;
    border-top: 3px solid rgba(96, 165, 250, 0.45);
    box-shadow: 0 -10px 40px -10px rgba(96, 165, 250, 0.5);
    pointer-events: none;
}


.tf-credit {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin-top: 6px;
    font-size: 0.74rem;
    color: rgba(255, 255, 255, 0.9);
}
.tf-credit b {
    color: #fff;
    font-weight: 800;
}
.tf-credit-line {
    width: 60px;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(147, 197, 253, 0.8));
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
        flex: 0 0 auto;
        margin-top: 0;
    }
    .tf--fit .tf-skyline {
        --hw: clamp(170px, calc(35vh - 97px), 471px);
    }
    .tf--fit .tf-band {
        padding: clamp(2px, 0.3vh, 5px) 18px clamp(6px, 0.8vh, 10px);
    }
    /* Keep the bottom swoosh below the credit row at the smaller padding. */
    .tf--fit .tf-band::after {
        bottom: -58px;
    }
    .tf--fit .tf-credit {
        margin-top: clamp(0px, 0.2vh, 2px);
        font-size: clamp(0.58rem, 1.05vh, 0.66rem);
    }
}

/* Phones: the artwork fills the width; the credit may wrap. */
@media (max-width: 700px) {
    .tf-skyline {
        --hw: max(231px, calc(min(100vw, 568px) - 97px));
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
