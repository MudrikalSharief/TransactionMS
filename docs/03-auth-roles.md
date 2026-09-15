# 3. Auth & Roles

## Login flow
1. `Login.vue submit()` -> `useAuth.login({email, password})`
2. `GET /sanctum/csrf-cookie` -> `POST /api/auth/login` -> `GET /api/auth/me`
3. Backend `AuthController@login`: `Auth::guard('web')->attempt()` + `session()->regenerate()`, returns `{message, user}`
4. Router guard caches `user`; `AppShell` shows bar/drawer only when `user && route != login`
5. Logout: `POST /api/auth/logout` (guard logout + invalidate + regenerate token), `user=null`, push `login`

## Roles
Seeded in `database/seeders/RolesSeeder.php` (13 codes):
`superadmin, admin, clerk, approver, viewer, end_user, gso, city_admin, cto, city_treasurer, cadmin, cbo, bac_paad`

- API gate: `EnsureRole:superadmin` on all `/api/admin/*`
- Step gate: `RoutingEngine::userCanWorkOnStep()` — `superadmin` bypass, else `step_roles ∩ user.roles` must intersect. Empty allowed list = deny.
- UI gate only: `AppShell` / `Dashboard` check `roles.some(code==='superadmin')` to show admin menu. No router role guard.
- Uncheck rule: only checker or `superadmin` can uncheck a requirement.

## Default accounts (password `admin123`)
- `vinzmuloc@gmail.com` — Super Admin (`superadmin`) — `SuperAdminSeeder.php`
- `enduser@lgu.test (end_user)`, `gso@lgu.test (gso)`, `cityadmin@lgu.test (city_admin)`, `cto@lgu.test (cto)`, `treasurer@lgu.test (city_treasurer)`, `cadmin@lgu.test (cadmin)`, `cbo@lgu.test (cbo)`, `bac@lgu.test (bac_paad)` — `UsersSeeder.php`

Passwords are bcrypt-hashed; plaintext is not recoverable from DB — these values are the seeder defaults.
