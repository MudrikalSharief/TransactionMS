<template>
    <div
        class="login-shell"
        :class="{ 'hide-cursor': loading && pointer.seen }"
    >
        <section class="side">
            <!-- Lockup: the emblem, a gold rule like its inner ring, and the
                 name in the emblem's own navy and gold, with its ribbon motto. -->
            <header class="brand">
                <span class="brand-mark">
                    <img
                        class="seal"
                        :src="'/tms-logo-128.png'"
                        alt="Transaction Management System emblem, Local Government of Zamboanga City"
                        width="76"
                        height="79"
                    />
                </span>
                <span class="brand-rule" aria-hidden="true"></span>
                <div class="brand-text">
                    <p class="brand-city">City Government of Zamboanga</p>
                    <h1 class="brand-name">Transaction<span>MS</span></h1>
                    <p class="brand-motto">
                        <span class="brand-link" aria-hidden="true"><i></i></span>
                        E-Service &amp; Efficient
                    </p>
                </div>
            </header>

            <div class="panel">
                <!-- Sign in / Create account: a pill switch shaped like the
                     module buttons in the artwork. -->
                <div class="switch" role="tablist" aria-label="Account">
                    <span class="switch-ink" :class="{ 'is-right': mode === 'register' }" aria-hidden="true"></span>
                    <button
                        id="tab-signin"
                        type="button"
                        role="tab"
                        :aria-selected="mode === 'signin' ? 'true' : 'false'"
                        aria-controls="panel-signin"
                        @click="openSignIn"
                    >
                        Sign in
                    </button>
                    <button
                        id="tab-register"
                        type="button"
                        role="tab"
                        :aria-selected="mode === 'register' ? 'true' : 'false'"
                        aria-controls="panel-register"
                        @click="openRegister"
                    >
                        Create account
                    </button>
                </div>

                <Transition name="swap" mode="out-in">
                    <main v-if="mode === 'signin'" id="panel-signin" key="signin" class="pane" role="tabpanel" aria-labelledby="tab-signin">
                        <h2>{{ greeting }}</h2>
                        <p class="sub">Sign in with your username or email and your password.</p>

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
                                <label for="login-id">Username or email</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-account-circle-outline</v-icon></span>
                                    <input
                                        id="login-id"
                                        v-model.trim="loginId"
                                        type="text"
                                        inputmode="email"
                                        name="username"
                                        placeholder="e.g. juan.delacruz"
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

                            <label class="check">
                                <input v-model="remember" type="checkbox" :disabled="loading" />
                                <span>Keep me signed in</span>
                            </label>

                            <button class="btn" :class="{ loading }" type="submit" :disabled="!canSubmit">
                                <span v-if="loading" class="spin" aria-hidden="true"></span>
                                <span>{{ loading ? "Signing in…" : "Sign in" }}</span>
                                <v-icon v-if="!loading" class="btn-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
                            </button>
                        </form>

                        <!-- The six module colours from the artwork mark the
                             switch to tracking. -->
                        <div class="divider" aria-hidden="true">
                            <span class="divider-line"></span>
                            <span class="dots"><i v-for="c in moduleColors" :key="c" :style="{ background: c, color: c }"></i></span>
                            <span class="divider-line"></span>
                        </div>

                        <button
                            class="track"
                            :class="{ loading: guestLoading }"
                            type="button"
                            :disabled="loading || guestLoading"
                            @click="guestLogin"
                        >
                            <span class="track-chip" aria-hidden="true">
                                <span v-if="guestLoading" class="spin spin-dark"></span>
                                <v-icon v-else>mdi-map-marker-path</v-icon>
                            </span>
                            <span class="track-text">
                                <b>{{ guestLoading ? "Opening tracker…" : "Track your transaction" }}</b>
                                <small>View-only. No account or sign-in needed.</small>
                            </span>
                            <v-icon class="track-go" aria-hidden="true">mdi-chevron-right</v-icon>
                        </button>
                    </main>

                    <!-- Create an account: the same details a superadmin enters
                         for a new user, plus a contact number. It waits for
                         approval. -->
                    <main v-else id="panel-register" key="register" class="pane" role="tabpanel" aria-labelledby="tab-register">
                        <h2>Request an account</h2>
                        <p class="sub">An administrator reviews new accounts. You can sign in once yours is approved.</p>

                        <div v-if="regError" :key="errorKey" class="error" role="alert" aria-live="assertive">
                            <v-icon aria-hidden="true">mdi-alert-circle-outline</v-icon>
                            <span>{{ regError }}</span>
                        </div>

                        <form novalidate :aria-busy="registering ? 'true' : 'false'" @submit.prevent="register">
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

                            <div class="grid-2">
                                <div class="field">
                                    <label for="reg-username">Username</label>
                                    <div class="control">
                                        <span class="chip" aria-hidden="true"><v-icon>mdi-at</v-icon></span>
                                        <input
                                            id="reg-username"
                                            v-model="reg.username"
                                            type="text"
                                            autocomplete="username"
                                            autocapitalize="none"
                                            spellcheck="false"
                                            maxlength="30"
                                            placeholder="jdelacruz"
                                            :disabled="registering"
                                            :aria-invalid="usernameProblem || fieldErrors.username ? 'true' : 'false'"
                                            aria-describedby="reg-username-help"
                                            required
                                            @input="onUsernameInput"
                                        />
                                    </div>
                                </div>

                                <div class="field">
                                    <label for="reg-contact">Contact number</label>
                                    <div class="control">
                                        <span class="chip" aria-hidden="true"><v-icon>mdi-phone-outline</v-icon></span>
                                        <input
                                            id="reg-contact"
                                            v-model.trim="reg.contact_number"
                                            type="tel"
                                            inputmode="tel"
                                            autocomplete="tel"
                                            placeholder="09171234567"
                                            :disabled="registering"
                                            :aria-invalid="fieldErrors.contact_number ? 'true' : 'false'"
                                            required
                                        />
                                    </div>
                                </div>
                            </div>
                            <p
                                id="reg-username-help"
                                class="field-note"
                                :class="{ 'is-bad': usernameProblem || fieldErrors.username }"
                            >
                                {{
                                    fieldErrors.username ||
                                    usernameProblem ||
                                    "3–30 lowercase letters, numbers, dots or underscores. You can sign in with it."
                                }}
                            </p>
                            <p v-if="fieldErrors.contact_number" class="field-error">{{ fieldErrors.contact_number }}</p>

                            <div class="field">
                                <label for="reg-email">Email</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-email-outline</v-icon></span>
                                    <input
                                        id="reg-email"
                                        v-model.trim="reg.email"
                                        type="email"
                                        autocomplete="email"
                                        autocapitalize="none"
                                        spellcheck="false"
                                        placeholder="name@zamboanga.gov.ph"
                                        :disabled="registering"
                                        :aria-invalid="fieldErrors.email ? 'true' : 'false'"
                                        required
                                    />
                                </div>
                                <p v-if="fieldErrors.email" class="field-error">{{ fieldErrors.email }}</p>
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

                            <!-- Office names are long: full width. -->
                            <div class="field">
                                <label for="reg-office">Office</label>
                                <div class="control">
                                    <span class="chip" aria-hidden="true"><v-icon>mdi-office-building-outline</v-icon></span>
                                    <select
                                        id="reg-office"
                                        v-model="reg.office_id"
                                        :disabled="registering || !options.offices.length"
                                        :aria-invalid="fieldErrors.office_id ? 'true' : 'false'"
                                        required
                                    >
                                        <option :value="null" disabled>Choose your office</option>
                                        <option v-for="o in options.offices" :key="o.id" :value="o.id">{{ o.name }}</option>
                                    </select>
                                </div>
                                <p v-if="fieldErrors.office_id" class="field-error">{{ fieldErrors.office_id }}</p>
                            </div>

                            <div class="field field-last">
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

                            <button class="btn" :class="{ loading: registering }" type="submit" :disabled="!canRegister">
                                <span v-if="registering" class="spin" aria-hidden="true"></span>
                                <span>{{ registering ? "Sending request…" : "Request account" }}</span>
                                <v-icon v-if="!registering" class="btn-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
                            </button>
                        </form>

                        <p class="help">
                            Already have an account?
                            <button type="button" class="link" @click="openSignIn">Sign in</button>
                        </p>
                    </main>
                </Transition>
            </div>

            <!-- Footer with a faint skyline and wave that continue the
                 artwork's bottom edge across the form panel. -->
            <footer>
                <span>City Government of Zamboanga</span>
                <svg class="skyline" viewBox="0 0 480 110" preserveAspectRatio="xMidYMax slice" aria-hidden="true">
                    <path class="sky-wave" d="M0 92 C120 70 260 112 480 78 L480 110 L0 110 Z" />
                    <g class="sky-city">
                        <rect x="300" y="52" width="16" height="40" />
                        <rect x="304" y="44" width="8" height="8" />
                        <path d="M308 30 L314 44 L302 44 Z" />
                        <rect x="322" y="66" width="46" height="26" />
                        <path d="M318 66 L345 56 L372 66 Z" />
                        <rect x="374" y="60" width="14" height="32" />
                        <rect x="392" y="70" width="22" height="22" />
                        <rect x="418" y="64" width="12" height="28" />
                        <path d="M262 92 L262 64 M262 64 c-9 -3 -14 2 -18 6 M262 64 c9 -3 14 2 18 6 M262 64 c-4 -7 -10 -8 -14 -8 M262 64 c4 -7 10 -8 14 -8" class="sky-palm" />
                        <path d="M446 92 L446 68 M446 68 c-8 -3 -12 2 -15 5 M446 68 c8 -3 12 2 15 5 M446 68 c-3 -6 -8 -7 -12 -7 M446 68 c3 -6 8 -7 12 -7" class="sky-palm" />
                    </g>
                </svg>
            </footer>
        </section>

        <aside class="hero" aria-label="Available modules">
            <LoginHero />
        </aside>

        <div
            v-if="loading && pointer.seen"
            class="spin-cursor"
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
import LoginHero from "@/components/login/LoginHero.vue";

const router = useRouter();
const auth = useAuth();
const { api, csrf } = useApi();

// Module colours, in the artwork's order.
const moduleColors = ["#3B6CF6", "#14B8A6", "#F59E0B", "#7C3AED", "#0EA5E9", "#EF4444"];

// Same greeting as the dashboard header, by the local hour.
const greeting = (() => {
    const h = new Date().getHours();
    if (h < 12) return "Good morning";
    if (h < 18) return "Good afternoon";
    return "Good evening";
})();

// "signin" or "register" (Create an account), in the same panel.
const mode = ref("signin");
const notice = ref("");

// Username or email: the server tells them apart by the "@".
const loginId = ref("");
const password = ref("");
const showPassword = ref(false);
const remember = ref(false);

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
            remember: remember.value,
        });

        await auth.init();

        await router.push({ name: "dashboard" });
    } catch (e) {
        const msg = e?.response?.data?.message;
        error.value =
            msg === "Invalid credentials."
                ? "That username or email and password don't match an account."
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
    email: "",
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
        reg.value.email &&
        reg.value.contact_number &&
        reg.value.password.length >= 8 &&
        reg.value.office_id != null &&
        reg.value.role_id != null,
);

async function openRegister() {
    mode.value = "register";
    error.value = "";
    notice.value = "";
    regError.value = "";
    fieldErrors.value = {};
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
            email: reg.value.email,
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
    /* Palette: the emblem's navy and gold, the artwork's sky and module colours. */
    --navy: #16307c;
    --navy-deep: #0f2466;
    --gold: #b8891b;
    --ink: #14213d;
    --muted: #5b6780;
    --line: #d9e1ef;
    --field: #f6f8fd;
    --focus: #2f6feb;
    --sky: #eaf2fd;
    --danger: #b42318;

    position: fixed;
    inset: 0;
    display: grid;
    grid-template-columns: minmax(380px, 500px) 1fr;
    overflow: auto;
    background: #ffffff;
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
    border: 3px solid rgba(22, 48, 124, 0.25);
    border-top-color: var(--navy);
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

/* ---- Left: form panel ---- */
.side {
    position: relative;
    z-index: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    min-height: 100vh;
    padding: 40px 52px 0;
    background: #ffffff;
    /* A soft edge against the artwork instead of a hard rule. */
    box-shadow: 1px 0 0 rgba(213, 222, 238, 0.9), 18px 0 40px -30px rgba(22, 48, 124, 0.35);
}

/* ---- Brand lockup (colours taken from the emblem) ---- */
.brand {
    --emblem-navy: #16307c;
    --emblem-gold: #b8891b;
    --emblem-gold-text: #8a6612; /* darker gold: readable at small sizes */
    display: flex;
    align-items: center;
    gap: 16px;
}
.brand-mark {
    position: relative;
    flex: none;
    display: grid;
    place-items: center;
    width: 84px;
    height: 84px;
    animation: brand-settle 0.6s cubic-bezier(0.2, 0.8, 0.2, 1) both;
}
/* Faint dotted gold ring behind the emblem, like its engraved rim. */
.brand-mark::before {
    content: "";
    position: absolute;
    inset: 0;
    border-radius: 50%;
    border: 1px dashed rgba(184, 137, 27, 0.45);
}
.seal {
    position: relative;
    width: 76px;
    height: 79px;
    object-fit: contain;
    filter: drop-shadow(0 6px 10px rgba(22, 48, 124, 0.22));
}
/* Gold rule between emblem and name, drawn top to bottom. */
.brand-rule {
    flex: none;
    width: 1.5px;
    height: 62px;
    background: linear-gradient(180deg, transparent, var(--emblem-gold) 18%, var(--emblem-gold) 82%, transparent);
    transform-origin: top center;
    animation: brand-rule 0.5s cubic-bezier(0.2, 0.7, 0.2, 1) 0.15s both;
}
.brand-text {
    min-width: 0;
    animation: brand-text 0.55s cubic-bezier(0.2, 0.7, 0.2, 1) 0.25s both;
}
.brand-city {
    margin: 0 0 3px;
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.2em;
    text-transform: uppercase;
    color: var(--emblem-gold-text);
}
.brand-name {
    margin: 0;
    font-size: 28px;
    line-height: 1.05;
    font-weight: 800;
    letter-spacing: -0.015em;
    color: var(--emblem-navy);
}
.brand-name span {
    color: var(--emblem-gold);
}
/* The ribbon's motto, led by the same lozenge-and-line link as the
   welcome screen. */
.brand-motto {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 6px 0 0;
    font-family: 'Iowan Old Style', 'Palatino Linotype', Palatino, 'Book Antiqua', Georgia, serif;
    font-size: 13.5px;
    font-style: italic;
    color: #4a5670;
}
.brand-link {
    position: relative;
    width: 26px;
    height: 7px;
    flex: none;
}
.brand-link::before {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    top: 3px;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--emblem-gold) 40%);
}
.brand-link i {
    position: absolute;
    right: 0;
    top: 0;
    width: 7px;
    height: 7px;
    background: var(--emblem-gold);
    transform: rotate(45deg) scale(0.8);
}
@keyframes brand-settle {
    from { opacity: 0; transform: scale(0.9); }
    to { opacity: 1; transform: none; }
}
@keyframes brand-rule {
    from { transform: scaleY(0); }
    to { transform: none; }
}
@keyframes brand-text {
    from { opacity: 0; transform: translateX(-8px); }
    to { opacity: 1; transform: none; }
}

/* ---- Panel ---- */
.panel {
    margin: auto 0;
    padding: 36px 0 28px;
    width: 100%;
    animation: rise 0.6s cubic-bezier(0.2, 0.8, 0.2, 1) 0.2s both;
}

/* Sign in / Create account switch */
.switch {
    position: relative;
    display: grid;
    grid-template-columns: 1fr 1fr;
    padding: 4px;
    margin-bottom: 30px;
    border-radius: 999px;
    background: #eef3fb;
    border: 1px solid #dfe7f4;
}
.switch button {
    position: relative;
    z-index: 1;
    height: 40px;
    border: 0;
    border-radius: 999px;
    background: none;
    font: inherit;
    font-size: 14px;
    font-weight: 700;
    letter-spacing: 0.01em;
    color: var(--muted);
    cursor: pointer;
    transition: color 0.25s ease;
}
.switch button[aria-selected="true"] {
    color: var(--navy);
}
.switch button:focus-visible {
    outline: 3px solid rgba(47, 111, 235, 0.35);
    outline-offset: 1px;
}
/* The white "pill" slides under the chosen side. */
.switch-ink {
    position: absolute;
    top: 4px;
    bottom: 4px;
    left: 4px;
    width: calc(50% - 4px);
    border-radius: 999px;
    background: linear-gradient(180deg, #ffffff 0%, #f7f9fe 100%);
    border: 1px solid #cfdcf3;
    box-shadow: 0 1px 0 #ffffff inset, 0 4px 12px -4px rgba(22, 48, 124, 0.28), 0 0 0 3px rgba(47, 111, 235, 0.06);
    transition: transform 0.38s cubic-bezier(0.3, 0.9, 0.3, 1);
}
.switch-ink.is-right {
    transform: translateX(100%);
}

.pane h2 {
    margin: 0 0 6px;
    font-size: 27px;
    font-weight: 800;
    letter-spacing: -0.02em;
    color: var(--ink);
}
.sub {
    margin: 0 0 24px;
    color: var(--muted);
    font-size: 14.5px;
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
    padding: 12px 14px;
    font-size: 14px;
    font-weight: 500;
    line-height: 1.45;
    margin-bottom: 18px;
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
    margin-bottom: 18px;
    min-width: 0;
}
.field label {
    display: block;
    margin: 0 0 7px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: #2a3757;
}
.grid-2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 14px;
}
.grid-2 .field {
    margin-bottom: 0;
}
.grid-2 + .field-note,
.grid-2 + .field-error {
    margin-top: 8px;
}
/* Breathing room above the submit button. */
.field-last {
    margin-bottom: 24px;
}
.control {
    position: relative;
}
/* Icon chip: lights up in the system blue when its field has focus. */
.chip {
    position: absolute;
    left: 8px;
    top: 50%;
    transform: translateY(-50%);
    display: grid;
    place-items: center;
    width: 34px;
    height: 34px;
    border-radius: 10px;
    background: #e9eff9;
    color: var(--navy);
    pointer-events: none;
    transition: background 0.2s ease, color 0.2s ease, box-shadow 0.2s ease;
}
.chip .v-icon {
    font-size: 19px;
}
.control input,
.control select {
    width: 100%;
    height: 50px;
    border: 1.5px solid var(--line);
    border-radius: 14px;
    background-color: var(--field);
    color: var(--ink);
    font: inherit;
    font-size: 15.5px;
    padding: 0 14px 0 52px;
    text-overflow: ellipsis;
    transition: border-color 0.18s ease, box-shadow 0.18s ease, background-color 0.18s ease;
}
/* Room for the show/hide password button only where there is one. */
.control:has(.toggle) input {
    padding-right: 48px;
}
.control input::placeholder {
    color: #8a94aa;
}
.control input:hover:not(:disabled),
.control select:hover:not(:disabled) {
    border-color: #b9c6de;
}
.control input:focus,
.control select:focus {
    outline: none;
    border-color: var(--focus);
    background-color: #ffffff;
    box-shadow: 0 0 0 4px rgba(47, 111, 235, 0.14), 0 6px 16px -10px rgba(47, 111, 235, 0.6);
}
.control:focus-within .chip {
    background: var(--focus);
    color: #ffffff;
    box-shadow: 0 4px 10px -4px rgba(47, 111, 235, 0.7);
}
.control input:disabled,
.control select:disabled {
    opacity: 0.72;
    cursor: not-allowed;
}
.control input[aria-invalid="true"],
.control select[aria-invalid="true"] {
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
    text-overflow: ellipsis;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' fill='none' stroke='%235b6780' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 14px center;
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
    -webkit-box-shadow: 0 0 0 100px #ffffff inset, 0 0 0 4px rgba(47, 111, 235, 0.14) !important;
    -webkit-text-fill-color: var(--ink) !important;
}
.control input:autofill {
    box-shadow: 0 0 0 100px var(--field) inset !important;
    -webkit-text-fill-color: var(--ink) !important;
}

.toggle {
    position: absolute;
    right: 6px;
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
    background: #e6ecf7;
    color: var(--navy);
}
.toggle:focus-visible {
    outline: 3px solid rgba(47, 111, 235, 0.35);
}
.toggle .v-icon {
    font-size: 20px;
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
    margin-bottom: 18px;
}
.field-note.is-bad {
    color: var(--danger);
    font-weight: 600;
}

.check {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    margin: 2px 0 26px;
    font-size: 14px;
    font-weight: 500;
    color: #2a3757;
    cursor: pointer;
    user-select: none;
}
.check input {
    width: 18px;
    height: 18px;
    margin: 0;
    accent-color: var(--navy);
    cursor: inherit;
}
.check input:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

/* ---- Primary button: emblem navy, a gold base line, a soft gloss ---- */
.btn {
    position: relative;
    width: 100%;
    height: 52px;
    border: 0;
    border-radius: 14px;
    background: linear-gradient(180deg, #1f3f9c 0%, var(--navy) 55%, var(--navy-deep) 100%);
    color: #ffffff;
    font: inherit;
    font-size: 15px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    overflow: hidden;
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.22),
        inset 0 -2px 0 var(--gold),
        0 10px 22px -12px rgba(22, 48, 124, 0.75);
    transition: transform 0.15s ease, box-shadow 0.2s ease, filter 0.2s ease;
}
.btn:hover:not(:disabled) {
    transform: translateY(-1px);
    filter: brightness(1.06);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.25),
        inset 0 -2px 0 var(--gold),
        0 14px 26px -12px rgba(22, 48, 124, 0.85),
        0 0 0 4px rgba(47, 111, 235, 0.12);
}
.btn:active:not(:disabled) {
    transform: translateY(0);
}
.btn:disabled {
    cursor: not-allowed;
    filter: saturate(0.55) brightness(1.15);
    box-shadow: inset 0 -2px 0 rgba(184, 137, 27, 0.5);
}
.btn.loading {
    cursor: progress;
}
.btn:focus-visible {
    outline: 3px solid rgba(47, 111, 235, 0.4);
    outline-offset: 3px;
}
.btn-arrow {
    font-size: 20px;
    transition: transform 0.2s ease;
}
.btn:hover:not(:disabled) .btn-arrow {
    transform: translateX(3px);
}

/* ---- Divider with the six module dots ---- */
.divider {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 26px 0 18px;
}
.divider-line {
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--line) 30%, var(--line) 70%, transparent);
}
.dots {
    display: flex;
    gap: 6px;
}
.dots i {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    box-shadow: 0 0 0 2px #ffffff, 0 0 8px currentColor;
}

/* ---- Track your transaction: a card-like secondary action ---- */
.track {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 12px 14px;
    border: 1.5px solid #cfdcf3;
    border-radius: 16px;
    background: linear-gradient(180deg, #ffffff 0%, #f6f9ff 100%);
    color: var(--navy);
    font: inherit;
    text-align: left;
    cursor: pointer;
    transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.15s ease;
}
.track:hover:not(:disabled) {
    border-color: #0ea5e9;
    box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.12), 0 10px 22px -16px rgba(14, 165, 233, 0.9);
    transform: translateY(-1px);
}
.track:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}
.track:focus-visible {
    outline: 3px solid rgba(14, 165, 233, 0.4);
    outline-offset: 2px;
}
.track-chip {
    flex: none;
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    border-radius: 12px;
    background: radial-gradient(circle at 35% 30%, #5cc8f5, #0ea5e9 70%);
    color: #ffffff;
    box-shadow: inset 0 -2px 0 rgba(0, 0, 0, 0.12), 0 6px 12px -6px rgba(14, 165, 233, 0.9);
}
.track-chip .v-icon {
    font-size: 21px;
}
.track-text {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
}
.track-text b {
    font-size: 14.5px;
    font-weight: 800;
    letter-spacing: 0.01em;
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
    color: #0ea5e9;
}

.spin {
    width: 18px;
    height: 18px;
    border: 2.5px solid rgba(255, 255, 255, 0.4);
    border-top-color: #ffffff;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}
.spin-dark {
    border-color: rgba(255, 255, 255, 0.45);
    border-top-color: #ffffff;
}
@keyframes spin {
    to { transform: rotate(360deg); }
}

.help {
    margin: 20px 0 0;
    text-align: center;
    font-size: 14px;
    color: var(--muted);
}
.link {
    border: 0;
    padding: 0;
    background: none;
    font: inherit;
    font-weight: 700;
    color: #1e40af;
    cursor: pointer;
}
.link:hover {
    text-decoration: underline;
    text-underline-offset: 3px;
}
.link:focus-visible {
    outline: 3px solid rgba(30, 64, 175, 0.28);
    outline-offset: 2px;
    border-radius: 4px;
}

/* Footer band: always below the form, edge to edge, skyline behind text. */
footer {
    position: relative;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    height: 104px;
    margin: 0 -52px;
    padding: 0 52px 16px;
    font-size: 11.5px;
    font-weight: 700;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--navy);
}
footer span {
    position: relative;
    z-index: 1;
}

/* Skyline + wave along the bottom, very faint. */
.skyline {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
}
.sky-wave {
    fill: rgba(59, 130, 246, 0.08);
}
.sky-city {
    fill: rgba(59, 130, 246, 0.1);
}
.sky-palm {
    fill: none;
    stroke: rgba(59, 130, 246, 0.14);
    stroke-width: 2.2;
    stroke-linecap: round;
}

/* ---- Right: artwork with glow effects (LoginHero) ---- */
/* Pinned: a long Create account form scrolls past it, the artwork stays. */
.hero {
    position: sticky;
    top: 0;
    align-self: start;
    height: 100vh;
    overflow: hidden;
    background: var(--sky);
}

/* Shorter screens (e.g. 1366x768, 1280x720 laptops): tighter vertical
   rhythm so Sign in fits without scrolling. */
@media (max-height: 800px) and (min-width: 861px) {
    .side {
        padding-top: 24px;
    }
    .brand-mark {
        width: 70px;
        height: 70px;
    }
    .seal {
        width: 62px;
        height: 64px;
    }
    .brand-rule {
        height: 52px;
    }
    .brand-name {
        font-size: 25px;
    }
    .panel {
        padding: 18px 0 12px;
    }
    .switch {
        margin-bottom: 18px;
    }
    .pane h2 {
        font-size: 24px;
    }
    .sub {
        margin-bottom: 16px;
    }
    .field {
        margin-bottom: 14px;
    }
    .field-note {
        margin-bottom: 14px;
    }
    .control input,
    .control select {
        height: 46px;
    }
    .check {
        margin-bottom: 18px;
    }
    .btn {
        height: 48px;
    }
    .divider {
        margin: 16px 0 12px;
    }
    footer {
        height: 64px;
        padding-bottom: 12px;
    }
}

@keyframes rise {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: none; }
}

@media (max-width: 860px) {
    .login-shell {
        grid-template-columns: 1fr;
    }
    .hero {
        display: none;
    }
    .side {
        padding: 28px 22px 0;
        box-shadow: none;
    }
    footer {
        margin: 0 -22px;
        padding: 0 22px 14px;
    }
}

/* Phones: a tighter lockup, and the paired fields stack. */
@media (max-width: 440px) {
    .brand {
        gap: 12px;
    }
    .brand-mark {
        width: 68px;
        height: 68px;
    }
    .seal {
        width: 60px;
        height: 62px;
    }
    .brand-rule {
        height: 52px;
    }
    .brand-city {
        font-size: 9.5px;
        letter-spacing: 0.12em;
    }
    .brand-name {
        font-size: 24px;
    }
    .brand-motto {
        font-size: 12.5px;
    }
    .grid-2 {
        grid-template-columns: 1fr;
    }
    .grid-2 .field + .field {
        margin-top: 18px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .control input,
    .control select,
    .chip,
    .btn,
    .track,
    .switch-ink {
        transition: none !important;
    }
    .brand-mark,
    .brand-rule,
    .brand-text,
    .panel,
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
