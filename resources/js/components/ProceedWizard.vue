<template>
    <div>
        <v-stepper v-if="showChecklist && hasProceedContent && !singlePage" v-model="step" flat hide-actions alt-labels :class="`wizard-stepper mb-2 is-step-${step}`">
            <v-stepper-header>
                <v-stepper-item :value="1" title="Review" subtitle="Checklist & proceed" :color="step === 1 ? 'warning' : '#FDE68A'" class="review-step">
                    <template #icon="{ hasCompleted }">
                        <v-icon v-if="hasCompleted">mdi-check</v-icon>
                    </template>
                </v-stepper-item>
                <v-divider class="wizard-connector" aria-hidden="true" />
                <v-stepper-item :value="2" title="Requirements" subtitle="Upload files" :color="step === 2 ? 'primary' : '#BFDBFE'" class="req-step">
                    <template #icon="{ hasCompleted }">
                        <v-icon v-if="hasCompleted">mdi-check</v-icon>
                    </template>
                </v-stepper-item>
            </v-stepper-header>
        </v-stepper>

        <v-window v-model="step">
            <!-- PAGE 1: review — requirements status + checklist ticks.
                 First page in two-page mode; the only page in single-step
                 (checklist-only) mode where its footer allows Proceed. -->
            <v-window-item v-if="showChecklist && !singlePage" :value="1">
                <!-- Single-step fallback: no requirements, so station info lives here -->
                <template v-if="!hasRequirements && ((fields || []).length || (stepData || []).length)">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />
                    <StepDataFields v-model:form="stepDataForm" :step-data="stepData" :saving="saving" :modern="modern" />
                    <v-divider class="my-3" />
                </template>

                <!-- Previous station remarks (last move only, read-only). Hidden when no remarks.
                     When flagged returns show, the remark lives inside the orange card below instead. -->
                <v-card v-if="prevContext && hasPrevRemarks && !flaggedChecklist.length" rounded="lg" border variant="outlined" class="pa-3 mb-3">
                    <div class="text-subtitle-2 font-weight-bold">
                        Remarks from {{ prevStepTitle }}
                    </div>
                    <div v-if="prevRunBy" class="text-caption text-medium-emphasis mb-2">{{ prevRunBy }}</div>
                    <div class="text-body-2">{{ prevRemarksText }}</div>
                </v-card>

                <!-- Previous station data (last move only, read-only). Independent of remarks. -->
                <v-card v-if="hasPrevDataRows" rounded="lg" border variant="outlined" class="pa-3 mb-3">
                    <div class="text-subtitle-2 font-weight-bold">
                        Data from {{ prevStepTitle }}
                    </div>
                    <template v-if="prevFieldRows.length">
                        <div v-for="f in prevFieldRows" :key="f.code || f.name" class="d-flex ga-2 py-1">
                            <span class="text-caption text-medium-emphasis" style="min-width: 140px">{{ f.name }}</span>
                            <span class="text-body-2">{{ displayPrevValue(f.value) }}</span>
                        </div>
                    </template>
                    <template v-if="prevStepDataRows.length">
                        <v-divider v-if="prevFieldRows.length" class="my-2" />
                        <div v-for="d in prevStepDataRows" :key="d.code || d.name" class="d-flex ga-2 py-1">
                            <span class="text-caption text-medium-emphasis" style="min-width: 140px">{{ d.name }}</span>
                            <span class="text-body-2">{{ displayPrevValue(d.value) }}</span>
                        </div>
                    </template>
                </v-card>

                <!-- Checklist: tick to confirm. Required ticks block Proceed. -->
                <div v-if="flaggedChecklist.length" class="mb-3">
                    <v-card rounded="lg" variant="tonal" color="warning" class="pa-3">
                        <template v-if="prevContext && hasPrevRemarks">
                            <div class="text-subtitle-1 font-weight-bold" style="color: #92400E">Remarks from {{ prevStepTitle }}</div>
                            <div v-if="prevRunBy" class="text-caption text-medium-emphasis mb-2">{{ prevRunBy }}</div>
                            <div class="text-body-2" style="color: #000">{{ prevRemarksText }}</div>
                            <v-divider class="my-3" />
                        </template>
                        <div class="text-subtitle-2 font-weight-bold" style="color: #92400E">Flagged on return</div>
                        <div class="text-caption text-medium-emphasis mb-2">The returning station flagged these items for re-check:</div>
                        <div class="d-flex flex-wrap ga-1 align-center">
                            <template v-for="c in flaggedChecklist" :key="c.id ?? c.name">
                                <v-tooltip v-if="viewableFiles(c).length" location="top" max-width="320">
                                    <template #activator="{ props }">
                                        <v-chip
                                            v-bind="props"
                                            size="small"
                                            variant="flat"
                                            color="warning"
                                            rounded="lg"
                                        ><v-icon start size="x-small">mdi-flag</v-icon>{{ c.name }}
                                            <a
                                                v-for="a in viewableFiles(c)"
                                                :key="`flag-eye-${c.id ?? c.name}-${a.id}`"
                                                :href="fileViewUrl(a)"
                                                target="_blank"
                                                rel="noopener"
                                                class="ml-1 d-inline-flex align-center"
                                                style="color: inherit"
                                                :title="`View ${a.original_name}`"
                                                @click.stop
                                            ><v-icon size="x-small">mdi-eye</v-icon></a>
                                        </v-chip>
                                    </template>
                                    <div v-for="a in viewableFiles(c)" :key="`flag-tip-${c.id ?? c.name}-${a.id}`" class="mb-1">
                                        <div class="font-weight-bold">{{ a.original_name }}</div>
                                        <div class="text-caption">{{ formatPrevSize(a.size_bytes) }}<span v-if="a.uploaded_by?.name"> · {{ a.uploaded_by.name }}</span><span v-if="a.created_at"> · {{ new Date(a.created_at).toLocaleString() }}</span></div>
                                        <div v-if="a.requirement?.name || a.label" class="text-caption">{{ a.requirement?.name || a.label }}</div>
                                    </div>
                                </v-tooltip>
                                <v-chip
                                    v-else
                                    size="small"
                                    variant="flat"
                                    color="warning"
                                    rounded="lg"
                                ><v-icon start size="x-small">mdi-flag</v-icon>{{ c.name }}</v-chip>
                            </template>
                        </div>
                    </v-card>
                </div>
                <div v-if="modern" class="text-h6 font-weight-bold mb-3">Review</div>
                <div class="d-flex justify-space-between align-baseline mb-1">
                    <div :class="modern ? 'text-h6 font-weight-bold' : 'text-subtitle-2 font-weight-bold'">Checklist</div>
                    <div v-if="modern && (checklist || []).length" class="text-body-2" :class="checklistComplete ? 'text-success' : 'text-medium-emphasis'">
                        {{ verifiedChecklistCount }} of {{ (checklist || []).length }} verified
                    </div>
                </div>
                <div v-if="modern && (checklist || []).length && !isReturnSelected" class="text-body-2 text-medium-emphasis mb-2">
                    Tick each box when you have seen the hard copies. Required items must be ticked.
                </div>
                <div v-if="isReturnSelected" class="text-caption text-medium-emphasis mb-2">
                    Return action — checklist not required.
                </div>
                <div v-else-if="!(checklist || []).length" class="text-caption text-medium-emphasis mb-2">
                    No checklist items for this station.
                </div>
                <div v-else>
                    <div v-if="!modern" class="text-caption text-medium-emphasis mb-2">
                        Tick each item as done. Required items must be ticked before you can Proceed.
                    </div>
                    <div
                        v-for="c in (checklist || [])"
                        :key="c.id"
                        class="d-flex align-center ga-2 py-1"
                    >
                        <v-checkbox
                            :model-value="!!c.checked"
                            :label="c.name"
                            density="compact"
                            hide-details="auto"
                            style="flex: 1 1 auto"
                            :disabled="saving || savingChecklist"
                            :loading="savingChecklist && savingChecklistItemId === c.id"
                            @update:model-value="(v) => emit('toggle-checklist', c, v)"
                        />
                        <v-btn
                            v-for="a in viewableFiles(c)"
                            :key="a.id"
                            size="x-small"
                            variant="tonal"
                            color="info"
                            rounded="0"
                            :href="fileViewUrl(a)"
                            target="_blank"
                            rel="noopener"
                            :title="`View ${a.original_name}`"
                            @click.stop
                        >
                            <v-icon start size="x-small">mdi-eye</v-icon>View
                        </v-btn>
                    </div>
                </div>

                <!-- Previous step's Additional files (last move only, view-only). -->
                <div v-if="hasPrevFiles" class="mt-3">
                    <div class="text-subtitle-2 font-weight-bold mb-2">Additional files</div>
                    <AttachmentList
                        :items="prevContext?.attachments || []"
                        :tx-id="txId"
                        :is-admin="false"
                        detailed
                        group-by-label
                        hide-delete
                        :show-details="false"
                        action="view"
                    />
                </div>

                <!-- Single-step mode only (no requirements): remarks + move
                     attachments live here so checklist-only flows can Proceed. -->
                <ProceedFooter
                    v-if="!hasRequirements"
                    v-model:remarks="remarks"
                    v-model:proceed-attachments="proceedAttachments"
                    v-model:attachment-name="attachmentName"
                    v-model:flagged="flagged"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :is-return-selected="isReturnSelected"
                    :checklist="checklist"
                    :show-checklist="showChecklist"
                    :missing-required-upload-labels="missingRequiredUploadLabels"
                    :missing-required-tick-labels="missingRequiredTickLabels"
                    :missing-required-checklist-labels="missingRequiredChecklistLabels"
                    :missing-required-fields="missingRequiredFields"
                    :execute-error="executeError"
                    :remarks-label="remarksLabel"
                    :remarks-placeholder="remarksPlaceholder"
                    :attachments-title="attachmentsTitle"
                    :modern="modern"
                    :show-existing-btn="showExistingBtn"
                    :existing-disabled="saving || savingChecklist"
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                    @open-existing="openExistingAdditional"
                />
            </v-window-item>

            <!-- PAGE 2: current-step requirements + per-item uploads + station info.
                 Last page in two-page mode; the only page in single-page mode
                 (step 1 → step 2, no checklist): remarks + move attachments
                 render below so it never shows a second screen. -->
            <v-window-item v-if="hasRequirements || hasStepData || !showChecklist" :value="singlePage ? 1 : 2">
                <template v-if="(fields || []).length">
                    <div :class="numberedSection ? 'text-h6 font-weight-bold' : 'text-subtitle-2 font-weight-bold'" class="mb-2">{{ numberedSection && sectionNumbers.info ? `Step ${sectionNumbers.info}: ` : '' }}Station info</div>
                    <StepInfoFields :fields="fields" :form="form" />

                    <v-divider class="my-3" />
                </template>
                <StepDataFields v-model:form="stepDataForm" :step-data="stepData" :saving="saving" :modern="modern" :numbered="numberedSection" :start-number="sectionNumbers.dataStart" />
                <div v-if="tickRequirements.length" class="d-flex justify-space-between align-baseline mb-2">
                    <div :class="modern ? 'text-h6 font-weight-bold' : 'text-subtitle-2 font-weight-bold'">{{ numberedSection && sectionNumbers.reqs ? `Step ${sectionNumbers.reqs}: ` : '' }}{{ isCompleting ? 'Requirements to Complete step' : (isReturnSelected ? 'Requirements to return' : 'Requirements to proceed') }}</div>
                    <div v-if="modern && (requirements || []).length && requiredTotalCount > 0" class="text-body-2 text-success">
                        {{ requiredTickedCount }} of {{ requiredTotalCount }} required ticked
                    </div>
                </div>
                <div v-if="modern && (requirements || []).length" class="text-body-2 text-medium-emphasis mb-2">
                    Tick each box when it is done. Items marked Required must be ticked.
                </div>

                <div v-if="tickRequirements.length" class="d-flex flex-column ga-3">
                    <!-- Tick group: current verify tick. Ticking a required
                        row unlocks its section below. -->
                    <div v-if="tickRequirements.length" class="d-flex flex-column">
                        <div
                            v-for="r in tickRequirements"
                            :key="r.definition.id"
                            class="d-flex align-center ga-2 py-1"
                        >
                            <v-checkbox
                                :model-value="!!r.checked"
                                :label="r.definition.name"
                                density="compact"
                                hide-details="auto"
                                style="flex: 0 1 auto"
                                :disabled="saving || savingChecklist"
                                :loading="savingChecklist && savingRequirementId === r.definition.id"
                                @update:model-value="(v) => emit('toggle-requirement', r, v)"
                            />
                            <v-chip v-if="r?.pivot?.is_required" :size="modern ? 'small' : 'x-small'" variant="tonal" :color="r.checked ? 'success' : 'error'" :rounded="modern ? 'pill' : 'lg'"><v-icon v-if="r.checked && !modern" start size="x-small">mdi-check</v-icon>Required</v-chip>
                            <v-chip v-else :size="modern ? 'small' : 'x-small'" :variant="modern ? 'outlined' : 'tonal'" color="grey" :rounded="modern ? 'pill' : 'lg'">{{ modern ? 'Optional' : 'optional' }}</v-chip>
                            <v-chip v-if="r.flagged_on_return" :size="modern ? 'small' : 'x-small'" variant="flat" color="warning" :rounded="modern ? 'pill' : 'lg'"><v-icon start size="x-small">mdi-flag</v-icon>flagged on return</v-chip>
                        </div>
                    </div>
                    <v-card
                        v-if="uploadFirstRequirements.length"
                        rounded="lg"
                        border
                        variant="outlined"
                        class="pa-3"
                    >
                        <div
                            v-for="(r, idx) in uploadFirstRequirements"
                            :key="r.definition.id"
                        >
                            <v-divider v-if="idx > 0" class="my-3" />
                            <div :style="isUploadLocked(r) ? 'opacity: 0.6' : ''">
                        <!-- Upload rows: status flip chip. Tick-only rows: optional chip. -->
                        <div class="d-flex align-center ga-2 mb-2">
                            <span class="font-weight-medium text-body-1">{{ r.definition.name }}</span>
                            <v-spacer />
                            <v-chip v-if="uploadRequired(r)" size="x-small" variant="tonal" :color="hasReqFiles(r) ? 'success' : 'error'" rounded="lg">
                                <v-icon start size="x-small">{{ hasReqFiles(r) ? 'mdi-check' : 'mdi-upload' }}</v-icon>{{ hasReqFiles(r) ? 'file uploaded' : 'upload required' }}
                            </v-chip>
                            <v-chip v-else size="x-small" :variant="modern ? 'outlined' : 'tonal'" color="grey" rounded="lg">optional</v-chip>
                            <v-chip
                                v-if="mergedReqAttachments(r).length"
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                rounded="lg"
                            >
                                <v-icon start size="x-small">mdi-paperclip</v-icon>{{ mergedReqAttachments(r).length }}
                            </v-chip>
                        </div>
                        <!-- Picker above, uploaded files at the bottom. -->
                        <AttachmentUploader
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            :requirement-id="r.definition.id"
                            :model-value="getReqFiles(r.definition.id)"
                            :hint-text="uploadRequired(r) ? reqHintText(r) : ''"
                            :hint-type="reqHintType(r)"
                            :show-list="false"
                            minimal
                            :show-header="false"
                            file-action="download"
                            :disabled="isUploadLocked(r) || saving || savingChecklist"
                            @update:model-value="(files) => setReqFiles(r.definition.id, files)"
                            @uploaded="() => emit('requirement-uploaded', r.definition.id)"
                            @deleted="(id) => emit('attachment-deleted', id)"
                        />
                        <div v-if="showExistingBtn" class="d-flex align-center ga-2 mt-2 mb-3">
                            <v-btn
                                size="small"
                                variant="tonal"
                                rounded="0"
                                prepend-icon="mdi-history"
                                :disabled="isUploadLocked(r) || saving || savingChecklist"
                                @click="openExisting(r)"
                            >Existing files</v-btn>
                            <span class="text-caption text-medium-emphasis">from {{ prevStepLabel }}</span>
                        </div>
                        <AttachmentList
                            :items="mergedReqAttachments(r)"
                            :tx-id="txId"
                            :is-admin="isAdmin"
                            :current-step-id="currentStepId"
                            mark-old-files
                            detailed
                            :show-details="false"
                            action="download"
                            @deleted="(id) => onReqAttachmentDeleted(r, id)"
                        />
                            </div>
                        </div>
                    </v-card>
                </div>
                <ProceedFooter
                    v-model:remarks="remarks"
                    v-model:proceed-attachments="proceedAttachments"
                    v-model:attachment-name="attachmentName"
                    v-model:flagged="flagged"
                    :tx-id="txId"
                    :is-admin="isAdmin"
                    :is-return-selected="isReturnSelected"
                    :checklist="checklist"
                    :show-checklist="showChecklist"
                    :missing-required-upload-labels="missingRequiredUploadLabels"
                    :missing-required-tick-labels="missingRequiredTickLabels"
                    :missing-required-checklist-labels="missingRequiredChecklistLabels"
                    :missing-required-fields="missingRequiredFields"
                    :execute-error="executeError"
                    :remarks-label="remarksLabel"
                    :remarks-placeholder="remarksPlaceholder"
                    :attachments-title="attachmentsTitle"
                    :modern="modern"
                    :show-existing-btn="showExistingBtn"
                    :existing-disabled="saving || savingChecklist"
                    @attachment-deleted="(id) => emit('attachment-deleted', id)"
                    @open-existing="openExistingAdditional"
                />
            </v-window-item>
        </v-window>

        <v-dialog v-model="existingDialog" max-width="700" scrollable>
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title class="px-6 pt-5 pb-4">
                    <div class="d-flex align-center ga-3">
                        <v-avatar color="grey-darken-3" rounded="lg" size="40">
                            <v-icon color="white">mdi-history</v-icon>
                        </v-avatar>
                        <div class="text-h6 font-weight-bold" style="line-height: 1.25">
                            Select file from {{ prevStepLabel }}
                        </div>
                    </div>
                    <div class="text-caption text-medium-emphasis mt-1">
                        Reuse a file without re-uploading
                    </div>
                </v-card-title>
                <v-divider />
                <v-card-text class="px-6 pt-4 pb-2">
                    <div v-if="existingForAdditional" class="text-body-2 mb-2">
                        Link a file already uploaded in
                        <b>{{ prevStepLabel }}</b> into your Additional files without re-uploading.
                    </div>
                    <div v-else class="text-body-2 mb-2">
                        Link a file already uploaded for
                        <b>{{ existingTarget?.definition?.name }}</b> without re-uploading.
                    </div>
                    <v-text-field
                        v-model="existingSearch"
                        label="Search files"
                        placeholder="File name, requirement, uploader…"
                        variant="outlined"
                        density="compact"
                        hide-details="auto"
                        prepend-inner-icon="mdi-magnify"
                        class="mb-3"
                    />
                    <v-alert v-if="existingError" type="error" variant="tonal" density="compact" class="mb-3">
                        {{ existingError }}
                    </v-alert>
                    <div v-if="filteredExisting.length" class="d-flex flex-column ga-2">
                        <template v-for="(row, i) in groupedExisting" :key="row.kind === 'sep' ? `sep-${i}` : row.file.id">
                            <div v-if="row.kind === 'sep'" class="d-flex align-center ga-2 mt-1">
                                <v-divider />
                                <span class="text-caption text-medium-emphasis text-no-wrap flex-shrink-0">Additional files</span>
                                <v-divider />
                            </div>
                            <div
                                v-else
                                class="d-flex align-center ga-2 pa-3 rounded"
                                style="border: 1px solid rgba(0,0,0,0.12)"
                            >
                                <v-icon color="error">{{ 'mdi-file-document' }}</v-icon>
                                <div class="flex-1-1" style="min-width: 0">
                                    <div class="text-body-2 text-truncate font-weight-medium">{{ row.file.original_name }}</div>
                                    <div class="d-flex flex-wrap align-center ga-1 my-1">
                                        <v-chip
                                            v-if="sourceStepLabel(row.file)"
                                            size="x-small"
                                            variant="tonal"
                                            color="grey-darken-3"
                                            rounded="lg"
                                        ><v-icon start size="x-small">mdi-source-branch</v-icon>{{ sourceStepLabel(row.file) }}</v-chip>
                                        <v-chip
                                            v-if="row.file.requirement?.name"
                                            size="x-small"
                                            variant="flat"
                                            color="blue-grey"
                                            rounded="lg"
                                        >{{ row.file.requirement.name }}</v-chip>
                                        <v-chip
                                            v-if="row.file.label"
                                            size="x-small"
                                            variant="flat"
                                            color="blue-grey"
                                            rounded="lg"
                                        >{{ row.file.label }}</v-chip>
                                    </div>
                                    <div class="text-caption text-medium-emphasis">
                                        {{ formatPrevSize(row.file.size_bytes) }}
                                        <span v-if="row.file.uploader?.name || row.file.uploaded_by?.name"> · {{ row.file.uploader?.name || row.file.uploaded_by?.name }}</span>
                                    </div>
                                </div>
                                <v-btn
                                    size="x-small"
                                    variant="text"
                                    color="grey-darken-1"
                                    icon="mdi-eye-outline"
                                    :title="`View ${row.file.original_name}`"
                                    :href="fileViewUrl(row.file)"
                                    target="_blank"
                                    rel="noopener"
                                    :disabled="!fileViewUrl(row.file)"
                                    @click.stop
                                />
                                <v-btn
                                    size="small"
                                    variant="tonal"
                                    rounded="0"
                                    color="grey-darken-3"
                                    :loading="existingSavingId === row.file.id"
                                    :disabled="existingSavingId !== null"
                                    @click="selectExisting(row.file)"
                                >Use file</v-btn>
                            </div>
                        </template>
                    </div>
                    <div v-else class="text-caption text-medium-emphasis">No files found in {{ prevStepLabel }}.</div>
                    <v-alert type="info" variant="tonal" density="compact" class="mt-3">
                        Linked files stay owned by {{ prevStepLabel }}. You can remove the reference from your step,
                        but only the previous step's delete removes it everywhere — then this requirement shows as missing again.
                    </v-alert>
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end px-6 py-4">
                    <v-btn variant="text" :disabled="existingSavingId !== null" @click="existingDialog = false">Close</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import StepInfoFields from '@/components/StepInfoFields.vue'
import StepDataFields from '@/components/StepDataFields.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import AttachmentList from '@/components/AttachmentList.vue'
import ProceedFooter from '@/components/ProceedFooter.vue'
import { useApi } from '@/composables/useApi'
import { fileViewUrl, isOfficeDoc } from '@/composables/useFileView'

// Wizard step + remarks + move-level attachments are two-way bound to the parent
// so staged station-info `form` (mutated in place) is never wiped.
const step = defineModel('step', { default: 1 })
const remarks = defineModel('remarks', { default: '' })
const proceedAttachments = defineModel('proceedAttachments', { default: () => [] })
const attachmentName = defineModel('attachmentName', { default: '' })
// Step-data draft keyed by definition code; sent as `step_data` on Proceed.
const stepDataForm = defineModel('stepDataForm', { default: () => ({}) })
// Structured return flags, two-way bound to the page (sent as
// flagged_items on execute). Passed down to both footers.
const flagged = defineModel('flagged', { default: () => [] })

const props = defineProps({
    txId: { type: [Number, String], required: true },
    isAdmin: { type: Boolean, default: false },
    // Current step id: requirement files that already moved forward are
    // locked (remove buttons hide). Passed from detail pages / dialogs.
    currentStepId: { type: [Number, String], default: null },
    // tx.current_step_requirements — current step only.
    requirements: { type: Array, default: () => [] },
    // tx.current_step_checklist — mirrors the previous station's requirements.
    checklist: { type: Array, default: () => [] },
    // tx.current_step_fields
    fields: { type: Array, default: () => [] },
    // tx.current_step_data — per-step text values (e.g. receipt number).
    stepData: { type: Array, default: () => [] },
    // Shared page draft object, mutated in place by StepInfoFields.
    form: { type: Object, required: true },
    selectedActionLabel: { type: String, default: '' },
    selectedRouteId: { type: [Number, String, null], default: null },
    isReturnSelected: { type: Boolean, default: false },
    // True when the modal is completing the last station (Complete Step).
    // Switches copy like "Requirements to Complete step".
    isCompleting: { type: Boolean, default: false },
    // False for step 1 → step 2: requirements only, checklist hidden entirely.
    showChecklist: { type: Boolean, default: true },
    missingRequiredUploadLabels: { type: Array, default: () => [] },
    missingRequiredTickLabels: { type: Array, default: () => [] },
    missingRequiredChecklistLabels: { type: Array, default: () => [] },
    missingRequiredFields: { type: Array, default: () => [] },
    executeError: { type: String, default: '' },
    saving: { type: Boolean, default: false },
    savingChecklist: { type: Boolean, default: false },
    savingChecklistItemId: { type: [Number, String, null], default: null },
    savingRequirementId: { type: [Number, String, null], default: null },
    remarksLabel: { type: String, default: 'Remarks (optional)' },
    remarksPlaceholder: { type: String, default: '' },
    attachmentsTitle: { type: String, default: 'Additional files' },
    // Previous station context (last move only, read-only): { step, run, fields, step_data }.
    prevContext: { type: Object, default: null },
    // Redesign flags (proceed modal mockup; My-transaction dialog only).
    // `modern` restyles pills, counters, hints and validation lines.
    // `singlePage` renders the numbered single-scroll layout (first step only).
    modern: { type: Boolean, default: false },
    singlePage: { type: Boolean, default: false },
    // Full transaction file list (tx.attachments) for the "Existing files"
    // picker. Filtered to the immediately previous step number only.
    existingAttachments: { type: Array, default: () => [] },
    currentStepOrder: { type: [Number, String], default: 1 },
    workflowSteps: { type: Array, default: () => [] },
})

// Page 2 holds the uploads. In single-page mode (step 1 → step 2) it is the
// only page: remarks + move attachments render below the uploads.
const hasRequirements = computed(() => (props.requirements || []).length > 0)
// Per-step text data present on this station (receipt number, etc.).
const hasStepData = computed(() => (props.stepData || []).length > 0)
const hasProceedContent = computed(
    () => hasRequirements.value || hasStepData.value || (props.checklist || []).length > 0 || (props.fields || []).length > 0,
)

// Redesign flags: numbered "Step N:" section headers only in the
// single-page first-step layout; modern counters/pills whenever modern.
const numberedSection = computed(() => props.modern && props.singlePage)
const sectionNumbers = computed(() => {
    const nums = { info: 0, dataStart: 1, reqs: 0 }
    let n = 0
    if ((props.fields || []).length) nums.info = ++n
    nums.dataStart = n + 1
    n += (props.stepData || []).length
    if ((props.requirements || []).length) nums.reqs = ++n
    return nums
})

// Required-only tick counter ("2 of 2 required ticked").
const requiredTotalCount = computed(() => (props.requirements || []).filter((r) => !!r?.pivot?.is_required).length)
const requiredTickedCount = computed(
    () => (props.requirements || []).filter((r) => !!r?.pivot?.is_required && !!r.checked).length,
)

// Checklist verify counter ("1 of 3 verified").
const verifiedChecklistCount = computed(() => (props.checklist || []).filter((c) => !!c.checked).length)
const checklistComplete = computed(
    () => (props.checklist || []).length > 0 && verifiedChecklistCount.value >= (props.checklist || []).length,
)
// Items the previous station flagged when returning this work.
const flaggedChecklist = computed(() => (props.checklist || []).filter((c) => !!c.flagged_on_return))

// Previous station context (last move only, read-only) shown above Checklist.
const prevStepTitle = computed(() => {
    const s = props.prevContext?.step
    if (!s) return ''
    const n = s.order_number
    const name = s.name || `Step ${n ?? ''}`
    const office = s.office?.code || s.office?.name
    const prefix = n != null && n !== '' ? `${n}. ` : ''
    return office ? `${prefix}${name} (${office})` : `${prefix}${name}`
})
const prevRunBy = computed(() => {
    const run = props.prevContext?.run
    if (!run) return ''
    const who = run.performed_by?.name || ''
    const when = run.performed_at ? new Date(run.performed_at).toLocaleString() : ''
    return [who, when].filter(Boolean).join(' · ')
})
const hasPrevRemarks = computed(() => !!String(props.prevContext?.run?.remarks || '').trim())
const prevRemarksText = computed(() => props.prevContext?.run?.remarks || '')
const prevFieldRows = computed(() => props.prevContext?.fields || [])
const prevStepDataRows = computed(() => props.prevContext?.step_data || [])
const hasPrevDataRows = computed(() => prevFieldRows.value.length > 0 || prevStepDataRows.value.length > 0)
const hasPrevFiles = computed(() => (props.prevContext?.attachments || []).length > 0)

function displayPrevValue(v) {
    if (v === null || v === undefined || v === '') return '—'
    if (Array.isArray(v)) return v.length ? v.join(', ') : '—'
    if (typeof v === 'object') return JSON.stringify(v)
    return String(v)
}

// "PR with number" rows are proceed-only: hide their tick + upload card
// when returning (main-bar return or in-modal return mode).
function isPrNumberRow(r) {
    const code = String(r?.definition?.code || '').toLowerCase().replace(/[^a-z0-9]/g, '');
    if (code === 'prnumber' || code === 'prwithnumber' || code === 'prno' || code === 'prnum') return true;
    const name = String(r?.definition?.name || '').toLowerCase();
    return /\bpr\b/.test(name) && name.includes('number');
}

// Page 2 display order: required first, then tick-only rows before
// file-input (uploader) rows within each band. Further ties keep backend
// display_order, then name. Length/empty checks keep using props.requirements.
const sortedRequirements = computed(() => {
    return [...(props.requirements || [])]
        .map((r, i) => ({ r, i }))
        .sort((a, b) => {
            const ar = a.r?.pivot?.is_required ? 0 : 1
            const br = b.r?.pivot?.is_required ? 0 : 1
            if (ar !== br) return ar - br
            const au = uploadRequired(a.r) ? 1 : 0
            const bu = uploadRequired(b.r) ? 1 : 0
            if (au !== bu) return au - bu
            const ao = a.r?.pivot?.display_order ?? a.i
            const bo = b.r?.pivot?.display_order ?? b.i
            if (ao !== bo) return ao - bo
            return String(a.r?.definition?.name ?? '').localeCompare(String(b.r?.definition?.name ?? ''))
        })
        .map((x) => x.r)
})

// Tick group hides "PR with number" rows on return (upload-only there —
// no verify tick), while the upload card below keeps them so the file
// can still travel with the return.
const tickRequirements = computed(() => props.isReturnSelected
    ? sortedRequirements.value.filter((r) => !isPrNumberRow(r))
    : sortedRequirements.value,
)

// Group card order: true upload inputs first, then tick-only sections.
// Stable sort preserves the required-first order inside each band.
// Built from the visible (return-filtered) rows so PR cards hide on return.
const uploadFirstRequirements = computed(() => [...tickRequirements.value].sort(
    (a, b) => (uploadRequired(a) ? 0 : 1) - (uploadRequired(b) ? 0 : 1),
))

const emit = defineEmits([
    'toggle-requirement',
    'toggle-checklist',
    'requirement-uploaded',
    'attachment-deleted',
    'update:remarks',
    'update:proceedAttachments',
    'update:attachmentName',
])

function hasReqFiles(r) {
    return mergedReqAttachments(r).length > 0
}

// Required rows stay locked until their top tick is checked
// (upload cards + optional pickers alike; return mode exempts the
// lock; optional rows never lock).
function isUploadLocked(r) {
    if (props.isReturnSelected) return false
    if (!r?.pivot?.is_required) return false
    return !r.checked
}

// Inline status beside the picker button. Success shows no text — the
// section and top chips flip to their done states instead.
function reqHintText(r) {
    if (isUploadLocked(r)) return `Tick ${r.definition.name} above to enable uploads.`
    if (hasReqFiles(r)) return ''
    if (!props.isReturnSelected) return 'Attach at least one file to unlock Proceed.'
    return ''
}

function reqHintType() {
    return 'error'
}

// Single list above the input: server files + staged session files,
// deduped by id (server copy wins after refresh).
function mergedReqAttachments(r) {
    const server = r.attachments || []
    const staged = getReqFiles(r.definition.id) || []
    const seen = new Set(server.map((a) => a.id))
    return [...server, ...staged.filter((a) => !seen.has(a.id))]
}

// Delete from the merged list: always delete the server row (staged
// copies are already persisted on upload), and drop any staged copy so
// the card never reappears or gets deleted twice.
function onReqAttachmentDeleted(r, id) {
    const staged = getReqFiles(r.definition.id) || []
    if (staged.some((a) => a.id === id)) {
        setReqFiles(r.definition.id, staged.filter((a) => a.id !== id))
    }
    emit('attachment-deleted', id)
}

// LINE 1 marker reads is_required; LINE 2 gate reads is_upload_required
// (falls back to is_required for payloads that predate the split).
function uploadRequired(r) {
    return !!((r?.pivot?.is_upload_required ?? r?.pivot?.is_required) ?? false)
}

// Files opened in a new tab: PDFs/images/text render natively, office
// docs (docx/xlsx/ppt) go through the Google Docs viewer fallback.
function isViewable(a) {
    if (isOfficeDoc(a)) return true
    const mime = String(a?.mime || '').toLowerCase()
    if (
        mime === 'application/pdf' ||
        mime.startsWith('image/') ||
        mime.startsWith('text/')
    ) return true
    return /\.(pdf|png|jpe?g|gif|webp|svg|bmp|txt|csv|log|docx?|xlsx?|pptx?|odt|ods|odp|rtf)$/i.test(String(a?.original_name || ''))
}

function viewableFiles(c) {
    return (c?.attachments || []).filter(isViewable)
}

// Files uploaded per requirement in this wizard session. Server already
// persists them (requirement_definition_id), this is only for instant counts.
const reqFiles = ref({})

function getReqFiles(id) {
    return reqFiles.value[id] || []
}

function setReqFiles(id, files) {
    reqFiles.value = { ...reqFiles.value, [id]: [...(files || [])] }
}

function clearReqFiles() {
    reqFiles.value = {}
}

function removeReqFile(id) {
    const next = {}
    for (const [key, files] of Object.entries(reqFiles.value || {})) {
        next[key] = (files || []).filter((a) => a.id !== id)
    }
    reqFiles.value = next
}

// "Existing files" picker: reuse a file from the immediately previous
// step number (step 5 sees step 4 only). Step 1 has no predecessor, so
// the button never renders there.
const prevStep = computed(() => {
    const cur = Number(props.currentStepOrder)
    if (!Number.isFinite(cur) || cur <= 1) return null
    return (props.workflowSteps || []).find((s) => Number(s.order_number) === cur - 1) || null
})
const prevStepLabel = computed(() => {
    if (!prevStep.value) return ''
    const n = prevStep.value.order_number
    const name = prevStep.value.name || prevStep.value.code || ''
    return `Step ${n}${name ? ` · ${name}` : ''}`
})
const eligiblePrevFiles = computed(() => {
    if (!prevStep.value) return []
    const pid = Number(prevStep.value.id)
    return (props.existingAttachments || []).filter(
        (a) => Number(a.workflow_step_id) === pid && !a.source_attachment_id && !a.is_linked,
    )
})
const showExistingBtn = computed(() => !!prevStep.value && eligiblePrevFiles.value.length > 0)

const { api } = useApi()
const existingDialog = ref(false)
const existingTarget = ref(null)
const existingForAdditional = ref(false)
const existingSearch = ref('')
const existingError = ref('')
const existingSavingId = ref(null)

function openExisting(r) {
    existingTarget.value = r
    existingForAdditional.value = false
    existingSearch.value = ''
    existingError.value = ''
    existingSavingId.value = null
    existingDialog.value = true
}

function openExistingAdditional() {
    existingTarget.value = null
    existingForAdditional.value = true
    existingSearch.value = ''
    existingError.value = ''
    existingSavingId.value = null
    existingDialog.value = true
}

const filteredExisting = computed(() => {
    const q = String(existingSearch.value || '').trim().toLowerCase()
    if (!q) return eligiblePrevFiles.value
    return eligiblePrevFiles.value.filter((a) => {
        const hay = [
            a.original_name,
            a.label,
            a.requirement?.name,
            a.requirement?.code,
            a.uploader?.name,
            a.uploaded_by?.name,
            sourceStepLabel(a),
        ].filter(Boolean).join(' ').toLowerCase()
        return hay.includes(q)
    })
})

// Proceed-level (Additional files) rows carry a label and no requirement;
// requirement-bound rows carry requirement_definition_id.
function isAdditionalFile(f) {
    return !f?.requirement_definition_id
}

const existingReqFiles = computed(() => filteredExisting.value.filter((f) => !isAdditionalFile(f)))
const existingAdditionalFiles = computed(() => filteredExisting.value.filter(isAdditionalFile))

// Picker order: requirement files first, then a labelled separator,
// then Additional files at the bottom. The separator always shows above
// Additional files whenever that section is non-empty.
const groupedExisting = computed(() => {
    const rows = existingReqFiles.value.map((f) => ({ kind: 'file', file: f }))
    if (existingAdditionalFiles.value.length) {
        rows.push({ kind: 'sep' })
        for (const f of existingAdditionalFiles.value) rows.push({ kind: 'file', file: f })
    }
    return rows
})

// "Step N · Station name" for a previous-step file card. Resolves the
// order number from workflowSteps (the API step payload has no
// order_number); falls back to the dialog-level prevStepLabel.
function sourceStepLabel(f) {
    const match = (props.workflowSteps || []).find(
        (s) => Number(s.id) === Number(f?.workflow_step_id),
    )
    if (match) {
        const n = match.order_number
        const name = match.name || match.code || f?.step?.name || ''
        return `Step ${n}${name ? ` · ${name}` : ''}`
    }
    if (f?.step?.name) return f.step.name
    return prevStepLabel.value
}

function formatPrevSize(b) {
    const n = Number(b || 0)
    if (n < 1024) return `${n} B`
    if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`
    return `${(n / 1024 / 1024).toFixed(1)} MB`
}

async function selectExisting(f) {
    if (existingSavingId.value !== null) return
    if (!existingForAdditional.value && !existingTarget.value) return
    existingSavingId.value = f.id
    existingError.value = ''
    try {
        const base = props.isAdmin
            ? `/api/admin/transactions/${props.txId}/attachments/reuse`
            : `/api/transactions/${props.txId}/attachments/reuse`
        if (existingForAdditional.value) {
            // Proceed-level (Additional files) link: auto-carry the source name.
            const res = await api.post(base, { source_attachment_id: f.id })
            const created = res.data?.data ?? res.data
            if (created && created.id) {
                proceedAttachments.value = [...(proceedAttachments.value || []), created]
            }
            emit('requirement-uploaded', null)
        } else {
            await api.post(base, {
                source_attachment_id: f.id,
                requirement_definition_id: existingTarget.value.definition.id,
            })
            emit('requirement-uploaded', existingTarget.value.definition.id)
        }
        existingDialog.value = false
        existingTarget.value = null
        existingForAdditional.value = false
    } catch (e) {
        existingError.value = e?.response?.data?.message || 'Failed to link file.'
    } finally {
        existingSavingId.value = null
    }
}

defineExpose({ clearReqFiles, getReqFiles, removeReqFile })
</script>

<style scoped>
.wizard-stepper {
    background: transparent;
}

/* Animated broken-line connector between Review (orange) and Requirements (blue).
   Uses Vuetify's own divider layout so Review/Requirements stay aligned. */
.wizard-stepper .wizard-connector {
    border: 0 !important;
    border-top: 0 !important;
    min-height: 2px;
    height: 2px;
    background-color: transparent !important;
    background-image: linear-gradient(to right, currentColor 55%, transparent 45%) !important;
    background-size: 10px 2px !important;
    background-repeat: repeat-x !important;
    opacity: 0.6;
    animation: wizard-dash-move 1.2s linear infinite;
}
@keyframes wizard-dash-move {
    from { background-position-x: 0; }
    to { background-position-x: 20px; }
}

/* Stepper circles: Review orange, Requirements blue. Pale opposite state
   enforced via step-bound classes (Vuetify ignores color on inactive). */
.wizard-stepper .review-step {
    --v-stepper-item-color: var(--v-theme-warning);
}
.wizard-stepper .req-step {
    --v-stepper-item-color: var(--v-theme-primary);
}
.wizard-stepper.is-step-1 :deep(.req-step .v-avatar),
.wizard-stepper.is-step-1 :deep(.req-step .v-stepper-item__avatar) {
    background-color: #BFDBFE !important;
    border-color: #BFDBFE !important;
    color: #005EED !important;
}
.wizard-stepper.is-step-2 :deep(.review-step .v-avatar),
.wizard-stepper.is-step-2 :deep(.review-step .v-stepper-item__avatar) {
    background-color: #FDE68A !important;
    border-color: #FDE68A !important;
    color: #92400E !important;
}
</style>
