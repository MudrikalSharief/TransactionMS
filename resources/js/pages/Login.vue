<template>
    <div class="login-sky">
        <div class="top-icons" aria-hidden="true">
            <span class="float-chip"><v-icon>mdi-file-document-edit-outline</v-icon><span class="chip-label">PR</span></span>
            <span class="float-chip"><v-icon>mdi-cart-outline</v-icon><span class="chip-label">Procurement</span></span>
            <span class="float-chip"><v-icon>mdi-cash-multiple</v-icon><span class="chip-label">Payroll</span></span>
            <span class="float-chip"><v-icon>mdi-receipt-text-outline</v-icon><span class="chip-label">Disbursement</span></span>
            <span class="float-chip"><v-icon>mdi-calendar-check-outline</v-icon><span class="chip-label">Leave</span></span>
            <span class="float-chip"><v-icon>mdi-airplane</v-icon><span class="chip-label">Travel Order</span></span>
        </div>

        <v-card class="login-card" elevation="0" :class="{ 'is-busy': loading }">
            <div class="login-inner">
            <div class="brand-row">
                <div class="seal-wrap">
                    <v-img
                        src="/zamboanga-seal.png"
                        alt="Zamboanga Seal"
                        eager
                        cover
                        aspect-ratio="1"
                        class="logo-seal"
                    />
                </div>
                <h1 class="brand-logo brand-left" aria-label="TransactionMF City Government of Zamboanga">
                    <span class="brand-main">TransactionMF</span>
                    <span class="brand-sub">CITY GOVERNMENT OF ZAMBOANGA</span>
                </h1>
            </div>
            <div class="brand-rule" aria-hidden="true"></div>

            <div class="welcome-block" aria-hidden="true">
                <h2 class="welcome-title">Welcome back</h2>
                <p class="welcome-sub">Sign in to continue to your workspace.</p>
            </div>

            <v-alert
                v-if="error"
                :key="errorKey"
                type="error"
                variant="tonal"
                rounded="lg"
                role="alert"
                aria-live="assertive"
                class="mb-4 font-weight-bold login-error"
            >
                <template #prepend>
                    <v-icon>mdi-alert-circle-outline</v-icon>
                </template>
                {{ error }}
            </v-alert>

            <v-form @submit.prevent="submit" :aria-busy="loading ? 'true' : 'false'">
                <label class="field-label" for="login-email">Email</label>
                <v-text-field
                    id="login-email"
                    v-model.trim="email"
                    name="username"
                    placeholder="Enter your email"
                    aria-label="Email"
                    type="email"
                    autocomplete="username"
                    autocapitalize="none"
                    spellcheck="false"
                    variant="solo"
                    bg-color="#f1f5f9"
                    rounded="lg"
                    flat
                    hide-details="auto"
                    prepend-inner-icon="mdi-email-outline"
                    class="login-field mb-6"
                    :disabled="loading"
                    required
                    autofocus
                />
                <label class="field-label" for="login-password">Password</label>
                <v-text-field
                    id="login-password"
                    v-model="password"
                    name="current-password"
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
                    class="login-field password-field mb-0"
                    :disabled="loading"
                    required
                />

                <v-btn
                    type="submit"
                    block
                    rounded="pill"
                    size="large"
                    :loading="loading"
                    :disabled="!canSubmit"
                    class="login-btn font-weight-bold"
                >
                    <v-icon v-if="!loading" start>mdi-login</v-icon>
                    {{ loading ? "Signing in…" : "Login" }}
                </v-btn>
            </v-form>

            <p class="copyright">© City Government of Zamboanga</p>
            </div>
        </v-card>
    </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuth } from "@/composables/useAuth";

const router = useRouter();
const auth = useAuth();

const email = ref("");
const password = ref("");
const showPassword = ref(false);

const loading = ref(false);
const error = ref("");
const errorKey = ref(0);

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
            remember: false,
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
.login-sky {
    position: fixed;
    inset: 0;
    width: 100%;
    overflow: hidden;
    height: 100vh;
    height: 100dvh;
    max-height: 100vh;
    max-height: 100dvh;
    background: url('/loginpage.jpg') center / cover no-repeat;
    font-family: 'Roboto', sans-serif;
    display: flex;
    justify-content: flex-start;
    align-items: stretch;
    padding: 0;
}
/* Soft scrim so the photo never fights the form panel */
.login-sky::before {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 0;
    background:
        linear-gradient(90deg, rgba(15, 23, 42, 0.18) 0%, rgba(15, 23, 42, 0) 40%),
        linear-gradient(0deg, rgba(15, 23, 42, 0.22) 0%, rgba(15, 23, 42, 0) 35%);
    pointer-events: none;
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
    left: 38.4%;
    right: 0;
    z-index: 2;
    pointer-events: none;
}

/* Floating transaction-type pills */
.float-chip {
    position: absolute;
    display: flex;
    align-items: center;
    gap: 10px;
    width: max-content;
    max-width: 100%;
    min-height: 58px;
    padding: 12px 22px;
    background: rgba(255, 255, 255, 0.94);
    color: #CA8A04;
    border-radius: 999px;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.22);
    pointer-events: none;
    white-space: nowrap;
    animation: floaty 5s ease-in-out infinite;
}
.float-chip .v-icon {
    font-size: 1.5rem;
}
.chip-label {
    font-weight: 800;
    font-size: 0.9rem;
    letter-spacing: 0.04em;
}
.top-icons .float-chip:nth-child(1) {
    top: 10%;
    left: 10%;
    animation-delay: 0s;
}
.top-icons .float-chip:nth-child(2) {
    top: 18%;
    right: 8%;
    animation-delay: 1.2s;
}
.top-icons .float-chip:nth-child(3) {
    top: 42%;
    left: 28%;
    animation-delay: 2.1s;
}
.top-icons .float-chip:nth-child(4) {
    top: 50%;
    right: 16%;
    animation-delay: 0.6s;
}
.top-icons .float-chip:nth-child(5) {
    bottom: 12%;
    left: 8%;
    animation-delay: 1.7s;
}
.top-icons .float-chip:nth-child(6) {
    bottom: 8%;
    right: 8%;
    animation-delay: 2.6s;
}

.login-card {
    position: relative;
    z-index: 1;
    width: 38.4%;
    max-width: 528px;
    min-width: 384px;
    min-height: 100vh;
    min-height: 100dvh;
    height: 100vh;
    height: 100dvh;
    max-height: none;
    margin: 0;
    margin-right: auto;
    border-radius: 0 !important;
    background: linear-gradient(180deg, rgba(255, 255, 255, 0.88), rgba(255, 255, 255, 0.78));
    backdrop-filter: blur(18px) saturate(1.2);
    -webkit-backdrop-filter: blur(18px) saturate(1.2);
    box-shadow: 0 24px 60px rgba(15, 23, 42, 0.22) !important;
    border: none;
    border-right: 1px solid #e2e8f0;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: none;
    -ms-overflow-style: none;
    animation: card-enter 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
}
/* Brand accent hairline across the top of the panel: dark blue to dark gray.
   Absolute so it never eats layout space or collapses the top padding when
   the form is taller than the viewport (sticky + centered flex clipped it). */
.login-card::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    z-index: 3;
    display: block;
    height: 35px;
    flex-shrink: 0;
    background: linear-gradient(90deg, #1E3A8A 0%, #1E40AF 45%, #334155 100%);
    pointer-events: none;
}
.login-card::-webkit-scrollbar {
    display: none;
    width: 0;
}

.login-inner {
    width: 100%;
    max-width: 448px;
    margin: auto;
    padding: 43px 56px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 4px;
    flex: 0 1 auto;
    min-height: auto;
    animation: inner-rise 0.6s cubic-bezier(0.22, 1, 0.36, 1) 0.08s both;
}

.brand-row {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    gap: 16px;
    margin-bottom: 12px;
    margin-left: -28px;
    margin-right: 0;
    min-width: 0;
    text-align: left;
}

.seal-wrap {
    width: 92px;
    height: 92px;
    flex-shrink: 0;
    border-radius: 50%;
    background: #ffffff;
    padding: 5px;
    box-shadow: 0 10px 28px rgba(30, 64, 175, 0.28), 0 0 0 6px rgba(30, 64, 175, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    box-sizing: border-box;
}

.logo-seal {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    overflow: hidden;
}
.logo-seal :deep(img),
.logo-seal :deep(.v-img__img) {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
    object-position: center !important;
    border-radius: 50% !important;
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
    min-width: 0;
    flex: 1;
}
.brand-logo.brand-left .brand-sub {
    text-indent: 0;
}
.brand-main {
    font-family: 'Roboto', sans-serif;
    font-weight: 800;
    font-size: clamp(1.6rem, 2.1vw, 2.08rem);
    letter-spacing: 0.01em;
    color: #1E40AF;
    text-shadow: 0 3px 0 rgba(30, 64, 175, 0.15);
    white-space: nowrap;
    max-width: 100%;
}
.brand-sub {
    margin-top: 8px;
    font-family: 'Roboto', sans-serif;
    font-weight: 900;
    font-size: clamp(0.82rem, 1.56vw, 0.91rem);
    letter-spacing: 0.05em;
    -webkit-text-stroke: 0.5px #1E40AF;
    text-indent: 0;
    color: #1E40AF;
    white-space: nowrap;
    line-height: 1.3;
    max-width: none;
}
.brand-rule {
    display: block;
    height: 0;
    margin: 12px -96px 18px;
    border: none;
    border-top: 4px solid #1E40AF;
    opacity: 0.6;
}

/* Ghost block: invisible but keeps a slim spacing rhythm in the layout */
.welcome-block {
    margin: 0 0 8px;
    visibility: hidden;
}
.welcome-title {
    margin: 0;
    font-size: 1.25rem;
    font-weight: 800;
    letter-spacing: 0.01em;
    color: #0f172a;
    line-height: 1.2;
}
.welcome-sub {
    margin: 4px 0 0;
    font-size: 0.85rem;
    font-weight: 500;
    color: #64748b;
}


.login-error {
    border-left: 4px solid #dc2626;
    animation: error-shake 0.4s ease;
}

.field-label {
    display: block;
    font-size: 0.88rem;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #475569;
    margin-bottom: 12px;
}

/* Tight gap above the email label so the form sits higher */
label[for="login-email"] {
    margin-top: 12px;
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
    min-height: 62px;
    padding-inline: 18px;
    column-gap: 12px;
    align-items: center;
    transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
}
.login-field :deep(.v-field__input) {
    min-height: 62px;
    padding-top: 15px;
    padding-bottom: 15px;
    padding-left: 0;
    padding-right: 0;
    font-size: 1.08rem;
}
.login-field :deep(.v-field:hover) {
    border-color: #93C5FD;
}
.login-field :deep(.v-field--focused) {
    border-color: #1E40AF;
    box-shadow: inset 0 2px 6px rgba(15, 23, 42, 0.06), 0 0 0 3px rgba(30, 64, 175, 0.18);
    transform: translateY(-1px);
}
.login-field :deep(.v-field--disabled) {
    opacity: 0.72;
}
.login-field :deep(input:focus-visible) {
    outline: 2px solid rgba(30, 64, 175, 0.55);
    outline-offset: 2px;
}
/* Dim the form slightly while the sign-in request is in flight */
.login-card.is-busy .login-inner form {
    opacity: 0.82;
}
.login-field :deep(.v-field__prepend-inner),
.login-field :deep(.v-field__append-inner) {
    display: flex;
    align-items: center;
    align-self: center;
    padding: 0;
    min-height: 100%;
}
.login-field :deep(.v-field__prepend-inner .v-icon) {
    color: #1E40AF;
    opacity: 0.9;
    font-size: 1.25rem;
}
.login-field :deep(.v-field__append-inner .v-icon) {
    color: #64748b;
    font-size: 1.25rem;
}

/* Kill the "box inside a box": native input defaults to white, outer
   solo field is #f1f5f9. Force every inner layer transparent so only the
   outer .v-field paints. */
.login-field :deep(.v-field__field),
.login-field :deep(.v-field__input) {
    background: transparent !important;
    background-color: transparent !important;
    box-shadow: none !important;
    border: none !important;
}
.login-field :deep(input) {
    font-family: 'Roboto', sans-serif;
    font-weight: 700;
    background: transparent !important;
    background-color: transparent !important;
    border: none !important;
    box-shadow: none !important;
    outline: none !important;
    color: #0f172a;
}
.login-field :deep(input::placeholder) {
    font-family: 'Roboto', sans-serif;
    font-weight: 700;
    color: #94a3b8 !important;
    opacity: 1 !important;
}

/* Chrome/Edge/Safari autofill: override yellow/blue wash with field bg */
.login-field :deep(input:-webkit-autofill),
.login-field :deep(input:-webkit-autofill:hover),
.login-field :deep(input:-webkit-autofill:focus),
.login-field :deep(input:-webkit-autofill:active) {
    -webkit-box-shadow: 0 0 0 100px #f1f5f9 inset !important;
    -webkit-text-fill-color: #0f172a !important;
    caret-color: #0f172a !important;
    border-radius: 14px !important;
    transition: background-color 5000s ease-in-out 0s !important;
}

/* Firefox autofill */
.login-field :deep(input:autofill) {
    box-shadow: 0 0 0 100px #f1f5f9 inset !important;
    -webkit-text-fill-color: #0f172a !important;
    color: #0f172a !important;
}

/* One input-box worth of space between password field and login button */
.password-field {
    margin-bottom: 62px !important;
}

.copyright {
    margin-top: 28px;
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: #475569;
    text-align: center;
}

.login-btn {
    position: relative;
    overflow: hidden;
    margin-top: 12px;
    min-height: 60px;
    font-size: 1.12rem;
    text-transform: none;
    background: linear-gradient(135deg, #1E40AF 0%, #1E40AF 60%, #1E3A8A 100%) !important;
    color: #ffffff !important;
    letter-spacing: 0.04em;
    box-shadow: 0 10px 22px rgba(30, 64, 175, 0.45) !important;
    transition: transform 0.15s ease, box-shadow 0.15s ease, filter 0.15s ease;
}
.login-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 28px rgba(30, 64, 175, 0.5) !important;
    filter: brightness(1.05);
}
.login-btn:active {
    transform: translateY(0) scale(0.98);
}
.login-btn:focus-visible {
    outline: 3px solid rgba(59, 130, 246, 0.65);
    outline-offset: 3px;
}
.login-btn.v-btn--disabled {
    background: linear-gradient(135deg, #93a4c4 0%, #7d90b5 100%) !important;
    box-shadow: none !important;
    opacity: 0.85;
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
        box-shadow: 0 24px 60px rgba(30, 58, 138, 0.16), 0 0 50px rgba(30, 64, 175, 0.16) !important;
    }
    50% {
        box-shadow: 0 24px 60px rgba(30, 58, 138, 0.2), 0 0 95px rgba(30, 64, 175, 0.32) !important;
    }
}

@keyframes card-enter {
    from {
        opacity: 0;
        transform: translateX(-18px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes inner-rise {
    from {
        opacity: 0;
        transform: translateY(14px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes error-shake {
    0%, 100% { transform: translateX(0); }
    20% { transform: translateX(-7px); }
    40% { transform: translateX(6px); }
    60% { transform: translateX(-4px); }
    80% { transform: translateX(3px); }
}

@media (max-width: 900px) {
    .login-sky {
        justify-content: center;
        align-items: center;
        padding: 24px 16px;
        overflow-y: auto;
        scrollbar-width: none;
        -ms-overflow-style: none;
    }
    .login-sky::-webkit-scrollbar {
        display: none;
        width: 0;
    }
    .top-icons {
        display: none;
    }
    .login-card {
        width: 100%;
        min-width: 0;
        max-width: 520px;
        min-height: 0;
        height: auto;
        max-height: none;
        margin: auto;
        border-radius: 20px !important;
        border-right: none;
        border: 1px solid #e3ecf5;
        overflow: hidden;
    }
    .login-inner {
        min-height: 0;
        max-width: none;
        padding: 32px 24px;
    }
    .brand-row {
        margin-left: -8px;
    }
    .brand-rule {
        margin: 12px -24px 12px;
    }
    .welcome-title {
        font-size: 1.3rem;
    }
    .seal-wrap {
        width: 88px;
        height: 88px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .login-card,
    .login-inner,
    .float-chip,
    .login-btn::after,
    .login-error {
        animation: none !important;
    }
    .login-btn,
    .login-field :deep(.v-field) {
        transition: none !important;
    }
}
</style>
