<template>
    <v-dialog :model-value="modelValue" max-width="560" scrollable :persistent="saving" @update:model-value="emit('update:modelValue', $event)">
        <v-card rounded="0">
            <v-card-title class="pa-5">Reassign officer</v-card-title>
            <v-card-text>
                <v-progress-linear v-if="loading" indeterminate color="primary" class="mb-4" />
                <v-alert v-if="error" type="error" variant="tonal" class="mb-4">{{ error }}</v-alert>
                <template v-if="assignment">
                    <v-select v-if="assignment.visits?.length > 1" v-model="selectedRun" :items="assignment.visits" item-title="label" item-value="id" label="Office and step" variant="outlined" :menu-props="{ locationStrategy: workspaceMenuLocation }" :disabled="saving || loading" @update:model-value="selectVisit" />
                    <div class="text-body-2 mb-2"><b>{{ assignment.office?.name || 'Originating office' }}</b> · {{ assignment.step?.name }}</div>
                    <div class="text-body-2 mb-4">Current officer: <b>{{ assignment.current_officer?.name || (assignment.is_pending ? 'Not assigned yet' : 'Officer no longer available') }}</b></div>
                    <v-alert v-if="assignment.requires_reassignment" type="warning" variant="tonal" class="mb-4">The previous officer is unavailable. Select a replacement before this return can be received.</v-alert>
                    <v-alert v-if="assignment.is_pending" type="info" variant="tonal" class="mb-4">This return is waiting to be received. The new officer must still receive it.</v-alert>
                    <p class="text-body-2 mb-4">Responsibility transfers immediately for this office. The previous officer will lose access to this transaction.</p>
                    <p v-if="!assignment.is_current" class="text-body-2 mb-4">The transaction is now at another step. The new officer can view it, with processing actions governed by the current step's office and role.</p>
                    <v-select v-model="assignedTo" :items="assignment.candidates || []" item-title="name" item-value="id" label="New officer" variant="outlined" :menu-props="{ locationStrategy: workspaceMenuLocation }" :disabled="saving || loading || !assignment.can_reassign" :error-messages="fieldErrors.assigned_to" />
                    <v-textarea v-model="reason" label="Reason (required)" variant="outlined" rows="3" counter="1000" maxlength="1000" :disabled="saving || loading || !assignment.can_reassign" :error-messages="fieldErrors.reason" />
                    <div v-if="assignment.can_reassign && !assignment.candidates?.length" class="text-body-2">No eligible replacement officers are available.</div>
                </template>
            </v-card-text>
            <v-card-actions class="px-5 pb-5">
                <v-spacer />
                <v-btn :disabled="saving" @click="emit('update:modelValue', false)">Cancel</v-btn>
                <v-btn color="primary" variant="flat" rounded="0" :loading="saving" :disabled="!canSubmit" @click="submit">Reassign officer</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { useApi } from '@/composables/useApi';
import { workspaceMenuLocation } from '@/utils/workspaceMenuLocation';

const props = defineProps({ modelValue: Boolean, txId: { type: [Number, String], default: null } });
const emit = defineEmits(['update:modelValue', 'saved', 'unavailable']);
const { api } = useApi();
const assignment = ref(null);
const assignedTo = ref(null);
const selectedRun = ref(null);
const reason = ref('');
const error = ref('');
const fieldErrors = ref({});
const loading = ref(false);
const saving = ref(false);
const canSubmit = computed(() => !loading.value && !saving.value && assignment.value?.can_reassign && assignedTo.value != null && reason.value.trim().length > 0 && reason.value.length <= 1000);
const endpoint = () => `/api/admin/transactions/${props.txId}/officer-assignment`;

async function fetchAssignment(runId = null) {
    loading.value = true;
    assignment.value = null;
    error.value = '';
    try {
        const res = await api.get(endpoint(), { params: runId ? { run_id: runId } : {} });
        assignment.value = res.data.data;
        selectedRun.value = assignment.value?.run_id;
        if (!assignment.value?.can_reassign) error.value = 'This office visit can no longer be reassigned. Close this dialog and refresh the transaction.';
    } catch (e) {
        error.value = e?.response?.data?.message || 'Failed to load eligible officers.';
        if ([403, 404].includes(e?.response?.status)) emit('unavailable');
    } finally {
        loading.value = false;
    }
}

function selectVisit(runId) {
    assignedTo.value = null;
    fieldErrors.value = {};
    fetchAssignment(runId);
}

watch(() => props.modelValue, open => {
    if (!open) return;
    assignedTo.value = null;
    selectedRun.value = null;
    reason.value = '';
    error.value = '';
    fieldErrors.value = {};
    fetchAssignment();
});

async function submit() {
    if (!canSubmit.value) return;
    saving.value = true;
    error.value = '';
    fieldErrors.value = {};
    try {
        await api.post(endpoint(), { run_id: assignment.value.run_id, version: assignment.value.version, assigned_to: assignedTo.value, reason: reason.value.trim() });
        emit('update:modelValue', false);
        emit('saved');
    } catch (e) {
        const status = e?.response?.status;
        if (status === 409) {
            // Never retry a transfer automatically: show the new responsibility
            // and require a fresh, deliberate officer selection and submission.
            assignedTo.value = null;
            await fetchAssignment(selectedRun.value);
            error.value = 'This transaction changed while the dialog was open. Review the office and current officer, select the replacement again, and submit to confirm.';
        } else {
            fieldErrors.value = e?.response?.data?.errors || {};
            error.value = e?.response?.data?.message || 'Unable to reassign the officer.';
            if ([403, 404].includes(status)) emit('unavailable');
        }
    } finally {
        saving.value = false;
    }
}
</script>
