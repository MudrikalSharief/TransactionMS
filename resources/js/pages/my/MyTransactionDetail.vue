<template>
    <div>
        <LoadingVeil :show="!tx && loading" label="transaction" icon="mdi-file-document-outline" />
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                    <v-icon color="#1E40AF">mdi-file-document</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">
                    Transaction: <b>{{ tx?.reference_number }}</b>
                    <span v-if="tx?.title"> — {{ tx.title }}</span>
                </span>
                <v-spacer />
                <v-btn variant="text" @click="$router.push('/my/transactions')">Back</v-btn>
            </v-card-title>

            <v-divider />

            <v-card-text v-if="tx" class="pa-0">
                <v-row no-gutters>
                    <v-col cols="12" sm="6" class="d-flex align-center ga-3 px-5 py-3">
                        <v-avatar color="primary" variant="tonal" rounded="0" size="34">
                            <v-icon size="20">mdi-shape-outline</v-icon>
                        </v-avatar>
                        <div class="min-w-0">
                            <div class="text-caption text-medium-emphasis">Transaction Type</div>
                            <div class="text-body-1 font-weight-bold">{{ tx.transaction_type?.name }}</div>
                        </div>
                    </v-col>
                    <v-divider class="d-sm-none" />
                    <v-col cols="12" sm="6" class="d-flex align-center ga-3 px-5 py-3 meta-divide">
                        <v-avatar color="primary" variant="tonal" rounded="0" size="34">
                            <v-icon size="20">mdi-source-branch</v-icon>
                        </v-avatar>
                        <div class="min-w-0">
                            <div class="text-caption text-medium-emphasis">Current Step</div>
                            <div class="text-body-1 font-weight-bold">{{ tx.current_step?.name }}</div>
                        </div>
                    </v-col>
                </v-row>

                <v-alert v-if="error" type="error" variant="tonal" class="ma-4 mt-0">{{ error }}</v-alert>

                <v-divider />

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

        <!-- Covered by LoadingVeil above while the transaction loads. -->

        <div v-if="(tx?.workflow_steps || []).length" class="mb-4">
            <StepProgress
                fluid
                preserve-order
                :steps="flatStationItems"
                :current-step-id="tx.current_step?.id"
                :current-step-code="tx.current_step?.code"
                :details="tx.station_checklist"
                :runs="tx.runs"
                :visited-step-ids="visitedStepIds"
                title="Transaction Stations"
            >
                <template #actions v-if="tx">
                    <v-alert v-if="pendingReceipt" type="warning" variant="tonal" class="mb-3">
                        <div class="font-weight-bold">Waiting to be received — sent by {{ pendingReceipt.performed_by?.name || 'Unknown' }} at {{ fmtDateTime(pendingReceipt.released_at || pendingReceipt.performed_at) }}.</div>
                        <div v-if="canAct" class="text-caption">Click Receive to claim this step. The first user with this role to receive is recorded as the receiver.</div>
                        <div v-else class="text-caption">Waiting for {{ tx.current_step?.office?.name || 'the next office' }} to receive it.</div>
                        <v-btn v-if="canAct" color="warning" rounded="0" class="mt-2" :loading="receiving" @click="receiveStep">
                            <v-icon start>mdi-inbox-arrow-down</v-icon>
                            Receive Step
                        </v-btn>
                    </v-alert>
                    <v-alert v-if="isDone" type="success" variant="tonal" class="mb-3">
                        <v-icon start size="small">mdi-flag-checkered</v-icon>
                        This transaction has been finalized — view only.
                    </v-alert>
                    <v-alert v-else-if="noOutgoingRoutes" type="error" variant="tonal" class="mb-3">
                        <div class="font-weight-bold">This step has no outgoing routes — the transaction can't move forward.</div>
                        <div class="text-caption">Ask an admin to link the steps in Workflows (Routes), then publish. Transactions already created stay on the old version — create a new one after publishing.</div>
                        <v-btn v-if="isSuperadmin()" :to="workflowsLink" color="error" variant="outlined" rounded="0" size="small" class="mt-2">
                            <v-icon start size="small">mdi-source-branch</v-icon>
                            Open Workflows
                        </v-btn>
                    </v-alert>
                    <v-alert v-else-if="!hasActionOptions && !showFinalize && !showCompleteStep" type="info" variant="tonal" class="mb-3">
                        No actions available for your role on this step (or route conditions not satisfied).
                        <span v-if="currentStepRoles.length" class="d-block mt-1 text-caption">This step requires role(s): <b>{{ currentStepRoles.join(', ') }}</b>.</span>
                    </v-alert>

                    <div v-else>
                        <RouteFlowPreview
                            v-if="hasActionOptions"
                            :prev-step="tx?.previous_step_context?.step ?? null"
                            :current-step="tx?.current_step ?? null"
                            :dest-step="selectedRouteId ? destStepForTitle() : null"
                            :workflow-steps="tx?.workflow_steps || []"
                            :direction="!selectedRouteId ? null : (isJumpSelected ? (isJumpForward ? 'resend' : 'return') : (isReturnSelected ? 'return' : 'forward'))"
                            :has-selection="!!selectedRouteId"
                            :hide-previous="isAtFirstStep"
                        />

                        <!-- Station-card missing-files warning hidden: blocking stays in the
                             Proceed modal (upload-required chips + disabled Proceed + backend 422).
                             Remove v-if="false" to restore. -->
                        <v-alert v-if="false && selectedRouteId && !isJumpSelected && (missingRequiredUploadLabels.length || missingRequiredChecklistLabels.length)" type="warning" variant="tonal" class="mt-3 mb-0">
                            <div v-if="missingRequiredUploadLabels.length">
                                Missing files for upload-required items — {{ missingRequiredUploadLabels.join(", ") }}.
                            </div>
                            <div v-if="missingRequiredChecklistLabels.length">
                                Unticked required checklist — {{ missingRequiredChecklistLabels.join(", ") }}.
                            </div>
                        </v-alert>

                        <v-row class="mt-1" align="stretch">
                            <v-col v-if="hasActionOptions" cols="12" md="6">
                                <ActionDropdown
                                    :model-value="selectedRouteId"
                                    :items="unifiedRouteOptions"
                                    :disabled="saving"
                                    @update:model-value="onSelectAction"
                                />
                            </v-col>
                            <v-col cols="12" :md="hasActionOptions ? 6 : 12" class="d-flex justify-end ga-2" style="flex-wrap: wrap">
                                <!-- Finalize replaced by Complete Step on the last station -->
                                <v-btn
                                    v-if="false"
                                    variant="outlined"
                                    color="grey-darken-3"
                                    rounded="0"
                                    height="100%"
                                    :disabled="saving"
                                    :loading="saving"
                                    @click="finalizeDialog = true"
                                >
                                    Finalize Transaction
                                </v-btn>
                                <v-btn
                                    v-if="showCompleteStep && !isReturnAction"
                                    color="success"
                                    rounded="0"
                                    append-icon="mdi-flag-checkered"
                                    style="width: 100%; flex: 1 1 auto"
                                    height="100%"
                                    :disabled="saving"
                                    :loading="saving"
                                    @click="openComplete()"
                                >
                                    Complete Step
                                </v-btn>
                                <v-btn
                                    v-if="showCompleteStep && isReturnAction"
                                    color="warning"
                                    rounded="0"
                                    append-icon="mdi-chevron-triple-left"
                                    style="width: 100%; flex: 1 1 auto"
                                    height="100%"
                                    :disabled="!selectedRouteId || saving"
                                    :loading="saving"
                                    @click="isJumpSelected && !isReturnAction ? openJump() : openProceed()"
                                >
                                    {{ actionButtonLabel }}
                                </v-btn>
                                <v-btn
                                    v-if="hasActionOptions && !showCompleteStep"
                                    :color="isReturnAction ? 'warning' : isResendAction ? 'purple-darken-2' : 'primary'"
                                    rounded="0"
                                    :append-icon="isReturnAction ? 'mdi-chevron-triple-left' : 'mdi-chevron-triple-right'"
                                    style="width: 100%; flex: 1 1 auto"
                                    height="100%"
                                    :disabled="!selectedRouteId || saving"
                                    :loading="saving"
                                    @click="isJumpSelected && !isReturnAction ? openJump() : openProceed()"
                                >
                                    {{ actionButtonLabel }}
                                </v-btn>
                            </v-col>
                        </v-row>
                    </div>
                </template>
            </StepProgress>
        </div>

        <!-- Checklist card hidden: checking now lives in the Proceed wizard. Flip v-if back to restore. -->
        <v-card rounded="0" elevation="1" class="lgu-card mb-4" v-if="false" id="checklist">
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
                    No stations in this transaction type yet.
                </v-alert>

                <div v-else class="mb-3">
                    <v-alert v-if="missingRequiredUploadLabels.length || missingRequiredChecklistLabels.length" type="warning" variant="tonal" class="mb-3">
                        <div v-if="missingRequiredUploadLabels.length">
                            Missing files for upload-required items: {{ missingRequiredUploadLabels.join(", ") }}.
                        </div>
                        <div v-if="missingRequiredChecklistLabels.length">
                            Required checklist items not ticked: {{ missingRequiredChecklistLabels.join(", ") }}.
                        </div>
                        You will not be able to proceed until these are done.
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
                            <AttachmentList :items="item.attachments || []" :tx-id="route.params.id" compact :current-step-id="tx?.current_step?.id" @deleted="removeAttachment" />
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
                                :disabled="savingChecklist || viewOnly"
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
                                :disabled="savingChecklist || !canUncheck(item) || viewOnly"
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

        <HistoryAttachmentsTabs
            v-if="tx || loading"
            :runs="tx?.runs || []"
            :loading="loading"
            :tx-id="route.params.id"
            :attachments="tx?.attachments || []"
            :workflow-steps="tx?.workflow_steps || []"
            :current-step-id="tx?.current_step?.id"
            @deleted="removeAttachment"
        />

        <v-dialog v-model="remarksDialog" max-width="800" scrollable>
            <v-card rounded="xl" style="overflow: hidden">
                <div class="px-6 pt-4"><StepBadge :tx="tx" modern /></div>
                <v-card-title :class="[{ 'text-warning': isReturnAction || isReturnMode }, 'd-flex', 'align-center', 'ga-2']">
                    <span>{{ displayModalTitle }}</span>
                    <v-spacer />
                    <v-btn v-if="!isReturnMode && !isAtFirstStep" size="small" variant="outlined" rounded="lg" color="warning" prepend-icon="mdi-arrow-left" @click="toggleWizardMode">Return</v-btn>
                    <v-btn v-else-if="!isAtFirstStep" size="small" variant="outlined" rounded="lg" color="grey-darken-3" prepend-icon="mdi-arrow-right" @click="toggleWizardMode">Proceed</v-btn>
                </v-card-title>
                <v-divider />
                <v-card-text class="proceed-scroll">
                    <div v-if="isReturnMode" class="mb-3">
                        <ActionDropdown
                            :model-value="selectedRouteId"
                            :items="returnPickerOptions"
                            label="Select where to return"
                            placeholder="Choose a station"
                            :disabled="saving"
                            @update:model-value="onSelectAction"
                        />
                    </div>
                    <ProceedWizard
                        ref="wizardRef"
                        v-model:step="wizardStep"
                        v-model:remarks="remarks"
                        v-model:proceed-attachments="proceedAttachments"
                        v-model:attachment-name="attachmentName"
                        :tx-id="route.params.id"
                        :current-step-id="tx?.current_step?.id"
                        :requirements="tx?.current_step_requirements || []"
                        :existing-attachments="tx?.attachments || []"
                        :current-step-order="tx?.current_step?.order_number"
                        :workflow-steps="tx?.workflow_steps || []"
                        :checklist="effectiveChecklist"
                        :fields="tx?.current_step_fields"
                        :form="form"
                        v-model:step-data-form="stepDataForm"
                        v-model:flagged="returnFlags"
                        :step-data="tx?.current_step_data || []"
                        :prev-context="tx?.previous_step_context || null"
                        modern
                        :single-page="isAtFirstStep"
                        :selected-action-label="isCompleting ? 'Complete Step' : selectedActionLabel"
                        :selected-route-id="isCompleting ? null : selectedRouteId"
                        :is-return-selected="isCompleting ? false : (isReturnMode || isReturnSelected)"
                        :is-completing="isCompleting"
                        :show-checklist="isCompleting ? true : !skipReview"
                        :missing-required-upload-labels="missingRequiredUploadLabels"
                        :missing-required-tick-labels="missingRequiredTickLabels"
                        :missing-required-checklist-labels="isCompleting ? missingRequiredCompleteLabels : missingRequiredChecklistLabels"
                        :missing-required-fields="missingRequiredFields"
                        :execute-error="executeError"
                        :saving="saving"
                        :saving-checklist="savingChecklist"
                        :saving-checklist-item-id="savingChecklistItemId"
                        :saving-requirement-id="savingRequirementId"
                        :remarks-label="isReturnMode ? 'Reason for returning (required)' : (autoReturnInfo?.sender ? `Reply to ${autoReturnInfo.sender} (optional)` : 'Remarks (optional)')"
                        remarks-placeholder="Explain what you changed or fixed"
                        attachments-title="Additional files"
                        @toggle-requirement="onWizardToggle"
                        @toggle-checklist="onWizardChecklistToggle"
                        @requirement-uploaded="refreshTxPreservingForm"
                        @attachment-deleted="removeAttachment"
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="align-center ga-2 px-6 py-4">
                    <div class="mr-auto">
                        <template v-if="footerStatus.ok">
                            <span class="font-weight-bold text-success">{{ footerStatus.title }}</span>
                            <span class="text-success"> {{ footerStatus.message }}</span>
                        </template>
                        <template v-else-if="footerStatus.titleOnly">
                            <span class="font-weight-bold text-error">{{ footerStatus.title }}</span>
                        </template>
                        <template v-else>
                            <div class="font-weight-bold text-error">{{ footerStatus.title }}</div>
                            <div class="text-body-2 text-medium-emphasis">{{ footerStatus.message }}</div>
                        </template>
                    </div>
                    <v-btn variant="outlined" rounded="lg" @click="remarksDialog = false">Cancel</v-btn>
                    <v-btn v-if="!isCompleting && wizardStep === 2 && !isSingleStepProceed && !skipReview" variant="outlined" rounded="lg" @click="wizardStep = 1">Back</v-btn>
                    <v-btn v-if="isCompleting && wizardStep === 2 && !isSingleStepProceed" variant="outlined" rounded="lg" @click="wizardStep = 1">Back</v-btn>
                    <v-btn v-if="!isCompleting && showNextBtn" variant="outlined" rounded="lg" :disabled="saving || savingChecklist" @click="goWizardNext">Next</v-btn>
                    <v-btn v-if="!isReturnMode && !isCompleting && isReturnAction && wizardStep === 1 && !isSingleStepProceed && !skipReview" color="warning" rounded="lg" :loading="saving" :disabled="returnSubmitDisabled" @click="isJumpSelected ? openJump() : executeSelected()">Return</v-btn>
                    <v-btn v-if="isCompleting && wizardStep === 1 && !isSingleStepProceed" variant="outlined" rounded="lg" :disabled="saving || savingChecklist" @click="goWizardNext">Next</v-btn>
                    <v-btn v-if="isCompleting && !isReturnMode && (wizardStep === 2 || isSingleStepProceed)" color="success" rounded="lg" :loading="saving" :disabled="completeBlocked" @click="finalizeTx">Complete Step</v-btn>
                    <template v-if="isReturnMode">
                        <v-btn color="warning" rounded="lg" :loading="saving" :disabled="returnSubmitDisabled" @click="isJumpSelected ? returnViaJump() : executeSelected()">Return</v-btn>
                    </template>
                    <v-btn v-else-if="!isCompleting && (wizardStep === 2 || skipReview)" :color="isReturnAction ? 'warning' : isResendAction ? 'purple-darken-2' : 'black'" rounded="lg" :loading="saving" :disabled="proceedDisabled" @click="executeSelected">{{ proceedButtonLabel }}</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <JumpBackDialog
            v-model:open="jumpDialog"
            :current-label="jumpCurrentLabel"
            :destination-label="jumpDestinationLabel"
            :subject="tx?.title || ''"
            :confirm-label="mainActionButtonLabel"
            :saving="saving"
            :is-forward="isJumpForward"
            :checklist="tx?.current_step_checklist || []"
            @confirm="confirmJump"
        />

        <ConfirmActionDialog
            v-model:open="finalizeDialog"
            title="Finalize transaction?"
            message="This marks the transaction done and locks it to view-only."
            confirm-label="Finalize Transaction"
            confirm-color="success"
            :saving="saving"
            @confirm="finalizeTx"
        />

        <v-dialog v-model="checkDialog" max-width="700">
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title>Check: {{ checkTarget?.definition?.name }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-body-2 mb-3">Tick this item as done?</div>
                    <v-divider class="my-3" />
                    <AttachmentUploader
                        :tx-id="route.params.id"
                        :requirement-id="checkTarget?.definition?.id"
                        v-model="checkAttachments"
                        :disabled="viewOnly"
                        file-action="download"
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
            <v-card rounded="xl" style="overflow: hidden">
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

        <!-- End-of-transaction footer: same deep-blue bar as the dashboard foot. -->
        <v-sheet v-if="tx" color="#1E3A8A" rounded="0" class="pa-4 mt-6 d-flex align-center justify-center ga-3 text-center">
            <v-avatar color="white" rounded="0" size="52" class="lgu-head-avatar">
                <v-icon color="#1E40AF" size="32">mdi-flag-checkered</v-icon>
            </v-avatar>
            <v-divider vertical :thickness="2" color="white" opacity="0.6" style="height: 48px" />
            <div class="text-left">
                <div class="text-h6 font-weight-bold text-white lh-1">END OF TRANSACTION</div>
                <div class="text-caption" style="color: rgba(255, 255, 255, 0.75)">TRANSACTION: {{ tx.reference_number }}</div>
            </div>
        </v-sheet>
    </div>
</template>

<script setup>
import { onMounted, ref, computed, watch } from "vue";
import { useRoute } from "vue-router";
import { useMyTransactions } from "@/composables/useMyTransactions";
import { useAuth, isSuperadminUser, isOfficeAdminUser } from "@/composables/useAuth";
import { useApi } from "@/composables/useApi";
import TableLoader from '@/components/TableLoader.vue';
import LoadingVeil from '@/components/LoadingVeil.vue';
import StepProgress from '@/components/StepProgress.vue';
import ActionDropdown from '@/components/ActionDropdown.vue';
import RouteFlowPreview from '@/components/RouteFlowPreview.vue';
import JumpBackDialog from '@/components/JumpBackDialog.vue';
import ConfirmActionDialog from '@/components/ConfirmActionDialog.vue';
import ChecklistTrackingGuide from '@/components/ChecklistTrackingGuide.vue';
import StepInfoFields from '@/components/StepInfoFields.vue';
import ProceedWizard from '@/components/ProceedWizard.vue';
import ReturnBanner from '@/components/ReturnBanner.vue';
import StepBadge from '@/components/StepBadge.vue';
import AttachmentUploader from '@/components/AttachmentUploader.vue';
import AttachmentList from '@/components/AttachmentList.vue';
import HistoryAttachmentsTabs from '@/components/HistoryAttachmentsTabs.vue';
import { fmtDateTime } from '@/utils/dates';

const route = useRoute();
const auth = useAuth();
const { api } = useApi();
const {
    getOne,
    execute,
    receive,
    gotoStation: gotoStationApi,
    finalize: finalizeApi,
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
// Return reason captured when a backward receive auto-opens Proceed.
// Shown under the modal title; cleared whenever the modal closes so
// manual Proceed opens never show a stale banner.
const autoReturnInfo = ref(null);
watch(remarksDialog, (open) => { if (!open) { autoReturnInfo.value = null; isCompleting.value = false; wizardMode.value = 'proceed'; stashedProceedAttachments.value = null; } });
const wizardStep = ref(1);
// UI-only Proceed/Return mode toggle in the Proceed modal (no backend:
// return mode reuses the same wizard shell with return styling/copy).
const wizardMode = ref('proceed');
const isReturnMode = computed(() => wizardMode.value === 'return');
const returnModalTitle = computed(() => {
    const dest = destStepForTitle();
    if (selectedRouteId.value && isReturnAction.value && dest) {
        const n = dest?.order_number ?? '';
        const name = dest?.name || dest?.code || '';
        if (n !== '' || name) return `Return to Step ${n} · ${name}`.trim();
    }
    const cur = tx.value?.current_step;
    const n = cur?.order_number ?? '';
    const name = cur?.name || cur?.code || '';
    return (n !== '' || name) ? `Return from Step ${n} · ${name}`.trim() : 'Return';
});
const displayModalTitle = computed(() => {
    if (isReturnMode.value) return returnModalTitle.value;
    if (isCompleting.value) return completeModalTitle.value;
    return proceedModalTitle.value;
});
// Stash the forward pick before Return clears it, so toggling back to
// Proceed restores "Proceed to ..." instead of plain "Proceed".
const stashedProceedRouteId = ref(null);
// Same stash idea for the staged "Additional files": entering Return
// clears the list; toggling back restores Proceed's.
const stashedProceedAttachments = ref(null);
function defaultForwardRouteId() {
    const forwards = forwardActions.value || [];
    if (!forwards.length) return null;
    if (forwards.length === 1) return forwards[0].route_id;
    const curOrder = Number(tx.value?.current_step?.order_number);
    if (Number.isFinite(curOrder)) {
        const next = forwards.find((a) => Number(a?.to_step?.order_number) === curOrder + 1);
        if (next) return next.route_id;
    }
    return forwards[0].route_id;
}
function toggleWizardMode() {
    const toReturn = !isReturnMode.value;
    wizardMode.value = toReturn ? 'return' : 'proceed';
    // Return stages uploads on the Requirements page — move the stepper
    // dot there. Proceed restarts on Review (or Requirements for step 1).
    if (toReturn) {
        // Remember the forward pick so Proceed toggle-back restores it.
        if (selectedRouteId.value != null && !isReturnAction.value) {
            stashedProceedRouteId.value = selectedRouteId.value;
        }
        // Return's "Additional files" starts empty — only files the user
        // uploads or links there. The returning step's own files still
        // travel back (stamped server-side), so nothing is orphaned.
        stashedProceedAttachments.value = [...(proceedAttachments.value || [])];
        proceedAttachments.value = [];
        // Checklist is skipped on return — land straight on Requirements.
        const hasReqPage = (tx.value?.current_step_requirements || []).length > 0
            || (tx.value?.current_step_data || []).length > 0;
        wizardStep.value = hasReqPage ? 2 : 1;
    } else {
        wizardStep.value = 1;
        // Restore the forward pick; auto-pick next step when nothing valid.
        if (selectedRouteId.value == null || isReturnAction.value) {
            const stash = stashedProceedRouteId.value;
            const stashValid = stash != null && (
                (forwardActions.value || []).some((a) => Number(a.route_id) === Number(stash)) ||
                (jumpRouteOptions.value || []).some((o) => String(o.value) === String(stash) && o.is_forward)
            );
            selectedRouteId.value = stashValid ? stash : defaultForwardRouteId();
        }
        // Back to Proceed: restore the staged list Return replaced, or the
        // fresh-Proceed default when Return was opened directly.
        proceedAttachments.value = stashedProceedAttachments.value != null
            ? [...stashedProceedAttachments.value]
            : proceedDefaultAttachments();
    }
    // Entering Return must force a choice — never inherit a forward
    // selection (that's why Step 3 looked "stuck" on Step 1).
    if (toReturn && !isReturnAction.value) {
        selectedRouteId.value = null;
    }
}
const wizardRef = ref(null);
const selectedRouteId = ref(null);
const proceedAttachments = ref([]);
const attachmentName = ref("");
const checkAttachments = ref([]);

// Steps the paper already passed (meta.visited_step_ids). Powers the
// yellow tracker nodes + the "Return to Step N" jump options.
const visitedStepIds = ref([]);
// Finalized transactions are view-only (backend rejects all writes).
const isDone = computed(() => !!(tx.value?.is_done));
// Office admins can open anything in their office's scope but only act at
// their office's steps (or where their roles allow). Mirrors
// RoutingEngine::userCanWorkOnStep; the server still enforces it.
const canAct = computed(() => {
    const u = auth.user.value;
    const cur = tx.value?.current_step;
    if (!u || !cur) return false;
    if (isSuperadminUser(u)) return true;
    if (isOfficeAdminUser(u)) {
        const mineOffice = Number(u.office?.id ?? u.office_id);
        if (Number(cur.office_id) === mineOffice) return true;
        // Step 1 of a request their office filed, even when step 1 has no office.
        const isStepOne = !!cur.is_start || Number(cur.order_number) === 1;
        if (isStepOne && Number(tx.value?.office?.id ?? tx.value?.office_id) === mineOffice) return true;
    }
    const entry = (tx.value?.station_checklist || []).find((s) => String(s?.step?.id) === String(cur.id));
    const mine = new Set((u.roles || []).map((r) => Number(r.id)));
    return (entry?.step?.roles || []).some((r) => mine.has(Number(r.id)));
});
const viewOnly = computed(() => isDone.value || !canAct.value);
const isEndStep = computed(() => !!(tx.value?.current_step?.is_end));
const showFinalize = computed(() => isEndStep.value && !isDone.value && !pendingReceipt.value);
// Complete Step replaces Finalize on the last station: green button that
// opens the checklist modal, then finalizes. No outgoing routes needed.
const isCompleting = ref(false);
const showCompleteStep = computed(() => isEndStep.value && !isDone.value && !pendingReceipt.value);
const completeModalTitle = computed(() => {
    const cur = tx.value?.current_step;
    const n = cur?.order_number ?? '';
    const name = cur?.name || cur?.code || '';
    return (n !== '' || name) ? `Complete Step ${n} · ${name}`.trim() : 'Complete Step';
});
const hasActionOptions = computed(() =>
    (availableActions.value || []).length > 0 || (jumpRouteOptions.value || []).length > 0,
);
const finalizeDialog = ref(false);
// Jump selections are strings ("jump:<stepId>"); route ids stay numbers.
const isJumpSelected = computed(() =>
    typeof selectedRouteId.value === 'string' && selectedRouteId.value.startsWith('jump:'),
);
const jumpStepId = computed(() =>
    isJumpSelected.value ? Number(String(selectedRouteId.value).split(':')[1]) : null,
);

const isReturnSelected = computed(() =>
    !isJumpSelected.value &&
    (availableActions.value || []).some(
        (a) => Number(a.route_id) === Number(selectedRouteId.value) && !!a.is_return_route,
    ),
);
// Step 1 → step 2 shows requirements only: hide the checklist in the wizard
// and skip its gating. Every other transition is unchanged.
const isFirstStepTransition = computed(() =>
    !isReturnSelected.value &&
    !isJumpSelected.value &&
    Number(tx.value?.current_step?.order_number) === 1 &&
    Number(selectedAction.value?.to_step?.order_number) === 2,
);
// Step 1 stations skip the Review page entirely: step 1 holds no
// predecessor checklist, so Review would only ever be its empty state.
// Exception (frontend-only return review): after a backward return into
// Step 1 (e.g. 3 -> 1) the receiver must re-verify the returned files,
// so Review shows a synthesized checklist built from the return run.
const isAtFirstStep = computed(() => Number(tx.value?.current_step?.order_number) === 1);
// Local ticks for the synthesized return-review rows (no checklist_override
// ids exist on Step 1, so these never call the checklist check API).
const returnReviewTicks = ref({});
const returnReviewBase = computed(() => {
    if (Number(tx.value?.current_step?.order_number) !== 1) return [];
    const ctx = tx.value?.previous_step_context;
    const prevStepId = Number(ctx?.step?.id || 0);
    if (!prevStepId) return [];
    const norm = (s) => String(s || '').trim().toLowerCase();
    const txAtts = tx.value?.attachments || [];
    const station = (tx.value?.station_checklist || []).find((s) => Number(s?.step?.id) === prevStepId);
    const flagged = ctx?.run?.flagged_items || [];
    const attsForReq = (code, name, reqId) => txAtts
        .filter((a) => {
            if (Number(a.workflow_step_id) !== prevStepId) return false;
            if (reqId && Number(a.requirement_definition_id) === Number(reqId)) return true;
            const c = norm(code);
            const rc = norm(a.requirement?.code);
            const rn = norm(a.requirement?.name);
            if (c && (rc === c)) return true;
            const n = norm(name);
            if (n && (rn === n)) return true;
            return false;
        })
        .map((a) => ({
            id: a.id,
            original_name: a.original_name,
            label: a.label,
            mime: a.mime,
            size_bytes: a.size_bytes,
            requirement_definition_id: a.requirement_definition_id,
            uploaded_by: a.uploaded_by,
            created_at: a.created_at,
            download_url: a.download_url,
            view_url: a.view_url,
        }));
    const rows = [];
    const pushRow = (key, name, code, description, attachments) => {
        if (!name && !code) return;
        const id = `return-${key}`;
        rows.push({
            id,
            requirement_definition_id: null,
            name: name || code,
            code: code || '',
            description: description || '',
            is_required: true,
            display_order: rows.length,
            checked: !!returnReviewTicks.value[id],
            flagged_on_return: true,
            prev_step: ctx?.step || null,
            prev_checked: true,
            attachments: attachments || [],
            attachment_count: (attachments || []).length,
        });
    };
    if (Array.isArray(flagged) && flagged.length) {
        flagged.forEach((f, i) => {
            const code = String(f?.code || '').trim();
            const name = String(f?.name || '').trim();
            const reqId = f?.requirement_definition_id ?? null;
            const match = (station?.requirements || []).find((r) =>
                (code && norm(r?.definition?.code) === norm(code)) ||
                (name && norm(r?.definition?.name) === norm(name)) ||
                (reqId && Number(r?.definition?.id) === Number(reqId)),
            );
            const label = match?.definition?.name || name || code || `Returned item ${i + 1}`;
            const rCode = match?.definition?.code || code || '';
            const atts = attsForReq(rCode || code, label, match?.definition?.id ?? reqId);
            pushRow(`flag-${norm(rCode || code) || norm(label) || i}`, label, rCode, `Returned from Station ${ctx?.step?.order_number ?? ''}`.trim(), atts);
        });
    } else if ((station?.requirements || []).length) {
        station.requirements.forEach((r) => {
            const label = r?.definition?.name || r?.definition?.code || 'Returned file';
            const code = r?.definition?.code || '';
            const atts = attsForReq(code, label, r?.definition?.id);
            pushRow(`req-${norm(code) || norm(label)}`, label, code, `Returned from Station ${ctx?.step?.order_number ?? ''}`.trim(), atts);
        });
    }
    for (const a of (ctx?.attachments || [])) {
        pushRow(`file-${a.id}`, a.original_name || a.label || 'Returned file', '', `Returned from Station ${ctx?.step?.order_number ?? ''}`.trim(), [{
            id: a.id,
            original_name: a.original_name,
            label: a.label,
            mime: a.mime,
            size_bytes: a.size_bytes,
            requirement_definition_id: a.requirement_definition_id,
            uploaded_by: a.uploaded_by,
            created_at: a.created_at,
            download_url: a.download_url,
            view_url: a.view_url,
        }]);
    }
    return rows;
});
const isReturnedToFirstStep = computed(() => {
    if (!isAtFirstStep.value) return false;
    if (!returnReviewBase.value.length) return false;
    const runs = tx.value?.runs || [];
    if (!runs.length) return !!tx.value?.previous_step_context?.step?.id;
    const curId = Number(tx.value?.current_step?.id);
    const last = [...runs].sort((a, b) => Number(a.id) - Number(b.id)).pop();
    if (!last) return false;
    const toId = Number(last.to_step?.id ?? last.to_step_id ?? 0);
    if (toId !== curId) return false;
    const fromOrd = Number(last.from_step?.order_number);
    const toOrd = Number(last.to_step?.order_number);
    if (Number.isFinite(fromOrd) && Number.isFinite(toOrd)) return fromOrd > toOrd;
    return Number(last.from_step?.id) !== curId;
});
const effectiveChecklist = computed(() => isReturnedToFirstStep.value ? returnReviewBase.value : (tx.value?.current_step_checklist || []));
const skipReview = computed(() => (isFirstStepTransition.value || isAtFirstStep.value) && !isReturnedToFirstStep.value);
// Dropdown selection: the '__clear' entry ("CANCEL") maps back
// to null so the box always shows a real destination or the placeholder.
function onSelectAction(v) {
    selectedRouteId.value = v === '__clear' ? null : v;
}
// Drop a selection that no longer exists in the refreshed action list.
// Otherwise the closed select renders the raw route id (e.g. "42") with
// no matching label after a move or a condition flip.
function pruneSelectedRoute() {
    if (selectedRouteId.value == null) return;
    const routeOk = (availableActions.value || []).some(
        (a) => Number(a.route_id) === Number(selectedRouteId.value),
    );
    const jumpOk = (jumpRouteOptions.value || []).some(
        (o) => String(o.value) === String(selectedRouteId.value),
    );
    if (!routeOk && !jumpOk) selectedRouteId.value = null;
}
// Single-step mode: no requirements on this station, skip page 1 entirely.
const hasProceedRequirements = computed(
    () => (tx.value?.current_step_requirements || []).length > 0,
);
const isSingleStepProceed = computed(() => !hasProceedRequirements.value);
// Return's "Additional files" starts empty: only what the user adds there
// is listed. Returned evidence is not lost — the from-step's own files are
// stamped to the return run by the engine.

// Files previously saved on the current station, for prefill when
// re-proceeding through already-passed stations. Move-level only:
// requirement files already show in their requirement sections above,
// so they are excluded from the below-remarks list.
function currentStepAttachments() {
    const cur = Number(tx.value?.current_step?.id);
    return (tx.value?.attachments || [])
        .filter((a) => Number(a.workflow_step_id) === cur)
        .filter((a) => a.requirement_definition_id == null || Number(a.requirement_definition_id) === 0);
}
// Proceed default for staged "Additional files": re-walks into an
// already-passed station prefill this station's previous files; first
// visits start empty on purpose.
function proceedDefaultAttachments() {
    const id = selectedAction.value?.to_step?.id;
    const visited = id !== null && id !== undefined
        && (visitedStepIds.value || []).map(Number).includes(Number(id));
    return visited ? [...currentStepAttachments()] : [];
}
const remarks = ref("");
// Structured return flags (flag pills): sent as flagged_items on execute,
// never written into remarks text. Reset after each move.
const returnFlags = ref([]);

const form = ref({});

// Step-data draft keyed by definition code (e.g. receipt_number),
// prefilled from the latest saved value per definition.
const stepDataForm = ref({});

function hydrateStepDataForm() {
    const next = {};
    for (const row of tx.value?.current_step_data ?? []) {
        const code = row?.definition?.code;
        if (!code) continue;
        next[code] = row.value ?? "";
    }
    stepDataForm.value = next;
}

const savingChecklist = ref(false);
const savingChecklistItemId = ref(null);
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

const receiving = ref(false);
const pendingReceipt = computed(
    () => tx.value?.pending_receipt || (tx.value?.runs || []).find((r) => !r.received_at) || null,
);

// Safety net: fail visibly when the transaction type itself is unfinished.
// Counts outgoing routes of the CURRENT step in the PINNED workflow version.
const outgoingRoutesCount = computed(() => {
    const cid = tx.value?.current_step?.id;
    if (cid == null) return 0;
    return (tx.value?.workflow_routes || []).filter((r) => Number(r.from_step_id) === Number(cid)).length;
});
const noOutgoingRoutes = computed(() => {
    if (!tx.value || isDone.value || showFinalize.value || showCompleteStep.value || pendingReceipt.value) return false;
    if (!Array.isArray(tx.value?.workflow_routes)) return false;
    return outgoingRoutesCount.value === 0;
});
const workflowsLink = computed(() => {
    const id = tx.value?.transaction_type?.id;
    return id ? `/admin/workflows?type=${id}` : '/admin/workflows';
});
// Roles allowed on the current step (from station checklist) — shown when
// routes exist but the viewer still has no actions (role mismatch).
const currentStepRoles = computed(() => {
    const entry = (tx.value?.station_checklist || []).find(
        (s) => String(s?.step?.id) === String(tx.value?.current_step?.id),
    );
    return (entry?.step?.roles || []).map((r) => r.name || r.code).filter(Boolean);
});

async function receiveStep() {
    receiving.value = true;
    executeError.value = "";
    // Snapshot the pending run before claiming: a backward arrival
    // (returns / jump-backs) auto-opens Proceed with its return reason
    // shown under the modal title. Forward receives just open Proceed.
    const pend = pendingReceipt.value;
    const fromOrd = Number(pend?.from_step?.order_number);
    const toOrd = Number(pend?.to_step?.order_number);
    const wasBackward = Number.isFinite(fromOrd) && Number.isFinite(toOrd) && fromOrd > toOrd;
    const retRemarks = (pend?.remarks || '').trim();
    try {
        const { tx: fresh, meta } = await receive(route.params.id);
        tx.value = fresh;
        availableActions.value = meta?.available_actions || [];
        visitedStepIds.value = meta?.visited_step_ids || [];
        // Drop stale selections from the previous station, then pre-select
        // the next step when it is the only forward route — otherwise the
        // modal opens with no action and Proceed stays disabled no matter
        // how complete the requirements are. Returns/jumps are never
        // auto-picked; multiple forward routes stay a manual choice.
        pruneSelectedRoute();
        const forwards = (availableActions.value || []).filter((a) => !a.is_return_route);
        if (selectedRouteId.value == null && forwards.length === 1) {
            selectedRouteId.value = forwards[0].route_id;
        }
        // Claimed — drop straight into the Proceed modal when an onward
        // action exists so receiving flows into proceeding in one gesture.
        autoReturnInfo.value = (wasBackward && retRemarks)
            ? { remarks: retRemarks, sender: pend?.performed_by?.name || '', fromStep: pend?.from_step || null }
            : null;
        if ((availableActions.value || []).length) openProceed();
    } catch (e) {
        executeError.value = formatApiError(e, "Receive failed.");
    } finally {
        receiving.value = false;
    }
}

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

const missingRequiredUploadLabels = computed(() => {
    if (isReturnSelected.value || isReturnMode.value) return [];
    return (tx.value?.current_step_requirements ?? [])
        .filter((r) => r?.pivot?.is_upload_required ?? r?.pivot?.is_required)
        .filter((r) => {
            const existing = (r.attachments || []).length;
            const staged = (wizardRef.value?.getReqFiles?.(r.definition.id)?.length ?? 0);
            return existing + staged === 0;
        })
        .map((r) => r.definition?.name)
        .filter(Boolean);
});

const missingRequiredTickLabels = computed(() => {
    if (isReturnSelected.value || isReturnMode.value) return [];
    // Every required requirement (tick-only AND upload rows like AR/Payroll)
    // must be ticked: the top tick unlocks the upload card below.
    return (tx.value?.current_step_requirements ?? [])
        .filter((r) => r?.pivot?.is_required)
        .filter((r) => !r.checked)
        .map((r) => r.definition?.name)
        .filter(Boolean);
});

const missingRequiredChecklistLabels = computed(() => {
    if (isReturnSelected.value || isReturnMode.value) return [];
    if (skipReview.value) return [];
    return (effectiveChecklist.value ?? [])
        .filter((c) => c.is_required && !c.checked)
        .map((c) => c.name)
        .filter(Boolean);
});

// Complete Step gating: required = predecessor ticked (prev_checked).
// Items the previous station left unticked stay optional here.
// Plus same required files + required data as Proceed so Complete
// cannot bypass uploads or station info.
const missingRequiredCompleteLabels = computed(() => {
    return (effectiveChecklist.value ?? [])
        .filter((c) => c.prev_checked && !c.checked)
        .map((c) => c.name)
        .filter(Boolean);
});
const completeBlocked = computed(() =>
    missingRequiredCompleteLabels.value.length > 0 ||
    missingRequiredUploadLabels.value.length > 0 ||
    missingRequiredTickLabels.value.length > 0 ||
    missingRequiredFields.value.length > 0 ||
    missingRequiredStepDataLabels.value.length > 0,
);
function completeBlockMessage() {
    const parts = [];
    if (missingRequiredUploadLabels.value.length) parts.push("Missing files: " + missingRequiredUploadLabels.value.join(", "));
    if (missingRequiredTickLabels.value.length) parts.push("Unticked required items: " + missingRequiredTickLabels.value.join(", "));
    if (missingRequiredCompleteLabels.value.length) parts.push("Required checklist items not completed: " + missingRequiredCompleteLabels.value.join(", "));
    if (missingRequiredFields.value.length) parts.push("Required station info missing: " + missingRequiredFields.value.join(", "));
    if (missingRequiredStepDataLabels.value.length) parts.push("Required step data missing: " + missingRequiredStepDataLabels.value.join(", "));
    return parts.join(" ");
}

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

// Required step-data values (receipt number, etc.) still empty in the
// draft. These fail server-side validation on Proceed, so warn and block
// Proceed until filled. Skipped on returns, like the other wizard gates.
const missingRequiredStepDataLabels = computed(() => {
    if (isReturnSelected.value || isReturnMode.value) return [];
    const out = [];
    for (const row of tx.value?.current_step_data ?? []) {
        if (!row?.definition?.is_required) continue;
        const v = stepDataForm.value?.[row.definition.code];
        if (v === null || v === undefined || String(v).trim() === "") {
            out.push(row.definition.display_name || row.definition.code);
        }
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
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        returnReviewTicks.value = {};
        hydrateForm();
        hydrateStepDataForm();

        const allIds = new Set((availableActions.value || []).map((a) => a.route_id));
        if (!allIds.has(selectedRouteId.value)) selectedRouteId.value = null;
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to load transaction.";
    } finally {
        loading.value = false;
    }
}

function openProceed() {
    isCompleting.value = false;
    remarks.value = "";
    // Available-action returns (return routes and backward jumps alike)
    // open the same modal as the in-modal Return button: return mode.
    const returning = isReturnAction.value;
    // Additional files start empty on Return — only what the user adds
    // there is listed; forwards use their own default (see
    // proceedDefaultAttachments below).
    proceedAttachments.value = returning ? [] : proceedDefaultAttachments();
    attachmentName.value = "";
    executeError.value = "";
    wizardMode.value = returning ? 'return' : 'proceed';
    if (returning) {
        // Same staging as the in-modal Return: land on Requirements,
        // the checklist page is skipped.
        const hasReqPage = (tx.value?.current_step_requirements || []).length > 0
            || (tx.value?.current_step_data || []).length > 0;
        wizardStep.value = hasReqPage ? 2 : 1;
    } else {
        // First-step single-page layout always starts on its only page.
        // Otherwise single-page mode (step 1 → step 2) shows the Requirements
        // page (now page 2), or start on Review (page 1).
        wizardStep.value = isAtFirstStep.value ? 1 : (skipReview.value ? 2 : 1);
    }
    wizardRef.value?.clearReqFiles?.();
    remarksDialog.value = true;
}

// Complete Step on the last station: checklist modal, then finalize.
// Checklist shows even with no outgoing routes; gating is prev_checked only.
function openComplete() {
    isCompleting.value = true;
    remarks.value = "";
    proceedAttachments.value = [];
    attachmentName.value = "";
    executeError.value = "";
    error.value = "";
    wizardMode.value = 'proceed';
    const hasList = (effectiveChecklist.value || []).length > 0;
    wizardStep.value = (!hasList || isSingleStepProceed.value) ? 2 : 1;
    if (hasList && isSingleStepProceed.value) wizardStep.value = 1;
    wizardRef.value?.clearReqFiles?.();
    remarksDialog.value = true;
}

// Re-fetch tx without wiping staged station-info `form` (uploads and
// check/uncheck refresh the requirements list only).
async function refreshTxPreservingForm() {
    try {
        const res = await getOne(route.params.id);
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        pruneSelectedRoute();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to refresh transaction.";
    }
}

async function goWizardNext() {
    await refreshTxPreservingForm();
    wizardStep.value = 2;
}

async function onWizardToggle(req, checked) {
    if (!req?.definition?.id) return;
    if (checked && !req.checked) await checkRequirement(req.definition.id);
    else if (!checked && req.checked) await uncheckRequirement(req.definition.id);
}

async function onWizardChecklistToggle(item, checked) {
    if (!item?.id) return;
    if (String(item.id).startsWith('return-')) {
        returnReviewTicks.value = { ...(returnReviewTicks.value || {}), [item.id]: !!checked };
        return;
    }
    if (checked && !item.checked) await checkChecklistItem(item.id);
    else if (!checked && item.checked) await uncheckChecklistItem(item.id);
}

async function checkChecklistItem(itemId) {
    savingChecklist.value = true;
    savingChecklistItemId.value = itemId;
    error.value = "";
    try {
        const res = await api.post(
            `/api/transactions/${route.params.id}/checklist/${itemId}/check`,
        );
        tx.value = res.data.data ?? res.data;
        availableActions.value = res.data.meta?.available_actions ?? [];
        visitedStepIds.value = res.data.meta?.visited_step_ids ?? [];
        pruneSelectedRoute();
    } catch (e) {
        error.value = e?.response?.data?.message || "Checklist check failed.";
    } finally {
        savingChecklist.value = false;
        savingChecklistItemId.value = null;
    }
}

async function uncheckChecklistItem(itemId) {
    savingChecklist.value = true;
    savingChecklistItemId.value = itemId;
    error.value = "";
    try {
        const res = await api.delete(
            `/api/transactions/${route.params.id}/checklist/${itemId}/check`,
        );
        tx.value = res.data.data ?? res.data;
        availableActions.value = res.data.meta?.available_actions ?? [];
        visitedStepIds.value = res.data.meta?.visited_step_ids ?? [];
        pruneSelectedRoute();
    } catch (e) {
        error.value = e?.response?.data?.message || "Checklist uncheck failed.";
    } finally {
        savingChecklist.value = false;
        savingChecklistItemId.value = null;
    }
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
            step_data: { ...(stepDataForm.value || {}) },
        });

        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        remarksDialog.value = false;
        wizardStep.value = 1;
        proceedAttachments.value = [];
        attachmentName.value = "";
        returnReviewTicks.value = {};
        // New station, new outgoing routes — force a fresh selection so the
        // closed dropdown never shows the previous route's raw id.
        selectedRouteId.value = null;
        hydrateForm();
        hydrateStepDataForm();
    } catch (e) {
        const msg = formatApiError(e, "Execute failed.");
        error.value = msg;
        executeError.value = msg;
    } finally {
        saving.value = false;
    }
}

// Jump straight back to an already-passed station — remarks required,
// collected in the jump dialog. No wizard, no checklist gating. The
// destination keeps complete saved work (backend rule).
const jumpDialog = ref(false);

function openJump() {
    if (!isJumpSelected.value) return;
    jumpDialog.value = true;
}

async function confirmJump(payload) {
    jumpDialog.value = false;
    await gotoStation(payload);
    if (!error.value) {
        remarksDialog.value = false;
        wizardMode.value = 'proceed';
        isCompleting.value = false;
        wizardStep.value = 1;
    }
}

// In-modal Return with a jump picked goes direct — no second dialog.
// Uses the reason + flag pills already entered in this modal.
async function returnViaJump() {
    if (!isJumpSelected.value || !jumpStepId.value || saving.value) return;
    await gotoStation({ remarks: (remarks.value || '').trim() || null, flagged: [...(returnFlags.value || [])] });
    if (!error.value) {
        remarksDialog.value = false;
        wizardMode.value = 'proceed';
        isCompleting.value = false;
        wizardStep.value = 1;
    }
}

async function gotoStation(payload) {
    if (!isJumpSelected.value || !jumpStepId.value || saving.value) return;
    saving.value = true;
    error.value = "";
    try {
        const remarks = typeof payload === "string" ? payload : payload?.remarks;
        const flagged = payload && typeof payload === "object" && Array.isArray(payload.flagged) ? payload.flagged : [];
        const res = await gotoStationApi(route.params.id, {
            to_step_id: jumpStepId.value,
            remarks: remarks || null,
            flagged_items: flagged,
        });
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        selectedRouteId.value = null;
        hydrateForm();
        hydrateStepDataForm();
    } catch (e) {
        error.value = formatApiError(e, "Jump failed.");
    } finally {
        saving.value = false;
    }
}

// Complete Step on the last station. Validates required files + data
// like Proceed, then saves staged station info with finalize.
async function finalizeTx() {
    if (saving.value) return;
    if (isCompleting.value && completeBlocked.value) {
        error.value = completeBlockMessage() || "Complete the required items first.";
        executeError.value = error.value;
        return;
    }
    saving.value = true;
    error.value = "";
    try {
        const payloadFields = { ...form.value };
        for (const row of tx.value?.current_step_fields ?? []) {
            const def = row.definition;
            if (def.type === "multiselect" && !Array.isArray(payloadFields[def.code])) {
                payloadFields[def.code] = [];
            }
            if ((def.type === "number" || def.type === "currency") && payloadFields[def.code] !== null && payloadFields[def.code] !== "") {
                payloadFields[def.code] = Number(payloadFields[def.code]);
            }
            if (def.type === "boolean") {
                payloadFields[def.code] = !!payloadFields[def.code];
            }
        }
        const res = await finalizeApi(route.params.id, {
            field_values: payloadFields,
            step_data: { ...(stepDataForm.value || {}) },
        });
        tx.value = res.tx;
        availableActions.value = res.meta?.available_actions ?? [];
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        selectedRouteId.value = null;
        hydrateForm();
        hydrateStepDataForm();
        finalizeDialog.value = false;
        remarksDialog.value = false;
        isCompleting.value = false;
        wizardStep.value = 1;
    } catch (e) {
        const msg = formatApiError(e, "Finalize failed.");
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
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        pruneSelectedRoute();
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
        visitedStepIds.value = res.meta?.visited_step_ids ?? [];
        pruneSelectedRoute();
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
    const name = a?.to_step?.name ?? `Step #${a.to_step_id ?? ""}`;
    const n = a?.to_step?.order_number;
    return n != null && n !== "" ? `${n}. ${name}` : `${name}`;
}

const unifiedRouteOptions = computed(() => [
    { value: '__clear', label: 'CANCEL', kind: 'clear', verb: 'Cancel', detail: '' },
    ...forwardActions.value.map((a) => {
        const n = a?.to_step?.order_number ?? a?.to_step_id;
        const name = a?.to_step?.name ?? labelForAction(a);
        const hasStep = n != null && n !== '';
        return {
            value: a.route_id,
            route_id: a.route_id,
            label: `Proceed → ${labelForAction(a)}`,
            kind: 'proceed',
            verb: hasStep ? `Proceed to Step ${n}` : 'Proceed',
            detail: hasStep ? String(name) : labelForAction(a),
        };
    }),
    ...returnActions.value.map((a) => {
        const n = a?.to_step?.order_number ?? a?.to_step_id;
        const name = a?.to_step?.name ?? labelForAction(a);
        const hasStep = n != null && n !== '';
        return {
            value: a.route_id,
            route_id: a.route_id,
            label: `Return → ${labelForAction(a)}`,
            kind: 'return',
            verb: hasStep ? `Return to Step ${n}` : 'Return',
            detail: hasStep ? String(name) : labelForAction(a),
        };
    }),
    ...jumpRouteOptions.value,
]);

// Jump targets: any visited step except the current one, ordered by
// step number. Behind = Return, ahead = quick Resend (e.g. 1 -> 3 after
// a 3 -> 1 return, remarks-only). Values are "jump:<stepId>" strings so
// they never collide with numeric route ids. Normal forward progress still
// goes step by step through the assigned routes. Recorded as Returned
// (backward) or Resent (forward) in history.
const jumpRouteOptions = computed(() => {
    // Locked until received — backend rejects jumps on pending receipt.
    if (pendingReceipt.value) return [];
    const visited = new Set((visitedStepIds.value || []).map((v) => Number(v)));
    const cur = Number(tx.value?.current_step?.id);
    const curOrder = Number(
        (tx.value?.workflow_steps || []).find((s) => Number(s.id) === cur)?.order_number ?? NaN,
    );
    // Forward targets already reachable via a normal Proceed route are
    // hidden here so the list never shows both "Proceed → 2" and
    // "Resend to Step 2" for the same step.
    const forwardDestIds = new Set(
        (forwardActions.value || [])
            .map((a) => Number(a?.to_step?.id ?? a?.to_step_id))
            .filter((v) => Number.isFinite(v)),
    );
    return (tx.value?.workflow_steps || [])
        .filter((s) => {
            const id = Number(s.id);
            if (!visited.has(id) || id === cur) return false;
            const forward = Number.isFinite(curOrder) && Number(s.order_number) > curOrder;
            if (forward && forwardDestIds.has(id)) return false;
            return true;
        })
        .sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0))
        .map((s) => {
            const forward = Number.isFinite(curOrder) && Number(s.order_number) > curOrder;
            return {
                value: `jump:${s.id}`,
                to_step_id: s.id,
                to_number: s.order_number ?? s.id,
                is_jump: true,
                is_forward: forward,
                label: `${forward ? 'Resend to' : 'Return to'} Step ${s.order_number} · ${s.name || s.code || ''}`.trim(),
                kind: forward ? 'resend' : 'return',
                verb: `${forward ? 'Resend to' : 'Return to'} Step ${s.order_number}`,
                detail: s.name || s.code || '',
            };
        });
});

const selectedJumpOption = computed(() =>
    (jumpRouteOptions.value || []).find((o) => String(o.value) === String(selectedRouteId.value)) || null,
);

const jumpDestinationLabel = computed(() => {
    const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(jumpStepId.value));
    if (!s) return 'the selected step';
    return `Step ${s.order_number} · ${s.name || s.code || ''}`.trim();
});

const jumpCurrentLabel = computed(() => {
    const c = tx.value?.current_step;
    if (!c) return 'current step';
    const match = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(c.id));
    return `Step ${match?.order_number ?? ''} · ${c.name || c.code || ''}`.trim();
});

const selectedActionLabel = computed(() => {
    if (isJumpSelected.value) return selectedJumpOption.value?.label ?? "";
    const a = (availableActions.value || []).find((x) => x.route_id === selectedRouteId.value);
    return a ? labelForAction(a) : "";
});

const selectedAction = computed(() => {
    if (isJumpSelected.value) return null;
    return (availableActions.value || []).find(
        (x) => Number(x.route_id) === Number(selectedRouteId.value),
    );
});
const selectedStepNumber = computed(
    () => selectedAction.value?.to_step?.order_number ?? selectedAction.value?.to_step_id ?? "",
);
const isJumpForward = computed(() => !!selectedJumpOption.value?.is_forward);
// True for any backward move: return-route selection or backward jump.
// Drives the orange (warning) button styling on return actions.
const isReturnAction = computed(() => isReturnSelected.value || (isJumpSelected.value && !isJumpForward.value));
const isResendAction = computed(() => isJumpSelected.value && isJumpForward.value);
// In-modal Return picker: real return routes + visited previous stations
// (backward jumps). Excludes forward/resend so Return never offers Step 1
// when Step 2 is the nearer previous station.
const returnPickerOptions = computed(() => {
    const routes = (returnActions.value || []).map((a) => {
        const n = a?.to_step?.order_number ?? a?.to_step_id;
        const name = a?.to_step?.name ?? labelForAction(a);
        return {
            value: a.route_id,
            route_id: a.route_id,
            label: `Return to Step ${n} · ${name}`,
            kind: 'return',
            verb: `Return to Step ${n}`,
            detail: String(name),
        };
    });
    const jumps = (jumpRouteOptions.value || [])
        .filter((o) => !o.is_forward)
        .map((o) => ({ ...o, kind: 'return' }));
    return [...routes, ...jumps];
});
const returnSubmitDisabled = computed(() =>
    !selectedRouteId.value || !isReturnAction.value || !(remarks.value || '').trim() || missingRequiredFields.value.length > 0 || saving.value,
);
const mainActionButtonLabel = computed(() => {
    if (!selectedRouteId.value) return "Proceed";
    if (isJumpSelected.value) {
        const n = selectedJumpOption.value?.to_number ?? "";
        const verb = isJumpForward.value ? "Resend to Step" : "Return to Step";
        return n !== "" ? `${verb} ${n}` : verb;
    }
    if (!selectedAction.value) return "Proceed";
    if (isReturnSelected.value) return `Return to Step ${selectedStepNumber.value}`;
    return `Proceed to Step ${selectedStepNumber.value}`;
});
// Action-bar button keeps the verb only (destination is shown in the
// graphic above it): Proceed / Return / Resend.
const actionButtonLabel = computed(() => {
    if (!selectedRouteId.value) return "Proceed";
    if (isJumpSelected.value) return isJumpForward.value ? "Resend" : "Return";
    if (!selectedAction.value) return "Proceed";
    if (isReturnSelected.value) return "Return";
    return "Proceed";
});

// Proceed modal title: Proceeding to "stepname" (office code). Name comes from
// the destination step (workflow_routes.to_step_id → workflow_steps); office
// code comes from the CURRENT step's Destination Office (where the paper is
// being sent from, e.g. General Service Office when on step 1).
function destStepForTitle() {
    if (isJumpSelected.value) {
        const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(jumpStepId.value));
        if (s) return s;
        return null;
    }
    const direct = selectedAction.value?.to_step;
    const routeId = Number(selectedRouteId.value);
    const route = (tx.value?.workflow_routes || []).find((r) => Number(r.id) === routeId);
    const toId = direct?.id ?? route?.to_step_id ?? selectedAction.value?.to_step_id;
    if (toId != null) {
        const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(toId));
        if (s) return { ...direct, ...s, office: s.office ?? direct?.office ?? null };
    }
    return direct ?? null;
}
function currentOfficeForTitle() {
    const cur = tx.value?.current_step;
    if (cur?.office?.code || cur?.office?.name || cur?.stage) return cur;
    const cid = cur?.id;
    if (cid != null) {
        const s = (tx.value?.workflow_steps || []).find((x) => Number(x.id) === Number(cid));
        if (s) return s;
    }
    return cur ?? null;
}
function proceedTitle(prefix) {
    const dest = destStepForTitle();
    const n = dest?.order_number ?? selectedStepNumber.value ?? "";
    const name = dest?.name || dest?.code || (n !== "" && n != null ? `Step ${n}` : "");
    if (!name) return "Proceed";
    const cur = currentOfficeForTitle();
    const office = String(
        cur?.office?.code ?? cur?.office?.name ?? cur?.stage ??
        dest?.office?.code ?? dest?.office?.name ?? dest?.stage ?? "",
    ).trim();
    return office ? `${prefix} ${name} (${office})` : `${prefix} ${name}`;
}

// Single-line Proceed modal title: destination step name + office.
const proceedModalTitle = computed(() => {
    if (!selectedRouteId.value) return "Proceed";
    if (isJumpSelected.value) {
        if (!selectedJumpOption.value) return "Return";
        return proceedTitle(isJumpForward.value ? "Resend to" : "Return to");
    }
    if (!selectedAction.value) return "Proceed";
    if (isReturnSelected.value) return proceedTitle("Return to");
    return proceedTitle("Proceed to");
});

// Black primary button label: Proceed to {destination office code}.
const destOfficeCode = computed(() => destStepForTitle()?.office?.code || '');
const proceedButtonLabel = computed(() => {
    if (isReturnSelected.value || isJumpSelected.value) return mainActionButtonLabel.value;
    if (destOfficeCode.value) return `Proceed to ${destOfficeCode.value}`;
    const dest = destStepForTitle();
    const name = dest?.name || dest?.code;
    if (name) return `Proceed to ${name}`;
    return 'Proceed';
});

// Footer Next-button visibility (mirrors the template condition).
const showNextBtn = computed(() => wizardStep.value === 1 && !isSingleStepProceed.value && !skipReview.value);
// Single source of truth for the Proceed disabled state (mirrors backend gating).
const proceedDisabled = computed(() =>
    !selectedRouteId.value ||
    (!isReturnSelected.value && (missingRequiredUploadLabels.value.length > 0 || missingRequiredTickLabels.value.length > 0 || missingRequiredChecklistLabels.value.length > 0)) ||
    missingRequiredFields.value.length > 0 ||
    missingRequiredStepDataLabels.value.length > 0,
);
const proceedActionWord = computed(() => (showNextBtn.value ? 'Next' : 'Proceed'));
// Footer status line (mockup: green "All set." vs red "Required" + reason).
const footerStatus = computed(() => {
    if (isReturnMode.value) {
        if (!selectedRouteId.value || !isReturnAction.value) return { ok: false, title: 'Required', message: 'Select where to return.', titleOnly: false };
        if (missingRequiredFields.value.length > 0) return { ok: false, title: 'This field is required.', message: '', titleOnly: true };
        return { ok: true, title: 'All set.', message: 'You can return.', titleOnly: false };
    }
    if (isCompleting.value) {
        const msg = completeBlockMessage();
        if (msg) return { ok: false, title: 'Required', message: `${msg} — complete the required items to enable Complete Step.`, titleOnly: false };
        return { ok: true, title: 'All set.', message: 'You can complete this step.', titleOnly: false };
    }
    if (!selectedRouteId.value) return { ok: false, title: 'Required', message: 'Select a destination to proceed.', titleOnly: false };
    if (missingRequiredUploadLabels.value.length > 0) return { ok: false, title: 'Required', message: `Upload the required files to enable ${proceedActionWord.value}.`, titleOnly: false };
    if (missingRequiredFields.value.length > 0 || missingRequiredStepDataLabels.value.length > 0) return { ok: false, title: 'This field is required.', message: '', titleOnly: true };
    if (missingRequiredTickLabels.value.length > 0 || missingRequiredChecklistLabels.value.length > 0) return { ok: false, title: 'Required', message: `Tick the required items to enable ${proceedActionWord.value}.`, titleOnly: false };
    return { ok: true, title: 'All set.', message: 'You can proceed.', titleOnly: false };
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
    wizardRef.value?.removeReqFile?.(id);
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

/* Slim inner scroll: keeps scrolling inside the curved modal. */
.proceed-scroll {
    max-height: 70vh;
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: rgba(0, 0, 0, 0.3) transparent;
    padding-right: 8px;
}
.proceed-scroll::-webkit-scrollbar {
    width: 4px;
}
.proceed-scroll::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.25);
    border-radius: 999px;
}
.proceed-scroll::-webkit-scrollbar-track {
    background: transparent;
}
/* Header meta split: vertical divider between Type and Step on sm+ only
   (stacked rows get the horizontal v-divider instead). */
@media (min-width: 600px) {
    .meta-divide {
        border-left: 1px solid rgba(0, 0, 0, 0.12);
    }
    html.dark .meta-divide {
        border-left-color: rgba(255, 255, 255, 0.12);
    }
}
</style>
