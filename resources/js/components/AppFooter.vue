<template>
    <!-- Site footer: City Hall artwork (public/footer-hall.webp, sky cut
         out so it sits on any page background) over a navy band with the
         seals, contacts and the CSD credit. The swooshes are drawn here. -->
    <footer class="tf">
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
            <div class="tf-main">
                <img class="tf-seal" :src="'/zamboanga-seal.png'" alt="City of Zamboanga official seal" width="62" height="62" />
                <div class="tf-sep" aria-hidden="true"></div>
                <div class="tf-info">
                    <div class="tf-social">
                        <a
                            v-for="s in socials"
                            :key="s.label"
                            class="tf-soc"
                            :href="s.href"
                            target="_blank"
                            rel="noopener noreferrer"
                            :aria-label="s.label"
                            :title="s.label"
                        >
                            <v-icon size="12">{{ s.icon }}</v-icon>
                        </a>
                    </div>
                    <a class="tf-line" href="mailto:info@zamboangacity.gov.ph">
                        <v-icon size="12">mdi-email-outline</v-icon>info@zamboangacity.gov.ph
                    </a>
                    <div class="tf-line">
                        <v-icon size="12">mdi-map-marker</v-icon>City Hall, Zamboanga City, Philippines
                    </div>
                    <a class="tf-line" href="tel:+63629913371">
                        <v-icon size="12">mdi-phone-outline</v-icon>(062) 991-3371
                    </a>
                </div>
                <!-- System emblem mirrors the seal on the other side. -->
                <div class="tf-sep" aria-hidden="true"></div>
                <img class="tf-seal tf-logo" :src="'/tms-logo.png'" alt="Transaction Management System emblem" width="62" height="62" />
            </div>

            <div class="tf-rule" aria-hidden="true"></div>
            <div class="tf-legal">
                <span>Terms &amp; Conditions</span>
                <span class="tf-bar" aria-hidden="true">|</span>
                <span>Privacy Policy</span>
            </div>
            <div class="tf-credit">
                <span class="tf-credit-line" aria-hidden="true"></span>
                <span>Developed by <b>City Hall Computer Service Division</b> <span class="tf-office">- Mayor's Office</span></span>
                <span class="tf-credit-line" aria-hidden="true"></span>
            </div>
        </div>
    </footer>
</template>

<script setup>
const edgeGradients = [
    { id: "tf-edge-gold", color: "#F2B33D" },
    { id: "tf-edge-blue", color: "#2563EB" },
];

// Only the verified City Government accounts/links.
const socials = [
    { label: "Facebook", icon: "mdi-facebook", href: "https://www.facebook.com/zambocitygovt/" },
    { label: "Official website", icon: "mdi-web", href: "https://zamboangacity.gov.ph/" },
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
    margin-top: 18px;
    color: #fff;
}

/* ---- skyline ---- */
.tf-skyline {
    position: relative;
    /* Width of the City Hall artwork (1000 x 310); everything below scales
       from it so the swooshes always meet the ground. */
    --hw: clamp(300px, 46vw, 780px);
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
    /* Extra top room so the seal row clears the building; the bottom room
       keeps the credit row above the curved swoosh (::after), which
       otherwise draws a line straight through it. */
    padding: 26px 24px 44px;
    text-align: center;
}
/* Lighter blue swoosh along the bottom edge. */
.tf-band::after {
    content: "";
    position: absolute;
    left: -10%;
    right: -10%;
    bottom: -38px;
    height: 66px;
    border-radius: 50%;
    border-top: 3px solid rgba(96, 165, 250, 0.45);
    box-shadow: 0 -10px 40px -10px rgba(96, 165, 250, 0.5);
    pointer-events: none;
}

.tf-main {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 26px;
}
.tf-seal {
    width: 84px;
    height: 84px;
    border-radius: 50%;
    box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.85), 0 0 14px rgba(147, 197, 253, 0.45);
    flex: 0 0 auto;
}
.tf-logo {
    object-fit: contain;
    background: #fff;
}
.tf-sep {
    align-self: stretch;
    width: 1px;
    background: linear-gradient(180deg, transparent, rgba(255, 255, 255, 0.55), transparent);
}
.tf-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 6px;
    text-align: left;
}
.tf-social {
    display: flex;
    align-self: center;
    gap: 10px;
    margin-bottom: 4px;
}
.tf-soc {
    display: grid;
    place-items: center;
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background: #fff;
    color: var(--tf-navy);
    text-decoration: none;
    box-shadow: 0 0 8px -2px rgba(147, 197, 253, 0.55);
    transition: background-color 0.15s ease, transform 0.15s ease;
}
a.tf-soc:hover {
    background: #BFDBFE;
    transform: translateY(-1px);
}
.tf-line {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    color: #fff;
    text-decoration: none;
    font-size: 0.84rem;
}
a.tf-line:hover {
    color: #BFDBFE;
}
.tf-line .v-icon {
    color: #fff;
}

.tf-rule {
    width: min(340px, 80%);
    height: 1px;
    margin: 14px auto 8px;
    background: linear-gradient(90deg, transparent, rgba(147, 197, 253, 0.7), transparent);
}
.tf-legal {
    display: flex;
    justify-content: center;
    gap: 14px;
    font-size: 0.74rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #93C5FD;
}
.tf-bar {
    opacity: 0.6;
}
.tf-credit {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    /* Clear breathing room between the Terms/Privacy row and this credit. */
    margin-top: 16px;
    font-size: 0.82rem;
    color: rgba(255, 255, 255, 0.9);
}
.tf-credit b {
    color: #fff;
    font-weight: 800;
}
.tf-credit-line {
    width: 80px;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(147, 197, 253, 0.8));
}
.tf-credit-line:last-child {
    transform: scaleX(-1);
}

/* Phones: the two emblems side by side, contacts below them. */
@media (max-width: 700px) {
    .tf-skyline {
        --hw: min(100vw, 520px);
    }
    .tf-main {
        display: grid;
        grid-template-columns: auto auto;
        justify-content: center;
        gap: 9px 15px;
    }
    .tf-sep {
        display: none;
    }
    .tf-seal {
        grid-row: 1;
        width: 64px;
        height: 64px;
    }
    .tf-logo {
        grid-column: 2;
    }
    .tf-info {
        grid-row: 2;
        grid-column: 1 / -1;
        align-items: center;
    }
    .tf-credit {
        flex-wrap: wrap;
        font-size: 0.68rem;
    }
    .tf-credit-line {
        display: none;
    }
}
</style>
