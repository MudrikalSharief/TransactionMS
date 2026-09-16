# 2. Architecture

## Stack
- Backend: Laravel 11, Sanctum SPA (cookie/session, not tokens), MySQL (`DB_DATABASE=transaction`)
- Frontend: Vue 3, Vue Router `createWebHistory`, Vuetify 3 (`pixivLight`), Axios `withCredentials:true`
- Build: Vite (`npm run build` -> `public/build`), Laravel SPA fallback in `routes/web.php`

## Backend layout (`app/`)
- `Models/`: `User, Role, Permission, Transaction, TransactionType, WorkflowDefinition, WorkflowStep, WorkflowRoute, StepRole, FieldDefinition, FieldValue, RequirementDefinition, TransactionRequirementCheck, TransactionState, TransactionStepRun, AuditLog`
- `Http/Controllers/Api/`: `AuthController (login/me/logout)`, `UserTransactionController (index/show/execute, role-filtered)`, `TransactionController (admin, unfiltered)`, `TransactionRequirementController (check/uncheck)`, `Admin/* (Users, Roles, TransactionTypes, Workflows, Steps, Routes, Fields, Requirements, GovRefs)`
- `Http/Requests/`: `Auth/LoginRequest`, `Transactions/*`, `Admin/*`, `Admin/Workflows/*`, `Admin/Fields/*`, `Admin/Requirements/*`
- `Http/Resources/`: `User, Role, Transaction, Workflow*, Field*, Requirement*, TransactionType, GovernmentReference`
- `Http/Middleware/EnsureRole.php`: `401 if guest, 403 if !hasRole(code)`. Used as `EnsureRole:superadmin` on `admin/*`.
- `Services/`: `RoutingEngine`, `TransactionEngine`, `JsonLogicEvaluator`, `FieldValidationService`, `WorkflowVersioningService`, `AuditService`
- `routes/api.php` (prefix `/api`), `routes/web.php` (SPA fallback `/{any}` excluding `api`), `bootstrap/app.php` (api middleware: stateful + throttle + bindings)

## Frontend layout (`resources/js/`)
- `app.js`: mounts `AppShell.vue` with router + Vuetify
- `router/index.js`: `/login`, `/ (dashboard)`, `/transactions`, `/transactions/:id`, `/my/transactions`, `/my/transactions/:id`, `/admin/* (users, roles, transaction-types, workflows, fields, requirements, gov-references, step-fields, step-requirements)`. Guard: `init() once via GET /api/auth/me`, redirect to `login` if `requiresAuth` and no user.
- `composables/`: `useApi (axios + csrf())`, `useAuth (user, init, login, logout)`, `useTransactions, useMyTransactions, useTransactionTypes, useWorkflows, useAdminUsers, useRoles, useFieldDefinitions, useRequirementDefinitions, useStepFields, useStepRequirements, useGovernmentReferences, useCache`
- `components/AppShell.vue`: app bar (search, Manila clock, weather `/api/weather` -> Open-Meteo `6.9214,122.0790`, user chip, logout) + rail drawer. Hides chrome on `login`.
- `pages/`: `Login.vue`, `Dashboard.vue`, `transactions/TransactionList|Detail.vue`, `my/MyTransactionList|Detail.vue`, `admin/*.vue`
- `plugins/vuetify.js`: `pixivLight` theme (`primary #0096FA`), mdi icons
