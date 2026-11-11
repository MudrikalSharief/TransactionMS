<template>
    <div
        class="login-shell"
        :class="{ 'hide-cursor': loading && pointer.seen }"
    >
        <div class="card">
            <section class="side">
                <!-- Page name for screen readers only; nothing shows above
                     the form. -->
                <h1 class="sr-only">TransactionMS sign in</h1>

                <Transition name="swap" mode="out-in">
                    <main v-if="mode === 'signin'" id="panel-signin" key="signin" class="pane">
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
                                <label for="login-id">Username</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-account-outline</v-icon></span>
                                    <input
                                        id="login-id"
                                        v-model.trim="loginId"
                                        type="text"
                                        inputmode="text"
                                        name="username"
                                        placeholder="Enter your username"
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
                                <label for="login-password">Password</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-lock-outline</v-icon></span>
                                    <input
                                        id="login-password"
                                        v-model="password"
                                        :type="showPassword ? 'text' : 'password'"
                                        name="current-password"
                                        placeholder="Enter your password"
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

                            <button class="btn" :class="{ loading }" type="submit" :disabled="!canSubmit">
                                <span v-if="loading" class="spin motion-keep" aria-hidden="true"></span>
                                <span>{{ loading ? "Signing in…" : "Sign in" }}</span>
                                <v-icon v-if="!loading" class="btn-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
                            </button>
                        </form>

                        <div class="divider" aria-hidden="true">
                            <span class="divider-line"></span>
                            <span class="divider-text">or</span>
                            <span class="divider-line"></span>
                        </div>
                    </main>

                    <main v-else id="panel-register" key="register" class="pane">
                        <h2>Create your account</h2>
                        <p class="sub">Choose a username to sign in. No email account needed. An administrator will review your request.</p>

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
                                    <v-icon class="btn-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
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
                                    <v-icon v-if="!registering" class="btn-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
                                </button>
                            </div>
                        </form>
                    </main>
                </Transition>

                <!-- Switch between signing in and asking for an account. -->
                <p class="account-switch">
                    <v-icon aria-hidden="true">{{ mode === 'signin' ? 'mdi-account-plus-outline' : 'mdi-login' }}</v-icon>
                    <span v-if="mode === 'signin'">
                        Don't have an account?
                        <button type="button" class="link" @click="openRegister">Create account</button>
                    </span>
                    <span v-else>
                        Already have an account?
                        <button type="button" class="link" @click="openSignIn">Sign in</button>
                    </span>
                </p>
            </section>

            <aside class="hero">
                <div class="hero-copy">
                    <h2 class="hero-title">
                        Monitor<br />City Government
                        <svg class="hero-spark" viewBox="0 0 48 48" aria-hidden="true">
                            <path d="M10 4 L15 20 M30 8 L22 22 M42 24 L26 27" />
                        </svg>
                    </h2>
                    <svg class="hero-swoosh" viewBox="0 0 160 18" aria-hidden="true">
                        <path d="M3 15 C40 3 100 0 157 7" />
                    </svg>
                </div>

                <!-- The picture, right-aligned on the panel floor. Its heads
                     and hands are copies of the same picture, cut out with
                     soft edges and gently turned (ART_PARTS below). -->
                <div ref="artEl" class="hero-art" aria-hidden="true">
                    <div
                        class="art-frame"
                        :style="{ width: `${frame.w}px`, height: `${frame.h}px`, bottom: `${frame.lift}px` }"
                    >
                        <img
                            class="hero-img"
                            :src="ART_SRC"
                            alt=""
                            :width="ART_W"
                            :height="ART_H"
                            decoding="async"
                        />
                        <span v-for="p in ART_PARTS" :key="p.id" class="art-part" :class="p.anim" :style="partStyle(p)" />
                    </div>

                    <!-- Foreground hills along the whole bottom; the picture's
                         own ground tucks in behind them. -->
                    <svg ref="groundEl" class="hero-ground" viewBox="0 0 1000 160" preserveAspectRatio="none">
                        <defs>
                            <linearGradient id="hg-left" x1="0" y1="0" x2="0" y2="1">
                                <stop offset="0" stop-color="#5fca97" />
                                <stop offset="1" stop-color="#36ad83" />
                            </linearGradient>
                            <linearGradient id="hg-right" x1="0" y1="0" x2="0" y2="1">
                                <stop offset="0" stop-color="#3aa7df" />
                                <stop offset="1" stop-color="#1c79c6" />
                            </linearGradient>
                            <linearGradient id="hg-front" x1="0" y1="0" x2="1" y2="0">
                                <stop offset="0" stop-color="#7fd08f" />
                                <stop offset="0.5" stop-color="#b3df9a" />
                                <stop offset="1" stop-color="#5dbfa6" />
                            </linearGradient>
                        </defs>
                        <path d="M0 22 C130 16 270 52 430 116 L430 160 L0 160 Z" fill="url(#hg-left)" />
                        <path d="M1000 4 C860 22 720 82 560 132 L560 160 L1000 160 Z" fill="url(#hg-right)" />
                        <path d="M0 90 C200 58 470 50 700 72 C820 84 920 78 1000 64 L1000 160 L0 160 Z" fill="url(#hg-front)" />
                    </svg>
                </div>

                <!-- Guest tracking: the read-only viewer, no sign-in. -->
                <div class="hero-cta">
                    <button
                        class="track"
                        :class="{ loading: guestLoading }"
                        type="button"
                        :disabled="loading || guestLoading"
                        @click="guestLogin"
                    >
                        <span class="track-chip" aria-hidden="true">
                            <span v-if="guestLoading" class="spin motion-keep"></span>
                            <v-icon v-else>mdi-map-marker-path</v-icon>
                        </span>
                        <span class="track-text">
                            <b>{{ guestLoading ? "Opening tracker…" : "Track your transaction" }}</b>
                            <small>View-only. No account or sign-in needed.</small>
                        </span>
                        <v-icon class="track-go" aria-hidden="true">mdi-chevron-right</v-icon>
                    </button>
                </div>
            </aside>
            <footer class="foot">
                <!-- Animations on/off for slow devices; the same setting as
                     the sidebar button (useMotion.js). -->
                <button
                    type="button"
                    class="motion-switch"
                    role="switch"
                    :aria-checked="motionEnabled ? 'true' : 'false'"
                    :title="motionEnabled ? 'Turn animations off (faster on slow devices)' : 'Turn animations on'"
                    @click="toggleMotion"
                >
                    <span class="motion-track" aria-hidden="true"><i /></span>
                    Animations {{ motionEnabled ? "on" : "off" }}
                </button>
            </footer>
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

// Animations on/off (footer switch; shared with the sidebar button).
const { motionEnabled, toggleMotion } = useMotion();

const router = useRouter();
const auth = useAuth();
const { api, csrf } = useApi();

// ---- Moving picture ---------------------------------------------------------
// The artwork is one still picture. Each moving part is a soft-edged copy of
// a patch of it laid exactly on top, turned a little around its pivot (a neck
// or a wrist) by a looping CSS animation. Boxes and pivots are in picture
// pixels (788 x 640). With animations off the copies sit still and the
// picture looks untouched.
const ART_SRC = "/login-art.jpg";
const ART_W = 788;
const ART_H = 640;
const ART_PARTS = [
    // woman at the board: head tilts, hand slides along the chart
    { id: "w1-head", box: [306, 40, 134, 154], pivot: [385, 182], anim: "art-tilt", dur: 5.2, delay: 0 },
    { id: "w1-hand", box: [484, 96, 98, 100], pivot: [503, 186], anim: "art-write", dur: 2.8, delay: 0.3 },
    // man thinking: head rocks, hand taps his chin
    { id: "m1-head", box: [92, 212, 168, 152], pivot: [186, 356], anim: "art-think", dur: 6, delay: 0.8 },
    { id: "m1-hand", box: [212, 300, 76, 72], pivot: [262, 374], anim: "art-tap", dur: 3.4, delay: 1.1 },
    // woman with glasses: head bobs, finger presses the checklist
    { id: "w2-head", box: [256, 226, 170, 170], pivot: [346, 394], anim: "art-bob", dur: 4.2, delay: 0.4 },
    { id: "w2-hand", box: [404, 280, 90, 70], pivot: [440, 342], anim: "art-press", dur: 1.9, delay: 0 },
    // man at the laptop: head nods
    { id: "m2-head", box: [514, 178, 164, 164], pivot: [588, 338], anim: "art-nod", dur: 3.8, delay: 1.6 },
];

function partStyle(p) {
    const [x, y, w, h] = p.box;
    const [px, py] = p.pivot;
    return {
        left: `${(x / ART_W) * 100}%`,
        top: `${(y / ART_H) * 100}%`,
        width: `${(w / ART_W) * 100}%`,
        height: `${(h / ART_H) * 100}%`,
        backgroundImage: `url(${ART_SRC})`,
        backgroundSize: `${(ART_W / w) * 100}% ${(ART_H / h) * 100}%`,
        backgroundPosition: `${(x / (ART_W - w)) * 100}% ${(y / (ART_H - h)) * 100}%`,
        transformOrigin: `${((px - x) / w) * 100}% ${((py - y) / h) * 100}%`,
        animationDuration: `${p.dur}s`,
        animationDelay: `${p.delay}s`,
    };
}

// Fit the picture into the room under the headline, sitting on the hills.
const artEl = ref(null);
const groundEl = ref(null);
const frame = ref({ w: 0, h: 0, lift: 0 });
let artObserver = null;

function fitArt() {
    const box = artEl.value;
    if (!box) return;
    const lift = Math.round((groundEl.value?.clientHeight || 0) * 0.42);
    const s = Math.min(box.clientWidth / ART_W, (box.clientHeight - lift) / ART_H, 1.3);
    frame.value = s > 0 ? { w: ART_W * s, h: ART_H * s, lift } : { w: 0, h: 0, lift };
}

onMounted(() => {
    fitArt();
    if (typeof ResizeObserver !== "undefined" && artEl.value) {
        artObserver = new ResizeObserver(fitArt);
        artObserver.observe(artEl.value);
    }
});
onUnmounted(() => artObserver?.disconnect());



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
.login-shell {
    /* Palette: blue frame and actions, navy headings, warm artwork panel. */
    --blue: #2563eb;
    --blue-deep: #1d4ed8;
    --blue-soft: #e8f0ff;
    --navy: #14245c;
    --ink: #1b2a4e;
    --muted: #5b6780;
    --line: #cfd8e8;
    --field: #ffffff;
    --focus: #2563eb;
    --danger: #b42318;
    --display: 'Montserrat', 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif;

    position: fixed;
    inset: 0;
    overflow: auto;
    background: #fef2da;
    color: var(--ink);
    font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
    -webkit-font-smoothing: antialiased;
    scrollbar-width: none;
    -ms-overflow-style: none;
}
.login-shell::-webkit-scrollbar {
    display: none;
    width: 0;
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
    border: 3px solid rgba(37, 99, 235, 0.25);
    border-top-color: var(--blue);
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

/* ---- Page: white form panel beside the artwork panel, edge to edge ---- */
.card {
    position: relative;
    display: grid;
    grid-template-columns: minmax(380px, 40%) 1fr;
    min-height: 100%;
    /* The picture's own edge colour, so it blends in. */
    background: #fef2da;
    overflow: hidden;
}

/* ---- Left: form panel ---- */
.side {
    position: relative;
    z-index: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    /* The form sits in the middle of the panel. */
    justify-content: center;
    padding: clamp(22px, 4.6vh, 52px) clamp(26px, 3.6vw, 60px) clamp(18px, 3vh, 32px);
    background: #ffffff;
    /* Rounded only on the side that meets the artwork. */
    border-radius: 0 32px 32px 0;
    box-shadow: 14px 0 34px -22px rgba(20, 36, 92, 0.35);
    animation: rise 0.5s cubic-bezier(0.2, 0.8, 0.2, 1) both;
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

.pane h2 {
    margin: 0 0 8px;
    font-family: var(--display);
    font-size: clamp(27px, 4.4vh, 38px);
    line-height: 1.1;
    font-weight: 800;
    letter-spacing: -0.015em;
    color: var(--navy);
}
.sub {
    max-width: 34ch;
    margin: 0 0 clamp(14px, 3vh, 26px);
    color: var(--muted);
    font-size: clamp(14px, 2vh, 16px);
    line-height: 1.5;
}

/* Switching panes: a short cross-fade with a lift. */
.swap-enter-active,
.swap-leave-active {
    transition: opacity 0.22s ease, transform 0.26s cubic-bezier(0.2, 0.8, 0.2, 1);
}
.swap-enter-from {
    opacity: 0;
    transform: translateY(10px);
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
    gap: 10px;
    border-radius: 12px;
    padding: 11px 14px;
    font-size: 14px;
    font-weight: 500;
    line-height: 1.45;
    margin-bottom: 16px;
    animation: rise 0.3s ease-out both;
}
.error {
    background: #fdf0ef;
    color: var(--danger);
    box-shadow: inset 3px 0 0 var(--danger);
}
.notice {
    background: #ebf7ef;
    color: #1d6b3c;
    box-shadow: inset 3px 0 0 #2f9e5b;
}
.error .v-icon,
.notice .v-icon {
    font-size: 20px;
    flex: none;
}

/* ---- Fields ---- */
.field {
    margin-bottom: clamp(12px, 2.2vh, 18px);
    min-width: 0;
}
.field label {
    display: block;
    margin: 0 0 7px;
    font-size: 14px;
    font-weight: 700;
    color: var(--navy);
}
.label-row {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    gap: 8px;
    margin-bottom: 7px;
}
.label-row label {
    margin-bottom: 0;
}
.field-counter {
    font-size: 11.5px;
    font-weight: 700;
    letter-spacing: 0.04em;
    color: var(--muted);
    font-variant-numeric: tabular-nums;
    transition: color 0.18s ease;
}
.field-counter.is-full {
    color: #1d6b3c;
}

.control {
    position: relative;
}
/* Icon segment on the left of each field, split off by a thin line. */
.chip {
    position: absolute;
    left: 1.5px;
    top: 1.5px;
    bottom: 1.5px;
    display: grid;
    place-items: center;
    width: 52px;
    border-right: 1.5px solid #e1e7f2;
    border-radius: 11px 0 0 11px;
    background: #f4f7fc;
    color: #34446b;
    pointer-events: none;
    transition: background 0.2s ease, color 0.2s ease, border-color 0.2s ease;
}
.chip .v-icon {
    font-size: 21px;
}
.control input,
.control select,
.control .office-select {
    width: 100%;
    height: clamp(44px, 6.2vh, 54px);
    border: 1.5px solid var(--line);
    border-radius: 12px;
    background-color: var(--field);
    color: var(--ink);
    font: inherit;
    font-size: 15.5px;
    padding: 0 14px 0 66px;
    text-overflow: ellipsis;
    transition: border-color 0.18s ease, box-shadow 0.18s ease;
}
/* Room for the show/hide password button only where there is one. */
.control:has(.toggle) input {
    padding-right: 52px;
}
.control input::placeholder {
    color: #8a94aa;
}
.control input:hover:not(:disabled),
.control select:hover:not(:disabled),
.control .office-select:hover:not(:disabled) {
    border-color: #a9b9d6;
}
.control input:focus,
.control select:focus,
.control .office-select:focus {
    outline: none;
    border-color: var(--focus);
    box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.14);
}
.control:focus-within .chip {
    background: var(--blue-soft);
    border-right-color: #c7d8fb;
    color: var(--blue);
}
.control input:disabled,
.control select:disabled,
.control .office-select:disabled {
    opacity: 0.72;
    cursor: not-allowed;
}
.control input[aria-invalid="true"],
.control select[aria-invalid="true"],
.control .office-select[aria-invalid="true"] {
    border-color: var(--danger);
}
.control:has([aria-invalid="true"]) .chip {
    background: #fbe4e2;
    color: var(--danger);
}
/* Selects match the inputs, with their own chevron. */
.control select {
    padding-right: 36px;
    appearance: none;
    cursor: pointer;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' fill='none' stroke='%235b6780' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 14px center;
}

/* Office picker: custom list so each option can show its own icon. */
.control .office-select {
    display: flex;
    align-items: center;
    gap: 10px;
    padding-right: 36px;
    text-align: left;
    cursor: pointer;
}
.office-selected {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
}
.office-avatar {
    display: grid;
    place-items: center;
    width: 26px;
    height: 26px;
    flex: none;
    overflow: hidden;
    border-radius: 50%;
    background: #e9eff9;
    color: var(--navy);
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.02em;
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
    text-overflow: ellipsis;
    white-space: nowrap;
}
.office-name {
    font-weight: 600;
}
.office-placeholder {
    color: #8a94aa;
}
.office-caret {
    margin-left: auto;
    flex: none;
    color: #5b6780;
    pointer-events: none;
}
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
.office-option:hover {
    background: #f1f5fd;
}
.office-option.is-selected {
    background: var(--blue-soft);
    color: var(--navy);
}
.office-option-name {
    flex: 1;
    min-width: 0;
}
.office-check {
    flex: none;
    color: var(--focus);
}
.office-empty {
    margin: 0;
    padding: 12px;
    color: var(--muted);
    font-size: 13px;
}

/* Autofill: keep the field's own colours instead of Chrome's wash. */
.control input:-webkit-autofill,
.control input:-webkit-autofill:hover,
.control input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 100px var(--field) inset !important;
    -webkit-text-fill-color: var(--ink) !important;
    caret-color: var(--ink) !important;
    transition: background-color 5000s ease-in-out 0s !important;
}
.control input:-webkit-autofill:focus {
    -webkit-box-shadow: 0 0 0 100px #ffffff inset, 0 0 0 4px rgba(37, 99, 235, 0.14) !important;
    -webkit-text-fill-color: var(--ink) !important;
}
.control input:autofill {
    box-shadow: 0 0 0 100px var(--field) inset !important;
    -webkit-text-fill-color: var(--ink) !important;
}

.toggle {
    position: absolute;
    right: 8px;
    top: 50%;
    transform: translateY(-50%);
    width: 38px;
    height: 38px;
    border: 0;
    border-radius: 10px;
    background: none;
    color: var(--muted);
    cursor: pointer;
    display: grid;
    place-items: center;
    transition: background 0.15s ease, color 0.15s ease;
}
.toggle:hover {
    background: #eef3fb;
    color: var(--navy);
}
.toggle:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.35);
}
.toggle .v-icon {
    font-size: 21px;
}

.field-error,
.field-note {
    margin: 6px 2px 0;
    font-size: 12.5px;
    line-height: 1.4;
}
.field-error {
    color: var(--danger);
    font-weight: 600;
}
.field-note {
    color: var(--muted);
    margin-bottom: 14px;
}
.field-note.is-bad {
    color: var(--danger);
    font-weight: 600;
}

/* ---- Primary button: a blue pill ---- */
.pane form .btn {
    margin-top: clamp(4px, 1vh, 10px);
}
.btn {
    position: relative;
    width: 100%;
    height: clamp(46px, 6.6vh, 58px);
    border: 0;
    border-radius: 999px;
    background: linear-gradient(180deg, #2f6ff0 0%, var(--blue-deep) 100%);
    color: #ffffff;
    font-family: var(--display);
    font-size: 16px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.25),
        0 12px 24px -12px rgba(29, 78, 216, 0.8);
    transition: transform 0.15s ease, box-shadow 0.2s ease, filter 0.2s ease;
}
.btn:hover:not(:disabled) {
    transform: translateY(-1px);
    filter: brightness(1.06);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.25),
        0 16px 28px -12px rgba(29, 78, 216, 0.9),
        0 0 0 4px rgba(37, 99, 235, 0.14);
}
.btn:active:not(:disabled) {
    transform: translateY(0);
}
.btn:disabled {
    cursor: not-allowed;
    filter: saturate(0.6) brightness(1.18);
    box-shadow: none;
}
.btn.loading {
    cursor: progress;
}
.btn:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.4);
    outline-offset: 3px;
}
.btn-arrow {
    font-size: 22px;
    transition: transform 0.2s ease;
}
.btn:hover:not(:disabled) .btn-arrow {
    transform: translateX(3px);
}

/* ---- Create account: steps paged with Back / Continue ---- */
.reg-step-title {
    margin: 0 0 16px;
    font-size: 16px;
    font-weight: 750;
    color: var(--navy);
}
.steps {
    display: flex;
    align-items: center;
    gap: 14px;
    margin: 0 0 14px;
}
.steps-text {
    margin: 0;
    font-size: 12px;
    font-weight: 700;
    color: var(--muted);
    white-space: nowrap;
}
.steps-track {
    display: flex;
    flex: 1;
    gap: 5px;
}
.steps-track i {
    flex: 1;
    height: 4px;
    border-radius: 999px;
    background: #e3eaf6;
    transition: background 0.35s ease;
}
.steps-track i.is-on {
    background: var(--blue);
}
.reg-nav {
    display: flex;
    gap: 12px;
    padding-top: 4px;
}
.reg-step.is-short + .reg-nav {
    margin-top: 18px;
}
.reg-nav .btn {
    flex: 1;
}
.btn-ghost {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: clamp(46px, 6.6vh, 58px);
    padding: 0 22px;
    border: 1.5px solid var(--line);
    border-radius: 999px;
    background: #ffffff;
    color: var(--navy);
    font-family: var(--display);
    font-size: 14px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    cursor: pointer;
    transition: border-color 0.2s ease, background 0.2s ease;
}
.btn-ghost:hover:not(:disabled) {
    border-color: #9fb5dc;
    background: #f6f8fd;
}
.btn-ghost:disabled {
    opacity: 0.55;
    cursor: not-allowed;
}
.btn-ghost:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.35);
    outline-offset: 3px;
}
.btn-ghost .v-icon {
    font-size: 19px;
}
.btn-arrow-back {
    transition: transform 0.2s ease;
}
.btn-ghost:hover:not(:disabled) .btn-arrow-back {
    transform: translateX(-3px);
}

/* ---- "or" divider ---- */
.divider {
    display: flex;
    align-items: center;
    gap: 16px;
    margin: clamp(12px, 2.4vh, 22px) 0 clamp(10px, 2vh, 18px);
}
.divider-line {
    flex: 1;
    height: 1px;
    background: #d9e0ec;
}
.divider-text {
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    color: #7a849a;
}

/* ---- Track your transaction: a white pill standing on the hills ---- */
.track {
    width: min(440px, 100%);
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 8px 18px 8px 8px;
    border: 0;
    border-radius: 999px;
    background: #ffffff;
    color: var(--navy);
    font: inherit;
    text-align: left;
    cursor: pointer;
    box-shadow:
        0 0 0 4px rgba(255, 255, 255, 0.45),
        0 16px 30px -14px rgba(20, 36, 92, 0.55);
    transition: box-shadow 0.2s ease, transform 0.15s ease;
}
.track:hover:not(:disabled) {
    box-shadow:
        0 0 0 4px rgba(255, 255, 255, 0.7),
        0 20px 34px -14px rgba(20, 36, 92, 0.6);
    transform: translateY(-2px);
}
.track:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}
.track:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.4);
    outline-offset: 2px;
}
.track-chip {
    flex: none;
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: linear-gradient(180deg, #2f6ff0 0%, var(--blue-deep) 100%);
    color: #ffffff;
    box-shadow: 0 6px 12px -6px rgba(29, 78, 216, 0.9);
}
.track-chip .v-icon {
    font-size: 22px;
}
.track-text {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 1px;
}
.track-text b {
    font-family: var(--display);
    font-size: 15px;
    font-weight: 800;
}
.track-text small {
    font-size: 12.5px;
    color: var(--muted);
}
.track-go {
    font-size: 22px;
    color: #7d8bb0;
    transition: transform 0.2s ease, color 0.2s ease;
}
.track:hover:not(:disabled) .track-go {
    transform: translateX(3px);
    color: var(--blue);
}

/* ---- Bottom: switch between sign in and create account ---- */
.account-switch {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin: 0;
    padding: 12px 18px;
    border-radius: 999px;
    background: #f1f4f9;
    font-size: 15px;
    color: var(--ink);
    text-align: center;
}
/* A little air above it when the form runs right up to it. */
.pane {
    margin-bottom: 16px;
}
.account-switch .v-icon {
    font-size: 22px;
    color: #34446b;
}
.link {
    border: 0;
    padding: 0;
    background: none;
    font: inherit;
    font-weight: 700;
    color: var(--blue);
    cursor: pointer;
}
.link:hover {
    text-decoration: underline;
}
.link:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.35);
    outline-offset: 2px;
    border-radius: 4px;
}

.spin {
    width: 18px;
    height: 18px;
    border: 2.5px solid rgba(255, 255, 255, 0.4);
    border-top-color: #ffffff;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}
@keyframes spin {
    to { transform: rotate(360deg); }
}

/* ---- Right: headline over the artwork ---- */
.hero {
    position: relative;
    display: flex;
    flex-direction: column;
    min-width: 0;
    /* Extra left room: the form panel's shadow falls here. */
    padding: clamp(26px, 6vh, 64px) clamp(28px, 4vw, 64px) 0 clamp(36px, 4.6vw, 76px);
}
.hero-copy {
    position: relative;
    z-index: 1;
}
.hero-title {
    position: relative;
    display: inline-block;
    margin: 0;
    font-family: var(--display);
    font-size: clamp(32px, 6.2vh, 58px);
    line-height: 1.06;
    font-weight: 800;
    letter-spacing: -0.015em;
    color: var(--navy);
}
.hero-spark {
    position: absolute;
    top: -0.32em;
    left: 5.4em;
    width: 0.8em;
    height: 0.8em;
}
.hero-spark path {
    fill: none;
    stroke: var(--blue);
    stroke-width: 4;
    stroke-linecap: round;
}
.hero-swoosh {
    display: block;
    width: clamp(110px, 12vw, 160px);
    margin-top: 8px;
}
.hero-swoosh path {
    fill: none;
    stroke: var(--blue);
    stroke-width: 4;
    stroke-linecap: round;
}

/* Room under the headline, edge to edge (and under the form panel's
   rounded corner, so the hills run all the way across). */
.hero {
    --ground: clamp(100px, 18vh, 170px);
}
.hero-art {
    position: relative;
    flex: 1;
    min-height: 240px;
    margin: 0 calc(clamp(28px, 4vw, 64px) * -1) 0 calc(clamp(36px, 4.6vw, 76px) * -1 - 40px);
    overflow: hidden;
}
/* Sized in JS (fitArt) to the picture's own shape, flush right, resting on
   the hills. */
.art-frame {
    position: absolute;
    right: 0;
}
.hero-img {
    display: block;
    width: 100%;
    height: 100%;
}
/* A moving piece: the same picture, cut to its box with a soft oval edge. */
.art-part {
    position: absolute;
    background-repeat: no-repeat;
    -webkit-mask-image: radial-gradient(closest-side, #000 60%, transparent 100%);
    mask-image: radial-gradient(closest-side, #000 60%, transparent 100%);
    will-change: transform;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
}
/* Names live here (not inline) so the scoped keyframe names match. */
.art-tilt { animation-name: art-tilt; }
.art-write { animation-name: art-write; }
.art-think { animation-name: art-think; }
.art-tap { animation-name: art-tap; }
.art-bob { animation-name: art-bob; }
.art-press { animation-name: art-press; }
.art-nod { animation-name: art-nod; }
@keyframes art-tilt {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(-2deg); }
}
@keyframes art-write {
    0%, 100% { transform: rotate(0deg); }
    30% { transform: rotate(-4deg); }
    60% { transform: rotate(1.5deg); }
    80% { transform: rotate(-1.5deg); }
}
@keyframes art-think {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(2deg); }
}
@keyframes art-tap {
    0%, 55%, 100% { transform: rotate(0deg); }
    65% { transform: rotate(-4deg); }
    75% { transform: rotate(0deg); }
    85% { transform: rotate(-4deg); }
}
@keyframes art-bob {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(2deg); }
}
@keyframes art-press {
    0%, 100% { transform: rotate(0deg); }
    50% { transform: rotate(-3deg); }
}
@keyframes art-nod {
    0%, 100% { transform: rotate(0deg); }
    30% { transform: rotate(2deg); }
    60% { transform: rotate(-0.8deg); }
}
.hero-ground {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    height: var(--ground);
}
/* Track your transaction, standing on the front hill. */
.hero-cta {
    position: absolute;
    left: 0;
    right: 0;
    bottom: calc(var(--ground) * 0.14);
    z-index: 2;
    display: flex;
    justify-content: center;
    padding: 0 24px;
}

/* ---- Animations switch: top-right corner of the artwork panel ---- */
.foot {
    position: absolute;
    right: 18px;
    top: 14px;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--navy);
    pointer-events: none;
}
.foot > * {
    pointer-events: auto;
}

/* Animations switch: a small pill. */
.motion-switch {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 3px 10px 3px 4px;
    border: 1px solid #c6d6f2;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.85);
    font: inherit;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--navy);
    cursor: pointer;
    transition: border-color 0.15s ease;
}
.motion-switch:hover {
    border-color: #9fb5dc;
}
.motion-switch:focus-visible {
    outline: 3px solid rgba(37, 99, 235, 0.35);
    outline-offset: 2px;
}
.motion-track {
    position: relative;
    width: 26px;
    height: 15px;
    border-radius: 999px;
    background: #c9d3e4;
    transition: background 0.2s ease;
}
.motion-track i {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 11px;
    height: 11px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 2px rgba(15, 36, 102, 0.35);
    transition: transform 0.2s ease;
}
.motion-switch[aria-checked="true"] .motion-track {
    background: var(--blue);
}
.motion-switch[aria-checked="true"] .motion-track i {
    transform: translateX(11px);
}

@keyframes rise {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: none; }
}

/* Short laptop screens (e.g. 1366x657): tighter rhythm so Sign in fits
   without scrolling. */
@media (max-height: 720px) and (min-width: 901px) {
    .side {
        padding-top: 18px;
        padding-bottom: 14px;
    }
    .sub {
        margin-bottom: 12px;
    }
    .divider {
        margin: 10px 0 8px;
    }
    .account-switch {
        padding: 9px 16px;
    }
}

/* Narrow screens: the form, then the tracking button; the picture and
   headline are dropped. */
@media (max-width: 900px) {
    .login-shell,
    .card {
        background: #ffffff;
    }
    .card {
        grid-template-columns: minmax(0, 560px);
        justify-content: center;
        align-content: center;
    }
    .side {
        border-radius: 0;
        box-shadow: none;
    }
    .hero {
        padding: 0 clamp(16px, 5vw, 40px) 20px;
    }
    .hero-copy,
    .hero-art {
        display: none;
    }
    .hero-cta {
        position: static;
        padding: 0;
    }
    .track {
        width: 100%;
        background: #f5f8ff;
        box-shadow: inset 0 0 0 1.5px #c9d8f6;
    }
    .foot {
        position: static;
        justify-content: center;
        padding: 0 0 16px;
    }
}

/* Phones: 16px gutters. */
@media (max-width: 480px) {
    .side {
        padding: 24px 16px 20px;
    }
    .hero {
        padding: 0 16px 20px;
    }
    .account-switch {
        flex-wrap: wrap;
        border-radius: 18px;
        font-size: 14px;
    }
    .track-text small {
        display: none;
    }
}

@media (prefers-reduced-motion: reduce) {
    .control input,
    .control select,
    .chip,
    .btn,
    .btn-ghost,
    .btn-arrow-back,
    .steps-track i,
    .track {
        transition: none !important;
    }
    .art-part {
        animation: none !important;
    }
    .side,
    .error,
    .notice {
        animation: none;
    }
    .swap-enter-active,
    .swap-leave-active {
        transition: none;
    }
}
</style>
