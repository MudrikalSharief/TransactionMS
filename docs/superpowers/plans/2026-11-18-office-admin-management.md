# Office Admin Account Management Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement these steps inline. Preserve the existing checkout and unrelated changes; do not commit or push.

**Goal:** Let office admins create and manage other admins in their own office.

**Architecture:** Reuse the office user API and Office Users page. Separate office account-management role restrictions from the privileged roles excluded by public signup. Keep office scoping, self-protection, approval and audit behavior.

**Tech Stack:** Laravel, PHPUnit with SQLite `:memory:`, Vue, Vuetify, Playwright CLI.

**Spec:** `docs/superpowers/specs/2026-11-18-office-admin-management-design.md`

## Constraints

- No migration or live account changes.
- Superadmin roles/accounts and other offices remain protected; self-management stays blocked.
- Preserve registration role restrictions and the existing test database guard.

## Steps

- [x] Add failing feature tests in `OfficeAdminTest.php` for Admin role discovery, creation, promotion, peer editing/deactivation and audit behavior; update the superseded admin-denial assertions.
- [x] Cover superadmin role injection, mixed-role protected targets, cross-office targets/transfer attempts, self-management and regular-user access.
- [x] Update `OfficeAdminController.php` and the public-role constant's comment without changing signup restrictions; run focused feature tests.
- [x] Update `admin/Users.vue` role guidance and peer-admin locks; document the workflow in the admin guide.
- [x] Verify desktop/mobile create/edit/inline role/status controls with mocked browser data; preserve protected controls.
- [x] Run full project verification and lint, compare pre-existing failing test identities, request independent review and update Graphify.

## Execution record

- Scope confirmed by user: office admins may manage admins in their own office; superadmins keep cross-office oversight.
- Red: the updated OfficeAdminTest failed four assertions on the old Admin role restrictions (15 tests, 81 assertions).
- Green: OfficeAdminTest and UsernameAuthenticationTest pass (32 tests, 212 assertions).
- Full verification: frontend build passes; PHPUnit runs 236 tests / 1427 assertions with the same two errors and four failing tests as the baseline. Lint and whitespace checks pass.
- Browser: create Admin at 1366px, 390px and 320px; inline promotion/demotion, peer name editing, deactivation/reactivation; self/superadmin locks, office scope and superadmin role picker verified with mocked requests. No live accounts changed.
- Independent read-only review: no critical or important findings. No files removed, migrations added or commits created.
- Ruling: use inline role/name/status editing for existing users; the current page has no Edit dialog entry point, so no new parallel account editor is introduced.
