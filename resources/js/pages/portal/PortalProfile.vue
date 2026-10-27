<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center ga-2 pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-1 mr-sm-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-account-circle-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">My Profile</span>
            </v-card-title>
            <v-divider />

            <v-card-text class="pa-5">
                <v-alert v-if="loadError" type="error" variant="tonal" rounded="0" class="mb-4">{{ loadError }}</v-alert>

                <div v-if="loading" class="py-8 d-flex justify-center">
                    <v-progress-circular indeterminate color="primary" />
                </div>

                <div v-else class="profile-grid">
                    <!-- Identity: set by the admins, shown for reference. -->
                    <section class="profile-id">
                        <div class="id-avatar">{{ initials }}</div>
                        <div class="id-name">{{ profile.name }}</div>
                        <div class="id-email">{{ profile.email }}</div>
                        <dl class="id-facts">
                            <dt>Office</dt>
                            <dd>{{ profile.office?.name || "No office assigned" }}</dd>
                            <dt>Role</dt>
                            <dd>{{ (profile.roles || []).map((r) => r.name || r.code).join(", ") || "—" }}</dd>
                        </dl>
                        <p class="id-note">Office and role are set on the Users page and can't be changed here.</p>
                    </section>

                    <div class="profile-forms">
                        <!-- Details -->
                        <section class="pf-sec">
                            <h2 class="pf-title">Your details</h2>
                            <v-text-field
                                v-model="details.name"
                                label="Full name"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                :error-messages="detailErrors.name"
                                @update:model-value="detailErrors.name = ''"
                            />
                            <v-text-field
                                v-model="details.email"
                                label="Email"
                                type="email"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                hint="You sign in with this email."
                                persistent-hint
                                class="mb-2"
                                :error-messages="detailErrors.email"
                                @update:model-value="detailErrors.email = ''"
                            />
                            <v-text-field
                                v-model="details.contact_number"
                                label="Contact number"
                                placeholder="09171234567"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                :error-messages="detailErrors.contact_number"
                                @update:model-value="detailErrors.contact_number = ''"
                            />
                            <div class="d-flex justify-end ga-2">
                                <v-btn variant="text" rounded="0" :disabled="!detailsChanged || savingDetails" @click="resetDetails">Undo changes</v-btn>
                                <v-btn color="primary" variant="flat" rounded="0" :loading="savingDetails" :disabled="!detailsChanged" @click="saveDetails">
                                    Save details
                                </v-btn>
                            </div>
                        </section>

                        <v-divider class="my-6" />

                        <!-- Password -->
                        <section class="pf-sec">
                            <h2 class="pf-title">Change password</h2>
                            <v-text-field
                                v-model="pw.current_password"
                                label="Current password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                autocomplete="current-password"
                                :error-messages="pwErrors.current_password"
                                @update:model-value="pwErrors.current_password = ''"
                            />
                            <v-text-field
                                v-model="pw.password"
                                label="New password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                autocomplete="new-password"
                                hint="At least 8 characters."
                                persistent-hint
                                class="mb-2"
                                :error-messages="pwErrors.password"
                                @update:model-value="pwErrors.password = ''"
                            />
                            <v-text-field
                                v-model="pw.password_confirmation"
                                label="Confirm new password"
                                :type="showPw ? 'text' : 'password'"
                                variant="outlined"
                                density="comfortable"
                                rounded="0"
                                autocomplete="new-password"
                                :append-inner-icon="showPw ? 'mdi-eye-off' : 'mdi-eye'"
                                @click:append-inner="showPw = !showPw"
                            />
                            <div class="d-flex justify-end">
                                <v-btn
                                    color="primary"
                                    variant="flat"
                                    rounded="0"
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
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { toast } from "@/composables/useToast";

// My Profile (every signed-in account except the shared guest viewer):
// name, email, contact number and password. Office and role are shown
// but set on the Users page.
const { api, csrf } = useApi();
const auth = useAuth();

const loading = ref(true);
const loadError = ref("");
const profile = ref({});

const details = ref({ name: "", email: "", contact_number: "" });
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

const detailsChanged = computed(
    () =>
        details.value.name !== (profile.value.name || "") ||
        details.value.email !== (profile.value.email || "") ||
        (details.value.contact_number || "") !== (profile.value.contact_number || ""),
);

function resetDetails() {
    details.value = {
        name: profile.value.name || "",
        email: profile.value.email || "",
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
        if (auth.user.value) auth.user.value = { ...auth.user.value, name: profile.value.name, email: profile.value.email };
        toast.success("Profile saved.");
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
.profile-grid {
    display: grid;
    grid-template-columns: 280px minmax(0, 1fr);
    gap: 32px;
    align-items: start;
}
.profile-id {
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-top: 4px solid rgb(var(--v-theme-primary));
    padding: 22px 20px;
    text-align: center;
}
.id-avatar {
    display: grid;
    place-items: center;
    width: 72px;
    height: 72px;
    margin: 0 auto 12px;
    background: var(--tms-grad);
    color: #fff;
    font-size: 1.6rem;
    font-weight: 800;
}
.id-name {
    font-size: 1.1rem;
    font-weight: 800;
    overflow-wrap: anywhere;
}
.id-email {
    font-size: 0.85rem;
    color: rgba(var(--v-theme-on-surface), 0.65);
    overflow-wrap: anywhere;
}
.id-facts {
    margin: 18px 0 0;
    text-align: left;
    font-size: 0.88rem;
}
.id-facts dt {
    font-size: 0.75rem;
    font-weight: 700;
    color: rgba(var(--v-theme-on-surface), 0.6);
    margin-top: 10px;
}
.id-facts dd {
    margin: 2px 0 0;
    font-weight: 600;
}
.id-note {
    margin: 16px 0 0;
    font-size: 0.78rem;
    color: rgba(var(--v-theme-on-surface), 0.6);
    text-align: left;
}
.profile-forms {
    max-width: 560px;
}
.pf-title {
    margin: 0 0 14px;
    font-size: 1rem;
    font-weight: 800;
    color: rgb(var(--v-theme-primary));
}
@media (max-width: 760px) {
    .profile-grid {
        grid-template-columns: 1fr;
    }
}
</style>
