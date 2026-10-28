<template>
    <v-app>
        <v-app-bar
            v-if="showAuthUi"
            elevation="0"
            class="app-bar"
        >
            <v-app-bar-nav-icon
                icon="mdi-menu"
                v-tooltip="'Menu'"
                color="white"
                @click="toggleNav"
            />
            <div
                class="d-flex align-center flex-shrink-0 mr-4 ml-3 brand-click"
                style="flex: 0 0 auto; min-width: max-content"
                v-tooltip="kind === 'admin' ? 'Go to Dashboard' : 'Go to Home'"
                @click="router.push(homePathFor(auth.user.value))"
            >
                <v-img
                    src="/tms-logo-128.png"
                    alt="Transaction Management System logo"
                    width="34"
                    height="35"
                    class="mr-2"
                    style="flex: 0 0 auto"
                />
                <div
                    class="d-flex flex-column justify-center"
                    style="white-space: nowrap; line-height: 1"
                >
                    <div
                        class="font-weight-bold brand-title"
                        style="font-size: 1.1rem; line-height: 1"
                    >
                        TransactionMS
                    </div>
                    <div
                        class="font-weight-bold brand-sub"
                        style="font-size: 0.62rem; letter-spacing: 0.14em; text-transform: uppercase; line-height: 1; margin-top: 3px"
                    >
                        Management Framework
                    </div>
                </div>
            </div>

            <div
                class="d-none d-md-flex align-center justify-center"
                style="flex: 1 1 auto; min-width: 0; padding: 0 24px"
            >
                <v-autocomplete
                    v-model="searchSelect"
                    v-model:search="searchText"
                    :items="searchResults"
                    item-title="title"
                    item-value="value"
                    return-object
                    clearable
                    hide-details
                    density="compact"
                    variant="solo"
                    bg-color="#e5e9ef"
                    rounded="pill"
                    prepend-inner-icon="mdi-magnify"
                    placeholder="Search"
                    :no-data-text="searchNoDataText"
                    :menu-props="{ contentClass: 'search-menu', offset: 18 }"
                    class="font-weight-bold search-pixiv"
                    style="width: 100%; max-width: 380px"
                    @focus="ensureSearchData"
                    @update:model-value="goToResult"
                >
                    <template v-slot:item="{ props, item }">
                        <v-list-item
                            v-bind="props"
                            :prepend-icon="item.raw.icon"
                            :title="item.raw.title"
                            :subtitle="item.raw.subtitle"
                        />
                    </template>
                </v-autocomplete>
            </div>

            <div class="d-flex align-center" style="flex: 0 0 auto">
                <!-- One pill, three segments split by dividers: time, weather,
                     profile (opens My Profile; the shared guest viewer has none). -->
                <div class="nav-group mr-8">
                    <div class="nav-seg" v-tooltip="'Zamboanga local time'">
                        <v-icon size="20" color="#c7d7ff">mdi-clock-outline</v-icon>
                        <span>{{ clock }}</span>
                    </div>
                    <span class="nav-sep" aria-hidden="true"></span>
                    <div class="nav-seg" v-tooltip="'Weather in Zamboanga City: ' + weatherLabel">
                        <v-icon size="20" color="#c7d7ff">{{ weatherIcon }}</v-icon>
                        <span>{{ temperature }} · Zamboanga</span>
                    </div>
                    <template v-if="auth.user.value">
                        <span class="nav-sep d-none d-md-block" aria-hidden="true"></span>
                        <div
                            class="nav-seg d-none d-md-flex"
                            :class="{ 'nav-seg--link': hasProfile }"
                            :role="hasProfile ? 'link' : undefined"
                            :tabindex="hasProfile ? 0 : undefined"
                            :aria-label="hasProfile ? 'My Profile' : undefined"
                            v-tooltip="hasProfile ? `${userTooltip} · Click to edit your profile` : false"
                            @click="hasProfile && router.push('/profile')"
                            @keydown.enter="hasProfile && router.push('/profile')"
                        >
                            <v-icon size="22" color="#c7d7ff">mdi-account-circle</v-icon>
                            <!-- One label at a time: office scope and role swap every 10 s.
                                 Both are stacked in one grid cell, so the pill keeps the
                                 width of the longer one and nothing shifts. -->
                            <span v-if="scopeTexts.length" class="nav-swap-box">
                                <span
                                    v-for="t in scopeTexts"
                                    :key="t"
                                    class="nav-swap-item"
                                    :class="{ 'is-on': t === scopeLabel?.text }"
                                >{{ t }}</span>
                            </span>
                        </div>
                    </template>
                    <span class="nav-sep" aria-hidden="true"></span>
                    <!-- Viewers never signed in themselves (Track your Document
                         Process), so leaving is a plain "back", no confirmation. -->
                    <button
                        v-if="kind === 'viewer'"
                        type="button"
                        class="nav-seg nav-seg--link nav-seg--btn"
                        :disabled="loggingOut"
                        v-tooltip="'Leave tracking and return to the login page'"
                        @click="onLogout"
                    >
                        <v-icon size="20" color="#c7d7ff">mdi-arrow-left</v-icon>
                        <span class="d-none d-sm-inline">Back to login</span>
                    </button>
                    <button
                        v-else
                        type="button"
                        class="nav-seg nav-seg--link nav-seg--btn"
                        aria-label="Log out"
                        v-tooltip="'Log out'"
                        @click="confirmLogout = true"
                    >
                        <v-icon size="22" color="#c7d7ff">mdi-logout</v-icon>
                    </button>
                </div>
            </div>
        </v-app-bar>

        <v-navigation-drawer
            v-if="showAuthUi"
            v-model="drawer"
            :rail="rail"
            :rail-width="76"
            style="border-right: 2px solid #005EED"
            @mouseenter="expandOnHover"
            @mouseleave="collapseOnLeave"
        >
            <v-list nav color="primary" class="nav-groups">
                <!-- Role-aware groups: superadmin sees everything, office admins
                     their office's work and people, everyone else their own work. -->
                <template v-for="group in navGroups" :key="group.title">
                    <div v-if="!rail" class="nav-group-label">{{ group.title }}</div>
                    <v-divider v-else class="nav-group-rule" />
                    <v-list-item
                        v-for="item in group.items"
                        :key="item.to"
                        :to="item.to"
                        :exact="!!item.exact"
                        :prepend-icon="item.badge == null ? item.icon : undefined"
                        rounded="lg"
                        v-tooltip:end="rail ? (item.badge ? `${item.title} ${item.badge}` : item.title) : false"
                    >
                        <!-- Items with a count (clerk Task): small red badge on the
                             icon in the rail; "TASK 9" (count right after the
                             title) when the menu is open. -->
                        <template v-if="item.badge != null" #prepend>
                            <!-- Badge only exists while collapsed, so the open row's
                                 text reads "TASK 9", not "9TASK 9". -->
                            <v-badge
                                v-if="rail && item.badge > 0"
                                :content="item.badge > 99 ? '99+' : item.badge"
                                color="error"
                                class="approvals-badge"
                            >
                                <v-icon>{{ item.icon }}</v-icon>
                            </v-badge>
                            <v-icon v-else>{{ item.icon }}</v-icon>
                        </template>
                        <v-list-item-title class="d-flex align-center">
                            {{ item.title.toUpperCase() }}
                            <v-chip
                                v-if="item.badge != null && !rail && item.badge > 0"
                                size="x-small"
                                color="error"
                                variant="flat"
                                class="font-weight-bold ml-2"
                                v-tooltip="`${item.title} ${item.badge}`"
                            >
                                {{ item.badge > 99 ? "99+" : item.badge }}
                            </v-chip>
                        </v-list-item-title>
                    </v-list-item>
                </template>
                <v-list-item
                    v-if="false && showApprovals"
                    to="/approvals"
                    rounded="lg"
                    v-tooltip:end="rail && pendingRequirements ? approvalsBadgeLabel : false"
                >
                    <template #prepend>
                        <v-badge
                            :model-value="rail && pendingRequirements > 0"
                            :content="pendingRequirements > 99 ? '99+' : pendingRequirements"
                            color="error"
                            class="approvals-badge"
                        >
                            <v-icon>mdi-clipboard-check-multiple-outline</v-icon>
                        </v-badge>
                    </template>
                    <v-list-item-title>APPROVALS</v-list-item-title>
                    <template #append>
                        <v-chip
                            v-if="!rail && pendingRequirements > 0"
                            size="x-small"
                            color="error"
                            variant="flat"
                            class="font-weight-bold"
                            v-tooltip="approvalsBadgeLabel"
                        >
                            {{ pendingRequirements > 99 ? "99+" : pendingRequirements }}
                        </v-chip>
                    </template>
                </v-list-item>

            </v-list>
            <template #append>
                <v-divider />
                <!-- Who is signed in: name, current role, office. Collapsed
                     rail shows the initials; hover for the details. -->
                <div
                    v-if="auth.user.value"
                    class="nav-profile"
                    :class="{ 'nav-profile--rail': rail, 'nav-profile--link': hasProfile }"
                    :role="hasProfile ? 'link' : undefined"
                    :tabindex="hasProfile ? 0 : undefined"
                    v-tooltip:end="rail && hasProfile ? userTooltip : false"
                    @click="hasProfile && router.push('/profile')"
                    @keydown.enter="hasProfile && router.push('/profile')"
                >
                    <div v-if="rail" class="nav-profile__avatar">{{ userInitials }}</div>
                    <div v-if="!rail" class="nav-profile__text">
                        <span class="nav-profile__name">{{ auth.user.value.name }}</span>
                        <!-- The shared guest viewer shows only its name. -->
                        <template v-if="hasProfile"><span class="nav-profile__sep" aria-hidden="true">|</span><span class="nav-profile__meta">
                            {{ primaryRole }}<template v-if="auth.user.value.office"> · {{ auth.user.value.office.code || auth.user.value.office.name }}</template>
                        </span></template>
                    </div>
                </div>
                <v-divider />
                <div
                    class="d-flex pa-2 drawer-footer"
                    :class="rail ? 'flex-column align-center ga-1' : 'flex-row align-center justify-space-evenly ga-2'"
                >
                    <v-btn
                        :icon="rail"
                        size="small"
                        variant="tonal"
                        color="primary"
                        density="comfortable"
                        v-tooltip="rail ? (isDark ? 'Light mode' : 'Dark mode') : false"
                        @click="toggleTheme"
                    >
                        <v-icon>{{ isDark ? "mdi-weather-sunny" : "mdi-weather-night" }}</v-icon>
                        <span v-if="!rail" class="ml-1 text-caption font-weight-bold">
                            {{ isDark ? "LIGHT" : "DARK" }}
                        </span>
                    </v-btn>
                    <v-btn
                        :icon="rail"
                        size="small"
                        variant="tonal"
                        color="primary"
                        density="comfortable"
                        to="/help"
                        v-tooltip="rail ? 'Help' : false"
                    >
                        <v-icon>mdi-help-circle-outline</v-icon>
                        <span v-if="!rail" class="ml-1 text-caption font-weight-bold">HELP</span>
                    </v-btn>
                </div>
            </template>
        </v-navigation-drawer>

        <v-main class="app-main">
            <OfflineBar />
            <!-- The tracker's flag backdrop behind every page; the viewer
                 pages draw their own (search dims it as results appear). -->
            <TrackBackdrop v-if="showAuthUi && route.meta?.kind !== 'viewer'" quiet />
            <v-container v-if="showAuthUi" fluid class="pa-6 app-page">
                <!-- Keyed by route record (not params) so each page eases in
                     once, while /my/transactions/1 -> /2 stays a plain update. -->
                <div :key="route.matched[0]?.path || route.path" class="page-enter">
                    <router-view />
                </div>
            </v-container>
            <template v-else>
                <router-view />
            </template>
            <div v-if="showAuthUi" class="app-foot-spacer" aria-hidden="true"></div>
            <AppFooter v-if="showAuthUi" />
        </v-main>

        <v-dialog v-model="confirmLogout" max-width="640">
            <v-card rounded="0">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                        <v-icon color="#005EED">mdi-logout</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">LOG OUT?</span>
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" color="grey-darken-3" @click="confirmLogout = false" />
                </v-card-title>
                <v-card-text class="pa-12 text-center">
                    <div class="d-flex justify-center">
                        <img :src="mascotLogoutUrl" alt="See you soon" width="240" style="border-radius: 18px" />
                    </div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="d-flex justify-space-between px-6 pt-6 pb-6">
                    <v-btn variant="text" color="grey-darken-3" rounded="0" size="large" style="width: 40%" @click="confirmLogout = false">Cancel</v-btn>
                    <v-divider vertical :thickness="2" class="align-self-stretch" />
                    <v-btn color="error" rounded="0" size="large" style="width: 40%" :loading="loggingOut" @click="onLogout">Log out</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <ConfirmDialog />
        <AppToaster />
        <LoginApprovalNotice />
    </v-app>
</template>

<script setup>
import { computed, ref, watch, onMounted, onUnmounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useDisplay, useTheme } from "vuetify";
import { useAuth, canUseApprovals, isSuperadminUser, isOfficeAdminUser, userKind, homePathFor } from "@/composables/useAuth";
import { useOfficeScope } from "@/composables/useOfficeScope";
import { useTransactions } from "@/composables/useTransactions";
import { useApprovalBadge } from "@/composables/useApprovalBadge";
import ConfirmDialog from "@/components/ConfirmDialog.vue";
import AppToaster from "@/components/AppToaster.vue";
import LoginApprovalNotice from "@/components/LoginApprovalNotice.vue";
import OfflineBar from "@/components/OfflineBar.vue";
import TrackBackdrop from "@/components/track/TrackBackdrop.vue";
import AppFooter from "@/components/AppFooter.vue";
import mascotLogoutUrl from "@/assets/mascots/logout.jpg";

const router = useRouter();
const route = useRoute();
const auth = useAuth();
const officeScope = useOfficeScope();
const { mobile } = useDisplay();

// ---- Collapsible sidebar (starts collapsed) ----
// Hover expands via the same `rail` state the hamburger toggles,
// so both push the content instead of overlaying it.
const drawer = ref(!mobile.value);
const rail = ref(true);
let hoverExpanded = false;

const toggleNav = () => {
    hoverExpanded = false;
    // Viewers start with the sidebar hidden, so the button shows/hides it.
    if (mobile.value || kind.value === "viewer") {
        drawer.value = !drawer.value;
    } else {
        rail.value = !rail.value;
    }
};

const expandOnHover = () => {
    if (mobile.value || !drawer.value || !rail.value) return;
    hoverExpanded = true;
    rail.value = false;
};

const collapseOnLeave = () => {
    if (mobile.value || !hoverExpanded) return;
    hoverExpanded = false;
    rail.value = true;
};

const showAuthUi = computed(() => {
    return !!auth.user.value && route.name !== "login" && !route.meta?.bare;
});

const isSuperadmin = computed(() => isSuperadminUser(auth.user.value));
const isOfficeAdmin = computed(() => isOfficeAdminUser(auth.user.value));

// admin (superadmin/admin) | staff (user portal) | viewer (read-only tracking)
const kind = computed(() => userKind(auth.user.value));
// Viewers have a single page (Track), so the sidebar starts hidden; every
// other account gets it back. The shell outlives sign-ins, so a viewer
// session must not leave it hidden for the next admin or clerk.
watch(kind, (k) => {
    drawer.value = k !== "viewer" && !mobile.value;
}, { immediate: true });
// My Profile: every signed-in account except the shared guest viewer.
const hasProfile = computed(() => !!auth.user.value && kind.value !== "viewer");

const showApprovals = computed(() => canUseApprovals(auth.user.value));

// Sidebar, grouped by what the role does. Office admins get superadmin-style
// tools limited to their office; setup stays superadmin only. Staff use the
// user portal, viewers the read-only tracking pages.
const navGroups = computed(() => {
    if (kind.value === "viewer") {
        return [{ title: "Track", items: [{ title: "Track Transactions", icon: "mdi-map-marker-path", to: "/track" }] }];
    }
    if (kind.value === "staff") {
        const work = [{ title: "Transactions", icon: "mdi-file-document-multiple", to: "/portal/transactions" }];
        // Clerks (anyone who may approve; end users can't) get their Task
        // list, with the number of transactions waiting on them.
        if (showApprovals.value) {
            const n = pendingTransactions.value;
            work.push({
                title: "Task",
                icon: "mdi-clipboard-check-multiple-outline",
                to: "/portal/approvals",
                badge: n,
            });
        }
        // Completed transactions move here from Transactions.
        work.push({ title: "Transaction History", icon: "mdi-archive-outline", to: "/portal/history" });
        return [
            { title: "Overview", items: [{ title: "Home", icon: "mdi-home-city-outline", to: "/portal", exact: true }] },
            { title: "Work", items: work },
        ];
    }
    const overview = { title: "Overview", items: [{ title: "Dashboard", icon: "mdi-view-dashboard", to: "/" }] };
    if (isSuperadmin.value) {
        return [
            overview,
            { title: "Work", items: [{ title: "Transactions", icon: "mdi-swap-horizontal", to: "/transactions" }] },
            {
                title: "People",
                items: [
                    { title: "Users", icon: "mdi-account-group", to: "/admin/users" },
                    { title: "Roles", icon: "mdi-shield-account", to: "/admin/roles" },
                ],
            },
            {
                title: "Setup",
                items: [
                    { title: "Offices", icon: "mdi-office-building-outline", to: "/admin/offices" },
                    { title: "Transaction Types", icon: "mdi-format-list-bulleted-type", to: "/admin/transaction-types" },
                    { title: "Fields", icon: "mdi-form-textbox", to: "/admin/fields" },
                    { title: "Gov References", icon: "mdi-bank", to: "/admin/government-references" },
                ],
            },
        ];
    }
    if (isOfficeAdmin.value) {
        return [
            overview,
            { title: "Work", items: [{ title: "Office Transactions", icon: "mdi-file-document-multiple", to: "/transactions" }] },
            { title: "People", items: [{ title: "Office Users", icon: "mdi-account-group", to: "/office/users" }] },
            {
                title: "Setup",
                items: [{ title: "Transaction Types", icon: "mdi-format-list-bulleted-type", to: "/admin/transaction-types" }],
            },
        ];
    }
    return [
        overview,
        { title: "Work", items: [{ title: "Transactions", icon: "mdi-file-document-multiple", to: "/transactions" }] },
    ];
});

// ---- APPROVALS badge: required items not checked yet (uploads + validations) ----
const approvalBadge = useApprovalBadge();
const pendingRequirements = approvalBadge.pendingRequirements;
const pendingTransactions = approvalBadge.pendingTransactions;
const approvalsBadgeLabel = computed(() => {
    const n = pendingRequirements.value;
    return `${n} required item${n === 1 ? "" : "s"} not checked yet`;
});

function refreshApprovalBadge() {
    if (showApprovals.value) approvalBadge.refresh();
    else approvalBadge.clear();
}

// Recount on login/role change and on every page change; a timer (see
// onMounted) catches work that arrives from other users meanwhile.
watch(showApprovals, refreshApprovalBadge, { immediate: true });
watch(() => route.fullPath, refreshApprovalBadge);
let approvalBadgeTimer = null;

const userTooltip = computed(() => {
    const u = auth.user.value;
    if (!u) return "User";
    const roles = (u.roles ?? []).map((r) => r.name || r.code).join(", ");
    const office = u.office?.name ? ` · ${u.office.name}` : "";
    return roles ? `${u.email || u.name} (${roles})${office}` : `${u.email || u.name || "User"}${office}`;
});

// Current role for the welcome line and profile: the most senior one held
// (superadmin, then admin, then the rest in the order assigned).
const primaryRole = computed(() => {
    const roles = auth.user.value?.roles ?? [];
    const rank = (r) => (r.code === "superadmin" ? 0 : r.code === "admin" ? 1 : 2);
    const top = [...roles].sort((a, b) => rank(a) - rank(b))[0];
    if (!top) return "No role";
    if (top.code === "admin" && isOfficeAdmin.value) return "Office Admin";
    return top.name || top.code;
});

// The profile pill shows one label at a time: the office scope and the role
// swap every 10 s (only the role when there is no office scope).
const showRoleLabel = ref(false);
const scopeLabel = computed(() => {
    const office = officeScope.value?.label;
    const role = primaryRole.value !== "No role" ? primaryRole.value : null;
    if (office && role) return showRoleLabel.value ? { text: role, isRole: true } : { text: office, isRole: false };
    if (office) return { text: office, isRole: false };
    return role ? { text: role, isRole: true } : null;
});
const scopeTexts = computed(() => {
    const office = officeScope.value?.label;
    const role = primaryRole.value !== "No role" ? primaryRole.value : null;
    return [office, role].filter(Boolean);
});
let scopeTimer = null;

const userInitials = computed(() => {
    const parts = (auth.user.value?.name || "").trim().split(/\s+/).filter(Boolean);
    const letters = parts.length > 1 ? parts[0][0] + parts[parts.length - 1][0] : (parts[0] || "?").slice(0, 2);
    return letters.toUpperCase();
});

const confirmLogout = ref(false);
const loggingOut = ref(false);

async function onLogout() {
    loggingOut.value = true;
    try {
        await auth.logout();
        confirmLogout.value = false;
        await router.push({ name: "login" });
    } finally {
        loggingOut.value = false;
    }
}

// ---- Global navbar search (transactions + pages) ----
const searchText = ref("");
const searchSelect = ref(null);
const searchLoading = ref(false);
let searchLoaded = false;

const allTx = useTransactions();

const searchPages = computed(() => {
    if (kind.value === "viewer") {
        return [
            { title: "Track Transactions", subtitle: "Page", icon: "mdi-map-marker-path", to: "/track" },
            { title: "Help", subtitle: "Page", icon: "mdi-help-circle-outline", to: "/help" },
        ].map((p, i) => ({ ...p, type: "page", value: `page-${i}` }));
    }
    if (kind.value === "staff") {
        return [
            { title: "Home", subtitle: "Page", icon: "mdi-home-city-outline", to: "/portal" },
            { title: "Transactions", subtitle: "Page", icon: "mdi-file-document-multiple", to: "/portal/transactions" },
            ...(showApprovals.value
                ? [{ title: "Task", subtitle: "Page", icon: "mdi-clipboard-check-multiple-outline", to: "/portal/approvals" }]
                : []),
            { title: "Transaction History", subtitle: "Page", icon: "mdi-archive-outline", to: "/portal/history" },
            { title: "Help", subtitle: "Page", icon: "mdi-help-circle-outline", to: "/help" },
        ].map((p, i) => ({ ...p, type: "page", value: `page-${i}` }));
    }
    const pages = [
        { title: "Dashboard", subtitle: "Page", icon: "mdi-view-dashboard", to: "/" },
        { title: "Help", subtitle: "Page", icon: "mdi-help-circle-outline", to: "/help" },
    ];
    if (isOfficeAdmin.value) {
        pages.push({ title: "Office Users", subtitle: "Page · Office admin", icon: "mdi-account-group", to: "/office/users" });
    }
    if (showApprovals.value) {
        pages.splice(2, 0, {
            title: "Approvals",
            subtitle: "Page",
            icon: "mdi-clipboard-check-multiple-outline",
            to: "/approvals",
        });
    }
    pages.push(
        { title: "Transactions", subtitle: "Page", icon: "mdi-swap-horizontal", to: "/transactions" }
    );
    if (isSuperadmin.value) {
        pages.push(
            { title: "Users", subtitle: "Page · Admin", icon: "mdi-account-group", to: "/admin/users" },
            { title: "Roles", subtitle: "Page · Admin", icon: "mdi-shield-account", to: "/admin/roles" },
            { title: "Offices", subtitle: "Page · Admin", icon: "mdi-office-building-outline", to: "/admin/offices" },
            { title: "Workflows", subtitle: "Page · Admin", icon: "mdi-source-branch", to: "/admin/workflows" },
            { title: "Fields", subtitle: "Page · Admin", icon: "mdi-form-textbox", to: "/admin/fields" },
            { title: "Requirements", subtitle: "Page · Admin", icon: "mdi-clipboard-check-outline", to: "/admin/requirements" },
            { title: "Government References", subtitle: "Page · Admin", icon: "mdi-bank", to: "/admin/government-references" }
        );
    }
    if (isSuperadmin.value || isOfficeAdmin.value) {
        pages.push({
            title: "Transaction Types",
            subtitle: "Page · Admin",
            icon: "mdi-format-list-bulleted-type",
            to: "/admin/transaction-types",
        });
    }
    return pages.map((p, i) => ({ ...p, type: "page", value: `page-${i}` }));
});

async function ensureSearchData() {
    // Viewers search pages only: the transaction lists are closed to them.
    if (kind.value === "viewer") return;
    if (searchLoaded || searchLoading.value) return;
    searchLoading.value = true;
    try {
        await allTx.fetchAll({ q: searchText.value });
    } catch {
        /* search stays page-only */
    } finally {
        searchLoading.value = false;
        searchLoaded = true;
    }
}

// Debounced server search: typing queries ?q= (ref/title) instead of
// filtering a stale page-1 snapshot — correct results on large datasets
// with one small 25-row payload per pause, not per keystroke.
let searchTimer = null;
watch(searchText, (q) => {
    if (searchTimer) clearTimeout(searchTimer);
    searchTimer = setTimeout(async () => {
        const query = String(q || "").trim();
        if (!query || kind.value === "viewer") return;
        searchLoading.value = true;
        try {
            await allTx.fetchAll({ q: query, silent: true });
        } catch {
            /* keep previous suggestions */
        } finally {
            searchLoading.value = false;
        }
    }, 400);
});

const searchResults = computed(() => {
    const q = (searchText.value || "").trim().toLowerCase();
    // No auto-suggestions: only search once the user types something.
    if (!q) return [];

    const seen = new Set();
    const txItems = [];

    const pushTx = (tx, to) => {
        if (!tx || seen.has(tx.id)) return;
        seen.add(tx.id);
        txItems.push({
            type: "tx",
            value: `tx-${to}-${tx.id}`,
            title: tx.title || tx.reference_number || `Transaction #${tx.id}`,
            subtitle: [tx.reference_number, tx.transaction_type?.name || tx.transaction_type_name]
                .filter(Boolean)
                .join(" · "),
            icon: "mdi-file-document-outline",
            to: `${to}/${tx.id}`,
        });
    };

    (allTx.items.value || []).forEach((tx) => pushTx(tx, "/transactions"));

    return [
        ...txItems.filter((i) => `${i.title} ${i.subtitle}`.toLowerCase().includes(q)).slice(0, 7),
        ...searchPages.value.filter((p) => p.title.toLowerCase().includes(q)),
    ];
});

const searchNoDataText = computed(() => {
    const q = (searchText.value || "").trim();
    return q ? `No results for "${q}"` : "Search anything . . .";
});

async function goToResult(item) {
    if (!item?.to) return;
    searchSelect.value = null;
    searchText.value = "";
    await router.push(item.to);
}

// ---- Live clock (Asia/Manila, Zamboanga, time only) ----
const clock = ref("--:--:--");
const MANILA_TZ = "Asia/Manila";
let clockTimer = null;

const tickClock = () => {
    // Minute precision pairs with the 30s timer above — cheaper on low-end
    // devices than a per-second re-render, still accurate to the minute.
    clock.value = new Date().toLocaleTimeString("en-PH", {
        timeZone: MANILA_TZ,
        hour: "2-digit",
        minute: "2-digit",
        hour12: true,
    });
};

// ---- Temperature (via /api/weather proxy, Zamboanga City) ----
const temperature = ref("--°C");
const weatherIcon = ref("mdi-thermometer");
const weatherLabel = ref("loading…");

const WEATHER_TEXT = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Icy fog",
    51: "Light drizzle",
    53: "Drizzle",
    55: "Heavy drizzle",
    56: "Light freezing drizzle",
    57: "Freezing drizzle",
    61: "Light rain",
    63: "Rain",
    65: "Heavy rain",
    66: "Light freezing rain",
    67: "Freezing rain",
    71: "Light snow",
    73: "Snow",
    75: "Heavy snow",
    77: "Snow grains",
    80: "Light showers",
    81: "Showers",
    82: "Heavy showers",
    85: "Light snow showers",
    86: "Snow showers",
    95: "Thunderstorm",
    96: "Storm with light hail",
    99: "Storm with hail",
};

// Dynamic icon driven by the live condition code (+ day/night)
const iconForCode = (code, temp, isDay = 1) => {
    const night = Number(isDay) === 0;
    if (code === null || code === undefined) {
        if (temp >= 32) return night ? "mdi-weather-night" : "mdi-weather-sunny";
        if (temp >= 27) return night ? "mdi-weather-night-partly-cloudy" : "mdi-weather-partly-cloudy";
        return "mdi-weather-cloudy";
    }
    if (code === 0 || code === 1) return night ? "mdi-weather-night" : "mdi-weather-sunny";
    if (code === 2) return night ? "mdi-weather-night-partly-cloudy" : "mdi-weather-partly-cloudy";
    if (code === 3) return "mdi-weather-cloudy";
    if ([45, 48].includes(code)) return "mdi-weather-fog";
    if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].includes(code))
        return "mdi-weather-rainy";
    if ([71, 73, 75, 77, 85, 86].includes(code)) return "mdi-weather-snowy";
    if ([95, 96, 99].includes(code)) return "mdi-weather-lightning-rainy";
    return "mdi-weather-cloudy";
};

const loadTemperature = async () => {
    const applyTemp = (temp, code, isDay = 1) => {
        if (temp === null || temp === undefined || Number.isNaN(Number(temp)))
            throw new Error("no data");
        const t = Math.round(Number(temp));
        temperature.value = `${t}°C`;
        weatherIcon.value = iconForCode(code, t, isDay);
        weatherLabel.value =
            code !== null && code !== undefined && WEATHER_TEXT[code]
                ? `${WEATHER_TEXT[code]}, ${t}°C`
                : `${t}°C`;
    };

    const openMeteoUrl =
        "https://api.open-meteo.com/v1/forecast?latitude=6.9214&longitude=122.0790&current=temperature_2m,weather_code,is_day&timezone=Asia%2FManila";

    // Retry chain for transient boot failures (offline blip, proxy cold
    // start): 15s -> 30s -> 60s, then surrender to the long interval.
    // Without this, one failed boot fetch parks the chip on N/A until the
    // next 10-30min tick, which reads as "needs a refresh".
    const scheduleRetry = () => {
        if (weatherFails >= WEATHER_RETRY_DELAYS.length) return;
        clearTimeout(weatherRetryTimer);
        weatherRetryTimer = setTimeout(() => {
            loadTemperature();
        }, WEATHER_RETRY_DELAYS[weatherFails]);
        weatherFails += 1;
    };
    const markTempOk = () => {
        weatherFails = 0;
        if (weatherRetryTimer) {
            clearTimeout(weatherRetryTimer);
            weatherRetryTimer = null;
        }
    };

    try {
        const res = await fetch("/api/weather", { headers: { Accept: "application/json" } });
        if (!res.ok) throw new Error("proxy failed");
        const data = await res.json();
        if (data.temperature === null || data.temperature === undefined) {
            // Backend reachable but upstream failed: try Open-Meteo directly
            const direct = await fetch(openMeteoUrl);
            const d = await direct.json();
            applyTemp(d?.current?.temperature_2m, d?.current?.weather_code, d?.current?.is_day);
        } else {
            applyTemp(data.temperature, data.code, data.is_day);
        }
        markTempOk();
    } catch {
        try {
            const direct = await fetch(openMeteoUrl);
            const d = await direct.json();
            applyTemp(d?.current?.temperature_2m, d?.current?.weather_code, d?.current?.is_day);
            markTempOk();
        } catch {
            temperature.value = "N/A";
            weatherIcon.value = "mdi-thermometer-off";
            weatherLabel.value = "unavailable";
            scheduleRetry();
        }
    }
};

let weatherTimer = null;
// Consecutive boot/refresh failures; reset on any success.
let weatherFails = 0;
let weatherRetryTimer = null;
const WEATHER_RETRY_DELAYS = [15 * 1000, 30 * 1000, 60 * 1000];

// Returning to a tab that parked on N/A/placeholder refreshes it.
const onVisible = () => {
    if (
        !document.hidden &&
        navigator.onLine &&
        (temperature.value === "N/A" || temperature.value === "--°C")
    ) {
        loadTemperature();
    }
};

// ---- Dark mode (persisted, applied via Vuetify theme + html.dark CSS layer) ----
const theme = useTheme();
const THEME_KEY = "lgu-tx:theme";
const isDark = computed(() => theme.global.name.value === "pixivDark");

function applyTheme(name) {
    theme.change(name);
    document.documentElement.classList.toggle("dark", name === "pixivDark");
    try {
        localStorage.setItem(THEME_KEY, name);
    } catch {
        /* private mode: theme just won't persist */
    }
}

function toggleTheme() {
    applyTheme(isDark.value ? "pixivLight" : "pixivDark");
}

onMounted(() => {
    let saved = null;
    try {
        saved = localStorage.getItem(THEME_KEY);
    } catch {
        /* ignore */
    }
    if (saved === "pixivDark" || saved === "pixivLight") applyTheme(saved);
    // Low-end tuning: clock at 30s (minute precision is enough; 1s forces a
    // re-render every second on weak CPUs). Weather + badge are deferred
    // until after first paint and skipped on hidden tabs / offline / 2g.
    const slowNet =
        (typeof navigator !== "undefined" &&
            (navigator.connection?.saveData ||
                ["slow-2g", "2g"].includes(navigator.connection?.effectiveType))) ||
        false;
    tickClock();
    clockTimer = setInterval(tickClock, 30 * 1000);
    const boot = (fn, delay) => {
        if ("requestIdleCallback" in window) requestIdleCallback(fn, { timeout: delay });
        else setTimeout(fn, delay);
    };
    boot(() => {
        if (!document.hidden && navigator.onLine) loadTemperature();
        refreshApprovalBadge();
    }, 2500);
    // Captive portals / slow office DHCP often mean "offline" at the boot
    // tick above: recover the moment connectivity arrives instead of
    // waiting out the long interval.
    window.addEventListener("online", loadTemperature);
    document.addEventListener("visibilitychange", onVisible);
    weatherTimer = setInterval(() => {
        if (!document.hidden && navigator.onLine) loadTemperature();
    }, (slowNet ? 30 : 10) * 60 * 1000);
    scopeTimer = setInterval(() => { showRoleLabel.value = !showRoleLabel.value; }, 10000);
    approvalBadgeTimer = setInterval(() => {
        if (!document.hidden && navigator.onLine) refreshApprovalBadge();
    }, (slowNet ? 5 : 1) * 60 * 1000);
});

onUnmounted(() => {
    if (clockTimer) clearInterval(clockTimer);
    if (weatherTimer) clearInterval(weatherTimer);
    if (weatherRetryTimer) {
        clearTimeout(weatherRetryTimer);
        weatherRetryTimer = null;
    }
    window.removeEventListener("online", loadTemperature);
    document.removeEventListener("visibilitychange", onVisible);
    if (approvalBadgeTimer) clearInterval(approvalBadgeTimer);
    if (scopeTimer) clearInterval(scopeTimer);
});
</script>

<style scoped>
/* Top bar: deep institutional navy (matches the sidebar active fill and
   dashboard foot bar) so the clock/weather/user/logout controls stop
   blending into a white header. Thin gold rule nods to the city seal. */
.app-bar {
    background: #0B2B66 !important;
    /* Thin lit edge plus a soft blue glow under the bar. */
    box-shadow: 0 1px 0 rgba(147, 197, 253, 0.35), 0 6px 26px -8px var(--tms-glow-c) !important;
}
.brand-title {
    color: #ffffff;
}
.brand-sub {
    color: rgba(255, 255, 255, 0.62);
}
/* Time / weather / profile live in one pill; thin vertical dividers split it. */
.nav-group {
    display: flex;
    align-items: stretch;
    height: 44px;
    border-radius: 999px;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.12);
    color: #e8eefc;
    border: 1px solid rgba(255, 255, 255, 0.16);
}
.nav-seg {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 0 14px;
    font-size: 0.875rem;
    font-weight: 500;
    white-space: nowrap;
    transition: background-color 0.15s ease;
}
.nav-seg--btn {
    background: none;
    border: 0;
    color: inherit;
    font: inherit;
    font-weight: 500;
}
.nav-seg--link {
    cursor: pointer;
}
.nav-seg--link:hover,
.nav-seg--link:focus-visible {
    background: rgba(255, 255, 255, 0.14);
    outline: none;
}
.nav-sep {
    align-self: center;
    width: 1px;
    height: 18px;
    background: rgba(255, 255, 255, 0.28);
}
.nav-swap-box {
    display: inline-grid;
    margin-left: 6px;
}
.nav-swap-item {
    grid-area: 1 / 1;
    opacity: 0;
    transition: opacity 0.3s ease;
    max-width: 260px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: 0.75rem;
    font-weight: 700;
    line-height: 1;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: #e8eefc;
}
.nav-swap-item.is-on {
    opacity: 1;
}
@media (max-width: 1279px) {
    .nav-swap-box {
        display: none;
    }
}
.nav-logout {
    color: #e8eefc !important;
}
.nav-logout:hover {
    background: rgba(255, 255, 255, 0.12);
}
.brand-click {
    cursor: pointer;
    user-select: none;
}
/* Viewer "Back to login": navy pill, fills on hover; icon only on phones. */
.track-exit {
    border-width: 1.5px;
    text-transform: none;
    letter-spacing: 0.01em;
}
/* On the navy app bar: white outline, fills light on hover. */
.track-exit:hover {
    background: rgba(255, 255, 255, 0.14);
}
.track-exit :deep(.v-icon) {
    transition: transform 0.15s ease;
}
.track-exit:hover :deep(.v-icon) {
    transform: translateX(-2px);
}
@media (max-width: 599px) {
    .track-exit :deep(.v-icon--start) {
        margin-inline-end: 0;
    }
}
/* Compact sidebar: tighter rows so all items fit without scrolling */
.nav-compact :deep(.v-list-item) {
    min-height: 36px !important;
    padding-top: 2px;
    padding-bottom: 2px;
}
.nav-compact :deep(.v-list-item-title) {
    font-size: 0.78rem;
    line-height: 1.2;
}
.nav-compact :deep(.v-list-item__prepend .v-icon) {
    font-size: 1.1rem;
}
/* Keep the APPROVALS badge on the icon, clear of the title */
.approvals-badge :deep(.v-badge__badge) {
    font-size: 0.65rem;
    min-width: 18px;
    height: 18px;
}
/* Sidebar group labels: quiet small caps that organize, never compete. */
.nav-group-label {
    padding: 14px 12px 4px;
    font-size: 0.64rem;
    font-weight: 800;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: rgba(var(--v-theme-on-surface), 0.45);
    white-space: nowrap;
    animation: nav-label-in 0.25s ease both;
}
.nav-groups > .nav-group-label:first-child {
    padding-top: 4px;
}
.nav-group-rule {
    margin: 8px 10px;
    opacity: 0.18;
}
.nav-groups > .nav-group-rule:first-child {
    display: none;
}
@keyframes nav-label-in {
    from { opacity: 0; transform: translateX(-4px); }
}
.nav-groups :deep(.v-list-item) {
    transition: background-color 0.18s ease, color 0.18s ease;
}
.nav-groups :deep(.v-list-item:not(.v-list-item--active):hover .v-icon) {
    color: #005EED;
}
/* Page change: a short ease-in so the switch reads as one smooth move. */
/* backwards, not both: once the move ends no transform is left on the
   wrapper (even an identity transform makes it the containing block for
   position: fixed, which boxed in full-page backdrops like the tracker's). */
.page-enter {
    animation: page-in 0.24s cubic-bezier(.2, .9, .25, 1) backwards;
}
@keyframes page-in {
    from { opacity: 0; transform: translateY(6px); }
}
@media (prefers-reduced-motion: reduce) {
    .page-enter,
    .nav-group-label {
        animation: none;
    }
}
/* Active nav item: solid dark fill instead of the faint primary tint,
   with a light inner accent so the current page reads at a glance. */
:deep(.v-navigation-drawer .v-list-item--active) {
    background: var(--tms-grad-h) !important;
    color: #ffffff !important;
    box-shadow: inset 3px 0 0 #93C5FD, 0 0 18px -2px var(--tms-glow-c);
}
:deep(.v-navigation-drawer .v-list-item--active > .v-list-item__overlay) {
    opacity: 0 !important;
}
:deep(.v-navigation-drawer .v-list-item--active .v-icon),
:deep(.v-navigation-drawer .v-list-item--active .v-list-item-title) {
    color: #ffffff !important;
    opacity: 1 !important;
}
/* Sidebar scrollbar: never show the thin blue bar in the rail (a short
   window used to grow one over the edge). Wheel/touch still scrolls; the
   right padding keeps what would have been the bar's strip as clear space
   so nothing sits against the border. */
:deep(.v-navigation-drawer__content) {
    scrollbar-width: none;
    padding-right: 6px;
}
:deep(.v-navigation-drawer__content)::-webkit-scrollbar {
    display: none;
    width: 0;
    height: 0;
}
/* Collapsed rail: the clear strip above would push every item 6px off
   centre, and each icon keeps a fixed slot plus spacer on its left. Centre
   items and icons on the rail so they line up with the avatar and the
   footer buttons below. (Expanded drawer is unaffected.) */
:deep(.v-navigation-drawer--rail .v-navigation-drawer__content) {
    padding-right: 0;
}
:deep(.v-navigation-drawer--rail .v-list-item) {
    padding-inline: 0 !important;
    grid-template-columns: 1fr !important;
    grid-template-areas: "prepend" !important;
}
:deep(.v-navigation-drawer--rail .v-list-item__prepend) {
    margin-inline: 0;
    justify-self: center;
}
:deep(.v-navigation-drawer--rail .v-list-item__prepend > .v-icon),
:deep(.v-navigation-drawer--rail .v-list-item__prepend > .v-badge) {
    margin-inline: 0 !important;
}
:deep(.v-navigation-drawer--rail .v-list-item__spacer),
:deep(.v-navigation-drawer--rail .v-list-item__content) {
    display: none;
}
:deep(.v-navigation-drawer--rail .nav-group-rule) {
    margin-inline: 12px;
}
/* Sidebar profile */
.nav-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 12px;
    min-width: 0;
}
.nav-profile--rail {
    justify-content: center;
    padding: 10px 0;
}
/* Clickable: opens My Profile. */
.nav-profile--link {
    cursor: pointer;
}
.nav-profile--link:hover,
.nav-profile--link:focus-visible {
    background: rgba(0, 94, 237, 0.06);
    outline: none;
}
.nav-profile__avatar {
    flex: 0 0 36px;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #1A1F2B;
    color: #fff;
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 0.04em;
    box-shadow: inset 0 -3px 0 #93C5FD;
}
.nav-profile__text {
    display: flex;
    align-items: center;
    flex: 1 1 auto;
    justify-content: center;
    gap: 8px;
    min-width: 0;
    line-height: 1.2;
    animation: nav-label-in 0.25s ease both;
}
.nav-profile__name {
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    font-weight: 800;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.nav-profile__name {
    flex: 0 1 auto;
}
.nav-profile__sep {
    flex: none;
    color: rgba(var(--v-theme-on-surface), 0.35);
    font-weight: 400;
}
.nav-profile__meta {
    flex: 0 1 auto;
    min-width: 0;
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    font-weight: 600;
    color: rgba(var(--v-theme-on-surface), 0.6);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
@media (prefers-reduced-motion: reduce) {
    .nav-profile__text {
        animation: none;
    }
}
/* Footer theme/help pair */
.drawer-footer .v-btn {
    min-width: 0;
    text-transform: none;
    letter-spacing: 0;
}
/* Pixiv-style pill search: chunky rounded type, soft shadow, blue focus ring */
.search-pixiv :deep(.v-field) {
    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.12);
    font-weight: 700;
    max-height: 38px;
}
.search-pixiv :deep(.v-field__input) {
    min-height: 38px;
    padding-top: 4px;
    padding-bottom: 4px;
}
.search-pixiv :deep(.v-field--focused) {
    box-shadow: 0 0 0 2px #005EED;
}
.search-pixiv :deep(.v-field__prepend-inner .v-icon) {
    color: #005EED;
    opacity: 1;
}
.search-pixiv :deep(input),
.search-pixiv :deep(input::placeholder) {
    font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
    font-weight: 700;
}
/* Column shell: on short pages the spacer soaks up the leftover height so
   the dashboard foot bar settles on the viewport bottom instead of floating. */
.app-main {
    display: flex;
    flex-direction: column;
}
/* Page sits above the fixed backdrop (AppFooter does the same). */
.app-page {
    position: relative;
    z-index: 1;
}
.app-foot-spacer {
    flex: 1 1 auto;
}
</style>
