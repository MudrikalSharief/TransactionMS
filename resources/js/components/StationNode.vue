<template>
    <v-tooltip :disabled="!hasExtra" location="top" max-width="360" open-delay="250">
        <template #activator="{ props }">
            <div
                v-bind="props"
                class="d-flex flex-column align-center flex-shrink-0"
                style="width: 110px"
                :data-node="dataNode"
            >
                <v-avatar
                    :color="state === 'done' ? 'success' : state === 'current' ? 'primary' : 'grey-lighten-2'"
                    size="42"
                >
                    <v-icon
                        v-if="isLast"
                        :color="state === 'upcoming' ? 'grey-darken-1' : 'white'"
                        size="26"
                    >
                        mdi-check
                    </v-icon>
                    <span
                        v-else
                        class="font-weight-bold"
                        :class="state === 'upcoming' ? 'text-grey-darken-1' : 'text-white'"
                        style="font-size: 1.1rem"
                    >
                        {{ index + 1 }}
                    </span>
                </v-avatar>
                <div
                    class="text-caption text-center mt-1 step-label"
                    :class="state === 'current' ? 'font-weight-bold' : 'text-medium-emphasis'"
                    :title="(s.name || s.code || `Step ${index + 1}`) + (s.code && s.name ? ` (${s.code})` : '')"
                >
                    {{ s.name || s.code || `Step ${index + 1}` }}
                </div>
                <v-chip
                    v-if="state === 'current'"
                    color="primary"
                    variant="tonal"
                    rounded="0"
                    size="small"
                    class="mt-3 font-weight-bold"
                >
                    You are Here
                </v-chip>
            </div>
        </template>
        <div class="font-weight-bold text-caption mb-1">
            {{ s.order_number }}. {{ s.name || s.code }}
        </div>
        <div class="text-caption text-medium-emphasis mb-2">{{ statusLine }}</div>
        <div v-if="(detail?.requirements || []).length">
            <div class="text-caption font-weight-bold">Checklist</div>
            <div v-for="r in detail.requirements" :key="r.definition.id" class="d-flex align-center ga-1 mt-1">
                <v-icon size="x-small" :color="r.checked ? 'success' : 'grey'">
                    {{ r.checked ? 'mdi-check-circle' : 'mdi-clock-outline' }}
                </v-icon>
                <span class="text-caption">{{ r.definition.name }}</span>
                <span v-if="r.checked && r.checked_by" class="text-caption text-medium-emphasis">
                    · {{ r.checked_by.name }}
                </span>
            </div>
        </div>
        <div v-if="(detail?.fields || []).length" class="mt-2">
            <div class="text-caption font-weight-bold">Info recorded</div>
            <div v-for="f in detail.fields" :key="f.definition.id" class="d-flex justify-space-between ga-2 mt-1">
                <span class="text-caption text-medium-emphasis">{{ f.definition.name }}</span>
                <span class="text-caption font-weight-bold text-right">{{ displayValue(f.value) }}</span>
            </div>
        </div>
        <div v-if="move" class="mt-2">
            <div class="text-caption font-weight-bold">Moved</div>
            <div class="text-caption">
                {{ move.action_code }} → {{ move.to_step?.name || move.to_step?.code }}
                <span v-if="move.remarks"> · {{ move.remarks }}</span>
            </div>
            <div class="text-caption text-medium-emphasis">
                {{ move.performed_by?.name }} · {{ move.performed_at }}
            </div>
        </div>
        <div v-if="isUpcoming && !hasExtra" class="text-caption text-medium-emphasis">
            Not reached yet — nothing submitted.
        </div>
    </v-tooltip>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
    s: { type: Object, required: true },
    index: { type: Number, required: true },
    state: { type: String, default: 'upcoming' },
    isLast: { type: Boolean, default: false },
    detail: { type: Object, default: null },
    move: { type: Object, default: null },
    dataNode: { type: [Number, String, null], default: null },
})

const isUpcoming = computed(() => props.state === 'upcoming');

const hasExtra = computed(() =>
    !!props.detail || !!props.move || props.state !== 'upcoming',
);

const statusLine = computed(() => {
    if (props.state === 'current') return 'In progress — this is where the paper sits.';
    if (props.state === 'done') return 'Submitted here.';
    return 'Not reached yet.';
});

function displayValue(v) {
    if (v === null || v === undefined || v === '') return '—';
    if (typeof v === 'object') {
        try { return JSON.stringify(v); } catch { return String(v); }
    }
    return String(v);
}
</script>

<style scoped>
.step-label {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.35;
    overflow-wrap: break-word;
    font-size: 0.85rem;
}
</style>
