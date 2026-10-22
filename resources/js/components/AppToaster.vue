<template>
    <div class="toaster" role="status" aria-live="polite">
        <TransitionGroup name="toast">
            <div v-for="t in toasts" :key="t.id" class="toast" :class="`toast-${t.tone}`">
                <v-icon class="toast-icon" size="small" :icon="t.icon" aria-hidden="true" />
                <div class="toast-text">{{ t.message }}</div>
                <v-btn
                    icon="mdi-close"
                    variant="text"
                    size="x-small"
                    density="comfortable"
                    class="toast-close"
                    aria-label="Dismiss"
                    @click="dismiss(t.id)"
                />
            </div>
        </TransitionGroup>
    </div>
</template>

<script setup>
import { useToast } from "@/composables/useToast";

const { toasts, dismiss } = useToast();
</script>

<style scoped>
.toaster {
    position: fixed;
    right: 20px;
    bottom: 20px;
    z-index: 6000;
    display: flex;
    flex-direction: column;
    gap: 10px;
    width: min(380px, calc(100vw - 32px));
    pointer-events: none;
}

@media (max-width: 600px) {
    .toaster {
        right: 12px;
        left: 12px;
        bottom: 12px;
        width: auto;
    }
}

.toast {
    pointer-events: auto;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 12px 8px 12px 14px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-left: 4px solid rgb(var(--v-theme-info));
    box-shadow: 0 8px 28px rgba(15, 23, 42, 0.22);
}

.toast-text {
    flex: 1 1 auto;
    min-width: 0;
    font-size: 0.82rem;
    font-weight: 600;
    line-height: 1.35;
    padding-top: 3px;
    overflow-wrap: anywhere;
}

.toast-icon {
    flex: 0 0 auto;
    margin-top: 2px;
    color: rgb(var(--v-theme-info));
}

.toast-close {
    flex: 0 0 auto;
    margin-top: 1px;
}

.toast-success {
    border-left-color: rgb(var(--v-theme-success));
}

.toast-success .toast-icon {
    color: rgb(var(--v-theme-success));
}

.toast-error {
    border-left-color: rgb(var(--v-theme-error));
}

.toast-error .toast-icon {
    color: rgb(var(--v-theme-error));
}

.toast-warning {
    border-left-color: rgb(var(--v-theme-warning));
}

.toast-warning .toast-icon {
    color: rgb(var(--v-theme-warning));
}

.toast-enter-active,
.toast-leave-active {
    transition: opacity 0.18s ease, transform 0.18s ease;
}

.toast-enter-from,
.toast-leave-to {
    opacity: 0;
    transform: translateY(6px);
}

.toast-move {
    transition: transform 0.18s ease;
}

@media (prefers-reduced-motion: reduce) {
    .toast-enter-active,
    .toast-leave-active,
    .toast-move {
        transition: none;
    }
}
</style>
