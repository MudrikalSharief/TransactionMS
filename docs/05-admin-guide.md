# 5. Admin Guide (superadmin only UI)

Order of setup: Types -> Steps (via Types) -> Routes -> Fields -> Requirements -> Roles/Users.

## Users (`admin/Users.vue`)
CRUD via `/api/admin/users`. Fields: `name, email, password (min 8, required on create), is_active, office_id, role_ids`. Audit-logged.

## Roles (`admin/Roles.vue`)
CRUD via `/api/admin/roles`. `code` is immutable key (`superadmin` cannot be deleted — 422). Assign via Users screen.

## Offices (ARCHIVED — hidden from UI, data kept)
`offices` + `office_steps` tables and `users/transactions.office_id` still exist with all rows intact, but every office surface is hidden: no sidebar item, no search entry, no Users column/picker, no transaction assignment UI, no office tracker. Roles alone gate the flow. Backend endpoints (`/api/admin/offices`, steps, `transactions/{id}/office`) remain live for reversibility. To restore: re-add the UI pieces (all removed from Vue only). To delete permanently: drop the tables/columns + remove the API.

## Transaction Types (`admin/TransactionTypes.vue`)
`code (payroll, procurement), name, description, is_active`. Seeded by `TransactionTypeSeeder`. The Steps column opens the type's Transaction Steps (same 1-2-3 steps logic as offices).

## Transaction Steps (`admin/Workflows.vue`, not in sidebar — open via Types -> Steps)
One list, one Save button. Every edit (add/update/delete step or route) auto-drafts backstage and goes live on Save — toast confirms "live for new transactions". Running papers stay pinned to their version; deleting a step that live papers sit on is blocked (422). Drafts: max one open per type (auto-reused); stale drafts deletable via `DELETE workflow-definitions/{id}` (draft-only). (Technical note: versions still exist invisibly; version numbers are hidden from the UI.)

## Steps + Routes
- Steps: `order_number, code (snake, unique per workflow), name, stage, sla_minutes, is_start/is_end`
- Routes: `from -> to, action_code, is_return_route, condition_expression (JsonLogic JSON), route_group, required_approvals_count`
- Pattern: linear forward `submit` chain + explicit `return` back-edges (e.g. `validate_dtr -> collect_dtr`, `gso_return_esig -> create_pr`)

## Fields (`Fields.vue` -> `StepFields.vue`)
Library (`field_definitions`, global when `workflow_definition_id=null`) + per-step attach (`display_order, required_override`). Types: `text|textarea|number|date|boolean|select|multiselect` with min/max/options/validation_rules. PR library: `pr_number, request_title*, office_name*, request_amount*, drive_link*, dts_number*, remarks`.

## Requirements (`Requirements*.vue` -> `StepRequirements.vue`)
Live-editable: definitions scoped to workflow + per-step attach (`display_order, is_required`) apply to running transactions immediately. Deleting an item with existing checks is blocked (set inactive instead). PR: `signed_pr_pdf, drive_uploaded, dts_created, pr_encoded, city_admin_signed, treasurer_signed, doc_validated, earmark_completed` mapped to their owning steps.

## Government References (`admin/GovernmentReferences.vue`)
Seeded lookup data via `GovernmentReferenceSeeder`.
