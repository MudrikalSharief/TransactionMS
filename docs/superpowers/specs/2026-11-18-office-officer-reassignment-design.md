# Office transaction officer reassignment

The user confirmed admin/superadmin-only reassignment, independent responsibility for each office after forwarding, assignment before a returned visit is received, and immediate viewing access for the replacement. Current-step office/role checks continue to govern processing actions.

Add a visible Reassign officer action to active Office Transactions rows and reuse the existing dialog on the transaction detail. Each office manages its latest destination visit, including after forwarding. Superadmins can choose among the offices that have received the transaction. Earlier visits remain receipt/history records. A pending return becomes the office's latest visit and may be assigned before receipt when that office previously received the transaction. An initial pending visit still requires receipt.

Use the existing assigned_to field and append-only assignment events. Preserve received_by, received_at, workflow position, pending status, SLA, and requirements. Require an eligible active officer in the selected visit's office and role, plus a reason. Serialize with routing/receiving, reject obsolete visit IDs and assignment versions, and record every change in route history and audit logs. No schema change is needed.

An explicit assignee on an office's latest visit has viewing access while another office processes the transaction. A later visit in the same office supersedes that office's previous assignment. Displaced officers do not regain access through office, role, or creator membership. Existing current-visit assignment checks continue to restrict current-step actions and pending receipt. Historical viewing does not grant actions at another office. Viewer tracking remains restricted after explicit assignment.

Office admins may select only their office's visit. Superadmins may select eligible offices independently. Completed and archived transactions remain closed to reassignment. A returned pending assignment does not mark the transaction received or reveal a fabricated receiver/time.

Verify forwarded-office reassignment, cross-office isolation and visibility, pending return assignment/receipt, initial pending denial, stale/revisited runs, invalid users, regular-user denial, list actions and dialog selection. Retain existing regression coverage with SQLite :memory: and compare the known full-suite baseline. Preserve the uncommitted login button edits.

## Automatic assignment on return
The user confirmed that a return restores the destination's previous office/officer automatically, retains Receive as a separate action, and waits for admin reassignment if the previous officer is unavailable. Both configured return routes and backward returns to passed stations must use this behavior.

Resolve the latest prior visit to the return destination step. Its explicit assignee takes precedence over its original receiver, including assignments made after forwarding. Restore that officer only while active and eligible for the destination office/role. Add a new assignment event attributed to System and an audit entry inside the return transaction. Keep the original visit and all receipt facts intact. Forward progress and forward resends keep their existing assignment behavior.

Add is_automatic to assignment records, defaulting historical/manual records to false. Automatic return events set it true. Current-visit ownership remains exclusive, but automatic restoration alone must not activate the permanent prior-officer exclusions of manual reassignment. In particular, the next office's original officer can still receive corrected work after an ordinary forward/resend. Route history distinguishes Return assignment from manual Reassigned events.

If the previous officer was deleted, deactivated or became ineligible, leave the return pending with an explicit unassigned responsibility record that blocks other regular officers from claiming it. Its office admin/superadmin can choose a replacement using Reassign officer before receipt. This recovery must also work for legacy return destinations whose prior officer cannot be resolved. The admin dialog must explain when reassignment is required. Each new visit remains a separate receipt and assignment history record.

Even an administrator must choose an eligible replacement before receiving a return marked as awaiting reassignment. Existing initial unassigned receipts retain their existing receiving rules.
