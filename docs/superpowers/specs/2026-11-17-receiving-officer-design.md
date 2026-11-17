# Transaction receiving officer details

## Intent and scope
Let users contact the actual officer who received a transaction at a particular workflow step. Use the existing Laravel/Vue application and recorded transaction step receipts.

## Behavior
- Show Assign Officer as plain display text followed by the latest receiver's name in the transaction step hover details. Display Receive at: with that same receipt's date and time in Asia/Manila. Do not display contact numbers or officer navigation in the hover card.
- Show these receipt details only when that particular step has a completed receipt with a recorded receiver. An upcoming step or a pending receipt does not qualify.
- Open a separate page for the transaction and selected step. Show the assigned office as context and only the officer's name and contact number as personal information.
- Regular users see only the latest completed receipt's receiver for the selected step. Admin and superadmin users see all completed receipts' receivers for that step, with receipt dates to distinguish repeat visits.
- Viewer accounts cannot see the officer label or receipt details, open the details page, or retrieve the officer contact information through the API.
- Enforce role filtering and receipt eligibility on the server. Preserve existing transaction access restrictions; this feature does not grant access to additional transactions.
- Keep receipts scoped to their transaction and destination step; never substitute an office directory or the releasing officer.

## Implementation choices
Use received_by and received_at on existing step runs, with the receipt office snapshot as office context. Sort completed receipts by received_at and then run ID to resolve ties. Display Contact number not provided when the receiver has no contact number. Keep one entry per completed receipt for administrators so repeat visits remain distinguishable.

## Approaches
Use existing step receipt records, which already identify the actual receiver. An office directory cannot identify who received an individual transaction. Additional officer assignment storage would duplicate the existing receipt record and is unnecessary for this feature. The selected approach is existing receipts, with role-specific history visibility as requested.

## Validation
Cover viewer denial, pending receipt denial, step and transaction isolation, latest receiver selection, administrator history, missing contact numbers, and existing transaction access restrictions. Run the project full verification command against SQLite :memory: and refresh the local Graphify graph after code edits.

## Delivery
Keep changes local and reviewable. Remove files made unused by the implementation after checking references. No existing file is expected to require removal.
