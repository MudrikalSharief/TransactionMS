<template>
    <div class="workspace-backdrop" aria-hidden="true">
        <TrackBackdrop quiet class="workspace-sun-backdrop" />
        <svg class="workspace-wave workspace-wave--top" viewBox="0 0 1440 240" preserveAspectRatio="none">
            <path class="workspace-wave-soft" d="M0 0H1440V62C1140 155 1015 54 770 77C470 106 280 232 0 161Z" />
            <path class="workspace-wave-mid" d="M0 0H1440V23C1140 111 1025 26 760 54C440 88 270 202 0 127Z" />
            <path class="workspace-wave-strong" d="M0 0H1440V4C1110 76 1050 2 762 26C455 52 244 163 0 94Z" />
        </svg>
        <svg class="workspace-wave workspace-wave--bottom" viewBox="0 0 1440 240" preserveAspectRatio="none">
            <path class="workspace-wave-soft" d="M0 175C280 68 470 170 770 135C1015 108 1140 32 1440 113V240H0Z" />
            <path class="workspace-wave-mid" d="M0 199C270 105 440 197 760 164C1025 136 1140 65 1440 141V240H0Z" />
            <path class="workspace-wave-strong" d="M0 220C244 141 455 225 762 193C1050 170 1110 99 1440 170V240H0Z" />
        </svg>
    </div>
</template>

<script setup>
import TrackBackdrop from "@/components/track/TrackBackdrop.vue";
</script>
