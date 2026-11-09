# Username-only account access

Approved by the user on 2026-11-09, to be implemented in the current `trial` checkout.

Remove email from public login and registration. Keep the existing numeric user
primary keys and relationships. Require a unique lowercase username for sign-up,
and accept only usernames and passwords for normal login. Keep existing passwords,
approval rules, office/role assignment, and guest tracking behavior.

The sign-up flow becomes **Your details → Create username and password → Office
and role**. Explain the username format and show duplicate-name validation inline.
Keep the existing branding and responsive panel rather than introduce another UI.

Preserve existing usernames. Generate usernames for accounts lacking one from
their names, adding a suffix for collisions. Enforce non-null usernames and the
existing unique index. Make the legacy email column nullable; never fabricate an
email or delete historical addresses. Internal account creation must also produce
a username so guest accounts and existing seeders remain usable.

Alternatives: dropping the email column would unnecessarily remove existing data
and expand the task into unrelated administration/contact features. Retaining email
as a login fallback conflicts with the requested username-only behavior. The chosen
approach retains email only as optional historical/contact data.

Verification covers email-free registration, username-only login, duplicates after
normalization, legacy username backfill, database constraints, pending approval,
guest access, and the three-step sign-up flow at desktop and mobile widths.
