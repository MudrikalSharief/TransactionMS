import { createRouter as _createRouter, createWebHistory } from "vue-router";
import Login from "@/pages/Login.vue";
import Dashboard from "@/pages/Dashboard.vue";

import AdminUsers from "@/pages/admin/Users.vue";
import AdminRoles from "@/pages/admin/Roles.vue";
import AdminOffices from "@/pages/admin/Offices.vue";
import AdminOfficeSteps from "@/pages/admin/OfficeSteps.vue";
import AdminTransactionTypes from "@/pages/admin/TransactionTypes.vue";
import AdminGovernmentReferences from "@/pages/admin/GovernmentReferences.vue";
import AdminWorkflows from "@/pages/admin/Workflows.vue";
import AdminFields from "@/pages/admin/Fields.vue";
import AdminStepFields from "@/pages/admin/StepFields.vue";

import AdminRequirements from "@/pages/admin/Requirements.vue";
import AdminStepRequirements from "@/pages/admin/StepRequirements.vue";
import AdminStepChecklist from "@/pages/admin/StepChecklist.vue";
import AdminRequirementsIndex from "@/pages/admin/RequirementsIndex.vue";

import TransactionsList from "@/pages/transactions/TransactionList.vue";
import TransactionDetail from "@/pages/transactions/TransactionDetail.vue";

import MyTransactionsList from "@/pages/my/MyTransactionList.vue";
import MyTransactionDetail from "@/pages/my/MyTransactionDetail.vue";

import ApprovalInbox from "@/pages/approvals/ApprovalInbox.vue";

import Help from "@/pages/Help.vue";

import { useAuth, canUseApprovals } from "@/composables/useAuth";

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
                path: "/admin/users",
                component: AdminUsers,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/roles",
                component: AdminRoles,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/offices",
                component: AdminOffices,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/offices/:officeId/steps",
                name: "admin.office-steps",
                component: AdminOfficeSteps,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/transaction-types",
                component: AdminTransactionTypes,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/government-references",
                component: AdminGovernmentReferences,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/workflows",
                component: AdminWorkflows,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/fields",
                component: AdminFields,
                meta: { requiresAuth: true },
            },

            {
                path: "/admin/workflows/:workflowId/steps/:stepId/fields",
                name: "admin.step-fields",
                component: AdminStepFields,
                meta: { requiresAuth: true },
            },

            {
                path: "/admin/workflows/:workflowId/requirements",
                name: "admin.requirements",
                component: AdminRequirements,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/workflows/:workflowId/steps/:stepId/requirements",
                name: "admin.step-requirements",
                component: AdminStepRequirements,
                meta: { requiresAuth: true },
            },
            {
                path: "/admin/workflows/:workflowId/steps/:stepId/checklist",
                name: "admin.step-checklist",
                component: AdminStepChecklist,
                meta: { requiresAuth: true },
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
                meta: { requiresAuth: true },
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
            return { name: "dashboard" };
        if (to.name === "approvals" && !canUseApprovals(auth.user.value))
            return { name: "dashboard" };
        return true;
    });

    router.afterEach((to) => {
        const base = "TransactionMS Management System";
        document.title = to.meta?.title ? `${base} | ${to.meta.title}` : `${base} | Dashboard`;
    });

    return router;
}
