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
                        width="60"
                        height="62"
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

            <main v-if="mode === 'signin'" class="panel">
                <h2>Sign in</h2>
                <p class="sub">Use your city government account to continue.</p>

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
                        <label for="login-email">Email</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-email-outline</v-icon>
                            <input
                                id="login-email"
                                v-model.trim="email"
                                type="email"
                                name="username"
                                placeholder="name@zamboanga.gov.ph"
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
                            <v-icon class="ic" aria-hidden="true">mdi-lock-outline</v-icon>
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
                                <v-icon>{{
                                    showPassword ? "mdi-eye-off-outline" : "mdi-eye-outline"
                                }}</v-icon>
                            </button>
                        </div>
                    </div>

                    <div class="row">
                        <label class="check">
                            <input v-model="remember" type="checkbox" :disabled="loading" />
                            Keep me signed in
                        </label>
                    </div>

                    <button class="btn" :class="{ loading }" type="submit" :disabled="!canSubmit">
                        <span v-if="loading" class="spin" aria-hidden="true"></span>
                        <span>{{ loading ? "Signing in…" : "Sign in" }}</span>
                    </button>
                </form>

                <button
                    class="btn btn-guest"
                    :class="{ loading: guestLoading }"
                    type="button"
                    :disabled="loading || guestLoading"
                    @click="guestLogin"
                >
                    <span v-if="guestLoading" class="spin spin-dark" aria-hidden="true"></span>
                    <v-icon v-else aria-hidden="true">mdi-file-search-outline</v-icon>
                    <span>{{ guestLoading ? "Opening tracker…" : "Track your Document Process" }}</span>
                </button>
                <p class="guest-note">View-only. No account or sign-in needed.</p>

                <p class="help">
                    Need an account?
                    <button type="button" class="link" @click="openRegister">Create an account</button>
                </p>
            </main>

            <!-- Create an account: the same details a superadmin enters for a
                 new user, plus a contact number. It waits for approval. -->
            <main v-else class="panel">
                <h2>Create an account</h2>
                <p class="sub">An administrator reviews new accounts. You can sign in once yours is approved.</p>

                <div v-if="regError" :key="errorKey" class="error" role="alert" aria-live="assertive">
                    <v-icon aria-hidden="true">mdi-alert-circle-outline</v-icon>
                    <span>{{ regError }}</span>
                </div>

                <form novalidate :aria-busy="registering ? 'true' : 'false'" @submit.prevent="register">
                    <div class="field">
                        <label for="reg-name">Full name</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-account-outline</v-icon>
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
                        <label for="reg-email">Email</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-email-outline</v-icon>
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
                        <label for="reg-contact">Contact number</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-phone-outline</v-icon>
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
                        <p v-if="fieldErrors.contact_number" class="field-error">{{ fieldErrors.contact_number }}</p>
                    </div>

                    <div class="field">
                        <label for="reg-password">Password</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-lock-outline</v-icon>
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

                    <div class="field">
                        <label for="reg-office">Office</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-office-building-outline</v-icon>
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

                    <div class="field">
                        <label for="reg-role">Role</label>
                        <div class="control">
                            <v-icon class="ic" aria-hidden="true">mdi-badge-account-horizontal-outline</v-icon>
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
                        <span>{{ registering ? "Creating account…" : "Create account" }}</span>
                    </button>
                </form>

                <p class="help">
                    Already have an account?
                    <button type="button" class="link" @click="openSignIn">Sign in</button>
                </p>
            </main>

            <footer>
                <span>City Government of Zamboanga</span>
            </footer>
        </section>

        <aside class="hero" aria-label="Available modules">
            <div class="hero-content">
                <h3>One place for city transactions</h3>
                <p>Process requests, approvals and records across departments.</p>
                <ul class="mods">
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-cart-outline</v-icon>
                        Procurement
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-cash-multiple</v-icon>
                        Payroll
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-receipt-text-outline</v-icon>
                        Disbursement
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-chart-pie</v-icon>
                        Budget
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-file-certificate-outline</v-icon>
                        Permits
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-file-document-multiple-outline</v-icon>
                        Records
                    </li>
                </ul>
            </div>
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

const router = useRouter();
const auth = useAuth();
const { api, csrf } = useApi();

// "signin" or "register" (Create an account), in the same panel.
const mode = ref("signin");
const notice = ref("");

const email = ref("");
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
    () => !loading.value && !guestLoading.value && email.value.trim().length > 0 && password.value.length > 0,
);

async function submit() {
    if (!canSubmit.value) return;
    loading.value = true;
    error.value = "";
    notice.value = "";

    try {
        await auth.login({
            email: email.value.trim(),
            password: password.value,
            remember: remember.value,
        });

        await auth.init();

        await router.push({ name: "dashboard" });
    } catch (e) {
        const msg =
            e?.response?.data?.message ||
            e?.response?.data?.errors?.email?.[0] ||
            "Login failed. Please check your credentials and try again.";
        error.value = msg;
        errorKey.value += 1;
    } finally {
        loading.value = false;
    }
}

// ---- Create an account ----------------------------------------------------

const emptyReg = () => ({ name: "", email: "", contact_number: "", password: "", office_id: null, role_id: null });
const reg = ref(emptyReg());
const options = ref({ offices: [], roles: [] });
const registering = ref(false);
const regError = ref("");
const fieldErrors = ref({});

const canRegister = computed(
    () =>
        !registering.value &&
        reg.value.name &&
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
            email: reg.value.email,
            contact_number: reg.value.contact_number,
            password: reg.value.password,
            office_id: reg.value.office_id,
            role_ids: [reg.value.role_id],
        });
        // Back to sign in, email filled in, with what happens next.
        email.value = reg.value.email;
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
            e?.response?.data?.message || "Document tracking is not available right now.";
        errorKey.value += 1;
    } finally {
        guestLoading.value = false;
    }
}
</script>

<style scoped>
.login-shell {
    position: fixed;
    inset: 0;
    display: grid;
    grid-template-columns: minmax(360px, 480px) 1fr;
    overflow: auto;
    background: #ffffff;
    color: #14213d;
    font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
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
    border-top-color: #16307C;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

/* ---- Left: form panel ---- */
.side {
    background: #ffffff;
    display: flex;
    flex-direction: column;
    padding: 28px 40px;
    border-right: 1px solid #d5dbe8;
    min-width: 0;
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
    width: 68px;
    height: 68px;
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
    width: 60px;
    height: 62px;
    object-fit: contain;
    filter: drop-shadow(0 6px 10px rgba(22, 48, 124, 0.22));
}
/* Gold rule between emblem and name, drawn top to bottom. */
.brand-rule {
    flex: none;
    width: 1.5px;
    height: 50px;
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
    font-size: 26px;
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
    margin: 4px 0 0;
    font-family: 'Iowan Old Style', 'Palatino Linotype', Palatino, 'Book Antiqua', Georgia, serif;
    font-size: 12.5px;
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
    from {
        opacity: 0;
        transform: scale(0.9);
    }
    to {
        opacity: 1;
        transform: none;
    }
}
@keyframes brand-rule {
    from {
        transform: scaleY(0);
    }
    to {
        transform: none;
    }
}
@keyframes brand-text {
    from {
        opacity: 0;
        transform: translateX(-8px);
    }
    to {
        opacity: 1;
        transform: none;
    }
}

.panel {
    margin: auto 0;
    padding: 24px 0;
    width: 100%;
}
.panel h2 {
    margin: 0 0 4px;
    font-size: 26px;
    font-weight: 700;
    letter-spacing: -0.015em;
}
.sub {
    margin: 0 0 18px;
    color: #5b6780;
    font-size: 14px;
}

.error {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #fdecea;
    color: #b42318;
    border-radius: 10px;
    padding: 10px 12px;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 14px;
}
.error .v-icon {
    font-size: 20px;
    flex: none;
}

.field {
    margin-bottom: 14px;
}
.field label {
    display: block;
    font-size: 12.5px;
    font-weight: 600;
    margin: 0 0 6px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
}
.control {
    position: relative;
}
.control .ic {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 20px;
    color: #5b6780;
    pointer-events: none;
}
.control input {
    width: 100%;
    height: 46px;
    border: 1.5px solid #d5dbe8;
    border-radius: 12px;
    background: #f3f5fb;
    color: #14213d;
    font: inherit;
    font-size: 16px;
    padding: 0 48px 0 46px;
    transition: border-color 0.15s ease, box-shadow 0.15s ease, background 0.15s ease;
}
.control input::placeholder {
    color: #7b869e;
}
.control input:hover:not(:disabled) {
    border-color: #aab4cc;
}
.control input:focus {
    outline: none;
    border-color: #16307C;
    background: #ffffff;
    box-shadow: 0 0 0 4px rgba(22, 48, 124, 0.22);
}
.control input:disabled {
    opacity: 0.72;
    cursor: not-allowed;
}

/* Autofill: keep the field's own colors instead of Chrome's yellow/blue wash */
.control input:-webkit-autofill,
.control input:-webkit-autofill:hover,
.control input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 100px #f3f5fb inset !important;
    -webkit-text-fill-color: #14213d !important;
    caret-color: #14213d !important;
    transition: background-color 5000s ease-in-out 0s !important;
}
.control input:-webkit-autofill:focus {
    -webkit-box-shadow: 0 0 0 100px #ffffff inset !important;
    -webkit-text-fill-color: #14213d !important;
}
.control input:autofill {
    box-shadow: 0 0 0 100px #f3f5fb inset !important;
    -webkit-text-fill-color: #14213d !important;
}

.toggle {
    position: absolute;
    right: 5px;
    top: 50%;
    transform: translateY(-50%);
    width: 36px;
    height: 36px;
    border: 0;
    background: none;
    border-radius: 10px;
    color: #5b6780;
    cursor: pointer;
    display: grid;
    place-items: center;
}
.toggle:hover {
    background: #e6ebf5;
}
.toggle:focus-visible {
    outline: 3px solid rgba(22, 48, 124, 0.28);
}
.toggle .v-icon {
    font-size: 20px;
}

.row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 12px 0 26px;
    font-size: 14px;
}
.check {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    margin: 0;
    cursor: pointer;
    user-select: none;
}
.check input {
    width: 18px;
    height: 18px;
    padding: 0;
    margin: 0;
    accent-color: #16307C;
    cursor: inherit;
}
.check input:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn {
    width: 100%;
    height: 48px;
    border: 0;
    border-radius: 12px;
    background: #16307C;
    color: #ffffff;
    font: inherit;
    font-size: 16px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    transition: background 0.15s ease, transform 0.05s ease;
    text-transform: uppercase;
    letter-spacing: 0.06em;
}
.btn:hover:not(:disabled) {
    background: #142d82;
}
.btn:active:not(:disabled) {
    transform: translateY(1px);
}
.btn:disabled {
    opacity: 0.75;
    cursor: not-allowed;
}
.btn.loading {
    cursor: progress;
}
.btn:focus-visible {
    outline: 3px solid rgba(22, 48, 124, 0.28);
    outline-offset: 2px;
}

.btn-guest {
    margin-top: 14px;
    background: #ffffff;
    color: #1E40AF;
    border: 1.5px solid #1E40AF;
}
.btn-guest:hover:not(:disabled) {
    background: #eef2ff;
}
.btn-guest .v-icon {
    font-size: 22px;
}
.guest-note {
    margin: 8px 0 0;
    text-align: center;
    font-size: 12.5px;
    color: #5b6780;
}
.spin-dark {
    border-color: rgba(30, 64, 175, 0.25);
    border-top-color: #1E40AF;
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
    to {
        transform: rotate(360deg);
    }
}

.help {
    margin: 14px 0 0;
    text-align: center;
    font-size: 13.5px;
    color: #5b6780;
}

/* ---- Create an account ---- */
.link {
    border: 0;
    padding: 0;
    background: none;
    font: inherit;
    font-weight: 700;
    color: #1E40AF;
    cursor: pointer;
}
.link:hover {
    text-decoration: underline;
}
.link:focus-visible {
    outline: 3px solid rgba(30, 64, 175, 0.28);
    outline-offset: 2px;
    border-radius: 4px;
}
.notice {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #e7f5ec;
    color: #1d6b3c;
    border-radius: 10px;
    padding: 10px 12px;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 14px;
}
.notice .v-icon {
    font-size: 20px;
    flex: none;
}
/* Selects match the text inputs, with their own chevron. */
.control select {
    width: 100%;
    height: 46px;
    border: 1.5px solid #d5dbe8;
    border-radius: 12px;
    background:
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' fill='none' stroke='%235b6780' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E")
            no-repeat right 18px center,
        #f3f5fb;
    color: #14213d;
    font: inherit;
    font-size: 16px;
    padding: 0 44px 0 46px;
    appearance: none;
    cursor: pointer;
    transition: border-color 0.15s ease, box-shadow 0.15s ease, background-color 0.15s ease;
}
.control select:hover:not(:disabled) {
    border-color: #aab4cc;
}
.control select:focus {
    outline: none;
    border-color: #1E40AF;
    background-color: #ffffff;
    box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.22);
}
.control select:disabled {
    opacity: 0.72;
    cursor: not-allowed;
}
.control input[aria-invalid="true"],
.control select[aria-invalid="true"] {
    border-color: #b42318;
}
.field-error {
    margin: 6px 0 0;
    font-size: 13px;
    color: #b42318;
}

footer {
    font-size: 12px;
    color: #16307C;
    display: flex;
    justify-content: center;
    gap: 12px;
    flex-wrap: wrap;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

/* ---- Right: photo hero ---- */
.hero {
    position: relative;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 56px;
    color: #ffffff;
    background: url('/loginpage.jpg') center / cover no-repeat;
}
/* Legibility scrim: above the photo, below the text/pills. */
.hero::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 1;
    background: linear-gradient(180deg, rgba(10, 25, 70, 0.15) 0%, rgba(10, 25, 70, 0.75) 100%);
    pointer-events: none;
}
.hero-content {
    position: relative;
    z-index: 2;
}
.hero h3 {
    margin: 0 0 8px;
    font-size: 34px;
    line-height: 1.15;
    font-weight: 800;
    letter-spacing: -0.02em;
    max-width: 18ch;
}
.hero p {
    margin: 0 0 28px;
    font-size: 16px;
    max-width: 44ch;
    color: rgba(255, 255, 255, 0.9);
}
.mods {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
    max-width: 560px;
    margin: 0;
    padding: 0;
    list-style: none;
}
.mod {
    display: flex;
    align-items: center;
    gap: 10px;
    background: rgba(255, 255, 255, 0.94);
    color: #16307C;
    border-radius: 14px;
    padding: 12px 14px;
    font-weight: 700;
    font-size: 13.5px;
    box-shadow: 0 6px 18px rgba(8, 20, 60, 0.25);
    text-transform: uppercase;
    letter-spacing: 0.04em;
}
.mod .v-icon {
    font-size: 22px;
    color: #16307C;
    flex: none;
}

@media (max-width: 1200px) {
    .hero {
        padding: 40px;
    }
    .mods {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

/* Short laptop screens: trim the lockup and spacing further so the
   sign-in form fits the viewport without scrolling. */
@media (max-height: 760px) and (min-width: 861px) {
    .side {
        padding: 20px 32px;
    }
    .brand-mark {
        width: 56px;
        height: 56px;
    }
    .seal {
        width: 50px;
        height: 52px;
    }
    .brand-rule {
        height: 42px;
    }
    .brand-name {
        font-size: 23px;
    }
    .panel {
        padding: 12px 0;
    }
    .field {
        margin-bottom: 10px;
    }
    .control input,
    .control select {
        height: 42px;
    }
    .row {
        margin: 8px 0 18px;
    }
    .btn {
        height: 44px;
    }
    .btn-guest {
        margin-top: 10px;
    }
    .guest-note {
        margin-top: 6px;
    }
    .help {
        margin-top: 10px;
    }
}

@media (max-width: 860px) {
    .login-shell {
        grid-template-columns: 1fr;
    }
    .hero {
        display: none;
    }
    .side {
        padding: 22px 18px;
        border-right: 0;
    }
}

/* Phones: a tighter lockup so the city line never reaches the edge. */
@media (max-width: 440px) {
    .brand {
        gap: 10px;
    }
    .brand-mark {
        width: 58px;
        height: 58px;
    }
    .seal {
        width: 52px;
        height: 54px;
    }
    .brand-rule {
        height: 44px;
    }
    .brand-city {
        font-size: 9.5px;
        letter-spacing: 0.12em;
    }
    .brand-name {
        font-size: 22px;
    }
    .brand-motto {
        font-size: 12px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .control input,
    .toggle,
    .btn {
        transition: none !important;
    }
    .brand-mark,
    .brand-rule,
    .brand-text {
        animation: none;
    }
}
</style>
