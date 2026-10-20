// Unique background color per user role, used for the role chips inside the
// History From User / To User cells (same column as the name).
//
// Known roles get a hand-picked Vuetify color. Any future role added in
// Admin → Roles automatically gets a stable color via a hash fallback,
// so no code change is needed when new roles are created.

const ROLE_COLORS = {
    superadmin: 'red-darken-4',
    admin: 'indigo-darken-2',
    clerk: 'blue-darken-1',
    approver: 'green-darken-2',
    viewer: 'grey-darken-1',
    end_user: 'teal-darken-2',
    gso: 'orange-darken-3',
    city_admin: 'deep-purple-darken-2',
    cto: 'cyan-darken-3',
    city_treasurer: 'amber-darken-4',
    cadmin: 'purple-darken-2',
    cbo: 'light-green-darken-3',
    bac_paad: 'pink-darken-2',
};

// Fallback palette for roles added later. Must stay in this order so
// existing auto-assigned colors never shift when new entries are added.
const FALLBACK_PALETTE = [
    'brown-darken-2',
    'blue-grey-darken-2',
    'deep-orange-darken-2',
    'lime-darken-4',
    'light-blue-darken-3',
    'red-darken-2',
    'teal-darken-3',
    'purple-darken-3',
    'green-darken-3',
    'orange-darken-2',
    'indigo-darken-3',
    'cyan-darken-2',
];

function hashCode(str) {
    let h = 0;
    for (let i = 0; i < str.length; i++) {
        h = (Math.imul(31, h) + str.charCodeAt(i)) | 0;
    }
    return Math.abs(h);
}

export function roleColorFor(code) {
    const key = String(code || '').toLowerCase().trim();
    if (!key) return 'grey-darken-1';
    if (ROLE_COLORS[key]) return ROLE_COLORS[key];
    const idx = hashCode(key) % FALLBACK_PALETTE.length;
    return FALLBACK_PALETTE[idx];
}
