<template>
    <div v-if="items?.length">
        <div v-if="detailed && groupByLabel" class="d-flex flex-column ga-3 px-1 py-1">
            <v-card
                v-for="g in labelGroups"
                :key="g.key"
                rounded="lg"
                class="pa-2"
                style="box-shadow: 0 0 8px 1px rgba(0, 0, 0, 0.18); background: rgba(0, 0, 0, 0.015)"
            >
                <div class="d-flex align-center ga-2 mb-2">
                    <span class="text-subtitle-2 font-weight-bold text-truncate">{{ g.title }}</span>
                    <v-chip size="x-small" variant="tonal" color="grey-darken-3" rounded="lg">{{ g.files.length }} file{{ g.files.length === 1 ? '' : 's' }}</v-chip>
                </div>
                <div class="d-flex flex-wrap ga-1 align-center">
                    <div
                        v-for="a in g.files"
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
                            v-if="canRemove(a)"
                            :icon="isLinked(a) ? 'mdi-link-off' : 'mdi-trash-can-outline'"
                            size="x-small"
                            variant="text"
                            color="grey-darken-1"
                            :title="removeTitle(a)"
                            :loading="deletingId === a.id"
                            :disabled="deletingId !== null"
                            @click.stop="askDelete(a)"
                        />
                        <v-chip v-if="isLinked(a)" size="x-small" variant="tonal" color="info" rounded="lg">linked</v-chip>
                    </div>
                </div>
            </v-card>
        </div>
        <div v-else-if="detailed" class="d-flex flex-wrap ga-1 align-center">
            <div
                v-for="a in items"
                :key="a.id"
                class="d-inline-flex align-center ga-1 py-1 px-2 rounded"
                style="background: rgba(76, 175, 80, 0.12); border: 1px solid rgba(76, 175, 80, 0.25); width: fit-content; max-width: 100%"
            >
                <v-icon size="default" color="error">{{ fileIconFor(a) }}</v-icon>
                <div class="flex-1-1" style="min-width: 0; max-width: 220px">
                    <div class="text-body-2 text-truncate">{{ displayLabel(a) || a.original_name }}</div>
                    <div class="text-caption text-medium-emphasis">{{ formatSize(a.size_bytes) }}</div>
                </div>
                <v-btn
                    icon="mdi-eye-outline"
                    size="x-small"
                    variant="text"
                    color="grey-darken-1"
                    :title="`View ${displayLabel(a) || a.original_name}`"
                    :href="fileViewUrl(a)"
                    target="_blank"
                    rel="noopener"
                    :disabled="!fileViewUrl(a)"
                    @click.stop
                />
                <v-btn
                    v-if="canRemove(a)"
                    :icon="isLinked(a) ? 'mdi-link-off' : 'mdi-trash-can-outline'"
                    size="x-small"
                    variant="text"
                    color="grey-darken-1"
                    :title="removeTitle(a)"
                    :loading="deletingId === a.id"
                    :disabled="deletingId !== null"
                    @click.stop="askDelete(a)"
                />
                <v-chip v-if="isLinked(a)" size="x-small" variant="tonal" color="info" rounded="lg">linked</v-chip>
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
                    <div v-if="displayLabel(a)" class="font-weight-bold text-caption">{{ displayLabel(a) }}</div>
                    <div class="text-caption" :class="displayLabel(a) ? 'text-medium-emphasis' : 'font-weight-bold'">{{ a.original_name }}</div>
                    <div class="text-caption text-medium-emphasis">
                        <template v-if="reqLabel(a) && reqLabel(a) !== displayLabel(a)">[{{ reqLabel(a) }}] · </template>{{ formatSize(a.size_bytes) }}
                    </div>
                    <div class="text-caption mt-1">
                        <a v-if="action === 'download'" :href="a.download_url" class="text-white" @click.stop>Download</a>
                        <a v-else :href="fileViewUrl(a)" target="_blank" rel="noopener" class="text-white" @click.stop>View</a>
                    </div>
                </v-tooltip>
                <span
                    class="text-caption font-weight-bold text-truncate"
                    style="max-width: 160px"
                    :title="displayLabel(a) || a.original_name"
                >{{ displayLabel(a) || a.original_name }}</span>
                <v-btn
                    v-if="showEye"
                    icon="mdi-eye-outline"
                    size="x-small"
                    variant="text"
                    color="grey-darken-1"
                    :title="`View ${displayLabel(a) || a.original_name}`"
                    :href="fileViewUrl(a)"
                    target="_blank"
                    rel="noopener"
                    :disabled="!fileViewUrl(a)"
                    @click.stop
                />
                <v-btn
                    v-if="canRemove(a)"
                    :icon="isLinked(a) ? 'mdi-link-off' : 'mdi-delete'"
                    size="x-small"
                    variant="text"
                    color="error"
                    :title="removeTitle(a)"
                    :loading="deletingId === a.id"
                    :disabled="deletingId !== null"
                    @click.stop="askDelete(a)"
                />
            </span>
        </div>
        <template v-else>
        <div v-if="groupByStep" class="d-flex flex-column ga-3 px-1 py-1">
            <v-card
                v-for="g in stepGroups"
                :key="g.key"
                rounded="lg"
                class="pa-2"
                style="box-shadow: 0 0 8px 1px rgba(0, 0, 0, 0.18); background: rgba(0, 0, 0, 0.015)"
            >
                <div class="d-flex align-center ga-2 mb-2">
                    <span class="text-subtitle-2 font-weight-bold text-truncate">{{ g.title }}</span>
                    <v-chip size="x-small" variant="tonal" color="grey-darken-3" rounded="lg">{{ g.files.length }} file{{ g.files.length === 1 ? '' : 's' }}</v-chip>
                </div>
                <div class="d-flex flex-wrap ga-1 align-center">
                    <v-chip
                        v-for="a in g.files"
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
                        <v-chip
                            v-if="isLinked(a)"
                            size="x-small"
                            variant="flat"
                            color="info"
                            rounded="0"
                            class="ml-1"
                        >linked</v-chip>
                        <v-btn
                            v-if="canRemove(a)"
                            :icon="isLinked(a) ? 'mdi-link-off' : 'mdi-delete'"
                            size="x-small"
                            variant="text"
                            color="error"
                            class="ml-1"
                            :title="removeTitle(a)"
                            :loading="deletingId === a.id"
                            :disabled="deletingId !== null"
                            @click.stop="askDelete(a)"
                        />
                    </v-chip>
                </div>
            </v-card>
        </div>
        <template v-else>
        <v-chip
            v-for="a in displayItems"
            :key="a.id"
            rounded="0"
            size="small"
            variant="tonal"
            color="grey-darken-3"
            class="mr-1 mb-1"
        >
            <v-icon start size="small">mdi-paperclip</v-icon>
            <v-chip
                v-if="showStep"
                size="x-small"
                variant="tonal"
                color="grey-darken-3"
                rounded="0"
                class="mr-1"
            >{{ stepLabel(a) || 'Other' }}</v-chip>
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
            <v-chip
                v-if="isLinked(a)"
                size="x-small"
                variant="flat"
                color="info"
                rounded="0"
                class="ml-1"
            >linked</v-chip>
            <v-btn
                v-if="canRemove(a)"
                :icon="isLinked(a) ? 'mdi-link-off' : 'mdi-delete'"
                size="x-small"
                variant="text"
                color="error"
                class="ml-1"
                :title="removeTitle(a)"
                :loading="deletingId === a.id"
                :disabled="deletingId !== null"
                @click.stop="askDelete(a)"
            />
        </v-chip>
        </template>
        </template>
        <v-alert v-if="deleteError" type="error" variant="tonal" density="compact" class="mt-1 mb-1">
            {{ deleteError }}
        </v-alert>
        <div v-if="!compact && showDetails" class="mt-1">
            <div v-for="a in items" :key="'d-' + a.id" class="text-caption text-medium-emphasis">
                <template v-if="displayLabel(a)">[{{ displayLabel(a) }}] </template><template v-else-if="reqLabel(a)">[{{ reqLabel(a) }}] </template>{{ a.original_name }} • {{ displayUploader(a) }} • {{ a.created_at }} •
                <a :href="fileViewUrl(a)" target="_blank" rel="noopener">View</a>
                <template v-if="canRemove(a)">
                    •
                    <a href="#" class="text-error" @click.prevent="askDelete(a)">{{ isLinked(a) ? 'Remove reference' : 'Delete' }}</a>
                </template>
            </div>
        </div>
    </div>
    <div v-else-if="!compact && centeredEmpty" class="text-center pa-6 d-flex flex-column align-center justify-center" style="min-height: 480px">
        <img :src="mascotEmptyUrl" alt="No files yet" width="180" class="mb-3" style="border-radius: 18px" />
        <div class="font-weight-bold">No files attached yet.</div>
    </div>
    <div v-else-if="!compact" class="text-caption text-medium-emphasis">No files attached yet.</div>

    <v-dialog v-model="confirmDialog" max-width="500">
        <v-card rounded="xl" style="overflow: hidden">
            <v-card-title class="d-flex align-center">
                <v-avatar color="error" rounded="0" size="32" class="mr-3">
                    <v-icon color="white">{{ pendingDelete && isLinked(pendingDelete) ? 'mdi-link-off' : 'mdi-delete-alert' }}</v-icon>
                </v-avatar>
                {{ pendingDelete && isLinked(pendingDelete) ? 'Remove reference?' : 'Delete file?' }}
            </v-card-title>
            <v-divider />
            <v-card-text>
                <div class="text-body-2" v-if="pendingDelete && isLinked(pendingDelete)">
                    Remove <b>{{ pendingDelete?.original_name }}</b> from this step?
                    <span class="text-medium-emphasis">The original file in the previous step is kept.</span>
                </div>
                <div class="text-body-2" v-else>
                    Permanently delete <b>{{ pendingDelete?.original_name }}</b>
                    <span class="text-medium-emphasis">({{ formatSize(pendingDelete?.size_bytes) }})</span>?
                    <span class="text-medium-emphasis">Steps that linked this file lose their reference too.</span>
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
                <v-btn color="error" rounded="0" :loading="deletingId !== null" @click="doDelete">{{ pendingDelete && isLinked(pendingDelete) ? 'Remove' : 'Delete' }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { ref, computed } from "vue";
import { useApi } from "@/composables/useApi";
import { useAuth } from "@/composables/useAuth";
import { fileViewUrl } from "@/composables/useFileView";
import mascotEmptyUrl from "@/assets/mascots/mascot-empty.jpg";

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
    // When true, compact cards show an eye button opening a preview tab
    // (used by the Proceed modal Other-attachments list only).
    showEye: { type: Boolean, default: false },
    // When true with detailed, files group into one big card per batch
    // name (used by the Proceed modal Additional-files list only).
    groupByLabel: { type: Boolean, default: false },
    // When true, hides all delete buttons (view-only display of
    // previous-step files in the Proceed Review page).
    hideDelete: { type: Boolean, default: false },
    // When true, hides all delete buttons (view-only display of
    // previous-step files in the Proceed Review page).
    hideDelete: { type: Boolean, default: false },
    // When true, the empty state renders as a centralized circle graphic
    // instead of plain text (used by the Attached Files tab only).
    centeredEmpty: { type: Boolean, default: false },
    // Step separation for the "All transaction files" card below history:
    // workflowSteps resolves "Step N · Name" per attachment; showStep
    // renders the chip; sortByStep orders Step 1 → N with unmatched last.
    workflowSteps: { type: Array, default: () => [] },
    showStep: { type: Boolean, default: false },
    sortByStep: { type: Boolean, default: false },
    // When true with the default chip list, files render inside one
    // mother card per step (All transaction files card below history).
    groupByStep: { type: Boolean, default: false },
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
// Unlink (remove a linked reference) renders for any signed-in user on a
// persisted transaction — the backend enforces current-step worker gate.
const canDelete = computed(() => isSuperadmin.value && props.txId !== null && props.txId !== undefined && props.txId !== "");
const canUnlink = computed(() => !!auth.user.value && props.txId !== null && props.txId !== undefined && props.txId !== "");

function isLinked(a) {
    return !!((a?.source_attachment_id ?? a?.is_linked) ?? false);
}

function canRemove(a) {
    if (props.hideDelete) return false;
    return isLinked(a) ? canUnlink.value : canDelete.value;
}

function removeTitle(a) {
    const name = displayLabel(a) || a?.original_name || 'file';
    return isLinked(a) ? `Remove reference to ${name} (original kept)` : `Remove ${name}`;
}

function displayUploader(a) {
    return a.uploaded_by?.name || a.uploader?.name || "—";
}

function displayLabel(a) {
    const label = String(a?.label || '').trim();
    return label || '';
}

// Group detailed files by batch name (first-appearance order); unlabeled
// legacy files collect under their own "Other files" group.
const labelGroups = computed(() => {
    const groups = [];
    const byKey = new Map();
    for (const a of (props.items || [])) {
        const label = displayLabel(a);
        const key = label || '__unlabeled__';
        let g = byKey.get(key);
        if (!g) {
            g = { key, title: label || 'Other files', files: [] };
            byKey.set(key, g);
            groups.push(g);
        }
        g.files.push(a);
    }
    return groups;
});

function reqLabel(a) {
    if (displayLabel(a)) return displayLabel(a);
    if (a?.requirement?.name) return a.requirement.name;
    if (a?.requirement?.code) return a.requirement.code;
    if (a?.origin === "proceed" || (!a?.requirement_definition_id && a?.origin !== "check")) {
        return "move file";
    }
    return "";
}

// "Step N · Name" for the All-transaction-files card. Resolves the order
// number + name from workflowSteps; falls back to the attachment's own
// step payload; "" when no step matches (rendered as "Other").
function stepEntry(a) {
    const match = (props.workflowSteps || []).find(
        (s) => Number(s.id) === Number(a?.workflow_step_id),
    );
    if (match) return match;
    return null;
}

function stepLabel(a) {
    const m = stepEntry(a);
    if (m) {
        const n = m.order_number;
        const name = m.name || m.code || a?.step?.name || '';
        return `Step ${n}${name ? ` · ${name}` : ''}`;
    }
    if (a?.step?.name) return a.step.name;
    return '';
}

function stepOrder(a) {
    const m = stepEntry(a);
    const n = Number(m?.order_number);
    return Number.isFinite(n) ? n : Number.POSITIVE_INFINITY;
}

// Flat list separated by step: Step 1 → N, unmatched ("Other") last,
// then oldest-first within each step.
const displayItems = computed(() => {
    const list = [...(props.items || [])];
    if (!props.sortByStep) return list;
    return list.sort((x, y) => {
        const ox = stepOrder(x);
        const oy = stepOrder(y);
        if (ox !== oy) return ox - oy;
        const dx = String(x?.created_at || '');
        const dy = String(y?.created_at || '');
        if (dx !== dy) return dx < dy ? -1 : 1;
        return Number(x?.id || 0) - Number(y?.id || 0);
    });
});

// One mother card per step: groups displayItems (already step-ordered,
// "Other" last) by step label preserving first-appearance order.
const stepGroups = computed(() => {
    const groups = [];
    const byKey = new Map();
    for (const a of (displayItems.value || [])) {
        const title = stepLabel(a) || 'Other';
        const key = title;
        let g = byKey.get(key);
        if (!g) {
            g = { key, title, files: [] };
            byKey.set(key, g);
            groups.push(g);
        }
        g.files.push(a);
    }
    return groups;
});

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
        // Linked references unlink only (original file kept); owner rows
        // delete for real (cascades to linked references server-side).
        const url = isLinked(a) ? `${base}/${a.id}/unlink` : `${base}/${a.id}`;
        const res = await api.delete(url);
        confirmDialog.value = false;
        pendingDelete.value = null;
        const cascaded = res?.data?.cascaded_link_ids || [];
        emit("deleted", a.id);
        for (const cid of cascaded) emit("deleted", cid);
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
