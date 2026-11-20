<template>
    <v-card rounded="0" elevation="1" class="lgu-card mb-4">
        <v-card-title class="pa-0">
            <v-tabs v-model="tab" color="primary" density="comfortable">
                <v-tab :value="0">
                    <v-icon start>mdi-history</v-icon>
                    Route History
                    <v-chip size="x-small" variant="tonal" class="ml-2">{{ (runs || []).length + (assignmentHistory || []).length }}</v-chip>
                </v-tab>
                <v-tab :value="1">
                    <v-icon start>mdi-paperclip</v-icon>
                    Transaction files
                    <v-chip size="x-small" variant="tonal" class="ml-2">{{ previousFiles.length }}</v-chip>
                </v-tab>
            </v-tabs>
        </v-card-title>
        <v-divider />
        <v-window v-model="tab" class="doc-tabs-window">
            <v-window-item :value="0">
                <TransactionHistory
                    bare
                    :runs="runs"
                    :assignment-history="assignmentHistory"
                    :loading="loading"
                    :is-done="isDone"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :workflow-steps="workflowSteps"
                    :workflow-routes="workflowRoutes"
                    @deleted="(id) => emit('deleted', id)"
                />
            </v-window-item>
            <v-window-item :value="1">
                <div v-if="loading" class="pa-4">
                    <v-skeleton-loader v-for="n in 5" :key="n" type="list-item-avatar" class="mb-2" />
                </div>
                <div v-else class="pa-4">
                    <AttachmentList
                        :items="previousFiles"
                        :tx-id="txId"
                        :is-admin="isAdmin"
                        :current-step-id="currentStepId"
                        :show-details="false"
                        :workflow-steps="workflowSteps"
                        show-step
                        sort-by-step
                        group-by-step
                        centered-empty
                        @deleted="(id) => emit('deleted', id)"
                    />
                </div>
            </v-window-item>
        </v-window>
    </v-card>
</template>

<script setup>
import { computed, ref } from 'vue'
import TransactionHistory from '@/components/history/TransactionHistory.vue'
import AttachmentList from '@/components/AttachmentList.vue'

// One container for history + files with tab switching (History first).
const props = defineProps({
    runs: { type: Array, default: () => [] },
    assignmentHistory: { type: Array, default: () => [] },
    loading: { type: Boolean, default: false },
    isDone: { type: Boolean, default: false },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
    attachments: { type: Array, default: () => [] },
    workflowSteps: { type: Array, default: () => [] },
    workflowRoutes: { type: Array, default: () => [] },
    // Current step id: files that already moved forward hide their remove
    // buttons (step lock). Passed from detail pages.
    currentStepId: { type: [Number, String], default: null },
})

const emit = defineEmits(['deleted'])

const tab = ref(0)

// Transaction files: files that actually travelled with a move.
// Unlinked uploads (step_run_id null) are drafts/stale files that never left
// their station, so they must not appear as previous transaction files.
// The server already limits non-admins to the previous step (step file rule).
const previousFiles = computed(() =>
    (props.attachments || []).filter(
        (a) =>
            a.step_run_id !== null &&
            a.step_run_id !== undefined &&
            (props.currentStepId == null || String(a.workflow_step_id) !== String(props.currentStepId)),
    ),
)
</script>

<style scoped>
/* Let the active pane grow with its content up to 560px, then scroll
   inside the card. The 44px gutter matches the comfortable tabs header
   so the card's top and bottom bands balance. */
.doc-tabs-window {
    max-height: 560px;
    padding-bottom: 44px;
    box-sizing: border-box;
}

.doc-tabs-window :deep(.v-window-item) {
    max-height: calc(560px - 44px);
    overflow-y: auto;
}
</style>
