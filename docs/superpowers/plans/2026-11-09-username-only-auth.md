# Username-only Authentication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Replace email-based account access with unique usernames.

**Architecture:** Keep the existing Laravel session authentication and Vue login
page. Use the existing username rules/index, a forward migration for legacy users
and nullable email, and username provisioning for internal account creation.

**Tech Stack:** Laravel 12, PHP 8.2, Vue 3, Vuetify, PHPUnit, Vite.

**Spec:** `docs/superpowers/specs/2026-11-09-username-only-auth-design.md`

## Global Constraints

- Work in the approved current `trial` checkout; preserve numeric user IDs.
- Public sign-up/login requires no email and provides no email fallback.
- Preserve passwords, approval requirements, office/role checks, and guest tracking.
- Tests use SQLite `:memory:`; never refresh or seed the development database.
- Refresh Graphify after changes; never commit generated graph output.

## Review Focus

- Case/whitespace variants must not create duplicate usernames.
- Existing blank usernames must be backfilled without changing IDs or passwords.
- Missing or duplicate names must still yield valid, collision-safe usernames.
- Unapproved accounts must remain blocked after registering without email.
- Internal creation and guest tracking must still work with non-null usernames.

### Task 1: Storage and authentication contract

**Files:** `app/Models/User.php`, `app/Http/Requests/Auth/LoginRequest.php`,
`app/Http/Controllers/Api/AuthController.php`,
`app/Http/Controllers/Api/RegistrationController.php`,
`database/migrations/2026_11_09_000001_require_usernames_for_authentication.php`,
`tests/Feature/UsernameAuthenticationTest.php`.

**Interfaces:** Preserve the login payload's `login` key, but validate its value as
a username only. Registration requires `username` and no `email`. Usernames remain
3–30 lowercase letters/numbers/dots/underscores, starting/ending alphanumeric.

- [x] Add API/storage tests for registration without email (201 and stored NULL),
  duplicate normalized usernames (422), username login (200), rejected email login,
  pending approval (403), and unique/non-null database constraints.
- [x] Add a migration fixture with blank usernames and colliding names; assert
  preserved IDs/passwords/emails/existing usernames and valid distinct backfills.
- [x] Run these tests and confirm the missing behavior fails before implementation.
- [x] Implement migration, model provisioning, and API changes; return username in
  authentication user data and preserve guest account lookup.
- [x] Run the focused suite plus existing guest tests; inspect any regressions.

### Task 2: Sign-up and sign-in presentation

**Files:** `resources/js/pages/Login.vue`, `resources/js/composables/useAuth.js`.

**Interfaces:** Submit the same username-only API contract as Task 1. Organize
registration into details, username/password, and office/role steps.

- [x] Move username entry to the credential step, remove email state/validation/
  payload/input, add step titles and useful username guidance, and update copy.
- [x] Keep field errors mapped to their owning step, including returning to step 0.
- [x] Build with `npm.cmd run build`; verify desktop/mobile form behavior using the
  local app, including validation and username prefill after registration.
- [x] Run the complete PHPUnit suite and compare against the recorded baseline.
- [x] Review the diff, run PHP syntax checks, update Graphify, and report migration
  requirements and any pre-existing test failures. Leave changes reviewable locally.
