<template>
    <header class="wsh">
        <div class="wsh-badge" aria-hidden="true">
            <v-icon size="26">{{ icon }}</v-icon>
        </div>
        <div class="wsh-main">
            <h1 class="wsh-title">{{ title }}</h1>
            <p v-if="subtitle" class="wsh-sub">{{ subtitle }}</p>
        </div>
        <div class="wsh-tools">
            <div
                v-if="versionLabel"
                class="wsh-ver"
                role="status"
                :aria-label="`Version: ${versionLabel}`"
                :title="versionTitle"
            >
                <span
                    class="wsh-ver-dot"
                    :class="versionKind"
                    aria-hidden="true"
                />
                <span>{{ versionLabel }}</span>
            </div>
            <v-btn
                class="wsh-tool"
                variant="outlined"
                prepend-icon="mdi-arrow-left"
                @click="$emit('back')"
            >
                Back
            </v-btn>
            <v-btn
                v-if="dirty && !readOnly"
                class="wsh-tool wsh-danger"
                variant="outlined"
                prepend-icon="mdi-undo"
                v-tooltip="
                    'Drop all staged edits and show the last saved state'
                "
                @click="$emit('discard')"
            >
                Discard
            </v-btn>
            <v-btn
                v-if="!readOnly"
                class="wsh-save"
                variant="flat"
                prepend-icon="mdi-content-save-plus-outline"
                :disabled="saveDisabled"
                v-tooltip="
                    dirty
                        ? 'Persist staged edits: overwrite the draft or create a new version'
                        : 'No staged changes to save'
                "
                @click="$emit('save')"
            >
                Save version
                <span v-if="dirty" class="wsh-unsaved">UNSAVED</span>
            </v-btn>
        </div>
    </header>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
    icon: { type: String, default: "mdi-source-branch" },
    title: { type: String, required: true },
    subtitle: { type: String, default: "" },
    version: { type: [Number, String], default: null },
    status: { type: String, default: "" },
    isLive: { type: Boolean, default: false },
    dirty: { type: Boolean, default: false },
    saveDisabled: { type: Boolean, default: false },
    readOnly: { type: Boolean, default: false },
});

defineEmits(["back", "discard", "save"]);

const versionLabel = computed(() => {
    if (!props.status) return "";
    if (props.status === "draft") return "Draft";
    return props.isLive ? "Current version" : "Previous";
});

const versionKind = computed(() => {
    if (props.status === "draft") return "is-draft";
    return props.isLive ? "is-live" : "is-prev";
});

const versionTitle = computed(() =>
    props.version ? `Workflow version v${props.version}` : "",
);
</script>

<style scoped>
.wsh {
    --wsh-ink: rgb(var(--v-theme-on-surface));
    --wsh-muted: rgb(var(--v-theme-secondary));
    --wsh-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --wsh-hover: #f3f6fc;
    --wsh-blue: #005EED;
    --wsh-field: #f4f6fb;
    --wsh-ok: #1b7a3d;
    --wsh-amber: #b86e00;
    --wsh-err: rgb(var(--v-theme-error));
    --wsh-err-bg: rgba(var(--v-theme-error), 0.12);
    --wsh-ring: rgba(29, 63, 174, 0.28);
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
    margin-bottom: 18px;
    padding: 22px 28px;
    border: 1px solid var(--wsh-line);
    border-bottom: 3px solid var(--wsh-blue);
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}

html.dark .wsh {
    --wsh-hover: #1d2745;
    --wsh-blue: #6f8cff;
    --wsh-field: #1c2645;
    --wsh-ok: #3fbf6f;
    --wsh-amber: #ffbf47;
    --wsh-err-bg: #4a1f22;
    --wsh-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}

.wsh-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--wsh-blue);
    color: #fff;
}

.wsh-main {
    flex: 1 1 320px;
    min-width: 0;
}

.wsh-title {
    margin: 0;
    color: var(--wsh-ink);
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}

.wsh-sub {
    margin: 5px 0 0;
    color: var(--wsh-muted);
    font-size: 13.5px;
    font-weight: 500;
    line-height: 1.3;
}

.wsh-tools {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin-left: auto;
}

.wsh-ver {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    height: 42px;
    padding: 0 14px;
    border: 1.5px solid var(--wsh-line);
    background: rgb(var(--v-theme-surface));
    color: var(--wsh-ink);
    font-size: 13.5px;
    font-weight: 700;
    white-space: nowrap;
}

.wsh-ver-dot {
    display: block;
    width: 8px;
    height: 8px;
    flex: none;
    background: var(--wsh-ok);
}

.wsh-ver-dot.is-draft {
    background: var(--wsh-amber);
}

.wsh-ver-dot.is-prev {
    background: var(--wsh-muted);
}

.wsh-tool,
.wsh-save {
    height: 42px !important;
    padding: 0 16px !important;
    border-radius: 0 !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    letter-spacing: 0 !important;
    text-transform: none !important;
    box-shadow: none !important;
}

.wsh-tool {
    border: 1.5px solid var(--wsh-line) !important;
    background: rgb(var(--v-theme-surface)) !important;
    color: var(--wsh-ink) !important;
}

.wsh-tool:hover {
    background: var(--wsh-hover) !important;
}

.wsh-danger {
    border-color: var(--wsh-err-bg) !important;
    color: var(--wsh-err) !important;
}

.wsh-danger:hover {
    background: var(--wsh-err-bg) !important;
}

.wsh-save {
    border: 1.5px solid transparent !important;
    background: var(--wsh-blue) !important;
    color: #fff !important;
}

.wsh-save.v-btn--disabled {
    background: var(--wsh-field) !important;
    color: var(--wsh-muted) !important;
}

.wsh-unsaved {
    display: inline-flex;
    margin-left: 8px;
    padding: 3px 7px;
    background: #fff1d6;
    color: #704000;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.04em;
}

html.dark .wsh-unsaved {
    background: #4a3510;
    color: #ffdf85;
}

.wsh :deep(.v-btn:focus-visible) {
    outline: 3px solid var(--wsh-ring);
    outline-offset: 2px;
}

@media (max-width: 960px) {
    .wsh-title {
        font-size: 22px;
    }

    .wsh-tools {
        width: 100%;
        margin-left: 0;
    }
}

@media (max-width: 720px) {
    .wsh {
        gap: 12px;
        padding: 18px 16px;
    }

    .wsh-badge {
        width: 46px;
        height: 46px;
    }

    .wsh-title {
        font-size: 20px;
    }

    .wsh-sub {
        font-size: 12.5px;
    }

    .wsh-main {
        flex: 1 1 200px;
    }

    .wsh-tools {
        gap: 8px;
    }

    .wsh-ver {
        flex: 1 1 auto;
        justify-content: center;
    }

    .wsh-tool,
    .wsh-save {
        flex: 1 1 auto;
    }
}
</style>
