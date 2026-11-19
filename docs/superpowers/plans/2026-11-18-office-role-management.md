# Office Role Management Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans inline, preserving existing dirty changes. Do not commit or push.

**Goal:** Mirror the superadmin Roles workflow for office admins with office-owned custom roles.

**Architecture:** Reuse role CRUD and page components, add nullable office ownership, and enforce role eligibility at every account assignment boundary.

**Tech Stack:** Laravel, MySQL locally, PHPUnit SQLite `:memory:`, Vue/Vuetify, Playwright CLI.

**Spec:** `docs/superpowers/specs/2026-11-18-office-role-management-design.md`

## Constraints

- Preserve existing roles as shared, existing accounts and workflow references.
- Office admins manage only their own custom roles and users; reserved roles and public signup restrictions stay protected.
- Role codes stay globally unique. Restore only an owned deleted role.
- Superadmins keep all-office oversight. Owned role assignments require the user's matching office.
- Reuse the current checkout and existing UI; no duplicate Roles page or generated graph files in git.

## Steps

- [x] Write failing feature tests for scoped CRUD, restoration, reserved/shared/foreign roles and all account assignment boundaries.
- [x] Add the nullable ownership migration and Role helpers; reuse RoleController with office-aware request validation/resource metadata and routes.
- [x] Enforce eligible role IDs in Office Users, superadmin account requests, public registration and user office transfers.
- [x] Reuse Roles.vue/useRoles for `/office/roles`, add navigation, read-only shared rows, office cache isolation and assignment filtering.
- [x] Verify focused tests; apply the additive local migration and verify existing role/account counts and assignments stay intact.
- [x] Verify desktop/mobile role CRUD, restoration, Office Users assignment, superadmin controls and signup role filtering using mocked browser requests.
- [x] Run full verification/lint, compare baseline failures, obtain independent review, update documentation and Graphify.

## Execution record

- User chose the mirrored Roles page with office-scoped role creation/editing and own-office user assignments.
- Existing office-admin account management from the previous task is preserved.
- Initial feature tests failed on missing office ownership and CRUD routes. Final focused tests pass: OfficeRoleManagementTest, OfficeAdminTest and UsernameAuthenticationTest, 41 tests / 340 assertions.
- Full verification runs 245 tests / 1555 assertions with the same two errors and four failures as the saved baseline; frontend build, lint and whitespace checks pass.
- Applied only the additive roles office-scope migration locally. Fingerprints confirm all 17 role definitions, 36 users and 36 role-user assignments remain unchanged; existing role owners are null.
- Browser tests cover creation at 1366/390/320px, inline code/name/description editing, delete/restore identity, Office Users assignment, superadmin controls, office-filtered signup and cache isolation on failed refresh. Browser requests are mocked; no live roles or accounts were created.
- Independent review findings resolved with red/green checks: office deletion detaches active and deleted owned-role assignments while preserving shared roles; role cache identity uses the actual auth `office.id` value.
- Signup interaction testing exposed a doubled popup coordinate and intrinsic grid-width overflow. Reused the bounded menu location strategy and constrained the mobile signup grid; menu, card and controls fit 390/320px screens.
- Final independent review reports no remaining important findings. Removed the superseded OfficeAdminController role-list method; no whole files were removed. No commits or pushes created.
