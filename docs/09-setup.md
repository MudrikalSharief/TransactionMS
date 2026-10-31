# 9. Setup & Seeding

## Local run
```bash
cp .env.example .env
# set DB_CONNECTION=mysql, DB_DATABASE=transaction, DB_USERNAME=root, DB_PASSWORD=
composer install
php artisan key:generate
php artisan migrate
php artisan db:seed
npm install
npm run build   # or npm run dev for Vite
php artisan serve --host=127.0.0.1 --port=8000
```
SPA at `http://127.0.0.1:8000`, API under `/api`, Sanctum stateful `127.0.0.1:8000`.

## Seed verification (read-only)
```sql
SELECT id, name, email, is_active FROM users WHERE email LIKE '%vinz%' OR email LIKE '%@lgu.test';
SELECT r.code FROM roles r JOIN role_user ru ON ru.role_id=r.id JOIN users u ON u.id=ru.user_id WHERE u.email='vinzmuloc@gmail.com';
SELECT code, name FROM transaction_types;
SELECT transaction_type_id, version, status FROM workflow_definitions ORDER BY transaction_type_id, version;
```

## Check the code
```bash
npm run lint   # finds unused code and likely mistakes in resources/js and public/sw.js
```
Rules are in `eslint.config.js`. No output means nothing was found.

## Login check
- Super admin: `vinzmuloc@gmail.com / admin123`
- Role test: `gso@lgu.test / admin123`, `cbo@lgu.test / admin123`, etc.
- If login fails: check `is_active=1`, correct DB (MySQL `transaction` vs stray `database/database.sqlite`), rerun `php artisan db:seed --class=SuperAdminSeeder`.

## Notes / known quirks
- Requirements routes: the library index uses `admin.requirements` (`/admin/requirements`); the workflow-scoped page uses `admin.workflow-requirements` (`/admin/workflows/:workflowId/requirements`). Keep the names distinct — duplicate names make one path unreachable.
- No router role guard; admin links hidden by `isSuperadmin` UI check only — API still enforces `EnsureRole:superadmin`.
- `User.HasApiTokens` trait present but login is session-based; no bearer tokens issued.
