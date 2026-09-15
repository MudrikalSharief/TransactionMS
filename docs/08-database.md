# 8. Database

## Identity
- `users (id, name, email unique, password, is_active, rememberToken)` + `password_reset_tokens, sessions`
- `roles (id, code unique, name, description, softDeletes)`, `role_user (user-role M2M)`
- `permissions, permission_role` — scaffolded, unused by engine
- `audit_logs (actor, event, entity, ip, ua)` via `AuditService`

## Catalog
- `transaction_types (id, code unique, name, description, is_active, softDeletes)`
- `government_references` — seeded lookups

## Workflow definition
- `workflow_definitions (id, transaction_type_id FK cascade, version, status, name, notes, published_at/by, unique(type,version))`
- `workflow_steps (id, workflow_definition_id FK cascade, order_number, code unique-per-workflow, name, stage, sla_minutes, is_start, is_end, softDeletes)`
- `workflow_routes (id, workflow_definition_id FK cascade, from_step_id FK cascade, to_step_id FK cascade, action_code, is_return_route, condition_expression json, route_group, required_approvals_count)`
- `step_roles (workflow_step_id FK cascade, role_id FK cascade, unique)` — auth gate

## Runtime
- `transactions (id, transaction_type_id FK cascade, workflow_definition_id FK cascade [pinned], reference_number unique, title, created_by FK, softDeletes)`
- `transaction_states (id, transaction_id FK cascade unique, current_step_id FK, entered_at)` — single mutable pointer
- `transaction_step_runs (id, transaction_id FK cascade, from_step_id FK, to_step_id FK nullable, action_code, remarks, performed_by FK, performed_at, index(tx,performed_at))` — immutable history

## Dynamic fields
- `field_definitions (id, workflow_definition_id nullable FK cascade [null=global], order_number, code, name, type, group, display_order, required, unique, sensitive, min/max_length, min/max_value, options json, validation_rules json, softDeletes, unique(workflow,code))`
- `field_definition_workflow_step (workflow_step_id FK cascade, field_definition_id FK cascade, display_order, required_override, unique)` — per-step form
- `field_values (id, transaction_id FK cascade, field_definition_id FK cascade, updated_by FK nullable, value_json json, value_text, value_number, unique(tx,field))` — one row per tx+field, upserted

## Checklists
- `requirement_definitions (id, workflow_definition_id FK cascade, order_number, code, name, description, is_active, softDeletes, unique(workflow,code))`
- `step_requirements (workflow_step_id FK cascade, requirement_definition_id FK cascade, display_order, is_required, unique)` — per-step gate
- `transaction_requirement_checks (id, transaction_id FK cascade, workflow_step_id FK cascade, requirement_definition_id FK cascade, checked_by FK, checked_at, unique(tx,step,req))` — immutable

## Seed order (`DatabaseSeeder`)
`RolesSeeder -> SuperAdminSeeder -> UsersSeeder -> TransactionTypeSeeder -> GovernmentReferenceSeeder -> WorkflowSeeder -> PurchaseRequestSetupSeeder`
