# Code Map

Where to look when you want to change something. To search inside a file, use
Ctrl+P in VS Code to open it by name and Ctrl+Shift+F to search the whole project.

## How a request flows

```
Browser page (resources/js/pages/...)
  -> composable that calls the API (resources/js/composables/...)
  -> route (routes/api.php)
  -> controller (app/Http/Controllers/Api/...)
  -> service for the business rules (app/Services/...)
  -> model and database (app/Models/..., database/migrations/...)
```

To trace a feature, start at its page and follow the `api.get` / `api.post` URL
into `routes/api.php`, which names the controller.

## Folders

| Folder | What is in it |
| --- | --- |
| `resources/js/pages/` | One file per screen, grouped by who uses it: `admin/`, `portal/` (staff), `track/` (viewers), `transactions/`, `approvals/` |
| `resources/js/components/` | Parts shared between screens: dialogs, badges, cards, the app frame |
| `resources/js/composables/` | Reusable logic and API calls, named `useSomething.js` |
| `resources/js/router/index.js` | Every URL, which page it opens and who may open it |
| `resources/js/plugins/vuetify.js` | Theme colours and icon setup |
| `resources/css/app.css` | Global styles. Styles for one screen live at the bottom of its `.vue` file |
| `public/` | Files served as they are: logos, office icons, the service worker |
| `routes/api.php` | Every API URL and the controller behind it |
| `app/Http/Controllers/Api/` | API handlers. `Admin/` is for admin screens, `Office/` for office admins |
| `app/Http/Requests/` | Validation rules for submitted forms |
| `app/Http/Resources/` | The JSON shape sent back to the browser |
| `app/Services/` | Business rules, kept apart from the controllers |
| `app/Models/` | One class per database table |
| `database/migrations/` | Table changes, in date order |
| `database/seeders/` | Starting data: roles, offices, accounts, workflows |

## "I want to change..."

| What | Where |
| --- | --- |
| Sidebar links and the top bar | `resources/js/components/AppShell.vue` (links are in `navGroups`) |
| Footer | `resources/js/components/AppFooter.vue`, artwork in `public/footer-hall.webp` |
| Login page | `resources/js/pages/Login.vue` |
| Login picture and its animated ring | `resources/js/components/login/LoginHero.vue`, `public/login-hero.webp` |
| Sign-in and who gets which home page | `resources/js/composables/useAuth.js`, `app/Http/Controllers/Api/AuthController.php` |
| Which URLs each role can open | `resources/js/router/index.js`, then the middleware in `routes/api.php` |
| Overdue popup after sign-in | `resources/js/components/LoginApprovalNotice.vue`, `resources/js/composables/useLoginNotice.js` |
| Due count label on Transactions | `resources/js/pages/portal/PortalTransactions.vue`, `resources/js/composables/useDueCount.js` |
| Staff home | `resources/js/pages/portal/PortalHome.vue`, `app/Http/Controllers/Api/PortalController.php` |
| Staff task page | `resources/js/pages/portal/PortalApprovals.vue`, `app/Http/Controllers/Api/ApprovalController.php` |
| Proceed steps on a transaction | `resources/js/components/ProceedWizard.vue` |
| Transaction details | `resources/js/pages/transactions/TransactionDetail.vue`, `app/Http/Controllers/Api/TransactionController.php` |
| File upload and list | `resources/js/components/AttachmentUploader.vue`, `AttachmentList.vue`, `app/Http/Controllers/Api/TransactionAttachmentController.php` |
| Viewer tracking | `resources/js/pages/track/`, `app/Http/Controllers/Api/ViewerTrackingController.php` |
| Admin dashboard | `resources/js/pages/Dashboard.vue`, `app/Http/Controllers/Api/Admin/DashboardSummaryController.php` |
| Workflow editor | `resources/js/pages/admin/Workflows.vue`, `resources/js/composables/useWorkflowStaging.js`, `app/Services/WorkflowStagingService.php` |
| How a transaction moves between steps | `app/Services/TransactionEngine.php`, `app/Services/RoutingEngine.php` |
| Users, roles, offices admin | `resources/js/pages/admin/Users.vue`, `Roles.vue`, `Offices.vue` |
| Office icons | `resources/js/utils/officeIcons.js`, `public/images/offices/` |
| Colours and theme | `resources/js/plugins/vuetify.js` |
| Browser caching | `public/sw.js`, `resources/js/composables/useCache.js` |
| Add or change a database table | New file in `database/migrations/`, plus its class in `app/Models/` |

## Large files

These are the longest files in the project, so search by function name instead of
scrolling: `resources/js/pages/admin/Workflows.vue`, `StepRequirements.vue`,
`StepData.vue`, `Users.vue` and `resources/js/pages/transactions/TransactionDetail.vue`.
Each of these `.vue` files has three parts: `<template>` (the HTML), `<script>` (the
logic) and `<style>` (the CSS).
