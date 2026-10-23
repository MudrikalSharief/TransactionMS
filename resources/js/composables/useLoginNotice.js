// One-time "routing slip" after sign-in (clerk approvals notice).
// login() marks the session for the signed-in user; the notice reads the
// mark once and clears it, so it shows on the first page after login only.
// Browser storage only: nothing here reaches the server or the database.
const FLAG = "tms.loginNotice";
const SEEN = (uid) => `tms.approvalsSeenAt.${uid}`;

export function markLoginNotice(userId) {
    try {
        sessionStorage.setItem(FLAG, String(userId));
    } catch {
        /* storage blocked: the notice just won't show */
    }
}

export function clearLoginNotice() {
    try {
        sessionStorage.removeItem(FLAG);
    } catch {
        /* ignore */
    }
}

// True (once) when this user has just signed in.
export function takeLoginNotice(userId) {
    try {
        const marked = sessionStorage.getItem(FLAG);
        if (marked !== String(userId)) return false;
        sessionStorage.removeItem(FLAG);
        return true;
    } catch {
        return false;
    }
}

// When this user last saw the notice (ms), or null the first time.
export function approvalsSeenAt(userId) {
    try {
        const v = Number(localStorage.getItem(SEEN(userId)));
        return Number.isFinite(v) && v > 0 ? v : null;
    } catch {
        return null;
    }
}

export function markApprovalsSeen(userId, at = Date.now()) {
    try {
        localStorage.setItem(SEEN(userId), String(at));
    } catch {
        /* ignore */
    }
}
