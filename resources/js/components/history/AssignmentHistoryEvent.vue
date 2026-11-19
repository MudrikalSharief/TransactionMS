<template>
    <div class="assignment-event pa-4">
        <div class="d-flex align-center flex-wrap ga-3 mb-2">
            <v-chip color="purple-darken-2" size="small" variant="tonal" rounded="0" prepend-icon="mdi-account-switch-outline">{{ event.is_automatic ? 'Return assignment' : 'Reassigned' }}</v-chip>
            <span class="text-caption text-medium-emphasis">{{ formatHistoryDate(event.assigned_at) }}</span>
        </div>
        <div v-if="event.office || event.step" class="text-body-2 mb-1">{{ event.office?.name }} · {{ event.step?.name }}</div>
        <div class="font-weight-medium">{{ event.from_officer?.name || 'Unassigned' }} → {{ event.to_officer?.name || 'Officer no longer available' }}</div>
        <div class="text-body-2 mt-1">Assigned by {{ event.assigned_by?.name || 'Administrator no longer available' }}</div>
        <div class="text-body-2 mt-2 assignment-reason"><b>Reason:</b> {{ event.reason }}</div>
    </div>
</template>

<script setup>
import { formatHistoryDate } from '@/utils/history';
defineProps({ event: { type: Object, required: true } });
</script>

<style scoped>
.assignment-event { border-left: 3px solid #7b1fa2; background: #faf7fc; }
.assignment-reason { white-space: pre-wrap; overflow-wrap: anywhere; }
</style>
