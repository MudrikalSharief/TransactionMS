# 1. Overview

## What it is
Workflow-driven transaction tracker for LGU operations (Payroll, Procurement / Purchase Request).
Admins design versioned workflows. Role-based users advance transactions step-by-step with dynamic forms + checklists.

## User types
- **End users / role workers** (`end_user, gso, city_admin, cto, city_treasurer, cadmin, cbo, bac_paad`): work only steps assigned to their role via `My Transactions`.
- **Super Admin** (`superadmin`): full visibility (`Transactions`), all admin screens, bypasses step-role checks.
- **Generic roles** (`admin, clerk, approver, viewer`): scaffolded in `RolesSeeder`, not wired to seeded workflows.

## Glossary
- **Transaction Type**: catalog entry (`payroll`, `procurement`).
- **Workflow Definition**: versioned flow for a type (`version`, `status: draft|published|archived`). Transactions pin the latest `published` version at creation.
- **Step**: node in a workflow (`code`, `name`, `stage`, `is_start/is_end`).
- **Route**: directed edge `from_step -> to_step` with `action_code` (`submit/approve/return`), optional `condition_expression` (JsonLogic).
- **Field**: dynamic input attached per-step (`field_definition_workflow_step`).
- **Requirement**: checklist item attached per-step (`step_requirements`). Required items gate execution.
- **State**: single pointer `transaction_states.current_step_id`.
- **Step Run**: append-only history `transaction_step_runs`.

## Typical example (Procurement PR, 14 steps)
`create_pr -> upload_drive -> create_dts -> email_gso -> gso_input_pr_no -> gso_return_esig -> city_admin_sign -> email_cto -> treasurer_sign -> email_cadmin -> email_cbo -> cbo_validate -> cbo_earmark -> submit_bac_paad(end)`
One return edge: `gso_return_esig -> create_pr (return)`.
