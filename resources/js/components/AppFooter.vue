<template>
    <!-- Site footer: City Hall skyline over a navy band with the seal,
         contacts and the CSD credit. The skyline is drawn here (left half,
         mirrored) so it stays sharp and follows light/dark mode. -->
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

            <svg class="tf-hall" viewBox="0 0 1100 260" preserveAspectRatio="xMidYMax meet">
                <g v-for="side in sides" :key="side" :transform="side">
                    <!-- palms and shrubs -->
                    <g v-for="p in palms" :key="p.x" :transform="`translate(${p.x} ${p.top})`">
                        <path class="sil" :d="`M-3 ${p.h} Q2 ${p.h / 2} 0 0 L4 0 Q7 ${p.h / 2} 3 ${p.h} Z`" />
                        <ellipse
                            v-for="a in fronds"
                            :key="a"
                            class="sil"
                            :rx="p.r"
                            ry="5.5"
                            :transform="`rotate(${a}) translate(${p.r - 4} 0)`"
                        />
                    </g>
                    <circle v-for="(b, i) in shrubs" :key="`b${i}`" class="sil" :cx="b[0]" :cy="b[1]" :r="b[2]" />

                    <!-- end pavilion -->
                    <rect class="sil" x="170" y="165" width="80" height="85" />
                    <path class="sil" d="M182 166 C182 150 196 142 210 142 C224 142 238 150 238 166 Z" />
                    <rect class="sil" x="208" y="126" width="4" height="18" />
                    <circle class="sil" cx="210" cy="124" r="4" />
                    <rect class="sil" x="166" y="160" width="88" height="7" />
                    <path class="win" d="M199 238 v-30 a11 11 0 0 1 22 0 v30 z" />
                    <path class="mul" d="M210 196 v42 M199 214 h22 M199 226 h22" />

                    <!-- wing with balustrade and arched windows -->
                    <rect class="sil" x="250" y="186" width="180" height="64" />
                    <rect class="sil" x="246" y="180" width="188" height="8" />
                    <line class="rail" x1="254" y1="194" x2="426" y2="194" />
                    <g v-for="x in [290, 340, 390]" :key="x">
                        <path class="win" :d="`M${x - 11} 240 v-24 a11 11 0 0 1 22 0 v24 z`" />
                        <path class="mul" :d="`M${x} 205 v35 M${x - 11} 222 h22 M${x - 11} 231 h22`" />
                    </g>

                    <!-- tower beside the centre block -->
                    <rect class="sil" x="430" y="148" width="42" height="102" />
                    <rect class="sil" x="426" y="142" width="50" height="8" />
                    <rect class="sil" x="447" y="126" width="8" height="18" />
                    <circle class="sil" cx="451" cy="123" r="5" />
                    <rect class="win" x="440" y="176" width="22" height="34" />
                    <path class="mul" d="M451 176 v34 M440 187 h22 M440 199 h22" />
                    <line class="rail" x1="434" y1="160" x2="468" y2="160" />
                </g>

                <!-- centre block: flag, dome, clock, portico -->
                <line class="pole" x1="550" y1="6" x2="550" y2="64" />
                <path class="sil" d="M552 8 h30 l-8 9 l8 9 h-30 z" />
                <rect class="sil" x="546" y="58" width="8" height="10" />
                <path class="sil" d="M506 122 C506 88 530 68 550 66 C570 68 594 88 594 122 Z" />
                <rect class="sil" x="496" y="118" width="108" height="16" />
                <circle class="win" cx="550" cy="100" r="9" />
                <rect class="sil" x="470" y="132" width="160" height="118" />
                <rect class="sil" x="460" y="130" width="180" height="10" />
                <text class="hall-name" x="550" y="164" text-anchor="middle">ZAMBOANGA CITY HALL</text>
                <rect class="win" x="478" y="170" width="144" height="5" />
                <rect v-for="x in columns" :key="x" class="win" :x="x" y="178" width="10" height="62" />
                <path class="win" d="M541 240 v-26 a9 9 0 0 1 18 0 v26 z" />
                <rect class="win" x="474" y="240" width="152" height="4" />
                <rect class="sil" x="140" y="246" width="820" height="14" />
            </svg>
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
                <span>Developed by <b>Computer Services Division · Mayor's Office</b></span>
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

// Left half of the skyline; the right half is the same group mirrored.
const sides = [undefined, "translate(1100 0) scale(-1 1)"];
const palms = [
    { x: 58, top: 150, h: 100, r: 30 },
    { x: 118, top: 128, h: 122, r: 38 },
];
const fronds = [-170, -140, -110, -80, -50, -20, 10];
const shrubs = [
    [20, 242, 16], [44, 232, 20], [78, 238, 18], [104, 228, 22], [138, 236, 18], [160, 242, 14],
];
const columns = [488, 508, 528, 562, 582, 602];

// Only the verified City Government accounts/links.
const socials = [
    { label: "Facebook", icon: "mdi-facebook", href: "https://www.facebook.com/zambocitygovt/" },
    { label: "Official website", icon: "mdi-web", href: "https://zamboangacity.gov.ph/" },
];
</script>

<style scoped>
.tf {
    --tf-navy: #0B2B66;
    --tf-deep: #071D47;
    --tf-gold: #F2B33D;
    --tf-blue: #2563EB;
    /* Windows and lettering stay light in both themes. */
    --tf-win: #F5F8FC;
    position: relative;
    z-index: 1;
    margin-top: 18px;
    color: #fff;
}

/* ---- skyline ---- */
.tf-skyline {
    position: relative;
    height: clamp(80px, 8.6vw, 128px);
}
.tf-hall {
    position: absolute;
    left: 50%;
    bottom: 0;
    transform: translateX(-50%);
    width: min(605px, 96%);
    height: 100%;
}
.tf-curve {
    position: absolute;
    left: 0;
    right: 0;
    bottom: -1px;
    width: 100%;
    height: clamp(31px, 3.3vw, 53px);
}
.tf-navy { fill: var(--tf-navy); }
.tf-gold { stroke-width: 2; }
.tf-blue { stroke-width: 6; }
.sil { fill: var(--tf-navy); }
.win { fill: var(--tf-win); }
.mul { stroke: var(--tf-navy); stroke-width: 2; fill: none; }
.rail { stroke: var(--tf-win); stroke-width: 3; stroke-dasharray: 2 3; }
.pole { stroke: var(--tf-navy); stroke-width: 3; }
.hall-name {
    fill: var(--tf-win);
    font: 800 12.5px Inter, 'Segoe UI', sans-serif;
    letter-spacing: 0.08em;
}

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
    padding: 30px 24px 40px;
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
    gap: 15px;
}
.tf-seal {
    width: 62px;
    height: 62px;
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
    gap: 3px;
    text-align: left;
}
.tf-social {
    display: flex;
    align-self: center;
    gap: 7px;
    margin-bottom: 3px;
}
.tf-soc {
    display: grid;
    place-items: center;
    width: 22px;
    height: 22px;
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
    gap: 6px;
    color: #fff;
    text-decoration: none;
    font-size: 0.72rem;
}
a.tf-line:hover {
    color: #BFDBFE;
}
.tf-line .v-icon {
    color: #fff;
}

.tf-rule {
    width: min(275px, 80%);
    height: 1px;
    margin: 10px auto 6px;
    background: linear-gradient(90deg, transparent, rgba(147, 197, 253, 0.7), transparent);
}
.tf-legal {
    display: flex;
    justify-content: center;
    gap: 10px;
    font-size: 0.66rem;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.85);
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
    font-size: 0.72rem;
    color: rgba(255, 255, 255, 0.9);
}
.tf-credit b {
    color: #fff;
    font-weight: 800;
}
.tf-credit-line {
    width: 50px;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(147, 197, 253, 0.8));
}
.tf-credit-line:last-child {
    transform: scaleX(-1);
}

/* Phones: the two emblems side by side, contacts below them. */
@media (max-width: 700px) {
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
        width: 53px;
        height: 53px;
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
