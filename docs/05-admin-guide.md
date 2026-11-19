# 5. Admin Guide

Order of setup: Types -> Steps (via Types) -> Routes -> Fields -> Requirements -> Roles/Users.

## Users (`admin/Users.vue`)
Superadmins use **Accounts** (`/admin/users`) to create and manage accounts across offices, including Admin and Superadmin roles. Fields include name, position, username, optional email/contact number, password (minimum 8 characters; required on create), active status, office and roles. Changes are audit-logged.

Office admins use **Office Users** (`/office/users`) to manage their own office. To create another admin, choose **Add user**, enter the account details, select **Admin**, and create the account. To promote an existing member, edit their roles and select Admin. Other admins in the same office can be edited, demoted, deactivated or reactivated. Newly created accounts are approved immediately.

Office admins cannot move accounts between offices, manage their own access here, assign Superadmin, or change any Superadmin account. Superadmins retain oversight across offices. Public signup cannot request Admin or Superadmin.

## Roles (`admin/Roles.vue`)
CRUD via `/api/admin/roles`. Codes, names and descriptions can be edited inline; the UI locks the Superadmin code, and deleting Superadmin is blocked by the server (422). Assign via the Users screen.

Office admins also have **Roles** under People (`/office/roles`). It uses the same Add Role and inline code/name/description editing controls. They can manage and restore custom roles created for their own office; shared roles are read-only. Role codes are unique across the system, so an office prefix such as `csd_records` helps distinguish custom roles. Recreating an owned deleted code restores its original role and relationships.

Assign a custom role through **Office Users** by opening a user's Roles cell, selecting the role and saving. Custom roles can only be assigned to accounts in the owning office. Superadmins see all roles and offices, but must remove incompatible custom roles before transferring a user. Public registration only offers shared roles and roles for the selected office. Removing an office unassigns its members and removes office-specific role assignments while preserving shared roles.

## Offices (ARCHIVED — hidden from UI, data kept)
`offices` + `office_steps` tables and `users/transactions.office_id` still exist with all rows intact, but every office surface is hidden: no sidebar item, no search entry, no Users column/picker, no transaction assignment UI, no office tracker. Roles alone gate the flow. Backend endpoints (`/api/admin/offices`, steps, `transactions/{id}/office`) remain live for reversibility. To restore: re-add the UI pieces (all removed from Vue only). To delete permanently: drop the tables/columns + remove the API.

## Transaction Types (`admin/TransactionTypes.vue`)
`code (payroll, procurement), name, description, is_active`. Seeded by `TransactionTypeSeeder`. The Steps column opens the type's Transaction Steps (same 1-2-3 steps logic as offices).

## Transaction Steps (`admin/Workflows.vue`, not in sidebar — open via Types -> Steps)
One list, one Save button. Every edit (add/update/delete step or route) auto-drafts backstage and goes live on Save — toast confirms "live for new transactions". Running papers stay pinned to their version; deleting a step that live papers sit on is blocked (422). Drafts: max one open per type (auto-reused); stale drafts deletable via `DELETE workflow-definitions/{id}` (draft-only). (Technical note: versions still exist invisibly; version numbers are hidden from the UI.)

## Steps + Routes
- Steps: `order_number, code (snake, unique per workflow), name, stage, sla_minutes, is_start/is_end`
- Routes: `from -> to, action_code, condition_expression (JsonLogic JSON), route_group, required_approvals_count` — forward-only (`is_return_route` retired; going back is done via jump to a visited station, recorded as Returned; old versions keep their return rows)
- Pattern: linear forward `submit` chain (e.g. `validate_dtr -> finalize_payroll` on `approve`)

## Fields (`Fields.vue`)
Library (`field_definitions`, global when `workflow_definition_id=null`). Types: `text|textarea|number|date|boolean|select|multiselect` with min/max/options/validation_rules. PR library: `pr_number, request_title*, office_name*, request_amount*, drive_link*, dts_number*, remarks`.

## Requirements (`Requirements*.vue` -> `StepRequirements.vue`)
Live-editable: definitions scoped to workflow + per-step attach (`display_order, is_required`) apply to running transactions immediately. Deleting an item with existing checks is blocked (set inactive instead). PR: `signed_pr_pdf, drive_uploaded, dts_created, pr_encoded, city_admin_signed, treasurer_signed, doc_validated, earmark_completed` mapped to their owning steps.

## Government References (`admin/GovernmentReferences.vue`)
Seeded lookup data via `GovernmentReferenceSeeder`.
