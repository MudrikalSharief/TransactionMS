# TransactionMS workspace redesign

## Intent and approved direction
Redesign the authenticated admin/superadmin and regular staff areas around the user's supplied blue-and-white dashboard reference. The user selected option 1: closely match the reference layout, wave background, rounded cards and soft shadows. Their subsequent navigation approval uses a collapsed desktop icon rail that expands on hover. Preserve the application's existing functionality, real data and access restrictions.

The screenshot is a visual reference, not seed data. Counts, names, offices, dates, chart values and notifications must come from the current session and APIs.

## Scope
Include the shared authenticated workspace shell; admin dashboard and Reports view; staff home; transaction list/detail/archive; task/approval queues; accounts and roles; offices and office steps; transaction types and workflow/requirements/field/step-data editors; government references; activity/history; officer details and reassignment; profile; and help when opened by staff/admin.

Do not redesign login, registration/login overlays, or any viewer tracking surface: /login, /track, /track/welcome, /track/:id and their shared viewer chrome. Preserve QR redirects and guest flow. Shared components must retain their tracking/login appearance when used there. No publishing or hosting changes; use the existing checkout and Vue/Laravel application.

## Approaches considered
1. Reference-first redesign in the existing Vue/Vuetify application, with workspace-scoped styles and selective layout changes. Selected by the user because it produces the requested composition while preserving data and behavior.
2. Recolor the current layouts without changing composition. Rejected by the user in favor of option 1.

## Visual system
- Default workspace light appearance: pale blue/white canvas, royal blue primary actions around #0055ED, deep navy text, white panels with subtle cool-blue borders and soft blue shadows.
- Use dark navy for headings, muted blue-gray for secondary information, and existing semantic success/warning/error colors for states. Red is reserved for overdue/destructive information, green for completed/clear, amber for in progress.
- Main cards use approximately 22-28px radii, medium controls 10-16px, pill-shaped search/filter controls, balanced 20-28px desktop spacing, and clear readable typography using existing available fonts.
- Reproduce the restrained blue wave decoration at the top and bottom with CSS or code-native SVG, plus small wave accents in the overdue tiles. Decoration stays behind content, ignores pointer input, has no accessibility announcement and never obscures controls.
- Reuse the existing golden sun motif and slow rotation from TrackBackdrop.vue behind redesigned admin and staff pages, together with the blue waves. Keep it centered in the available content area with restrained opacity so text, tables and cards remain readable. Preserve the existing motion preference and reduced-motion behavior: the sun stays decorative and static when animation is disabled. Scope workspace-specific placement, colors and opacity so login and tracking backgrounds remain unchanged. Do not replace the existing sun with a different design.
- Reuse existing official city seal assets and MDI icons. Do not invent logos, add stock photography, generate bitmap backgrounds, or install a new component/chart framework.
- Preserve the existing dark-theme preference. Provide compatible workspace colors under that preference; the screenshot defines the default light presentation. Theme changes must not alter the protected login/tracking styling.

## Workspace shell and navigation
- Desktop: persistent collapsed icon rail, expanding to approximately 220-240px on hover or keyboard focus and collapsing when the user leaves. Keep navigation targets vertically stable during expansion. Place the city seal and CITY GOVERNMENT OF ZAMBOANGA / TRANSACTIONS branding at its top. Use blue line icons, readable labels and a solid royal-blue rounded active item as in the reference.
- Keep all existing permitted destinations. Organize them around Overview, Transactions, Reports, Offices, Accounts, and the existing setup/activity/help entries as appropriate to each role. Staff and office admins must not gain menu entries or permissions they do not currently have. Reports can retain its existing dashboard view/redirect behavior.
- Remove the workspace hamburger button. On phones, use the city seal as an explicitly named overlay navigation toggle, since touch screens have no hover, with no permanently reserved sidebar width. Restore the collapsed desktop default after signing in within the same session.
- Header: scroll with the page across admin and staff workspaces, including on phones. Use a fully transparent background without a panel shadow so the existing sun-and-wave design shows through in light and dark mode, as approved in the latest follow-up. Preserve its reserved layout space at the top. Keep the left greeting/name/update time on the dashboard and staff home, or concise page context elsewhere; functional pill search on the right, followed by notification and account controls. Avoid duplicate greeting/title rows.
- Names and timestamps are live, with greeting and displayed dates/times based on Asia/Manila. No hard-coded Vince or screenshot date.
- Preserve search actions, notifications, account/profile/settings/logout and offline status. Keep existing clock/weather information available as a compact secondary detail or account-menu item if displaced from the reference header arrangement.
- Preserve the standard City Hall/developer footer where currently enabled. Do not reintroduce the removed End of transaction footer. Decorative waves are background treatment rather than another footer.

## Admin dashboard composition
Default order and placement at wide desktop widths:
1. Top row: two equal overdue tiles for Overdue Steps and Overdue Transactions, each with a red semantic icon on a pale-red circle, large number, slim blue separator and explanatory label. Use the existing summary API definitions.
2. Middle row: Transaction Status grouped bar chart on the left; Top Overdue Steps ranked rows on the right.
3. Bottom row: Needs My Action on the left; Overdue Transactions by Office donut/legend on the right.

Use the reference's roughly equal two-column panel composition, rounded white panels and subtle separators. Keep existing month and office filters and their scope; office admins do not gain all-office filtering. Preserve chart interactions, drill-downs, reporting, account approval/rejection actions and meaningful empty/loading/error states. Show real account or queue information appropriate to the user's role. Start summary and chart requests first, alongside the approval panel, before loading secondary transaction/office data. Keep the dashboard usable without a whole-page loading veil while secondary queues load; defer the shell's duplicate approval-badge request on the overview.

The existing default dashboard card IDs already match this composition. Retain card rearrangement/reset and saved user preferences; a clean/default layout matches the reference, while a user's deliberate saved arrangement remains respected. Do not drop existing reporting or smaller-screen access to controls merely to make a desktop screenshot fit.

## Staff home and other pages
- Staff home adopts the same shell, greeting, rounded summary tiles and consistent card styling, while retaining its existing office/role-specific metrics, process graph, queue and transaction creation capabilities. Do not expose admin-only statistics to mimic the screenshot.
- Lists: consistent rounded table surfaces, pale header rows, clear action toolbars, aligned search/filters, readable row spacing, visible sorting/pagination and existing selection/action behavior.
- Detail pages: consistent page heading/back/actions, cards, station progress and history. Preserve workflow steps, receipt facts, reassignment controls and persistent former-officer exclusion.
- Forms/editors: consistent labels, field heights, spacing, required indicators, validation/error treatment and primary/secondary/destructive buttons. Preserve workflow staging/save/publish behavior.
- Dialogs, menus, tooltips and hover cards should look coherent with the workspace and remain readable. Teleported overlays must receive the workspace styling only in workspace mode; viewer tracking overlays retain their current appearance. Officer name/time in the hover card remain non-clickable and show no contact number.
- Empty states, skeletons, errors, disabled/read-only controls and archived/finalized states must remain obvious and usable.

## Implementation boundaries
Retain Vue 3, Vuetify, existing charts, routes, API contracts and backend behavior. Introduce reusable workspace design tokens/styles and focused components where they remove duplication; do not rebuild the app, replace its authentication, or change database schema for a visual redesign.

Determine workspace mode centrally from authenticated user kind and route; enable new shell/style rules only there. Avoid unqualified global overrides that affect login or viewer pages, including after navigating or switching accounts in the same browser session. Preserve existing dark/motion preferences and reduced-motion support.

Keep the completed officer reassignment changes already in this checkout intact. Remove replaced or newly unused components/styles/assets only after checking imports, routes and asset references; do not create backups or parallel old/new versions. Keep changes local and reviewable; no commits or publication.

## Responsive and accessibility acceptance
Verify at 1672x940 (reference-like), 1366x768, 1024x768, and approximately 390x844. The dashboard stacks appropriately at smaller widths; controls wrap or move deliberately. Do not force all desktop panels into a fixed height on phones. Avoid whole-page horizontal overflow; wide data tables may use their own labeled scroll container.

Maintain visible keyboard focus, keyboard-operable navigation/menu/dialog actions, accessible names for icon-only controls, adequate contrast, focus handling for dialogs and readable charts. Long names, office labels, reference numbers, empty datasets and large counts must not collide or clip critical information.

## Verification
Capture fresh pre-change screenshots for login, viewer search/detail, admin dashboard, staff home and representative list/detail/editor pages. Test protected pages with the same viewport, theme, data and motion settings after the shared-shell changes; verify no visual change and no leaked workspace styles.

Use mocked API fixtures in browser checks for deterministic populated/empty/error states without modifying development records. Also check real rendering with existing data where read-only access is available. Validate representative routes for superadmin, office admin, staff and viewer, plus same-session role navigation and login/logout so workspace state does not persist into excluded pages.

Run frontend build, lint for changed files, relevant existing frontend tests and node .codex/hooks/verify.mjs full using the SQLite :memory: guard. Save a fresh baseline and compare failing identities if the full suite already fails. Refresh Graphify after code changes and perform an independent review for functional regressions and protected-page leakage. Do not add screenshot-text/source-string unit tests for purely cosmetic changes.

## Approval state
The user approved reference-first styling for both authenticated areas, including reuse of the existing rotating golden sun alongside the blue waves. Implementation and verification are recorded in docs/superpowers/plans/2026-11-17-workspace-redesign.md. Routine choices such as exact spacing, breakpoints and component extraction were delegated to the implementer within these constraints.
