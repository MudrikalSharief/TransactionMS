<template>
    <div
        class="login-shell"
        :class="{ 'hide-cursor': loading && pointer.seen }"
    >
        <!-- Soft blue waves along the corners, as in the reference. -->
        <svg class="waves" viewBox="0 0 1671 941" preserveAspectRatio="none" aria-hidden="true">
            <defs>
                <linearGradient id="wv-top" x1="0" y1="1" x2="1" y2="0">
                    <stop offset="0" stop-color="#5b93e3" />
                    <stop offset="1" stop-color="#a7c8f4" />
                </linearGradient>
                <linearGradient id="wv-corner" x1="1" y1="1" x2="0" y2="0">
                    <stop offset="0" stop-color="#4c88de" />
                    <stop offset="1" stop-color="#9fc2f2" />
                </linearGradient>
            </defs>
            <path d="M0 0 H640 C540 40 410 62 306 102 C192 146 92 204 0 268 Z" fill="#d3e4fb" />
            <path d="M0 0 H510 C436 28 344 48 254 82 C152 120 66 162 0 208 Z" fill="url(#wv-top)" opacity="0.85" />
            <path d="M1671 170 C1566 300 1536 520 1671 700 Z" fill="#e4eefc" opacity="0.8" />
            <path d="M0 941 V878 C300 838 600 900 900 905 C1200 910 1450 860 1671 790 V941 Z" fill="#d7e7fc" />
            <path d="M0 941 V858 C120 848 262 880 382 941 Z" fill="#c4ddfb" />
            <path d="M1671 941 H1250 C1420 920 1560 878 1671 818 Z" fill="url(#wv-corner)" opacity="0.9" />
        </svg>

        <!-- The page is laid out on the reference's own canvas (1671 x 941)
             and scaled to fit the window, so it matches it exactly. -->
        <div class="artboard" :style="{ '--s': scale }">
            <section class="card">
                <h1 class="sr-only">TransactionMS sign in</h1>
                <!-- System emblem on the sign-in screen; the large file only on sharp screens. -->
                <img
                    v-if="mode === 'signin'"
                    class="card-logo"
                    :src="'/tms-logo-128.png'"
                    :srcset="'/tms-logo-128.png 128w, /tms-logo.png 512w'"
                    sizes="104px"
                    alt="Transaction Management System emblem"
                    width="104"
                    height="104"
                    decoding="async"
                />
                <span class="accent" aria-hidden="true"></span>

                <Transition name="swap" mode="out-in">
                    <main v-if="mode === 'signin'" id="panel-signin" key="signin" class="pane">
                        <h2 class="card-title">Sign In</h2>

                        <div v-if="notice" class="notice" role="status" aria-live="polite">
                            <v-icon aria-hidden="true">mdi-check-circle-outline</v-icon>
                            <span>{{ notice }}</span>
                        </div>

                        <div v-if="error" :key="errorKey" class="error" role="alert" aria-live="assertive">
                            <v-icon aria-hidden="true">mdi-alert-circle-outline</v-icon>
                            <span>{{ error }}</span>
                        </div>

                        <form novalidate :aria-busy="loading ? 'true' : 'false'" @submit.prevent="submit">
                            <div class="field">
                                <label for="login-id" class="sr-only">Username</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-account-outline</v-icon></span>
                                    <input
                                        id="login-id"
                                        v-model.trim="loginId"
                                        type="text"
                                        inputmode="text"
                                        name="username"
                                        placeholder="Username"
                                        autocomplete="username"
                                        autocapitalize="none"
                                        spellcheck="false"
                                        :disabled="loading"
                                        required
                                        autofocus
                                    />
                                </div>
                            </div>

                            <div class="field">
                                <label for="login-password" class="sr-only">Password</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-lock-outline</v-icon></span>
                                    <input
                                        id="login-password"
                                        v-model="password"
                                        :type="showPassword ? 'text' : 'password'"
                                        name="current-password"
                                        placeholder="Password"
                                        autocomplete="current-password"
                                        :disabled="loading"
                                        required
                                    />
                                    <button
                                        type="button"
                                        class="toggle"
                                        :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                        :aria-pressed="showPassword ? 'true' : 'false'"
                                        @click="showPassword = !showPassword"
                                    >
                                        <v-icon>{{ showPassword ? "mdi-eye-off-outline" : "mdi-eye-outline" }}</v-icon>
                                    </button>
                                </div>
                            </div>

                            <!-- Where the reference has "Forgot password?" -->
                            <p class="aside-link">
                                <button type="button" class="link" @click="openRegister">Create account</button>
                            </p>

                            <button class="btn btn-main" :class="{ loading }" type="submit" :disabled="!canSubmit">
                                <span v-if="loading" class="spin motion-keep" aria-hidden="true"></span>
                                <span>{{ loading ? "Signing in…" : "Sign in" }}</span>
                            </button>
                        </form>
                    </main>

                    <main v-else id="panel-register" key="register" class="pane">
                        <h2 class="card-title is-small">Create Account</h2>
                        <p class="sub">Choose a username to sign in. An administrator will review your request.</p>

                        <div v-if="regError" :key="errorKey" class="error" role="alert" aria-live="assertive">
                            <v-icon aria-hidden="true">mdi-alert-circle-outline</v-icon>
                            <span>{{ regError }}</span>
                        </div>

                        <!-- Three short steps paged with Back / Continue, so the
                             whole request fits the panel without scrolling. -->
                        <div class="steps">
                            <p class="steps-text" aria-live="polite">Step {{ regStep + 1 }} of 3</p>
                            <span class="steps-track" aria-hidden="true">
                                <i v-for="n in 3" :key="n" :class="{ 'is-on': n - 1 <= regStep }"></i>
                            </span>
                        </div>

                        <h3 class="reg-step-title">{{ REG_STEP_TITLES[regStep] }}</h3>

                        <form
                            novalidate
                            :aria-busy="registering ? 'true' : 'false'"
                            @submit.prevent="regStep < 2 ? nextStep() : register()"
                        >
                            <Transition name="swap" mode="out-in">
                                <div v-if="regStep === 0" key="step-1" class="reg-step">
                                    <div class="field">
                                        <label for="reg-name">Full name</label>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-account-outline</v-icon></span>
                                            <input
                                                id="reg-name"
                                                v-model.trim="reg.name"
                                                type="text"
                                                autocomplete="name"
                                                placeholder="Juan Dela Cruz"
                                                :disabled="registering"
                                                :aria-invalid="fieldErrors.name ? 'true' : 'false'"
                                                required
                                            />
                                        </div>
                                        <p v-if="fieldErrors.name" class="field-error">{{ fieldErrors.name }}</p>
                                    </div>

                                    <div class="field">
                                        <div class="label-row">
                                            <label for="reg-contact">Contact number</label>
                                            <span
                                                class="field-counter"
                                                :class="{ 'is-full': reg.contact_number.length === 11 }"
                                                aria-live="polite"
                                            >{{ reg.contact_number.length }}/11</span>
                                        </div>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-phone-outline</v-icon></span>
                                            <input
                                                id="reg-contact"
                                                v-model="reg.contact_number"
                                                type="tel"
                                                inputmode="numeric"
                                                autocomplete="tel-national"
                                                maxlength="11"
                                                placeholder="09171234567"
                                                :disabled="registering"
                                                :aria-invalid="contactError ? 'true' : 'false'"
                                                required
                                                @input="onContactInput"
                                                @blur="contactTouched = true"
                                            />
                                        </div>
                                        <p v-if="contactError" class="field-error">{{ contactError }}</p>
                                    </div>
                                </div>

                                <div v-else-if="regStep === 1" key="step-2" class="reg-step is-short">
                                    <div class="field">
                                        <label for="reg-username">Create a username</label>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-account-key-outline</v-icon></span>
                                            <input
                                                id="reg-username"
                                                v-model="reg.username"
                                                type="text"
                                                name="username"
                                                autocomplete="username"
                                                autocapitalize="none"
                                                spellcheck="false"
                                                minlength="3"
                                                maxlength="30"
                                                placeholder="e.g. juan.delacruz"
                                                :disabled="registering"
                                                :aria-invalid="usernameProblem || fieldErrors.username ? 'true' : 'false'"
                                                aria-describedby="reg-username-help"
                                                required
                                                @input="onUsernameInput"
                                            />
                                        </div>
                                        <p id="reg-username-help" class="field-note" :class="{ 'is-bad': usernameProblem || fieldErrors.username }">
                                            {{ fieldErrors.username || usernameProblem || 'Your unique sign-in name. Use 3–30 letters, numbers, dots or underscores.' }}
                                        </p>
                                    </div>

                                    <div class="field">
                                        <label for="reg-password">Password</label>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-lock-outline</v-icon></span>
                                            <input
                                                id="reg-password"
                                                v-model="reg.password"
                                                :type="showPassword ? 'text' : 'password'"
                                                autocomplete="new-password"
                                                placeholder="At least 8 characters"
                                                :disabled="registering"
                                                :aria-invalid="fieldErrors.password ? 'true' : 'false'"
                                                required
                                            />
                                            <button
                                                type="button"
                                                class="toggle"
                                                :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                                :aria-pressed="showPassword ? 'true' : 'false'"
                                                @click="showPassword = !showPassword"
                                            >
                                                <v-icon>{{ showPassword ? "mdi-eye-off-outline" : "mdi-eye-outline" }}</v-icon>
                                            </button>
                                        </div>
                                        <p v-if="fieldErrors.password" class="field-error">{{ fieldErrors.password }}</p>
                                    </div>
                                </div>

                                <div v-else key="step-3" class="reg-step is-short">
                                    <div class="field">
                                        <label id="reg-office-label" for="reg-office">Office</label>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-office-building-outline</v-icon></span>
                                            <v-menu
                                                v-model="officeMenuOpen"
                                                :close-on-content-click="false"
                                                location="bottom start"
                                                offset="8"
                                            >
                                                <template #activator="{ props }">
                                                    <button
                                                        v-bind="props"
                                                        id="reg-office"
                                                        type="button"
                                                        class="office-select"
                                                        :disabled="registering || !options.offices.length"
                                                        :aria-invalid="fieldErrors.office_id ? 'true' : 'false'"
                                                        aria-labelledby="reg-office-label"
                                                    >
                                                        <span v-if="selectedOffice" class="office-selected">
                                                            <span class="office-avatar" aria-hidden="true">
                                                                <img v-if="officeIcon(selectedOffice)" :src="officeIcon(selectedOffice)" alt="" />
                                                                <span v-else>{{ officeInitials(selectedOffice) }}</span>
                                                            </span>
                                                            <span class="office-name">{{ selectedOffice.name }}</span>
                                                        </span>
                                                        <span v-else class="office-placeholder">Choose your office</span>
                                                        <v-icon class="office-caret" aria-hidden="true">mdi-chevron-down</v-icon>
                                                    </button>
                                                </template>
                                                <v-card
                                                    class="office-menu-card"
                                                    rounded="lg"
                                                    elevation="8"
                                                    role="listbox"
                                                    aria-labelledby="reg-office-label"
                                                >
                                                    <button
                                                        v-for="o in options.offices"
                                                        :key="o.id"
                                                        type="button"
                                                        class="office-option"
                                                        :class="{ 'is-selected': Number(reg.office_id) === Number(o.id) }"
                                                        role="option"
                                                        :aria-selected="Number(reg.office_id) === Number(o.id) ? 'true' : 'false'"
                                                        @click="chooseOffice(o.id)"
                                                    >
                                                        <span class="office-avatar" aria-hidden="true">
                                                            <img v-if="officeIcon(o)" :src="officeIcon(o)" :alt="`${o.name} icon`" />
                                                            <span v-else>{{ officeInitials(o) }}</span>
                                                        </span>
                                                        <span class="office-option-name">{{ o.name }}</span>
                                                        <v-icon
                                                            v-if="Number(reg.office_id) === Number(o.id)"
                                                            class="office-check"
                                                            size="18"
                                                            aria-hidden="true"
                                                        >mdi-check</v-icon>
                                                    </button>
                                                    <p v-if="!options.offices.length" class="office-empty">No offices available.</p>
                                                </v-card>
                                            </v-menu>
                                        </div>
                                        <p v-if="fieldErrors.office_id" class="field-error">{{ fieldErrors.office_id }}</p>
                                    </div>

                                    <div class="field">
                                        <label for="reg-role">Role</label>
                                        <div class="control">
                                            <span class="chip" aria-hidden="true"><v-icon>mdi-badge-account-horizontal-outline</v-icon></span>
                                            <select
                                                id="reg-role"
                                                v-model="reg.role_id"
                                                :disabled="registering || !options.roles.length"
                                                :aria-invalid="fieldErrors.role_ids ? 'true' : 'false'"
                                                required
                                            >
                                                <option :value="null" disabled>Choose your role</option>
                                                <option v-for="r in options.roles" :key="r.id" :value="r.id">{{ r.name }}</option>
                                            </select>
                                        </div>
                                        <p v-if="fieldErrors.role_ids" class="field-error">{{ fieldErrors.role_ids }}</p>
                                    </div>
                                </div>
                            </Transition>

                            <div class="reg-nav">
                                <button
                                    v-if="regStep > 0"
                                    type="button"
                                    class="btn-ghost"
                                    :disabled="registering"
                                    @click="prevStep"
                                >
                                    <v-icon class="btn-arrow-back" aria-hidden="true">mdi-arrow-left</v-icon>
                                    <span>Back</span>
                                </button>

                                <button
                                    v-if="regStep < 2"
                                    type="button"
                                    class="btn"
                                    :disabled="!stepReady(regStep)"
                                    @click="nextStep"
                                >
                                    <span>Continue</span>
                                </button>

                                <button
                                    v-else
                                    class="btn"
                                    :class="{ loading: registering }"
                                    type="submit"
                                    :disabled="!canRegister"
                                >
                                    <span v-if="registering" class="spin motion-keep" aria-hidden="true"></span>
                                    <span>{{ registering ? "Sending request…" : "Request account" }}</span>
                                </button>
                            </div>
                        </form>
                        <p class="aside-link is-center">
                            Already have an account?
                            <button type="button" class="link" @click="openSignIn">Sign in</button>
                        </p>
                    </main>
                </Transition>
            </section>

            <div class="hero-heading">
                <p class="hero-eyebrow">
                    <span class="hero-line" aria-hidden="true"></span>
                    Monitor City Government
                    <span class="hero-line" aria-hidden="true"></span>
                </p>
                <h2 class="hero-title">Transactions</h2>
                <span class="hero-bar" aria-hidden="true"></span>
            </div>

            <div class="illustration">
                <img
                    class="scene"
                    :src="'/login-scene.jpg'"
                    alt="A clerk reviewing papers, with Payroll, Permits, Approvals, Records, Routing and Tracking around her"
                    width="1000"
                    height="650"
                />

                <!-- The arrows between the modules, redrawn over the picture so
                     they can move: they flow round the cycle (Payroll, Permits,
                     Approvals, Records, Routing, Tracking) at one steady speed
                     (startFlow in the script). -->
                <!-- Approvals, lifted out of the picture and set 30px higher so
                     its sides meet the arrows on the circle. -->
                <img class="chip-approvals" :src="'/login-approvals.png'" alt="" width="280" height="106" />

                <svg class="flow" viewBox="0 0 1671 941" aria-hidden="true">
                    <g v-for="(a, i) in FLOW_ARROWS" :key="i">
                        <path v-if="a.tail" class="arrow-tail" :d="a.tail" />
                        <path :ref="(el) => (flowLines[i] = el)" class="arrow-line" :d="a.line" pathLength="1" />
                    </g>
                </svg>
            </div>

            <!-- Guest tracking: the read-only viewer, no sign-in. -->
            <button
                class="track"
                :class="{ loading: guestLoading }"
                type="button"
                :disabled="loading || guestLoading"
                title="View-only. No account or sign-in needed."
                @click="guestLogin"
            >
                <span class="track-face">
                    <span class="track-icon" aria-hidden="true">
                        <span v-if="guestLoading" class="spin motion-keep"></span>
                        <v-icon v-else>mdi-magnify</v-icon>
                    </span>
                    <span class="track-divider" aria-hidden="true"></span>
                    <span class="track-text">
                        <template v-if="guestLoading">Opening tracker…</template>
                        <template v-else>Track your<br />Transaction</template>
                    </span>
                    <span class="track-go" aria-hidden="true"><v-icon>mdi-arrow-right</v-icon></span>
                </span>
            </button>
        </div>

        <div
            v-if="loading && pointer.seen"
            class="spin-cursor motion-keep"
            :style="{ transform: `translate3d(${pointer.x}px, ${pointer.y}px, 0)` }"
            aria-hidden="true"
        ></div>
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useAuth, homePathFor, userKind } from "@/composables/useAuth";
import { useApi } from "@/composables/useApi";
import { useMotion } from "@/composables/useMotion";
import { officeIcon } from "@/utils/officeIcons";

// Respect the shared motion preference without showing a login toggle.
const { motionEnabled } = useMotion();

const router = useRouter();
const auth = useAuth();
const { api, csrf } = useApi();

// The page is drawn on the reference design's own canvas (1671 x 941) and
// scaled to fit the window, so its proportions always match the design.
const BOARD_W = 1671;
const BOARD_H = 941;
const scale = ref(1);
function fitBoard() {
    scale.value = Math.min(window.innerWidth / BOARD_W, window.innerHeight / BOARD_H);
}
onMounted(() => {
    fitBoard();
    window.addEventListener("resize", fitBoard, { passive: true });
});
onUnmounted(() => window.removeEventListener("resize", fitBoard));

// The flow arrows all lie on one circle round the clerk (design pixels):
// each is an arc of RING between two modules, running clockwise. Angles are
// in degrees with y pointing down (180 = left, 270 = top, 0 = right); each
// arrow lists its start angle, tip angle and the length of the faint dashed
// tail before it (0 where a tail would run into a module).
const RING = { cx: 1080, cy: 600, r: 370 };
const FLOW_ARROWS = [
    [175, 186.5, 20], // up into Payroll
    [200.5, 209.5, 8], // Payroll to Permits
    [230, 242, 20], // Permits to Approvals
    [291, 310, 22], // Approvals to Records
    [330, 338.5, 0], // Records to Routing
    [351.5, 358.5, 0], // Routing to Tracking
].map(([a0, a1, tailLen]) => {
    const { cx, cy, r } = RING;
    const rad = (d) => (d * Math.PI) / 180;
    const at = (d) => [cx + r * Math.cos(rad(d)), cy + r * Math.sin(rad(d))];
    const pt = ([x, y]) => `${x.toFixed(1)} ${y.toFixed(1)}`;
    const arc = (from, to) => `M${pt(at(from))} A${r} ${r} 0 0 1 ${pt(at(to))}`;
    const toDeg = (len) => (len / r) * (180 / Math.PI);

    // Plain lines, no arrowheads.
    return {
        line: arc(a0, a1),
        tail: tailLen ? arc(a0 - toDeg(tailLen), a0) : "",
        span: a1 - a0,
    };
});

// The flow: one steady clock for all six lines, so nothing waits or jumps.
// The lines draw one straight after another (each takes time in proportion
// to its length, so the speed never changes), stay drawn, then clear from
// their tails in the same order, and the cycle repeats. Animations off:
// the lines simply stay drawn.
const FLOW = { draw: 1800, hold: 1400, clear: 1800, rest: 300 }; // ms
const FLOW_MS = FLOW.draw + FLOW.hold + FLOW.clear + FLOW.rest;
const HIDDEN = 1.02; // just past the line's end, so no round-cap dot shows
const FLOW_FRAMES = (() => {
    const total = FLOW_ARROWS.reduce((sum, a) => sum + a.span, 0);
    const clearAt = FLOW.draw + FLOW.hold;
    const t = (ms) => ms / FLOW_MS;
    let before = 0;
    return FLOW_ARROWS.map(({ span }) => {
        const from = before / total;
        const to = (before += span) / total;
        return [
            { offset: 0, strokeDashoffset: HIDDEN },
            { offset: t(FLOW.draw * from), strokeDashoffset: HIDDEN },
            { offset: t(FLOW.draw * to), strokeDashoffset: 0 },
            { offset: t(clearAt + FLOW.clear * from), strokeDashoffset: 0 },
            { offset: t(clearAt + FLOW.clear * to), strokeDashoffset: -HIDDEN },
            { offset: 1, strokeDashoffset: -HIDDEN },
        ];
    });
})();

const flowLines = [];
let flowAnims = [];
function stopFlow() {
    flowAnims.forEach((a) => a.cancel());
    flowAnims = [];
}
function startFlow() {
    stopFlow();
    if (!motionEnabled.value) return;
    flowAnims = FLOW_FRAMES.map((frames, i) => {
        const anim = flowLines[i]?.animate?.(frames, { duration: FLOW_MS, iterations: Infinity });
        // Open on the finished drawing, as in the design, then flow on.
        if (anim) anim.currentTime = FLOW.draw;
        return anim;
    }).filter(Boolean);
}
onMounted(startFlow);
onUnmounted(stopFlow);
watch(motionEnabled, startFlow);

// "signin" or "register" (Create an account), in the same panel.
const mode = ref("signin");
const notice = ref("");

// A username is the only normal sign-in identifier.
const loginId = ref("");
const password = ref("");
const showPassword = ref(false);

const loading = ref(false);
const guestLoading = ref(false);
const error = ref("");
const errorKey = ref(0);

// Spinning cursor while signing in: CSS cursor images can't animate, so the
// native pointer is hidden and a spinner div follows it. Position is tracked
// off-render (plain vars) and only mirrored into reactive state while busy.
const pointer = ref({ x: 0, y: 0, seen: false });
let lastPointer = { x: 0, y: 0, seen: false };

function trackPointer(e) {
    lastPointer = { x: e.clientX, y: e.clientY, seen: true };
    if (loading.value) pointer.value = lastPointer;
}

onMounted(() => window.addEventListener("mousemove", trackPointer, { passive: true }));
onUnmounted(() => window.removeEventListener("mousemove", trackPointer));

watch(loading, (busy) => {
    if (busy) pointer.value = lastPointer;
});

const canSubmit = computed(
    () => !loading.value && !guestLoading.value && loginId.value.trim().length > 0 && password.value.length > 0,
);

async function submit() {
    if (!canSubmit.value) return;
    loading.value = true;
    error.value = "";
    notice.value = "";

    try {
        await auth.login({
            login: loginId.value.trim(),
            password: password.value,
        });

        await auth.init();

        await router.push({ name: "dashboard" });
    } catch (e) {
        const msg = e?.response?.data?.message;
        error.value =
            msg === "Invalid credentials."
                ? "That username and password don't match an account."
                : msg ||
                  e?.response?.data?.errors?.login?.[0] ||
                  "Sign in failed. Please check your details and try again.";
        errorKey.value += 1;
    } finally {
        loading.value = false;
    }
}

// ---- Create an account ----------------------------------------------------

const emptyReg = () => ({
    name: "",
    username: "",
    contact_number: "",
    password: "",
    office_id: null,
    role_id: null,
});
const reg = ref(emptyReg());
const options = ref({ offices: [], roles: [] });
const registering = ref(false);
const regError = ref("");
const fieldErrors = ref({});

// Contact: digits only, 11 max. The counter shows progress; the red state
// appears once they leave the field incomplete.
const contactTouched = ref(false);

const contactProblem = computed(() => {
    const n = String(reg.value.contact_number || "");
    if (!n || n.length === 11) return "";
    return "Enter an 11-digit contact number.";
});
const contactError = computed(
    () => fieldErrors.value.contact_number || (contactTouched.value ? contactProblem.value : ""),
);

const officeMenuOpen = ref(false);
const selectedOffice = computed(
    () => (options.value.offices || []).find((o) => Number(o.id) === Number(reg.value.office_id)) || null,
);

function onContactInput(e) {
    const digits = String(e?.target?.value ?? reg.value.contact_number ?? "")
        .replace(/\D/g, "")
        .slice(0, 11);
    reg.value.contact_number = digits;
    if (e?.target && e.target.value !== digits) e.target.value = digits;
    if (fieldErrors.value.contact_number) {
        fieldErrors.value = { ...fieldErrors.value, contact_number: "" };
    }
}

function officeInitials(office) {
    const code = String(office?.code || "").trim();
    if (code) return code.slice(0, 2).toUpperCase();
    return (
        String(office?.name || "?")
            .trim()
            .split(/\s+/)
            .slice(0, 2)
            .map((part) => part[0] || "")
            .join("")
            .toUpperCase() || "?"
    );
}

function chooseOffice(id) {
    reg.value.office_id = id;
    officeMenuOpen.value = false;
    if (fieldErrors.value.office_id) {
        fieldErrors.value = { ...fieldErrors.value, office_id: "" };
    }
}

// Same format the server enforces (App\Models\User::usernameRules).
const USERNAME_RE = /^[a-z0-9](?:[a-z0-9._]*[a-z0-9])?$/;

// Usernames are lowercase with no spaces; tidy as they type.
function onUsernameInput() {
    reg.value.username = reg.value.username.toLowerCase().replace(/\s+/g, "");
    if (fieldErrors.value.username) fieldErrors.value = { ...fieldErrors.value, username: "" };
}

// Shown once they've typed something that can't be a username.
const usernameProblem = computed(() => {
    const u = reg.value.username;
    if (!u) return "";
    if (u.length < 3) return "Use at least 3 characters.";
    if (!USERNAME_RE.test(u)) return "Use lowercase letters, numbers, dots or underscores; start and end with a letter or number.";
    return "";
});

const canRegister = computed(
    () =>
        !registering.value &&
        reg.value.name &&
        reg.value.username &&
        !usernameProblem.value &&
        reg.value.contact_number.length === 11 &&
        reg.value.password.length >= 8 &&
        reg.value.office_id != null &&
        reg.value.role_id != null,
);

// The request is split into three short steps, paged with Back / Continue, so
// it fits the panel without scrolling. Keys are the server's error keys, so a
// rejected field can send the form back to the step that owns it.
const REG_STEPS = [
    ["name", "contact_number"],
    ["username", "password"],
    ["office_id", "role_ids"],
];
const regStep = ref(0);
const REG_STEP_TITLES = ["Your details", "Create username and password", "Your office and role"];

// A step can advance once its fields are filled in properly.
function stepReady(step) {
    if (step === 0) {
        return Boolean(
            reg.value.name &&
            reg.value.contact_number.length === 11,
        );
    }
    if (step === 1) {
        return Boolean(reg.value.username && !usernameProblem.value && reg.value.password.length >= 8);
    }
    return reg.value.office_id != null && reg.value.role_id != null;
}

function nextStep() {
    officeMenuOpen.value = false;
    if (regStep.value < REG_STEPS.length - 1 && stepReady(regStep.value)) regStep.value += 1;
}

function prevStep() {
    officeMenuOpen.value = false;
    if (regStep.value > 0) regStep.value -= 1;
}

async function openRegister() {
    mode.value = "register";
    error.value = "";
    notice.value = "";
    regError.value = "";
    fieldErrors.value = {};
    contactTouched.value = false;
    officeMenuOpen.value = false;
    regStep.value = 0;
    if (options.value.offices.length) return;
    try {
        const res = await api.get("/api/auth/register/options");
        options.value = { offices: res.data.offices ?? [], roles: res.data.roles ?? [] };
    } catch {
        regError.value = "Could not load offices and roles. Check your connection and try again.";
        errorKey.value += 1;
    }
}

function openSignIn() {
    mode.value = "signin";
    regError.value = "";
    officeMenuOpen.value = false;
    regStep.value = 0;
}

async function register() {
    if (!canRegister.value) return;
    registering.value = true;
    regError.value = "";
    fieldErrors.value = {};

    try {
        await csrf();
        const res = await api.post("/api/auth/register", {
            name: reg.value.name,
            username: reg.value.username,
            contact_number: reg.value.contact_number,
            password: reg.value.password,
            office_id: reg.value.office_id,
            role_ids: [reg.value.role_id],
        });
        // Back to sign in with their new username filled in, and what
        // happens next.
        loginId.value = reg.value.username;
        password.value = "";
        reg.value = emptyReg();
        contactTouched.value = false;
        officeMenuOpen.value = false;
        regStep.value = 0;
        notice.value = res.data?.message || "Account created. You can sign in once an administrator approves it.";
        mode.value = "signin";
    } catch (e) {
        const errs = e?.response?.data?.errors || {};
        fieldErrors.value = Object.fromEntries(
            Object.entries(errs).map(([k, v]) => [k.replace(/\.\d+$/, ""), Array.isArray(v) ? v[0] : v]),
        );
        regError.value = Object.keys(errs).length
            ? "Check the highlighted fields."
            : e?.response?.data?.message || "Could not create the account. Please try again.";
        errorKey.value += 1;
        // Jump back to the step that owns the first rejected field.
        const firstBad = Object.keys(fieldErrors.value)[0];
        const step = REG_STEPS.findIndex((keys) => firstBad && keys.includes(firstBad));
        if (step >= 0) regStep.value = step;
    } finally {
        registering.value = false;
    }
}

// Guest = the read-only viewer account: signs in without a password and
// goes straight to the viewer (tracking) page.
async function guestLogin() {
    if (loading.value || guestLoading.value) return;
    guestLoading.value = true;
    error.value = "";

    try {
        const u = await auth.loginAsGuest();
        // Guests are viewers: open with the welcome animation.
        await router.push(userKind(u) === "viewer" ? "/track/welcome" : homePathFor(u));
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Transaction tracking is not available right now.";
        errorKey.value += 1;
    } finally {
        guestLoading.value = false;
    }
}
</script>

<style scoped>
/* Sizes below are in the reference image's pixels (1671 x 941); the
   artboard is scaled to the window, so everything keeps its proportions. */
.login-shell {
    --blue: #1d56c4;
    --blue-deep: #0b3b8f;
    --blue-soft: #e8f0ff;
    --navy: #0f2552;
    --ink: #1f2a44;
    --muted: #55627d;
    --line: #c9d3e5;
    --danger: #b42318;
    --display: 'Montserrat', 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif;

    position: fixed;
    inset: 0;
    overflow: hidden;
    background: linear-gradient(180deg, #f2f7fe 0%, #e8f1fd 100%);
    color: var(--ink);
    font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
    -webkit-font-smoothing: antialiased;
}
.waves {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
}
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    margin: -1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0 0 0 0);
    white-space: nowrap;
    border: 0;
}

/* Spinning cursor while signing in: the native pointer is hidden and this
   ring follows it (CSS cursor images can't animate, so a real element it is). */
.login-shell.hide-cursor,
.login-shell.hide-cursor * {
    cursor: none;
}
.spin-cursor {
    position: fixed;
    top: 0;
    left: 0;
    width: 26px;
    height: 26px;
    margin: -13px 0 0 -13px;
    pointer-events: none;
    z-index: 9999;
    will-change: transform;
}
.spin-cursor::before {
    content: "";
    position: absolute;
    inset: 0;
    border: 3px solid rgba(29, 86, 196, 0.25);
    border-top-color: var(--blue);
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

/* ---- The artboard ---- */
.artboard {
    position: absolute;
    left: 50%;
    top: 50%;
    width: 1671px;
    height: 941px;
    margin: -470.5px 0 0 -835.5px;
    transform: scale(var(--s, 1));
    transform-origin: center;
}
.artboard > * {
    position: absolute;
}

/* ---- Sign-in card ---- */
.card {
    left: 34px;
    top: 50px;
    width: 586px;
    min-height: 862px;
    /* Contents sit in the middle of the card. */
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 56px 48px 56px 52px;
    border: 2px solid rgba(255, 255, 255, 0.95);
    border-radius: 38px;
    background: rgba(255, 255, 255, 0.55);
    -webkit-backdrop-filter: blur(14px);
    backdrop-filter: blur(14px);
    box-shadow:
        0 0 0 1px rgba(29, 86, 196, 0.05),
        0 24px 60px -20px rgba(30, 80, 170, 0.22);
}
.accent {
    display: block;
    width: 106px;
    height: 7px;
    margin: 0 auto;
    border-radius: 999px;
    background: var(--blue);
}
.card-title {
    margin: 18px 0 44px;
    text-align: center;
    font-family: var(--display);
    font-size: 56px;
    font-weight: 700;
    line-height: 1.15;
    letter-spacing: -0.01em;
    color: var(--navy);
}
.card-title.is-small {
    margin-bottom: 10px;
    font-size: 46px;
}
/* System emblem in the card's upper-left corner on the sign-in screen: a
   white medallion with the Sign In button's blue gradient as its ring,
   lifted like the white chips in the artwork. */
.card-logo {
    position: absolute;
    top: 30px;
    left: 30px;
    display: block;
    box-sizing: content-box;
    width: 83px;
    height: 83px;
    padding: 5px;
    border: 3px solid transparent;
    border-radius: 50%;
    object-fit: contain;
    background:
        linear-gradient(#fff, #fff) padding-box,
        linear-gradient(135deg, var(--blue), var(--blue-deep)) border-box;
    box-shadow:
        0 0 0 5px rgba(255, 255, 255, 0.7),
        0 13px 24px -10px rgba(29, 86, 196, 0.45);
}
.sub {
    margin: 0 0 20px;
    text-align: center;
    font-size: 19px;
    line-height: 1.45;
    color: var(--muted);
}

/* Switching between sign in and create account. */
.swap-enter-active,
.swap-leave-active {
    transition: opacity 0.2s ease, transform 0.24s cubic-bezier(0.2, 0.8, 0.2, 1);
}
.swap-enter-from {
    opacity: 0;
    transform: translateY(8px);
}
.swap-leave-to {
    opacity: 0;
    transform: translateY(-6px);
}

/* ---- Messages ---- */
.error,
.notice {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin: -24px 0 22px;
    padding: 14px 18px;
    border-radius: 12px;
    font-size: 18px;
    font-weight: 500;
    line-height: 1.4;
}
.error {
    background: #fdf0ef;
    color: var(--danger);
    box-shadow: inset 4px 0 0 var(--danger);
}
.notice {
    background: #ebf7ef;
    color: #1d6b3c;
    box-shadow: inset 4px 0 0 #2f9e5b;
}
.error .v-icon,
.notice .v-icon {
    flex: none;
    font-size: 26px;
}
#panel-register .error {
    margin-top: 0;
}

/* ---- Fields ---- */
.field {
    min-width: 0;
    margin-bottom: 22px;
}
.field label:not(.sr-only) {
    display: block;
    margin: 0 0 8px;
    font-size: 19px;
    font-weight: 600;
    color: var(--ink);
}
.label-row {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    gap: 8px;
    margin-bottom: 8px;
}
.label-row label {
    margin-bottom: 0 !important;
}
.field-counter {
    font-size: 16px;
    font-weight: 600;
    font-variant-numeric: tabular-nums;
    color: var(--muted);
}
.field-counter.is-full {
    color: #1d6b3c;
}
.control {
    position: relative;
}
.chip {
    position: absolute;
    left: 30px;
    top: 50%;
    transform: translateY(-50%);
    display: grid;
    place-items: center;
    color: var(--ink);
    pointer-events: none;
    transition: color 0.18s ease;
}
.chip .v-icon {
    font-size: 36px;
}
.control input,
.control select,
.control .office-select {
    width: 100%;
    height: 70px;
    padding: 0 22px 0 98px;
    border: 2px solid var(--line);
    border-radius: 14px;
    background-color: rgba(247, 249, 253, 0.85);
    color: var(--ink);
    font: inherit;
    font-size: 22px;
    text-overflow: ellipsis;
    transition: border-color 0.18s ease, box-shadow 0.18s ease, background-color 0.18s ease;
}
.control:has(.toggle) input {
    padding-right: 76px;
}
.control input::placeholder {
    color: var(--ink);
    opacity: 1;
}
.control input:hover:not(:disabled),
.control select:hover:not(:disabled),
.control .office-select:hover:not(:disabled) {
    border-color: #a5b6d4;
}
.control input:focus,
.control select:focus,
.control .office-select:focus {
    outline: none;
    border-color: var(--blue);
    background-color: #ffffff;
    box-shadow: 0 0 0 5px rgba(29, 86, 196, 0.13);
}
.control:focus-within .chip {
    color: var(--blue);
}
.control input:disabled,
.control select:disabled,
.control .office-select:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}
.control input[aria-invalid="true"],
.control select[aria-invalid="true"],
.control .office-select[aria-invalid="true"] {
    border-color: var(--danger);
}
.control:has([aria-invalid="true"]) .chip {
    color: var(--danger);
}
.control select {
    padding-right: 48px;
    appearance: none;
    cursor: pointer;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='10' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' fill='none' stroke='%231f2a44' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 20px center;
}
.control input:-webkit-autofill,
.control input:-webkit-autofill:hover,
.control input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 100px #f7f9fd inset !important;
    -webkit-text-fill-color: var(--ink) !important;
    caret-color: var(--ink) !important;
    transition: background-color 5000s ease-in-out 0s !important;
}
.toggle {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    border: 0;
    border-radius: 12px;
    background: none;
    color: var(--ink);
    cursor: pointer;
    transition: background 0.15s ease, color 0.15s ease;
}
.toggle:hover {
    background: var(--blue-soft);
    color: var(--blue);
}
.toggle:focus-visible {
    outline: 3px solid rgba(29, 86, 196, 0.35);
}
.toggle .v-icon {
    font-size: 36px;
}
.field-error,
.field-note {
    margin: 8px 2px 0;
    font-size: 16px;
    line-height: 1.4;
}
.field-error {
    font-weight: 600;
    color: var(--danger);
}
.field-note {
    margin-bottom: 16px;
    color: var(--muted);
}
.field-note.is-bad {
    font-weight: 600;
    color: var(--danger);
}

/* Office picker: custom list so each option can show its own icon. */
.control .office-select {
    display: flex;
    align-items: center;
    gap: 12px;
    padding-right: 48px;
    text-align: left;
    cursor: pointer;
}
.office-selected {
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 0;
}
.office-avatar {
    display: grid;
    place-items: center;
    flex: none;
    width: 30px;
    height: 30px;
    overflow: hidden;
    border-radius: 50%;
    background: var(--blue-soft);
    color: var(--blue);
    font-size: 12px;
    font-weight: 800;
    line-height: 1;
}
.office-avatar img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
}
.office-name,
.office-option-name {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.office-name {
    font-weight: 600;
}
.office-placeholder {
    color: var(--ink);
}
.office-caret {
    flex: none;
    margin-left: auto;
    color: var(--ink);
    pointer-events: none;
}
/* The menu opens outside the scaled artboard, so normal sizes here. */
.office-menu-card {
    width: min(420px, calc(100vw - 40px));
    max-height: 300px;
    overflow-y: auto;
    padding: 6px;
    border: 1px solid #dbe4f2;
    background: #ffffff;
}
.office-option {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    padding: 8px 10px;
    border: 0;
    border-radius: 10px;
    background: transparent;
    color: var(--ink);
    font: inherit;
    font-size: 14px;
    font-weight: 600;
    text-align: left;
    cursor: pointer;
}
.office-option .office-avatar {
    width: 26px;
    height: 26px;
    font-size: 10.5px;
}
.office-option:hover {
    background: #f1f5fd;
}
.office-option.is-selected {
    background: var(--blue-soft);
}
.office-option-name {
    flex: 1;
    min-width: 0;
}
.office-check {
    flex: none;
    color: var(--blue);
}
.office-empty {
    margin: 0;
    padding: 12px;
    font-size: 13px;
    color: var(--muted);
}

/* ---- Create account steps ---- */
.steps {
    display: flex;
    align-items: center;
    gap: 16px;
    margin: 0 0 14px;
}
.steps-text {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
    white-space: nowrap;
    color: var(--muted);
}
.steps-track {
    display: flex;
    flex: 1;
    gap: 6px;
}
.steps-track i {
    flex: 1;
    height: 5px;
    border-radius: 999px;
    background: #d6dfee;
    transition: background 0.3s ease;
}
.steps-track i.is-on {
    background: var(--blue);
}
.reg-step-title {
    margin: 0 0 14px;
    font-size: 21px;
    font-weight: 700;
    color: var(--navy);
}
.reg-nav {
    display: flex;
    gap: 12px;
}
.reg-step.is-short + .reg-nav {
    margin-top: 10px;
}
.reg-nav .btn {
    flex: 1;
}

/* "Create account" sits where the reference has "Forgot password?". */
.aside-link {
    margin: 8px 6px 26px 0;
    font-size: 22px;
    color: var(--muted);
    text-align: right;
}
.aside-link.is-center {
    margin: 20px 0 0;
    font-size: 19px;
    text-align: center;
}
.link {
    border: 0;
    padding: 0;
    background: none;
    font: inherit;
    color: #1e4fb9;
    text-decoration: underline;
    text-underline-offset: 3px;
    cursor: pointer;
}
.link:hover {
    color: var(--blue-deep);
}
.link:focus-visible {
    outline: 3px solid rgba(29, 86, 196, 0.35);
    outline-offset: 2px;
    border-radius: 4px;
}

/* ---- Buttons: deep blue pill ---- */
.btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 26px;
    width: 100%;
    height: 70px;
    border: 0;
    border-radius: 999px;
    background: linear-gradient(90deg, #1656c6 0%, var(--blue-deep) 100%);
    color: #ffffff;
    font-family: var(--display);
    font-size: 27px;
    font-weight: 700;
    letter-spacing: 0.03em;
    text-transform: uppercase;
    cursor: pointer;
    box-shadow: 0 16px 28px -14px rgba(11, 59, 143, 0.75);
    transition: filter 0.2s ease, box-shadow 0.2s ease;
}
.btn-main {
    width: calc(100% + 5px);
}
.btn:hover:not(:disabled) {
    filter: brightness(1.08);
}
/* Stays the full blue of the design while the fields are empty. */
.btn:disabled {
    cursor: not-allowed;
}
.btn.loading {
    filter: none;
    cursor: progress;
}
.btn:focus-visible {
    outline: 4px solid rgba(29, 86, 196, 0.4);
    outline-offset: 4px;
}
.btn-ghost {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    height: 70px;
    padding: 0 26px;
    border: 2px solid var(--line);
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.85);
    color: var(--navy);
    font-family: var(--display);
    font-size: 20px;
    font-weight: 700;
    letter-spacing: 0.03em;
    text-transform: uppercase;
    cursor: pointer;
}
.btn-ghost:hover:not(:disabled) {
    background: #ffffff;
}
.btn-ghost:disabled {
    opacity: 0.55;
    cursor: not-allowed;
}
.btn-ghost .v-icon {
    font-size: 26px;
}

/* One shared right edge avoids shrink-to-fit flex differences between browsers. */
.hero-heading {
    right: 50px;
    top: 66px;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    width: max-content;
    gap: 3px;
}
.hero-eyebrow {
    width: max-content;
    display: flex;
    align-items: center;
    gap: 14px;
    margin: 0;
    font-family: var(--display);
    font-size: 25.3px;
    font-weight: 500;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    white-space: nowrap;
    color: #3b4565;
}
.hero-line {
    flex: 0 0 70px;
    height: 2px;
    background: #3b4565;
}
.hero-line:last-child {
    display: none;
}
.hero-title {
    transform: translateX(20px);
    margin: 0;
    font-family: var(--display);
    font-size: 66.7px;
    font-weight: 800;
    line-height: 1;
    letter-spacing: -0.01em;
    text-align: right;
    text-transform: uppercase;
    color: #0e3a8c;
}
.hero-bar {
    margin-top: 5px;
    width: 126px;
    height: 5px;
    border-radius: 999px;
    background: #1a5fd0;
}

/* Scale the artwork and arrow overlays together, excluding the tracking button. */
.illustration {
    inset: 0;
    transform: scale(0.77);
    transform-origin: 1100px 550px;
    pointer-events: none;
}
.illustration > * {
    position: absolute;
}

/* ---- Scene (cut from the reference), edges faded into the page ---- */
.scene {
    left: 600px;
    top: 230px;
    width: 1000px;
    height: 650px;
    -webkit-mask-image:
        linear-gradient(90deg, transparent 0, #000 3%, #000 97%, transparent 100%),
        linear-gradient(180deg, transparent 0, #000 3.5%, #000 97.5%, transparent 100%);
    -webkit-mask-composite: source-in;
    mask-image:
        linear-gradient(90deg, transparent 0, #000 3%, #000 97%, transparent 100%),
        linear-gradient(180deg, transparent 0, #000 3.5%, #000 97.5%, transparent 100%);
    mask-composite: intersect;
}

/* Approvals chip: its original spot in the picture is 914, 250. */
.chip-approvals {
    z-index: 1;
    left: 914px;
    top: 220px;
    width: 280px;
    height: 106px;
}

/* ---- Flow arrows over the scene ---- */
.flow {
    left: 0;
    top: 0;
    width: 1671px;
    height: 941px;
    overflow: visible;
    pointer-events: none;
}
.arrow-tail {
    fill: none;
    stroke: #8ec3f3;
    stroke-width: 2.4;
    stroke-linecap: round;
    stroke-dasharray: 3 5;
}
/* One dash the length of the line, then a gap longer than the line, so
   moving the offset draws the line from its tail (startFlow) or clears it. */
.arrow-line {
    fill: none;
    stroke: #0b4fc9;
    stroke-width: 3.6;
    stroke-linecap: round;
    stroke-dasharray: 1 1.1;
    stroke-dashoffset: 0;
}

/* ---- Track your Transaction: the slanted blue tab ---- */
.track {
    left: 1214px;
    top: 663.4px;
    width: 440px;
    height: 88px;
    padding: 0;
    border: 2px solid rgba(29, 86, 196, 0.35);
    border-radius: 16px;
    /* Light blue at 15% opacity; the text turns navy so it stays readable. */
    background: rgba(77, 156, 255, 0.15);
    -webkit-backdrop-filter: blur(6px);
    backdrop-filter: blur(6px);
    color: #0e3a8c;
    font: inherit;
    cursor: pointer;
    transform: skewX(-19deg);
    box-shadow: 0 0 0 0 rgba(110, 180, 255, 0);
    transition:
        background 0.25s ease,
        border-color 0.25s ease,
        box-shadow 0.25s ease;
}
/* Hover: the border and background light up in a light-blue glow. */
.track:hover:not(:disabled) {
    border-color: #8cc4ff;
    background: rgba(110, 180, 255, 0.26);
    box-shadow:
        0 0 0 2px rgba(140, 196, 255, 0.55),
        0 0 26px 6px rgba(110, 180, 255, 0.55),
        inset 0 0 18px rgba(140, 196, 255, 0.45);
}
.track .spin {
    border-color: rgba(14, 58, 140, 0.25);
    border-top-color: #0e3a8c;
}
.track:disabled {
    opacity: 0.8;
    cursor: not-allowed;
}
.track:focus-visible {
    outline: 4px solid rgba(29, 86, 196, 0.45);
    outline-offset: 4px;
}
.track-face {
    display: flex;
    align-items: center;
    height: 100%;
    padding: 0 18px 0 46px;
    transform: skewX(19deg);
}
.track-icon {
    display: grid;
    place-items: center;
    width: 56px;
}
.track-icon .v-icon {
    font-size: 58px;
}
.track-divider {
    width: 2.5px;
    height: 52px;
    margin: 0 26px 0 20px;
    background: rgba(14, 58, 140, 0.45);
}
.track-text {
    flex: 1;
    font-family: var(--display);
    font-size: 29px;
    font-weight: 700;
    line-height: 1.1;
    text-align: left;
}
.track-go {
    display: grid;
    place-items: center;
    width: 70px;
    height: 54px;
    border-radius: 10px;
    background: var(--blue);
    color: #ffffff;
    transform: skewX(-19deg);
}
.track-go .v-icon {
    font-size: 36px;
    transform: skewX(19deg);
    transition: transform 0.2s ease;
}
.track:hover:not(:disabled) .track-go .v-icon {
    transform: skewX(19deg) translateX(4px);
}

.spin {
    border-color: rgba(14, 58, 140, 0.25);
    border-top-color: #0e3a8c;
}
@keyframes spin {
    to { transform: rotate(360deg); }
}

/* ---- Phones and narrow windows: the card, then the tracking tab ---- */
@media (max-width: 900px) {
    .login-shell {
        overflow: auto;
    }
    .artboard {
        position: relative;
        left: auto;
        top: auto;
        display: grid;
        gap: 22px;
        width: auto;
        max-width: 480px;
        height: auto;
        min-height: 100%;
        margin: 0 auto;
        padding: 56px 16px 28px;
        align-content: center;
        transform: none;
    }
    .artboard > * {
        position: static;
    }
    .hero-heading,
    .illustration {
        display: none;
    }
    .card {
        width: auto;
        min-height: 0;
        padding: 30px 22px 26px;
        border-radius: 24px;
    }
    .accent {
        width: 72px;
        height: 6px;
    }
    .card-title {
        margin: 10px 0 24px;
        font-size: 36px;
    }
    .card-title.is-small {
        font-size: 30px;
    }
    .card {
        position: relative;
        left: auto;
        top: auto;
    }
    /* Room above the title for the corner emblem. */
    .card:has(.card-logo) {
        padding-top: 70px;
    }
    .card-logo {
        position: absolute;
        top: 16px;
        left: 16px;
        width: 58px;
        height: 58px;
        padding: 3px;
    }
    .sub,
    .field label:not(.sr-only),
    .aside-link.is-center {
        font-size: 14.5px;
    }
    .control input,
    .control select,
    .control .office-select {
        height: 54px;
        padding-left: 52px;
        font-size: 16px;
    }
    .chip {
        left: 16px;
    }
    .chip .v-icon,
    .toggle .v-icon {
        font-size: 24px;
    }
    .toggle {
        width: 40px;
        height: 40px;
    }
    .aside-link {
        margin: 2px 2px 16px 0;
        font-size: 15px;
    }
    .btn,
    .btn-ghost {
        height: 54px;
        font-size: 17px;
    }
    .btn-main {
        width: 100%;
    }
    .steps-text,
    .field-counter,
    .field-error,
    .field-note {
        font-size: 13px;
    }
    .reg-step-title {
        font-size: 16px;
    }
    .error,
    .notice {
        margin-top: 0;
        font-size: 14px;
    }
    .track {
        width: calc(100% - 24px);
        height: 72px;
        margin: 0 auto;
    }
    .track-face {
        justify-content: center;
        padding: 0 14px 0 26px;
    }
    .track-icon .v-icon {
        font-size: 36px;
    }
    .track-divider {
        height: 38px;
        margin: 0 16px 0 10px;
    }
    .track-text {
        flex: none;
        font-size: 19px;
    }
    .track-go {
        width: 52px;
        height: 42px;
        margin-left: 16px;
    }
    .track-go .v-icon {
        font-size: 26px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .control input,
    .control select,
    .btn,
    .track,
    .steps-track i,
    .swap-enter-active,
    .swap-leave-active {
        transition: none !important;
    }
}
</style>
