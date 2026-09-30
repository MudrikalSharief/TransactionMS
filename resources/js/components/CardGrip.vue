<template>
    <!-- Drag handle for a movable card. The page listens for the drag and
         arrow-key events it emits natively and finds it by the class. -->
    <span
        class="card-grip"
        draggable="true"
        role="button"
        tabindex="0"
        title="Drag to move this card"
        aria-label="Move this card. Drag it, or press the Up and Down arrow keys"
    >
        <v-icon size="20">mdi-drag</v-icon>
    </span>
</template>

<style scoped>
.card-grip {
    display: inline-flex;
    align-items: center;
    height: 34px;
    margin-left: -8px;
    margin-right: 4px;
    cursor: grab;
    color: rgba(var(--v-theme-on-surface), 0.38);
    transition: color 0.15s, background-color 0.15s;
}
.card-grip:hover,
.card-grip:focus-visible {
    color: rgb(var(--v-theme-on-surface));
    background: rgba(var(--v-theme-on-surface), 0.06);
    outline: none;
}
.card-grip:focus-visible {
    box-shadow: 0 0 0 2px rgba(var(--v-theme-on-surface), 0.4);
}
.card-grip:active {
    cursor: grabbing;
}
/* Browser drag-and-drop needs a mouse; hide the handle on touch-only screens. */
@media (pointer: coarse) {
    .card-grip {
        display: none;
    }
}
</style>
