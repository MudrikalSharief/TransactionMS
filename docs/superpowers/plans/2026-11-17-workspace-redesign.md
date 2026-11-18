# Workspace Redesign Implementation Plan

**Goal:** Apply the approved screenshot-led workspace design to admin and staff areas, preserving login/tracking and all features.
**Architecture:** Gate presentation centrally in AppShell with workspace-shell on v-app and workspace-active on html only for signed-in non-viewer workspace routes. Add scoped visual tokens, shell/backdrop styling and dashboard composition. Retain routes, data, permission logic and the completed reassignment work.
**Tech stack:** Existing Vue, Vuetify, CSS/SVG, charts, Playwright, Laravel/PHPUnit.
**Spec:** docs/superpowers/specs/2026-11-17-workspace-redesign-design.md (approved, including existing rotating sun).

## Constraints
Current checkout, local-only, no commits. No backend/schema changes. Login/registration and all viewer tracking styling unchanged. Preserve dark/motion preferences, real values, role navigation, workflow operations, reassignment/history and standard footer. No replacement assets where current seal/sun can be reused. Delete replaced unused files after checking references; no backups.

## Review focus
Style leakage through shared or teleported components; saved collapsed navigation state after switching users; small-screen clipped controls; graph/filter and drag-order regressions; CSS overriding semantic status or disabled states.

## Task 1: Workspace shell and backdrop
- [x] Use the protected-page baseline screenshots in .git/codex-checks/redesign-before-*.png.
- [x] Modify AppShell.vue and focused shell stylesheet: seal-branded desktop sidebar, solid blue active navigation, title/greeting slot, pill search, round bell/account, mobile overlay navigation. Follow-up approval changes the default to a hover-expanding icon rail; the latest header request makes the opaque header scroll with the page. Keep every existing destination and search action.
- [x] Expose workspace-shell class and html.workspace-active only for authenticated non-viewer/non-login mode. Remove marker on excluded routes, logout and unmount. Keep existing viewer chrome exactly.
- [x] Compose blue waves with the existing TrackBackdrop golden sun in workspace-only mode. Respect motion-off and avoid changing TrackBackdrop's viewer defaults.
- [x] Verify representative workspace header/drawer widths and protected-page marker removal; lint changed files.

## Task 2: Admin dashboard and staff home
- [x] Modify Dashboard.vue, PortalHome.vue and focused dashboard stylesheet. Use top two overdue tiles and default two-column/four-panel composition as reference. Retain real data, reporting, filters, actions, drilldowns and saved card order/reset.
- [x] Coordinate header slot with shell; fallback to in-page greeting if slot not used. Dates and greeting use Asia/Manila. Staff home keeps staff-specific metrics rather than duplicating administrator stats.
- [x] Make chart panels, filters, ranked rows, clear action state and donut/legend match reference. Stack on phones with readable content; preserve theme variants.
- [x] Verify populated/empty/error dashboard and staff home with mocked browser responses. Lint/build; meaningful pure helper tests only if behavior requires them.

## Task 3: System-wide surfaces and validation
- [x] Add resources/css/workspace.css and import from app.js, isolated by workspace-shell/workspace-active. Unify table cards/headings/actions/forms/dialogs/hover/progress/history/profile/help/editor surfaces, with accessible focus, readable statuses and dark variants.
- [x] Audit representative accounts, offices, workflow, report, transaction list/detail, task, profile and reassignment dialogs for layout clashes and preserve existing operations.
- [x] Re-run protected-page baseline fixture after source changes; compare screenshots/styles under identical motion/theme/viewport. Test same-session workspace to viewer/login and sidebar mobile behavior.
- [x] Run frontend lint, existing node tests and node .codex/hooks/verify.mjs full. Compare current failure identities against fresh baseline; refresh Graphify. Independent review and fix important observed defects.

## Ledger
User approved option1 design and explicitly requested existing rotating sun with blue waves. Before-product-edit protected-page baselines captured at1366x900 with motion disabled and mocked login/viewer APIs. Full pre-change verification running under .git/codex-checks/redesign-baseline.log. Agents own disjoint files; scope-changing decisions stay within approved design.

## Completion evidence
- Implemented AppShell and new WorkspaceBackdrop; scoped workspace-shell.css, workspace-dashboard.css and workspace.css; dashboard and staff home updates; app.js stylesheet import. All existing data/API/permission/reassignment logic retained. No backend or schema change for this redesign.
- Main workspace visuals: seal-branded sidebar and full permitted navigation, greeting/search/notification/account header, reference dashboard cards and charts, consistent page/table/form/dialog surfaces, mobile drawer, dark mode, existing sun rotation plus blue waves. The follow-up below records the approved hover behavior.
- Protected screenshots at1366x900 are byte-identical before/after for login, tracking list/search and tracking detail. Evidence .git/codex-checks/redesign-before-*.png and redesign-after-*.png. No diffs to Login.vue, pages/track/, components/track/, base app.css or Vuetify theme definitions.
- Browser fixtures: admin dashboard at1672x940 and1366x768; admin/staff home; representative transactions/detail/accounts/offices/workflow/profile/help; six mobile pages at390x844 with no document overflow; internal table scrolling retained; dark dashboard/profile; active-field error color retained; office-admin menu and all-office filter restrictions; account/search menu positions at1024 and390; manual collapse/mobile drawer; Reports; settings/dark mode/logout.
- Verified sun uses the existing140s rotation with motion enabled and stops for reduced motion. Same-session workspace to viewer to logout removes shell/html markers without a reload. Protected direct-page screenshot comparison still matches after final code changes.
- Independent review found no Critical/Important regression. Its error-field outline concern was fixed with explicit semantic error-color rules and checked in the browser. Fixed dark profile hard-coded surfaces/labels and kept footer credit legible.
- Found and fixed a live-development HMR cleanup race: the previous shell instance must not remove the replacement's active workspace marker. Mount synchronizes the marker and unmount checks the remaining workspace DOM. Verified the corrected marker and dark profile after HMR, and reran same-session boundary checks.
- Workspace account/search popups use a scoped positioning strategy after the existing connected menu positioning reproduced doubled coordinates on tablet resizing. Measured resulting popups stay within1024px and390px viewports; excluded viewer/login strategy remains unchanged.
- Final node .codex/hooks/verify.mjs full: frontend build PASS; PHPUnit214 tests/1202 assertions,2 errors/4 failures. The same214-test pre-change baseline has the exact same six failing identities, no differences. Logs .git/codex-checks/redesign-baseline-phpunit.log, redesign-final.log and phpunit.log.
- Existing failures/errors: OfficeIconTest::test_office_can_be_created_with_an_uploaded_icon; OfficeIconTest::test_office_icon_can_be_replaced_and_removed; DashboardSummaryTest::test_counts_each_status_in_the_current_calendar_week; EndUserStepOfficeTest::test_end_user_toggle_overrides_office_without_the_end_user_role; OfficeRoleMatrixTest::test_my_transactions_endpoint_stays_station_scoped; OfficeScopedAccessTest::test_office_admin_can_act_on_a_blank_step_at_their_office.
- Existing7 frontend node tests passed, changed-file ESLint passed, git diff --check passed. Build retains existing runtime-public-asset/chunk-size warnings; weather fetch can time out independently of the UI. Browser tests used mocked APIs and changed no development records.
- Final Graphify AST update completed:5390 nodes/9641 edges. Generated artifacts remain uncommitted.

No files removed; replaced obsolete inline dashboard styles were removed in the same edit when moved to the scoped stylesheet. No commits or publication performed. No deferred review findings remain.

## Dashboard navigation and loading follow-up
- User confirmed a pinned header and desktop icon rail that automatically opens on hover and closes on leaving. Removed the workspace hamburger. Phones use the city seal to open the touch navigation overlay; keyboard focus also expands desktop navigation.
- Reproduced the apparent header overlap: its fixed position was correct, but its transparent background allowed scrolling cards to show through the greeting, search and account controls. Added opaque light/dark surfaces and kept the existing fixed positioning. Navigation row positions remain stable when expanded.
- Reproduced sequential loading with a held transaction-list response. Dashboard summary and chart requests now start first, alongside account approvals, before secondary transaction/office data. Removed the dashboard-wide loading veil and deferred the duplicate overview badge request. Existing permission, filtering and error handling remain.
- Reproduced the same-session sign-in edge: the account changed before leaving the login route, leaving the desktop drawer expanded. Entering workspace mode now restores the collapsed desktop default.
- Browser red/green checks passed for held-list loading, header scrolling, hover open/close, stable navigation targets, same-session sign-in and mobile seal navigation without horizontal overflow. Screenshots: dashboard-header-fixed-scroll.png and dashboard-mobile-fixed-header.png in .git/codex-checks/.
- Final frontend build and changed-file ESLint passed; all 7 existing frontend tests passed. Full verification remains 214 tests/1202 assertions with the exact same 2 errors and 4 failures as the pre-change baseline. Graphify updated successfully after the last source edit.
- Login, tracking list and tracking detail screenshots remain byte-identical under the protected-page fixture after this follow-up. No files removed or commits made.

## Latest header scrolling follow-up
- User changed the header preference to non-sticky and confirmed it applies to all admin and staff pages. AppShell now passes absolute positioning to the workspace app bar, preserving Vuetify's reserved top space and sidebar alignment while allowing the title, search and profile controls to scroll out of view. Existing login/viewer behavior is unchanged.
- Browser checks confirmed the header moves by the document scroll distance and leaves the viewport for both admin and staff at 1366px and 390px widths, with no horizontal overflow. Evidence: .git/codex-checks/header-nonsticky-browser.log and header-nonsticky-*.png. No files removed.

## Transparent header follow-up
- User approved a fully transparent header across admin and staff, showing the existing sun-and-wave background. Removed the workspace header fill and shadow, including the obsolete dark-mode fill override. The header continues scrolling with the page; individual search and account controls retain their readable surfaces.
- Browser checks and visual inspection passed at 1366px and 390px in light and dark mode. Evidence: .git/codex-checks/header-blend-browser.log and header-blend-*.png. Frontend build passed; full verification retains the same 214 tests/1202 assertions with 2 errors and 4 failures and no changed failing identities. Graphify refreshed. No files removed.
