import { ref } from "vue";
import { useApi } from "@/composables/useApi";
import { readCache, writeCache, invalidateCache, CacheKeys } from "@/composables/useCache";

const user = ref(null);
const initialized = ref(false);

// Approvals is hidden from users with no assigned role, and from end users
// (they submit, never approve). Superadmin keeps access even when also
// holding end_user. Mirrors ApprovalController::index.
export function canUseApprovals(u) {
    const codes = (u?.roles ?? []).map((r) => r.code);
    if (!codes.length) return false;
    return codes.includes("superadmin") || !codes.includes("end_user");
}

export function useAuth() {
    const { api, csrf } = useApi();

    // Single network round-trip; shared by the blocking first-load path and
    // the detached background revalidation below.
    async function revalidate({ painted = false } = {}) {
        try {
            const res = await api.get("/api/auth/me");
            user.value = res.data.user;
            writeCache(CacheKeys.authUser, res.data.user);
        } catch {
            const hadSession = painted || user.value != null;
            user.value = null;
            invalidateCache(CacheKeys.authUser);
            // We already let the router through on a cached session that
            // turned out dead: bounce to login (the API enforces auth
            // server-side regardless, so nothing protected ever leaks).
            if (hadSession && typeof window !== "undefined" && window.location.pathname !== "/login") {
                window.location.assign("/login");
            }
        } finally {
            initialized.value = true;
        }
    }

    // Instant illusion: the last known session paints the shell at once, so
    // first paint never waits on /me over a bad network. When a cached user
    // exists this resolves immediately and revalidates detached; cold loads
    // still await the network exactly once.
    function init() {
        let painted = false;
        try {
            const cached = readCache(CacheKeys.authUser);
            if (cached != null) {
                user.value = cached;
                initialized.value = true;
                painted = true;
            }
        } catch { /* ignore: fall through to network */ }
        if (painted) {
            revalidate({ painted: true }).catch(() => { /* handled inside */ });
            return Promise.resolve();
        }
        return revalidate();
    }

    async function login({ email, password, remember = false }) {
        await csrf();
        await api.post("/api/auth/login", { email, password, remember });

        await init();

        return user.value;
    }

    async function logout() {
        try {
            await api.post("/api/auth/logout");
        } finally {
            user.value = null;
            initialized.value = true;
            invalidateCache(CacheKeys.authUser);
        }
    }

    return { user, initialized, init, login, logout };
}
