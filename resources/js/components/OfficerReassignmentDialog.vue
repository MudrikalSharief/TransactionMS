<template>
    <v-dialog
        :model-value="modelValue"
        max-width="560"
        scrollable
        content-class="or-dialog"
        :persistent="saving"
        aria-labelledby="or-title"
        @update:model-value="emit('update:modelValue', $event)"
    >
        <v-card rounded="xl" class="or-card">
            <v-card-title class="or-hd">
                <v-avatar color="primary" variant="tonal" rounded="lg" size="44" class="or-badge">
                    <v-icon>mdi-account-switch-outline</v-icon>
                </v-avatar>
                <div class="or-hd-copy">
                    <h2 id="or-title" class="or-title">Reassign officer</h2>
                    <p class="or-sub">Transfer the current received step to another eligible officer.</p>
                </div>
                <v-btn
                    icon="mdi-close"
                    variant="text"
                    size="small"
                    class="or-x"
                    aria-label="Close reassign dialog"
                    :disabled="saving"
                    @click="close"
                />
            </v-card-title>
            <v-divider />
            <v-card-text class="or-bd">
                <v-progress-linear v-if="loading" indeterminate color="primary" class="mb-4" />
                <v-alert v-if="error" type="error" variant="tonal" density="compact" class="mb-4">
                    {{ error }}
                </v-alert>
                <template v-if="assignment">
                    <v-select
                        v-if="assignment.visits?.length > 1"
                        v-model="selectedRun"
                        :items="assignment.visits"
                        item-title="label"
                        item-value="id"
                        label="Office and step"
                        variant="outlined"
                        :menu-props="{ locationStrategy: workspaceMenuLocation }"
                        :disabled="saving || loading"
                        @update:model-value="selectVisit"
                    />
                    <div class="text-body-2 mb-2"><b>{{ assignment.office?.name || 'Originating office' }}</b> · {{ assignment.step?.name }}</div>
                    <div class="or-current">
                        <span class="or-current-icon" aria-hidden="true">
                            <v-icon size="20">mdi-account-outline</v-icon>
                        </span>
                        <div class="or-current-copy">
                            <div class="or-label">Current officer</div>
                            <div class="or-current-name">
                                {{ assignment.current_officer?.name || (assignment.is_pending ? 'Not assigned yet' : 'Officer no longer available') }}
                            </div>
                        </div>
                    </div>
                    <v-alert v-if="assignment.requires_reassignment" type="warning" variant="tonal" class="mb-4">The previous officer is unavailable. Select a replacement before this return can be received.</v-alert>
                    <v-alert v-if="assignment.is_pending" type="info" variant="tonal" class="mb-4">This return is waiting to be received. The new officer must still receive it.</v-alert>
                    <div class="or-note" role="note">
                        <v-icon size="18" aria-hidden="true">mdi-alert-outline</v-icon>
                        <span>Responsibility transfers immediately for this office. The previous officer will lose access to this transaction.</span>
                    </div>
                    <p v-if="!assignment.is_current" class="text-body-2 mb-4">The transaction is now at another step. The new officer can view it, with processing actions governed by the current step's office and role.</p>
                    <div class="or-field">
                        <label class="or-label" for="or-officer">
                            New officer <span class="or-req" aria-hidden="true">*</span>
                        </label>
                        <v-select
                            id="or-officer"
                            v-model="assignedTo"
                            :items="assignment.candidates || []"
                            item-title="name"
                            item-value="id"
                            placeholder="Choose an eligible officer"
                            variant="outlined"
                            density="comfortable"
                            hide-details="auto"
                            :disabled="saving || loading || !assignment.can_reassign"
                            :error-messages="fieldErrors.assigned_to"
                            class="or-in"
                        />
                        <div v-if="assignment.can_reassign && !assignment.candidates?.length" class="or-empty">
                            No eligible replacement officers are available.
                        </div>
                    </div>
                    <div class="or-field">
                        <label class="or-label" for="or-reason">
                            Reason <span class="or-req" aria-hidden="true">*</span>
                        </label>
                        <v-textarea
                            id="or-reason"
                            v-model="reason"
                            variant="outlined"
                            density="comfortable"
                            rows="3"
                            counter="1000"
                            maxlength="1000"
                            placeholder="Explain why responsibility is changing"
                            :disabled="saving || loading || !assignment.can_reassign"
                            :error-messages="fieldErrors.reason"
                            class="or-in"
                        />
                    </div>
                </template>
            </v-card-text>
            <v-divider />
            <v-card-actions class="or-ft">
                <v-btn
                    variant="outlined"
                    rounded="lg"
                    class="or-b"
                    :disabled="saving"
                    @click="close"
                >
                    Cancel
                </v-btn>
                <v-btn
                    color="primary"
                    rounded="lg"
                    class="or-b or-b-pri"
                    :loading="saving"
                    :disabled="!canSubmit"
                    @click="submit"
                >
                    Reassign officer
                </v-btn>
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

function close() {
    if (saving.value) return;
    emit('update:modelValue', false);
}

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

<style scoped>
.or-card {
    max-height: 90vh;
    overflow: hidden;
    background: rgb(var(--v-theme-surface));
}
.or-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 16px;
}
.or-badge {
    flex: none;
}
.or-hd-copy {
    min-width: 0;
}
.or-title {
    margin: 0;
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}
.or-sub {
    margin: 3px 0 0;
    font-size: 14px;
    line-height: 1.4;
    color: rgb(var(--v-theme-secondary));
}
.or-x {
    margin-left: auto;
    flex: none;
}
.or-bd {
    padding: 18px 24px 8px;
}
.or-label {
    display: block;
    margin-bottom: 7px;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}
.or-current {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 16px;
    border: 1px solid rgba(var(--v-theme-primary), 0.14);
    border-radius: 14px;
    background: rgba(var(--v-theme-primary), 0.06);
}
.or-current-icon {
    display: grid;
    place-items: center;
    width: 38px;
    height: 38px;
    flex: none;
    border-radius: 10px;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
}
.or-current-copy {
    min-width: 0;
}
.or-current .or-label {
    margin-bottom: 2px;
}
.or-current-name {
    font-size: 15px;
    font-weight: 700;
    line-height: 1.3;
    overflow-wrap: anywhere;
}
.or-note {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    margin-top: 12px;
    padding: 12px 14px;
    border: 1px solid rgba(var(--v-theme-warning), 0.28);
    border-radius: 12px;
    background: rgba(var(--v-theme-warning), 0.1);
    font-size: 13px;
    line-height: 1.5;
}
.or-note :deep(.v-icon) {
    flex: none;
    margin-top: 1px;
    color: rgb(var(--v-theme-warning));
}
.or-field {
    margin-top: 18px;
}
.or-req {
    color: rgb(var(--v-theme-error));
}
.or-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: rgba(var(--v-theme-on-surface), 0.045);
}
.or-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}
.or-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
}
/* Keep the field's regular neutral outline while the dropdown is open. */
.or-in :deep(.v-field.v-field--focused .v-field__outline) {
    --v-field-border-width: 1.5px;
    --v-field-border-opacity: 0.38;
}
/*
 * The workspace-wide focus-visible rule draws a second blue rectangle inside
 * Vuetify fields. The field's own border is the focus indicator here.
 */
.or-in :deep(input:focus-visible),
.or-in :deep(textarea:focus-visible),
.or-in :deep(.v-field__input:focus-visible) {
    outline: none !important;
}
.or-in :deep(.v-field--error) {
    box-shadow: 0 0 0 4px rgba(var(--v-theme-error), 0.14);
}
.or-empty {
    margin-top: 8px;
    font-size: 13px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
}
.or-ft {
    gap: 10px;
    padding: 16px 24px 20px;
}
.or-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}
.or-b-pri {
    min-width: 160px;
}
@media (max-width: 600px) {
    :global(.or-dialog) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }
    :global(.or-dialog .v-card) {
        max-height: 92vh;
        border-radius: 24px 24px 0 0 !important;
    }
    .or-hd {
        padding: 20px 18px 14px;
    }
    .or-bd {
        padding: 16px 18px 8px;
    }
    .or-ft {
        flex-direction: column-reverse;
        padding: 14px 18px 18px;
    }
    .or-b {
        width: 100%;
    }
}
</style>
