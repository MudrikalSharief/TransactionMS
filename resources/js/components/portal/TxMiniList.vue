<template>
    <div>
        <div v-if="loading" class="d-flex align-center justify-center" style="height: 200px">
            <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
        </div>
        <v-alert v-else-if="!rows.length" type="info" variant="tonal" rounded="0" class="ma-2">
            {{ empty }}
        </v-alert>
        <v-list v-else lines="two" class="py-0">
            <v-list-item v-for="tx in rows" :key="tx.id" rounded="0" class="mini-row" @click="emit('open', tx)">
                <template #prepend>
                    <div class="mini-icon" :style="tint(tx)">
                        <v-icon size="20">mdi-file-document-outline</v-icon>
                    </div>
                </template>
                <v-list-item-title class="font-weight-bold">
                    {{ tx.title || tx.reference_number || `Transaction #${tx.id}` }}
                </v-list-item-title>
                <v-list-item-subtitle>
                    {{ subtitle(tx) }}
                </v-list-item-subtitle>
                <template #append>
                    <v-chip v-if="tx.is_done" size="x-small" color="success" variant="flat" rounded="0" class="mr-2">
                        Done
                    </v-chip>
                    <span v-else-if="tx.current_step" class="mini-pill mr-2" :style="tint(tx)">
                        {{ tx.current_step.name || tx.current_step.code }}
                    </span>
                    <v-icon size="small" color="primary">mdi-chevron-right</v-icon>
                </template>
            </v-list-item>
        </v-list>
    </div>
</template>

<script setup>
import { processColor, txProcessName } from "@/utils/processColor";

defineProps({
    rows: { type: Array, default: () => [] },
    loading: { type: Boolean, default: false },
    empty: { type: String, default: "Nothing here yet." },
});
const emit = defineEmits(["open"]);

function timeAgo(iso) {
    if (!iso) return "";
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
    if (s < 60) return "just now";
    if (s < 3600) return `${Math.floor(s / 60)}m ago`;
    if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
    if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`;
    return new Date(iso).toLocaleDateString("en-PH", { month: "short", day: "numeric", year: "numeric" });
}

function tint(tx) {
    const c = processColor(txProcessName(tx));
    return { color: c, background: `color-mix(in srgb, ${c} 14%, transparent)` };
}

function subtitle(tx) {
    const base = [tx.reference_number, tx.transaction_type?.name || tx.transaction_type_name]
        .filter(Boolean)
        .join(" · ");
    return [base, timeAgo(tx.created_at)].filter(Boolean).join(" · ");
}
</script>

<style scoped>
.mini-row {
    cursor: pointer;
}
.mini-row:hover {
    background: rgba(var(--v-theme-on-surface), 0.05);
}
.mini-icon {
    display: grid;
    place-items: center;
    width: 38px;
    height: 38px;
    margin-right: 12px;
    border-radius: 10px;
}
.mini-icon .v-icon {
    color: inherit;
}
.mini-pill {
    display: inline-block;
    max-width: 180px;
    padding: 3px 10px;
    border-radius: 999px;
    font-size: 0.72rem;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>
