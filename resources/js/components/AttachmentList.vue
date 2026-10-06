<template>
    <div v-if="items?.length">
        <div v-if="detailed" class="d-flex flex-wrap ga-1 align-center">
            <div
                v-for="a in items"
                :key="a.id"
                class="d-inline-flex align-center ga-1 py-1 px-2 rounded"
                style="background: rgba(76, 175, 80, 0.12); border: 1px solid rgba(76, 175, 80, 0.25); width: fit-content; max-width: 100%"
            >
                <v-icon size="default" color="error">{{ fileIconFor(a) }}</v-icon>
                <div class="flex-1-1" style="min-width: 0; max-width: 220px">
                    <div class="text-body-2 text-truncate">{{ a.original_name }}</div>
                    <div class="text-caption text-medium-emphasis">{{ formatSize(a.size_bytes) }}</div>
                </div>
                <v-btn
                    icon="mdi-eye-outline"
                    size="x-small"
                    variant="text"
                    color="grey-darken-1"
                    :title="`View ${a.original_name}`"
                    :href="fileViewUrl(a)"
                    target="_blank"
                    rel="noopener"
                    :disabled="!fileViewUrl(a)"
                    @click.stop
                />
                <v-btn
                    v-if="canDelete"
                    icon="mdi-trash-can-outline"
                    size="x-small"
                    variant="text"
                    color="grey-darken-1"
                    :title="`Remove ${a.original_name}`"
                    :loading="deletingId === a.id"
                    :disabled="deletingId !== null"
                    @click.stop="askDelete(a)"
                />
            </div>
        </div>
        <div v-else-if="compact" class="d-flex flex-wrap ga-1">
            <span v-for="a in items" :key="a.id" class="d-inline-flex align-center ga-1 border rounded-0 pa-1">
                <v-tooltip location="top" max-width="320">
                    <template #activator="{ props }">
                        <a
                            v-if="action === 'download'"
                            :href="a.download_url"
                            class="text-decoration-none"
                            :title="a.original_name"
                            v-bind="props"
                            @click.stop
                        >
                            <v-btn
                                icon
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                :aria-label="a.original_name"
                                :title="a.original_name"
                            >
                                <v-icon size="small">{{ fileIconFor(a) }}</v-icon>
                            </v-btn>
                        </a>
                        <a
                            v-else
                            :href="fileViewUrl(a)"
                            target="_blank"
                            rel="noopener"
                            class="text-decoration-none"
                            :title="a.original_name"
                            v-bind="props"
                            @click.stop
                        >
                            <v-btn
                                icon
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                :aria-label="a.original_name"
                                :title="a.original_name"
                            >
                                <v-icon size="small">{{ fileIconFor(a) }}</v-icon>
                            </v-btn>
                        </a>
                    </template>
                    <div class="font-weight-bold text-caption">{{ a.original_name }}</div>
                    <div class="text-caption text-medium-emphasis">
                        <template v-if="reqLabel(a)">[{{ reqLabel(a) }}] · </template>{{ formatSize(a.size_bytes) }}
                    </div>
                    <div class="text-caption mt-1">
                        <a v-if="action === 'download'" :href="a.download_url" class="text-white" @click.stop>Download</a>
                        <a v-else :href="fileViewUrl(a)" target="_blank" rel="noopener" class="text-white" @click.stop>View</a>
                    </div>
                </v-tooltip>
                <v-btn
                    v-if="canDelete"
                    icon="mdi-delete"
                    size="x-small"
                    variant="text"
                    color="error"
                    title="Delete (superadmin only)"
                    :loading="deletingId === a.id"
                    :disabled="deletingId !== null"
                    @click.stop="askDelete(a)"
                />
            </span>
        </div>
        <template v-else>
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
            <v-chip
                v-if="reqLabel(a)"
                size="x-small"
                variant="flat"
                color="blue-grey"
                rounded="0"
                class="mr-1"
            >{{ reqLabel(a) }}</v-chip>
            {{ a.original_name }}
            <span class="text-caption ml-1">({{ formatSize(a.size_bytes) }})</span>
            <a
                :href="fileViewUrl(a)"
                target="_blank"
                rel="noopener"
                class="ml-1 text-decoration-none"
                title="View"
                @click.stop
            >
                <v-icon size="small">mdi-eye</v-icon>
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
        </template>
        <v-alert v-if="deleteError" type="error" variant="tonal" density="compact" class="mt-1 mb-1">
            {{ deleteError }}
        </v-alert>
        <div v-if="!compact && showDetails" class="mt-1">
            <div v-for="a in items" :key="'d-' + a.id" class="text-caption text-medium-emphasis">
                <template v-if="reqLabel(a)">[{{ reqLabel(a) }}] </template>{{ a.original_name }} • {{ displayUploader(a) }} • {{ a.created_at }} •
                <a :href="fileViewUrl(a)" target="_blank" rel="noopener">View</a>
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
import { fileViewUrl } from "@/composables/useFileView";

const props = defineProps({
    items: { type: Array, default: () => [] },
    compact: { type: Boolean, default: false },
    // Detailed file rows (requirements redesign): icon + name + size·uploaded + trash.
    // Delete stays superadmin-gated via canDelete.
    detailed: { type: Boolean, default: false },
    // When false, hides the plain-text detail lines below the chips
    // (used in history expanded details to avoid showing each file twice).
    showDetails: { type: Boolean, default: true },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
    // 'view' opens a preview tab; 'download' fetches the file directly.
    // Upload pickers use 'download'.
    action: { type: String, default: 'view' },
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

function reqLabel(a) {
    if (a?.requirement?.name) return a.requirement.name;
    if (a?.requirement?.code) return a.requirement.code;
    if (a?.origin === "proceed" || (!a?.requirement_definition_id && a?.origin !== "check")) {
        return "move file";
    }
    return "";
}

function fileIconFor(a) {
    const mime = String(a?.mime || "").toLowerCase();
    const name = String(a?.original_name || "").toLowerCase();
    const ext = (name.split(".").pop() || "").split("?")[0];

    if (mime.includes("pdf") || ext === "pdf") return "mdi-file-pdf-box";
    if (mime.startsWith("image/") || ["png", "jpg", "jpeg", "gif", "webp", "bmp", "svg"].includes(ext)) return "mdi-file-image";
    if (mime.includes("word") || mime.includes("officedocument.wordprocessing") || ["doc", "docx", "odt", "rtf"].includes(ext)) return "mdi-file-word";
    if (mime.includes("spreadsheet") || mime.includes("excel") || ["xls", "xlsx", "ods"].includes(ext)) return "mdi-file-excel";
    if (mime.includes("csv") || ext === "csv") return "mdi-file-delimited";
    if (mime.includes("presentation") || mime.includes("powerpoint") || ["ppt", "pptx", "odp"].includes(ext)) return "mdi-file-powerpoint";
    if (mime.includes("zip") || mime.includes("compressed") || ["zip", "rar", "7z", "tar", "gz"].includes(ext)) return "mdi-folder-zip";
    if (mime.startsWith("text/") || ["txt", "md", "log"].includes(ext)) return "mdi-file-document-outline";
    if (mime.startsWith("video/") || ["mp4", "avi", "mov", "mkv"].includes(ext)) return "mdi-file-video";
    if (mime.startsWith("audio/") || ["mp3", "wav", "ogg"].includes(ext)) return "mdi-file-music";
    return "mdi-file-document";
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
        if (e?.response?.status === 404) {
            confirmDialog.value = false;
            pendingDelete.value = null;
            emit("deleted", a.id);
            return;
        }
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
