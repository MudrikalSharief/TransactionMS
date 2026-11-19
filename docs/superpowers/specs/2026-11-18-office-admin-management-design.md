# Office admin account management

Office admins may create or promote another admin within their own office and manage that account through Office Users. Superadmins retain account management across all offices. This extends the existing Add User, edit form, inline roles and status controls; it does not add custom role creation to office admins.

The office API must force new accounts into the actor's office and ignore office transfer fields on updates. Other-office accounts remain inaccessible. Superadmin accounts, including accounts holding both Admin and Superadmin, remain protected. Office admins cannot edit or deactivate themselves through Office Users.

The office role list and create/update validation will permit Admin while excluding Superadmin. Public signup must continue excluding both privileged roles. Accounts created by an office admin remain approved immediately. Existing audit events record the actor, office and role changes. No schema migration or live account modification is required.

The UI must offer Admin in the existing role picker, unlock other office admins' edit/role/status controls, and explain the remaining superadmin restriction. Tests must exercise direct API requests as well as desktop/mobile controls, including spoofed office IDs and compound protected roles.
