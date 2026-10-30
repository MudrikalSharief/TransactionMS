<template>
    <div :class="{ 'pm-form': redesign }">
        <!-- Caller-owned picker/header (redesigned requirement cards put the
             title, status and Choose files action on one row). -->
        <slot name="header" :open="pick" :uploading="uploading" :disabled="pickerDisabled" />
        <input v-if="$slots.header" ref="fileInput" type="file" multiple class="d-none" @change="onNativePick" />
        <div v-if="!$slots.header && showHeader" class="d-flex align-center ga-2 mb-3">
            <div class="font-weight-bold text-body-1">
                Upload files
            </div>
            <span v-if="hintText" class="text-caption" :class="hintType === 'success' ? 'text-success' : 'text-error'">
                <v-icon size="x-small">{{ hintType === 'success' ? 'mdi-check' : 'mdi-alert-circle-outline' }}</v-icon>
                {{ hintText }}
            </span>
        </div>
        <!-- Inline Name + Add file row (used by Other attachments in the Proceed modal). -->
        <div v-if="!$slots.header && showLabelInput" :class="redesign ? 'pm-add mb-2' : 'd-flex ga-2 align-start flex-wrap mb-2'">
            <template v-if="redesign">
                <input
                    class="pm-input"
                    :value="fileLabel"
                    :placeholder="labelInputPlaceholder || labelInputLabel"
                    :aria-label="labelInputLabel"
                    @input="emit('update:fileLabel', $event.target.value)"
                />
                <button
                    type="button"
                    class="pm-btn pri"
                    :disabled="pickerDisabled"
                    @click="pick"
                >
                    <span v-if="uploading" class="pm-spinner" aria-hidden="true"></span>
                    <v-icon v-else size="16">mdi-paperclip</v-icon>
                    {{ uploading ? 'Uploading…' : addButtonLabel }}
                </button>
                <button
                    v-if="showExistingBtn"
                    type="button"
                    class="pm-btn ghost"
                    :disabled="existingDisabled || uploading"
                    @click="emit('open-existing')"
                >
                    <v-icon size="16">mdi-history</v-icon>
                    Existing
                </button>
            </template>
            <template v-else>
                <v-text-field
                    :model-value="fileLabel"
                    :label="labelInputLabel"
                    :placeholder="labelInputPlaceholder"
                    variant="outlined"
                    density="compact"
                    hide-details="auto"
                    class="flex-1-1"
                    style="min-width: 180px"
                    @update:model-value="(v) => emit('update:fileLabel', v)"
                />
                <v-btn
                    size="small"
                    variant="tonal"
                    rounded="0"
                    prepend-icon="mdi-paperclip"
                    class="flex-0-0 mt-1"
                    :disabled="pickerDisabled"
                    :loading="uploading"
                    @click="pick"
                >{{ addButtonLabel }}</v-btn>
                <v-btn
                    v-if="showExistingBtn"
                    size="small"
                    variant="tonal"
                    rounded="0"
                    prepend-icon="mdi-history"
                    class="flex-0-0 mt-1"
                    :disabled="existingDisabled || uploading"
                    @click="emit('open-existing')"
                >Existing files</v-btn>
            </template>
            <input ref="fileInput" type="file" multiple class="d-none" @change="onNativePick" />
        </div>
        <!-- Minimal picker: small button + inline hint (used in grouped upload sections). -->
        <div v-else-if="!$slots.header && minimal" :class="redesign ? '' : 'd-flex align-center ga-2 mb-2'">
            <button
                v-if="redesign"
                type="button"
                class="pm-lnk"
                :disabled="pickerDisabled"
                @click="pick"
            >
                <v-icon size="16">{{ uploading ? 'mdi-loading' : 'mdi-paperclip' }}</v-icon>
                {{ uploading ? 'Uploading…' : (hasFiles ? 'Add more' : 'Choose files') }}
            </button>
            <v-btn
                v-else
                size="small"
                variant="tonal"
                rounded="0"
                prepend-icon="mdi-paperclip"
                :disabled="pickerDisabled"
                :loading="uploading"
                @click="pick"
            >Choose files</v-btn>
            <span v-if="labelMissing" class="text-caption text-error">
                <v-icon size="x-small">mdi-alert-circle-outline</v-icon>
                Enter a name first to enable uploads.
            </span>
            <span v-else-if="hintText" :class="redesign ? 'pm-hint' : 'text-caption'" :style="!redesign ? '' : ''">
                <v-icon size="x-small">{{ hintType === 'success' ? 'mdi-check' : 'mdi-alert-circle-outline' }}</v-icon>
                {{ hintText }}
            </span>
            <input ref="fileInput" type="file" multiple class="d-none" @change="onNativePick" />
        </div>
        <v-file-input
            v-else-if="!$slots.header"
            v-model="picked"
            label="Choose files"
            multiple
            show-size
            counter
            density="compact"
            :disabled="pickerDisabled"
            :loading="uploading"
            :hint="labelMissing ? 'Enter a name first to enable uploads.' : undefined"
            :persistent-hint="labelMissing"
            @update:model-value="onPick"
        />
        <v-alert v-if="uploadError" :type="redesign ? 'error' : 'error'" :variant="redesign ? 'tonal' : 'tonal'" :density="redesign ? 'compact' : 'compact'" :class="redesign ? 'mb-2' : 'mb-2'">
            {{ uploadError }}
        </v-alert>
        <AttachmentList
            v-if="showList"
            :items="modelValue"
            :tx-id="txId"
            :is-admin="isAdmin"
            :compact="!listDetailed"
            :detailed="listDetailed"
            :show-details="false"
            :action="fileAction"
            :show-eye="listShowEye"
            :group-by-label="listGroupByLabel"
            :collapsible-groups="listCollapsibleGroups"
            :redesign="redesign"
            @deleted="onDeleted"
        />
    </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useApi } from "@/composables/useApi";
import AttachmentList from "@/components/AttachmentList.vue";

const props = defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    requirementId: { type: [Number, String], default: null },
    modelValue: { type: Array, default: () => [] },
    disabled: { type: Boolean, default: false },
    hintText: { type: String, default: '' },
    hintType: { type: String, default: 'error' },
    // When false, hides the internal file list (caller renders its own
    // merged list elsewhere, e.g. above the input in Proceed cards).
    showList: { type: Boolean, default: true },
    // Minimal mode: small Choose button instead of the full-width field
    // (used in grouped upload sections in the Proceed modal).
    minimal: { type: Boolean, default: false },
    // Hide the "Upload files" header (requirement name serves as title).
    showHeader: { type: Boolean, default: true },
    // File click behavior of the internal list ('view' | 'download').
    fileAction: { type: String, default: 'view' },
    // Optional per-batch label for uploads (used by Other attachments).
    fileLabel: { type: String, default: '' },
    // When true, picking files is blocked until fileLabel is non-blank.
    requireLabel: { type: Boolean, default: false },
    // When true, the internal list shows an eye preview button per file.
    listShowEye: { type: Boolean, default: false },
    // When true, the internal list renders green detailed cards instead of
    // grey compact chips (used by the Proceed modal Other-attachments only).
    listDetailed: { type: Boolean, default: false },
    // When true with listDetailed, files group into one big card per batch name.
    listGroupByLabel: { type: Boolean, default: false },
    // Collapse the grouped list by batch name. Additional files leave this
    // expanded by default so freshly uploaded rows stay visible.
    listCollapsibleGroups: { type: Boolean, default: false },
    // When true, renders an inline [Name][Add file] row owning the label
    // input (used by Other attachments instead of a separate Name field).
    showLabelInput: { type: Boolean, default: false },
    labelInputLabel: { type: String, default: 'Name' },
    labelInputPlaceholder: { type: String, default: 'e.g. Additional DTR' },
    addButtonLabel: { type: String, default: 'Add file' },
    // When true, shows an inline "Existing files" button beside Add file
    // (Additional-files reuse from the previous step; no Name needed).
    showExistingBtn: { type: Boolean, default: false },
    existingDisabled: { type: Boolean, default: false },
    // Redesigned proceed-modal styling for the picker, label row and list.
    redesign: { type: Boolean, default: false },
});
const emit = defineEmits(["update:modelValue", "uploaded", "deleted", "error", "update:fileLabel", "open-existing"]);

const { api } = useApi();
const picked = ref([]);
const fileInput = ref(null);
const uploading = ref(false);
const uploadError = ref("");

const uploadUrl = computed(() =>
    props.isAdmin
        ? `/api/admin/transactions/${props.txId}/attachments`
        : `/api/transactions/${props.txId}/attachments`,
);

const labelMissing = computed(() => props.requireLabel && !String(props.fileLabel || '').trim());
const pickerDisabled = computed(() => props.disabled || uploading.value || labelMissing.value);
const hasFiles = computed(() => (props.modelValue || []).length > 0);

// Lets a caller-owned #header slot trigger the native picker while the
// upload state (busy/disabled) stays owned here.
function pick() {
    if (pickerDisabled.value) return;
    fileInput.value?.click();
}

defineExpose({ pick, uploading });

function onDeleted(id) {
    emit("update:modelValue", props.modelValue.filter((a) => a.id !== id));
    emit("deleted", id);
}

function formatErr(e) {
    const errs = e?.response?.data?.errors;
    if (errs) {
        const first = Object.values(errs).flat()[0];
        if (first) return Array.isArray(first) ? first[0] : String(first);
    }
    return (
        e?.response?.data?.message ||
        "Upload failed."
    );
}

async function onPick(files) {
    uploadError.value = "";
    if (!files?.length) return;
    if (labelMissing.value) {
        uploadError.value = "Enter a name first.";
        return;
    }
    const label = String(props.fileLabel || '').trim();
    const queue = [...files];
    picked.value = [];
    uploading.value = true;
    const done = [...props.modelValue];
    try {
        for (const f of queue) {
            if (f.size > 20 * 1024 * 1024) {
                uploadError.value = `"${f.name}" exceeds 20MB and was skipped.`;
                continue;
            }
            const fd = new FormData();
            fd.append("file", f);
            if (props.requirementId) {
                fd.append("requirement_definition_id", String(props.requirementId));
            }
            if (label) {
                fd.append("label", label);
            }
            // Do NOT set Content-Type manually: the browser must add the
            // multipart boundary, otherwise Laravel sees no file (422).
            const res = await api.post(uploadUrl.value, fd);
            const created = res.data?.data ?? res.data;
            done.push(created);
            emit("update:modelValue", [...done]);
            emit("uploaded", created);
        }
        // One name per batch: clear it so the next batch gets its own name.
        if (label) emit("update:fileLabel", "");
    } catch (e) {
        uploadError.value = formatErr(e);
        emit("error", uploadError.value);
    } finally {
        uploading.value = false;
    }
}

function onNativePick(e) {
    const files = [...(e?.target?.files || [])];
    if (e?.target) e.target.value = '';
    onPick(files);
}
</script>
