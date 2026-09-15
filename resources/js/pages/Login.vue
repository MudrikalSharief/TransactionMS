<template>
    <div class="login-sky fill-height d-flex align-center">
        <div class="top-icons" aria-hidden="true">
            <span class="float-chip"><v-icon>mdi-file-document-outline</v-icon></span>
            <span class="float-chip"><v-icon>mdi-city</v-icon></span>
            <span class="float-chip"><v-icon>mdi-check-decagram</v-icon></span>
            <span class="float-chip"><v-icon>mdi-shield-check</v-icon></span>
            <span class="float-chip"><v-icon>mdi-medal</v-icon></span>
            <span class="float-chip"><v-icon>mdi-office-building-outline</v-icon></span>
        </div>

        <v-card class="login-card" elevation="0">
            <div class="login-inner">
            <div class="brand-row">
                <div class="seal-wrap">
                    <v-img
                        src="/zamboanga-seal.png"
                        alt="Zamboanga Seal"
                        width="72"
                        height="72"
                        class="logo-seal"
                    />
                </div>
                <h1 class="brand-logo brand-left" aria-label="LGU Transaction System">
                    <span class="brand-main">TransactionMS</span>
                    <span class="brand-sub">TRANSACTION MANAGEMENT SYSTEM</span>
                </h1>
            </div>
            <div class="brand-rule" aria-hidden="true"></div>

            <v-alert
                v-if="error"
                type="error"
                variant="tonal"
                rounded="lg"
                class="mb-4 font-weight-bold"
            >
                {{ error }}
            </v-alert>

            <v-form @submit.prevent="submit">
                <label class="field-label" for="login-email">Email</label>
                <v-text-field
                    id="login-email"
                    v-model="email"
                    placeholder="you@example.com"
                    aria-label="Email"
                    type="email"
                    autocomplete="username"
                    variant="solo"
                    bg-color="#f1f5f9"
                    rounded="lg"
                    flat
                    hide-details="auto"
                    prepend-inner-icon="mdi-email-outline"
                    class="login-field mb-4"
                    required
                />
                <label class="field-label" for="login-password">Password</label>
                <v-text-field
                    id="login-password"
                    v-model="password"
                    placeholder="Enter your password"
                    aria-label="Password"
                    :type="showPassword ? 'text' : 'password'"
                    autocomplete="current-password"
                    :append-inner-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                    @click:append-inner="showPassword = !showPassword"
                    variant="solo"
                    bg-color="#f1f5f9"
                    rounded="lg"
                    flat
                    hide-details="auto"
                    prepend-inner-icon="mdi-lock-outline"
                    class="login-field mb-4"
                    required
                />

                <v-btn
                    type="submit"
                    block
                    rounded="pill"
                    size="large"
                    :loading="loading"
                    class="login-btn font-weight-bold"
                >
                    <v-icon start>mdi-login</v-icon>
                    Login
                </v-btn>
            </v-form>

            <v-divider class="my-4" />

            <div class="login-extra">
                <p class="extra-title">Secure LGU portal for Zamboanga City</p>
                <div class="extra-features">
                    <div class="extra-item">
                        <v-icon>mdi-file-search-outline</v-icon>
                        <span>Track requests end-to-end</span>
                    </div>
                    <div class="extra-item">
                        <v-icon>mdi-shield-check-outline</v-icon>
                        <span>Verified, role-based workflows</span>
                    </div>
                    <div class="extra-item">
                        <v-icon>mdi-bell-ring-outline</v-icon>
                        <span>Status updates at every step</span>
                    </div>
                </div>
                <p class="extra-foot">Need help? Visit the City Hall help desk or contact support.</p>
            </div>
            <p class="copyright">© City Government of Zamboanga · TransactionMS</p>
            </div>
        </v-card>
    </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuth } from "@/composables/useAuth";

const router = useRouter();
const auth = useAuth();

const email = ref("");
const password = ref("");
const showPassword = ref(false);

const loading = ref(false);
const error = ref("");

async function submit() {
    loading.value = true;
    error.value = "";

    try {
        await auth.login({
            email: email.value,
            password: password.value,
            remember: false,
        });

        await auth.init();

        await router.push({ name: "dashboard" });
    } catch (e) {
        const msg =
            e?.response?.data?.message ||
            e?.response?.data?.errors?.email?.[0] ||
            "Login failed.";
        error.value = msg;
    } finally {
        loading.value = false;
    }
}
</script>

<style scoped>
.login-sky {
    position: relative;
    overflow: hidden;
    min-height: 100vh;
    background: url('/loginpage.jpg') center / cover no-repeat;
    font-family: 'M PLUS Rounded 1c', sans-serif;
    justify-content: flex-start;
    align-items: center;
    padding: 16px 16px 16px 4vw;
}
.login-sky > * {
    position: relative;
    z-index: 1;
}

/* Right-side icon field: scattered organically over the photo area */
.top-icons {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 40%;
    right: 0;
    z-index: 2;
    pointer-events: none;
}

/* Floating icon chips */
.float-chip {
    position: absolute;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.92);
    color: #7C3AED;
    border-radius: 20px;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.22);
    pointer-events: none;
    animation: floaty 5s ease-in-out infinite;
}
.top-icons .float-chip:nth-child(1) {
    top: 10%;
    left: 12%;
    width: 76px;
    height: 76px;
}
.top-icons .float-chip:nth-child(2) {
    top: 18%;
    right: 10%;
    width: 60px;
    height: 60px;
    color: #4caf50;
    border-radius: 50%;
    animation-delay: 1.2s;
}
.top-icons .float-chip:nth-child(3) {
    top: 44%;
    left: 30%;
    width: 68px;
    height: 68px;
    color: #ffb300;
    animation-delay: 2.1s;
}
.top-icons .float-chip:nth-child(4) {
    top: 58%;
    right: 18%;
    width: 80px;
    height: 80px;
    color: #8B5CF6;
    border-radius: 50%;
    animation-delay: 0.6s;
}
.top-icons .float-chip:nth-child(5) {
    bottom: 10%;
    left: 10%;
    width: 64px;
    height: 64px;
    color: #ff7043;
    animation-delay: 1.7s;
}
.top-icons .float-chip:nth-child(6) {
    bottom: 22%;
    right: 8%;
    width: 72px;
    height: 72px;
    color: #0288d1;
    border-radius: 50%;
    animation-delay: 2.6s;
}

.login-card {
    position: relative;
    z-index: 1;
    width: 40%;
    max-width: 500px;
    min-width: 400px;
    min-height: 0;
    max-height: calc(100vh - 32px);
    margin: 0;
    border-radius: 24px !important;
    background: rgba(255, 255, 255, 0.68);
    backdrop-filter: blur(18px) saturate(1.2);
    -webkit-backdrop-filter: blur(18px) saturate(1.2);
    box-shadow: 0 24px 60px rgba(15, 23, 42, 0.22) !important;
    border: 1px solid rgba(255, 255, 255, 0.65);
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    overflow: hidden;
}

.login-inner {
    width: 100%;
    max-width: none;
    margin: 0;
    padding: 20px 26px;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    min-height: 0;
}

.brand-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 2px;
}

.seal-wrap {
    width: 92px;
    height: 92px;
    flex-shrink: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.9);
    padding: 5px;
    box-shadow: 0 10px 28px rgba(124, 58, 237, 0.28), 0 0 0 6px rgba(124, 58, 237, 0.1);
}

.logo-seal {
    border-radius: 50%;
}

/* Pixiv-style wordmark logo */
.brand-logo {
    display: flex;
    flex-direction: column;
    align-items: center;
    line-height: 1;
    margin-top: 0;
}
.brand-logo.brand-left {
    align-items: flex-start;
    text-align: left;
}
.brand-logo.brand-left .brand-sub {
    text-indent: 0;
}
.brand-main {
    font-family: 'M PLUS Rounded 1c', sans-serif;
    font-weight: 800;
    font-size: clamp(2rem, 2.6vw, 2.5rem);
    letter-spacing: 0.02em;
    color: #7C3AED;
    text-shadow: 0 3px 0 rgba(124, 58, 237, 0.15);
    white-space: nowrap;
}
.brand-sub {
    margin-top: 6px;
    font-family: 'M PLUS Rounded 1c', sans-serif;
    font-weight: 800;
    font-size: 0.82rem;
    letter-spacing: 0.14em;
    text-indent: 0.14em;
    color: #7C3AED;
}
.brand-rule {
    display: block;
    height: 0;
    margin: 12px 0 18px;
    border: none;
    border-top: 2px solid #7C3AED;
    opacity: 0.6;
}

.field-label {
    display: block;
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #475569;
    margin-bottom: 6px;
}

.login-field :deep(.v-input__control),
.login-field :deep(.v-field),
.login-field :deep(.v-field__overlay),
.login-field :deep(.v-field__underlay),
.login-field :deep(.v-field__loader) {
    border-radius: 14px !important;
}
.login-field :deep(.v-field) {
    overflow: hidden;
    box-shadow: inset 0 2px 6px rgba(15, 23, 42, 0.06);
    font-weight: 700;
    border: 1.5px solid transparent;
    outline: none;
    min-height: 54px;
    transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
}
.login-field :deep(.v-field__input) {
    min-height: 54px;
    font-size: 0.98rem;
}
.login-field :deep(.v-field:hover) {
    border-color: #C4B5FD;
}
.login-field :deep(.v-field--focused) {
    border-color: #7C3AED;
    box-shadow: inset 0 2px 6px rgba(15, 23, 42, 0.06), 0 0 0 3px rgba(124, 58, 237, 0.18);
    transform: translateY(-1px);
}
.login-field :deep(.v-field__prepend-inner .v-icon) {
    color: #7C3AED;
    opacity: 0.9;
}
.login-field :deep(.v-field__append-inner .v-icon) {
    color: #64748b;
}

.login-field :deep(input),
.login-field :deep(input::placeholder) {
    font-family: 'M PLUS Rounded 1c', sans-serif;
    font-weight: 700;
}

.login-extra {
    background: rgba(248, 250, 252, 0.75);
    border: 1px solid rgba(226, 232, 240, 0.9);
    border-radius: 14px;
    padding: 12px 14px;
    color: #475569;
}
.extra-title {
    font-weight: 800;
    font-size: 0.88rem;
    color: #334155;
    margin-bottom: 10px;
}
.extra-features {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 8px 16px;
    margin-bottom: 10px;
}
.extra-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 0.82rem;
    font-weight: 700;
    color: #475569;
    white-space: nowrap;
}
.extra-item .v-icon {
    color: #7C3AED;
}
.extra-foot {
    font-size: 0.78rem;
    color: #94a3b8;
}
.copyright {
    margin-top: 14px;
    font-size: 0.72rem;
    color: #94a3b8;
    text-align: center;
}

.login-btn {
    position: relative;
    overflow: hidden;
    background: linear-gradient(135deg, #7C3AED 0%, #7C3AED 60%, #6D28D9 100%) !important;
    color: #ffffff !important;
    letter-spacing: 0.06em;
    box-shadow: 0 10px 22px rgba(124, 58, 237, 0.45) !important;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.login-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 28px rgba(124, 58, 237, 0.5) !important;
}
.login-btn:active {
    transform: translateY(0) scale(0.98);
}
.login-btn::after {
    content: "";
    position: absolute;
    top: -60%;
    bottom: -60%;
    left: -30%;
    width: 36px;
    background: linear-gradient(105deg, transparent, rgba(255, 255, 255, 0.55), transparent);
    transform: skewX(-20deg);
    animation: btn-sheen 3.2s ease-in-out infinite;
    pointer-events: none;
}

@keyframes floaty {
    0%,
    100% {
        transform: translateY(0) rotate(-4deg);
    }
    50% {
        transform: translateY(-14px) rotate(4deg);
    }
}

@keyframes btn-sheen {
    0% {
        left: -30%;
        opacity: 0;
    }
    12% {
        opacity: 1;
    }
    45%,
    100% {
        left: 130%;
        opacity: 0;
    }
}

@keyframes card-glow {
    0%,
    100% {
        box-shadow: 0 24px 60px rgba(76, 29, 149, 0.16), 0 0 50px rgba(124, 58, 237, 0.16) !important;
    }
    50% {
        box-shadow: 0 24px 60px rgba(76, 29, 149, 0.2), 0 0 95px rgba(124, 58, 237, 0.32) !important;
    }
}

@media (max-width: 900px) {
    .login-sky {
        justify-content: center;
        padding: 24px 16px;
    }
    .top-icons {
        display: none;
    }
    .login-card {
        width: 100%;
        min-width: 0;
        max-width: 520px;
        min-height: 0;
        margin: auto;
        border-radius: 28px !important;
        border-right: none;
        border: 1px solid #e3ecf5;
    }
    .login-inner {
        min-height: 0;
        padding: 32px 24px;
    }
    .seal-wrap {
        width: 88px;
        height: 88px;
    }
}
</style>
