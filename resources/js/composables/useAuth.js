import { ref } from "vue";
import { useApi } from "@/composables/useApi";

const user = ref(null);
const initialized = ref(false);

export function useAuth() {
    const { api, csrf } = useApi();

    async function init() {
        try {
            const res = await api.get("/api/auth/me");
            user.value = res.data.user;
        } catch {
            user.value = null;
        } finally {
            initialized.value = true;
        }
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
        }
    }

    return { user, initialized, init, login, logout };
}
