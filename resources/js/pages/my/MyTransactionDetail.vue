<template>
    <div>
        <h1 class="text-h5 font-weight-bold mb-5">My Transaction Detail</h1>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-file-document</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">
                    Transaction: <b>{{ tx?.reference_number }}</b>
                    <span v-if="tx?.title"> — {{ tx.title }}</span>
                </span>
                <v-spacer />
                <v-btn variant="text" @click="$router.push('/my/transactions')">Back</v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text v-if="tx" class="pa-4">
                <div class="mb-2">
                    <b>Transaction Type:</b> {{ tx.transaction_type?.name }}
                </div>

                <div class="mb-2">
                    <b>Current Step:</b> {{ tx.current_step?.name }} ({{ tx.current_step?.code }})
                </div>

                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>

                <v-divider class="my-3" />

            </v-card-text>

            <v-card-text v-else class="pa-4">
                <v-alert v-if="!loading && error" type="error" variant="tonal" class="mb-0">{{ error }}</v-alert>
                <div v-else>
                    <v-skeleton-loader type="heading" class="mb-2" />
                    <v-skeleton-loader type="text" />
                    <v-skeleton-loader type="text" />
                </div>
            </v-card-text>
        </v-card>

        <template v-if="!tx && loading">
            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-text class="pa-4">
                    <div class="d-flex flex-wrap ga-1">
                        <v-skeleton-loader v-for="n in 6" :key="n" type="chip" width="110" />
                    </div>
                </v-card-text>
            </v-card>

            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-title class="d-flex align-center pa-5">
                    <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                        <v-icon color="white">mdi-swap-horizontal</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">Available Actions</span>
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-4">
                    <v-skeleton-loader type="actions" />
                </v-card-text>
            </v-card>

            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-title class="d-flex align-center pa-5">
                    <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                        <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">Checklist</span>
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-4">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" />
                </v-card-text>
            </v-card>

            <!-- Step Form skeleton hidden with its card (see above). -->
            <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="false">
                <v-card-title class="d-flex align-center pa-5">
                    <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                        <v-icon color="white">mdi-form-textbox</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">Step Form</span>
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-4">
                    <v-skeleton-loader type="paragraph" />
                </v-card-text>
            </v-card>

            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-title class="d-flex align-center pa-5">
                    <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                        <v-icon color="white">mdi-swap-horizontal</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">Available Actions</span>
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-4">
                    <v-skeleton-loader type="actions" />
                </v-card-text>
            </v-card>

            <v-card rounded="0" elevation="1" class="lgu-card mb-4">
                <v-card-title class="d-flex align-center pa-5">
                    <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                        <v-icon color="white">mdi-history</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">History</span>
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-4">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" />
                </v-card-text>
            </v-card>
        </template>

        <div v-if="(tx?.workflow_steps || []).length" class="mb-4">
            <StepProgress
                fluid
                preserve-order
                :steps="flatStationItems"
                :current-step-id="tx.current_step?.id"
                :current-step-code="tx.current_step?.code"
                :details="tx.station_checklist"
                :runs="tx.runs"
                title="Transaction Stations"
            />
        </div>

        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="tx">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-swap-horizontal</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Available Actions</span>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">

                <v-alert v-if="!availableActions.length" type="info" variant="tonal" class="mb-3">
                    No actions available for your role on this step (or route conditions not satisfied).
                </v-alert>

                <div v-else>
                    <v-row>
                        <v-col cols="12" md="6">
                            <v-select
                                v-model="selectedForwardRouteId"
                                :items="forwardRouteOptions"
                                item-title="label"
                                item-value="route_id"
                                label="Proceed / Forward actions"
                                clearable
                                :disabled="saving"
                            />
                        </v-col>

                        <v-col cols="12" md="6">
                            <v-select
                                v-model="selectedReturnRouteId"
                                :items="returnRouteOptions"
                                item-title="label"
                                item-value="route_id"
                                label="Return actions"
                                clearable
                                :disabled="saving"
                            />
                        </v-col>
                    </v-row>

                    <v-alert v-if="selectedRouteId && missingRequiredLabels.length" type="warning" variant="tonal" class="mt-3 mb-0">
                        Check all required items in the <a href="#checklist">Checklist below</a> to unlock — {{ missingRequiredLabels.join(", ") }}.
                    </v-alert>

                    <v-alert v-if="selectedRouteId && missingRequiredFields.length" type="warning" variant="tonal" class="mt-3 mb-0">
                        Fill in required station info before proceeding — {{ missingRequiredFields.join(", ") }}.
                    </v-alert>

                    <v-row class="mt-1">
                        <v-col cols="12" class="d-flex justify-end">
                            <v-btn
                                color="grey-darken-3"
                                rounded="0"
                                :disabled="!selectedRouteId || saving || (!isReturnSelected && missingRequiredLabels.length > 0) || missingRequiredFields.length > 0"
                                :loading="saving"
                                @click="openProceed()"
                            >
                                Proceed
                            </v-btn>
                        </v-col>
                    </v-row>
                </div>

            </v-card-text>
        </v-card>

        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="tx" id="checklist">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-clipboard-check-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Checklist</span>
                <v-menu
                    open-on-hover
                    :close-on-content-click="false"
                    max-width="520"
                    location="bottom end"
                    open-delay="250"
                >
                    <template #activator="{ props }">
                        <v-btn
                            icon="mdi-help-circle-outline"
                            variant="text"
                            color="grey-darken-3"
                            v-bind="props"
                            class="ml-1"
                        />
                    </template>
                    <v-card rounded="0">
                        <v-card-title class="text-subtitle-1 font-weight-bold pa-4">
                            Station tracking guide
                        </v-card-title>
                        <v-divider />
                        <v-card-text class="pa-4" style="max-height: 420px; overflow-y: auto;">
                            <ChecklistTrackingGuide
                                :stations="tx.station_checklist"
                                :current-step-id="tx.current_step?.id"
                            />
                        </v-card-text>
                    </v-card>
                </v-menu>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">

                <v-alert v-if="!(tx?.station_checklist || []).length" type="info" variant="tonal" class="mb-3">
                    No stations in this process yet.
                </v-alert>

                <div v-else class="mb-3">
                    <v-alert v-if="missingRequiredLabels.length" type="warning" variant="tonal" class="mb-3">
                        Required items missing: {{ missingRequiredLabels.join(", ") }}.
                        You will not be able to execute any action until these are checked.
                    </v-alert>

                    <div class="d-flex flex-column" style="min-height: 510px">
                    <v-data-table
                        v-show="!loading"
                        :headers="reqHeaders"
                        :items="journeyRows"
                        item-key="uid"
                        :row-props="rowProps"
                        :items-per-page="5"
                        :items-per-page-options="[5, 10, 25]"
                        density="compact"
                        hover
                        class="lgu-table"
                    >
                        <template v-slot:[`item.station`]="{ item }">
                            <div class="font-weight-medium text-caption">
                                {{ item.station.order_number }}. {{ item.station.name }}
                                <v-chip v-if="isCurrentRow(item)" rounded="0" size="x-small" class="ml-1" variant="tonal" color="primary">here</v-chip>
                            </div>
                        </template>

                        <template v-slot:[`item.name`]="{ item }">
                            <v-tooltip :disabled="rowRelevant(item)" location="top" max-width="320">
                                <template #activator="{ props }">
                                    <div v-bind="props">
                                        <div class="font-weight-medium" :class="item.is_placeholder ? 'text-medium-emphasis' : ''">
                                            {{ item.definition.name }}
                                            <template v-if="!item.is_placeholder">
                                            <v-chip v-if="item.pivot.is_required" rounded="0" size="small" class="ml-2" variant="tonal" color="error"><v-icon start size="small">mdi-asterisk</v-icon>required</v-chip>
                                            <v-chip v-else rounded="0" size="small" class="ml-2" variant="tonal" color="grey"><v-icon start size="small">mdi-minus-circle</v-icon>optional</v-chip>
                                            </template>
                                        </div>
                                        <div class="text-caption" v-if="item.definition.description">
                                            {{ item.definition.description }}
                                        </div>
                                    </div>
                                </template>
                                {{ waitText(item) }}
                            </v-tooltip>
                        </template>

                        <template v-slot:[`item.who`]="{ item }">
                            <div class="d-flex flex-wrap ga-1">
                                <v-chip
                                    v-for="r in (item.station.roles || [])"
                                    :key="r.id || r.code"
                                    rounded="0"
                                    size="x-small"
                                    variant="tonal"
                                    color="grey-darken-3"
                                >
                                    {{ r.name || r.code }}
                                </v-chip>
                                <span v-if="!(item.station.roles || []).length" class="text-caption text-medium-emphasis">—</span>
                            </div>
                        </template>

                        <template v-slot:[`item.status`]="{ item }">
                            <span v-if="item.is_placeholder" class="text-caption text-medium-emphasis">—</span>
                            <template v-else>
                            <v-chip rounded="0" size="small" variant="tonal" :color="item.checked ? 'success' : 'grey'">
                                <v-icon start size="small">{{ item.checked ? 'mdi-check-circle' : 'mdi-clock-outline' }}</v-icon>
                                {{ item.checked ? "checked" : "unchecked" }}
                            </v-chip>
                            <v-chip v-if="item.attachment_count" rounded="0" size="x-small" variant="tonal" color="grey-darken-3" class="ml-1">
                                <v-icon start size="x-small">mdi-paperclip</v-icon>{{ item.attachment_count }}
                            </v-chip>
                            <div class="text-caption" v-if="item.checked_at">
                                {{ item.checked_by?.name }} • {{ item.checked_at }}
                            </div>
                            <AttachmentList :items="item.attachments || []" :tx-id="route.params.id" compact @deleted="removeAttachment" />
                            </template>
                        </template>

                        <template v-slot:[`item.actions`]="{ item }">
                            <span v-if="item.is_placeholder" class="text-caption text-medium-emphasis">—</span>
                            <div v-else-if="isCurrentRow(item)" class="d-flex ga-3 justify-end">
                            <v-btn
                                v-if="!item.checked"
                                size="small"
                                color="grey-darken-3"
                                rounded="0"
                                :disabled="savingChecklist"
                                :loading="savingChecklist && savingRequirementId === item.definition.id"
                                @click="openCheck(item)"
                            >
                                Check
                            </v-btn>

                            <template v-else>
                            <v-tooltip location="top" max-width="320">
                                <template #activator="{ props }">
                                    <v-btn
                                        icon="mdi-help-circle-outline"
                                        size="small"
                                        variant="text"
                                        color="grey-darken-3"
                                        v-bind="props"
                                    />
                                </template>
                                <div class="font-weight-bold text-caption mb-1">Recorded info</div>
                                <div v-for="row in (tx?.current_step_fields || [])" :key="row.definition.id" class="d-flex justify-space-between ga-3">
                                    <span class="text-caption text-medium-emphasis">{{ row.definition.name }}</span>
                                    <span class="text-caption font-weight-bold text-right">{{ displayValue(form[row.definition.code]) }}</span>
                                </div>
                                <div v-if="!(tx?.current_step_fields || []).length" class="text-caption text-medium-emphasis">
                                    No info fields on this station.
                                </div>
                            </v-tooltip>
                            <v-btn
                                size="small"
                                rounded="0"
                                color="warning"
                                :disabled="savingChecklist || !canUncheck(item)"
                                :loading="savingChecklist && savingRequirementId === item.definition.id"
                                @click="openUncheck(item)"
                            >
                                Uncheck
                            </v-btn>
                            </template>
                            </div>
                        </template>
                    </v-data-table>
                    <TableLoader v-if="loading" label="checklist" compact style="flex: 1 1 auto" />
                    </div>
                </div>

            </v-card-text>
        </v-card>

        <!-- Step Form card hidden: entry lives in the Check/Proceed modals. Flip v-if back to restore. -->
        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="false">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-form-textbox</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Step Form</span>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">

                <v-alert v-if="!tx.current_step_fields?.length" type="info" variant="tonal" class="mb-3">
                    No fields assigned to this step.
                </v-alert>

                <v-row v-else>
                    <StepInfoFields :fields="tx.current_step_fields" :form="form" />
                </v-row>

            </v-card-text>
        </v-card>

        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="tx">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-history</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">History</span>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">
                <div class="d-flex flex-column" style="min-height: 510px">
                <v-data-table v-show="!loading" :headers="runHeaders" :items="tx.runs || []" item-key="id" density="compact" height="450" fixed-header :items-per-page="25" hover class="lgu-table">
                    <template v-slot:[`item.from_step`]="{ item }">
                        {{ item.from_step?.name }} ({{ item.from_step?.code }})
                    </template>
                    <template v-slot:[`item.to_step`]="{ item }">
                        {{ item.to_step?.name }} ({{ item.to_step?.code }})
                    </template>
                    <template v-slot:[`item.performed_by`]="{ item }">
                        {{ item.performed_by?.name }}
                    </template>
                    <template v-slot:[`item.files`]="{ item }">
                        <AttachmentList :items="item.attachments || []" :tx-id="route.params.id" compact @deleted="removeAttachment" />
                    </template>
                </v-data-table>
                <TableLoader v-if="loading" label="history" compact style="flex: 1 1 auto" />
                </div>
            </v-card-text>
        </v-card>

        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="tx">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-paperclip</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Attached Files</span>
                <v-chip size="small" variant="tonal" class="ml-2">{{ (tx.attachments || []).length }}</v-chip>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-4">
                <AttachmentList :items="tx.attachments || []" :tx-id="route.params.id" @deleted="removeAttachment" />
            </v-card-text>
        </v-card>

        <v-dialog v-model="remarksDialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>
                    Proceed
                    <div v-if="selectedActionLabel" class="text-caption text-medium-emphasis font-weight-bold">{{ selectedActionLabel }}</div>
                </v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="tx?.current_step_fields" :form="form" />
                    <div v-if="!(tx?.current_step_fields || []).length" class="text-caption text-medium-emphasis mb-3">
                        No info fields on this station — remarks only.
                    </div>
                    <v-textarea v-model="remarks" label="Remarks (optional)" rows="4" class="mt-2" />
                    <v-divider class="my-3" />
                    <AttachmentUploader :tx-id="route.params.id" v-model="proceedAttachments" @deleted="removeAttachment" />
                    <v-alert v-if="executeError" type="error" variant="tonal" class="mt-3">
                        {{ executeError }}
                    </v-alert>
                    <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" class="mt-3">
                        Fill in required station info: {{ missingRequiredFields.join(", ") }}.
                    </v-alert>
                    <v-alert v-if="missingRequiredLabels.length" type="warning" variant="tonal" class="mt-3">
                        Required items missing: {{ missingRequiredLabels.join(", ") }}.
                    </v-alert>
                    <v-alert v-else-if="!missingRequiredFields.length" type="info" variant="tonal" class="mt-3">
                        Station info and remarks will be saved together with this move.
                    </v-alert>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="remarksDialog = false">Cancel</v-btn>
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" :disabled="!selectedRouteId || (!isReturnSelected && missingRequiredLabels.length > 0) || missingRequiredFields.length > 0" @click="executeSelected">Proceed</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="checkDialog" max-width="700">
            <v-card rounded="0">
                <v-card-title>Check: {{ checkTarget?.definition?.name }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-body-2 mb-3">Tick this item as done?</div>
                    <v-divider class="my-3" />
                    <AttachmentUploader
                        :tx-id="route.params.id"
                        :requirement-id="checkTarget?.definition?.id"
                        v-model="checkAttachments"
                        @deleted="removeAttachment"
                    />
                    <v-expansion-panels variant="accordion" class="mt-3">
                        <v-expansion-panel rounded="0" :title="checkInfoTitle">
                            <template #text>
                                <StepInfoFields :fields="tx?.current_step_fields" :form="form" />
                                <div v-if="!(tx?.current_step_fields || []).length" class="text-caption text-medium-emphasis">
                                    N/A — no info fields on this station.
                                </div>
                                <v-alert v-if="missingRequiredFields.length" type="warning" variant="tonal" class="mt-3">
                                    Required before checking: {{ missingRequiredFields.join(", ") }}.
                                </v-alert>
                                <v-alert v-else type="info" variant="tonal" class="mt-3">
                                    Anything entered is kept on this page and saved together when you Proceed.
                                </v-alert>
                            </template>
                        </v-expansion-panel>
                    </v-expansion-panels>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="checkDialog = false">Cancel</v-btn>
                    <v-btn color="grey-darken-3" rounded="0" :loading="savingChecklist" :disabled="missingRequiredFields.length > 0" @click="confirmCheck">Check item</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="uncheckDialog" max-width="600">
            <v-card rounded="0">
                <v-card-title>Uncheck: {{ uncheckTarget?.definition?.name }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-subtitle-2 font-weight-bold mb-2">Recorded info (kept as-is)</div>
                    <div v-for="row in (tx?.current_step_fields || [])" :key="row.definition.id" class="d-flex justify-space-between ga-3 py-1">
                        <span class="text-caption text-medium-emphasis">{{ row.definition.name }}</span>
                        <span class="text-caption font-weight-bold text-right">{{ displayValue(form[row.definition.code]) }}</span>
                    </div>
                    <div v-if="!(tx?.current_step_fields || []).length" class="text-caption text-medium-emphasis">
                        N/A — no info fields on this station.
                    </div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="uncheckDialog = false">Cancel</v-btn>
                    <v-btn color="warning" rounded="0" :loading="savingChecklist" @click="confirmUncheck">Uncheck item</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { onMounted, ref, computed, watch } from "vue";
import { useRoute } from "vue-router";
import { useMyTransactions } from "@/composables/useMyTransactions";
import { useAuth } from "@/composables/useAuth";
import TableLoader from '@/components/TableLoader.vue';
import StepProgress from '@/components/StepProgress.vue';
import ChecklistTrackingGuide from '@/components/ChecklistTrackingGuide.vue';
import StepInfoFields from '@/components/StepInfoFields.vue';
import AttachmentUploader from '@/components/AttachmentUploader.vue';
import AttachmentList from '@/components/AttachmentList.vue';

const route = useRoute();
const auth = useAuth();
const {
    getOne,
    execute,
    checkRequirement: apiCheckRequirement,
    uncheckRequirement: apiUncheckRequirement,
} = useMyTransactions();

const tx = ref(null);
const availableActions = ref([]);
const saving = ref(false);
const loading = ref(true);
const error = ref("");
const executeError = ref("");

function formatApiError(e, fallback) {
    const errs = e?.response?.data?.errors;
    if (errs) {
        const detail = Object.values(errs).flat().join(" ");
        if (detail) return `${e?.response?.data?.message || fallback} ${detail}`;
    }
    return e?.response?.data?.message || fallback;
}

const remarksDialog = ref(false);
const selectedForwardRouteId = ref(null);
const selectedReturnRouteId = ref(null);
const proceedAttachments = ref([]);
const checkAttachments = ref([]);

const selectedRouteId = computed(() => selectedForwardRouteId.value ?? selectedReturnRouteId.value);
// Proceed vs Return are mutually exclusive: picking one clears the other.
watch(selectedForwardRouteId, (v) => {
    if (v != null && selectedReturnRouteId.value !== null) selectedReturnRouteId.value = null;
});
watch(selectedReturnRouteId, (v) => {
    if (v != null && selectedForwardRouteId.value !== null) selectedForwardRouteId.value = null;
});
const isReturnSelected = computed(() =>
    (availableActions.value || []).some(
        (a) => Number(a.route_id) === Number(selectedRouteId.value) && !!a.is_return_route,
    ),
);
// Return autofill: show every file on the transaction (including previous
// stations and already-linked runs) so the user sees what travels back.
// Forward actions start empty on purpose.
function returnAttachments() {
    return [...(tx.value?.attachments || [])];
}
const remarks = ref("");

const form = ref({});

const savingChecklist = ref(false);
const savingRequirementId = ref(null);

const reqHeaders = [
    { title: "Station", key: "station", sortable: false },
    { title: "Requirement", key: "name", sortable: false },
    { title: "Who", key: "who", sortable: false },
    { title: "Status", key: "status", sortable: false },
    { title: "", key: "actions", sortable: false },
];

// Full journey: every station appears in one table, even stations with
// no checklist labels (placeholder row). Rows outside the viewer's roles
// are dimmed with a wait hint; Check/Uncheck stays on the current station
// only (backend enforces the same rule). Placeholders never block Proceed.
const journeyRows = computed(() => {
    const out = [];
    for (const s of (tx.value?.station_checklist || [])) {
        const reqs = s.requirements || [];
        if (!reqs.length) {
            out.push({
                uid: `${s.step.id}:empty`,
                station: s.step,
                definition: { id: `empty-${s.step.id}`, name: "No checklist items", description: null, code: "—" },
                pivot: { display_order: 0, is_required: false },
                checked: false,
                checked_at: null,
                checked_by: null,
                is_placeholder: true,
            });
            continue;
        }
        for (const r of reqs) {
            out.push({
                uid: `${s.step.id}:${r.definition.id}`,
                station: s.step,
                definition: r.definition,
                pivot: r.pivot,
                checked: r.checked,
                checked_at: r.checked_at,
                checked_by: r.checked_by,
                attachments: r.attachments || [],
                attachment_count: r.attachment_count ?? (r.attachments || []).length,
                is_placeholder: false,
            });
        }
    }
    return out;
});

const myRoleCodes = computed(() =>
    new Set((auth.user.value?.roles || []).map((r) => r.code)),
);

function rowRelevant(row) {
    if (isSuperadmin()) return true;
    if (Number(row.station?.id) === Number(tx.value?.current_step?.id)) return true;
    return (row.station?.roles || []).some((r) => myRoleCodes.value.has(r.code));
}

function rowProps({ item }) {
    return { class: rowRelevant(item) ? "" : "row-dim" };
}

function isCurrentRow(row) {
    return Number(row.station?.id) === Number(tx.value?.current_step?.id);
}

function waitText(row) {
    const st = row.station || {};
    const who = (st.roles || []).map((r) => r.name || r.code).filter(Boolean).join(" / ");
    return `Waiting — handled at Station ${st.order_number} · ${st.name}${who ? ` (${who})` : ""}.`;
}

const runHeaders = [
    { title: "From", key: "from_step", sortable: false },
    { title: "To", key: "to_step", sortable: false },
    { title: "Action", key: "action_code" },
    { title: "Remarks", key: "remarks" },
    { title: "Files", key: "files", sortable: false },
    { title: "By", key: "performed_by", sortable: false },
    { title: "At", key: "performed_at" },
];

function isSuperadmin() {
    const roles = auth.user.value?.roles || [];
    return roles.some((r) => r.code === "superadmin");
}

function canUncheck(item) {
    if (!item?.checked) return false;
    const me = auth.user.value?.id;
    const checkerId = item?.checked_by?.id;
    return isSuperadmin() || (me && checkerId && me === checkerId);
}

function componentFor(type) {
    switch (type) {
        case "textarea": return "v-textarea";
        case "select": return "v-select";
        case "multiselect": return "v-select";
        case "boolean": return "v-switch";
        default: return "v-text-field";
    }
}

function inputTypeFor(type) {
    if (type === "number" || type === "currency") return "number";
    if (type === "date") return "date";
    return "text";
}

function hydrateForm() {
    const next = {};
    for (const row of tx.value?.current_step_fields ?? []) {
        const def = row.definition;
        const val = row.value;

        if (def.type === "multiselect") next[def.code] = Array.isArray(val) ? val : [];
        else if (def.type === "boolean") next[def.code] = !!val;
        else next[def.code] = val ?? null;
    }
    form.value = next;
}

// Transaction stations flattened depth-first so sub-steps (1.1…)
// read in hierarchy order instead of global order_number sort.
const flatStationItems = computed(() => {
    const list = tx.value?.workflow_steps || [];
    const byId = new Map(list.map((s) => [s.id, s]));
    const byParent = new Map();
    for (const s of list) {
        const key = s.parent_id ?? 0;
        if (!byParent.has(key)) byParent.set(key, []);
        byParent.get(key).push(s);
    }
    for (const arr of byParent.values()) {
        arr.sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0));
    }
    const out = [];
    const walk = (key) => {
        for (const s of (byParent.get(key) || [])) {
            out.push(s);
            walk(s.id);
        }
    };
    walk(0);
    for (const s of list) {
        if (s.parent_id && !byId.has(s.parent_id) && !out.includes(s)) out.push(s);
    }
    return out;
});

const missingRequiredLabels = computed(() => {
    const reqs = tx.value?.current_step_requirements ?? [];
    return reqs
        .filter((r) => r?.pivot?.is_required && !r.checked)
        .map((r) => r.definition?.name)
        .filter(Boolean);
});

// Required station-info fields still empty in the draft form. These fail
// server-side validation on Proceed (e.g. Request Title, Office Name,
// Amount), so warn and block Proceed until filled.
const missingRequiredFields = computed(() => {
    const out = [];
    for (const row of tx.value?.current_step_fields ?? []) {
        if (!row?.definition?.required) continue;
        const v = form.value?.[row.definition.code];
        const empty = v === null || v === undefined || v === "" ||
            (Array.isArray(v) && v.length === 0);
        if (empty) out.push(row.definition.name);
    }
    return out;
});

// Title for the Check-modal station-info panel: required when the step
// has required fields, N/A when the station has no info fields at all.
const checkInfoTitle = computed(() => {
    if (!(tx.value?.current_step_fields || []).length) return "Station info (N/A)";
    if (missingRequiredFields.value.length) return "Station info (required)";
    return "Add station info (optional)";
});

async function load() {
    loading.value = true;
    error.value = "";
    try {
        const res = await getOne(route.params.id);
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        hydrateForm();

        const allIds = new Set((availableActions.value || []).map((a) => a.route_id));
        if (!allIds.has(selectedForwardRouteId.value)) selectedForwardRouteId.value = null;
        if (!allIds.has(selectedReturnRouteId.value)) selectedReturnRouteId.value = null;
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load transaction.";
    } finally {
        loading.value = false;
    }
}

function openProceed() {
    remarks.value = "";
    // Return actions autofill every transaction file so the user sees
    // what will travel back; forward actions start empty.
    proceedAttachments.value = isReturnSelected.value
        ? [...returnAttachments()]
        : [];
    executeError.value = "";
    remarksDialog.value = true;
}

async function executeSelected() {
    saving.value = true;
    error.value = "";
    executeError.value = "";

    try {
        const payloadFields = { ...form.value };

        for (const row of tx.value?.current_step_fields ?? []) {
            const def = row.definition;

            if (def.type === "multiselect" && !Array.isArray(payloadFields[def.code])) {
                payloadFields[def.code] = [];
            }

            if ((def.type === "number" || def.type === "currency") &&
                payloadFields[def.code] !== null &&
                payloadFields[def.code] !== "") {
                payloadFields[def.code] = Number(payloadFields[def.code]);
            }

            if (def.type === "boolean") {
                payloadFields[def.code] = !!payloadFields[def.code];
            }
        }

        const res = await execute(route.params.id, {
            route_id: selectedRouteId.value,
            remarks: remarks.value || null,
            field_values: payloadFields,
            attachment_ids: (proceedAttachments.value || []).map((a) => a.id),
        });

        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        remarksDialog.value = false;
        proceedAttachments.value = [];
        hydrateForm();
    } catch (e) {
        const msg = formatApiError(e, "Execute failed.");
        error.value = msg;
        executeError.value = msg;
    } finally {
        saving.value = false;
    }
}

async function checkRequirement(requirementId) {
    savingChecklist.value = true;
    savingRequirementId.value = requirementId;
    error.value = "";
    try {
        const res = await apiCheckRequirement(route.params.id, requirementId);
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        // Keep staged (unsent) info: fields only persist on Proceed, so do
        // NOT rebuild the form from server values here — that would wipe
        // what was just typed in the Check modal.
    } catch (e) {
        error.value = e?.response?.data?.message || "Checklist check failed.";
    } finally {
        savingChecklist.value = false;
        savingRequirementId.value = null;
    }
}

async function uncheckRequirement(requirementId) {
    savingChecklist.value = true;
    savingRequirementId.value = requirementId;
    error.value = "";
    try {
        const res = await apiUncheckRequirement(route.params.id, requirementId);
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        // Same as check: preserve staged info, server has no newer values.
    } catch (e) {
        error.value = e?.response?.data?.message || "Checklist uncheck failed.";
    } finally {
        savingChecklist.value = false;
        savingRequirementId.value = null;
    }
}

const forwardActions = computed(() => (availableActions.value || []).filter((a) => !a.is_return_route));
const returnActions = computed(() => (availableActions.value || []).filter((a) => !!a.is_return_route));

function labelForAction(a) {
    const to = a?.to_step?.name ? `${a.to_step.name} (${a.to_step.code})` : `Step #${a.to_step_id ?? ""}`;
    const group = a?.route_group ? ` • ${a.route_group}` : "";
    const approvals = a?.required_approvals_count ? ` • approvals: ${a.required_approvals_count}` : "";
    return `${a.action_code} → ${to}${group}${approvals}`;
}

const forwardRouteOptions = computed(() =>
    forwardActions.value.map((a) => ({ route_id: a.route_id, label: labelForAction(a) })),
);

const returnRouteOptions = computed(() =>
    returnActions.value.map((a) => ({ route_id: a.route_id, label: labelForAction(a) })),
);

const selectedActionLabel = computed(() => {
    const a = (availableActions.value || []).find((x) => x.route_id === selectedRouteId.value);
    return a ? labelForAction(a) : "";
});

// Check/Uncheck modals. Info fields bind the same page `form` object, so
// anything typed in the Check modal is staged locally and only saved
// together with Proceed (the check endpoint takes no field payload).
const checkDialog = ref(false);
const uncheckDialog = ref(false);
const checkTarget = ref(null);
const uncheckTarget = ref(null);

function openCheck(item) {
    checkTarget.value = item;
    checkAttachments.value = [];
    checkDialog.value = true;
}

function openUncheck(item) {
    uncheckTarget.value = item;
    uncheckDialog.value = true;
}

async function confirmCheck() {
    if (!checkTarget.value) return;
    checkDialog.value = false;
    await checkRequirement(checkTarget.value.definition.id);
    checkAttachments.value = [];
}

async function confirmUncheck() {
    if (!uncheckTarget.value) return;
    uncheckDialog.value = false;
    await uncheckRequirement(uncheckTarget.value.definition.id);
}

function displayValue(v) {
    if (v === null || v === undefined || v === "") return "N/A";
    if (typeof v === "object") {
        try { return JSON.stringify(v); } catch { return String(v); }
    }
    return String(v);
}

// Prune a superadmin-deleted attachment from every local list so the UI
// stays in sync without a full reload (which would wipe staged form input).
function removeAttachment(id) {
    proceedAttachments.value = (proceedAttachments.value || []).filter((a) => a.id !== id);
    checkAttachments.value = (checkAttachments.value || []).filter((a) => a.id !== id);
    if (tx.value?.attachments) tx.value.attachments = tx.value.attachments.filter((a) => a.id !== id);
    for (const s of (tx.value?.station_checklist || [])) {
        if (s.attachments) s.attachments = s.attachments.filter((a) => a.id !== id);
        for (const r of (s.requirements || [])) {
            if (r.attachments) {
                r.attachments = r.attachments.filter((a) => a.id !== id);
                r.attachment_count = r.attachments.length;
            }
        }
    }
    for (const r of (tx.value?.current_step_requirements || [])) {
        if (r.attachments) {
            r.attachments = r.attachments.filter((a) => a.id !== id);
            r.attachment_count = r.attachments.length;
        }
    }
    for (const run of (tx.value?.runs || [])) {
        if (run.attachments) run.attachments = run.attachments.filter((a) => a.id !== id);
    }
}

onMounted(load);
</script>

<style scoped>
.row-dim {
    opacity: 0.55;
}
</style>
