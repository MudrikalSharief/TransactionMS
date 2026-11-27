<template>
    <div class="pw-summary">
        <div
            v-for="tile in tiles"
            :key="tile.key"
            class="pw-stat"
            :class="`pw-stat--${tile.tone || 'info'}`"
        >
            <span class="pw-stat-icon" aria-hidden="true">
                <v-icon size="20">{{ tile.icon }}</v-icon>
            </span>
            <span class="pw-stat-copy">
                <span class="pw-stat-value">{{ tile.value }}</span>
                <span class="pw-stat-label">{{ tile.label }}</span>
            </span>
        </div>
    </div>
</template>

<script setup>
defineProps({
    // [{ key, label, value, icon, tone }]
    tiles: { type: Array, default: () => [] },
})
</script>
