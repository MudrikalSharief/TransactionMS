# Clerk step cards

Goal: Preserve Created by me, In process, and Completed; add three clerk step cards: Overdue Completed, Overdue Pending, Needs My Action.

Design: Extend the existing portal summary with step-visit counts and matching rows. Scope visits to the user's effective office and responsible officer. Use existing working-hours SLA arithmetic, starting at receipt and ending at the next departure (including finalize). Pending overdue visits must still be current and actionable. Needs My Action is the union of current unreceived arrivals and current returns; count each visit once. Historical completed visits remain counted after the transaction moves elsewhere. Existing non-clerk summaries remain unchanged. Period applies to completed departure dates; current queues remain live. Reuse StatCard and a responsive list dialog; keep changes local.

- [x] Add focused API tests for historical completion, current delay, receipt, return, office/officer isolation, and period.
- [x] Implement clerk summary and three cards with matching lists.
- [x] Run focused tests, lint/build, browser verification, and Graphify update.

Verification: 32 focused PHPUnit tests / 280 assertions passed; changed-file ESLint, PHP syntax, production build and diff checks passed. Mocked browser checks confirmed the three labels and counts, receipt/return and historical lists, and desktop/mobile layout. Full suite not rerun. No files removed.

Follow-up: Restored the original three summary cards alongside the three new step cards. Browser checks confirmed all six cards, matching lists, and no mobile overflow; lint and build passed.

Layout follow-up: Row 1 has Overdue Completed and Overdue Pending; row 2 has Created by me, In process, Completed; row 3 has the graph, Office Transactions, and Needs My Action. Browser geometry verified the 2/3/3 arrangement and mobile stacking. Graph filter wraps to remain readable. Build and lint passed; no files removed.

Needs My Action follow-up: Replaced its number-only StatCard with the same panel/header/TxMiniList structure used by Office Transactions. Shows the five latest step arrivals/returns (descending visit ID), each linked to its transaction; View all retains the full queue dialog. Removed the obsolete actionTile mapping and clerk-action-card styles. Browser fixture with seven entries verified exactly five latest entries, receipt/return descriptions, full queue access, desktop rows and mobile overflow. Build and lint passed. No files removed.

Admin design parity: Clerk count cards now reuse the admin/superadmin summary-strip and summary-seg markup/styles, including the wave decoration, number/icon/label sizing, borders, shadows, dark-theme inheritance and keyboard focus. Non-clerk StatCard usage remains required. Browser comparison against both admin and superadmin confirmed equal computed card background, radius, shadow, wave, icon width/color and label size/color. Existing row grouping, card actions and five-entry action preview passed desktop/mobile checks. Build, lint and diff checks passed; no files removed.

Clerk graph follow-up: Removed Office Transactions from the clerk layout and skipped its list request. Other staff still use that panel, so its code and dependencies remain required. Bottom row is a wider graph beside Needs My Action. ProcessGraphCard reuses the admin chart-head/chart-filters/topsteps-month controls and shared GroupedBarChart, retaining scoped per-process data. Added synchronized period menu and multi-process menu; removed obsolete select styles and clerk graph overrides. Browser tests verified one initial chart request, no Office Transactions heading, populated graph, period and process filtering, full action queue, desktop placement and mobile overflow. Build, changed-file lint, and diff checks passed. No files removed.

Pre-commit full-suite verification: Current result 258 tests/1621 assertions, 2 errors and 3 failures. Fresh unchanged-HEAD baseline result 257 tests/1603 assertions, the identical 5 failing identities, no new failing tests. The new clerk test passed with 18 assertions. Baseline/current JUnit and logs are under .git/codex-checks/clerk-*-phpunit.*. Existing failures: two OfficeIconTest errors for absent GD, EndUserStepOfficeTest, OfficeRoleMatrixTest and OfficeScopedAccessTest. Repository pre-push policy requires build success and treats this existing PHPUnit baseline as advisory.
