# Officer reassignment with exclusive access

The confirmed extension in docs/superpowers/specs/2026-11-18-office-officer-reassignment-design.md adds Office Transactions list actions, reassignment of each office's latest visit after forwarding, assignment on pending returns, and explicit assignee viewing access across office handoffs. It supersedes the current-step-only restrictions below for those cases.

## Intent
Allow an office administrator to transfer responsibility for a specific transaction's current received step immediately. Preserve receipt facts and make each reassignment visible in route history. Once explicitly assigned, only the responsible officer and authorized administrators may access that transaction at that step.

## Confirmed requirements
- Reassignment takes effect immediately; the new officer need not accept it.
- An explicitly assigned transaction is accessible only to its assigned officer and authorized admin/superadmin accounts. Other regular staff, including the original receiver and creator, lose access.
- Previous responsible officers remain blocked across later steps until explicitly assigned again by an authorized administrator. Office, role, or creator membership cannot restore their access automatically.
- Every transfer appears in route history and the audit log.
- Preserve received_by and received_at as the original receipt facts.
- Keep the hover officer information as plain text without contact numbers or navigation.

## Approaches
1. Overwrite received_by: rejected because it rewrites the original receipt and its meaning.
2. Store the current assignment on the receiving step run and keep append-only assignment events: recommended. This supports one responsible officer at a time, explicit access checks, and a dedicated history without inventing workflow movements.
3. Keep assignment only in generic audit metadata: insufficient for a dependable current-assignee query and a first-class route history event.

## Data
- Add nullable assigned_to (foreign key to users) to transaction_step_runs. Use a new migration; do not alter previously applied migrations.
- Add transaction_officer_assignments with transaction_id, transaction_step_run_id, from_user_id, to_user_id, assigned_by, assigned_at, and reason. Store officer/admin name snapshots so account deletion does not erase the meaning of history.
- The first explicit assignment records the receiver as the previous responsible officer; subsequent assignments record the previous assigned officer. Reassigning to the current responsible officer is rejected as a no-op.
- A deleted or inactive assignee must not reopen access to other regular staff. Retain enough assignment history to distinguish an unassigned run from a run whose assignee is no longer available. An authorized administrator can assign a replacement.
- Update the current assignment, assignment event and audit log atomically. Serialize against routing/receiving/finalization so a stale page cannot reassign a step the transaction has already left.
- Require the client to submit the expected receiving-run ID and assignment version. Reject a departed step or changed assignment with 409 Conflict so one admin cannot unknowingly overwrite another admin's transfer. Recheck target eligibility inside the transaction.

## Administrator action
- Add Reassign officer to the current transaction detail, available to the current effective office's admin and superadmin.
- Allow reassignment only on the current received step of an active, non-finalized, non-archived transaction.
- Require an active eligible officer in that step's effective office with a role permitted to work on the step. Do not offer viewer-only accounts. Require a reason.
- An admin's ability to view a transaction through a different office in its workflow does not authorize reassigning the current office's work.
- Preserve authorized admin/superadmin oversight using existing visibility scope; assignment does not grant administrators access outside that scope.

## Access
- An explicit assignment narrows regular-user access. Being the creator, originating-office colleague, original receiver, or a matching role holder is no longer an alternative grant.
- The assigned officer may view and perform permitted current-step actions. Assignment must not bypass role, office, account status, archive, completion, checklist, or file-step restrictions.
- Apply the restriction on the server to transaction lists/search, detail, route history, officer details, attachment list/view/download/upload/reuse/delete, checklist/field updates, approvals, routing, jump-back, and finalization. Saved URLs and API requests must not bypass it.
- Suppress transaction-specific rows, titles, references and previews in dashboards, approval inboxes, notifications and reports exposed to excluded regular users. Aggregate signals must not grant access to a hidden row.
- Treat viewer tracking as access too: an explicitly assigned transaction must not remain discoverable to viewer accounts through public tracking. Administrators retain their authorized management access.
- Previously loaded data cannot be recalled. After reassignment, new server requests from the old officer are denied; polling/action failures must clear the stale detail and return them to an allowed list.

## Step transitions (confirmed lifecycle)
Assignments belong to one destination-step visit, identified by its receiving run. Moving forward, returning, or revisiting produces a new step visit and does not inherit an earlier assigned_to. Historical receipt and assignment records also preserve transaction-wide exclusions: a displaced receiver/assignee, and the responsible officer whose assigned visit has ended, cannot regain access through office, role, creator, or past assignment grants. A new explicit assignment to that officer restores access for that current visit, subject to eligibility checks.

At an unassigned next visit, eligible receiving officers of the new effective office may receive the transaction unless they are previously excluded officers. Once received, its newly responsible receiver can continue through the existing role/office gates until reassigned or the visit ends. An explicit assignment narrows access to its assignee and authorized administrators again. If the receiving office's regular officers are all previously excluded, its authorized admin/superadmin can receive the step and then explicitly assign an eligible previously excluded officer; receipt alone by the excluded regular officer is not a restoration path.

Never-assigned transactions retain their existing behavior. For transactions that have assignment history, ordinary creator/originating-office grants do not bypass exclusions on later visits. Viewer tracking remains unavailable for these restricted transactions, including between visits. Finished/archived assigned work stays restricted to its responsible officer for read access where the existing read rules permit it, plus authorized administrators; normal completion/archive write locks remain. Finalization must preserve the current visit's restriction even when it creates a self-loop history row; it is not a new assignment visit.

## Display and history
- The hover card shows Assigned Officer as plain text with the current responsible officer for that visit (explicit assignee, otherwise receiver). Receive at continues showing the original receipt time.
- Keep actual receiver information available in receipt history; do not relabel a reassigned officer as the original receiver.
- Merge assignment events chronologically into route history, using a distinct Reassigned entry with previous/new officer, assigning admin, time in Asia/Manila and reason. Administrative viewers see every event within their transaction scope.
- Assignment events do not create transaction_step_runs, change current_step_id, create pending receipts, or reset entered_at/SLA/checklists. They are responsibility changes within one visit, not routes.
- A subsequent assignment shows the new officer and retains every earlier event. Do not display contact numbers in the hover card.

## Verification and delivery
Test immediate access transfer, repeated transfers, old officer/creator/colleague/viewer denial, assignee access, scoped admin exceptions, invalid targets, stale concurrent submissions, departed steps, archived/finalized locks, account deletion/deactivation, repeat visits and event ordering. Test attachment direct URLs and all alternate transaction APIs, not just the detail UI. Verify the regular receive path for never-assigned work remains unchanged. Test that excluded officers remain denied after forward/return/revisit and while pending receipt, that new eligible officers can receive, that explicit reassignment restores an excluded officer's access, and that authorized admin receipt avoids deadlock when every eligible regular officer is excluded.

Use SQLite :memory: and preserve the test guard. Capture a fresh pre-change test baseline, run node .codex/hooks/verify.mjs full and compare failing test identities if existing failures remain. Refresh Graphify after product edits. Keep changes local and reviewable; do not commit generated graph artifacts. Remove any files made unused after checking references.

## Approval
The user approved this design and implementation, including immediate transfer, exclusive assignee/admin access, reassignment route history, persistent exclusion until explicit reassignment, and a required reason. Implementation and verification are recorded in docs/superpowers/plans/2026-11-17-officer-reassignment.md.
