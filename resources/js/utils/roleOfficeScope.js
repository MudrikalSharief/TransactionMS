export function isRoleAvailableInOffice(role, officeId) {
    if (!role) return false;
    return role.office_id == null || (Number(officeId) > 0 && Number(role.office_id) === Number(officeId));
}
