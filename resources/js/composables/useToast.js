import { ref } from "vue";

// App-wide toast queue (see components/AppToaster.vue, mounted once in the
// shell). Module-scoped like useConfirm so any page can fire a message
// without prop-drilling. Repeated identical messages refresh their timer
// instead of stacking, and only the newest MAX_VISIBLE are kept.

const toasts = ref([]);
const timers = new Map();
const MAX_VISIBLE = 4;
const DEFAULT_TIMEOUT = 4200;
const ERROR_TIMEOUT = 7000;
let seq = 0;

const ICONS = {
    success: "mdi-check-circle-outline",
    error: "mdi-alert-circle-outline",
    warning: "mdi-alert-outline",
    info: "mdi-information-outline",
};

export function dismissToast(id) {
    const timer = timers.get(id);
    if (timer) {
        clearTimeout(timer);
        timers.delete(id);
    }
    toasts.value = toasts.value.filter((t) => t.id !== id);
}

function push(message, tone = "info", { timeout } = {}) {
    const text = String(message ?? "").trim();
    if (!text) return null;

    // Same message again: just restart its clock so rapid retries don't
    // bury the screen in duplicates.
    const existing = toasts.value.find((t) => t.message === text && t.tone === tone);
    if (existing) {
        const old = timers.get(existing.id);
        if (old) clearTimeout(old);
        const ttlAgain = timeout ?? (tone === "error" ? ERROR_TIMEOUT : DEFAULT_TIMEOUT);
        if (ttlAgain > 0) timers.set(existing.id, setTimeout(() => dismissToast(existing.id), ttlAgain));
        return existing.id;
    }

    const id = ++seq;
    const ttl = timeout ?? (tone === "error" ? ERROR_TIMEOUT : DEFAULT_TIMEOUT);
    toasts.value.push({ id, message: text, tone, icon: ICONS[tone] ?? ICONS.info });
    if (toasts.value.length > MAX_VISIBLE) dismissToast(toasts.value[0].id);
    if (ttl > 0) timers.set(id, setTimeout(() => dismissToast(id), ttl));
    return id;
}

export const toast = {
    push,
    success: (message, options) => push(message, "success", options),
    error: (message, options) => push(message, "error", options),
    warning: (message, options) => push(message, "warning", options),
    info: (message, options) => push(message, "info", options),
};

export function useToast() {
    return { toasts, dismiss: dismissToast, ...toast };
}
