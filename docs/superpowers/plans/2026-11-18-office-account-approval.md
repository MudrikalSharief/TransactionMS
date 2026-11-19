# Office Account Approval Implementation Plan

**Goal:** Make selected-office approval requests visible and manageable to the office admin, with superadmin oversight.
**Architecture:** Retain existing registration, UserApproval and scoped office endpoints. Extend useSmartPoll with opt-in unversioned refresh and use it for account queues. Guard account fetches against stale responses after mutation.
**Spec:** docs/superpowers/specs/2026-11-18-office-account-approval-design.md, based on the user's confirmed choices.
**Stack:** Laravel, Vue/Vuetify, PHPUnit SQLite :memory:, Playwright.

## Tasks
- [x] Inspect registration/office approval permissions and verify real public signup through scoped approval, rejection and login. Initial integration test passes 17 assertions.
- [x] Reproduce dashboard and Users request staleness while transaction version stays unchanged.
- [x] Add independent silent account refresh, stale-response protection, and clear selected-office approval wording.
- [x] Run focused/full verification and mocked office/superadmin browser flows. Compare the known six-failure baseline, review important regressions and update Graphify.

Keep current checkout and prior edits. No commits/pushes or development account approval. Remove replaced unused files after checking references.

## Completion evidence
- Existing registration/approval server scope already enforces the selected office. Added a real public-registration regression covering CSD and GSO requests, wrong-office list/approve/reject denial, CSD approval/rejection, superadmin approval across offices and applicant login after approval. UsernameAuthenticationTest and OfficeAdminTest pass 26 tests/141 assertions.
- Reproduced stale account requests on both the dashboard and Office Users page while transactions/version remains constant. Added opt-in unversioned useSmartPoll refresh using existing scoped user endpoints. Existing transaction-version polling keeps its default behavior. Office Users search state is preserved, and refreshes pause during account mutations.
- Added fetch sequencing/invalidation so an older background response cannot resurrect an approved/rejected request. Browser test holds the earlier GET through approval and releases it after the fresh list, verifying the pending row stays removed.
- Mocked browser flows passed dashboard/Office Users refresh, CSD-only requests, office approval/rejection endpoint usage, superadmin all-office requests and approval, username confirmation text, and preserved search. Registration copy was visually checked at 1366px and 390px. Screenshots/scripts/logs are in .git/codex-checks/office-account-*.
- Signup text directs the applicant to their selected office's administrator. Dashboard pending rows and rejection confirmation identify applicants by username. Account load errors do not show a false all-clear state.
- Independent review found no Critical or Important issue. Build and changed-file ESLint pass, existing 7 frontend tests pass, and git diff --check passes. Final full suite is 230 tests/1356 assertions with the exact same 2 errors and 4 failures as the 229-test baseline, with no new failing identities. Graphify updated after source/test edits.
- Read-only local audit confirmed active csdadmin belongs to CSD, with no pending accounts at audit time. Browser requests were mocked and PHP tests used SQLite :memory:. No development accounts approved, no database/schema change, no files removed, no commits or pushes. Prior working-tree changes retained.
