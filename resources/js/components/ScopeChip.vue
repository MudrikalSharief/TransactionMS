<template>
    <!-- Whose data this is: every page an admin sees states its office scope. -->
    <span v-if="scope" class="scope-chip" :class="`scope-chip--${scope.kind}`" v-tooltip="scope.tooltip">
        <v-icon size="15" class="scope-chip__icon">{{ scope.icon }}</v-icon>
        <span class="scope-chip__label">{{ scope.label }}</span>
        <span v-if="scope.badge" class="scope-chip__badge">{{ scope.badge }}</span>
    </span>
</template>

<script setup>
import { useOfficeScope } from '@/composables/useOfficeScope'

const scope = useOfficeScope()
</script>

<style scoped>
.scope-chip {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    height: 28px;
    padding: 0 10px 0 8px;
    border: 1px solid rgba(30, 64, 175, 0.28);
    border-left: 3px solid #005EED;
    background: #f1f5f9;
    color: #1E293B;
    font-size: 0.78rem;
    font-weight: 700;
    white-space: nowrap;
    max-width: 100%;
    animation: scope-in 0.35s cubic-bezier(.2, .9, .25, 1) both;
}
.scope-chip__icon {
    color: #005EED;
}
.scope-chip__label {
    overflow: hidden;
    text-overflow: ellipsis;
}
.scope-chip__badge {
    font-size: 0.62rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    padding: 2px 6px;
    background: #1A1F2B;
    color: #fff;
}
.scope-chip--all {
    border-left-color: #CA8A04;
}
.scope-chip--all .scope-chip__icon {
    color: #A16207;
}
@keyframes scope-in {
    from { opacity: 0; transform: translateY(-3px); }
}
@media (prefers-reduced-motion: reduce) {
    .scope-chip { animation: none; }
}
html.dark .scope-chip {
    background: rgba(148, 163, 184, 0.12);
    color: #E2E8F0;
    border-color: rgba(147, 197, 253, 0.3);
    border-left-color: #93C5FD;
}
html.dark .scope-chip__icon {
    color: #93C5FD;
}
</style>
