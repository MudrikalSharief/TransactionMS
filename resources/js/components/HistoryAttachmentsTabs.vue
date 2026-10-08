<template>
    <v-card rounded="0" elevation="1" class="lgu-card mb-4">
        <v-card-title class="pa-0">
            <v-tabs v-model="tab" color="primary" density="comfortable">
                <v-tab :value="0">
                    <v-icon start>mdi-history</v-icon>
                    Transaction History
                    <v-chip size="x-small" variant="tonal" class="ml-2">{{ (runs || []).length }}</v-chip>
                </v-tab>
                <v-tab :value="1">
                    <v-icon start>mdi-paperclip</v-icon>
                    Attached Files
                    <v-chip size="x-small" variant="tonal" class="ml-2">{{ (attachments || []).length }}</v-chip>
                </v-tab>
            </v-tabs>
        </v-card-title>
        <v-divider />
        <v-window v-model="tab" class="doc-tabs-window">
            <v-window-item :value="0">
                <TransactionHistory
                    bare
                    :runs="runs"
                    :loading="loading"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    @deleted="(id) => emit('deleted', id)"
                />
            </v-window-item>
            <v-window-item :value="1">
                <div v-if="loading" class="pa-4">
                    <v-skeleton-loader v-for="n in 5" :key="n" type="list-item-avatar" class="mb-2" />
                </div>
                <div v-else class="pa-4">
                    <AttachmentList
                        :items="attachments || []"
                        :tx-id="txId"
                        :is-admin="isAdmin"
                        :show-details="false"
                        centered-empty
                        @deleted="(id) => emit('deleted', id)"
                    />
                </div>
            </v-window-item>
        </v-window>
    </v-card>
</template>

<script setup>
import { ref } from 'vue'
import TransactionHistory from '@/components/history/TransactionHistory.vue'
import AttachmentList from '@/components/AttachmentList.vue'

// One container for history + files with tab switching (History first).
const props = defineProps({
    runs: { type: Array, default: () => [] },
    loading: { type: Boolean, default: false },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
    attachments: { type: Array, default: () => [] },
})

const emit = defineEmits(['deleted'])

const tab = ref(0)
</script>

<style scoped>
/* Fixed pane height with internal scroll: the History table and the
   Files list differ in length, so panes scroll inside instead of
   resizing the card (and the page) on every tab switch. */
.doc-tabs-window {
    height: 560px;
}

.doc-tabs-window :deep(.v-window-item) {
    height: 560px;
    overflow-y: auto;
}
</style>
