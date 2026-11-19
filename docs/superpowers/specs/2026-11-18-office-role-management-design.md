# Office-scoped role management

## Approved behavior

Office admins receive the same Roles page used by superadmins, linked under People. They may create, rename, describe, delete and restore custom roles owned by their office. Shared roles remain available for assignment but are read-only for office admins. Other offices' custom roles are neither manageable nor assignable by an office admin. Superadmin accounts and system role codes remain protected.

Role assignments continue through Office Users and are limited to that office's users. Superadmins retain management of all role definitions and all offices' accounts. A custom role may only be assigned to users belonging to its owning office, including assignments made by superadmins and through public registration. Changing a user's office requires removing incompatible custom roles. Public signup continues excluding Admin, Superadmin, Viewer and End User.

## Data and compatibility

Add nullable `roles.office_id` referencing offices. Null denotes an existing shared role; migration must not reclassify existing roles or modify account assignments. Role codes remain globally unique to preserve current references. Office admins cannot use any built-in `Role::HIERARCHY` code for custom roles or claim a shared/other-office deleted code. Recreating their own deleted code restores the same role ID and relationships. Office ownership cannot be changed through role update payloads.

## Implementation

Reuse RoleController, Roles.vue and useRoles with office-aware routes, validation and cache keys. Return office ownership and editability metadata. Enforce ownership on the server and display shared roles as read-only. Add `/office/roles` to office-admin navigation; keep `/admin/roles` restricted to superadmins. Workflow setup remains superadmin-operated.

Account role validation must cover office-admin create/update, superadmin create/update and public signup. Public signup and superadmin account forms filter office-specific role choices for the selected office. Office role mutations invalidate role catalogue caches. No live test accounts or roles will be created during browser verification.

## Verification

Feature tests cover ownership, office overrides, shared/foreign target rejection, reserved codes, restoration, audit records, account assignments, user transfers, registration and existing superadmin operations. Browser checks cover the reused Roles page and Office Users assignment controls on desktop/mobile, plus superadmin and signup office selection.
