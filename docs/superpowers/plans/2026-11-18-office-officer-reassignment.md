# Office Officer Reassignment Implementation Plan

**Goal:** Let admins reassign their office's transaction officer from the list after forwarding and on pending returns.
**Architecture:** Extend OfficerAssignmentAccess around each office's latest destination visit. Reuse assigned_to, assignment events and the shared dialog. Add authorized office-assignment read grants while preserving current-step action checks.
**Tech stack:** Laravel, Vue/Vuetify, PHPUnit SQLite :memory:, Playwright.
**Spec:** docs/superpowers/specs/2026-11-18-office-officer-reassignment-design.md, reflecting the user's confirmed clarification answers.

## Tasks
- [x] Add focused regressions for forwarding, pending returns, stale visits, ownership visibility, other-office action denial and list metadata.
- [x] Extend service, API and read visibility around the latest visit per office. Preserve atomic updates, original receipt facts, required reason and candidate scope.
- [x] Add the list button, office/visit selection to the existing dialog, and meaningful refresh/error handling. Preserve archive behavior and existing detail entry point.
- [x] Run focused and full verification, compare baseline identities, inspect desktop/mobile admin flows with mocked requests, and refresh Graphify.

Current checkout and local edits only. No development database writes or schema migration are required. Remove replaced unused files after checking references. Existing baseline has 214 tests, 1202 assertions, 2 errors and 4 failures.

## Verification and review
- New forwarding, pending-return, cross-office selection and superadmin version regressions failed before implementation. The assignment suites now pass 20 tests and 173 assertions through the normal PHPUnit entry point with SQLite :memory:.
- Independent review found a missing historical viewing grant on the normal admin detail endpoint. Added read-only middleware coverage restricted to actual managed office visits and explicit assignees. Tests cover both detail endpoints and attachment reads. Existing office gates retain their baseline behavior.
- Browser checks passed for admin/superadmin list actions, office selection, required reasons, forwarded and returned assignments, stale versions and preserving the selected office during retry. Desktop and mobile screenshots and scripts are in .git/codex-checks/office-reassign-* and office-reassignment-browser.*. Requests were mocked and changed no development records.
- Fixed dropdowns rendering outside the viewport by extracting the existing workspace menu positioning into one shared utility used by the shell and reassignment selectors. Browser checks also verify account menus at 1366px and 390px. The dialog scrolls its content while retaining its actions on narrow screens. Cached list rows retain the reassignment flag, with fresh server authorization on submission.
- Final full verification builds successfully and runs 218 tests/1248 assertions with the exact same 2 errors and 4 failures as the 214-test baseline. No added failing test identities. Changed frontend files pass ESLint, existing 7 frontend tests pass, and git diff --check passes. Graphify updated after source edits.
- No files removed, no schema changes, no commits and no pushes. Earlier login edits remain in the working tree.

## Automatic return assignment follow-up
- [x] Add failing API regressions for configured returns/backward jumps, original receiver versus reassigned owner, latest visit selection, unavailable officers and admin recovery.
- [x] Restore the previous destination officer within the return transaction, append System assignment/audit records, and keep unavailable-owner returns restricted and pending.
- [x] Explain required replacement in the existing admin dialog. Preserve receipt facts, current-step processing rules and normal forward behavior.
- [x] Verify focused/full tests with the in-memory guard, compare baseline failure identities, check the admin recovery flow and refresh Graphify.

### Automatic return verification
- Focused assignment suites pass 31 tests/262 assertions. New cases cover configured/backward returns, original/reassigned/latest owners, inactive/deleted/wrong-office/wrong-role officers, missing legacy receiver, admin recovery, required replacement before admin receipt, audit failure rollback, and forward/resend through the next office's actual Receive.
- Independent review reproduced a resend regression when automatic history activated manual prior-receiver exclusions. Added migration 2026_11_18_000001_mark_automatic_officer_assignments.php and the trusted is_automatic marker to separate automatic restoration from manual transfer. The reviewer independently verified return, receipt, resend and next-office receipt all succeed after the fix, with no remaining Critical/Important findings.
- Applied the additive migration to local MySQL. Before/after counts remained 36 users, 58 transactions, 248 runs and zero assignment records. The user then explicitly approved restoring the one pre-existing pending return. Applied only transaction70/run269, restoring its previous GSO officer42 while preserving workflow position, entered_at and null receipt fields. It remains pending Receive. This added one System assignment and its audit entry. Evidence is in .git/codex-checks/automatic-return-db-*.json and automatic-return-existing-result.json.
- Final full verification builds successfully and runs 229 tests/1337 assertions with the exact same 2 errors and 4 failures as the 218-test baseline. No changed failing identities. Changed Vue files pass ESLint, existing 7 frontend tests pass and git diff --check passes.
- Mocked desktop/mobile browser checks passed for admin and superadmin recovery, unavailable-officer warning, required reason and stale office/version recovery. Graphify updated after source changes. No files removed, commits or pushes.
