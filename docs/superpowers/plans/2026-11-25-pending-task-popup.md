# Pending Task Popup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Present the once-after-login pending task notice as a compact card based on the second reference image.

**Architecture:** Keep the existing Vue component and its data, trigger, and navigation logic. Replace its template and local dialog styling in place; remove all folder-tab and stamp styles made unused by the redesign.

**Tech Stack:** Vue 3, Vuetify 3, CSS, Vite.

**Spec:** `docs/superpowers/specs/2026-11-25-pending-task-popup-design.md`

## Global Constraints

- Preserve once-after-login display only for staff with pending tasks.
- Preserve greeting, assigned office, total count, status tally, Close, Remind me later, and Open tasks.
- Keep keyboard access, visible focus, narrow-screen layout, and short-viewport scrolling.
- Add no dependency or asset.

## Review Focus

- A long name or office label must wrap inside the card.
- A narrow phone must keep both actions reachable.
- A short viewport must allow the card to scroll.
- Zero or optional tally rows must not leave empty gaps.
- Closing or opening tasks must still mark the notice seen through the existing dialog lifecycle.

---

### Task 1: Replace pending task notice presentation

**Files:**
- Modify: `resources/js/components/LoginApprovalNotice.vue`
- Verify: `node .codex/hooks/verify.mjs full`

**Interfaces:**
- Consumes: existing computed values `greeting`, `user`, `officeCode`, `officeName`, `total`, `tally` and handlers `markSeen`, `openApprovals`.
- Produces: the same notice behavior and actions with a compact card presentation.

- [x] Replace the old folder, stamp, and illustrated footer template with a centered icon, heading, summary, tally, and two actions.
- [x] Replace obsolete dialog styles with compact responsive styles and clear focus states.
- [x] Run the frontend build and full verification; frontend passed, PHPUnit reported the same 2 errors and 3 failures as before this UI change.
- [x] Review a browser preview at desktop and 360px/320px phone widths; the 320px card scrolls to keep actions reachable. The live popup requires a signed-in staff session.
- [x] Run `graphify update .`, `git diff --check`, and check the final file list for obsolete files. No files became unused.
