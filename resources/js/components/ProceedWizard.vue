<template>
    <div class="pm-wizard">
        <!-- Two-step wizard indicator: Review → Requirements. Tabs are a
             read-only indicator; Back/Next in the modal footer drive it. -->
        <div
            v-if="showChecklist && hasProceedContent && !singlePage && hasRequirementPage"
            class="pm-tabs"
            :class="{ 'is-return': isReturnSelected }"
            role="tablist"
            aria-label="Proceed steps"
        >
            <button
                type="button"
                class="pm-tab"
                :class="{ 'is-active': step === 1 }"
                role="tab"
                :aria-selected="step === 1"
                @click="goToStep(1)"
            >Review</button>
            <button
                type="button"
                class="pm-tab"
                :class="{ 'is-active': step === 2 }"
                role="tab"
                :aria-selected="step === 2"
                :disabled="requirementsTabDisabled"
                :title="requirementsTabDisabled ? 'Complete the required Review items first.' : ''"
                @click="goToStep(2)"
            >Requirements</button>
        </div>

        <!-- Return destination selector sits below the Review/Requirements
             tabs but above the page content. -->
        <slot name="after-tabs" />

        <v-window v-model="step">
            <!-- PAGE 1: review — previous context, return flags and checklist. -->
            <v-window-item v-if="showChecklist && !singlePage" :value="1" data-pm-page="1">
                <!-- Single-step fallback: no requirements, so station info lives here -->
                <section v-if="!hasRequirements && ((fields || []).length || (stepData || []).length)" class="pm-section">
                    <div class="pm-sh"><h3>Station information</h3></div>
                    <StepInfoFields :fields="fields" :form="form" modern />
                    <StepDataFields v-model:form="stepDataForm" :step-data="stepData" :saving="saving" modern />
                </section>

                <!-- Previous station remarks (last move only, read-only). -->
                <section v-if="prevContext && hasPrevRemarks && !flaggedChecklist.length" class="pm-section">
                    <div class="pm-sh"><h3>From {{ prevStepTitle }}</h3></div>
                    <div class="pm-note">
                        <v-icon size="18">mdi-message-text-outline</v-icon>
                        <div style="min-width: 0">
                            <b>Remarks</b>
                            <div>{{ prevRemarksText }}</div>
                            <div v-if="prevRunBy" class="pm-hint">{{ prevRunBy }}</div>
                        </div>
                    </div>
                </section>

                <!-- Previous station data (last move only, read-only). -->
                <section v-if="hasPrevDataRows" class="pm-section">
                    <div class="pm-sh"><h3>Data from {{ prevStepTitle }}</h3></div>
                    <div class="pm-note">
                        <v-icon size="18">mdi-table</v-icon>
                        <div style="min-width: 0; flex: 1">
                            <div v-for="f in prevFieldRows" :key="f.code || f.name" class="pm-data-row">
                                <span>{{ f.name }}</span>
                                <span>{{ displayPrevValue(f.value) }}</span>
                            </div>
                            <div v-for="d in prevStepDataRows" :key="d.code || d.name" class="pm-data-row">
                                <span>{{ d.name }}</span>
                                <span>{{ displayPrevValue(d.value) }}</span>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Flagged-on-return card (with the returning remarks when present). -->
                <section v-if="flaggedChecklist.length" class="pm-section">
                    <div class="pm-warn-card">
                        <template v-if="prevContext && hasPrevRemarks">
                            <div class="pm-warn-title">
                                <v-icon size="17">mdi-message-alert-outline</v-icon>
                                Remarks from {{ prevStepTitle }}
                            </div>
                            <p style="color: var(--pm-ink)">{{ prevRemarksText }}</p>
                            <div v-if="prevRunBy" class="pm-hint" style="margin-bottom: 12px">{{ prevRunBy }}</div>
                        </template>
                        <div class="pm-warn-title">
                            <v-icon size="17">mdi-flag-outline</v-icon>
                            Flagged on return
                        </div>
                        <p>The returning station flagged these items for re-check.</p>
                        <div class="pm-flag-row">
                            <span
                                v-for="c in flaggedChecklist"
                                :key="c.id ?? c.name"
                                class="pm-flag-pill is-on"
                            >
                                <v-icon size="13">mdi-flag</v-icon>
                                {{ c.name }}
                                <a
                                    v-for="a in viewableFiles(c)"
                                    :key="`flag-eye-${c.id ?? c.name}-${a.id}`"
                                    :href="fileViewUrl(a)"
                                    target="_blank"
                                    rel="noopener"
                                    style="color: inherit; display: inline-flex"
                                    :title="`View ${a.original_name}`"
                                    @click.stop
                                ><v-icon size="14">mdi-eye-outline</v-icon></a>
                            </span>
                        </div>
                    </div>
                </section>

                <!-- Checklist: tick to confirm. Required ticks block Proceed. -->
                <section class="pm-section">
                    <div class="pm-sh">
                        <h3>Checklist</h3>
                        <span
                            v-if="(checklist || []).length"
                            class="pm-count"
                            :style="checklistComplete ? 'color: var(--pm-ok)' : ''"
                        >{{ verifiedChecklistCount }} of {{ (checklist || []).length }} verified</span>
                    </div>
                    <p v-if="isReturnSelected" class="pm-hint">Return action — checklist not required.</p>
                    <p v-else-if="!(checklist || []).length" class="pm-hint">No checklist items for this station.</p>
                    <p v-else class="pm-hint">Tick each box when you have seen the hard copies. Required items must be ticked.</p>

                    <div v-if="!isReturnSelected && (checklist || []).length" class="pm-checks pm-checks--single">
                        <div
                            v-for="c in (checklist || [])"
                            :key="c.id"
                            class="pm-check pm-check--stack"
                            :class="{ 'is-open': checklistFilesOpen(c) }"
                            :data-pm-task="c.name"
                        >
                            <div class="pm-check-row">
                                <label class="pm-check-main">
                                    <input
                                        type="checkbox"
                                        :checked="!!c.checked"
                                        :disabled="saving || savingChecklist"
                                        @change="emit('toggle-checklist', c, $event.target.checked)"
                                    />
                                    <span class="pm-box"><v-icon size="14">mdi-check</v-icon></span>
                                    <span class="pm-nm" :title="c.name">{{ c.name }}</span>
                                </label>
                                <span class="pm-tag" :class="c.is_required ? 'r' : 'o'">{{ c.is_required ? 'Required' : 'Optional' }}</span>
                                <v-progress-circular
                                    v-if="savingChecklist && savingChecklistItemId === c.id"
                                    size="14"
                                    indeterminate
                                    color="primary"
                                />
                                <button
                                    v-if="checklistFiles(c).length"
                                    type="button"
                                    class="pm-file-toggle"
                                    :aria-expanded="checklistFilesOpen(c) ? 'true' : 'false'"
                                    :title="checklistFilesOpen(c) ? `Hide files for ${c.name}` : `View files for ${c.name}`"
                                    @click="toggleChecklistFiles(c)"
                                >
                                    <v-icon size="14">mdi-paperclip</v-icon>
                                    {{ checklistFiles(c).length }} file{{ checklistFiles(c).length === 1 ? '' : 's' }}
                                    <v-icon size="16" class="pm-file-toggle-chevron">mdi-chevron-down</v-icon>
                                </button>
                            </div>
                            <div v-if="checklistFiles(c).length && checklistFilesOpen(c)" class="pm-check-files">
                                <AttachmentList
                                    :items="checklistFiles(c)"
                                    :tx-id="txId"
                                    :is-admin="isAdmin"
                                    redesign
                                    hide-delete
                                    :show-details="false"
                                    action="view"
                                    :redesign-limit="checklistFiles(c).length"
                                />
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Previous step's Additional files (last move only, view-only). -->
                <section v-if="hasPrevFiles" class="pm-section">
                    <div class="pm-sh">
                        <h3>Previous files</h3>
                        <span class="pm-count">{{ (prevContext?.attachments || []).length }} file{{ (prevContext?.attachments || []).length === 1 ? '' : 's' }}</span>
                    </div>
                    <AttachmentList
                        :items="prevContext?.attachments || []"
                        :tx-id="txId"
                        :is-admin="false"
                        redesign
                        group-by-label
                        collapsible-groups
                        :groups-open-by-default="false"
                        hide-delete
                        :show-details="false"
                        action="view"
                    />
                </section>

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

            <!-- PAGE 2: requirements + per-item uploads + station info. -->
            <v-window-item v-if="hasRequirements || hasStepData || !showChecklist || isCompleting" :value="singlePage ? 1 : 2" data-pm-page="2">
                <!-- Requirement ticks (forward moves only; Return carries
                     files/flags without re-verifying requirements). -->
                <section v-if="!isReturnSelected && tickRequirements.length" class="pm-section">
                    <div class="pm-sh">
                        <h3>{{ requirementTitle }}</h3>
                        <span v-if="requiredTotalCount > 0" class="pm-count">{{ requiredTickedCount }} of {{ requiredTotalCount }} required ticked</span>
                        <span v-else class="pm-count">{{ checkedTickCount }} of {{ tickRequirements.length }} ticked</span>
                    </div>
                    <p class="pm-hint">Tick each box when it is done. Items marked Required must be ticked.</p>
                    <div class="pm-checks">
                        <div
                            v-for="r in tickRequirements"
                            :key="r.definition.id"
                            class="pm-check"
                            :data-pm-task="r.definition.name"
                        >
                            <label class="pm-check-main">
                                <input
                                    type="checkbox"
                                    :checked="!!r.checked"
                                    :disabled="saving || savingChecklist"
                                    @change="emit('toggle-requirement', r, $event.target.checked)"
                                />
                                <span class="pm-box"><v-icon size="14">mdi-check</v-icon></span>
                                <span class="pm-nm" :title="r.definition.name">{{ r.definition.name }}</span>
                            </label>
                            <span class="pm-tag" :class="r?.pivot?.is_required ? 'r' : 'o'">{{ r?.pivot?.is_required ? 'Required' : 'Optional' }}</span>
                            <span v-if="r.flagged_on_return" class="pm-flag">
                                <v-icon size="12">mdi-flag</v-icon> Flagged
                            </span>
                            <v-progress-circular
                                v-if="savingChecklist && savingRequirementId === r.definition.id"
                                size="14"
                                indeterminate
                                color="primary"
                            />
                        </div>
                    </div>
                </section>

                <!-- Requirement uploads (forward moves only). -->
                <section v-if="!isReturnSelected && uploadFirstRequirements.length" class="pm-section">
                    <div class="pm-sh">
                        <h3>{{ uploadSectionTitle }}</h3>
                        <span v-if="requiredUploadCount > 0" class="pm-count">{{ attachedUploadCount }} of {{ requiredUploadCount }} required attached</span>
                        <span v-else class="pm-count">Optional uploads</span>
                    </div>
                    <div class="pm-upload-list">
                        <div
                            v-for="r in uploadFirstRequirements"
                            :key="r.definition.id"
                            class="pm-upload"
                            :class="uploadStateClass(r)"
                            :data-pm-task="r.definition.name"
                        >
                            <AttachmentUploader
                                :tx-id="txId"
                                :is-admin="isAdmin"
                                :requirement-id="r.definition.id"
                                :model-value="getReqFiles(r.definition.id)"
                                :show-list="false"
                                minimal
                                :show-header="false"
                                file-action="download"
                                redesign
                                :disabled="isUploadLocked(r) || saving || savingChecklist"
                                @update:model-value="(files) => setReqFiles(r.definition.id, files)"
                                @uploaded="() => emit('requirement-uploaded', r.definition.id)"
                                @deleted="(id) => emit('attachment-deleted', id)"
                            >
                                <template #header="{ open, uploading, disabled }">
                                    <div class="pm-uh">
                                        <span class="pm-sico">
                                            <v-icon size="17">{{ uploadIcon(r) }}</v-icon>
                                        </span>
                                        <div class="pm-ut">
                                            <b :title="r.definition.name">{{ r.definition.name }}</b>
                                            <span class="pm-meta">
                                                {{ uploadRequired(r) ? 'Required' : 'Optional' }}
                                                <i>{{ uploadFileLabel(r) }}</i>
                                            </span>
                                        </div>
                                        <button
                                            v-if="showExistingBtn"
                                            type="button"
                                            class="pm-lnk"
                                            :disabled="disabled"
                                            @click="openExisting(r)"
                                        >
                                            <v-icon size="15">mdi-history</v-icon>
                                            Reuse
                                        </button>
                                        <button
                                            type="button"
                                            class="pm-lnk"
                                            :disabled="disabled"
                                            @click="open"
                                        >
                                            <v-icon v-if="!uploading" size="15">mdi-paperclip</v-icon>
                                            {{ uploading ? 'Uploading…' : (hasReqFiles(r) ? 'Add more' : 'Choose files') }}
                                        </button>
                                    </div>
                                </template>
                            </AttachmentUploader>

                            <p v-if="uploadRequired(r) && reqHintText(r)" class="pm-hint is-error">{{ reqHintText(r) }}</p>

                            <AttachmentList
                                v-if="mergedReqAttachments(r).length"
                                :items="mergedReqAttachments(r)"
                                :tx-id="txId"
                                :is-admin="isAdmin"
                                :current-step-id="currentStepId"
                                mark-old-files
                                redesign
                                :show-details="false"
                                action="download"
                                @deleted="(id) => onReqAttachmentDeleted(r, id)"
                            />
                            <p v-else class="pm-empty">No file uploaded yet.</p>
                        </div>
                    </div>
                </section>

                <!-- Station info -->
                <section v-if="(fields || []).length" class="pm-section">
                    <div class="pm-sh"><h3>Station information</h3></div>
                    <StepInfoFields :fields="fields" :form="form" modern />
                </section>

                <!-- Step data -->
                <section v-if="(stepData || []).length" class="pm-section">
                    <div class="pm-sh"><h3>Step data</h3></div>
                    <StepDataFields
                        v-model:form="stepDataForm"
                        :step-data="stepData"
                        :saving="saving"
                        modern
                        :numbered="numberedSection"
                        :start-number="sectionNumbers.dataStart"
                    />
                </section>

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

        <ExistingFilePicker
            v-model:open="existingDialog"
            :files="eligiblePrevFiles"
            :step-label="prevStepLabel"
            :saving-id="existingSavingId"
            :error="existingError"
            @use="selectExisting"
        />
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import StepInfoFields from '@/components/StepInfoFields.vue'
import StepDataFields from '@/components/StepDataFields.vue'
import AttachmentUploader from '@/components/AttachmentUploader.vue'
import AttachmentList from '@/components/AttachmentList.vue'
import ExistingFilePicker from '@/components/ExistingFilePicker.vue'
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
    isCompleting: { type: Boolean, default: false },
    // False for step 1 → step 2: requirements only, checklist hidden entirely.
    showChecklist: { type: Boolean, default: true },
    // Lock the Requirements tab until the Review page's required items are
    // ticked (forward Proceed / Complete Step; Return leaves it enabled).
    requirementsTabDisabled: { type: Boolean, default: false },
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
// The second window item only exists when there is something after Review.
// Keep the tab strip in sync so clicking a tab can never land on a blank page.
const hasRequirementPage = computed(
    () => hasRequirements.value || hasStepData.value || !props.showChecklist || props.isCompleting,
)

// Tabs behave like Back/Next. Requirements are locked while required Review
// checklist items remain unticked; Return never locks because its checklist
// is informational only.
function goToStep(next) {
    if (next === 2 && props.requirementsTabDisabled) return
    if (!hasRequirementPage.value) return
    step.value = next
}
// Header counter (visual only): ticked / total. Gating still uses parents' missingRequired*.
const checkedRequirementsCount = computed(() => (props.requirements || []).filter((r) => !!r.checked).length)
const requirementsComplete = computed(
    () => (props.requirements || []).length > 0 && checkedRequirementsCount.value >= (props.requirements || []).length,
)
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
const checkedTickCount = computed(() => (props.requirements || []).filter((r) => !!r.checked).length)

// Checklist verify counter ("1 of 3 verified").
const verifiedChecklistCount = computed(() => (props.checklist || []).filter((c) => !!c.checked).length)
const checklistComplete = computed(
    () => (props.checklist || []).length > 0 && verifiedChecklistCount.value >= (props.checklist || []).length,
)
// Items the previous station flagged when returning this work.
const flaggedChecklist = computed(() => (props.checklist || []).filter((c) => !!c.flagged_on_return))

// Per-checklist-item file disclosure. Files are view-only here (the
// checklist mirrors the previous station's evidence); each row inside the
// expanded list owns its own View button.
const expandedChecklistFiles = ref({})
function checklistKey(c) {
    return String(c?.id ?? c?.name ?? '')
}
function checklistFiles(c) {
    return c?.attachments || []
}
function checklistFilesOpen(c) {
    return !!expandedChecklistFiles.value[checklistKey(c)]
}
function toggleChecklistFiles(c) {
    const key = checklistKey(c)
    expandedChecklistFiles.value = {
        ...expandedChecklistFiles.value,
        [key]: !expandedChecklistFiles.value[key],
    }
}

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

// Section copy adapts to the action mode while keeping the mockup headings.
const requirementTitle = computed(() => {
    if (props.isCompleting) return 'Requirement — complete step'
    if (props.isReturnSelected) return 'Requirement — return'
    return 'Requirement'
})
const uploadSectionTitle = computed(() => {
    if (props.isCompleting) return 'Requirement Upload — complete step'
    if (props.isReturnSelected) return 'Requirement Upload — return'
    return 'Requirement Upload'
})
const attachedUploadCount = computed(
    () => uploadFirstRequirements.value.filter((r) => uploadRequired(r) && hasReqFiles(r)).length,
)
const requiredUploadCount = computed(
    () => uploadFirstRequirements.value.filter((r) => uploadRequired(r)).length,
)

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

function reqHintType(r) {
    return 'error'
}

// Mockup upload-card states: locked (tick first), blocked (required but
// empty), complete (has at least one file) or optional/neutral.
function uploadStateClass(r) {
    if (isUploadLocked(r)) return 'is-locked'
    if (hasReqFiles(r)) return 'is-ok'
    if (uploadRequired(r)) return 'is-block'
    return 'is-opt'
}

function uploadIcon(r) {
    if (isUploadLocked(r)) return 'mdi-lock-outline'
    if (hasReqFiles(r)) return 'mdi-check'
    if (uploadRequired(r)) return 'mdi-upload-outline'
    return 'mdi-paperclip'
}

function uploadFileLabel(r) {
    const n = mergedReqAttachments(r).length
    if (!n) return 'No file yet'
    return n === 1 ? '1 file' : `${n} files`
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
const existingError = ref('')
const existingSavingId = ref(null)

function openExisting(r) {
    existingTarget.value = r
    existingForAdditional.value = false
    existingError.value = ''
    existingSavingId.value = null
    existingDialog.value = true
}

function openExistingAdditional() {
    existingTarget.value = null
    existingForAdditional.value = true
    existingError.value = ''
    existingSavingId.value = null
    existingDialog.value = true
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
