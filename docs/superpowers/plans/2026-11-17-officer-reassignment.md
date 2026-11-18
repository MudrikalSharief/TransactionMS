# Officer Reassignment Implementation Plan

**Goal:** Implement immediate, exclusive officer assignments with persistent exclusions and route history.
**Architecture:** Add assigned_to and append-only assignment records. A shared OfficerAssignmentAccess service defines current-visit identity, row visibility and permission checks. Assignment API updates records atomically; shared transaction scope and runtime guards enforce the same rule on every access path. A separate Vue admin control consumes the API and route history shows assignment events without fake workflow runs.
**Tech Stack:** Laravel, SQLite :memory: PHPUnit, Vue/Vuetify.
**Spec:** docs/superpowers/specs/2026-11-17-officer-reassignment-design.md (approved).

## Constraints
Use current checkout, no commits. Preserve receipt facts, role/office/file-step restrictions and unrelated changes. Reasons required. Former officers stay excluded across visits until explicitly assigned again; admin/superadmin access remains scoped. Never-assigned transactions keep existing behavior. Preserve SQLite safety guard and compare full-suite failures with fresh baseline.

## Review focus
Direct attachment URLs and creator exceptions; stale concurrent reassignment/routing; account deletion/deactivation fails closed; return/finalize does not resurrect old access; viewer/public tracking and dashboard/list queries must not disclose excluded transactions.

## Task 1: Assignment domain/API
- [x] Test missing feature first, then add migration, TransactionOfficerAssignment model, OfficerAssignmentAccess service, OfficerReassignmentController and routes.
- [x] Interfaces: OfficerAssignmentAccess::currentRun(Transaction): ?TransactionStepRun, ::applyVisibility(Builder, User): Builder, ::canAccess(Transaction, User): bool, ::assertAccess(Transaction, User): void. Current visit excludes finalize-only self loops.
- [x] GET /api/admin/transactions/{transaction}/officer-assignment returns data {can_reassign, run_id, version, current_officer, candidates:[{id,name}], history:[assignment event]}. POST same path accepts {run_id,version,assigned_to,reason}; returns same data. Reject stale version/run 409, invalid targets/no-op 422, unauthorized 403; reason max 1000.
- [x] Event payload: {id,step_run_id,from_officer:{id,name},to_officer:{id,name},assigned_by:{id,name},assigned_at,reason}. Receipt names and timestamps unchanged.
- [x] Add assignment payload to TransactionResource: officer_assignment {can_reassign,run_id,version,current_officer}; assignment_history array. Existing detail gates must authorize before serialization.
- [x] Verify focused domain/API tests under guarded SQLite.

## Task 2: Admin controls and history
- [x] Add OfficerReassignmentDialog.vue and wire TransactionDetail.vue. Load candidates on open, require reason, pass run/version for 409 conflict, reload details after success.
- [x] Pass assignment_history to HistoryAttachmentsTabs.vue and render chronologically with routes as distinct reassignment events showing old/new/admin/time/reason; do not alter transaction runs/SLA.
- [x] Update hover current officer from assigned_to metadata while preserving received_at and receipt history. Handle 403/404 detail refresh by clearing stale data and returning to list.
- [x] Verify build/lint and browser mocked scenarios including history, validation and conflicts.

## Task 3: Access enforcement/integration
- [x] Add failing tests covering old officer/creator/colleague denial, assignee access, role/office eligibility, scoped administrators, next-step exclusions/restoration, viewer tracking and direct files.
- [x] Integrate shared access service into transaction queries and route-bound access before existing creator/office grants. Audit raw queries and alternate list/dashboard/approval/notification/report paths.
- [x] Serialize transaction writes against reassignments with transaction-row locks and recheck access after acquiring locks; prevent stale form actions from completing after transfer.
- [x] Run focused tests, full node .codex/hooks/verify.mjs full, compare baseline identities, git diff --check, refresh graphify update ., independent review, and address important findings.

## Execution ledger
User approved design and required reason. Implementation and access enforcement continue within that authorization; no additional approval gates for routine code changes. Agents own disjoint files and coordinate interface changes; final review checks the integrated result.

## Results
- Domain/API tests: 8 passed, 57 assertions. Access integration tests: 8 passed, 70 assertions. Tests first failed with missing endpoint before implementation.
- Frontend tests: 7 passed, including 2 new chronological assignment-event tests. ESLint and git diff --check passed.
- Final command node .codex/hooks/verify.mjs full: frontend build passed; PHPUnit 214 tests /1202 assertions, 2 errors and 4 failures. Baseline was 198 tests /1075 assertions, with exactly the same six failing identities; no new failing tests. Evidence: .git/codex-checks/reassignment-baseline-phpunit.log, reassignment-final.log and phpunit.log.
- Existing failing identities: OfficeIconTest::test_office_can_be_created_with_an_uploaded_icon; OfficeIconTest::test_office_icon_can_be_replaced_and_removed; DashboardSummaryTest::test_counts_each_status_in_the_current_calendar_week; EndUserStepOfficeTest::test_end_user_toggle_overrides_office_without_the_end_user_role; OfficeRoleMatrixTest::test_my_transactions_endpoint_stays_station_scoped; OfficeScopedAccessTest::test_office_admin_can_act_on_a_blank_step_at_their_office.
- Browser checks used mocked APIs without creating development records: required reason, stale 409 refresh with deliberate resubmission, successful transfer/reload, chronological history with admin/reason/Manila time, hover original receipt time, old-page polling denial/redirect, and 390px mobile layout. Screenshots in output/playwright/assignment-*.png.
- Applied only database/migrations/2026_11_17_000001_add_officer_assignments.php to local MySQL after SQL preview. Counts before/after unchanged: 57 transactions, 243 step runs, 35 users. Read-only MySQL visibility queries succeeded for all 35 existing accounts. No real officer assignments were changed.
- Graphify AST update completed (5355 nodes). Generated graph files remain uncommitted.
- Independent review found no Important/Critical issue in access control, lifecycle, locks, receipt preservation or alternate entry points.

## Rulings and review notes
- Stale administrator submissions after the transaction moves outside their current management office return 403; same-office run/version conflicts return 409. Current authorization takes priority over disclosing a stale step's updated assignment.
- The query scope assumes the existing unaliased transactions table. Independent review noted future aliased queries would require alias support; no current affected query exists, so this is a future integration consideration, not a current access-control defect.
- Account deletion tests detach the existing role pivot before deletion because that pre-existing foreign key restricts deletes. The assignment foreign keys then set deleted-user references to null while history snapshots and the assignment restriction remain.

No files removed and no commits made. All implementation tasks are complete; the unrelated pre-existing PHPUnit failures remain documented above.
