<template>
    <v-menu
        v-model="open"
        :disabled="disabled"
        :close-on-content-click="false"
        location="bottom start"
        :offset="8"
        retain-focus
        transition="axn-dd"
        :width="menuWidth || undefined"
        :min-width="menuWidth || undefined"
        @update:model-value="onMenuToggle"
    >
        <template #activator="{ props: activatorProps }">
            <button
                ref="triggerRef"
                v-bind="activatorProps"
                type="button"
                class="axn-trigger"
                :class="{ 'is-open': open }"
                :disabled="disabled"
                role="combobox"
                aria-haspopup="listbox"
                :aria-expanded="open ? 'true' : 'false'"
                :aria-controls="menuId"
                :aria-activedescendant="open && act >= 0 ? optionId(act) : undefined"
                :aria-label="label"
                @keydown="onKeydown"
            >
                <span class="axn-tile axn-tile-lg" :class="toneClass(selected?.kind)">
                    <v-icon size="22">{{ selected ? kindIcon(selected.kind) : 'mdi-gesture-tap' }}</v-icon>
                </span>
                <span class="axn-txt">
                    <span class="axn-cap">{{ label }}</span>
                    <span class="axn-val" :class="{ 'is-muted': !selected }">{{ selected ? selected.verb : placeholder }}</span>
                </span>
                <v-icon class="axn-chev" :class="{ 'is-open': open }" size="20">mdi-chevron-down</v-icon>
            </button>
        </template>

        <div :id="menuId" class="axn-menu" role="listbox" aria-label="Actions">
            <div
                v-for="(item, i) in items"
                :id="optionId(i)"
                :key="item.value"
                class="axn-opt"
                :class="{ 'is-active': act === i, 'is-selected': isSelected(item) }"
                role="option"
                :aria-selected="isSelected(item) ? 'true' : 'false'"
                @click="choose(i)"
                @mouseenter="act = i"
            >
                <span class="axn-tile" :class="toneClass(item.kind)">
                    <v-icon size="22">{{ kindIcon(item.kind) }}</v-icon>
                </span>
                <span class="axn-txt">
                    <span class="axn-t" :class="{ 'is-danger': item.kind === 'clear' }">{{ item.verb }}</span>
                    <span v-if="item.detail" class="axn-d">{{ item.detail }}</span>
                </span>
                <v-icon v-if="isSelected(item)" class="axn-chk" size="20">mdi-check</v-icon>
            </div>
        </div>
    </v-menu>
</template>

<script setup>
import { computed, nextTick, ref } from 'vue';

// Action picker for the transaction detail pages (mockup: "Action Dropdown –
// Redesign"). The trigger shows the chosen action; the menu lists
// Proceed/Return/Resend/Cancel rows with kind-tinted tiles. Values pass
// through unchanged — the page maps '__clear' to null (onSelectAction).
// Class prefix is "axn-", never "ad-": ad blockers (uBlock Origin) hide
// elements named like .ad-tile / .ad-txt, which blanked this picker.
const props = defineProps({
    modelValue: { type: [Number, String], default: null },
    // unifiedRouteOptions rows: { value, verb, detail, kind }.
    items: { type: Array, default: () => [] },
    disabled: { type: Boolean, default: false },
    label: { type: String, default: 'Select action' },
    placeholder: { type: String, default: 'Choose an action' },
});

const emit = defineEmits(['update:modelValue']);

const open = ref(false);
// Highlighted row (keyboard arrows / mouse hover). -1 = none.
const act = ref(-1);
const triggerRef = ref(null);
// Menu matches the trigger width (measured when it opens).
const menuWidth = ref(0);
const uid = Math.random().toString(36).slice(2, 8);
const menuId = `axn-menu-${uid}`;
function optionId(i) {
    return `${menuId}-opt-${i}`;
}

const selected = computed(
    () => (props.items || []).find((it) => isSelected(it)) || null,
);

function isSelected(item) {
    return props.modelValue != null && String(item?.value) === String(props.modelValue);
}

const TONES = {
    proceed: 'tone-blue',
    return: 'tone-amber',
    resend: 'tone-purple',
    clear: 'tone-red',
};
function toneClass(kind) {
    return TONES[kind] || 'tone-neutral';
}

const ICONS = {
    proceed: 'mdi-arrow-right',
    return: 'mdi-arrow-left',
    resend: 'mdi-arrow-right',
    clear: 'mdi-close',
};
function kindIcon(kind) {
    return ICONS[kind] || 'mdi-arrow-right';
}

function onMenuToggle(v) {
    if (!v) return;
    // Highlight the selected row on open; measure the trigger for width.
    act.value = (props.items || []).findIndex((it) => isSelected(it));
    menuWidth.value = triggerRef.value?.offsetWidth || 0;
}

function choose(i) {
    const item = (props.items || [])[i];
    if (!item) return;
    emit('update:modelValue', item.value);
    open.value = false;
    nextTick(() => triggerRef.value?.focus());
}

function onKeydown(e) {
    const n = (props.items || []).length;
    if (!n) return;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        e.preventDefault();
        if (!open.value) {
            open.value = true;
            return;
        }
        const step = e.key === 'ArrowDown' ? 1 : -1;
        act.value = (act.value + step + n) % n;
    } else if (e.key === 'Home' && open.value) {
        e.preventDefault();
        act.value = 0;
    } else if (e.key === 'End' && open.value) {
        e.preventDefault();
        act.value = n - 1;
    } else if ((e.key === 'Enter' || e.key === ' ') && open.value) {
        e.preventDefault();
        if (act.value >= 0) choose(act.value);
    } else if (e.key === 'Escape' && open.value) {
        e.preventDefault();
        open.value = false;
    } else if (e.key === 'Tab' && open.value) {
        open.value = false;
    }
}
</script>

<style scoped>
/* ---- trigger ---- */
.axn-trigger {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 14px;
    text-align: left;
    font: inherit;
    color: #14213d;
    cursor: pointer;
    background: #fff;
    border: 1.5px solid #d9dfec;
    border-radius: 16px;
    padding: 10px 14px 10px 10px;
    min-height: 68px;
    transition: border-color .15s, box-shadow .15s;
}
.axn-trigger:hover {
    border-color: #aab4cc;
}
.axn-trigger:focus-visible,
.axn-trigger.is-open {
    outline: none;
    border-color: #1d3fae;
    box-shadow: 0 0 0 4px rgba(29, 63, 174, 0.28);
}
.axn-trigger:disabled {
    opacity: 0.6;
    cursor: default;
}
.axn-trigger:disabled:hover {
    border-color: #d9dfec;
}

/* ---- tiles ---- */
.axn-tile {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    display: grid;
    place-items: center;
    flex: none;
    transition: background .2s, color .2s;
}
.axn-opt .axn-tile {
    width: 40px;
    height: 40px;
}
.tone-blue { background: #e8eeff; color: #1d3fae; }
.tone-amber { background: #fff1d6; color: #b86e00; }
.tone-red { background: #fde8e8; color: #c62828; }
.tone-purple { background: #ede9fe; color: #6d28d9; }
.tone-neutral { background: #eef1f6; color: #5b6780; }

/* ---- trigger text ---- */
.axn-txt {
    flex: 1;
    min-width: 0;
}
.axn-cap {
    display: block;
    font-size: 12px;
    font-weight: 600;
    color: #5b6780;
    margin-bottom: 2px;
}
.axn-val {
    display: block;
    font-size: 16px;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.axn-val.is-muted {
    color: #5b6780;
    font-weight: 600;
}
.axn-chev {
    color: #5b6780;
    flex: none;
    transition: transform .2s;
}
.axn-chev.is-open {
    transform: rotate(180deg);
}

/* ---- menu ---- */
.axn-menu {
    margin: 0;
    padding: 8px;
    background: #fff;
    border: 1px solid #d9dfec;
    border-radius: 18px;
    box-shadow: 0 18px 40px -12px rgba(20, 33, 61, 0.28), 0 2px 6px rgba(20, 33, 61, 0.08);
}
.axn-opt {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 10px;
    border-radius: 12px;
    cursor: pointer;
    position: relative;
}
.axn-opt.is-active {
    background: #f3f6fc;
}
.axn-t {
    display: block;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.25;
}
.axn-t.is-danger {
    color: #c62828;
}
.axn-d {
    display: block;
    font-size: 13px;
    color: #5b6780;
    margin-top: 2px;
}
.axn-chk {
    margin-left: auto;
    color: #1d3fae;
    flex: none;
}
.axn-opt.is-selected::before {
    content: "";
    position: absolute;
    left: -8px;
    top: 12px;
    bottom: 12px;
    width: 4px;
    border-radius: 0 4px 4px 0;
    background: #1d3fae;
}

/* ---- dark theme (html.dark is toggled by AppShell) ---- */
html.dark .axn-trigger {
    background: #161e36;
    border-color: #2b3558;
    color: #eef2fb;
}
html.dark .axn-trigger:hover {
    border-color: #3a4670;
}
html.dark .axn-trigger:focus-visible,
html.dark .axn-trigger.is-open {
    border-color: #8aa1ff;
    box-shadow: 0 0 0 4px rgba(138, 161, 255, 0.35);
}
html.dark .axn-trigger:disabled:hover {
    border-color: #2b3558;
}
html.dark .axn-cap,
html.dark .axn-chev,
html.dark .axn-d,
html.dark .axn-val.is-muted {
    color: #9aa7c4;
}
html.dark .tone-blue { background: #25306a; color: #8aa1ff; }
html.dark .tone-amber { background: #4a3510; color: #ffbf47; }
html.dark .tone-red { background: #4a1f22; color: #ff8a80; }
html.dark .tone-purple { background: #3b2f63; color: #c4b5fd; }
html.dark .tone-neutral { background: #26304a; color: #9aa7c4; }
html.dark .axn-menu {
    background: #161e36;
    border-color: #2b3558;
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.6), 0 2px 6px rgba(0, 0, 0, 0.3);
}
html.dark .axn-opt.is-active {
    background: #1d2745;
}
html.dark .axn-t {
    color: #eef2fb;
}
html.dark .axn-t.is-danger {
    color: #ff8a80;
}
html.dark .axn-chk {
    color: #8aa1ff;
}
html.dark .axn-opt.is-selected::before {
    background: #8aa1ff;
}

@media (prefers-reduced-motion: reduce) {
    .axn-trigger,
    .axn-chev,
    .axn-tile {
        transition: none !important;
    }
}
</style>

<!--
    Menu enter/leave for transition="axn-dd" (mockup's translateY(-6px)
    scale(.98) at .16s, top origin). These classes land on Vuetify's own
    overlay content element, which carries no scope id, so this block has
    to stay unscoped; the "axn-dd-" prefix keeps it collision-free.
-->
<style>
.axn-dd-enter-active,
.axn-dd-leave-active {
    transition: opacity .16s, transform .16s;
    transform-origin: top;
}
.axn-dd-enter-from,
.axn-dd-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(.98);
}
.axn-dd-enter-to,
.axn-dd-leave-from {
    opacity: 1;
    transform: none;
}

@media (prefers-reduced-motion: reduce) {
    .axn-dd-enter-active,
    .axn-dd-leave-active {
        transition: none !important;
    }
}
</style>
