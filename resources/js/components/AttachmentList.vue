<template>
    <div v-if="items?.length">
        <v-chip
            v-for="a in items"
            :key="a.id"
            rounded="0"
            size="small"
            variant="tonal"
            color="grey-darken-3"
            class="mr-1 mb-1"
        >
            <v-icon start size="small">mdi-paperclip</v-icon>
            {{ a.original_name }}
            <span class="text-caption ml-1">({{ formatSize(a.size_bytes) }})</span>
            <a
                :href="a.download_url"
                class="ml-1 text-decoration-none"
                title="Download"
                @click.stop
            >
                <v-icon size="small">mdi-download</v-icon>
            </a>
            <v-btn
                v-if="canDelete"
                icon="mdi-delete"
                size="x-small"
                variant="text"
                color="error"
                class="ml-1"
                title="Delete (superadmin only)"
                :loading="deletingId === a.id"
                :disabled="deletingId !== null"
                @click.stop="askDelete(a)"
            />
        </v-chip>
        <v-alert v-if="deleteError" type="error" variant="tonal" density="compact" class="mt-1 mb-1">
            {{ deleteError }}
        </v-alert>
        <div v-if="!compact" class="mt-1">
            <div v-for="a in items" :key="'d-' + a.id" class="text-caption text-medium-emphasis">
                {{ a.original_name }} • {{ displayUploader(a) }} • {{ a.created_at }} •
                <a :href="a.download_url">Download</a>
                <template v-if="canDelete">
                    •
                    <a href="#" class="text-error" @click.prevent="askDelete(a)">Delete</a>
                </template>
            </div>
        </div>
    </div>
    <div v-else-if="!compact" class="text-caption text-medium-emphasis">No files attached yet.</div>

    <v-dialog v-model="confirmDialog" max-width="500">
        <v-card rounded="0">
            <v-card-title class="d-flex align-center">
                <v-avatar color="error" rounded="0" size="32" class="mr-3">
                    <v-icon color="white">mdi-delete-alert</v-icon>
                </v-avatar>
                Delete file?
            </v-card-title>
            <v-divider />
            <v-card-text>
                <div class="text-body-2">
                    Permanently delete <b>{{ pendingDelete?.original_name }}</b>
                    <span class="text-medium-emphasis">({{ formatSize(pendingDelete?.size_bytes) }})</span>?
                </div>
                <v-alert type="warning" variant="tonal" density="compact" class="mt-3">
                    This cannot be undone.
                </v-alert>
                <v-alert v-if="deleteError" type="error" variant="tonal" density="compact" class="mt-3">
                    {{ deleteError }}
                </v-alert>
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end">
                <v-btn variant="text" :disabled="deletingId !== null" @click="cancelDelete">Cancel</v-btn>
                <v-btn color="error" rounded="0" :loading="deletingId !== null" @click="doDelete">Delete</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { ref, computed } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";

const props = defineProps({
    items: { type: Array, default: () => [] },
    compact: { type: Boolean, default: false },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
});
const emit = defineEmits(["deleted"]);

const { api } = useApi();
const auth = useAuth();
const deletingId = ref(null);
const deleteError = ref("");
const confirmDialog = ref(false);
const pendingDelete = ref(null);

const isSuperadmin = computed(() =>
    (auth.user.value?.roles || []).some((r) => r.code === "superadmin"),
);

// Delete button only renders for superadmin on a persisted transaction.
const canDelete = computed(() => isSuperadmin.value && props.txId !== null && props.txId !== undefined && props.txId !== "");

function displayUploader(a) {
    return a.uploaded_by?.name || a.uploader?.name || "—";
}

function askDelete(a) {
    deleteError.value = "";
    pendingDelete.value = a;
    confirmDialog.value = true;
}

function cancelDelete() {
    if (deletingId.value !== null) return;
    confirmDialog.value = false;
    pendingDelete.value = null;
}

async function doDelete() {
    const a = pendingDelete.value;
    if (!a) return;
    deleteError.value = "";
    deletingId.value = a.id;
    try {
        const base = props.isAdmin
            ? `/api/admin/transactions/${props.txId}/attachments`
            : `/api/transactions/${props.txId}/attachments`;
        await api.delete(`${base}/${a.id}`);
        confirmDialog.value = false;
        pendingDelete.value = null;
        emit("deleted", a.id);
    } catch (e) {
        deleteError.value = e?.response?.data?.message || "Delete failed.";
    } finally {
        deletingId.value = null;
    }
}

function formatSize(b) {
    const n = Number(b || 0);
    if (n < 1024) return `${n} B`;
    if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
    return `${(n / 1024 / 1024).toFixed(1)} MB`;
}
</script>
