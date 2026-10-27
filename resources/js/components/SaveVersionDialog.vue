<template>
    <v-dialog
        v-model="open"
        max-width="620"
        scrollable
        content-class="sv-dialog"
        attach="body"
    >
        <v-card rounded="xl" class="sv-card" style="overflow: hidden">
            <v-card-title class="stp-hd">
                <v-avatar color="primary" variant="tonal" rounded="lg" size="44" class="stp-badge">
                    <v-icon>mdi-content-save-outline</v-icon>
                </v-avatar>
                <div class="stp-hd-t">
                    <div class="stp-title">Save version</div>
                    <div class="stp-sub">Review your staged changes and choose how to save them.</div>
                </div>
                <v-btn
                    icon="mdi-close"
                    variant="text"
                    size="small"
                    class="stp-x"
                    aria-label="Close save dialog"
                    :disabled="saving"
                    @click="close"
                />
            </v-card-title>
            <v-divider />
            <v-card-text class="stp-bd">
                <v-alert
                    v-if="saveError"
                    type="error"
                    variant="tonal"
                    density="compact"
                    closable
                    class="mb-4"
                    @click:close="saveError = ''"
                >
                    {{ saveError }}
                </v-alert>

                <div class="sv-sum">
                    <div class="sv-sum-copy">
                        <template v-if="stagedChangeTotal">
                            Saving applies the staged changes below in one atomic step.
                            Nothing is written until you confirm.
                        </template>
                        <template v-else>
                            No staged content changes. This save will only update the
                            version details.
                        </template>
                    </div>
                    <div class="sv-chips">
                        <v-menu
                            v-for="chip in stagedCounts"
                            :key="chip.key"
                            open-on-hover
                            open-on-focus
                            :open-delay="120"
                            :close-delay="180"
                            :close-on-content-click="false"
                            location="bottom"
                            offset="8"
                        >
                            <template #activator="{ props: menuProps }">
                                <button
                                    v-bind="menuProps"
                                    type="button"
                                    class="sv-chip"
                                    :class="{ 'is-zero': !chip.count }"
                                    :aria-label="`${chip.label}: ${chip.count} change${chip.count === 1 ? '' : 's'}. Show details.`"
                                >
                                    <span class="sv-chip-n">{{ chip.count }}</span>
                                    <span>{{ chip.label }}</span>
                                </button>
                            </template>
                            <v-card class="sv-pop" rounded="lg" elevation="8">
                                <div class="sv-pop-h">
                                    <span>{{ chip.label }}</span>
                                    <span class="sv-pop-count">
                                        {{ chip.count }} change{{ chip.count === 1 ? "" : "s" }}
                                    </span>
                                </div>
                                <div v-if="chip.items.length" class="sv-pop-list">
                                    <div
                                        v-for="(item, idx) in chip.items"
                                        :key="`${chip.key}-${idx}`"
                                        class="sv-pop-item"
                                    >
                                        <span
                                            class="sv-pop-dot"
                                            :class="`is-${item.kind}`"
                                        ></span>
                                        <div class="sv-pop-body">
                                            <div class="sv-pop-label">
                                                <span class="sv-pop-kind">
                                                    {{ changeKindLabel(item.kind) }}
                                                </span>
                                                {{ item.label }}
                                            </div>
                                            <div
                                                v-if="item.changes.length"
                                                class="sv-pop-changes"
                                            >
                                                <div
                                                    v-for="(change, ci) in item.changes"
                                                    :key="`${change.field}-${ci}`"
                                                    class="sv-pop-change"
                                                >
                                                    <span class="sv-pop-field">
                                                        {{ change.label }}:
                                                    </span>
                                                    <span
                                                        class="sv-pop-val"
                                                        :title="
                                                            changeValueTitle(
                                                                change,
                                                                change.from,
                                                            )
                                                        "
                                                    >
                                                        {{
                                                            formatChangeValue(
                                                                change,
                                                                change.from,
                                                            )
                                                        }}
                                                    </span>
                                                    <span class="sv-pop-arrow">→</span>
                                                    <span
                                                        class="sv-pop-val"
                                                        :title="
                                                            changeValueTitle(
                                                                change,
                                                                change.to,
                                                            )
                                                        "
                                                    >
                                                        {{
                                                            formatChangeValue(
                                                                change,
                                                                change.to,
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div v-else class="sv-pop-empty">
                                    No changes in this group.
                                </div>
                            </v-card>
                        </v-menu>
                    </div>
                </div>

                <section class="stp-sec sv-sec">
                    <h3 class="stp-sec-t">How to save</h3>
                    <div class="sv-opts">
                        <label class="sv-opt" :class="{ 'is-on': saveMode === 'overwrite' }">
                            <input
                                v-model="saveMode"
                                class="sv-opt-input"
                                type="radio"
                                name="sv-save-mode"
                                value="overwrite"
                            />
                            <span class="sv-radio" aria-hidden="true"></span>
                            <span class="sv-opt-body">
                                <span class="sv-opt-title">
                                    Update current version
                                    <span class="sv-tag sv-tag-draft">Same version</span>
                                </span>
                                <span class="sv-opt-desc">
                                    Applies the staged changes to the current version.
                                    The version number stays the same.
                                </span>
                            </span>
                        </label>
                        <label class="sv-opt" :class="{ 'is-on': saveMode === 'create-new' }">
                            <input
                                v-model="saveMode"
                                class="sv-opt-input"
                                type="radio"
                                name="sv-save-mode"
                                value="create-new"
                            />
                            <span class="sv-radio" aria-hidden="true"></span>
                            <span class="sv-opt-body">
                                <span class="sv-opt-title">
                                    Create new version
                                    <span class="sv-tag sv-tag-live">Published live</span>
                                </span>
                                <span class="sv-opt-desc">
                                    Publishes a new version immediately. The old version
                                    is kept.
                                </span>
                            </span>
                        </label>
                    </div>
                    <div v-if="saveMode === 'create-new'" class="sv-warn">
                        <v-icon size="18" color="warning">mdi-alert-outline</v-icon>
                        <span>
                            This goes live immediately for everyone who uses this
                            workflow.
                        </span>
                    </div>
                </section>

                <section class="stp-sec sv-sec">
                    <h3 class="stp-sec-t">Details</h3>
                    <div class="stp-f">
                        <label class="stp-lb" for="sv-name">
                            Version name
                            <span class="stp-opt">
                                {{ saveMode === "create-new" ? "(required)" : "(optional rename)" }}
                            </span>
                        </label>
                        <v-text-field
                            id="sv-name"
                            v-model="saveName"
                            placeholder="e.g. Holiday rush flow"
                            maxlength="200"
                            counter
                            variant="outlined"
                            density="comfortable"
                            class="stp-in"
                        />
                    </div>
                    <div class="stp-f" style="margin-bottom: 0">
                        <label class="stp-lb" for="sv-notes">
                            Notes
                            <span class="stp-opt">(optional)</span>
                        </label>
                        <v-textarea
                            id="sv-notes"
                            v-model="saveNotes"
                            rows="3"
                            placeholder="Why is this version changing?"
                            hint="Saved with this version so others can see why it changed."
                            persistent-hint
                            variant="outlined"
                            density="comfortable"
                            class="stp-in"
                        />
                    </div>
                </section>
            </v-card-text>
            <v-divider />
            <v-card-actions class="stp-ft justify-end">
                <v-btn
                    variant="outlined"
                    rounded="lg"
                    class="stp-b"
                    :disabled="saving"
                    @click="close"
                >
                    Cancel
                </v-btn>
                <v-btn
                    color="primary"
                    rounded="lg"
                    class="stp-b stp-b-pri"
                    :loading="saving"
                    :disabled="saveMode === 'create-new' && !saveName.trim()"
                    @click="confirmSave"
                >
                    {{ saveSubmitLabel }}
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from "vue";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";

const props = defineProps({
    modelValue: { type: Boolean, default: false },
    typeId: { type: [Number, null], default: null },
    defId: { type: [Number, null], default: null },
    defaultName: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue", "saved"]);

const staging = useWorkflowStaging();

const open = computed({
    get: () => props.modelValue,
    set: (value) => emit("update:modelValue", value),
});

const saveMode = ref("overwrite");
const saveName = ref("");
const saveNotes = ref("");
const saving = ref(false);
const saveError = ref("");

const bucket = computed(() =>
    props.typeId != null ? staging.buckets.get(String(props.typeId)) : null,
);

const stagedChangeDetails = computed(() =>
    props.typeId != null
        ? staging.changedDetails(props.typeId)
        : { steps: [], routes: [], requirements: [], checklists: [], fields: [], stepData: [] },
);

const stagedCounts = computed(() => {
    const details = stagedChangeDetails.value;
    return [
        { key: "steps", label: "Steps", count: details.steps.length, items: details.steps },
        { key: "routes", label: "Routes", count: details.routes.length, items: details.routes },
        {
            key: "stepData",
            label: "Step data",
            count: details.stepData.length,
            items: details.stepData,
        },
        {
            key: "requirements",
            label: "Requirements",
            count: details.requirements.length,
            items: details.requirements,
        },
        {
            key: "checklists",
            label: "Checklists",
            count: details.checklists.length,
            items: details.checklists,
        },
        {
            key: "fields",
            label: "Field assignments",
            count: details.fields.length,
            items: details.fields,
        },
    ];
});

const stagedChangeTotal = computed(() =>
    stagedCounts.value.reduce((total, chip) => total + chip.count, 0),
);

const stepNameById = computed(() => {
    const map = new Map();
    for (const [key, label] of Object.entries(bucket.value?.stepLabels || {})) {
        if (key && label) map.set(String(key), label);
    }
    for (const step of [
        ...(bucket.value?.sourceSteps || []),
        ...(bucket.value?.steps || []),
    ]) {
        const label =
            step?.name || step?.code || (step?.id != null ? `Step #${step.id}` : "");
        if (!label) continue;
        if (step.id != null) map.set(String(step.id), label);
        if (step.client_id != null) map.set(String(step.client_id), label);
    }
    return map;
});

const requirementNameById = computed(() => {
    const map = new Map();
    const b = bucket.value;
    for (const def of [...(b?.sourceReqDefs || []), ...(b?.reqDefs || [])]) {
        const label = def?.name || def?.code;
        if (!label) continue;
        if (def.id != null) map.set(String(def.id), label);
        if (def.client_id != null) map.set(String(def.client_id), label);
    }
    const linkedRows = [
        ...Object.values(b?.sourceBindings || {}),
        ...Object.values(b?.bindings || {}),
        ...Object.values(b?.sourceChecklist || {}),
        ...Object.values(b?.checklist || {}),
    ].flat();
    for (const row of linkedRows) {
        const key =
            row?.requirement_definition_id ??
            row?.req_key ??
            row?.requirement_key;
        const label = row?.name || row?.code;
        if (key == null || !label || map.has(String(key))) continue;
        map.set(String(key), label);
    }
    return map;
});

function changeKindLabel(kind) {
    return kind === "added" ? "Added" : kind === "removed" ? "Removed" : "Updated";
}

function truncateChangeValue(text, max = 64) {
    const value = String(text);
    return value.length > max ? `${value.slice(0, max - 1)}…` : value;
}

function formatChangeValue(change, value) {
    if (change.field === "required_override") {
        return value === true ? "Required" : value === false ? "Optional" : "Default";
    }
    if (value == null || value === "") return "None";
    switch (change.field) {
        case "office":
            return `Office #${value}`;
        case "roles": {
            const ids = Array.isArray(value) ? value : [];
            if (!ids.length) return "None";
            return ids.map((id) => `#${id}`).join(", ");
        }
        case "parent":
        case "from":
        case "to":
            return stepNameById.value.get(String(value)) || `Step #${value}`;
        case "requirement":
            return (
                requirementNameById.value.get(String(value)) ||
                `Requirement #${value}`
            );
        case "is_start":
        case "is_end":
        case "is_return_route":
        case "is_required":
        case "is_upload_required":
        case "is_active":
            return value ? "Yes" : "No";
        case "sla_minutes":
            return `${value} min`;
        case "condition_expression":
            return truncateChangeValue(value, 52);
        default:
            return truncateChangeValue(value, 64);
    }
}

function changeValueTitle(change, value) {
    if (change.field === "required_override") return formatChangeValue(change, value);
    if (value == null || value === "") return "None";
    if (
        [
            "condition_expression",
            "description",
            "name",
            "display_name",
            "label",
            "code",
            "route_group",
            "stage",
        ].includes(change.field)
    ) {
        return String(value);
    }
    return formatChangeValue(change, value);
}

const saveSubmitLabel = computed(() =>
    saveMode.value === "create-new" ? "Publish new version" : "Save version",
);

watch(
    () => props.modelValue,
    (isOpen) => {
        if (!isOpen) return;
        saveMode.value = "overwrite";
        saveName.value = props.defaultName || "";
        saveNotes.value = "";
        saveError.value = "";
    },
);

function close() {
    if (saving.value) return;
    open.value = false;
}

async function confirmSave() {
    if (!props.typeId || !props.defId) {
        saveError.value = "No workflow version is selected.";
        return;
    }
    const name = saveName.value.trim();
    if (saveMode.value === "create-new" && !name) {
        saveError.value = "Give the new version a name first.";
        return;
    }
    saveError.value = "";
    saving.value = true;
    try {
        const { data, meta } = await staging.saveAll(props.typeId, props.defId, {
            mode: saveMode.value,
            name: saveMode.value === "create-new" ? name : name || undefined,
            notes: saveNotes.value.trim() || undefined,
        });
        open.value = false;
        emit("saved", { data, meta });
    } catch (e) {
        const data = e?.response?.data;
        const firstFieldError = data?.errors
            ? Object.values(data.errors).flat()[0]
            : null;
        saveError.value =
            (e?.response?.status === 409
                ? "Someone saved while you were editing. Reload to get the latest, then re-apply your changes."
                : null) ||
            firstFieldError ||
            data?.message ||
            "Saving the staged changes failed.";
    } finally {
        saving.value = false;
    }
}
</script>

<style scoped>
/* ---- Save version modal (same design as the Steps/Routes page) ---- */
.sv-card {
    max-height: 90vh;
}
.sv-sum {
    padding: 14px 16px;
    border: 1px solid rgba(var(--v-theme-primary), 0.12);
    border-radius: 14px;
    background: rgba(var(--v-theme-primary), 0.06);
}
.sv-sum-copy {
    font-size: 13px;
    line-height: 1.5;
    color: rgb(var(--v-theme-secondary));
}
.sv-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 12px;
}
.sv-chip {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    min-height: 30px;
    padding: 0 11px 0 6px;
    border: 1px solid rgba(var(--v-theme-primary), 0.18);
    border-radius: 99px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
    font-size: 12.5px;
    font-weight: 700;
    line-height: 1.2;
    text-align: left;
    cursor: pointer;
    appearance: none;
    transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
}
.sv-chip:hover {
    border-color: rgba(var(--v-theme-primary), 0.45);
    background: rgba(var(--v-theme-primary), 0.07);
}
.sv-chip:focus-visible {
    outline: 2px solid rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.sv-chip-n {
    display: inline-grid;
    place-items: center;
    min-width: 22px;
    height: 22px;
    padding: 0 6px;
    border-radius: 99px;
    background: rgba(var(--v-theme-primary), 0.14);
    color: rgb(var(--v-theme-primary));
    font-size: 11.5px;
    font-weight: 800;
}
.sv-chip.is-zero {
    opacity: 0.45;
    border-color: rgba(var(--v-border-color), var(--v-border-opacity));
}
.sv-chip.is-zero .sv-chip-n {
    background: rgba(var(--v-border-color), 0.08);
    color: rgb(var(--v-theme-secondary));
}

/* Chip detail popovers: what changed, with old → new values. */
.sv-pop {
    width: min(360px, calc(100vw - 32px));
    padding: 14px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.sv-pop-h {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 10px;
    font-size: 14px;
    font-weight: 800;
}
.sv-pop-count {
    flex: none;
    font-size: 11.5px;
    font-weight: 700;
    color: rgb(var(--v-theme-secondary));
    white-space: nowrap;
}
.sv-pop-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
    max-height: min(300px, 45vh);
    padding-right: 2px;
    overflow-y: auto;
    overscroll-behavior: contain;
}
.sv-pop-item {
    display: flex;
    align-items: flex-start;
    gap: 9px;
}
.sv-pop-dot {
    flex: none;
    width: 8px;
    height: 8px;
    margin-top: 5px;
    border-radius: 50%;
    background: rgb(var(--v-theme-primary));
}
.sv-pop-dot.is-added {
    background: rgb(var(--v-theme-success));
}
.sv-pop-dot.is-updated {
    background: rgb(var(--v-theme-warning));
}
.sv-pop-dot.is-removed {
    background: rgb(var(--v-theme-error));
}
.sv-pop-body {
    min-width: 0;
}
.sv-pop-label {
    font-size: 13px;
    font-weight: 700;
    line-height: 1.4;
    overflow-wrap: anywhere;
}
.sv-pop-kind {
    margin-right: 6px;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}
.sv-pop-changes {
    display: flex;
    flex-direction: column;
    gap: 3px;
    margin-top: 5px;
}
.sv-pop-change {
    font-size: 12px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
    overflow-wrap: anywhere;
}
.sv-pop-field {
    margin-right: 3px;
    font-weight: 700;
    color: rgb(var(--v-theme-on-surface));
}
.sv-pop-val {
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.sv-pop-arrow {
    margin: 0 5px;
    color: rgb(var(--v-theme-secondary));
}
.sv-pop-empty {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}
.sv-sec {
    margin-top: 22px;
}
.sv-opts {
    display: grid;
    gap: 10px;
}
.sv-opt {
    position: relative;
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
    cursor: pointer;
    transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
}
.sv-opt:hover {
    background: rgba(var(--v-theme-primary), 0.04);
}
.sv-opt.is-on {
    border-color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.07);
    box-shadow: 0 0 0 3px rgba(var(--v-theme-primary), 0.1);
}
.sv-opt:focus-within {
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}
.sv-opt-input {
    position: absolute;
    width: 1px;
    height: 1px;
    margin: -1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0 0 0 0);
    white-space: nowrap;
    border: 0;
}
.sv-radio {
    flex: none;
    width: 20px;
    height: 20px;
    margin-top: 1px;
    border: 2px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 50%;
    background: rgb(var(--v-theme-surface));
    transition: border-color 0.15s, box-shadow 0.15s;
}
.sv-opt.is-on .sv-radio {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: inset 0 0 0 4px rgb(var(--v-theme-surface));
    background: rgb(var(--v-theme-primary));
}
.sv-opt-body {
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
}
.sv-opt-title {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    font-size: 14.5px;
    font-weight: 800;
    line-height: 1.3;
}
.sv-opt-desc {
    font-size: 12.5px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
}
.sv-tag {
    display: inline-flex;
    align-items: center;
    height: 20px;
    padding: 0 8px;
    border-radius: 99px;
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.02em;
    text-transform: uppercase;
}
.sv-tag-draft {
    background: rgba(var(--v-theme-warning), 0.14);
    color: rgb(var(--v-theme-warning));
}
.sv-tag-live {
    background: rgba(var(--v-theme-success), 0.14);
    color: rgb(var(--v-theme-success));
}
.sv-warn {
    display: flex;
    align-items: flex-start;
    gap: 9px;
    margin-top: 10px;
    padding: 11px 13px;
    border: 1px solid rgba(var(--v-theme-warning), 0.28);
    border-radius: 12px;
    background: rgba(var(--v-theme-warning), 0.1);
    color: rgb(var(--v-theme-warning));
    font-size: 12.5px;
    font-weight: 600;
    line-height: 1.45;
}
.sv-warn :deep(.v-icon) {
    flex: none;
    margin-top: 1px;
}

/* ---- Modal chrome shared with the New/Edit Step dialog ---- */
.stp-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 16px;
}
.stp-badge {
    flex: none;
}
.stp-hd-t {
    min-width: 0;
}
.stp-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}
.stp-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}
.stp-x {
    margin-left: auto;
    flex: none;
}
.stp-bd {
    padding: 18px 24px 8px;
}
.stp-sec {
    margin-bottom: 22px;
}
.stp-sec-t {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 0 0 12px;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}
.stp-sec-t::after {
    content: "";
    flex: 1;
    height: 1px;
    background: rgba(var(--v-border-color), var(--v-border-opacity));
}
.stp-f {
    min-width: 0;
    margin-bottom: 14px;
}
.stp-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}
.stp-opt {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}
.stp-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}
.stp-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}
.stp-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(0, 94, 237, 0.18);
}
.stp-ft {
    gap: 10px;
    padding: 16px 24px 20px;
}
.stp-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}
.stp-b-pri {
    min-width: 120px;
}

html.dark .stp-in :deep(.v-field) {
    background: #232b45;
}
html.dark .stp-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}

@media (max-width: 600px) {
    :global(.sv-dialog) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }
    :global(.sv-dialog .v-card) {
        max-height: 92vh;
        border-radius: 24px 24px 0 0 !important;
    }
}
</style>
