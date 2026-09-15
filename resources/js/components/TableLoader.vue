<template>
    <div class="table-loader d-flex flex-column align-center justify-center" :style="{ minHeight: boxHeight + 'px' }">
        <div class="orbit">
            <span class="orbit-ring outer" />
            <span class="orbit-ring middle" />
            <v-avatar color="grey-darken-3" size="56" class="orbit-core">
                <v-icon color="white" size="30">{{ icon }}</v-icon>
            </v-avatar>
            <span class="orbit-dot d1" />
            <span class="orbit-dot d2" />
            <span class="orbit-dot d3" />
        </div>

        <div class="mt-5 text-subtitle-1 font-weight-bold loader-text">
            Loading {{ label }}<span class="dots"><span>.</span><span>.</span><span>.</span></span>
        </div>
        <div :key="tipIndex" class="text-caption text-medium-emphasis font-weight-bold tip-fade">
            {{ tips[tipIndex % tips.length] }}
        </div>
    </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'

const props = defineProps({
    label: { type: String, default: 'records' },
    icon: { type: String, default: 'mdi-database-sync' },
    compact: { type: Boolean, default: false },
})

const boxHeight = props.compact ? 220 : 360

const tips = [
    'Fetching the latest rows',
    'Lining up the columns',
    'Polishing the chips',
    'Almost there',
]

const tipIndex = ref(0)
let timer = null

onMounted(() => {
    timer = setInterval(() => {
        tipIndex.value += 1
    }, 2200)
})

onUnmounted(() => {
    if (timer) clearInterval(timer)
})
</script>

<style scoped>
.table-loader {
    width: 100%;
    font-family: 'M PLUS Rounded 1c', sans-serif;
}

.orbit {
    position: relative;
    width: 120px;
    height: 120px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.orbit-ring {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
}

.orbit-ring.outer {
    inset: 0;
    border: 5px solid #e5e7eb;
    border-top-color: #424242;
    border-right-color: #616161;
    animation: orbit-spin 1.1s linear infinite;
}

.orbit-ring.middle {
    inset: 16px;
    border: 3px dashed #9e9e9e;
    opacity: 0.8;
    animation: orbit-spin-rev 2.4s linear infinite;
}

.orbit-core {
    animation: core-pulse 1.8s ease-in-out infinite;
    box-shadow: 0 4px 14px rgba(66, 66, 66, 0.4);
}

.orbit-dot {
    position: absolute;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: #424242;
}

.orbit-dot.d1 {
    top: 6px;
    left: 22px;
    animation: dot-bob 1.4s ease-in-out infinite;
}

.orbit-dot.d2 {
    bottom: 10px;
    right: 16px;
    background: #757575;
    animation: dot-bob 1.4s ease-in-out 0.25s infinite;
}

.orbit-dot.d3 {
    top: 52px;
    right: 2px;
    background: #9e9e9e;
    animation: dot-bob 1.4s ease-in-out 0.5s infinite;
}

.loader-text {
    color: #334155;
    letter-spacing: 0.02em;
}

.dots span {
    display: inline-block;
    margin-left: 3px;
    animation: dot-bounce 1.2s ease-in-out infinite;
    font-weight: 800;
    color: #424242;
}

.dots span:nth-child(2) {
    animation-delay: 0.15s;
}

.dots span:nth-child(3) {
    animation-delay: 0.3s;
}

.tip-fade {
    animation: tip-in 0.45s ease;
    min-height: 20px;
}

@keyframes orbit-spin {
    to {
        transform: rotate(360deg);
    }
}

@keyframes orbit-spin-rev {
    to {
        transform: rotate(-360deg);
    }
}

@keyframes core-pulse {
    0%,
    100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.1);
    }
}

@keyframes dot-bob {
    0%,
    100% {
        transform: translateY(0) scale(1);
        opacity: 1;
    }
    50% {
        transform: translateY(-8px) scale(0.8);
        opacity: 0.6;
    }
}

@keyframes dot-bounce {
    0%,
    100% {
        transform: translateY(0);
    }
    40% {
        transform: translateY(-4px);
    }
}

@keyframes tip-in {
    from {
        opacity: 0;
        transform: translateY(6px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
