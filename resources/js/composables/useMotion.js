import { readonly, ref } from "vue";

// Animations on/off, one setting for the whole site (sidebar and login
// toggles). Off adds `no-motion` to <html>; app.css then stops every CSS
// animation and transition (loaders marked `motion-keep` keep turning),
// and JS animations ask motionOff().
//
// Remembered per browser. Until someone chooses, it starts OFF on devices
// that would struggle: data saver, a 2G connection, <= 2 GB memory or
// <= 2 CPU cores, or the system "reduce motion" setting. The same rule
// runs inline in app.blade.php so the page never flashes motion first.

const KEY = "lgu-tx:motion"; // "on" | "off"

function constrainedDevice() {
    if (typeof window === "undefined") return false;
    const c = navigator.connection;
    return Boolean(
        window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ||
            c?.saveData ||
            ["slow-2g", "2g"].includes(c?.effectiveType) ||
            (navigator.deviceMemory && navigator.deviceMemory <= 2) ||
            (navigator.hardwareConcurrency && navigator.hardwareConcurrency <= 2),
    );
}

function initial() {
    let saved = null;
    try {
        saved = localStorage.getItem(KEY);
    } catch {
        /* private mode: fall back to the device check */
    }
    if (saved === "on") return true;
    if (saved === "off") return false;
    return !constrainedDevice();
}

const enabled = ref(initial());

function apply() {
    if (typeof document !== "undefined") {
        document.documentElement.classList.toggle("no-motion", !enabled.value);
    }
}
apply();

function setMotion(on) {
    enabled.value = Boolean(on);
    apply();
    try {
        localStorage.setItem(KEY, enabled.value ? "on" : "off");
    } catch {
        /* private mode: lasts until reload */
    }
}

/** True when animations should not run (for JS-driven motion). */
export function motionOff() {
    return !enabled.value;
}

export function useMotion() {
    return {
        motionEnabled: readonly(enabled),
        setMotion,
        toggleMotion: () => setMotion(!enabled.value),
    };
}
