<template>
    <transition name="toast-fade">
        <div v-if="visible" class="app-toast" role="status" aria-live="polite">
            {{ message }}
        </div>
    </transition>
</template>

<script setup>
import { onUnmounted, ref } from 'vue'

// Bottom-center toast (design mockup): dark pill that fades + slides in
// and auto-dismisses. Callers keep it simple via a template ref:
//   const toast = ref(null); toast.value?.show('Route staged…')
const visible = ref(false)
const message = ref('')
let timer = null

function hide() {
    visible.value = false
    if (timer) {
        clearTimeout(timer)
        timer = null
    }
}

function show(text, { duration = 2600 } = {}) {
    message.value = String(text ?? '')
    visible.value = true
    if (timer) clearTimeout(timer)
    timer = setTimeout(hide, duration)
}

onUnmounted(hide)

defineExpose({ show, hide })
</script>

<style scoped>
.app-toast {
    position: fixed;
    left: 50%;
    bottom: calc(24px + env(safe-area-inset-bottom, 0px));
    transform: translate(-50%, 0);
    z-index: 3000;
    max-width: min(92vw, 480px);
    padding: 12px 18px;
    border-radius: 12px;
    background: #14213d;
    color: #eef2f9;
    font-size: 14px;
    font-weight: 600;
    box-shadow: 0 14px 34px -14px rgba(0, 0, 0, 0.55);
}

html.dark .app-toast {
    background: #eef2fb;
    color: #0e1424;
}

.toast-fade-enter-active,
.toast-fade-leave-active {
    transition: opacity 0.25s ease, transform 0.25s ease;
}

.toast-fade-enter-from,
.toast-fade-leave-to {
    opacity: 0;
    transform: translate(-50%, 20px);
}

/* Centered resting position (Vue only toggles enter/leave transforms). */
.toast-fade-enter-to,
.toast-fade-leave-from {
    transform: translate(-50%, 0);
}

@media (prefers-reduced-motion: reduce) {
    .toast-fade-enter-active,
    .toast-fade-leave-active {
        transition: none;
    }
}
</style>
