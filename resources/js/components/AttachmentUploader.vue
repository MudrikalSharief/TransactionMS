<template>
    <div>
        <div v-if="showHeader" class="d-flex align-center ga-2 mb-3">
            <div class="font-weight-bold text-body-1">
                Upload files
                <span class="text-caption text-medium-emphasis">(optional, max 20MB each)</span>
            </div>
            <span v-if="hintText" class="text-caption" :class="hintType === 'success' ? 'text-success' : 'text-error'">
                <v-icon size="x-small">{{ hintType === 'success' ? 'mdi-check' : 'mdi-alert-circle-outline' }}</v-icon>
                {{ hintText }}
            </span>
        </div>
        <!-- Minimal picker: small button + inline hint (used in grouped upload sections). -->
        <div v-if="minimal" class="d-flex align-center ga-2 mb-2">
            <v-btn
                size="small"
                variant="tonal"
                rounded="0"
                prepend-icon="mdi-paperclip"
                :disabled="disabled || uploading"
                :loading="uploading"
                @click="fileInput?.click()"
            >Choose files</v-btn>
            <span v-if="hintText" class="text-caption" :class="hintType === 'success' ? 'text-success' : 'text-error'">
                <v-icon size="x-small">{{ hintType === 'success' ? 'mdi-check' : 'mdi-alert-circle-outline' }}</v-icon>
                {{ hintText }}
            </span>
            <span v-else class="text-caption text-medium-emphasis">(optional, max 20MB each)</span>
            <input ref="fileInput" type="file" multiple class="d-none" @change="onNativePick" />
        </div>
        <v-file-input
            v-else
            v-model="picked"
            label="Choose files"
            multiple
            show-size
            counter
            density="compact"
            :disabled="disabled || uploading"
            :loading="uploading"
            @update:model-value="onPick"
        />
        <v-alert v-if="uploadError" type="error" variant="tonal" density="compact" class="mb-2">
            {{ uploadError }}
        </v-alert>
        <AttachmentList
            v-if="showList"
            :items="modelValue"
            :tx-id="txId"
            :is-admin="isAdmin"
            compact
            :action="fileAction"
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
});
const emit = defineEmits(["update:modelValue", "uploaded", "deleted", "error"]);

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

function onDeleted(id) {
    emit("update:modelValue", props.modelValue.filter((a) => a.id !== id));
    emit("deleted", id);
}

function formatErr(e) {    const errs = e?.response?.data?.errors;
    if (errs) {
        const first = Object.values(errs).flat()[0];
        if (first) return Array.isArray(first) ? first[0] : String(first);
    }
    return (
        e?.response?.data?.message ||
        "Upload failed."
    );
}

async function onPick(files) {    uploadError.value = "";
    if (!files?.length) return;
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
            // Do NOT set Content-Type manually: the browser must add the
            // multipart boundary, otherwise Laravel sees no file (422).
            const res = await api.post(uploadUrl.value, fd);
            const created = res.data?.data ?? res.data;
            done.push(created);
            emit("update:modelValue", [...done]);
            emit("uploaded", created);
        }
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
