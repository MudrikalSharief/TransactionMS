<template>
    <div class="netbar-wrap" :class="{ collapsed: !state }" :aria-hidden="state ? undefined : 'true'">
        <div class="netbar-inner">
            <div class="netbar" :class="`netbar-${state || 'offline'}`" role="status" aria-live="polite">
                <v-icon size="small" :icon="icon" aria-hidden="true" />
                <span class="netbar-title">{{ title }}</span>
                <span v-if="hint" class="netbar-hint">{{ hint }}</span>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from "vue";

// Connection strip shown under the app bar (spans login too). States:
//   offline — browser reports no connection
//   flaky   — browser thinks it's online but API calls fail with no response
//             (captive portals / office DHCP are the usual culprits)
//   back    — connection recovered; shows briefly then collapses
const state = ref(typeof navigator !== "undefined" && navigator.onLine === false ? "offline" : "");
let backTimer = null;

const META = {
    offline: {
        icon: "mdi-wifi-off",
        title: "You're offline",
        hint: "Changes can't be saved until the connection returns.",
    },
    flaky: {
        icon: "mdi-cloud-alert-outline",
        title: "Can't reach the server",
        hint: "Check your connection — we'll keep retrying.",
    },
    back: {
        icon: "mdi-check-circle-outline",
        title: "Back online",
        hint: "",
    },
};

const icon = computed(() => META[state.value]?.icon || META.offline.icon);
const title = computed(() => META[state.value]?.title || "");
const hint = computed(() => META[state.value]?.hint || "");

function showBackOnline() {
    state.value = "back";
    if (backTimer) clearTimeout(backTimer);
    backTimer = setTimeout(() => {
        state.value = navigator.onLine === false ? "offline" : "";
    }, 3000);
}

function onOffline() {
    if (backTimer) clearTimeout(backTimer);
    state.value = "offline";
}

function onOnline() {
    showBackOnline();
}

function onNetworkError() {
    // Real offline state wins; otherwise the server is unreachable.
    if (state.value !== "offline") state.value = "flaky";
}

function onNetworkOk() {
    if (state.value === "flaky" || state.value === "offline") showBackOnline();
}

onMounted(() => {
    window.addEventListener("online", onOnline);
    window.addEventListener("offline", onOffline);
    window.addEventListener("api:network-error", onNetworkError);
    window.addEventListener("api:network-ok", onNetworkOk);
});

onBeforeUnmount(() => {
    if (backTimer) clearTimeout(backTimer);
    window.removeEventListener("online", onOnline);
    window.removeEventListener("offline", onOffline);
    window.removeEventListener("api:network-error", onNetworkError);
    window.removeEventListener("api:network-ok", onNetworkOk);
});
</script>

<style scoped>
.netbar-wrap {
    display: grid;
    grid-template-rows: 1fr;
    transition: grid-template-rows 0.22s ease;
    position: sticky;
    top: var(--v-layout-top, 0px);
    z-index: 6;
}

.netbar-wrap.collapsed {
    grid-template-rows: 0fr;
}

.netbar-inner {
    overflow: hidden;
}

.netbar {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 2px 10px;
    padding: 8px 16px;
    color: #fff;
    font-size: 0.8rem;
    line-height: 1.3;
}

.netbar-offline,
.netbar-flaky {
    background: #b45309;
}

.netbar-back {
    background: #15803d;
}

.netbar-title {
    font-weight: 700;
    letter-spacing: 0.02em;
}

.netbar-hint {
    color: rgba(255, 255, 255, 0.88);
}

@media (prefers-reduced-motion: reduce) {
    .netbar-wrap {
        transition: none;
    }
}
</style>
