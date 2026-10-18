import { createRouter as _createRouter, createWebHistory } from "vue-router";
import Login from "@/pages/Login.vue";
// Lazy-load everything below so /login (and first paint on slow devices /
// bad networks) only downloads the shell + login chunk. Each page becomes
// its own async chunk via Vite code-splitting.
const Dashboard = () => import("@/pages/Dashboard.vue");

const AdminUsers = () => import("@/pages/admin/Users.vue");
const AdminRoles = () => import("@/pages/admin/Roles.vue");
const AdminOffices = () => import("@/pages/admin/Offices.vue");
const AdminOfficeSteps = () => import("@/pages/admin/OfficeSteps.vue");
const AdminTransactionTypes = () => import("@/pages/admin/TransactionTypes.vue");
const AdminGovernmentReferences = () => import("@/pages/admin/GovernmentReferences.vue");
const AdminWorkflows = () => import("@/pages/admin/Workflows.vue");
const AdminFields = () => import("@/pages/admin/Fields.vue");
const AdminStepFields = () => import("@/pages/admin/StepFields.vue");

const AdminRequirements = () => import("@/pages/admin/Requirements.vue");
const AdminStepRequirements = () => import("@/pages/admin/StepRequirements.vue");
const AdminStepData = () => import("@/pages/admin/StepData.vue");
const AdminStepChecklist = () => import("@/pages/admin/StepChecklist.vue");
const AdminRequirementsIndex = () => import("@/pages/admin/RequirementsIndex.vue");

const TransactionsList = () => import("@/pages/transactions/TransactionList.vue");
const TransactionDetail = () => import("@/pages/transactions/TransactionDetail.vue");

const MyTransactionsList = () => import("@/pages/my/MyTransactionList.vue");
const MyTransactionDetail = () => import("@/pages/my/MyTransactionDetail.vue");

const ApprovalInbox = () => import("@/pages/approvals/ApprovalInbox.vue");

const Help = () => import("@/pages/Help.vue");

// User portal (every role except superadmin/admin) and the read-only viewer
// tracking pages.
const PortalHome = () => import("@/pages/portal/PortalHome.vue");
const PortalTransactions = () => import("@/pages/portal/PortalTransactions.vue");
const TrackWelcome = () => import("@/pages/track/TrackWelcome.vue");
const TrackList = () => import("@/pages/track/TrackList.vue");
const TrackDetail = () => import("@/pages/track/TrackDetail.vue");

import { useAuth, canUseApprovals, isOfficeAdminUser, userKind, homePathFor } from "@/composables/useAuth";
import { anyStagingDirty } from "@/composables/useWorkflowStaging";
import { confirm } from "@/composables/useConfirm";

export function createRouter() {
    const router = _createRouter({
        history: createWebHistory(),
        routes: [
            { path: "/login", name: "login", component: Login },

            {
                path: "/",
                name: "dashboard",
                component: Dashboard,
                meta: { requiresAuth: true, title: "Dashboard" },
            },

            {
                path: "/portal",
                name: "portal",
                component: PortalHome,
                meta: { requiresAuth: true, title: "Home", kind: "staff" },
            },
            {
                path: "/portal/transactions",
                name: "portal.transactions",
                component: PortalTransactions,
                meta: { requiresAuth: true, title: "Transactions", kind: "staff" },
            },
            {
                // Short opening animation for viewers; `bare` hides the app chrome.
                path: "/track/welcome",
                name: "track.welcome",
                component: TrackWelcome,
                meta: { requiresAuth: true, title: "Welcome", kind: "viewer", bare: true },
            },
            {
                path: "/track",
                name: "track",
                component: TrackList,
                meta: { requiresAuth: true, title: "Track Transactions", kind: "viewer" },
            },
            {
                path: "/track/:id",
                name: "track.detail",
                component: TrackDetail,
                meta: { requiresAuth: true, title: "Track Transaction", kind: "viewer" },
            },

            {
                path: "/admin/users",
                component: AdminUsers,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/roles",
                component: AdminRoles,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/offices",
                component: AdminOffices,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/offices/:officeId/steps",
                name: "admin.office-steps",
                component: AdminOfficeSteps,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/transaction-types",
                component: AdminTransactionTypes,
                meta: { requiresAuth: true, officeAdmin: true },
            },
            {
                path: "/admin/government-references",
                component: AdminGovernmentReferences,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/workflows",
                component: AdminWorkflows,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/fields",
                component: AdminFields,
                meta: { requiresAuth: true, superadmin: true },
            },

            {
                path: "/admin/workflows/:workflowId/steps/:stepId/fields",
                name: "admin.step-fields",
                component: AdminStepFields,
                meta: { requiresAuth: true, superadmin: true },
            },

            {
                path: "/admin/workflows/:workflowId/requirements",
                name: "admin.requirements",
                component: AdminRequirements,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/workflows/:workflowId/steps/:stepId/requirements",
                name: "admin.step-requirements",
                component: AdminStepRequirements,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/admin/workflows/:workflowId/steps/:stepId/step-data",
                name: "admin.step-data",
                component: AdminStepData,
                meta: { requiresAuth: true, superadmin: true },
            },

            {
                path: "/transactions",
                component: TransactionsList,
                meta: { requiresAuth: true },
            },
            {
                path: "/transactions/:id",
                component: TransactionDetail,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/requirements",
                name: "admin.requirements",
                component: AdminRequirementsIndex,
                meta: { requiresAuth: true, superadmin: true },
            },
            {
                path: "/my/transactions",
                name: "my.transactions",
                component: MyTransactionsList,
                meta: { requiresAuth: true },
            },
            {
                path: "/my/transactions/:id",
                name: "my.transaction.detail",
                component: MyTransactionDetail,
                meta: { requiresAuth: true },
            },
            {
                path: "/approvals",
                name: "approvals",
                component: ApprovalInbox,
                meta: { requiresAuth: true, title: "Approvals" },
            },
            {
                path: "/help",
                name: "help",
                component: Help,
                meta: { requiresAuth: true },
            },
        ],
    });

    router.beforeEach(async (to) => {
        const auth = useAuth();
        if (!auth.initialized.value) await auth.init();
        if (to.meta.requiresAuth && !auth.user.value) return { name: "login" };
        if (to.name === "login" && auth.user.value)
            return homePathFor(auth.user.value);

        // Each kind of account lives in its own set of pages.
        if (auth.user.value) {
            const kind = userKind(auth.user.value);
            if (kind === "viewer") {
                // Right after sign-in (login pushes "dashboard") they get the
                // welcome animation. Otherwise read-only: tracking pages and
                // Help only.
                if (to.name === "dashboard") return "/track/welcome";
                if (to.meta.kind !== "viewer" && to.name !== "help") return "/track";
            } else if (to.meta.kind && to.meta.kind !== kind) {
                return homePathFor(auth.user.value);
            } else if (kind === "staff" && to.name === "dashboard") {
                return "/portal";
            }
        }
        if (to.name === "approvals" && !canUseApprovals(auth.user.value))
            return { name: "dashboard" };
        // My Transactions is redundant for superadmin (bypass returns all rows,
        // same as Transactions) — send them to the admin list instead.
        const roles = auth.user.value?.roles ?? [];
        const isSuperadmin = roles.some((r) => r.code === "superadmin");
        if (to.meta.superadmin && !isSuperadmin) return { name: "dashboard" };
        if (to.meta.officeAdmin && !isSuperadmin && !isOfficeAdminUser(auth.user.value))
            return { name: "dashboard" };
        if (isSuperadmin && to.path.startsWith("/my/transactions")) {
            const rest = to.path.slice("/my/transactions".length);
            return rest ? `/transactions${rest}` : "/transactions";
        }
        // Staged workflow edits live only in memory until Save version:
        // stop accidental loss on navigation (Save and Discard live on the
        // workflow pages; a reload also drops staged edits).
        if (anyStagingDirty()) {
            const leave = await confirm({
                title: "Leave without saving?",
                message: "You have unsaved workflow changes. Leave without saving them?",
                confirmLabel: "Leave",
                cancelLabel: "Stay",
            });
            if (!leave) return false;
        }
        return true;
    });

    router.afterEach((to) => {
        const base = "TransactionMF";
        document.title = to.meta?.title ? `${base} | ${to.meta.title}` : base;
    });

    return router;
}
