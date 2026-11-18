<template>
    <div class="mx-auto" style="max-width: 880px">
        <v-btn :to="backTo" variant="text" prepend-icon="mdi-arrow-left" class="mb-4">Back to transaction</v-btn>
        <v-card rounded="0" elevation="1">
            <v-card-title class="pa-4">{{ details?.show_history ? 'Receiving officers' : 'Receiving officer' }}</v-card-title>
            <v-card-subtitle v-if="details" class="pb-4" style="white-space: normal">
                {{ details.transaction.reference_number }} · Step {{ details.step.order_number }} · {{ details.step.name }}
            </v-card-subtitle>
            <v-divider />
            <v-card-text>
                <div v-if="loading" role="status" class="d-flex align-center ga-3 py-6">
                    <v-progress-circular indeterminate color="primary" size="24" /> Loading receiving officer details…
                </div>
                <v-alert v-else-if="error" type="error" variant="tonal" role="alert">
                    {{ error }}
                    <v-btn variant="text" size="small" @click="load">Retry</v-btn>
                </v-alert>
                <template v-else-if="details">
                    <p class="text-medium-emphasis mb-4">
                        {{ details.show_history ? 'All completed receipts for this step, newest first.' : 'Latest completed receipt for this step.' }}
                    </p>
                    <v-card v-for="receipt in details.receipts" :key="receipt.id" variant="outlined" rounded="0" class="mb-3">
                        <v-card-text>
                            <div class="text-body-2 mb-1">Assigned office: <b>{{ receipt.office?.name || 'Office not recorded' }}</b></div>
                            <div class="text-caption text-medium-emphasis mb-4">Received {{ fmtDateTime(receipt.received_at) }}</div>
                            <dl class="officer-details">
                                <dt>Name</dt><dd>{{ receipt.officer.name }}</dd>
                                <dt>Contact number</dt><dd>{{ receipt.officer.contact_number?.trim() || 'Contact number not provided' }}</dd>
                            </dl>
                        </v-card-text>
                    </v-card>
                </template>
            </v-card-text>
        </v-card>
    </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useApi } from '@/composables/useApi';
import { useAuth, userKind } from '@/composables/useAuth';
import { fmtDateTime } from '@/utils/dates';

const route = useRoute();
const { api } = useApi();
const auth = useAuth();
const details = ref(null);
const loading = ref(false);
const error = ref('');
const isStaff = computed(() => userKind(auth.user.value) === 'staff');
const backTo = computed(() => ({
    name: isStaff.value ? 'portal.transaction' : 'transaction.detail',
    params: { id: route.params.id },
}));
let requestId = 0;

async function load() {
    const current = ++requestId;
    details.value = null;
    error.value = '';
    loading.value = true;
    try {
        const prefix = isStaff.value ? '/api' : '/api/admin';
        const response = await api.get(`${prefix}/transactions/${route.params.id}/steps/${route.params.stepId}/receivers`);
        if (current === requestId) details.value = response.data.data;
    } catch (e) {
        if (current !== requestId) return;
        const status = e.response?.status;
        error.value = status === 403 ? 'You do not have access to these officer details.'
            : status === 404 ? 'No receiving officer details are available for this step.'
            : 'Unable to load receiving officer details. Please try again.';
    } finally {
        if (current === requestId) loading.value = false;
    }
}

watch(() => [route.params.id, route.params.stepId], load, { immediate: true });
</script>

<style scoped>
.officer-details { display: grid; grid-template-columns: minmax(90px, 140px) minmax(0, 1fr); gap: 12px; }
.officer-details dt { color: rgb(var(--v-theme-on-surface), 0.65); }
.officer-details dd { margin: 0; font-weight: 600; overflow-wrap: anywhere; }
@media (max-width: 600px) {
    .officer-details { grid-template-columns: minmax(0, 1fr); gap: 4px; }
    .officer-details dd + dt { margin-top: 12px; }
}
</style>
