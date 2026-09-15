<template>
    <div>
        <div class="text-subtitle-2 font-weight-bold mb-2">
            Attach files <span class="text-caption text-medium-emphasis">(optional, max 20MB each)</span>
        </div>
        <v-file-input
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
            :items="modelValue"
            :tx-id="txId"
            :is-admin="isAdmin"
            compact
            @deleted="onDeleted"
        />
        <div class="text-caption text-medium-emphasis mt-1">
            Files upload immediately and are kept permanently. Visible to all viewers later. Only superadmin can delete.
        </div>
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
});
const emit = defineEmits(["update:modelValue", "uploaded", "deleted", "error"]);

const { api } = useApi();
const picked = ref([]);
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

async function onPick(files) {
    uploadError.value = "";
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
</script>
