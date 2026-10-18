<template>
    <v-menu
        v-model="open"
        :disabled="disabled"
        :close-on-content-click="false"
        location="bottom start"
        :offset="8"
        retain-focus
        transition="ad-dd"
        :width="menuWidth || undefined"
        :min-width="menuWidth || undefined"
        @update:model-value="onMenuToggle"
    >
        <template #activator="{ props: activatorProps }">
            <button
                ref="triggerRef"
                v-bind="activatorProps"
                type="button"
                class="ad-trigger"
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
                <span class="ad-tile ad-tile-lg" :class="toneClass(selected?.kind)">
                    <v-icon size="22">{{ selected ? kindIcon(selected.kind) : 'mdi-gesture-tap' }}</v-icon>
                </span>
                <span class="ad-txt">
                    <span class="ad-cap">{{ label }}</span>
                    <span class="ad-val" :class="{ 'is-muted': !selected }">{{ selected ? selected.verb : placeholder }}</span>
                </span>
                <v-icon class="ad-chev" :class="{ 'is-open': open }" size="20">mdi-chevron-down</v-icon>
            </button>
        </template>

        <div :id="menuId" class="ad-menu" role="listbox" aria-label="Actions">
            <div
                v-for="(item, i) in items"
                :id="optionId(i)"
                :key="item.value"
                class="ad-opt"
                :class="{ 'is-active': act === i, 'is-selected': isSelected(item) }"
                role="option"
                :aria-selected="isSelected(item) ? 'true' : 'false'"
                @click="choose(i)"
                @mouseenter="act = i"
            >
                <span class="ad-tile" :class="toneClass(item.kind)">
                    <v-icon size="22">{{ kindIcon(item.kind) }}</v-icon>
                </span>
                <span class="ad-txt">
                    <span class="ad-t" :class="{ 'is-danger': item.kind === 'clear' }">{{ item.verb }}</span>
                    <span v-if="item.detail" class="ad-d">{{ item.detail }}</span>
                </span>
                <v-icon v-if="isSelected(item)" class="ad-chk" size="20">mdi-check</v-icon>
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
const menuId = `ad-menu-${uid}`;
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
.ad-trigger {
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
.ad-trigger:hover {
    border-color: #aab4cc;
}
.ad-trigger:focus-visible,
.ad-trigger.is-open {
    outline: none;
    border-color: #1d3fae;
    box-shadow: 0 0 0 4px rgba(29, 63, 174, 0.28);
}
.ad-trigger:disabled {
    opacity: 0.6;
    cursor: default;
}
.ad-trigger:disabled:hover {
    border-color: #d9dfec;
}

/* ---- tiles ---- */
.ad-tile {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    display: grid;
    place-items: center;
    flex: none;
    transition: background .2s, color .2s;
}
.ad-opt .ad-tile {
    width: 40px;
    height: 40px;
}
.tone-blue { background: #e8eeff; color: #1d3fae; }
.tone-amber { background: #fff1d6; color: #b86e00; }
.tone-red { background: #fde8e8; color: #c62828; }
.tone-purple { background: #ede9fe; color: #6d28d9; }
.tone-neutral { background: #eef1f6; color: #5b6780; }

/* ---- trigger text ---- */
.ad-txt {
    flex: 1;
    min-width: 0;
}
.ad-cap {
    display: block;
    font-size: 12px;
    font-weight: 600;
    color: #5b6780;
    margin-bottom: 2px;
}
.ad-val {
    display: block;
    font-size: 16px;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.ad-val.is-muted {
    color: #5b6780;
    font-weight: 600;
}
.ad-chev {
    color: #5b6780;
    flex: none;
    transition: transform .2s;
}
.ad-chev.is-open {
    transform: rotate(180deg);
}

/* ---- menu ---- */
.ad-menu {
    margin: 0;
    padding: 8px;
    background: #fff;
    border: 1px solid #d9dfec;
    border-radius: 18px;
    box-shadow: 0 18px 40px -12px rgba(20, 33, 61, 0.28), 0 2px 6px rgba(20, 33, 61, 0.08);
}
.ad-opt {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 10px;
    border-radius: 12px;
    cursor: pointer;
    position: relative;
}
.ad-opt.is-active {
    background: #f3f6fc;
}
.ad-t {
    display: block;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.25;
}
.ad-t.is-danger {
    color: #c62828;
}
.ad-d {
    display: block;
    font-size: 13px;
    color: #5b6780;
    margin-top: 2px;
}
.ad-chk {
    margin-left: auto;
    color: #1d3fae;
    flex: none;
}
.ad-opt.is-selected::before {
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
html.dark .ad-trigger {
    background: #161e36;
    border-color: #2b3558;
    color: #eef2fb;
}
html.dark .ad-trigger:hover {
    border-color: #3a4670;
}
html.dark .ad-trigger:focus-visible,
html.dark .ad-trigger.is-open {
    border-color: #8aa1ff;
    box-shadow: 0 0 0 4px rgba(138, 161, 255, 0.35);
}
html.dark .ad-trigger:disabled:hover {
    border-color: #2b3558;
}
html.dark .ad-cap,
html.dark .ad-chev,
html.dark .ad-d,
html.dark .ad-val.is-muted {
    color: #9aa7c4;
}
html.dark .tone-blue { background: #25306a; color: #8aa1ff; }
html.dark .tone-amber { background: #4a3510; color: #ffbf47; }
html.dark .tone-red { background: #4a1f22; color: #ff8a80; }
html.dark .tone-purple { background: #3b2f63; color: #c4b5fd; }
html.dark .tone-neutral { background: #26304a; color: #9aa7c4; }
html.dark .ad-menu {
    background: #161e36;
    border-color: #2b3558;
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.6), 0 2px 6px rgba(0, 0, 0, 0.3);
}
html.dark .ad-opt.is-active {
    background: #1d2745;
}
html.dark .ad-t {
    color: #eef2fb;
}
html.dark .ad-t.is-danger {
    color: #ff8a80;
}
html.dark .ad-chk {
    color: #8aa1ff;
}
html.dark .ad-opt.is-selected::before {
    background: #8aa1ff;
}

@media (prefers-reduced-motion: reduce) {
    .ad-trigger,
    .ad-chev,
    .ad-tile {
        transition: none !important;
    }
}
</style>

<!--
    Menu enter/leave for transition="ad-dd" (mockup's translateY(-6px)
    scale(.98) at .16s, top origin). These classes land on Vuetify's own
    overlay content element, which carries no scope id, so this block has
    to stay unscoped; the "ad-dd-" prefix keeps it collision-free.
-->
<style>
.ad-dd-enter-active,
.ad-dd-leave-active {
    transition: opacity .16s, transform .16s;
    transform-origin: top;
}
.ad-dd-enter-from,
.ad-dd-leave-to {
    opacity: 0;
    transform: translateY(-6px) scale(.98);
}
.ad-dd-enter-to,
.ad-dd-leave-from {
    opacity: 1;
    transform: none;
}

@media (prefers-reduced-motion: reduce) {
    .ad-dd-enter-active,
    .ad-dd-leave-active {
        transition: none !important;
    }
}
</style>
