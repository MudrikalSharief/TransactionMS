<template>
    <nav class="depth-nav" aria-label="Breadcrumb">
        <div ref="barEl" class="dn-bar">
            <div ref="trailEl" class="dn-trail">
                <ol class="dn-list">
                    <template
                        v-for="(item, idx) in visibleLevels"
                        :key="item.key || idx"
                    >
                        <li
                            v-if="hiddenLevels.length && idx === 1"
                            class="dn-li dn-more-wrap"
                        >
                            <button
                                ref="moreBtn"
                                type="button"
                                class="dn-crumb dn-more"
                                aria-haspopup="menu"
                                :aria-expanded="menuOpen ? 'true' : 'false'"
                                :aria-label="`Show ${hiddenLevels.length} hidden levels`"
                                @click.stop="toggleMenu"
                            >
                                …
                            </button>
                            <div
                                v-if="menuOpen"
                                class="dn-menu"
                                role="menu"
                                aria-label="Hidden levels"
                            >
                                <small>Hidden levels</small>
                                <RouterLink
                                    v-for="(hidden, hi) in hiddenLevels"
                                    :key="hidden.key || hi"
                                    class="dn-menu-item"
                                    role="menuitem"
                                    :to="hidden.to || { path: '/' }"
                                    @click="menuOpen = false"
                                >
                                    <i>{{ hidden.depth }}</i>
                                    <span>{{ hidden.label }}</span>
                                </RouterLink>
                            </div>
                        </li>
                        <li
                            class="dn-li"
                            :class="{
                                'dn-deeper-wrap':
                                    idx === visibleLevels.length - 1,
                            }"
                        >
                            <template v-if="idx === visibleLevels.length - 1">
                                <button
                                    v-if="deeper.length"
                                    ref="deeperBtn"
                                    type="button"
                                    class="dn-now dn-now-btn"
                                    aria-haspopup="menu"
                                    :aria-expanded="deeperOpen ? 'true' : 'false'"
                                    :aria-label="deeperLabel"
                                    :title="item.label"
                                    aria-current="page"
                                    @click.stop="toggleDeeper"
                                >
                                    <span>{{ item.label }}</span>
                                    <v-icon size="16" aria-hidden="true"
                                        >mdi-chevron-down</v-icon
                                    >
                                </button>
                                <span
                                    v-else
                                    class="dn-now"
                                    :title="item.label"
                                    aria-current="page"
                                >
                                    <span>{{ item.label }}</span>
                                </span>
                                <div
                                    v-if="deeperOpen"
                                    class="dn-menu dn-deeper-menu"
                                    role="menu"
                                    :aria-label="deeperLabel"
                                >
                                    <small>{{ deeperLabel }}</small>
                                    <template
                                        v-for="(deeperItem, di) in deeper"
                                        :key="deeperItem.key || di"
                                    >
                                        <span
                                            v-if="deeperItem.current"
                                            class="dn-menu-item is-current"
                                            role="menuitem"
                                            aria-current="page"
                                        >
                                            <span>{{ deeperItem.label }}</span>
                                            <v-icon size="14" aria-hidden="true"
                                                >mdi-check</v-icon
                                            >
                                        </span>
                                        <RouterLink
                                            v-else-if="deeperItem.to"
                                            class="dn-menu-item"
                                            role="menuitem"
                                            :to="deeperItem.to"
                                            @click="deeperOpen = false"
                                        >
                                            <span>{{ deeperItem.label }}</span>
                                        </RouterLink>
                                        <span
                                            v-else
                                            class="dn-menu-item"
                                            >{{ deeperItem.label }}</span
                                        >
                                    </template>
                                </div>
                            </template>
                            <RouterLink
                                v-else-if="item.to"
                                class="dn-crumb"
                                :to="item.to"
                                :title="item.label"
                            >
                                <v-icon
                                    v-if="item.icon === 'home'"
                                    size="16"
                                    aria-hidden="true"
                                    >mdi-home-outline</v-icon
                                >
                                <span>{{ item.label }}</span>
                            </RouterLink>
                            <span
                                v-else
                                class="dn-crumb is-static"
                                :title="item.label"
                            >
                                <v-icon
                                    v-if="item.icon === 'home'"
                                    size="16"
                                    aria-hidden="true"
                                    >mdi-home-outline</v-icon
                                >
                                <span>{{ item.label }}</span>
                            </span>
                        </li>
                    </template>
                </ol>
            </div>

            <span class="dn-depth" :title="depthTitle">
                <span class="dn-dots" aria-hidden="true">
                    <i
                        v-for="(item, idx) in levels"
                        :key="item.key || idx"
                        :class="{ on: idx <= currentIndex }"
                    />
                </span>
                <span>{{ depthLabel }}</span>
            </span>

            <div class="dn-mini">
                <RouterLink
                    v-if="parentLevel?.to"
                    class="dn-up"
                    :to="parentLevel.to"
                    :aria-label="`Go up to ${parentLevel.label}`"
                >
                    <v-icon size="17" aria-hidden="true"
                        >mdi-chevron-left</v-icon
                    >
                    <span>{{ parentLevel.label }}</span>
                </RouterLink>
                <button
                    v-else-if="parentLevel"
                    type="button"
                    class="dn-up"
                    disabled
                >
                    <v-icon size="17" aria-hidden="true"
                        >mdi-chevron-left</v-icon
                    >
                    <span>{{ parentLevel.label }}</span>
                </button>
                <div v-if="deeper.length" class="dn-mini-now-wrap">
                    <button
                        ref="deeperMiniBtn"
                        type="button"
                        class="dn-mini-now dn-mini-now-btn"
                        aria-haspopup="menu"
                        :aria-expanded="deeperOpen ? 'true' : 'false'"
                        :aria-label="deeperLabel"
                        @click.stop="toggleDeeper"
                    >
                        <span>{{ currentLevel?.label }}</span>
                        <v-icon size="16" aria-hidden="true"
                            >mdi-chevron-down</v-icon
                        >
                    </button>
                    <div
                        v-if="deeperOpen"
                        class="dn-menu dn-deeper-menu is-mini"
                        role="menu"
                        :aria-label="deeperLabel"
                    >
                        <small>{{ deeperLabel }}</small>
                        <template
                            v-for="(deeperItem, di) in deeper"
                            :key="deeperItem.key || di"
                        >
                            <span
                                v-if="deeperItem.current"
                                class="dn-menu-item is-current"
                                role="menuitem"
                                aria-current="page"
                            >
                                <span>{{ deeperItem.label }}</span>
                                <v-icon size="14" aria-hidden="true"
                                    >mdi-check</v-icon
                                >
                            </span>
                            <RouterLink
                                v-else-if="deeperItem.to"
                                class="dn-menu-item"
                                role="menuitem"
                                :to="deeperItem.to"
                                @click="deeperOpen = false"
                            >
                                <span>{{ deeperItem.label }}</span>
                            </RouterLink>
                            <span v-else class="dn-menu-item">{{
                                deeperItem.label
                            }}</span>
                        </template>
                    </div>
                </div>
                <b v-else class="dn-mini-now">{{ currentLevel?.label }}</b>
            </div>
        </div>
    </nav>
</template>

<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";

const props = defineProps({
    // [{ label, to?, icon? }] — the last level is the current page.
    levels: { type: Array, default: () => [] },
    // Next-level pages shown when the current crumb is clicked.
    deeper: { type: Array, default: () => [] },
    deeperLabel: { type: String, default: "Go deeper" },
});

const route = useRoute();
const router = useRouter();
const barEl = ref(null);
const trailEl = ref(null);
const moreBtn = ref(null);
const deeperBtn = ref(null);
const deeperMiniBtn = ref(null);
const mode = ref(0);
const menuOpen = ref(false);
const deeperOpen = ref(false);

const currentIndex = computed(() => Math.max(0, props.levels.length - 1));
const currentLevel = computed(
    () => props.levels[currentIndex.value] || null,
);

// Mobile "up" skips parents that resolve to the current page (e.g. the
// type crumb on Workflows) and lands on the nearest distinct page.
const parentLevel = computed(() => {
    const list = props.levels || [];
    for (let i = list.length - 2; i >= 0; i -= 1) {
        const item = list[i];
        if (!item?.to) continue;
        if (router.resolve(item.to).fullPath !== route.fullPath) return item;
    }
    return list.length > 1 ? list[list.length - 2] : null;
});

// Full trail first; if it overflows, keep Home + the last two levels,
// then Home + the current level (same fallbacks as the reference).
const visibleLevels = computed(() => {
    const list = props.levels || [];
    const n = list.length;
    if (mode.value === 0 || n <= 3) return list;
    if (mode.value === 1) return [list[0], ...list.slice(-2)];
    return [list[0], list[n - 1]];
});

const hiddenLevels = computed(() => {
    const list = props.levels || [];
    const n = list.length;
    if (mode.value === 0 || n <= 3) return [];
    const slice =
        mode.value === 1 ? list.slice(1, -2) : list.slice(1, -1);
    return slice.map((item, idx) => ({ ...item, depth: idx + 1 }));
});

const depthLabel = computed(() =>
    currentIndex.value === 0 ? "Top level" : `Depth ${currentIndex.value}`,
);

const depthTitle = computed(() =>
    currentIndex.value === 0
        ? "You are at the top level"
        : `${currentIndex.value} click${currentIndex.value === 1 ? "" : "s"} from the top level`,
);

function fits() {
    const el = trailEl.value;
    if (!el) return true;
    return el.scrollWidth <= el.clientWidth + 1;
}

function measure() {
    if (props.levels.length <= 3) {
        mode.value = 0;
        return;
    }
    if (mode.value === 0 && !fits()) {
        mode.value = 1;
        nextTick(() => {
            if (!fits()) mode.value = 2;
        });
    } else if (mode.value === 1 && !fits()) {
        mode.value = 2;
    }
}

function resetMeasure() {
    mode.value = 0;
    menuOpen.value = false;
    deeperOpen.value = false;
    nextTick(measure);
}

function toggleMenu() {
    menuOpen.value = !menuOpen.value;
    if (menuOpen.value) deeperOpen.value = false;
}

function toggleDeeper() {
    deeperOpen.value = !deeperOpen.value;
    if (deeperOpen.value) menuOpen.value = false;
}

function focusDeeperTrigger() {
    const el = deeperBtn.value?.offsetParent
        ? deeperBtn.value
        : deeperMiniBtn.value;
    el?.focus?.();
}

function onDocumentClick(event) {
    if (menuOpen.value && !event.target.closest(".dn-more-wrap")) {
        menuOpen.value = false;
    }
    if (
        deeperOpen.value &&
        !event.target.closest(".dn-deeper-wrap") &&
        !event.target.closest(".dn-mini-now-wrap")
    ) {
        deeperOpen.value = false;
    }
}

function onKeydown(event) {
    if (event.key !== "Escape") return;
    if (menuOpen.value) {
        menuOpen.value = false;
        moreBtn.value?.focus?.();
    }
    if (deeperOpen.value) {
        deeperOpen.value = false;
        focusDeeperTrigger();
    }
}

let observer = null;

onMounted(() => {
    resetMeasure();
    document.addEventListener("click", onDocumentClick);
    document.addEventListener("keydown", onKeydown);
    if (window.ResizeObserver && barEl.value) {
        observer = new ResizeObserver(() => resetMeasure());
        observer.observe(barEl.value);
    }
});

onUnmounted(() => {
    observer?.disconnect();
    document.removeEventListener("click", onDocumentClick);
    document.removeEventListener("keydown", onKeydown);
});

watch(
    () => props.levels,
    () => {
        menuOpen.value = false;
        deeperOpen.value = false;
        resetMeasure();
    },
    { deep: true },
);

watch(
    () => props.deeper,
    () => {
        deeperOpen.value = false;
    },
    { deep: true },
);
</script>

<style scoped>
.depth-nav {
    --dn-panel: #fff;
    --dn-ink: #14213d;
    --dn-muted: #5b6780;
    --dn-line: #d5dbe8;
    --dn-field: #f4f6fb;
    --dn-hover: #f3f6fc;
    --dn-blue: #1d3fae;
    --dn-sep: #aab4cc;
    --dn-ring: rgba(29, 63, 174, 0.28);
    background: var(--dn-panel);
    color: var(--dn-ink);
    border: 1px solid var(--dn-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}

html.dark .depth-nav {
    --dn-panel: #161e36;
    --dn-ink: #eef2fb;
    --dn-muted: #9aa7c4;
    --dn-line: #2b3558;
    --dn-field: #1c2645;
    --dn-hover: #1d2745;
    --dn-blue: #6f8cff;
    --dn-sep: #5b6780;
    --dn-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.5);
}

.dn-bar {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 0 24px;
    min-height: 52px;
}

.dn-trail {
    flex: 1;
    min-width: 0;
    overflow: visible;
}

.dn-list {
    display: flex;
    align-items: center;
    flex-wrap: nowrap;
    list-style: none;
    margin: 0;
    padding: 0;
    width: max-content;
    max-width: none;
}

.dn-li {
    display: flex;
    align-items: center;
    flex: none;
    position: relative;
}

.dn-li + .dn-li::before {
    content: "";
    width: 7px;
    height: 7px;
    border-top: 2px solid var(--dn-sep);
    border-right: 2px solid var(--dn-sep);
    transform: rotate(45deg);
    margin: 0 12px 0 6px;
    flex: none;
}

.dn-crumb {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    height: 34px;
    padding: 0 10px;
    font: inherit;
    font-size: 13.5px;
    font-weight: 600;
    color: var(--dn-muted);
    max-width: 260px;
    border: 0;
    background: none;
    text-decoration: none;
    cursor: pointer;
    transition: background 0.15s, color 0.15s;
}

.dn-crumb span {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.dn-crumb:hover {
    background: var(--dn-hover);
    color: var(--dn-blue);
}

.dn-crumb .v-icon {
    flex: none;
}

.dn-crumb.is-static {
    cursor: default;
}

.dn-now {
    height: 34px;
    display: inline-flex;
    align-items: center;
    padding: 0 10px;
    font-size: 14px;
    font-weight: 800;
    color: var(--dn-ink);
    max-width: 380px;
    box-shadow: inset 0 -3px 0 var(--dn-blue);
}

.dn-now span {
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.dn-now-btn {
    gap: 6px;
    border: 0;
    background: none;
    font-family: inherit;
    cursor: pointer;
}

.dn-now-btn:hover {
    background: var(--dn-hover);
}

.dn-now-btn .v-icon {
    flex: none;
    color: var(--dn-muted);
    transition: transform 0.16s ease;
}

.dn-now-btn[aria-expanded="true"] .v-icon {
    transform: rotate(180deg);
}

.dn-more {
    width: 34px;
    justify-content: center;
    padding: 0;
    font-size: 16px;
    letter-spacing: 1px;
    font-weight: 800;
    cursor: pointer;
}

.dn-menu {
    position: absolute;
    left: 0;
    top: calc(100% + 6px);
    z-index: 20;
    min-width: 240px;
    max-width: 340px;
    background: var(--dn-panel);
    border: 1px solid var(--dn-line);
    box-shadow: 0 16px 36px -12px rgba(20, 33, 61, 0.4);
    padding: 6px;
}

html.dark .dn-menu {
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.6),
        0 2px 6px rgba(0, 0, 0, 0.3);
}

.dn-deeper-menu {
    left: auto;
    right: 0;
    min-width: 260px;
    max-width: 360px;
    max-height: min(60vh, 360px);
    overflow-y: auto;
}

.dn-deeper-menu.is-mini {
    top: calc(100% + 6px);
    min-width: min(260px, calc(100vw - 28px));
    max-width: calc(100vw - 28px);
}

.dn-menu small {
    display: block;
    padding: 6px 10px 4px;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--dn-muted);
}

.dn-menu-item {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    padding: 9px 10px;
    border: 0;
    background: none;
    text-align: left;
    font-size: 13.5px;
    font-weight: 600;
    color: var(--dn-ink);
    text-decoration: none;
}

.dn-menu-item:hover {
    background: var(--dn-hover);
    color: var(--dn-blue);
}

.dn-menu-item i {
    font-style: normal;
    font-size: 11px;
    font-weight: 800;
    color: var(--dn-muted);
    background: var(--dn-field);
    padding: 1px 7px;
    flex: none;
}

.dn-menu-item span {
    flex: 1;
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.dn-menu-item.is-current {
    color: var(--dn-blue);
    cursor: default;
}

.dn-menu-item.is-current:hover {
    background: none;
    color: var(--dn-blue);
}

.dn-menu-item.is-current .v-icon {
    flex: none;
    margin-left: auto;
    color: var(--dn-blue);
}

.dn-depth {
    flex: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: 12px;
    font-weight: 700;
    color: var(--dn-muted);
    background: var(--dn-field);
    padding: 5px 10px;
    cursor: default;
}

.dn-dots {
    display: flex;
    gap: 3px;
}

.dn-dots i {
    width: 6px;
    height: 12px;
    background: var(--dn-line);
}

.dn-dots i.on {
    background: var(--dn-blue);
}

.dn-mini {
    display: none;
    align-items: center;
    gap: 10px;
    min-width: 0;
    flex: 1;
}

.dn-up {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    height: 36px;
    padding: 0 12px 0 8px;
    border: 1.5px solid var(--dn-line);
    background: var(--dn-panel);
    color: var(--dn-ink);
    font: inherit;
    font-size: 13px;
    font-weight: 700;
    max-width: 55%;
    flex: none;
    text-decoration: none;
    cursor: pointer;
}

.dn-up span {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.dn-up:hover {
    background: var(--dn-hover);
}

.dn-up:disabled {
    opacity: 0.55;
    cursor: default;
}

.dn-mini-now {
    font-size: 14px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    min-width: 0;
    color: var(--dn-ink);
}

.dn-mini-now-wrap {
    position: relative;
    flex: 1;
    min-width: 0;
}

.dn-mini-now-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 0;
    border: 0;
    background: none;
    font-family: inherit;
    cursor: pointer;
    min-width: 0;
    max-width: 100%;
    overflow: visible;
}

.dn-mini-now-btn span {
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.dn-mini-now-btn .v-icon {
    flex: none;
    color: var(--dn-muted);
    transition: transform 0.16s ease;
}

.dn-mini-now-btn[aria-expanded="true"] .v-icon {
    transform: rotate(180deg);
}

.depth-nav a:focus-visible,
.depth-nav button:focus-visible {
    outline: 3px solid var(--dn-ring);
    outline-offset: 2px;
}

@media (max-width: 700px) {
    .dn-bar {
        padding: 8px 14px;
    }

    .dn-trail,
    .dn-depth {
        display: none;
    }

    .dn-mini {
        display: flex;
    }
}

@media (prefers-reduced-motion: reduce) {
    .dn-crumb {
        transition: none;
    }
}
</style>
