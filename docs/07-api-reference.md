# 7. API Reference (prefix `/api`)

## Auth (Sanctum cookie)
- `POST /auth/login (guest)` — `{email, password, remember?}` -> session + `{user}`
- `GET /auth/me (auth)` — `{user + roles{id,code,name}}`
- `POST /auth/logout (auth)` — destroys session
- `GET /weather` — public Open-Meteo proxy (Zamboanga `6.9214,122.0790`)

## Worker (auth)
- `GET /transactions` — `UserTransaction@index`, only tx where user role can work current step
- `GET /transactions/{tx}` — detail + `meta.available_actions` (routes passing JsonLogic)
- `POST /transactions/{tx}/execute` — `{route_id, remarks?, field_values/fields?}` -> validate + advance
- `POST /transactions/{tx}/requirements/{req}/check` / `DELETE .../uncheck` — checklist toggle (uncheck: checker or superadmin only)

## Admin (`auth + EnsureRole:superadmin`, prefix `/admin`)
- `apiResource users, roles, transaction-types, government-references, fields`
- `GET/POST /workflow-definitions`, `GET /workflow-definitions/{wf}`, `POST /workflow-definitions/{wf}/publish`
- `GET/POST /workflow-definitions/{wf}/steps`, `PUT/DELETE /.../steps/{step}`
- `POST /.../{wf}/routes`, `PUT/DELETE /.../routes/{route}`
- `GET/POST /.../{wf}/requirements`, `PUT/DELETE /.../requirements/{req}`
- `GET /.../steps/{step}/fields`, `POST .../sync` (same for `requirements`)
- `GET/POST /transactions`, `GET /transactions/{tx}`, `POST /transactions/{tx}/execute`

Validation via `FormRequest` classes; admin writes emit `AuditLog`.
