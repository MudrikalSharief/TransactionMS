# Pending task popup redesign

## Intent

Use the second supplied image's compact, centered white card as the visual format for the pending task notice shown to staff after sign-in. Keep the information and actions from the existing notice, which matches the first supplied image.

## Scope and behavior

- Show the notice once after a staff user signs in, when they have at least one pending task. Keep the existing trigger, task data, count calculations, seen state, and navigation to `/portal/approvals`.
- Show the signed-in user's greeting, assigned office, total pending tasks, and the existing status tally (waiting to be received, past due, on time, and new when applicable).
- Keep **Open tasks**, **Remind me later**, and a close control. Use clear focus states and preserve keyboard dismissal.
- Use a centered heading and copy, three small icon summaries for waiting to receive, past due, and on time, and a full-width primary action in the style of the approved reference. Omit the large badge above the heading. Show new arrivals and almost-due counts as short notes when present. Keep the system's blue palette and accessible contrast.
- Keep the dashboard visible behind a translucent, blurred backdrop. On narrow screens, stack summary details and actions; allow vertical scrolling when the viewport is short.

## Approaches

1. **Selected proposal:** Redesign `LoginApprovalNotice.vue` in place. Replace its folder tab, large stamp, and illustrated footer with a compact card. This keeps behavior and data flow stable and removes obsolete styling in the same edit.
2. Introduce a shared modal design for every system dialog. This would touch many unrelated workflows and require a separate inventory and review.

## Boundaries

The two references describe the current notice and its proposed replacement. Other dialogs keep their existing behavior and appearance unless the user confirms a wider scope. No new asset or dependency is needed.
