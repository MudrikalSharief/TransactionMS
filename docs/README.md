# LGU Transaction System — Documentation

Central docs for end-users, admins, and developers.

## Contents

1. [Overview](01-overview.md) — what the app is, user types, glossary
2. [Architecture](02-architecture.md) — tech stack, frontend/backend layout
3. [Auth & Roles](03-auth-roles.md) — login, Sanctum session, role matrix, default accounts
4. [User Flow](04-user-flow.md) — Login → Dashboard → My Transactions → Detail → Execute
5. [Admin Guide](05-admin-guide.md) — Users, Roles, Types, Workflows, Fields, Requirements
6. [Workflow Engine](06-workflow-engine.md) — lifecycle, RoutingEngine, TransactionEngine, JsonLogic
7. [API Reference](07-api-reference.md) — endpoints by area
8. [Database](08-database.md) — tables, relations, seed data
9. [Setup & Seeding](09-setup.md) — local run, seed, verify

> Source of truth verified against `app/`, `routes/api.php`, `resources/js/`, `database/migrations`, `database/seeders`, `app/Services/RoutingEngine.php`.
