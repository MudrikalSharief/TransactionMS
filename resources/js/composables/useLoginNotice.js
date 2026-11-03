// One-time "routing slip" after sign-in (clerk approvals notice).
// login() marks the session for the signed-in user; the notice reads the
// mark once and clears it, so it shows on the first page after login only.
// The overdue-transactions notice works the same way with its own mark, and
// remembers for the session that it was shown (the Transactions page then
// offers its "Pending overdue transactions" button).
// Browser storage only: nothing here reaches the server or the database.
import { ref } from "vue";

const FLAG = "tms.loginNotice";
const TX_FLAG = "tms.txNotice";
const TX_SHOWN = "tms.txNoticeShown";
const SEEN = (uid) => `tms.approvalsSeenAt.${uid}`;

// True while the clerk's in-tray notice is loading or open, so the
// overdue-transactions notice waits its turn instead of stacking on it.
export const trayBusy = ref(false);

// Who has seen the overdue notice this sign-in (reactive copy of TX_SHOWN,
// so the Transactions page button appears as soon as the notice shows).
const txShownFor = ref(readTxShown());
function readTxShown() {
    try {
        return sessionStorage.getItem(TX_SHOWN);
    } catch {
        return null;
    }
}

export function markLoginNotice(userId) {
    txShownFor.value = null;
    try {
        sessionStorage.setItem(FLAG, String(userId));
        sessionStorage.setItem(TX_FLAG, String(userId));
        sessionStorage.removeItem(TX_SHOWN);
    } catch {
        /* storage blocked: the notice just won't show */
    }
}

export function clearLoginNotice() {
    txShownFor.value = null;
    try {
        sessionStorage.removeItem(FLAG);
        sessionStorage.removeItem(TX_FLAG);
        sessionStorage.removeItem(TX_SHOWN);
    } catch {
        /* ignore */
    }
}

// True (once) when this user has just signed in: the overdue notice's turn.
export function takeTxNotice(userId) {
    try {
        if (sessionStorage.getItem(TX_FLAG) !== String(userId)) return false;
        sessionStorage.removeItem(TX_FLAG);
        return true;
    } catch {
        return false;
    }
}

export function markTxNoticeShown(userId) {
    txShownFor.value = String(userId);
    try {
        sessionStorage.setItem(TX_SHOWN, String(userId));
    } catch {
        /* ignore */
    }
}

// True once the overdue notice has been shown to this user this sign-in.
export function txNoticeShown(userId) {
    return userId != null && txShownFor.value === String(userId);
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
