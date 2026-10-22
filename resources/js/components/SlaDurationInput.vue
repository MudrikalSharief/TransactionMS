<template>
    <div class="sla-duration">
        <div class="sla-card">
            <span :id="quickLabelId" class="sla-label">Quick set</span>
            <div class="sla-chips" role="group" :aria-labelledby="quickLabelId">
                <button
                    v-for="preset in PRESETS"
                    :key="preset.label"
                    type="button"
                    class="sla-chip"
                    :aria-pressed="isPresetActive(preset)"
                    @click="applyPreset(preset)"
                >
                    {{ preset.label }}
                </button>
                <button
                    type="button"
                    class="sla-chip"
                    :aria-pressed="custom"
                    :aria-expanded="custom"
                    :aria-controls="fieldsId"
                    @click="enableCustom"
                >
                    Custom
                </button>
            </div>

            <div v-if="custom" :id="fieldsId" class="sla-fields">
                <div class="sla-field">
                    <label :for="daysId">Days</label>
                    <input
                        ref="daysInput"
                        :id="daysId"
                        class="sla-input"
                        type="number"
                        min="0"
                        :max="maxDays"
                        step="1"
                        inputmode="numeric"
                        autocomplete="off"
                        placeholder="0"
                        :value="days || ''"
                        :aria-invalid="shownError ? 'true' : undefined"
                        :aria-describedby="shownError ? errorId : summaryId"
                        @input="onFieldInput('days', $event)"
                        @blur="normalizeField('days', $event)"
                    />
                </div>
                <div
                    class="sla-field"
                    :class="{ 'is-disabled': extrasDisabled }"
                >
                    <label :for="hoursId">Hours</label>
                    <input
                        :id="hoursId"
                        class="sla-input"
                        type="number"
                        min="0"
                        max="23"
                        step="1"
                        inputmode="numeric"
                        autocomplete="off"
                        :placeholder="extrasDisabled ? '' : '0'"
                        :value="hours || ''"
                        :disabled="extrasDisabled"
                        :aria-invalid="shownError ? 'true' : undefined"
                        :aria-describedby="shownError ? errorId : summaryId"
                        @input="onFieldInput('hours', $event)"
                        @blur="normalizeField('hours', $event)"
                    />
                </div>
                <div
                    class="sla-field"
                    :class="{ 'is-disabled': extrasDisabled }"
                >
                    <label :for="minutesId">Minutes</label>
                    <input
                        :id="minutesId"
                        class="sla-input"
                        type="number"
                        min="0"
                        max="59"
                        step="1"
                        inputmode="numeric"
                        autocomplete="off"
                        :placeholder="extrasDisabled ? '' : '0'"
                        :value="minutes || ''"
                        :disabled="extrasDisabled"
                        :aria-invalid="shownError ? 'true' : undefined"
                        :aria-describedby="shownError ? errorId : summaryId"
                        @input="onFieldInput('minutes', $event)"
                        @blur="normalizeField('minutes', $event)"
                    />
                </div>
            </div>

            <p :id="summaryId" class="sla-summary" aria-live="polite">
                <template v-if="total > 0"
                    >Due within <b>{{ human }}</b></template
                >
                <template v-else><b>No time limit</b></template>
            </p>
            <p v-if="autoClearNotice" class="sla-notice" role="status">
                <v-icon size="14" color="warning">mdi-alert-outline</v-icon>
                <span>Max SLA is {{ maxDays }} days.</span>
            </p>
            <p v-if="shownError" :id="errorId" class="sla-error" role="alert">
                {{ shownError }}
            </p>
        </div>
    </div>
</template>

<script setup>
import { computed, nextTick, ref, useId, watch } from "vue";

const props = defineProps({
    modelValue: { type: Number, default: 0 },
    maxDays: { type: Number, default: 30 },
    maxTotal: { type: Number, default: 0 },
    error: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const PRESETS = [
    { label: "No limit", days: 0, hours: 0, minutes: 0, total: 0 },
    { label: "30 min", days: 0, hours: 0, minutes: 30, total: 30 },
    { label: "2 hours", days: 0, hours: 2, minutes: 0, total: 120 },
    { label: "8 hours", days: 0, hours: 8, minutes: 0, total: 480 },
    { label: "1 day", days: 1, hours: 0, minutes: 0, total: 1440 },
    { label: "3 days", days: 3, hours: 0, minutes: 0, total: 4320 },
    { label: "7 days", days: 7, hours: 0, minutes: 0, total: 10080 },
];

const uid = useId();
const quickLabelId = `sla-quick-${uid}`;
const fieldsId = `sla-fields-${uid}`;
const summaryId = `sla-summary-${uid}`;
const errorId = `sla-error-${uid}`;
const daysId = `sla-days-${uid}`;
const hoursId = `sla-hours-${uid}`;
const minutesId = `sla-minutes-${uid}`;

const days = ref(0);
const hours = ref(0);
const minutes = ref(0);
const custom = ref(false);
const daysInput = ref(null);
const autoClearNotice = ref(false);

// The parent prop is the source of truth, but typing emits back immediately.
// Ignore that echo so a custom value that happens to match a preset does not
// close the custom fields while the user is still editing.
let internalUpdate = false;

const total = computed(
    () => days.value * 1440 + hours.value * 60 + minutes.value,
);
const totalLimit = computed(() => {
    const explicit = Number(props.maxTotal);
    return explicit > 0 ? explicit : Math.max(1, props.maxDays) * 1440;
});
const limitError = computed(() =>
    total.value > totalLimit.value ? `Max SLA is ${props.maxDays} days.` : "",
);
const shownError = computed(() => props.error || limitError.value);
const extrasDisabled = computed(() => days.value >= props.maxDays);

const human = computed(() => {
    const parts = [];
    if (days.value) parts.push(plural(days.value, "day"));
    if (hours.value) parts.push(plural(hours.value, "hour"));
    if (minutes.value) parts.push(plural(minutes.value, "minute"));
    return parts.join(" ");
});

function plural(value, word) {
    return `${value} ${word}${value === 1 ? "" : "s"}`;
}

function applyTotal(raw) {
    const original = Math.max(0, Math.trunc(Number(raw) || 0));
    const originalDays = Math.floor(original / 1440);
    let value = original;

    // At 30 days there is no room for extra hours/minutes. If the incoming
    // value had them, clear them and leave a non-blocking notice explaining
    // why the two fields are now disabled.
    autoClearNotice.value =
        originalDays > props.maxDays ||
        (originalDays === props.maxDays && original % 1440 > 0);

    if (originalDays >= props.maxDays) {
        value = props.maxDays * 1440;
        days.value = props.maxDays;
        hours.value = 0;
        minutes.value = 0;
    } else {
        days.value = originalDays;
        hours.value = Math.floor((value % 1440) / 60);
        minutes.value = value % 60;
    }

    custom.value = !PRESETS.some((preset) => preset.total === value);
    if (value !== original) emitTotal();
}

function emitTotal() {
    internalUpdate = true;
    emit("update:modelValue", total.value);
    nextTick(() => {
        internalUpdate = false;
    });
}

function isPresetActive(preset) {
    return !custom.value && total.value === preset.total;
}

function applyPreset(preset) {
    days.value = preset.days;
    hours.value = preset.hours;
    minutes.value = preset.minutes;
    custom.value = false;
    autoClearNotice.value = false;
    emitTotal();
}

function enableCustom() {
    custom.value = true;
    nextTick(() => daysInput.value?.focus());
}

function setField(field, value) {
    if (field === "days") days.value = value;
    else if (field === "hours") hours.value = value;
    else minutes.value = value;
}

function maxFor(field) {
    if (field === "days") return props.maxDays;
    return field === "hours" ? 23 : 59;
}

function onFieldInput(field, event) {
    if (field !== "days" && extrasDisabled.value) return;

    const parsed = Number(String(event.target.value ?? "").trim());
    let value = Number.isFinite(parsed) ? Math.floor(parsed) : 0;
    value = Math.max(0, value);

    if (field === "days") {
        const hadExtras = hours.value > 0 || minutes.value > 0;
        const overDays = value > props.maxDays;
        const atMax = Math.min(value, props.maxDays) === props.maxDays;
        autoClearNotice.value = overDays || (atMax && hadExtras);
        value = Math.min(props.maxDays, value);
    } else {
        value = Math.min(maxFor(field), value);
    }

    // Keep the DOM in sync when a typed value was clamped (31 -> 30, etc.).
    // Zero is shown as an empty box, matching the design.
    const display = value ? String(value) : "";
    if (event.target.value !== display) event.target.value = display;

    setField(field, value);
    if (field === "days" && value >= props.maxDays) {
        hours.value = 0;
        minutes.value = 0;
    }
    custom.value = true;
    emitTotal();
}

function normalizeField(field, event) {
    const value =
        field === "days"
            ? days.value
            : field === "hours"
              ? hours.value
              : minutes.value;
    event.target.value = value ? String(value) : "";
}

watch(
    () => props.modelValue,
    (value) => {
        if (internalUpdate) return;
        applyTotal(value);
    },
    { immediate: true },
);
</script>

<style scoped>
.sla-duration {
    --sla-ring: rgba(var(--v-theme-primary), 0.24);
}

.sla-duration * {
    box-sizing: border-box;
}

.sla-card {
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 16px;
    padding: 16px;
}

.sla-label {
    display: block;
    margin: 0 0 10px;
    font-size: 14px;
    font-weight: 600;
}

.sla-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 16px;
}

.sla-chip {
    height: 36px;
    padding: 0 15px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 99px;
    background: none;
    color: inherit;
    font: inherit;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        border-color 0.15s,
        color 0.15s;
}

.sla-chip:hover {
    background: rgba(var(--v-theme-primary), 0.06);
}

.sla-chip:focus-visible {
    outline: 3px solid var(--sla-ring);
    outline-offset: 2px;
}

.sla-chip[aria-pressed="true"] {
    background: rgb(var(--v-theme-primary));
    border-color: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
}

.sla-fields {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
    margin-bottom: 14px;
}

.sla-field label {
    display: block;
    margin-bottom: 6px;
    font-size: 13px;
    font-weight: 600;
}

.sla-field.is-disabled label {
    opacity: 0.6;
}

.sla-input {
    width: 100%;
    height: 48px;
    padding: 0 8px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
    background: #f4f6fb;
    color: inherit;
    font: inherit;
    font-size: 16px;
    font-weight: 700;
    text-align: center;
    transition:
        border-color 0.15s,
        box-shadow 0.15s,
        background 0.15s;
}

.sla-input::placeholder {
    color: #7b869e;
    font-weight: 500;
}

.sla-input:hover {
    border-color: #aab4cc;
}

.sla-input:focus {
    outline: none;
    border-color: rgb(var(--v-theme-primary));
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px var(--sla-ring);
}

.sla-input:disabled {
    cursor: not-allowed;
    opacity: 0.6;
    background: rgba(var(--v-theme-on-surface), 0.04);
}

.sla-input:disabled:hover {
    border-color: rgba(var(--v-border-color), var(--v-border-opacity));
}

/* Keep the duration boxes clean; keyboard arrows still increment them. */
.sla-input::-webkit-outer-spin-button,
.sla-input::-webkit-inner-spin-button {
    margin: 0;
    -webkit-appearance: none;
}
.sla-input[type="number"] {
    -moz-appearance: textfield;
    appearance: textfield;
}

.sla-summary {
    margin: 0;
    font-size: 13.5px;
    color: rgb(var(--v-theme-secondary));
}

.sla-summary b {
    color: rgb(var(--v-theme-primary));
}

.sla-notice {
    display: flex;
    align-items: flex-start;
    gap: 6px;
    margin: 10px 0 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 12.5px;
    font-weight: 600;
    line-height: 1.4;
}

.sla-notice :deep(.v-icon) {
    flex: none;
    margin-top: 1px;
}

.sla-error {
    margin: 10px 0 0;
    color: rgb(var(--v-theme-error));
    font-size: 12.5px;
    font-weight: 600;
    line-height: 1.4;
}

html.dark .sla-card,
html.dark .sla-chip,
html.dark .sla-input {
    border-color: rgba(255, 255, 255, 0.16);
}

html.dark .sla-input {
    background: #232b45;
}

html.dark .sla-input:disabled {
    background: rgba(255, 255, 255, 0.06);
}

html.dark .sla-input:disabled:hover {
    border-color: rgba(255, 255, 255, 0.16);
}

html.dark .sla-input:hover {
    border-color: rgba(255, 255, 255, 0.28);
}

html.dark .sla-input:focus {
    background: rgb(var(--v-theme-surface));
    border-color: rgb(var(--v-theme-primary));
}

html.dark .sla-input::placeholder {
    color: rgba(255, 255, 255, 0.42);
}

@media (max-width: 420px) {
    .sla-card {
        padding: 14px;
    }
    .sla-fields {
        gap: 8px;
    }
    .sla-chip {
        height: 34px;
        padding: 0 13px;
        font-size: 13px;
    }
    .sla-input {
        padding: 0 4px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .sla-chip,
    .sla-input {
        transition: none;
    }
}
</style>
