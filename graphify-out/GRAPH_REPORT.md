# Graph Report - TransactionMS  (2026-10-16)

## Corpus Check
- 312 files · ~222,061 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 24 file(s) not represented in the graph (top: (none) 17, .jsonc 2, .example 1)

## Summary
- 2999 nodes · 5049 edges · 247 communities (124 shown, 123 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 383 edges (avg confidence: 0.85)
- Token cost: 282,960 input · 0 output

## Community Hubs (Navigation)
- My Transaction Detail Page
- Admin Transaction Detail Page
- Workflow Builder Page
- Transaction Execution & Checklist API
- Dashboard Page
- Proceed Wizard
- Composer Dependencies
- Summary Rows & Type Helpers
- App Shell & Navigation
- Requirements Index Page
- Attachments & History List
- Core Laravel Migrations
- API Resources & Role Middleware
- Approval Proceed Dialog
- Summary Detail Dialog
- Transaction List Page
- Admin Lookup Controllers
- Step Requirements Page
- Dashboard Summary API
- Architecture Docs
- Workflow Staging (Frontend)
- Step Checklist Page
- App Bootstrap & Shared UI
- Shared UI Components
- Grouped Bar Chart
- Step Data Page
- Step Data & Requirement API
- API Routes & Endpoints
- Step Data Models
- Workflow Schema Migrations
- Frontend Router
- Data Composables
- Step Fields Page
- Workflow Steps & Routes API
- Approvals & User Transactions API
- Database Seeders
- Summary Popover
- Field Definitions Page
- Approval Inbox Page
- Requirement Definitions API
- Route Flow Preview
- Reference & Audit Models
- Workflow Staging Service
- Step Progress Tracker
- System Overview Docs
- User Flow & API Docs
- Requirements Page
- Office Steps API
- Roles, Types & Test Base
- Transaction Schema Migrations
- Office Steps Page
- Users Admin Page
- Step Checklist API
- Attachment Upload API
- Help Guide Page
- Transaction & Field Models
- Workflow Engine & Auth Docs
- Frontend Build Config
- Reference & Office Migrations
- Admin Setup Docs
- My Transaction List Page
- History Formatting Utils
- Users API
- Workflow Publishing API
- Form Request Validation
- Attachment Uploader
- Donut Chart
- Transactions Composable
- Workflows Composable
- Dashboard Summary Tests
- Maintenance Commands
- Field Definitions API
- User Transactions API
- Transaction Engine
- Staging Save Bar
- Roles Admin Page
- Approval Inbox Tests
- Workflow Versioning Service
- Auth Controller
- Transaction Step Run
- Login
- Use Cache
- Use My Transactions
- My Transaction Detail
- Field Validation Service
- User Factory
- Package
- Government References
- My Transaction Detail (2)
- Transaction Detail
- Json Logic Evaluator
- Purchase Request Setup Seeder
- Zamboanga seal
- Jump Back Dialog
- Use Offices
- Store Office Request
- Transaction Attachment
- Checklist Service
- Workflow Seeder
- Approval Proceed Dialog (2)
- Proceed Wizard (2)
- Use Auth
- Workflow Make Live Test
- Upsert Workflow Route Request
- Transaction Step Run Resource
- App Service Provider
- App
- Package (2)
- Station Node
- Transaction Detail (2)
- Workflow Save As Test
- README
- Step Data Fields
- Use Dashboard Layout
- Use Requirement Definitions
- Use Step Data
- Workflows
- Workflows (2)
- Transaction Checklist Check
- Transaction Requirement Check
- Readd parent id to office steps table
- Use Api
- Checklist Tracking Guide
- Use Admin Users
- Use Approval Badge
- Use Field Definitions
- Use Roles
- Dashboard
- My Transaction Detail (3)
- Update User Request
- Apply Staged Workflow Request
- Upload Attachment Request
- Create cache table
- Add is active to users table
- Add pivot meta to field definition workf
- Alter field definitions make workflow de
- Add office id to transactions table
- Drop parent id from office steps table
- Drop parent id from workflow steps table
- Add office id to workflow steps table
- Add is done to transactions table
- Add label to requirement definitions tab
- Rename label to code on checklist overri
- Add label to transaction attachments tab
- Package (3)
- Approval Proceed Dialog (3)
- Use Confirm
- Roles
- Store Field Definition Request
- Sync Step Fields Request
- Update Field Definition Request
- Publish Workflow Definition Request
- Store Requirement Definition Request
- Sync Step Requirements Request
- Update Requirement Definition Request
- Store Government Reference Request
- Store Role Request
- Store Transaction Type Request
- Store User Request
- Update Government Reference Request
- Update Transaction Type Request
- Create Draft Request
- Save As Version Request
- Upsert Workflow Step Request
- Check Requirement Request
- Goto Station Request
- Transition Transaction Request
- Transaction Resource
- Transaction State
- Create roles table
- Create permission role table
- Create role user table
- Create audit logs table
- Create workflow definitions table
- Create workflow steps table
- Create step roles table
- Create workflow routes table
- Create transaction step runs table
- Create field definitions table
- Create field values table
- Create requirement definitions table
- Create requirement checks table
- Create requirement definition workflow s
- Create step requirements table
- Create transaction requirement checks ta
- Create offices table
- Create transaction attachments table
- Create office transaction type table
- Create checklist overrides table
- Create transaction checklist checks tabl
- Create workflow step data table
- Create transaction step data table
- Example Test
- Sw
- Logout
- Mascot empty
- Use File View
- Workflows (3)
- Workflows (4)
- Workflows (5)
- Workflows (6)
- Workflows (7)
- Dashboard (2)
- Dashboard (3)
- My Transaction Detail (4)
- Transaction Detail (3)
- Transaction Detail (4)
- Transaction Detail (5)
- Package (4)
- Loginpage
- Approval Proceed Dialog (4)
- Approval Proceed Dialog (5)
- Proceed Wizard (3)
- Proceed Wizard (4)
- Live Update Badge
- Dashboard (4)
- My Transaction Detail (5)
- Transaction Detail (6)
- Dates
- Steps
- Confirm Action Dialog
- Proceed Wizard (5)
- Proceed Wizard (6)
- Workflows (8)
- Dashboard (5)
- Dashboard (6)
- Transaction Detail (7)

## God Nodes (most connected - your core abstractions)
1. `WorkflowDefinition` - 91 edges
2. `Transaction` - 90 edges
3. `vue` - 66 edges
4. `WorkflowStep` - 57 edges
5. `Controller` - 53 edges
6. `RoutingEngine` - 49 edges
7. `AuditService` - 36 edges
8. `User` - 33 edges
9. `ChecklistService` - 25 edges
10. `TransactionResource` - 24 edges

## Surprising Connections (you probably didn't know these)
- `robots.txt (allow all crawlers)` --conceptually_related_to--> `Vite Build + SPA Fallback Route`  [AMBIGUOUS]
  public/robots.txt → docs/02-architecture.md
- `RoutingEngine::assertUserCanExecute` --semantically_similar_to--> `RoutingEngine::assertRouteExecutable`  [AMBIGUOUS] [semantically similar]
  docs/10-finish-transaction-button.md → docs/06-workflow-engine.md
- `Local Vite-Bundled Assets (no CDN)` --references--> `Vite Build + SPA Fallback Route`  [INFERRED]
  resources/js/assets/mascots/README.md → docs/02-architecture.md
- `DashboardSummaryTest` --references--> `Office`  [EXTRACTED]
  tests/Feature/DashboardSummaryTest.php → app/Models/Office.php
- `ApprovalInboxTest` --references--> `RequirementDefinition`  [EXTRACTED]
  tests/Feature/ApprovalInboxTest.php → app/Models/RequirementDefinition.php

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Step Execution Flow (execute -> assert -> validate -> record)** — docs_07_api_reference_execute_endpoint, docs_06_workflow_engine_transitionbyroute, docs_06_workflow_engine_assertrouteexecutable, docs_06_workflow_engine_assertrequiredrequirementschecked, docs_06_workflow_engine_usercanworkonstep, docs_06_workflow_engine_jsonlogicevaluator, docs_06_workflow_engine_fieldvalidationservice, docs_01_overview_step_run, docs_01_overview_transaction_state [INFERRED 0.85]
- **Layered Authorization (API gate, step gate, UI gate)** — docs_02_architecture_ensurerole_middleware, docs_03_auth_roles_admin_api_gate, docs_03_auth_roles_step_role_gate, docs_06_workflow_engine_usercanworkonstep, docs_08_database_step_roles_table, docs_03_auth_roles_ui_only_admin_gate [INFERRED 0.85]
- **Workflow Versioning and Pinning** — docs_01_overview_workflow_definition, docs_06_workflow_engine_workflowversioningservice, docs_05_admin_guide_transaction_steps_editor, docs_06_workflow_engine_pinned_version_rule, docs_07_api_reference_workflow_publish_endpoint, docs_08_database_runtime_tables [INFERRED 0.85]
- **Muslim-Christian coexistence symbolism** — public_zamboanga_seal_official_seal, public_zamboanga_seal_crescent_and_star, public_zamboanga_seal_cross [INFERRED 0.85]
- **Maritime heritage symbolism** — public_zamboanga_seal_official_seal, public_zamboanga_seal_vinta, public_zamboanga_seal_fish [INFERRED 0.75]
- **Mascot Logout Scene** — resources_js_assets_mascots_logout_bluebird_mascot, resources_js_assets_mascots_logout_exit_door, resources_js_assets_mascots_logout_logout_action [INFERRED 0.85]

## Communities (247 total, 123 thin omitted)

### Community 0 - "My Transaction Detail Page"
Cohesion: 0.02
Nodes (75): actionButtonLabel, { api }, attachmentName, auth, autoReturnInfo, availableActions, checkAttachments, checkDialog (+67 more)

### Community 1 - "Admin Transaction Detail Page"
Cohesion: 0.02
Nodes (70): actionButtonLabel, { api }, attachmentName, auth, autoReturnInfo, availableActions, checkAttachments, checkDialog (+62 more)

### Community 2 - "Workflow Builder Page"
Cohesion: 0.03
Nodes (62): activeDef, bootSkeleton, currentDef, {
    defs,
    loading,
    fetchDefinitions,
    makeLive,
}, draftDef, error, flatStepRows, fromStepOptions (+54 more)

### Community 3 - "Transaction Execution & Checklist API"
Cohesion: 0.11
Nodes (7): TransactionChecklistController, TransactionController, TransactionResource, Transaction, WorkflowRoute, RoutingEngine, TransactionEngine

### Community 4 - "Dashboard Page"
Cohesion: 0.04
Nodes (46): actionQueue, { api }, auth, barEls, byProcessRows, cardIds, detail, dragId (+38 more)

### Community 5 - "Proceed Wizard"
Cohesion: 0.04
Nodes (40): { api }, attachmentName, checkedRequirementsCount, checklistComplete, eligiblePrevFiles, existingDialog, existingError, existingForAdditional (+32 more)

### Community 6 - "Composer Dependencies"
Cohesion: 0.04
Nodes (48): pestphp/pest-plugin, php-http/discovery, autoload, autoload-dev, psr-4, psr-4, config, allow-plugins (+40 more)

### Community 7 - "Summary Rows & Type Helpers"
Cohesion: 0.05
Nodes (32): byName(), cache, dur(), minutesSince(), rowView(), stationName(), SUMMARY_META, askMakeLive() (+24 more)

### Community 8 - "App Shell & Navigation"
Cohesion: 0.05
Nodes (35): allTx, applyTheme(), approvalBadge, approvalsBadgeLabel, auth, clock, confirmLogout, drawer (+27 more)

### Community 9 - "Requirements Index Page"
Cohesion: 0.05
Nodes (39): { api }, bindDialog, bindHeaders, bindOverrides, bindRows, bindSaving, bindStationIds, bindTarget (+31 more)

### Community 10 - "Attachments & History List"
Cohesion: 0.06
Nodes (30): { api }, auth, canDelete, canRemove(), canUnlink, confirmDialog, deleteError, deletingId (+22 more)

### Community 11 - "Core Laravel Migrations"
Cohesion: 0.07
Nodes (17): {closure#1}(), {closure#2}(), {closure#3}(), {closure#1}(), {closure#2}(), {closure#3}(), {closure#1}(), {closure#2}() (+9 more)

### Community 12 - "API Resources & Role Middleware"
Cohesion: 0.08
Nodes (5): EnsureRole, FieldDefinitionResource, FieldValueResource, OfficeResource, WorkflowRouteResource

### Community 14 - "Approval Proceed Dialog"
Cohesion: 0.05
Nodes (35): { api }, attachmentName, availableActions, error, executeError, form, forwardActions, { getOne, execute } (+27 more)

### Community 15 - "Summary Detail Dialog"
Cohesion: 0.07
Nodes (34): accent, animateIn(), animateOut(), { api }, close(), contentRef, count, countUp() (+26 more)

### Community 16 - "Transaction List Page"
Cohesion: 0.06
Nodes (28): auth, baseHeaders, clientPages, confirmDialog, createTx(), dialog, error, fillerHeight (+20 more)

### Community 17 - "Admin Lookup Controllers"
Cohesion: 0.12
Nodes (8): GovernmentReferenceController, OfficeController, RoleController, TransactionTypeController, GovernmentReferenceResource, RoleResource, TransactionTypeResource, AuditService

### Community 18 - "Step Requirements Page"
Cohesion: 0.07
Nodes (29): addDialog, addError, addForm, adding, addRequirement(), afterBulkSaved(), { api }, { assigned, loading, fetchAssigned } (+21 more)

### Community 19 - "Dashboard Summary API"
Cohesion: 0.15
Nodes (8): {closure#1}(), {closure#10}(), {closure#11}(), {closure#3}(), {closure#4}(), {closure#7}(), {closure#9}(), DashboardSummaryController

### Community 20 - "Architecture Docs"
Cohesion: 0.10
Nodes (26): 02 Architecture, API Controllers (Auth, UserTransaction, Transaction, Admin/*), AppShell.vue (app bar + rail drawer), Frontend Composables (useApi, useAuth, useCache, ...), EnsureRole Middleware, Laravel 11 Backend, MySQL Database `transaction`, pixivLight Vuetify Theme (+18 more)

### Community 21 - "Workflow Staging (Frontend)"
Cohesion: 0.14
Nodes (26): bucket(), buckets, rowKey(), tmpKey(), useWorkflowStaging(), buildPayload(), markClean(), markResync() (+18 more)

### Community 22 - "Step Checklist Page"
Cohesion: 0.07
Nodes (27): addDialog, addError, addForm, addRow(), afterBulkSaved(), { api }, error, headers (+19 more)

### Community 23 - "App Bootstrap & Shared UI"
Cohesion: 0.07
Nodes (16): app, emit, props, tab, attachmentName, emit, proceedAttachments, remarks (+8 more)

### Community 24 - "Shared UI Components"
Cohesion: 0.07
Nodes (15): vue, props, props, senderLabel, stepLabel, badgeText, props, stepName (+7 more)

### Community 25 - "Grouped Bar Chart"
Cohesion: 0.08
Nodes (23): bandW, barPath(), bars, barW, groupTotals, hoverIndex, labelEvery, layers (+15 more)

### Community 26 - "Step Data Page"
Cohesion: 0.08
Nodes (20): { api }, cleanPayload(), dialog, editingId, error, form, formError, headers (+12 more)

### Community 27 - "Step Data & Requirement API"
Cohesion: 0.13
Nodes (3): StepDataController, StepRequirementController, WorkflowStep

### Community 28 - "API Routes & Endpoints"
Cohesion: 0.10
Nodes (7): UserController, TransactionFinalizeController, TransactionGotoController, TransactionReceiveController, TransactionRequirementController, UserTransactionController, Controller

### Community 29 - "Step Data Models"
Cohesion: 0.12
Nodes (4): ChecklistOverride, FieldValue, StepRole, TransactionStepData

### Community 30 - "Workflow Schema Migrations"
Cohesion: 0.08
Nodes (9): {closure#1}(), {closure#2}(), {closure#3}(), {closure#1}(), {closure#2}(), {closure#1}(), {closure#2}(), {closure#1}() (+1 more)

### Community 31 - "Frontend Router"
Cohesion: 0.22
Nodes (22): AdminFields(), AdminGovernmentReferences(), AdminOffices(), AdminOfficeSteps(), AdminRequirements(), AdminRequirementsIndex(), AdminRoles(), AdminStepChecklist() (+14 more)

### Community 32 - "Data Composables"
Cohesion: 0.09
Nodes (9): { dialog, confirm, cancel }, useApprovals(), useSmartPoll(), handleVisibility(), schedule(), tick(), useStepFields(), useStepRequirements() (+1 more)

### Community 33 - "Step Fields Page"
Cohesion: 0.08
Nodes (21): afterBulkSaved(), { api }, assigned, assignHeaders, assignmentRows, error, { items: fields, fetchAll: fetchFields }, loadAssigned() (+13 more)

### Community 34 - "Workflow Steps & Routes API"
Cohesion: 0.17
Nodes (5): {closure#1}(), WorkflowRouteController, WorkflowStepController, WorkflowStepResource, WorkflowVersioningService

### Community 35 - "Approvals & User Transactions API"
Cohesion: 0.10
Nodes (6): ApprovalController, {closure#1}(), {closure#14}(), {closure#2}(), {closure#4}(), {closure#5}()

### Community 36 - "Database Seeders"
Cohesion: 0.12
Nodes (7): DatabaseSeeder, GovernmentReferenceSeeder, OfficeSeeder, RolesSeeder, SuperAdminSeeder, TransactionTypeSeeder, UsersSeeder

### Community 37 - "Summary Popover"
Cohesion: 0.09
Nodes (19): accent, { api }, arrow, count, emit, error, expand(), loading (+11 more)

### Community 38 - "Field Definitions Page"
Cohesion: 0.09
Nodes (18): deleteDialog, deleting, deletingNow, dialog, error, filtered, form, headers (+10 more)

### Community 39 - "Approval Inbox Page"
Cohesion: 0.11
Nodes (18): approvalBadge, checkItems(), dialogOpen, dialogTxId, error, groups, guideSections, isPending() (+10 more)

### Community 40 - "Requirement Definitions API"
Cohesion: 0.13
Nodes (3): RequirementDefinitionController, RequirementDefinitionResource, RequirementDefinition

### Community 41 - "Route Flow Preview"
Cohesion: 0.13
Nodes (21): actionChipColor, actionChipLabel, ariaLabel, arrowColor, arrowIcon, currentName, currentNumber, destName (+13 more)

### Community 42 - "Reference & Audit Models"
Cohesion: 0.17
Nodes (3): AuditLog, GovernmentReference, Permission

### Community 43 - "Workflow Staging Service"
Cohesion: 0.16
Nodes (3): {closure#1}(), {closure#3}(), WorkflowStagingService

### Community 44 - "Step Progress Tracker"
Cohesion: 0.10
Nodes (14): currentIdx, detailById, moveByStep, ordered, positionLabel, props, snakeRows, snakeSplit (+6 more)

### Community 45 - "System Overview Docs"
Cohesion: 0.18
Nodes (16): 01 Overview, Generic Roles (admin, clerk, approver, viewer), LGU Workflow-Driven Transaction Tracker, Procurement Purchase Request Workflow (14 steps), End Users / Role Workers, Step Run (append-only history), Super Admin User Type, Transaction State (current_step pointer) (+8 more)

### Community 46 - "User Flow & API Docs"
Cohesion: 0.18
Nodes (19): 04 User Flow, Dashboard.vue Page, DonutChart.vue (by type / by step), MyTransactionList.vue (role-filtered queue), Transaction Detail Views (MyTransactionDetail / TransactionDetail), TransactionList.vue (superadmin all queue), 07 API Reference, Admin Endpoints (/admin/*, superadmin) (+11 more)

### Community 47 - "Requirements Page"
Cohesion: 0.10
Nodes (14): { api }, dialog, error, form, headers, { items, loading, fetchAll }, returnTypeId, route (+6 more)

### Community 48 - "Office Steps API"
Cohesion: 0.24
Nodes (4): {closure#1}(), OfficeStepController, Office, OfficeStep

### Community 49 - "Roles, Types & Test Base"
Cohesion: 0.19
Nodes (4): Role, TransactionType, ExampleTest, TestCase

### Community 50 - "Transaction Schema Migrations"
Cohesion: 0.11
Nodes (4): {closure#1}(), {closure#1}(), {closure#1}(), {closure#1}()

### Community 51 - "Office Steps Page"
Cohesion: 0.11
Nodes (13): descendantsOf(), dialog, error, flatSteps, form, headers, { items, fetchAll, fetchSteps, createStep, updateStep, removeStep }, loading (+5 more)

### Community 52 - "Users Admin Page"
Cohesion: 0.11
Nodes (14): auth, dialog, error, filtered, form, headers, { items: offices, fetchAll: fetchOffices }, officeNameById (+6 more)

### Community 53 - "Step Checklist API"
Cohesion: 0.24
Nodes (3): {closure#1}(), StepChecklistController, ChecklistService

### Community 55 - "Help Guide Page"
Cohesion: 0.14
Nodes (16): activeContent, activeKey, adminSteps, anyVisible, auth, filteredAdmin, filteredNotes, filteredUser (+8 more)

### Community 57 - "Workflow Engine & Auth Docs"
Cohesion: 0.27
Nodes (16): Backend Services Layer, 06 Workflow Engine, RoutingEngine::assertRequiredRequirementsChecked, RoutingEngine::assertRouteExecutable, AuditService::log, RoutingEngine::availableActions, RoutingEngine::buildContext, FieldValidationService::validateForStep (+8 more)

### Community 58 - "Frontend Build Config"
Cohesion: 0.13
Nodes (14): private, $schema, type, concurrently, eslint, @eslint/js, eslint-plugin-vue, laravel-vite-plugin (+6 more)

### Community 59 - "Reference & Office Migrations"
Cohesion: 0.12
Nodes (3): {closure#1}(), {closure#1}(), {closure#1}()

### Community 60 - "Admin Setup Docs"
Cohesion: 0.17
Nodes (14): Dynamic Step Field, Step Requirement (checklist gate), 05 Admin Guide, Admin Setup Order (Types -> Steps -> Routes -> Fields -> Requirements -> Roles/Users), Field Library + Per-Step Attach, Government References (seeded lookup), Roles Admin Screen, Users Admin Screen (+6 more)

### Community 61 - "My Transaction List Page"
Cohesion: 0.13
Nodes (10): error, filtered, fmtDate(), guideSections, headers, { items, loading, meta, fetchAll }, page, router (+2 more)

### Community 62 - "History Formatting Utils"
Cohesion: 0.17
Nodes (9): ACTION_CONFIGS, detailStepText(), getActionConfig(), historyDateFmt, movementOf(), officeOf(), stepLabelOf(), stepNo() (+1 more)

### Community 63 - "Users API"
Cohesion: 0.22
Nodes (4): {closure#1}(), {closure#2}(), UserResource, User

### Community 64 - "Workflow Publishing API"
Cohesion: 0.17
Nodes (3): WorkflowDefinitionController, PublishWorkflowRequest, WorkflowDefinitionResource

### Community 65 - "Form Request Validation"
Cohesion: 0.18
Nodes (3): StoreWorkflowDefinitionRequest, UpdateRoleRequest, CreateTransactionRequest

### Community 67 - "Attachment Uploader"
Cohesion: 0.19
Nodes (13): { api }, emit, fileInput, formatErr(), labelMissing, onDeleted(), onNativePick(), onPick() (+5 more)

### Community 68 - "Donut Chart"
Cohesion: 0.16
Nodes (13): circumference, emit, hovered, hoverIndex, PALETTE, props, radius, segEnter() (+5 more)

### Community 69 - "Transactions Composable"
Cohesion: 0.15
Nodes (3): useTransactions(), applyPayload(), fetchAll()

### Community 72 - "Maintenance Commands"
Cohesion: 0.18
Nodes (3): {closure#1}(), OrganizeAttachmentsByDate, PruneUnusedWorkflows

### Community 73 - "Field Definitions API"
Cohesion: 0.26
Nodes (3): FieldDefinitionController, StepFieldController, WorkflowDefinition

### Community 76 - "Staging Save Bar"
Cohesion: 0.18
Nodes (12): confirmSave(), dirty, emit, onDiscard(), props, saveDialog, saveError, saveMode (+4 more)

### Community 77 - "Roles Admin Page"
Cohesion: 0.15
Nodes (8): dialog, error, filtered, form, headers, { roles, loading, fetchRoles, createRole, updateRole, deleteRole }, saving, search

### Community 79 - "Workflow Versioning Service"
Cohesion: 0.20
Nodes (4): {closure#1}(), {closure#2}(), {closure#4}(), {closure#5}()

### Community 82 - "Login"
Cohesion: 0.17
Nodes (10): vue-router, auth, canSubmit, email, error, errorKey, loading, password (+2 more)

### Community 83 - "Use Cache"
Cohesion: 0.21
Nodes (6): CacheKeys, isCached(), memory, readCache(), safeParse(), storedUserId()

### Community 84 - "Use My Transactions"
Cohesion: 0.18
Nodes (3): useMyTransactions(), applyPayload(), fetchAll()

### Community 85 - "My Transaction Detail"
Cohesion: 0.23
Nodes (12): confirmJump(), currentStepAttachments(), executeSelected(), finalizeTx(), formatApiError(), gotoStation(), hydrateForm(), hydrateStepDataForm() (+4 more)

### Community 88 - "Package"
Cohesion: 0.18
Nodes (11): devDependencies, axios, concurrently, eslint, @eslint/js, eslint-plugin-vue, laravel-vite-plugin, tailwindcss (+3 more)

### Community 89 - "Government References"
Cohesion: 0.18
Nodes (6): dialog, error, form, headers, { items, loading, fetchAll, create, update, remove }, saving

### Community 90 - "My Transaction Detail (2)"
Cohesion: 0.22
Nodes (11): checkChecklistItem(), checkRequirement(), confirmCheck(), confirmUncheck(), goWizardNext(), onWizardChecklistToggle(), onWizardToggle(), pruneSelectedRoute() (+3 more)

### Community 91 - "Transaction Detail"
Cohesion: 0.22
Nodes (11): checkChecklistItem(), checkRequirement(), confirmCheck(), confirmUncheck(), goWizardNext(), onWizardChecklistToggle(), onWizardToggle(), pruneSelectedRoute() (+3 more)

### Community 94 - "Zamboanga seal"
Cohesion: 0.24
Nodes (10): Zamboanga City Hall, City of Zamboanga, Crescent and Star (Islamic faith symbol), Cross (Christian faith symbol), Fish (marine resources), Fort Pilar, City of Zamboanga Official Seal, Vinta Boat (+2 more)

### Community 95 - "Jump Back Dialog"
Cohesion: 0.22
Nodes (9): confirm(), dialogTitle, emit, props, remarks, remarksError, shortDestination, titleHead (+1 more)

### Community 101 - "Approval Proceed Dialog (2)"
Cohesion: 0.36
Nodes (9): applyResponse(), emit, executeSelected(), formatApiError(), goWizardNext(), onAttachmentDeleted(), onChecklistToggle(), onRequirementToggle() (+1 more)

### Community 102 - "Proceed Wizard (2)"
Cohesion: 0.22
Nodes (9): emit, getReqFiles(), hasReqFiles(), isUploadLocked(), mergedReqAttachments(), onReqAttachmentDeleted(), reqHintText(), selectExisting() (+1 more)

### Community 103 - "Use Auth"
Cohesion: 0.28
Nodes (6): initialized, useAuth(), init(), login(), revalidate(), user

### Community 109 - "Package (2)"
Cohesion: 0.25
Nodes (8): dependencies, @mdi/font, @mdi/js, @mdi/svg, @vitejs/plugin-vue, vue, vue-router, vuetify

### Community 110 - "Station Node"
Cohesion: 0.25
Nodes (5): avatarColor, hasExtra, isUpcoming, props, statusLine

### Community 111 - "Transaction Detail (2)"
Cohesion: 0.43
Nodes (8): confirmJump(), executeSelected(), finalizeTx(), formatApiError(), gotoStation(), hydrateForm(), hydrateStepDataForm(), load()

### Community 113 - "README"
Cohesion: 0.38
Nodes (6): Login Flow (csrf-cookie -> login -> me), Login.vue Page, Auth Endpoints (/auth/login, /auth/me, /auth/logout), Mascots README, logout.jpg (logout farewell bird), mascot-empty.jpg (empty-state bird)

### Community 114 - "Step Data Fields"
Cohesion: 0.38
Nodes (4): form, hintFor(), statusFor(), unitFor()

### Community 115 - "Use Dashboard Layout"
Cohesion: 0.43
Nodes (5): readOrder(), useDashboardLayout(), move(), save(), shift()

### Community 117 - "Use Step Data"
Cohesion: 0.48
Nodes (6): useStepData(), baseUrl(), create(), fetchAll(), remove(), update()

### Community 118 - "Workflows"
Cohesion: 0.29
Nodes (7): clickAddStep(), editStep(), formatSlaMinutes(), goStepFields(), minutesToSla(), openStepDialog(), stepInDraft()

### Community 119 - "Workflows (2)"
Cohesion: 0.29
Nodes (7): confirmMakeLive(), confirmSave(), discardStaged(), goLive(), seedFromActiveDef(), selectEffective(), viewDef()

### Community 122 - "Readd parent id to office steps table"
Cohesion: 0.33
Nodes (3): {closure#1}(), {closure#2}(), {closure#3}()

### Community 123 - "Use Api"
Cohesion: 0.33
Nodes (3): axios, api, useApi()

### Community 124 - "Checklist Tracking Guide"
Cohesion: 0.40
Nodes (4): currentOrder, isCurrent(), props, stateOf()

### Community 129 - "Dashboard"
Cohesion: 0.33
Nodes (6): clearHoldTimer(), endHold(), onEscapeWhileArmed(), onHoldCancel(), onHoldEnd(), onHoldMove()

### Community 130 - "My Transaction Detail (3)"
Cohesion: 0.33
Nodes (6): currentOfficeForTitle(), destOfficeCode, destStepForTitle(), proceedButtonLabel, proceedModalTitle, proceedTitle()

### Community 148 - "Package (3)"
Cohesion: 0.40
Nodes (3): @mdi/font, @mdi/js, vuetify

### Community 149 - "Approval Proceed Dialog (3)"
Cohesion: 0.40
Nodes (5): currentStepAttachments(), hydrateForm(), hydrateStepDataForm(), load(), resetWizardForRoute()

### Community 150 - "Use Confirm"
Cohesion: 0.50
Nodes (3): close(), dialog, useConfirmDialog()

### Community 151 - "Roles"
Cohesion: 0.50
Nodes (4): FALLBACK_PALETTE, hashCode(), ROLE_COLORS, roleColorFor()

### Community 200 - "Logout"
Cohesion: 0.67
Nodes (4): Bluebird Mascot (teal scarf), Open Exit Door with Exit Arrow Icon, Logout Mascot Illustration, User Logout Action

### Community 201 - "Mascot empty"
Cohesion: 0.50
Nodes (4): Blue Bird Mascot Character (navy scarf), Brand Blue Color Palette, Empty State UI Pattern, Mascot Empty-State Illustration (mascot-empty.jpg)

### Community 202 - "Use File View"
Cohesion: 0.67
Nodes (3): fileViewUrl(), isOfficeDoc(), OFFICE_EXTS

### Community 203 - "Workflows (3)"
Cohesion: 0.50
Nodes (4): clickAddRoute(), editRoute(), openRouteDialog(), routeInDraft()

### Community 204 - "Workflows (4)"
Cohesion: 0.50
Nodes (4): goStepChecklist(), isTmpRow(), stepRouteTarget(), workingRowFor()

### Community 205 - "Workflows (5)"
Cohesion: 0.67
Nodes (4): goStepData(), goStepRequirements(), liveEditableTarget(), stepOnDef()

### Community 206 - "Workflows (6)"
Cohesion: 0.50
Nodes (4): parseSlaTime(), slaHuman, slaTimeDisplay, slaTotal

### Community 207 - "Workflows (7)"
Cohesion: 0.50
Nodes (4): routeClientError(), saveRoute(), stepOrderOf(), toStepOptions

### Community 208 - "Dashboard (2)"
Cohesion: 0.50
Nodes (4): armCard(), cardAt(), onHoldStart(), onInteractiveTarget()

### Community 209 - "Dashboard (3)"
Cohesion: 0.50
Nodes (4): graphTx, processRanking, txTypeLabel(), weekIndexOf()

### Community 210 - "My Transaction Detail (4)"
Cohesion: 0.50
Nodes (4): canUncheck(), isSuperadmin(), rowProps(), rowRelevant()

### Community 211 - "Transaction Detail (3)"
Cohesion: 0.50
Nodes (4): canUncheck(), isSuperadmin(), rowProps(), rowRelevant()

### Community 212 - "Transaction Detail (4)"
Cohesion: 0.50
Nodes (4): currentOfficeForTitle(), destStepForTitle(), proceedModalTitle, proceedTitle()

### Community 213 - "Transaction Detail (5)"
Cohesion: 0.50
Nodes (4): currentStepAttachments(), openProceed(), receiveStep(), returnAttachments()

### Community 215 - "Package (4)"
Cohesion: 0.67
Nodes (3): scripts, build, dev

### Community 217 - "Approval Proceed Dialog (4)"
Cohesion: 0.67
Nodes (3): currentOfficeForTitle(), destStepForTitle(), proceedModalTitle

### Community 218 - "Approval Proceed Dialog (5)"
Cohesion: 0.67
Nodes (3): forwardOptions, labelForAction(), selectedActionLabel

### Community 219 - "Proceed Wizard (3)"
Cohesion: 0.67
Nodes (3): existingAdditionalFiles, existingReqFiles, isAdditionalFile()

### Community 220 - "Proceed Wizard (4)"
Cohesion: 0.67
Nodes (3): sortedRequirements, uploadFirstRequirements, uploadRequired()

### Community 223 - "Dashboard (4)"
Cohesion: 0.67
Nodes (3): goToHelp(), goToQueue(), startLinks

### Community 224 - "My Transaction Detail (5)"
Cohesion: 0.67
Nodes (3): labelForAction(), selectedActionLabel, unifiedRouteOptions

### Community 225 - "Transaction Detail (6)"
Cohesion: 0.67
Nodes (3): labelForAction(), selectedActionLabel, unifiedRouteOptions

## Ambiguous Edges - Review These
- `Finish Transaction Button (future work)` → `LGU Transaction System Documentation Index`  [AMBIGUOUS]
  docs/README.md · relation: references
- `robots.txt (allow all crawlers)` → `Vite Build + SPA Fallback Route`  [AMBIGUOUS]
  public/robots.txt · relation: conceptually_related_to
- `Procurement Purchase Request Workflow (14 steps)` → `Forward-Only Routes (is_return_route retired)`  [AMBIGUOUS]
  docs/05-admin-guide.md · relation: conceptually_related_to
- `RoutingEngine::assertRouteExecutable` → `RoutingEngine::assertUserCanExecute`  [AMBIGUOUS]
  docs/10-finish-transaction-button.md · relation: semantically_similar_to

## Knowledge Gaps
- **23 isolated node(s):** `@eslint/js`, `@tailwindcss/vite`, `concurrently`, `eslint`, `eslint-plugin-vue` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1602 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **123 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `vue` connect `Shared UI Components` to `Use Roles`, `My Transaction Detail Page`, `Workflow Builder Page`, `Admin Transaction Detail Page`, `Dashboard Page`, `Proceed Wizard`, `Summary Rows & Type Helpers`, `App Shell & Navigation`, `Requirements Index Page`, `Attachments & History List`, `Approval Proceed Dialog`, `Summary Detail Dialog`, `Transaction List Page`, `Step Requirements Page`, `Workflow Staging (Frontend)`, `Use Confirm`, `App Bootstrap & Shared UI`, `Step Checklist Page`, `Grouped Bar Chart`, `Step Data Page`, `Data Composables`, `Step Fields Page`, `Summary Popover`, `Field Definitions Page`, `Approval Inbox Page`, `Route Flow Preview`, `Step Progress Tracker`, `Requirements Page`, `Office Steps Page`, `Users Admin Page`, `Help Guide Page`, `Frontend Build Config`, `My Transaction List Page`, `Attachment Uploader`, `Donut Chart`, `Transactions Composable`, `Workflows Composable`, `Staging Save Bar`, `Roles Admin Page`, `Login`, `Use My Transactions`, `Government References`, `Jump Back Dialog`, `Use Offices`, `Use Auth`, `Station Node`, `Use Dashboard Layout`, `Use Requirement Definitions`, `Use Step Data`, `Checklist Tracking Guide`, `Use Admin Users`, `Use Approval Badge`, `Use Field Definitions`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **What connects `@eslint/js`, `@tailwindcss/vite`, `concurrently` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `My Transaction Detail Page` be split into smaller, more focused modules?**
  _Cohesion score 0.022727272727272728 - nodes in this community are weakly interconnected._
- **Why does `vue-router` connect `Login` to `My Transaction Detail Page`, `Admin Transaction Detail Page`, `Workflow Builder Page`, `Dashboard Page`, `Summary Rows & Type Helpers`, `App Shell & Navigation`, `Approval Proceed Dialog`, `Summary Detail Dialog`, `Transaction List Page`, `Step Requirements Page`, `Step Checklist Page`, `Step Data Page`, `Frontend Router`, `Step Fields Page`, `Summary Popover`, `Requirements Page`, `Office Steps Page`, `Frontend Build Config`, `My Transaction List Page`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Should `Admin Transaction Detail Page` be split into smaller, more focused modules?**
  _Cohesion score 0.024096385542168676 - nodes in this community are weakly interconnected._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `Finish Transaction Button (future work)` and `LGU Transaction System Documentation Index`?**
  _Edge tagged AMBIGUOUS (relation: references) - confidence is low._
- **What is the exact relationship between `robots.txt (allow all crawlers)` and `Vite Build + SPA Fallback Route`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._