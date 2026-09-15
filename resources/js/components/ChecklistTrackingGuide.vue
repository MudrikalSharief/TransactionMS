<template>
    <div>
        <div v-if="!(stations || []).length" class="text-caption text-medium-emphasis">
            No stations.
        </div>
        <v-timeline v-else density="compact" side="start" truncate-line="both">
            <v-timeline-item
                v-for="s in stations"
                :key="s.step.id"
                :dot-color="stateOf(s).color"
                :icon="stateOf(s).icon"
                size="small"
                density="compact"
                :class="isCurrent(s) ? '' : 'is-dim'"
            >
                <v-tooltip :disabled="isCurrent(s)" location="right" max-width="300">
                    <template #activator="{ props }">
                        <div v-bind="props">
                            <div class="font-weight-bold text-caption">
                                {{ s.step.order_number }}. {{ s.step.name }}
                                <v-chip
                                    v-if="isCurrent(s)"
                                    rounded="0"
                                    size="x-small"
                                    variant="tonal"
                                    color="primary"
                                    class="ml-1"
                                >
                                    here
                                </v-chip>
                            </div>
                            <div v-if="!(s.requirements || []).length" class="text-caption text-medium-emphasis">
                                No checklist items
                            </div>
                            <div
                                v-for="r in (s.requirements || [])"
                                :key="r.definition.id"
                                class="d-flex align-center flex-wrap ga-1 mt-1"
                            >
                                <v-icon
                                    size="x-small"
                                    :color="r.checked ? 'success' : 'grey'"
                                >
                                    {{ r.checked ? 'mdi-check-circle' : 'mdi-clock-outline' }}
                                </v-icon>
                                <span class="text-caption">{{ r.definition.name }}</span>
                                <v-chip
                                    v-if="r.pivot?.is_required"
                                    rounded="0"
                                    size="x-small"
                                    variant="tonal"
                                    color="error"
                                >
                                    required
                                </v-chip>
                            </div>
                        </div>
                    </template>
                    {{ nodeWaitText(s) }}
                </v-tooltip>
            </v-timeline-item>
        </v-timeline>
    </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
    stations: { type: Array, default: () => [] },
    currentStepId: { type: [Number, String], default: null },
})

const currentOrder = computed(() => {
    const cur = (props.stations || []).find((s) => Number(s.step.id) === Number(props.currentStepId));
    return cur ? Number(cur.step.order_number) || 0 : 0;
});

function isCurrent(s) {
    return Number(s.step.id) === Number(props.currentStepId);
}

function nodeWaitText(s) {
    const doneItems = (s.requirements || []).filter((r) => r.checked);
    if (doneItems.length) {
        return `Completed — ${doneItems.map((r) => r.definition.name).join(", ")}.`;
    }
    return `Wait until the paper reaches Station ${s.step.order_number} · ${s.step.name}.`;
}
function stateOf(s) {
    if (isCurrent(s)) {
        return { color: 'primary', icon: 'mdi-record-circle' };
    }
    // Green only when the station's required work is actually checked
    // (or it is an empty station already passed) — never by position alone.
    const reqs = s.requirements || [];
    const required = reqs.filter((r) => r.pivot?.is_required);
    const order = Number(s.step.order_number) || 0;
    const passed = currentOrder.value !== 0 && order < currentOrder.value;
    if (required.length > 0 && required.every((r) => r.checked)) {
        return { color: 'success', icon: 'mdi-check' };
    }
    if (reqs.length === 0 && passed) {
        return { color: 'success', icon: 'mdi-check' };
    }
    return { color: 'grey', icon: 'mdi-clock-outline' };
}
</script>

<style scoped>
.is-dim {
    opacity: 0.55;
}
</style>
