import { ref } from "vue";

const dialog = ref({
    open: false,
    title: "Are you sure?",
    message: "",
    confirmLabel: "Confirm",
    cancelLabel: "Cancel",
    tone: "warning",
    resolve: null,
});

function close(result) {
    const resolve = dialog.value.resolve;
    dialog.value.open = false;
    dialog.value.resolve = null;
    if (resolve) resolve(result);
}

/**
 * Promise-based confirm modal (replaces window.confirm).
 * Resolves true when the user confirms, false on cancel/dismiss.
 *
 * Usage: const ok = await confirm({ title, message, confirmLabel, tone })
 */
export function confirm(options = {}) {
    if (dialog.value.open) {
        return Promise.resolve(false);
    }
    return new Promise((resolve) => {
        dialog.value.title = options.title ?? "Are you sure?";
        dialog.value.message = options.message ?? "";
        dialog.value.confirmLabel = options.confirmLabel ?? "Confirm";
        dialog.value.cancelLabel = options.cancelLabel ?? "Cancel";
        dialog.value.tone = options.tone ?? "warning";
        dialog.value.resolve = resolve;
        dialog.value.open = true;
    });
}

export function useConfirmDialog() {
    return {
        dialog,
        confirm: (result) => close(result),
        cancel: () => close(false),
    };
}
