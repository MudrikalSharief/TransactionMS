<template>
    <v-app>
        <v-app-bar
            v-if="showAuthUi"
            elevation="0"
            class="app-bar"
        >
            <div
                class="d-flex align-center flex-shrink-0 mr-4 brand-click"
                style="flex: 0 0 auto; min-width: max-content"
                role="button"
                tabindex="0"
                aria-label="Open or close the menu"
                v-tooltip="'Toggle menu'"
                @click="toggleNav"
                @keydown.enter="toggleNav"
                @keydown.space.prevent="toggleNav"
            >
                <div class="brand-logo">
                    <img
                        :src="'/tms-logo-128.png'"
                        alt="Transaction Management System logo"
                        class="brand-logo-img"
                    />
                </div>
                <div class="brand-divider" aria-hidden="true"></div>
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
                    rounded="pill"
                    prepend-inner-icon="mdi-magnify"
                    placeholder="Search"
                    :no-data-text="searchNoDataText"
                    :menu-props="{ contentClass: 'search-menu', offset: 18 }"
                    class="font-weight-bold search-pixiv"
                    style="width: 100%; max-width: 420px"
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

            <div class="d-flex align-center app-bar-right" style="flex: 0 0 auto">
                <!-- Local status: time and weather. -->
                <div class="nav-status d-none d-md-flex">
                    <div class="nav-seg nav-time" v-tooltip="'Zamboanga local time'">
                        <v-icon size="20">mdi-clock-outline</v-icon>
                        <div class="nav-time-stack">
                            <div id="app-bar-time-meta" class="nav-time-meta"></div>
                            <span class="nav-time-value">{{ clock }}</span>
                        </div>
                    </div>
                    <span class="nav-sep" aria-hidden="true"></span>
                    <div class="nav-seg" v-tooltip="'Weather in Zamboanga City: ' + weatherLabel">
                        <v-icon size="20">{{ weatherIcon }}</v-icon>
                        <span>{{ temperature }}</span>
                    </div>
                </div>

                <!-- Bell (staff, clerks, admins): deadlines and returns. -->
                <NotificationBell />

                <!-- Viewers (tracking): Back to the previous page. On the search
                     page with nothing to go back to, it leaves tracking for the
                     login page. -->
                <button
                    v-if="auth.user.value && kind === 'viewer'"
                    type="button"
                    class="nav-back"
                    :disabled="loggingOut"
                    v-tooltip="viewerBackHint"
                    @click="viewerBack"
                >
                    <v-icon size="20">mdi-arrow-left</v-icon>
                    <span class="d-none d-sm-inline">Back</span>
                </button>

                <!-- Tracker pages: the shared guest session gets a visible
                     way back to sign-in instead of the account menu. -->
                <v-btn
                    v-if="isTrackerView"
                    class="nav-login"
                    color="primary"
                    variant="flat"
                    rounded="0"
                    size="small"
                    prepend-icon="mdi-login-variant"
                    :loading="loggingOut"
                    :disabled="loggingOut"
                    @click="onLogout"
                >
                    Login
                </v-btn>

                <!-- Account: pressing the avatar opens a Facebook-style menu
                     with the profile header, settings and log out. Hidden for
                     the shared viewer account. -->
                <v-menu
                    v-if="auth.user.value && kind !== 'viewer'"
                    location="bottom end"
                    offset="10"
                    transition="fade-transition"
                >
                    <template #activator="{ props }">
                        <button
                            v-bind="props"
                            type="button"
                            class="nav-account"
                            aria-label="Account menu"
                        >
                            <v-icon size="20">mdi-account-outline</v-icon>
                        </button>
                    </template>
                    <v-card class="account-menu" rounded="xl" elevation="8">
                        <div class="account-menu-head">
                            <div class="account-menu-avatar">{{ accountInitial }}</div>
                            <div class="account-menu-id">
                                <div class="account-menu-name">{{ accountName }}</div>
                                <div v-if="accountEmail" class="account-menu-mail">{{ accountEmail }}</div>
                            </div>
                        </div>
                        <v-divider class="account-menu-divider" />
                        <v-list density="compact" class="account-menu-list">
                            <v-list-item v-if="hasProfile" @click="router.push('/profile')">
                                <template #prepend>
                                    <span class="account-menu-icon"><v-icon size="18">mdi-account-outline</v-icon></span>
                                </template>
                                <v-list-item-title>My Profile</v-list-item-title>
                            </v-list-item>
                            <v-list-item @click="settingsOpen = true">
                                <template #prepend>
                                    <span class="account-menu-icon"><v-icon size="18">mdi-cog-outline</v-icon></span>
                                </template>
                                <v-list-item-title>Settings &amp; Preferences</v-list-item-title>
                            </v-list-item>
                            <v-list-item @click="router.push('/help')">
                                <template #prepend>
                                    <span class="account-menu-icon"><v-icon size="18">mdi-help-circle-outline</v-icon></span>
                                </template>
                                <v-list-item-title>Help &amp; Support</v-list-item-title>
                            </v-list-item>
                        </v-list>
                        <v-divider class="account-menu-divider" />
                        <v-list density="compact" class="account-menu-list">
                            <v-list-item
                                v-if="kind === 'viewer'"
                                :disabled="loggingOut"
                                @click="onLogout"
                            >
                                <template #prepend>
                                    <span class="account-menu-icon"><v-icon size="18">mdi-arrow-left</v-icon></span>
                                </template>
                                <v-list-item-title>Back to login</v-list-item-title>
                            </v-list-item>
                            <v-list-item v-else class="account-menu-logout" @click="confirmLogout = true">
                                <template #prepend>
                                    <span class="account-menu-icon account-menu-icon--danger">
                                        <v-icon size="18">mdi-logout-variant</v-icon>
                                    </span>
                                </template>
                                <v-list-item-title>Log Out</v-list-item-title>
                            </v-list-item>
                        </v-list>
                    </v-card>
                </v-menu>
            </div>
        </v-app-bar>

        <v-navigation-drawer
            v-if="showAuthUi"
            v-model="drawer"
            :rail="rail"
            :rail-width="76"
            class="app-drawer"
            @mouseenter="expandOnHover"
            @mouseleave="collapseOnLeave"
        >
            <v-list nav color="primary" class="nav-groups">
                <!-- Role-aware groups: superadmin sees everything, office admins
                     their office's work and people, everyone else their own work. -->
                <template v-for="group in navGroups" :key="group.title">
                    <!-- Shown opened and collapsed (smaller and centred in the
                         rail) at the same height, so rows never move. -->
                    <div
                        class="nav-group-label"
                        :class="{ 'nav-group-label--rail': rail }"
                        :aria-hidden="rail ? 'true' : undefined"
                    >{{ group.title }}</div>
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
                <!-- Help lives with the destinations, right after the last group. -->
                <v-list-item
                    to="/help"
                    rounded="lg"
                    v-tooltip:end="rail ? 'Help' : false"
                >
                    <template #prepend>
                        <v-icon>mdi-help-circle-outline</v-icon>
                    </template>
                    <v-list-item-title class="d-flex align-center">HELP</v-list-item-title>
                </v-list-item>
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
                <!-- Settings: one row in the sidebar (a gear in the rail) that
                     opens the profile + preferences dialog. -->
                <div v-if="rail" class="nav-rail-tools">
                    <v-btn
                        icon
                        variant="text"
                        density="comfortable"
                        class="nav-rail-gear"
                        aria-label="Settings"
                        v-tooltip:end="'Settings'"
                        @click="settingsOpen = true"
                    >
                        <v-icon>mdi-cog-outline</v-icon>
                    </v-btn>
                </div>
                <v-list-item
                    v-else
                    rounded="lg"
                    class="nav-settings-item"
                    @click="settingsOpen = true"
                >
                    <template #prepend>
                        <v-icon>mdi-cog-outline</v-icon>
                    </template>
                    <v-list-item-title class="nav-settings-label">SETTINGS</v-list-item-title>
                </v-list-item>
            </template>
        </v-navigation-drawer>

        <v-main class="app-main" :class="{ 'app-main--fit': showAuthUi && route.meta?.fit }">
            <OfflineBar />
            <!-- The tracker's flag backdrop behind every page; the viewer
                 pages draw their own (search dims it as results appear). -->
            <TrackBackdrop v-if="showAuthUi && route.meta?.kind !== 'viewer'" quiet />
            <v-container
                v-if="showAuthUi"
                fluid
                class="pa-6 app-page"
            >
                <!-- Keyed by route record (not params) so each page eases in
                     once, while /my/transactions/1 -> /2 stays a plain update. -->
                <div :key="route.matched[0]?.path || route.path" class="page-enter">
                    <router-view />
                </div>
            </v-container>
            <template v-else>
                <router-view />
            </template>
            <!-- Dashboards (admin "/" and staff "/portal") have no footer
                 (route meta noFooter); the cards get that height instead. -->
            <template v-if="showAuthUi && !route.meta?.noFooter">
                <div class="app-foot-spacer" aria-hidden="true"></div>
                <AppFooter :fit="!!route.meta?.fit" :hall-left="route.meta?.kind !== 'viewer'" />
            </template>
        </v-main>

        <v-dialog v-model="confirmLogout" max-width="400">
            <v-card class="logout-card">
                <div class="logout-head">
                    <span class="logout-title">Are you sure?</span>
                    <button
                        type="button"
                        class="logout-close"
                        aria-label="Close"
                        @click="confirmLogout = false"
                    >
                        <v-icon size="18">mdi-close</v-icon>
                    </button>
                </div>
                <p class="logout-body">
                    You will no longer be logged in on this device.
                </p>
                <div class="logout-actions">
                    <button
                        type="button"
                        class="logout-btn logout-btn--cancel"
                        @click="confirmLogout = false"
                    >
                        Cancel
                    </button>
                    <button
                        type="button"
                        class="logout-btn logout-btn--confirm"
                        :disabled="loggingOut"
                        @click="onLogout"
                    >
                        <v-progress-circular
                            v-if="loggingOut"
                            size="16"
                            width="2"
                            indeterminate
                        />
                        <span v-else>Log out</span>
                    </button>
                </div>
            </v-card>
        </v-dialog>

        <v-dialog v-model="settingsOpen" max-width="460">
            <v-card rounded="0">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                        <v-icon color="#005EED">mdi-cog-outline</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">SETTINGS</span>
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" color="grey-darken-3" @click="settingsOpen = false" />
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-6">
                    <div class="settings-row">
                        <v-icon class="settings-row__icon">{{ isDark ? "mdi-weather-night" : "mdi-weather-sunny" }}</v-icon>
                        <div class="settings-row__text">
                            <div class="settings-row__title">Dark mode</div>
                            <div class="settings-row__sub">{{ isDark ? "On · navy surfaces" : "Off · light surfaces" }}</div>
                        </div>
                        <v-switch
                            :model-value="isDark"
                            color="primary"
                            density="compact"
                            hide-details
                            inset
                            :aria-label="isDark ? 'Turn dark mode off' : 'Turn dark mode on'"
                            @update:model-value="toggleTheme"
                        />
                    </div>

                    <div class="settings-row">
                        <v-icon class="settings-row__icon">{{ motionEnabled ? "mdi-motion-play-outline" : "mdi-motion-pause-outline" }}</v-icon>
                        <div class="settings-row__text">
                            <div class="settings-row__title">Animations</div>
                            <div class="settings-row__sub">{{ motionEnabled ? "On · full motion" : "Off · faster on slow devices" }}</div>
                        </div>
                        <v-switch
                            :model-value="motionEnabled"
                            color="primary"
                            density="compact"
                            hide-details
                            inset
                            :aria-label="motionEnabled ? 'Turn animations off' : 'Turn animations on'"
                            @update:model-value="toggleMotion"
                        />
                    </div>
                </v-card-text>
            </v-card>
        </v-dialog>

        <ConfirmDialog />
        <AppToaster />
        <LoginApprovalNotice />
        <LoginOverdueNotice />
    </v-app>
</template>

<script setup>
import { computed, ref, watch, onMounted, onUnmounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useDisplay, useTheme } from "vuetify";
import { useAuth, canUseApprovals, isSuperadminUser, isOfficeAdminUser, userKind } from "@/composables/useAuth";
import { useTransactions } from "@/composables/useTransactions";
import { useApprovalBadge } from "@/composables/useApprovalBadge";
import ConfirmDialog from "@/components/ConfirmDialog.vue";
import AppToaster from "@/components/AppToaster.vue";
import LoginApprovalNotice from "@/components/LoginApprovalNotice.vue";
import LoginOverdueNotice from "@/components/LoginOverdueNotice.vue";
import NotificationBell from "@/components/NotificationBell.vue";
import OfflineBar from "@/components/OfflineBar.vue";
import { useMotion } from "@/composables/useMotion";
import TrackBackdrop from "@/components/track/TrackBackdrop.vue";
import AppFooter from "@/components/AppFooter.vue";


const router = useRouter();
const route = useRoute();
const auth = useAuth();
const { mobile } = useDisplay();

// ---- Collapsible sidebar (starts collapsed) ----
// Hover expands via the same `rail` state the hamburger toggles, so both push
// the content instead of overlaying it.
const drawer = ref(!mobile.value);
const rail = ref(true);
let hoverExpanded = false;

const toggleNav = () => {
    hoverExpanded = false;
    // Viewers start with the sidebar hidden, so the button shows/hides it.
    if (mobile.value || kind.value === "viewer") {
        drawer.value = !drawer.value;
        // On phones the drawer is an overlay; open it with labels, not as a rail.
        if (drawer.value) rail.value = false;
    } else {
        rail.value = !rail.value;
    }
};

// Settings dialog: profile line plus the theme / motion controls that used to
// sit at the foot of the sidebar.
const settingsOpen = ref(false);

// Labels appear as soon as the pointer comes close to the collapsed rail:
// the rows are spaced like the open menu, so waiting for a direct hover leaves
// bare icons floating far apart. Collapse again once the pointer is well clear.
const RAIL_HOT_ZONE_PX = 112;
const RAIL_RESET_PX = 340;
function onPointerNearRail(e) {
    if (mobile.value || !drawer.value) return;
    if (rail.value && e.clientX <= RAIL_HOT_ZONE_PX) {
        hoverExpanded = true;
        rail.value = false;
    } else if (!rail.value && hoverExpanded && e.clientX > RAIL_RESET_PX) {
        hoverExpanded = false;
        rail.value = true;
    }
}

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
// Guest viewers on the tracker pages get a Login button where the account
// menu sits on every other page.
const isTrackerView = computed(() => kind.value === "viewer" && route.meta?.kind === "viewer");
// Viewers have a single page (Track), so the sidebar starts hidden; every
// other account gets it back. The shell outlives sign-ins, so a viewer
// session must not leave it hidden for the next admin or clerk.
watch(kind, (k) => {
    drawer.value = k !== "viewer" && !mobile.value;
}, { immediate: true });
// My Profile: every signed-in account except the shared guest viewer.
const hasProfile = computed(() => !!auth.user.value && kind.value !== "viewer");

// Account menu header.
const accountName = computed(
    () => auth.user.value?.name || auth.user.value?.username || "Account",
);
const accountEmail = computed(() => auth.user.value?.email || "");
const accountInitial = computed(
    () => (accountName.value || "?").trim().charAt(0).toUpperCase() || "?",
);

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
        work.push({ title: "Archive", icon: "mdi-archive-outline", to: "/portal/history" });
        return [
            { title: "Overview", items: [{ title: "Home", icon: "mdi-home-city-outline", to: "/portal", exact: true }] },
            { title: "Work", items: work },
        ];
    }
    const overview = { title: "Overview", items: [{ title: "Dashboard", icon: "mdi-view-dashboard", to: "/" }] };
    // Monitoring (read-only) for superadmins and office admins; the Reports
    // are a view inside the Dashboard.
    if (isSuperadmin.value || isOfficeAdmin.value) {
        overview.items.push({ title: "Activity Log", icon: "mdi-history", to: "/admin/activity" });
    }
    if (isSuperadmin.value) {
        return [
            overview,
            { title: "Work", items: [
                { title: "Transactions", icon: "mdi-swap-horizontal", to: "/transactions" },
                { title: "Archive", icon: "mdi-archive-outline", to: "/transactions/archive" },
            ] },
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
                ],
            },
        ];
    }
    if (isOfficeAdmin.value) {
        return [
            overview,
            { title: "Work", items: [
                { title: "Office Transactions", icon: "mdi-file-document-multiple", to: "/transactions" },
                { title: "Archive", icon: "mdi-archive-outline", to: "/transactions/archive" },
            ] },
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

const confirmLogout = ref(false);
const loggingOut = ref(false);

// ---- Viewer Back (header) ----
// The page before this one, when it is a real page to return to (not the
// welcome animation, a QR hand-off or the login screen).
function previousPage() {
    const prev = window.history.state?.back;
    if (typeof prev !== "string") return null;
    if (prev === "/track/welcome" || prev.startsWith("/scan/") || prev.startsWith("/login")) return null;
    return prev;
}
const onTrackSearch = computed(() => route.name === "track");
const viewerBackHint = computed(() => {
    if (!onTrackSearch.value) return previousPage() ? "Back to the previous page" : "Back to the search";
    return previousPage()?.startsWith("/track/") ? "Back to the previous page" : "Leave tracking and return to the login page";
});
async function viewerBack() {
    const prev = previousPage();
    if (!onTrackSearch.value) {
        if (prev) router.back();
        else router.push("/track");
        return;
    }
    if (prev?.startsWith("/track/")) {
        router.back();
        return;
    }
    await onLogout();
}

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
            { title: "Archive", subtitle: "Page", icon: "mdi-archive-outline", to: "/portal/history" },
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
    if (isSuperadmin.value || isOfficeAdmin.value) {
        pages.push(
            { title: "Reports", subtitle: "Dashboard · Monitoring", icon: "mdi-chart-box-outline", to: "/?view=reports" },
            { title: "Activity Log", subtitle: "Page · Monitoring", icon: "mdi-history", to: "/admin/activity" },
        );
    }
    if (isOfficeAdmin.value) {
        pages.push({ title: "Archive", subtitle: "Page · Admin", icon: "mdi-archive-outline", to: "/transactions/archive" });
    }
    if (isSuperadmin.value) {
        pages.push(
            { title: "Users", subtitle: "Page · Admin", icon: "mdi-account-group", to: "/admin/users" },
            { title: "Roles", subtitle: "Page · Admin", icon: "mdi-shield-account", to: "/admin/roles" },
            { title: "Archive", subtitle: "Page · Admin", icon: "mdi-archive-outline", to: "/transactions/archive" },
            { title: "Offices", subtitle: "Page · Admin", icon: "mdi-office-building-outline", to: "/admin/offices" },
            { title: "Workflows", subtitle: "Page · Admin", icon: "mdi-source-branch", to: "/admin/workflows" },
            { title: "Requirements", subtitle: "Page · Admin", icon: "mdi-clipboard-check-outline", to: "/admin/requirements" }
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

// ---- Animations on/off (sidebar button; shared with the login page) ----
const { motionEnabled, toggleMotion } = useMotion();

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
    window.addEventListener("pointermove", onPointerNearRail, { passive: true });
    weatherTimer = setInterval(() => {
        if (!document.hidden && navigator.onLine) loadTemperature();
    }, (slowNet ? 30 : 10) * 60 * 1000);
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
    window.removeEventListener("pointermove", onPointerNearRail);
    if (approvalBadgeTimer) clearInterval(approvalBadgeTimer);
});
</script>

<style scoped>
/* ---- Top bar (Facebook-like, in black-navy) -----------------------------
   The brand doubles as the menu toggle — logo, brand, search, status,
   account, log out — with Facebook's surface: near-black navy, pill search,
   round icon buttons and a circular avatar. */
.app-bar {
    /* Light chrome, theme-aware: white in the light theme and the theme's own
       dark surface when dark mode is on. */
    background: rgb(var(--v-theme-surface)) !important;
    border-bottom: 1px solid rgba(var(--v-border-color), 0.14);
    box-shadow: 0 4px 16px -12px rgba(0, 0, 0, 0.45) !important;
    color: rgb(var(--v-theme-on-surface));
}
/* Blue accent along the bottom edge, full width. */
.app-bar::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 2px;
    background: #2f6feb;
    pointer-events: none;
}
/* Breathing room at both ends of the bar. */
.app-bar :deep(.v-toolbar__content) {
    padding-inline: 24px;
}
/* Keep the sidebar below the bar in every mode (permanent, rail, mobile), so
   the first rows can never slide under it. */
:deep(.v-navigation-drawer) {
    top: var(--v-layout-top, 64px) !important;
    height: calc(100% - var(--v-layout-top, 64px)) !important;
}
/* White tile + rule keeps the pale seal from dissolving into the bar and
   separates it from the wordmark. */
.brand-logo {
    display: flex;
    align-items: center;
    justify-content: center;
    flex: none;
    box-sizing: border-box;
    width: 40px;
    height: 40px;
    /* Even 5px frame (border + padding) around a 30px square image. */
    padding: 4px;
    margin-right: 10px;
    border-radius: 10px;
    background: #fff;
    border: 1px solid rgba(var(--v-border-color), 0.16);
    box-shadow: 0 2px 6px -2px rgba(11, 18, 32, 0.18);
}
.brand-logo-img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    object-position: center;
}
.brand-divider {
    flex: none;
    width: 1px;
    height: 26px;
    margin-right: 10px;
    background: rgba(var(--v-theme-on-surface), 0.18);
}
.brand-title {
    color: rgb(var(--v-theme-on-surface));
    letter-spacing: -0.01em;
}
.brand-sub {
    color: rgba(var(--v-theme-on-surface), 0.55);
}
/* Time + weather: plain text, no pill around them. */
.nav-status {
    display: flex;
    align-items: center;
    height: 40px;
    color: rgba(var(--v-theme-on-surface), 0.7);
    margin-right: 8px;
}
.nav-seg {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 0 10px;
    font-size: 0.84rem;
    font-weight: 600;
    white-space: nowrap;
    color: rgba(var(--v-theme-on-surface), 0.7);
}
.nav-time-stack {
    display: flex;
    flex-direction: column;
    justify-content: center;
    min-width: 0;
    line-height: 1.05;
}
.nav-time-meta:empty {
    display: none;
}
.nav-time-value {
    font-size: 0.84rem;
    font-weight: 600;
    white-space: nowrap;
}
.nav-seg .v-icon {
    color: rgba(var(--v-theme-on-surface), 0.55);
    transition: color 0.15s ease;
}
.nav-seg:hover .v-icon {
    color: #0b1220;
}
.nav-sep {
    align-self: center;
    width: 1px;
    height: 16px;
    background: rgba(var(--v-theme-on-surface), 0.16);
}
/* Tracker pages: solid sign-in action beside the weather. */
.nav-login {
    height: 40px !important;
    margin-left: 4px;
    padding-inline: 16px !important;
    font-weight: 700;
    letter-spacing: 0.01em;
    box-shadow: none;
}
/* Account: bare avatar button; the tinted circle only appears on hover. */
.nav-account {
    display: flex;
    align-items: center;
    justify-content: center;
    flex: none;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 0;
    border-radius: 50%;
    background: transparent;
    color: rgba(var(--v-theme-on-surface), 0.7);
    cursor: pointer;
    transition: background-color 0.15s ease, color 0.15s ease;
}
/* Viewer Back: same quiet look as the account button, with a label. */
.nav-back {
    display: flex;
    align-items: center;
    gap: 6px;
    flex: none;
    height: 40px;
    padding: 0 14px 0 10px;
    border: 0;
    border-radius: 20px;
    background: transparent;
    color: rgba(var(--v-theme-on-surface), 0.75);
    font: inherit;
    font-size: 0.9rem;
    font-weight: 700;
    cursor: pointer;
    transition: background-color 0.15s ease, color 0.15s ease;
}
.nav-back:hover,
.nav-back:focus-visible {
    background: rgba(11, 18, 32, 0.09);
    color: #0b1220;
    outline: none;
}
.nav-back:disabled {
    opacity: 0.6;
    cursor: default;
}
.nav-account:hover,
.nav-account:focus-visible {
    background: rgba(11, 18, 32, 0.09);
    color: #0b1220;
    outline: none;
}

/* Facebook-style account menu: profile header, grouped actions, log out. */
.account-menu {
    width: 300px;
    max-width: calc(100vw - 24px);
    overflow: hidden;
    border: 1px solid rgba(var(--v-border-color), 0.12);
    box-shadow: 0 18px 46px -18px rgba(0, 0, 0, 0.45) !important;
}
.account-menu-head {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 8px;
    padding: 10px 12px;
    border-radius: 12px;
    transition: background-color 0.15s ease;
}
.account-menu-avatar {
    display: flex;
    align-items: center;
    justify-content: center;
    flex: none;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #1b74e4;
    color: #fff;
    font-size: 1rem;
    font-weight: 700;
}
.account-menu-id {
    min-width: 0;
}
.account-menu-name {
    font-size: 0.9rem;
    font-weight: 700;
    line-height: 1.25;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.account-menu-mail {
    margin-top: 1px;
    font-size: 0.72rem;
    color: rgba(var(--v-theme-on-surface), 0.55);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.account-menu-divider {
    margin: 4px 0 !important;
}
.account-menu-list {
    padding: 4px 8px !important;
}
.account-menu-list :deep(.v-list-item) {
    min-height: 42px;
    border-radius: 10px;
}
.account-menu-list :deep(.v-list-item-title) {
    font-size: 0.82rem;
    font-weight: 600;
}
.account-menu-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    margin-inline-end: 10px;
    border-radius: 50%;
    background: rgba(var(--v-theme-on-surface), 0.08);
    color: rgba(var(--v-theme-on-surface), 0.75);
}
.account-menu-icon--danger {
    background: rgba(211, 47, 47, 0.12);
    color: #d32f2f;
}
.account-menu-logout :deep(.v-list-item-title) {
    color: #d32f2f;
    font-weight: 700;
}
.logout-card {
    padding: 22px 22px 20px;
    border-radius: 18px !important;
    border: 1px solid rgba(var(--v-border-color), 0.12);
    box-shadow: 0 24px 60px -24px rgba(0, 0, 0, 0.45) !important;
}
.logout-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 8px;
}
.logout-title {
    font-size: 0.92rem;
    font-weight: 800;
    line-height: 1.3;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}
.logout-close {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    width: 30px;
    height: 30px;
    margin: -5px -5px 0 0;
    border: 0;
    border-radius: 10px;
    background: transparent;
    color: rgba(var(--v-theme-on-surface), 0.55);
    cursor: pointer;
    transition: background-color 0.15s ease, color 0.15s ease;
}
.logout-close:hover {
    background: rgba(var(--v-theme-on-surface), 0.08);
    color: rgba(var(--v-theme-on-surface), 0.9);
}
.logout-close:focus-visible {
    outline: 2px solid rgba(27, 116, 228, 0.5);
    outline-offset: 1px;
}
.logout-body {
    margin: 10px 0 0;
    font-size: 0.85rem;
    line-height: 1.5;
    color: rgba(var(--v-theme-on-surface), 0.62);
}
.logout-actions {
    display: flex;
    gap: 10px;
    margin-top: 22px;
}
.logout-btn {
    flex: 1 1 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    height: 40px;
    padding: 0 16px;
    border: 0;
    border-radius: 12px;
    font: inherit;
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 0.07em;
    text-transform: uppercase;
    cursor: pointer;
    transition: background-color 0.15s ease, box-shadow 0.15s ease, transform 0.1s ease;
}
.logout-btn:active {
    transform: translateY(1px);
}
.logout-btn:focus-visible {
    outline: 2px solid rgba(27, 116, 228, 0.5);
    outline-offset: 2px;
}
.logout-btn--cancel {
    background: rgba(var(--v-theme-on-surface), 0.07);
    color: rgba(var(--v-theme-on-surface), 0.8);
}
.logout-btn--cancel:hover {
    background: rgba(var(--v-theme-on-surface), 0.12);
}
.logout-btn--confirm {
    background: #1b74e4;
    color: #fff;
    box-shadow: 0 8px 18px -10px rgba(27, 116, 228, 0.9);
}
.logout-btn--confirm:hover {
    background: #1668d3;
    box-shadow: 0 10px 22px -10px rgba(27, 116, 228, 0.95);
}
.logout-btn--confirm:disabled {
    opacity: 0.6;
    cursor: default;
    box-shadow: none;
}
.brand-click {
    cursor: pointer;
    user-select: none;
    border-radius: 8px;
    transition: opacity 0.15s ease;
}
.brand-click:hover {
    opacity: 0.82;
}
.brand-click:focus-visible {
    outline: 2px solid rgba(47, 111, 235, 0.45);
    outline-offset: 4px;
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
    line-height: 16px;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: rgba(var(--v-theme-on-surface), 0.45);
    white-space: nowrap;
    animation: nav-label-in 0.25s ease both;
}
.nav-groups > .nav-group-label:first-child {
    padding-top: 4px;
}
/* In the rail the label stays, smaller and centred over its icons; the fixed
   line-height keeps every row on the same y as when the menu is open. */
.nav-group-label--rail {
    padding-left: 0;
    padding-right: 0;
    font-size: 0.53rem;
    letter-spacing: 0.08em;
    text-align: center;
    overflow: hidden;
    text-overflow: clip;
    animation: none;
}
@keyframes nav-label-in {
    from { opacity: 0; transform: translateX(-4px); }
}
.nav-groups :deep(.v-list-item) {
    transition: background-color 0.18s ease, color 0.18s ease;
}
.nav-groups :deep(.v-list-item:not(.v-list-item--active):hover .v-icon) {
    color: #0b1220;
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
/* Active nav item: Facebook's light-blue selected pill (no heavy dark tile). */
:deep(.v-navigation-drawer .v-list-item--active) {
    background: rgba(11, 18, 32, 0.1) !important;
    color: #0b1220 !important;
    box-shadow: none;
}
:deep(.v-navigation-drawer .v-list-item--active > .v-list-item__overlay) {
    opacity: 0 !important;
}
:deep(.v-navigation-drawer .v-list-item--active .v-icon),
:deep(.v-navigation-drawer .v-list-item--active .v-list-item-title) {
    color: #0b1220 !important;
    opacity: 1 !important;
}
/* Hover: same tint at half strength, icon goes blue. */
:deep(.v-navigation-drawer .v-list-item:not(.v-list-item--active):hover) {
    background: rgba(11, 18, 32, 0.05) !important;
}
:deep(.v-navigation-drawer .v-list-item) {
    border-radius: 10px;
    margin: 1px 8px;
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
:deep(.v-navigation-drawer--rail .v-list-item) {
    margin-inline: 8px;
}
.app-drawer {
    background: rgb(var(--v-theme-surface)) !important;
    border-right: 1px solid rgba(var(--v-border-color), 0.16) !important;
}
/* Sidebar: the settings row (expanded) and its gear (collapsed rail). */
.nav-settings-item {
    margin: 1px 8px 6px;
    border-radius: 10px;
}
.nav-settings-label {
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 0.04em;
}
.nav-rail-tools {
    display: flex;
    justify-content: center;
    padding: 8px 0;
}
.nav-rail-gear {
    color: rgba(var(--v-theme-on-surface), 0.6) !important;
}
.nav-rail-gear:hover {
    color: #2f6feb !important;
    background: rgba(47, 111, 235, 0.08) !important;
}
/* ---- Settings dialog ---- */
.settings-row {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 10px 0;
}
.settings-row + .settings-row {
    border-top: 1px solid rgba(var(--v-border-color), 0.1);
}
.settings-row__icon {
    color: #2f6feb;
    flex: none;
}
.settings-row__text {
    flex: 1 1 auto;
    min-width: 0;
}
.settings-row__title {
    font-size: 0.92rem;
    font-weight: 700;
}
.settings-row__sub {
    margin-top: 2px;
    font-size: 0.75rem;
    color: rgba(var(--v-theme-on-surface), 0.55);
}
/* Search: light pill (Facebook's gray field), blue ring on focus. */
.search-pixiv :deep(.v-field) {
    min-height: 40px;
    max-height: 40px;
    background: rgba(var(--v-theme-on-surface), 0.07);
    border: 1px solid transparent;
    box-shadow: none;
    color: rgb(var(--v-theme-on-surface));
    transition: background-color 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
}
.search-pixiv :deep(.v-field:hover) {
    background: rgba(var(--v-theme-on-surface), 0.1);
}
.search-pixiv :deep(.v-field--focused) {
    background: rgba(var(--v-theme-on-surface), 0.1);
    border-color: #2f6feb;
    box-shadow: 0 0 0 2px rgba(47, 111, 235, 0.25);
}
.search-pixiv :deep(.v-field__input) {
    min-height: 40px;
    padding-top: 4px;
    padding-bottom: 4px;
    color: rgb(var(--v-theme-on-surface));
}
.search-pixiv :deep(.v-field__prepend-inner .v-icon) {
    color: rgba(var(--v-theme-on-surface), 0.55);
    opacity: 1;
}
.search-pixiv :deep(.v-field__append-inner .v-icon) {
    color: rgba(var(--v-theme-on-surface), 0.45);
    font-size: 18px;
}
.search-pixiv :deep(input),
.search-pixiv :deep(input::placeholder) {
    font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
    font-weight: 500;
    color: rgb(var(--v-theme-on-surface));
}
.search-pixiv :deep(input::placeholder) {
    color: rgba(var(--v-theme-on-surface), 0.5);
    opacity: 1;
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
