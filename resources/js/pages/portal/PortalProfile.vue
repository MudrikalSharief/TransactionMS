<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-account-circle-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">My Profile</span>
                <v-spacer />
                <!-- Return: to the page you came from, or your home page. -->
                <v-btn
                    variant="outlined"
                    color="grey-darken-3"
                    rounded="0"
                    height="40"
                    :icon="xs"
                    :prepend-icon="xs ? undefined : 'mdi-arrow-left'"
                    aria-label="Back"
                    @click="goBack"
                >
                    <v-icon v-if="xs">mdi-arrow-left</v-icon>
                    <template v-else>Back</template>
                </v-btn>
            </v-card-title>
            <v-divider />

            <v-card-text class="pa-5 profile-body">
                <v-alert v-if="loadError" type="error" variant="tonal" rounded="lg" class="mb-4">{{ loadError }}</v-alert>

                <!-- Skeleton mirrors the real layout (identity card + two form
                     cards) so nothing jumps when the profile arrives. -->
                <div v-if="loading" class="profile-grid" aria-busy="true" aria-live="polite" aria-label="Loading your profile">
                    <section class="pf-card profile-id" aria-hidden="true">
                        <div class="sk sk-avatar"></div>
                        <div class="sk sk-line sk-line--name"></div>
                        <div class="sk sk-line sk-line--user"></div>
                        <div class="id-divider"></div>
                        <div class="sk sk-line sk-line--fact"></div>
                        <div class="sk sk-line sk-line--fact"></div>
                    </section>

                    <div class="profile-forms" aria-hidden="true">
                        <section v-for="n in 2" :key="n" class="pf-card">
                            <div class="sk sk-title"></div>
                            <div class="sk sk-field"></div>
                            <div class="sk sk-field"></div>
                            <div class="sk sk-field"></div>
                            <div class="sk-actions">
                                <div class="sk sk-btn sk-btn--wide"></div>
                            </div>
                        </section>
                    </div>
                </div>

                <div v-else class="profile-grid">
                    <!-- Identity: set by the admins, shown for reference.
                         Office and role are changed on the Users page. -->
                    <section class="pf-card profile-id">
                        <div class="id-avatar">{{ initials }}</div>
                        <div class="id-name">{{ profile.name }}</div>
                        <div class="id-user">{{ profile.username }}</div>
                        <div class="id-divider"></div>
                        <div class="id-fact">
                            <v-icon size="24" aria-hidden="true">mdi-office-building-outline</v-icon>
                            <div>
                                <div class="id-fact-label">Office</div>
                                <div class="id-fact-value">{{ profile.office?.name || "No office assigned" }}</div>
                            </div>
                        </div>
                        <div class="id-fact">
                            <v-icon size="24" aria-hidden="true">mdi-account-outline</v-icon>
                            <div>
                                <div class="id-fact-label">Role</div>
                                <div class="id-fact-value">{{ (profile.roles || []).map((r) => r.name || r.code).join(", ") || "—" }}</div>
                            </div>
                        </div>
                    </section>

                    <div class="profile-forms">
                        <!-- Details -->
                        <section class="pf-card">
                            <h2 class="pf-title">
                                <v-icon size="26" aria-hidden="true">mdi-account-outline</v-icon>
                                Your details
                            </h2>
                            <label class="pf-label" for="pf-name">Full name</label>
                            <v-text-field
                                id="pf-name"
                                v-model="details.name"
                                placeholder="Full name"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                hide-details="auto"
                                class="pf-field"
                                :error-messages="detailErrors.name"
                                @update:model-value="detailErrors.name = ''"
                            />
                            <label class="pf-label" for="pf-username">Username</label>
                            <v-text-field
                                id="pf-username"
                                v-model="details.username"
                                placeholder="Username"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                autocomplete="username"
                                autocapitalize="none"
                                spellcheck="false"
                                maxlength="30"
                                prepend-inner-icon="mdi-account-key-outline"
                                :hint="usernameChanged ? 'You will sign in with this new username next time.' : 'Used to sign in. 3–30 lowercase letters, numbers, dots or underscores.'"
                                persistent-hint
                                hide-details="auto"
                                class="pf-field"
                                :error-messages="detailErrors.username || usernameProblem"
                                @update:model-value="onUsernameInput"
                            />
                            <label class="pf-label" for="pf-contact">Contact number</label>
                            <v-text-field
                                id="pf-contact"
                                v-model="details.contact_number"
                                placeholder="Contact number"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                hide-details="auto"
                                class="pf-field"
                                :error-messages="detailErrors.contact_number"
                                @update:model-value="detailErrors.contact_number = ''"
                            />
                            <div class="pf-actions pf-actions--ruled">
                                <v-btn variant="text" rounded="md" class="pf-btn-quiet" :disabled="!detailsChanged || savingDetails" @click="resetDetails">Undo changes</v-btn>
                                <v-btn color="#0b3a9e" variant="flat" rounded="md" class="pf-btn" :loading="savingDetails" :disabled="!detailsChanged || !!usernameProblem" @click="saveDetails">
                                    Save details
                                </v-btn>
                            </div>
                        </section>

                        <!-- Password -->
                        <section class="pf-card">
                            <h2 class="pf-title">
                                <v-icon size="26" aria-hidden="true">mdi-lock-outline</v-icon>
                                Change password
                            </h2>
                            <label class="pf-label" for="pf-current">Current password</label>
                            <v-text-field
                                id="pf-current"
                                v-model="pw.current_password"
                                placeholder="Current password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                autocomplete="current-password"
                                hide-details="auto"
                                class="pf-field"
                                :error-messages="pwErrors.current_password"
                                @update:model-value="pwErrors.current_password = ''"
                            />
                            <label class="pf-label" for="pf-new">New password</label>
                            <v-text-field
                                id="pf-new"
                                v-model="pw.password"
                                placeholder="New password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                autocomplete="new-password"
                                hint="At least 8 characters."
                                persistent-hint
                                hide-details="auto"
                                class="pf-field"
                                :error-messages="pwErrors.password"
                                @update:model-value="pwErrors.password = ''"
                            />
                            <label class="pf-label" for="pf-confirm">Confirm new password</label>
                            <v-text-field
                                id="pf-confirm"
                                v-model="pw.password_confirmation"
                                placeholder="Confirm new password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="compact"
                                rounded="lg"
                                autocomplete="new-password"
                                hide-details="auto"
                                class="pf-field"
                                :append-inner-icon="showPw ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                                @click:append-inner="showPw = !showPw"
                            />
                            <div class="pf-actions">
                                <v-btn
                                    color="#0b3a9e"
                                    variant="flat"
                                    rounded="md"
                                    class="pf-btn"
                                    :loading="savingPw"
                                    :disabled="!pw.current_password || !pw.password || !pw.password_confirmation"
                                    @click="savePassword"
                                >
                                    Change password
                                </v-btn>
                            </div>
                        </section>
                    </div>
                </div>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { useDisplay } from "vuetify";
import { useApi } from "@/composables/useApi";
import { useAuth, homePathFor } from "@/composables/useAuth";
import { toast } from "@/composables/useToast";

const router = useRouter();
const { xs } = useDisplay();

// Back: the previous page in this tab when there is one, else the
// account's home page (e.g. the profile was opened in a new tab).
function goBack() {
    if (window.history.state?.back) router.back();
    else router.push(homePathFor(auth.user.value));
}

// My Profile (every signed-in account except the shared guest viewer):
// name, username (the sign-in name), contact number and password. Office
// and role are shown but set on the Users page.
const { api, csrf } = useApi();
const auth = useAuth();

const loading = ref(true);
const loadError = ref("");
const profile = ref({});

const details = ref({ name: "", username: "", contact_number: "" });
const detailErrors = ref({});
const savingDetails = ref(false);

const pw = ref({ current_password: "", password: "", password_confirmation: "" });
const pwErrors = ref({});
const savingPw = ref(false);
const showPw = ref(false);

const initials = computed(() =>
    String(profile.value.name || "")
        .split(/\s+/)
        .filter(Boolean)
        .map((w) => w[0].toUpperCase())
        .slice(0, 2)
        .join(""),
);

const usernameChanged = computed(() => details.value.username !== (profile.value.username || ""));

const detailsChanged = computed(
    () =>
        details.value.name !== (profile.value.name || "") ||
        usernameChanged.value ||
        (details.value.contact_number || "") !== (profile.value.contact_number || ""),
);

// Same format the server enforces (App\Models\User::usernameRules).
const USERNAME_RE = /^[a-z0-9](?:[a-z0-9._]*[a-z0-9])?$/;
const usernameProblem = computed(() => {
    const u = details.value.username;
    if (!usernameChanged.value) return "";
    if (!u) return "Choose a username.";
    if (u.length < 3) return "Use at least 3 characters.";
    if (!USERNAME_RE.test(u)) return "Use lowercase letters, numbers, dots or underscores; start and end with a letter or number.";
    return "";
});

// Usernames are lowercase with no spaces; tidy as they type.
function onUsernameInput(value) {
    details.value.username = String(value || "").toLowerCase().replace(/\s+/g, "");
    detailErrors.value.username = "";
}

function resetDetails() {
    details.value = {
        name: profile.value.name || "",
        username: profile.value.username || "",
        contact_number: profile.value.contact_number || "",
    };
    detailErrors.value = {};
}

const firstErrors = (errs) =>
    Object.fromEntries(Object.entries(errs || {}).map(([k, v]) => [k, Array.isArray(v) ? v[0] : String(v)]));

async function load() {
    loading.value = true;
    loadError.value = "";
    try {
        const res = await api.get("/api/profile");
        profile.value = res.data?.profile || {};
        resetDetails();
    } catch (e) {
        loadError.value = e?.response?.data?.message || "Failed to load your profile.";
    } finally {
        loading.value = false;
    }
}

async function saveDetails() {
    savingDetails.value = true;
    detailErrors.value = {};
    try {
        await csrf?.();
        const res = await api.put("/api/profile", { ...details.value });
        profile.value = res.data?.profile || profile.value;
        resetDetails();
        // Header and sidebar show the new name right away.
        const renamed = auth.user.value && auth.user.value.username !== profile.value.username;
        if (auth.user.value) auth.user.value = { ...auth.user.value, name: profile.value.name, username: profile.value.username };
        toast.success(renamed ? `Profile saved. Sign in with "${profile.value.username}" from now on.` : "Profile saved.");
    } catch (e) {
        detailErrors.value = firstErrors(e?.response?.data?.errors);
        if (!Object.keys(detailErrors.value).length) toast.error(e?.response?.data?.message || "Saving failed.");
    } finally {
        savingDetails.value = false;
    }
}

async function savePassword() {
    savingPw.value = true;
    pwErrors.value = {};
    try {
        await csrf?.();
        await api.put("/api/profile/password", { ...pw.value });
        pw.value = { current_password: "", password: "", password_confirmation: "" };
        toast.success("Password changed.");
    } catch (e) {
        pwErrors.value = firstErrors(e?.response?.data?.errors);
        if (!Object.keys(pwErrors.value).length) toast.error(e?.response?.data?.message || "Changing the password failed.");
    } finally {
        savingPw.value = false;
    }
}

onMounted(load);
</script>

<style scoped>
/* Body sits on a light panel so the white cards stand out (the header
   above is unchanged). */
.profile-body {
    background: #f3f6fb;
}
.profile-grid {
    display: grid;
    grid-template-columns: 300px minmax(0, 1fr);
    gap: 22px;
    align-items: start;
}
.pf-card {
    padding: 20px 22px;
    border: 1px solid #e3e8f1;
    border-radius: 14px;
    background: #fff;
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04), 0 10px 26px -18px rgba(15, 23, 42, 0.3);
}
.profile-forms {
    display: grid;
    gap: 18px;
    min-width: 0;
}

/* ---- Identity card ---- */
.profile-id {
    padding: 28px 22px 24px;
    text-align: center;
}
.id-avatar {
    display: grid;
    place-items: center;
    width: 84px;
    height: 84px;
    margin: 0 auto 14px;
    border-radius: 14px;
    background: linear-gradient(180deg, #1550c2, #0b3a9e);
    color: #fff;
    font-size: 1.85rem;
    font-weight: 800;
    letter-spacing: 0.02em;
    box-shadow: 0 10px 20px -12px rgba(11, 58, 158, 0.8);
}
.id-name {
    font-size: 1.3rem;
    font-weight: 800;
    color: #13213f;
    overflow-wrap: anywhere;
}
.id-user {
    margin-top: 2px;
    font-size: 0.98rem;
    color: #6b7487;
    overflow-wrap: anywhere;
}
.id-divider {
    height: 1px;
    margin: 20px 0 18px;
    background: #e3e8f1;
}
.id-fact {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    padding: 0 6px;
    text-align: left;
}
.id-fact + .id-fact {
    margin-top: 18px;
}
.id-fact .v-icon {
    margin-top: 6px;
    color: #5b6475;
}
.id-fact-label {
    font-size: 0.82rem;
    color: #6b7487;
}
.id-fact-value {
    margin-top: 2px;
    font-size: 1rem;
    font-weight: 700;
    color: #13213f;
    overflow-wrap: anywhere;
}

/* ---- Form cards ---- */
.pf-title {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 0 0 14px;
    font-size: 1.2rem;
    font-weight: 800;
    color: #13213f;
}
.pf-title .v-icon {
    color: #0b3a9e;
}
.pf-label {
    display: block;
    margin: 0 0 6px 2px;
    font-size: 0.86rem;
    font-weight: 500;
    color: #13213f;
}
.pf-field {
    margin-bottom: 14px;
}
.pf-field :deep(.v-field) {
    background: #fff;
    font-size: 0.98rem;
}
.pf-field :deep(.v-field__outline) {
    --v-field-border-opacity: 0.22;
}
.pf-field :deep(.v-messages) {
    font-size: 0.76rem;
}
.pf-actions {
    display: flex;
    justify-content: flex-end;
    gap: 14px;
    margin-top: 6px;
}
.pf-actions--ruled {
    margin: 16px -22px 0;
    padding: 16px 22px 0;
    border-top: 1px solid #e8edf5;
}
.pf-btn {
    min-width: 160px;
    font-weight: 800;
    letter-spacing: 0.05em;
}
.pf-btn-quiet {
    color: #5b6475 !important;
    font-weight: 800;
    letter-spacing: 0.05em;
}

@media (max-width: 860px) {
    .profile-grid {
        grid-template-columns: 1fr;
    }
}
@media (max-width: 480px) {
    .pf-card {
        padding: 18px 16px;
    }
    .pf-actions--ruled {
        margin: 16px -16px 0;
        padding: 14px 16px 0;
    }
    .pf-actions {
        flex-wrap: wrap;
    }
    .pf-btn {
        flex: 1 1 auto;
    }
}

/* ---- Loading skeleton: same box sizes as the real content ---- */
.sk {
    position: relative;
    overflow: hidden;
    border-radius: 6px;
    background: rgba(var(--v-border-color), 0.14);
}
.sk::after {
    content: "";
    position: absolute;
    inset: 0;
    transform: translateX(-100%);
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.45), transparent);
    animation: sk-shimmer 1.4s ease-in-out infinite;
}
@keyframes sk-shimmer {
    100% { transform: translateX(100%); }
}
.sk-avatar {
    width: 84px;
    height: 84px;
    margin: 0 auto 14px;
    border-radius: 14px;
}
.sk-line {
    height: 12px;
    margin: 6px auto;
}
.sk-line--name {
    width: 55%;
    height: 18px;
    margin-top: 8px;
}
.sk-line--user {
    width: 40%;
}
.sk-line--fact {
    width: 75%;
    height: 32px;
    margin: 0 0 16px;
}
.sk-title {
    width: 38%;
    height: 22px;
    margin-bottom: 18px;
}
.sk-field {
    height: 64px;
    margin-bottom: 12px;
}
.sk-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 4px;
}
.sk-btn {
    width: 120px;
    height: 36px;
}
.sk-btn--wide {
    width: 160px;
}
@media (prefers-reduced-motion: reduce) {
    .sk::after {
        animation: none;
    }
}
</style>
