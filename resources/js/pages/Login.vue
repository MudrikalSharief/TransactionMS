<template>
    <div class="login-shell">
        <section class="side">
            <header class="brand">
                <img
                    class="seal"
                    :src="'/zamboanga-seal.png'"
                    alt="City Government of Zamboanga seal"
                    width="64"
                    height="64"
                />
                <div>
                    <h1>TransactionMF</h1>
                    <p>City Government of Zamboanga</p>
                </div>
            </header>

            <main class="panel">
                <h2>Sign in</h2>
                <p class="sub">Use your city government account to continue.</p>

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

                <p class="help">
                    Need an account? Contact your department's system administrator.
                </p>
            </main>

            <footer>
                <span>© City Government of Zamboanga</span>
                <span>Authorized users only</span>
            </footer>
        </section>

        <aside class="hero" aria-label="Available modules">
            <video
                v-if="showHeroVideo"
                class="hero-video"
                :src="'/loginpage.mp4'"
                autoplay
                muted
                loop
                playsinline
                preload="metadata"
                aria-hidden="true"
                tabindex="-1"
            ></video>

            <div class="hero-content">
                <h3>One place for city transactions</h3>
                <p>Process requests, approvals and records across departments.</p>
                <ul class="mods">
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-file-document-edit-outline</v-icon>
                        PR
                    </li>
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
                        <v-icon aria-hidden="true">mdi-calendar-check-outline</v-icon>
                        Leave
                    </li>
                    <li class="mod">
                        <v-icon aria-hidden="true">mdi-airplane</v-icon>
                        Travel Order
                    </li>
                </ul>
            </div>
        </aside>
    </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuth } from "@/composables/useAuth";

const router = useRouter();
const auth = useAuth();

const email = ref("");
const password = ref("");
const showPassword = ref(false);
const remember = ref(false);

const loading = ref(false);
const error = ref("");
const errorKey = ref(0);

// Looping background clip for the photo panel. Rendered only at >=861px
// (mirroring the CSS breakpoint that hides the hero on phones), so small
// screens never download the multi-MB video for a panel they can't see.
const showHeroVideo = ref(false);
let heroMq = null;
function syncHeroVideo(e) {
    showHeroVideo.value = e.matches;
}

onMounted(() => {
    heroMq = window.matchMedia("(min-width: 861px)");
    showHeroVideo.value = heroMq.matches;
    heroMq.addEventListener("change", syncHeroVideo);
});

onUnmounted(() => {
    heroMq?.removeEventListener("change", syncHeroVideo);
});

const canSubmit = computed(
    () => !loading.value && email.value.trim().length > 0 && password.value.length > 0,
);

async function submit() {
    if (!canSubmit.value) return;
    loading.value = true;
    error.value = "";

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
    font-family: 'Public Sans', system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
    scrollbar-width: none;
    -ms-overflow-style: none;
}
.login-shell::-webkit-scrollbar {
    display: none;
    width: 0;
}

/* ---- Left: form panel ---- */
.side {
    background: #ffffff;
    display: flex;
    flex-direction: column;
    padding: 40px 48px;
    border-right: 1px solid #d5dbe8;
    min-width: 0;
}

.brand {
    display: flex;
    align-items: center;
    gap: 16px;
}
.seal {
    width: 64px;
    height: 64px;
    flex: none;
}
.brand h1 {
    margin: 0;
    font-size: 26px;
    line-height: 1.1;
    font-weight: 800;
    color: #1E40AF;
    letter-spacing: -0.01em;
}
.brand p {
    margin: 4px 0 0;
    font-size: 13px;
    font-weight: 600;
    color: #5b6780;
}

.panel {
    margin: auto 0;
    padding: 48px 0 24px;
    width: 100%;
}
.panel h2 {
    margin: 0 0 6px;
    font-size: 28px;
    font-weight: 700;
    letter-spacing: -0.015em;
}
.sub {
    margin: 0 0 28px;
    color: #5b6780;
    font-size: 15px;
}

.error {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #fdecea;
    color: #b42318;
    border-radius: 10px;
    padding: 12px 14px;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 18px;
}
.error .v-icon {
    font-size: 20px;
    flex: none;
}

.field {
    margin-bottom: 20px;
}
.field label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    margin: 0 0 8px;
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
    height: 52px;
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
    border-color: #1E40AF;
    background: #ffffff;
    box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.22);
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
    right: 6px;
    top: 50%;
    transform: translateY(-50%);
    width: 40px;
    height: 40px;
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
    outline: 3px solid rgba(30, 64, 175, 0.28);
}
.toggle .v-icon {
    font-size: 20px;
}

.row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: -4px 0 24px;
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
    accent-color: #1E40AF;
    cursor: inherit;
}
.check input:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn {
    width: 100%;
    height: 54px;
    border: 0;
    border-radius: 12px;
    background: #1E40AF;
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
    outline: 3px solid rgba(30, 64, 175, 0.28);
    outline-offset: 2px;
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
    margin: 20px 0 0;
    text-align: center;
    font-size: 14px;
    color: #5b6780;
}

footer {
    font-size: 12.5px;
    color: #5b6780;
    display: flex;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
}

/* ---- Right: photo/video hero ---- */
.hero {
    position: relative;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 56px;
    color: #ffffff;
    /* Photo fallback: paints before the clip buffers, when autoplay is
       blocked, and for reduced-motion users (video hidden there). */
    background: url('/loginpage.jpg') center / cover no-repeat;
}
.hero-video {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    z-index: 0;
}
/* Legibility scrim: above the video, below the text/pills. */
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
    color: #1E40AF;
    border-radius: 14px;
    padding: 12px 14px;
    font-weight: 700;
    font-size: 14.5px;
    box-shadow: 0 6px 18px rgba(8, 20, 60, 0.25);
}
.mod .v-icon {
    font-size: 22px;
    color: #1E40AF;
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

@media (max-width: 860px) {
    .login-shell {
        grid-template-columns: 1fr;
    }
    .hero {
        display: none;
    }
    .side {
        padding: 28px 22px;
        border-right: 0;
    }
}

@media (prefers-reduced-motion: reduce) {
    /* An autoplaying loop is exactly what these users opted out of:
       keep the static photo instead. */
    .hero-video {
        display: none;
    }
    .control input,
    .toggle,
    .btn {
        transition: none !important;
    }
}
</style>
