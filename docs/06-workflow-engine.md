# 6. Workflow Engine

## Lifecycle
1. **Create** (`TransactionEngine::create(typeId, title, userId)`): picks latest `published` workflow for type, validates `is_start` exists, creates `Transaction (type, pinned workflow, reference_number XXXX-XXXX-XXXX, title, created_by)` + `TransactionState(current=start)` + `StepRun(action=create, from=start, to=start)`.
2. **Work step**: user fills step fields + checks required requirements.
3. **Execute** (`transitionByRoute`): `assertRouteExecutable` -> `FieldValidationService.validateForStep` -> upsert `FieldValue` -> create `StepRun(from=current, to=route.to, action, remarks, performed_by/at)` -> update `State.current_step_id + entered_at`.
4. **End**: `currentStep.is_end=true` = terminal (no outgoing forward routes). No `status` column — derive from step.

Pinned-version rule: all checks use `tx.workflow`, so publishing v2 never moves v1 in-flight transactions.

## RoutingEngine (`app/Services/RoutingEngine.php`)
- `availableActions(tx, user)`: `[]` if no current step or role fails; else outgoing routes from current where `routeConditionPasses`.
- `assertRouteExecutable(tx, routeId, user)`: 403 if role fails; 422 if route not in pinned workflow / `from != current` / required checklist missing / condition fails.
- `assertRequiredRequirementsChecked`: diffs `step.requirementDefinitions (pivot is_required)` vs `tx.requirementChecks (this step)`; aborts `422 Required checklist items not completed: {names}`.
- `userCanWorkOnStep`: `superadmin` bypass; else intersect `step_roles` with `user.roles`.
- `buildContext(tx)`: `{transaction_id, transaction_type_code, workflow_version, current_step_code, fields{code: value}}` with priority `value_json.value > value_number > value_text > raw value_json`.

## JsonLogic (`JsonLogicEvaluator.php`)
Supports `var (dot-path), ==, !=, >, >=, <, <=, and, or, !, missing, missing_some`. Null expression = pass. Invalid/unknown op = fail. Example: `{"var":"fields.request_amount"}`.

## Validation & Versioning & Audit
- `FieldValidationService::validateForStep`: builds Laravel rules from type + min/max + options + `validation_rules` + `required_override`.
- `WorkflowVersioningService`: `createDraft(clone_latest_published), publish, assertDraft, cloneFrom`.
- `AuditService::log(request, event, entity, meta)` -> `audit_logs(actor, event, entity, ip, ua)`.
