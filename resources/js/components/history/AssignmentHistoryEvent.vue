<template>
    <div
        class="assignment-event"
        role="group"
        :aria-label="`Reassigned from ${fromName} to ${toName} by ${assignedByName}`"
    >
        <span class="assignment-marker" aria-hidden="true">
            <v-icon size="18">mdi-account-switch-outline</v-icon>
        </span>
        <div class="assignment-content">
            <div class="assignment-top">
                <v-chip
                    size="small"
                    variant="tonal"
                    rounded="0"
                    color="purple-darken-2"
                    class="assignment-chip"
                >
                    Reassigned
                </v-chip>
                <span v-if="stepText" class="assignment-step" :title="stepTitle">
                    <v-icon size="14" aria-hidden="true">mdi-map-marker-outline</v-icon>
                    {{ stepText }}
                </span>
                <span class="assignment-date">{{ formatHistoryDate(event.assigned_at) }}</span>
            </div>
            <div class="assignment-transfer">
                <span class="assignment-person">{{ fromName }}</span>
                <v-icon size="16" class="assignment-arrow" aria-hidden="true">mdi-arrow-right</v-icon>
                <span class="assignment-person is-new">{{ toName }}</span>
            </div>
            <div class="assignment-bottom">
                <div class="assignment-reason">
                    <span class="assignment-reason-label">Reason</span>{{ event.reason }}
                </div>
                <div class="assignment-by">
                    Reassigned by <b>{{ assignedByName }}</b>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { formatHistoryDate } from '@/utils/history';

const props = defineProps({
    event: { type: Object, required: true },
    // The step visit this transfer belongs to, so the row can name its station.
    visit: { type: Object, default: null },
});

const fromName = computed(
    () => props.event?.from_officer?.name || 'Officer no longer available',
);
const toName = computed(
    () => props.event?.to_officer?.name || 'Officer no longer available',
);
const assignedByName = computed(
    () => props.event?.assigned_by?.name || 'Administrator no longer available',
);
const stepText = computed(() => {
    const step = props.visit?.to_step;
    if (!step) return '';
    const number = step.order_number ? `Step ${step.order_number}` : '';
    const office = String(step.office?.code || step.office?.name || '').trim();
    return [number, office].filter(Boolean).join(' · ');
});
const stepTitle = computed(() => {
    const step = props.visit?.to_step;
    if (!step) return '';
    return [step.name, step.office?.name].filter(Boolean).join(' — ');
});
</script>

<style scoped>
.assignment-event {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin: 8px 12px;
    padding: 12px 14px;
    border: 1px solid color-mix(in srgb, #7c3aed 18%, transparent);
    border-left: 3px solid #7c3aed;
    background: color-mix(in srgb, #7c3aed 6%, rgb(var(--v-theme-surface)));
}
.assignment-marker {
    display: grid;
    place-items: center;
    width: 30px;
    height: 30px;
    flex: none;
    background: color-mix(in srgb, #7c3aed 14%, transparent);
    color: #7c3aed;
}
.assignment-content {
    flex: 1 1 auto;
    min-width: 0;
}
.assignment-top {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
}
.assignment-chip {
    font-weight: 700;
}
.assignment-step {
    display: inline-flex;
    align-items: center;
    gap: 3px;
    min-width: 0;
    overflow: hidden;
    color: rgb(var(--v-theme-on-surface));
    font-size: 12px;
    font-weight: 600;
    opacity: 0.7;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.assignment-date {
    margin-left: auto;
    color: rgb(var(--v-theme-on-surface));
    font-size: 12px;
    opacity: 0.6;
    white-space: nowrap;
}
.assignment-transfer {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    margin-top: 7px;
    font-size: 14.5px;
    line-height: 1.3;
}
.assignment-person {
    font-weight: 700;
    overflow-wrap: anywhere;
}
.assignment-person.is-new {
    color: #7c3aed;
}
.assignment-arrow {
    opacity: 0.45;
}
.assignment-bottom {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 6px 20px;
    margin-top: 6px;
}
.assignment-reason {
    flex: 1 1 320px;
    min-width: 0;
    color: rgb(var(--v-theme-on-surface));
    font-size: 13px;
    line-height: 1.5;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}
.assignment-reason-label {
    margin-right: 6px;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    opacity: 0.6;
}
.assignment-by {
    flex: none;
    color: rgb(var(--v-theme-on-surface));
    font-size: 12px;
    opacity: 0.75;
}
.assignment-by b {
    font-weight: 700;
}
@media (max-width: 700px) {
    .assignment-event {
        gap: 10px;
        margin: 8px;
        padding: 10px 12px;
    }
    .assignment-marker {
        width: 28px;
        height: 28px;
    }
    .assignment-date {
        margin-left: 0;
    }
}
</style>
