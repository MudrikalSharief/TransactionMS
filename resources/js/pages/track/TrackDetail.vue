<template>
    <TrackBackdrop quiet />
    <div class="track-detail">
        <v-btn variant="text" color="grey-darken-3" prepend-icon="mdi-arrow-left" class="mb-3" @click="router.push('/track')">
            Back to search
        </v-btn>

        <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

        <div v-if="loading" class="d-flex align-center justify-center" style="height: 280px">
            <v-progress-circular indeterminate color="grey-darken-3" size="48" width="4" />
        </div>

        <template v-else-if="tx">
            <!-- Summary -->
            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-title class="d-flex align-center flex-wrap ga-2 pa-4 track-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 track-avatar">
                        <v-icon color="#005EED" size="24">mdi-map-marker-path</v-icon>
                    </v-avatar>
                    <div style="min-width: 0">
                        <div class="text-subtitle-1 font-weight-bold">{{ tx.title || tx.reference_number }}</div>
                        <div class="text-caption text-medium-emphasis">{{ tx.reference_number }}</div>
                    </div>
                    <v-spacer />
                    <v-chip :color="tx.is_done ? 'success' : 'warning'" variant="flat" rounded="0" class="font-weight-bold">
                        <v-icon start>{{ tx.is_done ? "mdi-check-circle-outline" : "mdi-progress-clock" }}</v-icon>
                        {{ tx.is_done ? "Completed" : "In process" }}
                    </v-chip>
                </v-card-title>
                <v-card-text class="pa-4">
                    <v-row dense>
                        <v-col v-for="f in facts" :key="f.label" cols="12" sm="6" md="3">
                            <div class="fact-label">{{ f.label }}</div>
                            <div class="fact-value">{{ f.value }}</div>
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-card>

            <!-- Progress tracker -->
            <StepProgress
                fluid
                class="mb-4"
                title="Progress"
                :steps="tx.workflow_steps"
                :current-step-id="tx.current_step?.id"
                :current-step-code="tx.current_step?.code"
                :visited-step-ids="tx.visited_step_ids"
                :runs="trackerRuns"
            />

            <!-- Movement history: offices and times only -->
            <v-card rounded="0" elevation="1" class="lgu-card">
                <v-card-title class="d-flex align-center pa-4 track-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 track-avatar">
                        <v-icon color="#005EED" size="24">mdi-history</v-icon>
                    </v-avatar>
                    <span class="text-subtitle-1 font-weight-bold">Movement History</span>
                </v-card-title>
                <v-card-text class="pa-4">
                    <v-alert v-if="!tx.history.length" type="info" variant="tonal" rounded="0">
                        No movement recorded yet.
                    </v-alert>
                    <v-timeline v-else side="end" density="compact" align="start" truncate-line="both">
                        <v-timeline-item
                            v-for="h in historyDesc"
                            :key="h.id"
                            :dot-color="h.is_creation ? 'teal' : 'primary'"
                            size="small"
                        >
                            <div class="font-weight-bold">{{ describe(h) }}</div>
                            <div class="text-caption text-medium-emphasis">
                                {{ fmtDateTime(h.performed_at) }}
                                <template v-if="h.received_at"> · received {{ fmtDateTime(h.received_at) }}<template v-if="h.received_office"> by {{ h.received_office.name }}</template></template>
                                <template v-else-if="!h.is_creation"> · awaiting receipt</template>
                            </div>
                        </v-timeline-item>
                    </v-timeline>
                </v-card-text>
            </v-card>

            <div class="text-caption text-medium-emphasis mt-3">
                <v-icon size="14">mdi-lock-outline</v-icon>
                Read-only view. Documents and attachments are not shown to viewer accounts.
            </div>
        </template>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useSmartPoll } from "@/composables/useSmartPoll";
import StepProgress from "@/components/StepProgress.vue";
import TrackBackdrop from "@/components/track/TrackBackdrop.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const tx = ref(null);
const loading = ref(true);
const error = ref("");

async function load({ silent = false } = {}) {
    if (!silent) loading.value = true;
    try {
        const ref = route.query.ref ? { ref: String(route.query.ref) } : {};
        const res = await api.get(`/api/viewer/transactions/${route.params.id}`, { params: ref });
        tx.value = res.data?.data ?? null;
        error.value = "";
    } catch (e) {
        error.value =
            e?.response?.status === 404
                ? "This transaction was not found. Search for it again with its full reference number."
                : e?.response?.data?.message || "Failed to load the transaction.";
        if (!silent) tx.value = null;
    } finally {
        loading.value = false;
    }
}

function fmtDateTime(iso) {
    if (!iso) return "—";
    return new Date(iso).toLocaleString("en-PH", {
        timeZone: "Asia/Manila",
        month: "short",
        day: "numeric",
        year: "numeric",
        hour: "numeric",
        minute: "2-digit",
    });
}

const facts = computed(() => {
    const t = tx.value;
    if (!t) return [];
    return [
        { label: "Transaction type", value: t.transaction_type?.name || "—" },
        { label: "Office", value: t.office?.name || "—" },
        { label: "Current step", value: t.current_step?.name || (t.is_done ? "Finished" : "—") },
        { label: "Currently at", value: t.current_step?.office?.name || "—" },
        { label: "Created", value: fmtDateTime(t.created_at) },
        { label: "Last update", value: fmtDateTime(t.updated_at) },
    ];
});

// Hover cards on the tracker show the office that moved it, never a person.
const trackerRuns = computed(() =>
    (tx.value?.history ?? []).map((h) => ({
        ...h,
        performed_by: { name: h.from_step?.office?.name || "Office" },
    }))
);

const historyDesc = computed(() => [...(tx.value?.history ?? [])].reverse());

function describe(h) {
    if (h.is_creation) return `Created and started at ${h.to_step?.name || "the first step"}`;
    const from = h.from_step?.name || "—";
    const to = h.to_step?.name || "—";
    const toOffice = h.to_step?.office?.name;
    return `${from} → ${to}${toOffice ? ` (${toOffice})` : ""}`;
}

onMounted(load);
useSmartPoll(() => load({ silent: true }));
</script>

<style scoped>
.track-detail {
    position: relative;
    z-index: 1;
}
.track-head {
    background: transparent;
    border-bottom: 4px solid rgb(var(--v-theme-primary));
    border-image: var(--tms-grad-h) 1;
}
.track-avatar {
    border: 2px solid rgb(var(--v-theme-primary));
}
.fact-label {
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}
.fact-value {
    font-weight: 700;
    overflow-wrap: anywhere;
}
</style>
