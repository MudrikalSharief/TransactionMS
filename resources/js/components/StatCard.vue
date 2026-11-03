<template>
    <div
        class="stat"
        :class="[`stat--${variant}`, { 'stat--click': clickable || cta }]"
        role="button"
        tabindex="0"
        :aria-label="`${label}: ${value}`"
        @click="clickable && emit('activate')"
        @keydown.enter.prevent="emit('activate')"
        @keydown.space.prevent="emit('activate')"
    >
        <!-- e.g. the hover preview menu -->
        <slot />
        <v-icon class="stat-watermark" aria-hidden="true">{{ icon }}</v-icon>
        <div class="stat-blob" aria-hidden="true" />
        <div class="stat-disc"><v-icon size="24" color="white">{{ icon }}</v-icon></div>
        <div class="stat-value">
            <v-progress-circular v-if="loading" indeterminate size="22" width="3" color="grey-darken-1" />
            <template v-else>{{ value }}</template>
        </div>
        <div class="stat-body">
            <span class="stat-badge">{{ label }}</span>
            <div class="stat-hint">{{ hint }}</div>
        </div>
        <div v-if="cta" class="stat-cta">
            {{ cta }} <v-icon size="14">mdi-chevron-down</v-icon>
        </div>
    </div>
</template>

<script setup>
defineProps({
    label: { type: String, required: true },
    value: { type: [Number, String], default: '—' },
    hint: { type: String, default: '' },
    // success | warning | danger | info | orange
    variant: { type: String, default: 'info' },
    // MDI icon: shown in the solid disc and as the faded watermark
    icon: { type: String, default: 'mdi-file-document-outline' },
    loading: { type: Boolean, default: false },
    // true: a click emits "activate" (Enter/Space always do)
    clickable: { type: Boolean, default: false },
    // small "Show list" hint shown on hover/focus
    cta: { type: String, default: '' },
})
const emit = defineEmits(['activate'])
</script>

<style scoped>
/* Each variant sets: --stat-c (solid), --stat-from / --stat-to (card
   gradient), --stat-badge-ink. */
.stat {
    --stat-c: #005eed;
    --stat-from: #e3eeff;
    --stat-to: #9cc2ff;
    --stat-badge-ink: #fff;
    position: relative;
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 0;
    min-height: 76px;
    padding: 10px 16px;
    border-radius: 12px;
    border: 1px solid color-mix(in srgb, var(--stat-c) 45%, transparent);
    background: linear-gradient(105deg, var(--stat-from) 0%, var(--stat-to) 100%);
    box-shadow: 0 8px 22px -16px color-mix(in srgb, var(--stat-c) 80%, transparent);
    overflow: hidden;
    isolation: isolate;
    transition: transform 0.22s cubic-bezier(.2, .9, .25, 1), box-shadow 0.22s;
}
.stat--click {
    cursor: pointer;
}
.stat:hover,
.stat:focus-visible {
    transform: translateY(-3px);
    box-shadow: 0 16px 28px -16px color-mix(in srgb, var(--stat-c) 90%, transparent);
    outline: none;
}
.stat:focus-visible {
    box-shadow: 0 0 0 3px color-mix(in srgb, var(--stat-c) 60%, transparent);
}

.stat--success { --stat-c: #16a34a; --stat-from: #e3f7ea; --stat-to: #86d9a3; }
.stat--warning { --stat-c: #f59e0b; --stat-from: #fff4d6; --stat-to: #fcc75a; --stat-badge-ink: #3b2600; }
.stat--danger { --stat-c: #e5383b; --stat-from: #fde6e7; --stat-to: #f59a9c; }
.stat--info { --stat-c: #005eed; --stat-from: #e3eeff; --stat-to: #9cc2ff; }
.stat--orange { --stat-c: #f26b21; --stat-from: #ffeadd; --stat-to: #fbb489; }

/* big faded icon + soft circle on the right */
.stat-watermark {
    position: absolute;
    right: 14px;
    top: 50%;
    z-index: -1;
    font-size: 60px !important;
    width: 60px;
    height: 60px;
    transform: translateY(-50%) rotate(-8deg);
    color: #fff;
    opacity: 0.38;
    pointer-events: none;
}
.stat-blob {
    position: absolute;
    right: -36px;
    top: -30px;
    z-index: -2;
    width: 130px;
    height: 130px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.18);
    pointer-events: none;
}

.stat-disc {
    flex: 0 0 auto;
    display: grid;
    place-items: center;
    width: 46px;
    height: 46px;
    border-radius: 50%;
    background: var(--stat-c);
    box-shadow: 0 8px 18px -8px color-mix(in srgb, var(--stat-c) 90%, transparent), inset 0 -4px 0 rgba(0, 0, 0, 0.08);
    transition: transform 0.3s cubic-bezier(.3, 1.6, .5, 1);
}
.stat:hover .stat-disc {
    transform: scale(1.06) rotate(-4deg);
}

.stat-body {
    flex: 1 1 0;
    min-width: 0;
}
.stat-badge {
    display: inline-block;
    padding: 1px 10px;
    border-radius: 999px;
    background: var(--stat-c);
    color: var(--stat-badge-ink);
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 0.03em;
    text-transform: uppercase;
    white-space: nowrap;
}
.stat-value {
    flex: 0 0 auto;
    font-size: 2rem;
    font-weight: 800;
    line-height: 1;
    font-variant-numeric: tabular-nums;
    color: #111827;
}
.stat-hint {
    margin-top: 2px;
    font-size: 0.75rem;
    line-height: 1.25;
    color: #1f2937;
}

.stat-cta {
    position: absolute;
    right: 10px;
    top: 5px;
    font-size: 0.7rem;
    font-weight: 800;
    color: #111827;
    opacity: 0;
    transform: translateX(6px);
    transition: opacity 0.2s, transform 0.2s;
}
.stat:hover .stat-cta,
.stat:focus-visible .stat-cta {
    opacity: 0.75;
    transform: none;
}

@media (max-width: 480px) {
    .stat-watermark { display: none; }
}
@media (prefers-reduced-motion: reduce) {
    .stat,
    .stat-disc,
    .stat-cta {
        transition: none;
    }
    .stat:hover,
    .stat:focus-visible,
    .stat:hover .stat-disc {
        transform: none;
    }
}

/* dark theme: same hues over the dark surface, light text */
html.dark .stat {
    --stat-from: color-mix(in srgb, var(--stat-c) 14%, rgb(var(--v-theme-surface)));
    --stat-to: color-mix(in srgb, var(--stat-c) 42%, rgb(var(--v-theme-surface)));
}
html.dark .stat-value,
html.dark .stat-cta {
    color: #fff;
}
html.dark .stat-hint {
    color: rgba(255, 255, 255, 0.82);
}
html.dark .stat-watermark {
    opacity: 0.16;
}
</style>
