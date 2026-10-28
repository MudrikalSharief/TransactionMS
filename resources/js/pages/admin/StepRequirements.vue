<template>
    <div class="sr-page">
        <v-alert
            v-if="error"
            type="error"
            variant="tonal"
            density="compact"
            class="mb-4"
        >
            {{ error }}
        </v-alert>
        <v-alert
            v-if="continuationCheckError"
            type="warning"
            variant="tonal"
            density="compact"
            class="mb-4"
        >
            {{ continuationCheckError }}
        </v-alert>

        <WorkflowPageHeader
            icon="mdi-clipboard-check-outline"
            title="Requirements"
            subtitle="Choose a step and manage what workers must complete or upload."
            :version="defVersion"
            :status="defStatus"
            :is-live="defIsLive"
            :dirty="stagingDirty"
            :save-disabled="!stagingDirty"
            @back="goBack"
            @discard="discardStaged"
            @save="openSaveDialog"
        />

        <div class="sr-info">
            <v-icon size="20" class="sr-info-ic"
                >mdi-information-outline</v-icon
            >
            <span>
                <b>Staged assignment.</b>
                Edits stay local until you press Save version.
            </span>
        </div>

        <StagingSaveBar
            ref="saveBarRef"
            :type-id="typeId"
            :def-id="workflowDefinitionId"
            :inline-actions="false"
            @saved="afterBulkSaved"
            @discarded="loadAssigned"
        />

        <p class="sr-lbl">Select step</p>

        <div ref="stepMenuRef" class="sr-dd" @focusout="onStepMenuFocusOut">
            <button
                ref="stepTrigger"
                type="button"
                class="sr-trigger"
                :class="{ 'sr-trigger-open': stepMenuOpen }"
                :disabled="stepsLoading || !stepOptions.length"
                aria-haspopup="listbox"
                aria-controls="sr-step-menu"
                :aria-expanded="stepMenuOpen ? 'true' : 'false'"
                @click="toggleStepMenu"
                @keydown="onTriggerKeydown"
            >
                <span class="sr-sr-only">Select step</span>
                <span class="sr-step-n">{{
                    selectedStep?.order_number ?? "-"
                }}</span>
                <span class="sr-step-tx">
                    <b>{{
                        selectedStep?.name ||
                        (stepsLoading ? "Loading steps…" : "Select a step")
                    }}</b>
                    <small>{{
                        selectedStep?.code || "No step selected"
                    }}</small>
                </span>
                <span v-if="selectedStep" class="sr-count">
                    {{ countLabel(stepRequirementCount(selectedStep.id)) }}
                </span>
                <v-icon
                    class="sr-chev"
                    :class="{ 'sr-chev-open': stepMenuOpen }"
                    size="20"
                >
                    mdi-chevron-down
                </v-icon>
            </button>

            <div
                v-if="stepMenuOpen"
                id="sr-step-menu"
                class="sr-menu"
                role="listbox"
                aria-label="Steps"
            >
                <button
                    v-for="(option, index) in stepOptions"
                    :key="option.id"
                    :ref="(el) => setStepOptionEl(el, index)"
                    type="button"
                    class="sr-option"
                    :class="{ 'sr-option-selected': isSelectedStep(option.id) }"
                    role="option"
                    :aria-selected="
                        isSelectedStep(option.id) ? 'true' : 'false'
                    "
                    @click="selectStep(option.id)"
                    @keydown="onStepOptionKeydown($event, index)"
                >
                    <span class="sr-option-n">{{ option.order_number }}</span>
                    <span class="sr-option-tx">
                        <b>{{ option.name }}</b>
                        <small>{{ option.code }}</small>
                    </span>
                    <span class="sr-count">{{ countLabel(option.count) }}</span>
                    <v-icon
                        class="sr-option-ck"
                        :class="{
                            'sr-option-ck-on': isSelectedStep(option.id),
                        }"
                        size="20"
                        aria-hidden="true"
                    >
                        mdi-check
                    </v-icon>
                </button>
                <div v-if="!stepOptions.length" class="sr-option-empty">
                    No steps available.
                </div>
            </div>
        </div>

        <section class="sr-card" aria-live="polite">
            <div class="sr-card-hd">
                <div>
                    <h2>Requirements for this step</h2>
                    <p>{{ cardSubtitle }}</p>
                </div>
                <div class="sr-hd-actions">
                    <button
                        type="button"
                        class="sr-overview"
                        @click="openOverview"
                    >
                        <v-icon size="18">mdi-eye-outline</v-icon>
                        Requirement Overview
                    </button>
                    <button
                        type="button"
                        class="sr-previous"
                        :disabled="!previousStep || showLoader"
                        @click="openPreviousRequirements"
                    >
                        <v-icon size="18">mdi-content-copy</v-icon>
                        <span>Previous requirement</span>
                    </button>
                    <button
                        type="button"
                        class="sr-add"
                        :disabled="!selectedStepId || showLoader"
                        @click="openAdd"
                    >
                        <v-icon size="18">mdi-plus</v-icon>
                        <span>Add requirement</span>
                    </button>
                </div>
            </div>

            <div v-if="showLoader" class="sr-loading">
                <TableLoader
                    compact
                    label="step requirements"
                    icon="mdi-clipboard-list-outline"
                />
            </div>

            <div v-else class="sr-rows" role="table" aria-label="Requirements">
                <div class="sr-row sr-row-head" role="row">
                    <div role="columnheader">Name</div>
                    <div role="columnheader">Code</div>
                    <div role="columnheader">Required</div>
                    <div role="columnheader">Upload required</div>
                    <div role="columnheader"></div>
                </div>

                <div
                    v-for="item in assignmentRows"
                    :key="String(item.requirement_definition_id)"
                    class="sr-row sr-row-item"
                    :class="{ 'is-unsaved': isNewRequirement(item) }"
                    role="row"
                >
                    <div class="sr-name" role="cell">
                        <div class="sr-name-title">
                            <b>{{ item.name }}</b>
                            <span
                                v-if="isNewRequirement(item)"
                                class="sr-unsaved-chip"
                            >
                                UNSAVED
                            </span>
                        </div>
                        <span v-if="item.description">{{
                            item.description
                        }}</span>
                    </div>

                    <div class="sr-code-cell" role="cell">
                        <input
                            v-if="isRequirementCodeEditable(item)"
                            v-model="item.code"
                            type="text"
                            class="sr-code-in"
                            placeholder="e.g. dtr, pr, voucher"
                            maxlength="64"
                            autocomplete="off"
                            spellcheck="false"
                            :aria-label="`Code for ${item.name}`"
                            @update:model-value="onRequirementCodeInput(item)"
                        />
                        <code v-else class="sr-code">{{
                            item.code || "—"
                        }}</code>
                    </div>

                    <div class="sr-req sr-req-r" role="cell">
                        <button
                            type="button"
                            class="sr-tg"
                            role="switch"
                            :aria-checked="item.is_required ? 'true' : 'false'"
                            :aria-label="`Toggle required for ${item.name}`"
                            @click="toggleRequired(item)"
                        ></button>
                        <span :class="{ 'sr-on': item.is_required }">
                            {{ item.is_required ? "Required" : "Optional" }}
                        </span>
                    </div>

                    <div class="sr-req sr-req-u" role="cell">
                        <button
                            type="button"
                            class="sr-tg"
                            role="switch"
                            :aria-checked="
                                item.is_upload_required ? 'true' : 'false'
                            "
                            :aria-label="`Toggle upload required for ${item.name}`"
                            @click="toggleUploadRequired(item)"
                        ></button>
                        <span :class="{ 'sr-on': item.is_upload_required }">
                            {{
                                item.is_upload_required
                                    ? "File required"
                                    : "No file"
                            }}
                        </span>
                    </div>

                    <div class="sr-actions" role="cell">
                        <button
                            type="button"
                            class="sr-ib sr-ib-edit"
                            :aria-label="`Edit ${item.name}`"
                            @click="openEdit(item)"
                        >
                            <v-icon size="18">mdi-pencil</v-icon>
                        </button>
                        <button
                            type="button"
                            class="sr-ib sr-ib-delete"
                            :aria-label="`Remove ${item.name} from this step`"
                            @click="removeRow(item)"
                        >
                            <v-icon size="18">mdi-delete</v-icon>
                        </button>
                    </div>
                </div>

                <template v-if="!assignmentRows.length">
                    <div
                        v-for="n in 2"
                        :key="`empty-ghost-top-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>

                    <div class="sr-row sr-row-noitem" role="row">
                        <div
                            class="sr-noitem-cell"
                            role="cell"
                            aria-colspan="5"
                        >
                            <div class="sr-noitem-copy">
                                <b>{{ noItemTitle }}</b>
                                <span>{{ noItemText }}</span>
                            </div>
                            <button
                                v-if="noItemAction === 'add'"
                                type="button"
                                class="sr-add"
                                @click="openAdd"
                            >
                                <v-icon size="18">mdi-plus</v-icon>
                                <span>Add requirement</span>
                            </button>
                            <button
                                v-else-if="noItemAction === 'items'"
                                type="button"
                                class="sr-add"
                                @click="loadAssigned"
                            >
                                <v-icon size="18">mdi-refresh</v-icon>
                                <span>Try again</span>
                            </button>
                            <button
                                v-else-if="noItemAction === 'steps'"
                                type="button"
                                class="sr-add"
                                @click="retrySteps"
                            >
                                <v-icon size="18">mdi-refresh</v-icon>
                                <span>Try again</span>
                            </button>
                        </div>
                    </div>

                    <div
                        v-for="n in 2"
                        :key="`empty-ghost-bottom-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                </template>

                <template v-else>
                    <div
                        v-for="n in ghostRowCount"
                        :key="`ghost-${n}`"
                        class="sr-row sr-row-ghost"
                        aria-hidden="true"
                    >
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                </template>
            </div>
        </section>

        <v-dialog
            v-model="addDialog"
            max-width="540"
            content-class="req-dialog-content"
            @after-enter="focusAddName"
        >
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="req-badge"
                    >
                        <v-icon>mdi-clipboard-check-outline</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Add requirement</div>
                        <div class="req-sub">
                            Add a checklist item that workers must complete for
                            this step.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="req-x"
                        aria-label="Close add requirement dialog"
                        @click="addDialog = false"
                    />
                </v-card-title>

                <form
                    class="req-form"
                    novalidate
                    @submit.prevent="addRequirement"
                >
                    <v-card-text class="req-bd">
                        <v-alert
                            v-if="addError"
                            type="error"
                            variant="tonal"
                            density="compact"
                            class="mb-4"
                        >
                            {{ addError }}
                        </v-alert>

                        <div class="req-f">
                            <label class="req-lb" for="req-name"
                                >Name <span class="req-required">*</span></label
                            >
                            <v-text-field
                                id="req-name"
                                ref="addNameField"
                                v-model="addForm.name"
                                placeholder="e.g. Signed PR (PDF)"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                :error="!!addFieldErrors.name"
                                class="req-in"
                                @update:model-value="onAddNameInput"
                            />
                            <div v-if="addFieldErrors.name" class="req-error">
                                {{ addFieldErrors.name }}
                            </div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-code"
                                >Code <span class="req-required">*</span></label
                            >
                            <v-text-field
                                id="req-code"
                                ref="addCodeField"
                                v-model="addForm.code"
                                placeholder="signed_pr_pdf"
                                maxlength="64"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                spellcheck="false"
                                :error="!!addFieldErrors.code"
                                class="req-in req-in-mono"
                                @update:model-value="onAddCodeInput"
                            />
                            <div v-if="addFieldErrors.code" class="req-error">
                                {{ addFieldErrors.code }}
                            </div>
                            <div v-else class="req-help">
                                Type the system code manually in snake_case.
                            </div>
                        </div>

                        <div class="req-f">
                            <label class="req-lb" for="req-remarks">
                                Remarks
                                <span class="req-opt"
                                    >(instructions for workers)</span
                                >
                            </label>
                            <v-textarea
                                id="req-remarks"
                                v-model="addForm.description"
                                placeholder="Tell workers what to check or attach"
                                rows="3"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                class="req-in req-in-area"
                            />
                        </div>

                        <section class="req-sec">
                            <div class="req-sec-t">Rules</div>

                            <div class="req-rule">
                                <span class="req-rule-ic">
                                    <v-icon size="20"
                                        >mdi-checkbox-marked-outline</v-icon
                                    >
                                </span>
                                <div class="req-rule-copy">
                                    <b>Required item</b>
                                    <span>
                                        {{
                                            addForm.is_required
                                                ? "Must be completed before the step can proceed"
                                                : "Workers can skip this item"
                                        }}
                                    </span>
                                </div>
                                <button
                                    class="req-tg"
                                    type="button"
                                    role="switch"
                                    :aria-checked="
                                        addForm.is_required ? 'true' : 'false'
                                    "
                                    aria-label="Required item"
                                    @click="
                                        addForm.is_required =
                                            !addForm.is_required
                                    "
                                ></button>
                            </div>

                            <div class="req-rule">
                                <span class="req-rule-ic">
                                    <v-icon size="20">mdi-paperclip</v-icon>
                                </span>
                                <div class="req-rule-copy">
                                    <b>Upload required</b>
                                    <span>
                                        {{
                                            addForm.is_upload_required
                                                ? "Workers must attach a file"
                                                : "No file needed"
                                        }}
                                    </span>
                                </div>
                                <button
                                    class="req-tg"
                                    type="button"
                                    role="switch"
                                    :aria-checked="
                                        addForm.is_upload_required
                                            ? 'true'
                                            : 'false'
                                    "
                                    aria-label="Upload required"
                                    @click="
                                        addForm.is_upload_required =
                                            !addForm.is_upload_required
                                    "
                                ></button>
                            </div>
                        </section>

                        <section class="req-sec req-carry">
                            <div
                                class="cr-card"
                                :data-on="addForm.carry_to_steps ? 'true' : 'false'"
                            >
                                <div class="cr-head">
                                    <span class="cr-ic">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="5" cy="12" r="2.5"/><circle cx="19" cy="12" r="2.5"/><path d="M7.5 12h9M14 8.5l3.5 3.5-3.5 3.5"/></svg>
                                    </span>
                                    <div>
                                        <b>Carry across steps</b>
                                        <span class="cr-d">{{ carryDesc }}</span>
                                    </div>
                                    <button
                                        type="button"
                                        class="cr-sw"
                                        role="switch"
                                        :aria-checked="addForm.carry_to_steps ? 'true' : 'false'"
                                        :disabled="!carryCan"
                                        @click="toggleCarry"
                                    />
                                </div>
                                <div
                                    v-if="addForm.carry_to_steps"
                                    class="cr-panel"
                                >
                                    <div class="cr-grid">
                                        <div class="cr-f">
                                            <label for="cr-rq-s"
                                                >Starts at
                                                <span class="cr-tag"
                                                    >Current step</span
                                                ></label
                                            >
                                            <div class="cr-sel">
                                                <select id="cr-rq-s" disabled>
                                                    <option>
                                                        {{ carryStartLabel }}
                                                    </option>
                                                </select>
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>
                                            </div>
                                        </div>
                                        <div class="cr-f">
                                            <label for="cr-rq-e"
                                                >Ends at</label
                                            >
                                            <div class="cr-sel">
                                                <select
                                                    id="cr-rq-e"
                                                    v-model="addForm.carry_to_step_id"
                                                >
                                                    <option
                                                        v-for="opt in carryEndOptions"
                                                        :key="opt.id"
                                                        :value="opt.id"
                                                    >
                                                        {{ opt.label }}
                                                    </option>
                                                </select>
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cr-wrap">
                                        <ol class="cr-track">
                                            <li
                                                v-for="(node, i) in carryTrack"
                                                :key="node.step.id"
                                                class="cr-n"
                                                :data-in="node.in"
                                                :data-link="node.link"
                                                :data-start="node.start"
                                                :data-end="node.end"
                                            >
                                                <button
                                                    type="button"
                                                    :title="`Step ${node.step.order_number}: ${node.step.name}`"
                                                    :aria-disabled="node.locked ? 'true' : 'false'"
                                                    @click="clickCarryTrack(i)"
                                                >
                                                    {{ i + 1 }}
                                                </button>
                                            </li>
                                        </ol>
                                    </div>
                                    <p
                                        v-if="carryCount"
                                        class="cr-sum"
                                        aria-live="polite"
                                    >
                                        Added to
                                        <b>{{ carryCount }} steps</b>, from
                                        Step {{ carryStartNum }} to Step
                                        {{ carryEndNum }}.
                                    </p>
                                    <p class="cr-hint">
                                        Every step in between is included. No
                                        steps are skipped.
                                    </p>
                                </div>
                            </div>
                        </section>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="req-ft">
                        <v-btn
                            type="button"
                            variant="outlined"
                            rounded="lg"
                            class="req-b"
                            @click="addDialog = false"
                        >
                            Cancel
                        </v-btn>
                        <v-btn
                            color="primary"
                            rounded="lg"
                            class="req-b req-b-pri"
                            type="submit"
                            :loading="adding"
                        >
                            Add requirement
                        </v-btn>
                    </v-card-actions>
                </form>
            </v-card>
        </v-dialog>

        <v-dialog
            v-model="editDialog"
            max-width="480"
            content-class="req-dialog-content"
            @after-enter="focusEditName"
        >
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="req-badge"
                    >
                        <v-icon>mdi-pencil-outline</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Edit requirement</div>
                        <div class="req-sub">
                            Change the requirement name. Its code and rules stay
                            unchanged.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="req-x"
                        aria-label="Close edit requirement dialog"
                        @click="editDialog = false"
                    />
                </v-card-title>

                <form class="req-form" novalidate @submit.prevent="saveEdit">
                    <v-card-text class="req-bd">
                        <v-alert
                            v-if="editError"
                            type="error"
                            variant="tonal"
                            density="compact"
                            class="mb-4"
                        >
                            {{ editError }}
                        </v-alert>

                        <div class="req-f">
                            <label class="req-lb" for="req-edit-name"
                                >Name <span class="req-required">*</span></label
                            >
                            <v-text-field
                                id="req-edit-name"
                                ref="editNameField"
                                v-model="editForm.name"
                                placeholder="e.g. Signed PR (PDF)"
                                variant="outlined"
                                density="comfortable"
                                hide-details
                                autocomplete="off"
                                :error="!!editNameError"
                                class="req-in"
                                @update:model-value="editNameError = ''"
                            />
                            <div v-if="editNameError" class="req-error">
                                {{ editNameError }}
                            </div>
                        </div>

                        <div class="req-code-ro">
                            <span>Code</span>
                            <code>{{ editCode || "—" }}</code>
                        </div>
                        <div class="req-help">
                            The system code and requirement rules are not
                            changed here.
                        </div>
                    </v-card-text>

                    <v-divider />
                    <v-card-actions class="req-ft">
                        <v-btn
                            type="button"
                            variant="outlined"
                            rounded="lg"
                            class="req-b"
                            @click="editDialog = false"
                        >
                            Cancel
                        </v-btn>
                        <v-btn
                            color="primary"
                            rounded="lg"
                            class="req-b req-b-pri"
                            type="submit"
                            :loading="editSaving"
                        >
                            Save name
                        </v-btn>
                    </v-card-actions>
                </form>
            </v-card>
        </v-dialog>

        <v-dialog v-model="previousDialog" max-width="620">
            <v-card rounded="xl" class="req-card">
                <v-card-title class="req-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="req-badge"
                    >
                        <v-icon>mdi-content-copy</v-icon>
                    </v-avatar>
                    <div class="req-hd-t">
                        <div class="req-title">Previous requirements</div>
                        <div class="req-sub">
                            Select a requirement from
                            {{ previousStep?.name || "the previous step" }} to
                            reuse it in {{ selectedStep?.name || "this step" }}.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="req-x"
                        aria-label="Close previous requirements"
                        @click="previousDialog = false"
                    />
                </v-card-title>

                <v-divider />
                <v-card-text class="req-bd">
                    <v-alert
                        v-if="previousError"
                        type="error"
                        variant="tonal"
                        density="compact"
                        class="mb-4"
                    >
                        {{ previousError }}
                    </v-alert>
                    <div v-if="previousLoading" class="sr-loading">
                        <TableLoader
                            compact
                            label="previous requirements"
                            icon="mdi-clipboard-list-outline"
                        />
                    </div>
                    <div
                        v-else-if="previousRequirements.length"
                        class="sr-previous-list"
                    >
                        <div
                            v-for="item in previousRequirements"
                            :key="String(item.requirement_definition_id)"
                            class="sr-previous-item"
                        >
                            <div class="sr-name">
                                <b>{{ item.name }}</b>
                                <span>{{ item.code || "No code" }}</span>
                                <span v-if="item.description">{{
                                    item.description
                                }}</span>
                            </div>
                            <button
                                type="button"
                                class="sr-previous-add"
                                :disabled="isRequirementAssigned(item)"
                                @click="addPreviousRequirement(item)"
                            >
                                <v-icon size="16">
                                    {{
                                        isRequirementAssigned(item)
                                            ? "mdi-check"
                                            : "mdi-plus"
                                    }}
                                </v-icon>
                                {{
                                    isRequirementAssigned(item)
                                        ? "Added"
                                        : "Add to step"
                                }}
                            </button>
                        </div>
                    </div>
                    <div v-else class="sr-previous-empty">
                        {{ previousStep?.name || "The previous step" }} has no
                        requirements to reuse.
                    </div>
                </v-card-text>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import {
    computed,
    nextTick,
    onBeforeUnmount,
    onMounted,
    ref,
    watch,
} from "vue";
import { useRoute, useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useRequirementDefinitions } from "@/composables/useRequirementDefinitions";
import { useStepRequirements } from "@/composables/useStepRequirements";
import { useToast } from "@/composables/useToast";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import { confirm } from "@/composables/useConfirm";
import StagingSaveBar from "@/components/StagingSaveBar.vue";
import TableLoader from "@/components/TableLoader.vue";
import WorkflowPageHeader from "@/components/WorkflowPageHeader.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const returnTypeId = ref(null);
const defVersion = ref(null);
const defStatus = ref("");
const defIsLive = ref(false);

function goBack() {
    const qType = Number(route.query.type);
    const target =
        Number.isFinite(qType) && qType > 0
            ? qType
            : Number(returnTypeId.value);
    if (target > 0)
        router.push({ path: "/admin/workflows", query: { type: target } });
    else router.push("/admin/workflows");
}

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const { items: requirements, fetchAll: fetchReqs } =
    useRequirementDefinitions();
const { assigned, loading, fetchAssigned } = useStepRequirements();
const staging = useWorkflowStaging();
const { success: toastSuccess } = useToast();

// Staging is keyed by transaction type: prefer the explicit query param,
// fall back to the type resolved from the loaded definition.
const typeId = computed(() => {
    const q = Number(route.query.type);
    if (Number.isFinite(q) && q > 0) return q;
    const t = Number(returnTypeId.value);
    return Number.isFinite(t) && t > 0 ? t : null;
});

const error = ref("");
const continuationCheckError = ref("");

const saveBarRef = ref(null);
const stagingDirty = computed(() =>
    typeId.value ? staging.isDirty(typeId.value) : false,
);

function openSaveDialog() {
    saveBarRef.value?.openSaveDialog?.();
}

function discardStaged() {
    saveBarRef.value?.discard?.();
}

const steps = ref([]);
const stepsLoading = ref(false);
const selectedStepId = ref(null);

// Working rows for the current step: pivots joined with definitions.
const assignmentRows = ref([]);
const continuedRequirementIds = ref(new Set());
// First-load gate: rows only map after a fetch settles, so keep the veil up
// until then (loading alone clears on warm cache before rows exist).
const ready = ref(false);

const stepMenuOpen = ref(false);
const stepMenuRef = ref(null);
const stepTrigger = ref(null);
const stepOptionEls = ref([]);

const selectedStep = computed(
    () =>
        steps.value.find(
            (step) => Number(step.id) === Number(selectedStepId.value),
        ) || null,
);

const orderedSteps = computed(() =>
    [...steps.value].sort((a, b) => {
        const order = Number(a.order_number ?? 0) - Number(b.order_number ?? 0);
        return order || Number(a.id ?? 0) - Number(b.id ?? 0);
    }),
);

const selectedStepIndex = computed(() =>
    orderedSteps.value.findIndex(
        (step) => Number(step.id) === Number(selectedStepId.value),
    ),
);

const previousStep = computed(() =>
    selectedStepIndex.value > 0
        ? orderedSteps.value[selectedStepIndex.value - 1]
        : null,
);

const carryStepOptions = computed(() =>
    selectedStepIndex.value < 0
        ? []
        : orderedSteps.value
              .slice(selectedStepIndex.value)
              .map((step) => ({
                  id: step.id,
                  label: `Step ${step.order_number}: ${step.name}`,
              })),
);

// ---- Carry-across-steps card (mockup "CarryRange", rendering only) ----
const carryCan = computed(
    () =>
        selectedStepIndex.value >= 0 &&
        selectedStepIndex.value < orderedSteps.value.length - 1,
);

const carryDesc = computed(() => {
    if (!carryCan.value)
        return "This is the last step, so there are no later steps to add it to.";
    return addForm.value.carry_to_steps
        ? "Added to a range of steps"
        : "Add this requirement to every step in a range";
});

const carryStartLabel = computed(
    () => carryStepOptions.value[0]?.label ?? "",
);

// "Ends at" only offers steps after the current one (mockup behavior).
const carryEndOptions = computed(() => carryStepOptions.value.slice(1));

const carryEndIndex = computed(() =>
    orderedSteps.value.findIndex(
        (step) => Number(step.id) === Number(addForm.value.carry_to_step_id),
    ),
);

const carryStartNum = computed(
    () => orderedSteps.value[selectedStepIndex.value]?.order_number ?? "",
);

const carryEndNum = computed(
    () => orderedSteps.value[carryEndIndex.value]?.order_number ?? "",
);

const carryCount = computed(() =>
    addForm.value.carry_to_steps &&
    carryEndIndex.value > selectedStepIndex.value
        ? carryEndIndex.value - selectedStepIndex.value + 1
        : 0,
);

const carryTrack = computed(() => {
    const on = addForm.value.carry_to_steps;
    return orderedSteps.value.map((step, i) => {
        const inRange =
            on &&
            selectedStepIndex.value >= 0 &&
            i >= selectedStepIndex.value &&
            i <= carryEndIndex.value;
        return {
            step,
            in: inRange ? "1" : "0",
            link:
                on && inRange && i > selectedStepIndex.value ? "1" : "0",
            start: i === selectedStepIndex.value ? "1" : "0",
            end: on && inRange && i === carryEndIndex.value ? "1" : "0",
            locked: i <= selectedStepIndex.value,
        };
    });
});

function toggleCarry() {
    if (!carryCan.value) return;
    addForm.value.carry_to_steps = !addForm.value.carry_to_steps;
}

function clickCarryTrack(i) {
    if (i <= selectedStepIndex.value) return;
    const step = orderedSteps.value[i];
    if (step) addForm.value.carry_to_step_id = step.id;
}

function openOverview() {
    const wid = workflowDefinitionId.value;
    if (!Number.isFinite(wid) || wid <= 0) return;

    const selected = Number(selectedStepId.value);
    const fallback = stepIdFromUrl.value;
    const sid =
        Number.isFinite(selected) && selected > 0 ? selected : fallback;

    if (!Number.isFinite(sid) || sid <= 0) {
        router.push({
            name: "admin.workflow-requirements",
            params: { workflowId: wid },
            query: route.query,
        });
        return;
    }

    router.push({
        name: "admin.step-requirements-overview",
        params: { workflowId: wid, stepId: sid },
        query: route.query,
    });
}

const showLoader = computed(
    () =>
        stepsLoading.value ||
        !ready.value ||
        (!!selectedStepId.value && loading.value),
);

function stepRequirementCount(id) {
    if (
        Number(id) === Number(selectedStepId.value) &&
        ready.value &&
        !loading.value
    ) {
        return assignmentRows.value.length;
    }
    const bucket = typeId.value
        ? staging.buckets.get(String(typeId.value))
        : null;
    const staged = bucket?.bindings?.[String(id)];
    if (staged) return staged.length;
    const step = steps.value.find((row) => Number(row.id) === Number(id));
    return Math.max(0, Number(step?.step_requirements_count ?? 0));
}

const stepOptions = computed(() =>
    steps.value.map((step) => ({
        id: step.id,
        order_number: step.order_number,
        name: step.name,
        code: step.code,
        count: stepRequirementCount(step.id),
    })),
);

function countLabel(count) {
    return `${count} ${count === 1 ? "requirement" : "requirements"}`;
}

const cardSubtitle = computed(() => {
    if (stepsLoading.value) return "Loading steps…";
    if (!steps.value.length) return "No steps available.";
    if (!selectedStepId.value)
        return "Select a step to manage its requirements.";
    if (loading.value) return "Loading requirements…";
    if (error.value) return "Couldn't load requirements.";
    const count = assignmentRows.value.length;
    if (!count) return "Nothing added yet";
    return `${countLabel(count)} for “${selectedStep.value?.name || "this step"}”`;
});

const noItemTitle = computed(() => {
    if (error.value && !selectedStepId.value) return "Couldn't load steps";
    if (!selectedStepId.value)
        return steps.value.length ? "Select a step" : "No steps available";
    if (error.value) return "Couldn't load requirements";
    return "No requirements yet";
});

const noItemText = computed(() => {
    if (error.value && !selectedStepId.value)
        return "Check the error above, then try again.";
    if (!selectedStepId.value) {
        return steps.value.length
            ? "Choose a step above to manage its requirements."
            : "This workflow doesn't have any steps yet.";
    }
    if (error.value) return "Check the error above, then try again.";
    return "Add a requirement that workers must complete for this step.";
});

const noItemAction = computed(() => {
    if (error.value) return selectedStepId.value ? "items" : "steps";
    if (!selectedStepId.value) return null;
    return "add";
});

const ghostRowCount = computed(() =>
    Math.max(0, 5 - assignmentRows.value.length),
);

function isSelectedStep(id) {
    return Number(id) === Number(selectedStepId.value);
}

function setStepOptionEl(el, index) {
    if (el) stepOptionEls.value[index] = el;
}

function focusStepOption(index) {
    const count = stepOptions.value.length;
    if (!count) return;
    const next = (index + count) % count;
    nextTick(() => stepOptionEls.value[next]?.focus?.());
}

function openStepMenu(index) {
    if (!stepOptions.value.length) return;
    stepMenuOpen.value = true;
    focusStepOption(index);
}

function closeStepMenu(restoreFocus = false) {
    stepMenuOpen.value = false;
    if (restoreFocus) nextTick(() => stepTrigger.value?.focus?.());
}

function toggleStepMenu() {
    if (stepMenuOpen.value) {
        closeStepMenu();
        return;
    }
    const index = stepOptions.value.findIndex((option) =>
        isSelectedStep(option.id),
    );
    openStepMenu(index >= 0 ? index : 0);
}

function onTriggerKeydown(event) {
    if (event.key !== "ArrowDown" && event.key !== "ArrowUp") return;
    event.preventDefault();
    openStepMenu(event.key === "ArrowUp" ? stepOptions.value.length - 1 : 0);
}

function onStepOptionKeydown(event, index) {
    if (event.key === "ArrowDown") {
        event.preventDefault();
        focusStepOption(index + 1);
    } else if (event.key === "ArrowUp") {
        event.preventDefault();
        focusStepOption(index - 1);
    } else if (event.key === "Home") {
        event.preventDefault();
        focusStepOption(0);
    } else if (event.key === "End") {
        event.preventDefault();
        focusStepOption(stepOptions.value.length - 1);
    }
}

function onStepMenuFocusOut(event) {
    if (
        stepMenuOpen.value &&
        !stepMenuRef.value?.contains(event.relatedTarget)
    ) {
        stepMenuOpen.value = false;
    }
}

function onDocumentPointerDown(event) {
    if (!stepMenuOpen.value) return;
    if (!stepMenuRef.value?.contains(event.target)) stepMenuOpen.value = false;
}

function onDocumentKeydown(event) {
    if (event.key === "Escape" && stepMenuOpen.value) {
        event.preventDefault();
        closeStepMenu(true);
    }
}

function selectStep(id) {
    const changed = !isSelectedStep(id);
    stepMenuOpen.value = false;
    if (changed) selectedStepId.value = id;
    nextTick(() => stepTrigger.value?.focus?.());
}

// Edit-name dialog
const editDialog = ref(false);
const editSaving = ref(false);
const editError = ref("");
const editNameError = ref("");
const editForm = ref({ name: "" });
const editCode = ref("");
const editKey = ref(null);
const editNameField = ref(null);

// Add-entry dialog
const addDialog = ref(false);
const adding = ref(false);
const addError = ref("");
const addForm = ref({
    name: "",
    code: "",
    description: "",
    is_required: true,
    is_upload_required: true,
    carry_to_steps: false,
    carry_to_step_id: null,
});
const addFieldErrors = ref({ name: "", code: "" });
const addNameField = ref(null);
const addCodeField = ref(null);
const previousDialog = ref(false);
const previousLoading = ref(false);
const previousError = ref("");
const previousRequirements = ref([]);
let previousLoadToken = 0;

function onAddNameInput() {
    if (addFieldErrors.value.name) addFieldErrors.value.name = "";
}

function onAddCodeInput() {
    if (addFieldErrors.value.code) addFieldErrors.value.code = "";
}

function focusAddName() {
    addNameField.value?.focus();
}

function validateAddForm() {
    const name = addForm.value.name?.trim() || "";
    const code = addForm.value.code?.trim() || "";
    const errors = { name: "", code: "" };

    if (!name) errors.name = "Enter a requirement name.";
    if (!code) {
        errors.code = "Enter a code in snake_case (for example signed_pr_pdf).";
    } else if (!/^[a-z][a-z0-9_]*$/.test(code)) {
        errors.code =
            "Use snake_case, starting with a letter (for example signed_pr_pdf).";
    }

    addFieldErrors.value = errors;
    if (errors.name) {
        addNameField.value?.focus();
        return false;
    }
    if (errors.code) {
        addCodeField.value?.focus();
        return false;
    }
    return true;
}

function toggleRequired(item) {
    item.is_required = !item.is_required;
    stageBindings();
}

function toggleUploadRequired(item) {
    item.is_upload_required = !item.is_upload_required;
    stageBindings();
}

function openEdit(item) {
    editError.value = "";
    editNameError.value = "";
    editKey.value = item.requirement_definition_id;
    editCode.value = item.code || "";
    editForm.value = { name: item.name || "" };
    editDialog.value = true;
}

function focusEditName() {
    editNameField.value?.focus();
}

function saveEdit() {
    if (editSaving.value) return;
    const name = editForm.value.name?.trim() || "";
    if (!name) {
        editNameError.value = "Enter a requirement name.";
        editNameField.value?.focus();
        return;
    }
    if (!typeId.value) {
        editError.value =
            "Resolve the transaction type first (open this page from Workflows).";
        return;
    }

    const key = editKey.value;
    const row = assignmentRows.value.find(
        (item) => String(item.requirement_definition_id) === String(key),
    );
    if (!row) {
        editError.value = "Requirement not found.";
        return;
    }

    editSaving.value = true;
    editError.value = "";
    try {
        const bucket = staging.buckets.get(String(typeId.value));
        const currentDef = (bucket?.reqDefs || []).find(
            (def) => String(def.client_id ?? def.id) === String(key),
        );
        const patch = { name };
        if (typeof key === "number") patch.id = key;
        else patch.client_id = key;
        if (!currentDef) {
            patch.code = row.code || null;
            patch.description = row.description || null;
        }
        staging.upsertReqDef(typeId.value, patch);
        assignmentRows.value = assignmentRows.value.map((item) =>
            String(item.requirement_definition_id) === String(key)
                ? { ...item, name }
                : item,
        );
        stageBindings();
        editDialog.value = false;
        toastSuccess(`Requirement renamed to "${name}".`);
    } catch (e) {
        editError.value = e?.message || "Failed to rename requirement.";
    } finally {
        editSaving.value = false;
    }
}

function openAdd() {
    addError.value = "";
    addFieldErrors.value = { name: "", code: "" };
    const lastStep = orderedSteps.value[orderedSteps.value.length - 1];
    addForm.value = {
        name: "",
        code: "",
        description: "",
        is_required: true,
        is_upload_required: true,
        carry_to_steps: false,
        carry_to_step_id: lastStep?.id ?? selectedStepId.value,
    };
    addDialog.value = true;
}

function storeRow(r, idx) {
    return {
        req_key: r.requirement_definition_id,
        display_order: Number(r.display_order ?? idx),
        is_required: !!r.is_required,
        is_upload_required: r.is_upload_required ?? r.is_required ?? true,
        code: r.code ?? "",
        name: r.name ?? "",
        description: r.description ?? "",
    };
}

function isRequirementCodeEditable(item) {
    return (
        typeof item.requirement_definition_id !== "number" &&
        !continuedRequirementIds.value.has(
            String(item.requirement_definition_id),
        )
    );
}

function isNewRequirement(item) {
    return typeof item.requirement_definition_id !== "number";
}

function onRequirementCodeInput(item) {
    if (!isRequirementCodeEditable(item) || !typeId.value) return;

    const key = item.requirement_definition_id;
    staging.upsertReqDef(typeId.value, {
        client_id: key,
        code: item.code,
    });

    const bucket = staging.buckets.get(String(typeId.value));
    for (const step of orderedSteps.value.slice(selectedStepIndex.value + 1)) {
        const rows = bucket?.bindings?.[String(step.id)];
        if (!Array.isArray(rows)) break;

        const hasRequirement = rows.some(
            (row) =>
                String(row.requirement_definition_id ?? row.req_key ?? row.id) ===
                String(key),
        );
        if (!hasRequirement) break;

        staging.setBindings(
            typeId.value,
            step.id,
            rows.map((row) =>
                String(
                    row.requirement_definition_id ?? row.req_key ?? row.id,
                ) === String(key)
                    ? { ...row, code: item.code }
                    : row,
            ),
        );
    }
    stageBindings();
}

// Write the visible rows into the staging store (no network). Called by
// every inline edit/add/remove; Save version persists everything at once.
function stageBindings() {
    if (!typeId.value || !selectedStepId.value) return;
    staging.setBindings(
        typeId.value,
        Number(selectedStepId.value),
        (assignmentRows.value || []).map((r, idx) => storeRow(r, idx)),
    );
}

async function addRequirement() {
    if (adding.value) return;
    if (!validateAddForm()) return;
    if (!typeId.value) {
        addError.value =
            "Resolve the transaction type first (open this page from Workflows).";
        return;
    }
    if (!selectedStep.value) {
        addError.value = "Select a step before adding a requirement.";
        return;
    }
    adding.value = true;
    addError.value = "";
    try {
        let rangeSteps = [selectedStep.value];
        if (addForm.value.carry_to_steps) {
            const startIndex = selectedStepIndex.value;
            const endIndex = orderedSteps.value.findIndex(
                (step) =>
                    String(step.id) ===
                    String(addForm.value.carry_to_step_id),
            );
            if (startIndex < 0 || endIndex < startIndex) {
                throw new Error("Choose a valid ending step for this range.");
            }
            rangeSteps = orderedSteps.value.slice(startIndex, endIndex + 1);
        }

        const rowsByStep = new Map();
        for (const step of rangeSteps) {
            if (Number(step.id) === Number(selectedStepId.value)) continue;

            const staged =
                staging.buckets
                    .get(String(typeId.value))
                    ?.bindings?.[String(step.id)];
            if (Array.isArray(staged)) {
                rowsByStep.set(
                    String(step.id),
                    staged.map(normalizePreviousRequirement),
                );
                continue;
            }

            const response = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId.value}/steps/${step.id}/requirements`,
            );
            const rows = response.data?.data ?? response.data;
            if (!Array.isArray(rows)) {
                throw new Error(
                    `Requirements for step "${step.name}" were invalid.`,
                );
            }
            const normalized = rows.map(normalizePreviousRequirement);
            staging.seedBindings(
                typeId.value,
                step.id,
                normalized.map((row, index) => storeRow(row, index)),
            );
            rowsByStep.set(String(step.id), normalized);
        }

        // Staged requirement definition (server mints the id on save).
        const { row: created } = staging.upsertReqDef(typeId.value, {
            name: addForm.value.name.trim(),
            code: addForm.value.code.trim(),
            description: addForm.value.description?.trim() || null,
        });
        const requirementKey = created.client_id ?? created.id;
        const requirement = {
            requirement_definition_id: requirementKey,
            code: created.code,
            name: created.name,
            label: created.label,
            description: created.description,
            is_required: !!addForm.value.is_required,
            is_upload_required: !!addForm.value.is_upload_required,
        };

        for (const step of rangeSteps) {
            const isSelected = Number(step.id) === Number(selectedStepId.value);
            const rows = isSelected
                ? assignmentRows.value
                : rowsByStep.get(String(step.id)) || [];
            if (
                rows.some(
                    (item) =>
                        String(item.requirement_definition_id) ===
                        String(requirementKey),
                )
            ) {
                continue;
            }
            const nextRows = [
                ...rows,
                {
                    ...requirement,
                    display_order: rows.length,
                },
            ];
            if (isSelected) {
                assignmentRows.value = nextRows;
            } else {
                staging.setBindings(
                    typeId.value,
                    step.id,
                    nextRows.map((item, index) => storeRow(item, index)),
                );
            }
        }
        addDialog.value = false;
        stageBindings();
        toastSuccess(
            addForm.value.carry_to_steps && rangeSteps.length > 1
                ? `Requirement "${created.name}" added to ${rangeSteps.length} steps.`
                : `Requirement "${created.name}" added to this step.`,
        );
    } catch (e) {
        addError.value = e?.message || "Failed to add requirement.";
    } finally {
        adding.value = false;
    }
}

async function removeRow(item) {
    const stepIndex = selectedStepIndex.value;
    if (stepIndex < 0 || !selectedStep.value) return;

    const removingStepId = Number(selectedStepId.value);
    const requirementId = String(item.requirement_definition_id);
    const affectedSteps = [selectedStep.value];
    const rowsByAffectedStep = new Map();

    try {
        for (const step of orderedSteps.value.slice(stepIndex + 1)) {
            const bucket = typeId.value
                ? staging.buckets.get(String(typeId.value))
                : null;
            const staged = bucket?.bindings?.[String(step.id)];
            let rows;

            if (Array.isArray(staged)) {
                rows = staged;
            } else {
                const response = await api.get(
                    `/api/admin/workflow-definitions/${workflowDefinitionId.value}/steps/${step.id}/requirements`,
                );
                rows = response.data?.data ?? response.data;
                if (!Array.isArray(rows)) {
                    throw new Error(
                        `Requirements for step "${step.name}" were invalid.`,
                    );
                }
            }

            const continues = rows.some(
                (row) =>
                    String(
                        row.requirement_definition_id ??
                            row.req_key ??
                            row.id,
                    ) === requirementId,
            );
            if (!continues) break;

            const normalizedRows = rows.map(normalizePreviousRequirement);
            rowsByAffectedStep.set(String(step.id), normalizedRows);
            affectedSteps.push(step);
        }
    } catch (e) {
        error.value =
            e?.response?.data?.message ||
            e?.message ||
            "Failed to check whether this requirement continues to later steps.";
        return;
    }

    if (Number(selectedStepId.value) !== removingStepId) return;

    if (affectedSteps.length > 1) {
        const stepList = affectedSteps
            .map((step) => `• Step ${step.order_number}: ${step.name}`)
            .join("\n");
        const ok = await confirm({
            title: "Remove continued requirement?",
            message: `This removes the requirement from ${affectedSteps.length} steps to keep the chain continuous:\n${stepList}`,
            confirmLabel: "Remove from all listed steps",
            tone: "danger",
        });
        if (!ok) return;
    }

    if (Number(selectedStepId.value) !== removingStepId) return;

    assignmentRows.value = assignmentRows.value.filter(
        (row) =>
            String(row.requirement_definition_id) !== requirementId,
    );
    stageBindings();

    for (const step of affectedSteps.slice(1)) {
        const rows = rowsByAffectedStep.get(String(step.id)) || [];
        const storedRows = rows.map((row, index) => storeRow(row, index));
        staging.seedBindings(typeId.value, step.id, storedRows);
        staging.setBindings(
            typeId.value,
            step.id,
            storedRows.filter(
                (row) =>
                    String(
                        row.requirement_definition_id ??
                            row.req_key ??
                            row.id,
                    ) !== requirementId,
            ),
        );
    }
}

function normalizePreviousRequirement(row, index) {
    return {
        requirement_definition_id:
            row.requirement_definition_id ?? row.req_key ?? row.id,
        code: row.code ?? "",
        name: row.name ?? "",
        label: row.label ?? "",
        description: row.description ?? "",
        display_order: Number(row.display_order ?? index),
        is_required:
            row.is_required ?? row.pivot_meta?.is_required ?? true,
        is_upload_required:
            row.is_upload_required ??
            row.pivot_meta?.is_upload_required ??
            row.is_required ??
            row.pivot_meta?.is_required ??
            true,
    };
}

async function openPreviousRequirements() {
    const sourceStep = previousStep.value;
    if (!sourceStep || !selectedStepId.value) return;

    const token = ++previousLoadToken;
    previousDialog.value = true;
    previousLoading.value = true;
    previousError.value = "";
    previousRequirements.value = [];

    try {
        const bucket = typeId.value
            ? staging.buckets.get(String(typeId.value))
            : null;
        const staged = bucket?.bindings?.[String(sourceStep.id)];
        let rows;

        if (Array.isArray(staged)) {
            rows = staged;
        } else {
            const response = await api.get(
                `/api/admin/workflow-definitions/${workflowDefinitionId.value}/steps/${sourceStep.id}/requirements`,
            );
            rows = response.data?.data ?? response.data;
            if (!Array.isArray(rows)) {
                throw new Error("Previous step requirements were invalid.");
            }
            if (typeId.value) {
                staging.seedBindings(
                    typeId.value,
                    sourceStep.id,
                    rows.map((row, index) =>
                        storeRow(normalizePreviousRequirement(row, index), index),
                    ),
                );
            }
        }

        if (token !== previousLoadToken) return;
        previousRequirements.value = rows.map(normalizePreviousRequirement);
    } catch (e) {
        if (token === previousLoadToken) {
            previousError.value =
                e?.response?.data?.message ||
                e?.message ||
                "Failed to load previous step requirements.";
        }
    } finally {
        if (token === previousLoadToken) previousLoading.value = false;
    }
}

function isRequirementAssigned(item) {
    return assignmentRows.value.some(
        (row) =>
            String(row.requirement_definition_id) ===
            String(item.requirement_definition_id),
    );
}

function addPreviousRequirement(item) {
    if (isRequirementAssigned(item)) return;

    assignmentRows.value = [
        ...assignmentRows.value,
        {
            ...item,
            display_order: assignmentRows.value.length,
        },
    ];
    stageBindings();
    toastSuccess(`Requirement "${item.name}" added to this step.`);
}

async function loadSteps() {
    stepsLoading.value = true;
    error.value = "";
    try {
        const wid = workflowDefinitionId.value;
        try {
            const defRes = await api.get(
                `/api/admin/workflow-definitions/${wid}`,
            );
            const def = defRes.data?.data ?? defRes.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
            defVersion.value = def?.version ?? null;
            defStatus.value = def?.status ?? "";
            defIsLive.value = !!def?.is_live;
        } catch {
            /* type id and version metadata are best-effort */
        }
        const res = await api.get(
            `/api/admin/workflow-definitions/${wid}/steps`,
        );
        steps.value = res.data.data ?? res.data;
    } catch (e) {
        error.value =
            e?.response?.data?.message || e?.message || "Failed to load steps.";
    } finally {
        stepsLoading.value = false;
    }
}

function enrichStagedRow(r, idx) {
    // Names/labels for staged rows: staged defs first, then the server
    // catalog, then whatever the row itself carries.
    const key = String(r.req_key ?? r.requirement_definition_id ?? r.id);
    const b = typeId.value ? staging.buckets.get(String(typeId.value)) : null;
    const staged = (b?.reqDefs || []).find(
        (d) => String(d.client_id ?? d.id) === key,
    );
    const cat = (requirements.value || []).find((d) => String(d.id) === key);
    const src = staged || cat || {};
    return {
        requirement_definition_id: r.req_key ?? r.requirement_definition_id,
        code: r.code ?? src.code ?? "",
        name: src.name ?? r.name ?? "",
        label: src.label ?? r.label ?? "",
        description: r.description ?? src.description ?? "",
        display_order: Number(r.display_order ?? idx),
        is_required: r.is_required ?? true,
        is_upload_required: r.is_upload_required ?? r.is_required ?? true,
    };
}

let loadAssignedToken = 0;

async function loadAssigned() {
    const token = ++loadAssignedToken;
    if (!selectedStepId.value) {
        assignmentRows.value = [];
        continuedRequirementIds.value = new Set();
        ready.value = true;
        return;
    }
    ready.value = false;
    error.value = "";
    continuationCheckError.value = "";
    continuedRequirementIds.value = new Set();
    let currentRequirementsLoaded = false;
    try {
        await fetchAssigned(
            workflowDefinitionId.value,
            Number(selectedStepId.value),
        );
        if (token !== loadAssignedToken) return;
        const sid = Number(selectedStepId.value);
        // Prefer already-staged rows so revisit never shows stale server
        // state over unsaved edits; names resolve via staged defs/catalog.
        const staged = typeId.value
            ? staging.buckets.get(String(typeId.value))?.bindings?.[String(sid)]
            : null;
        if (staged) {
            assignmentRows.value = staged.map((r, idx) =>
                enrichStagedRow(r, idx),
            );
        } else {
            assignmentRows.value = (assigned.value || []).map((a) => ({
                requirement_definition_id: a.id,
                code: a.code ?? "",
                name: a.name,
                label: a.label ?? "",
                description: a.description ?? "",
                display_order: a.pivot_meta?.display_order ?? 0,
                is_required: a.pivot_meta?.is_required ?? true,
                is_upload_required:
                    a.pivot_meta?.is_upload_required ??
                    a.pivot_meta?.is_required ??
                    true,
            }));
            // Seed the staging slice (skipped when staged edits exist).
            if (typeId.value) {
                staging.seedBindings(
                    typeId.value,
                    sid,
                    assignmentRows.value.map((r, idx) => storeRow(r, idx)),
                );
                staging.seedReqDefs(typeId.value, requirements.value || []);
            }
        }
        currentRequirementsLoaded = true;

        if (previousStep.value) {
            const bucket = typeId.value
                ? staging.buckets.get(String(typeId.value))
                : null;
            const previousStaged =
                bucket?.bindings?.[String(previousStep.value.id)];
            let previousRows;
            if (Array.isArray(previousStaged)) {
                previousRows = previousStaged;
            } else {
                const response = await api.get(
                    `/api/admin/workflow-definitions/${workflowDefinitionId.value}/steps/${previousStep.value.id}/requirements`,
                );
                previousRows = response.data?.data ?? response.data;
                if (!Array.isArray(previousRows)) {
                    throw new Error(
                        "Previous step requirements were invalid.",
                    );
                }
                if (typeId.value) {
                    staging.seedBindings(
                        typeId.value,
                        previousStep.value.id,
                        previousRows.map((row, index) =>
                            storeRow(
                                normalizePreviousRequirement(row, index),
                                index,
                            ),
                        ),
                    );
                }
            }
            if (token !== loadAssignedToken) return;
            continuedRequirementIds.value = new Set(
                previousRows.map((row) =>
                    String(
                        row.requirement_definition_id ??
                            row.req_key ??
                            row.id,
                    ),
                ),
            );
        }
    } catch (e) {
        if (token === loadAssignedToken) {
            if (currentRequirementsLoaded) {
                continuedRequirementIds.value = new Set(
                    assignmentRows.value.map((row) =>
                        String(row.requirement_definition_id),
                    ),
                );
                continuationCheckError.value =
                    e?.response?.data?.message ||
                    "Couldn't check the previous step. Code editing is disabled until it can be checked.";
            } else {
                error.value =
                    e?.response?.data?.message ||
                    "Failed to load assigned requirements.";
            }
        }
    } finally {
        if (token === loadAssignedToken) ready.value = true;
    }
}

function selectInitialStep() {
    const sid = stepIdFromUrl.value;
    if (
        Number.isFinite(sid) &&
        steps.value.some((step) => Number(step.id) === sid)
    ) {
        selectedStepId.value = sid;
    } else if (steps.value.length) {
        selectedStepId.value = steps.value[0].id;
    }
}

async function retrySteps() {
    await loadSteps();
    if (
        !selectedStepId.value ||
        !steps.value.some(
            (step) => Number(step.id) === Number(selectedStepId.value),
        )
    ) {
        selectInitialStep();
    }
}

async function afterBulkSaved(payload) {
    const saved = payload?.data ?? null;
    const savedId = Number(saved?.id);
    if (savedId > 0 && savedId !== Number(workflowDefinitionId.value)) {
        const selected = selectedStep.value;
        const savedSteps = saved?.steps ?? [];
        const targetStep =
            savedSteps.find(
                (step) => step.code && step.code === selected?.code,
            ) ??
            savedSteps.find(
                (step) => step.name && step.name === selected?.name,
            ) ??
            savedSteps.find(
                (step) =>
                    Number(step.order_number) ===
                    Number(selected?.order_number),
            ) ??
            savedSteps[0];

        if (targetStep?.id) {
            const target = router.resolve({
                name: "admin.step-requirements",
                params: { workflowId: savedId, stepId: targetStep.id },
                query: typeId.value ? { type: typeId.value } : {},
            }).href;
            window.location.assign(target);
            return;
        }
    }

    // Bucket was dropped by the save: reload fresh (reseeds staging).
    await fetchReqs(workflowDefinitionId.value);
    await loadAssigned();
}

watch(selectedStepId, async () => {
    previousLoadToken++;
    editDialog.value = false;
    previousDialog.value = false;
    previousRequirements.value = [];
    assigned.value = [];
    assignmentRows.value = [];
    if (!selectedStepId.value) {
        ready.value = true;
        return;
    }
    await loadAssigned();
});

onMounted(async () => {
    document.addEventListener("mousedown", onDocumentPointerDown);
    document.addEventListener("keydown", onDocumentKeydown);

    // Requirement catalog and step list are independent: fetch in parallel.
    await Promise.allSettled([
        fetchReqs(workflowDefinitionId.value),
        loadSteps(),
    ]);
    selectInitialStep();
    if (!selectedStepId.value) ready.value = true;
});

onBeforeUnmount(() => {
    document.removeEventListener("mousedown", onDocumentPointerDown);
    document.removeEventListener("keydown", onDocumentKeydown);
});
</script>

<style scoped>
/* ---- Requirements page ---- */
.sr-page {
    --sr-field: #f4f6fb;
    --sr-hover: #f3f6fc;
    /* Cancel AppShell's v-container pa-6 so the page can use the
       mockup's adaptive full-width gutters. */
    width: auto;
    max-width: none;
    margin: 0 -24px;
    padding: 0 clamp(16px, 3vw, 48px) 16px;
}

.sr-page :deep(.v-alert) {
    border-radius: 0;
}

.sr-page :deep(.v-btn) {
    border-radius: 0;
}

.sr-previous:focus-visible,
.sr-overview:focus-visible,
.sr-add:focus-visible,
.sr-trigger:focus-visible,
.sr-option:focus-visible,
.sr-ib:focus-visible,
.sr-tg:focus-visible,
.sr-code-in:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.sr-info {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 22px;
    padding: 14px 16px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.1);
    font-size: 14px;
    line-height: 1.5;
}

.sr-info-ic {
    flex: none;
    margin-top: 1px;
    color: rgb(var(--v-theme-primary));
}

.sr-info b {
    color: rgb(var(--v-theme-primary));
}

.sr-lbl {
    margin: 0 0 10px;
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

/* ---- Step picker ---- */
.sr-dd {
    position: relative;
    margin-bottom: 22px;
}

.sr-trigger {
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    min-height: 68px;
    padding: 10px 14px 10px 10px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
    transition:
        border-color 0.15s,
        box-shadow 0.15s;
}

.sr-trigger:hover:not(:disabled) {
    border-color: rgba(var(--v-theme-primary), 0.45);
}

.sr-trigger:focus-visible,
.sr-trigger-open {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}

.sr-trigger:disabled {
    opacity: 0.65;
    cursor: default;
}

.sr-step-n {
    display: grid;
    flex: none;
    width: 44px;
    height: 44px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 16px;
    font-weight: 800;
    place-items: center;
}

.sr-step-tx {
    flex: 1;
    min-width: 0;
}

.sr-step-tx b {
    display: block;
    overflow: hidden;
    font-size: 16px;
    font-weight: 700;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-step-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-count {
    flex: none;
    padding: 3px 10px;
    border-radius: 0;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
}

.sr-chev {
    flex: none;
    color: rgb(var(--v-theme-secondary));
    transition: transform 0.2s;
}

.sr-chev-open {
    transform: rotate(180deg);
}

.sr-menu {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    left: 0;
    z-index: 20;
    max-height: 320px;
    padding: 8px;
    overflow: auto;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 18px 40px -12px rgba(20, 33, 61, 0.3);
}

.sr-option {
    position: relative;
    display: flex;
    align-items: center;
    gap: 14px;
    width: 100%;
    padding: 10px;
    border: 0;
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-on-surface));
    text-align: left;
    cursor: pointer;
}

.sr-option:hover,
.sr-option:focus-visible {
    background: var(--sr-hover);
}

.sr-option-selected::before {
    position: absolute;
    top: 12px;
    bottom: 12px;
    left: -8px;
    width: 4px;
    border-radius: 0;
    background: rgb(var(--v-theme-primary));
    content: "";
}

.sr-option-n {
    display: grid;
    flex: none;
    width: 40px;
    height: 40px;
    border-radius: 0;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
    font-size: 15px;
    font-weight: 800;
    place-items: center;
}

.sr-option-tx {
    flex: 1;
    min-width: 0;
}

.sr-option-tx b {
    display: block;
    overflow: hidden;
    font-size: 14.5px;
    font-weight: 700;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-option-tx small {
    display: block;
    overflow: hidden;
    margin-top: 2px;
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12px;
    line-height: 1.2;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.sr-option-ck {
    flex: none;
    color: rgb(var(--v-theme-primary));
    opacity: 0;
}

.sr-option-ck-on {
    opacity: 1;
}

.sr-option-empty {
    padding: 18px 12px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
    text-align: center;
}

.sr-sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

/* ---- Requirements card ---- */
.sr-card {
    overflow: hidden;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
}

.sr-card-hd {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 18px 20px;
    border-bottom: 1px solid
        rgba(var(--v-border-color), var(--v-border-opacity));
}

.sr-card-hd h2 {
    margin: 0;
    font-size: 17px;
    font-weight: 800;
    line-height: 1.2;
}

.sr-card-hd p {
    margin: 2px 0 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
    line-height: 1.2;
}

.sr-hd-actions {
    display: flex;
    align-items: center;
    flex: none;
    gap: 10px;
    margin-left: auto;
}

.sr-overview {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 8px;
    height: 44px;
    padding: 0 18px;
    border: 1.5px solid rgba(var(--v-theme-primary), 0.42);
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-primary));
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        border-color 0.15s;
}

.sr-overview:hover {
    border-color: rgba(var(--v-theme-primary), 0.65);
    background: rgba(var(--v-theme-primary), 0.07);
}

.sr-previous {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 8px;
    height: 44px;
    padding: 0 16px;
    border: 1.5px solid rgba(var(--v-theme-primary), 0.42);
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-primary));
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        border-color 0.15s,
        opacity 0.15s;
}

.sr-previous:hover:not(:disabled) {
    border-color: rgba(var(--v-theme-primary), 0.65);
    background: rgba(var(--v-theme-primary), 0.07);
}

.sr-previous:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.sr-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 8px;
    height: 44px;
    padding: 0 18px;
    border: 0;
    border-radius: 0;
    background: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-on-primary));
    font-size: 14.5px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        opacity 0.15s;
}

.sr-add:hover:not(:disabled) {
    filter: brightness(0.93);
}

.sr-add:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.sr-loading {
    display: flex;
    align-items: center;
    min-height: 404px;
    padding: 12px 0;
}

.sr-previous-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.sr-previous-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 14px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    background: rgb(var(--v-theme-surface));
}

.sr-previous-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    gap: 6px;
    min-height: 38px;
    padding: 0 12px;
    border: 1px solid rgba(var(--v-theme-primary), 0.42);
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-primary));
    font: inherit;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
}

.sr-previous-add:hover:not(:disabled) {
    background: rgba(var(--v-theme-primary), 0.07);
}

.sr-previous-add:disabled {
    opacity: 0.65;
    cursor: default;
}

.sr-previous-empty {
    padding: 22px 12px;
    color: rgb(var(--v-theme-secondary));
    text-align: center;
}

.sr-rows {
    width: 100%;
}

.sr-row {
    display: grid;
    grid-template-columns:
        minmax(0, 2fr)
        minmax(0, 1.4fr)
        minmax(150px, 1fr)
        minmax(170px, 1fr)
        112px;
    align-items: center;
    gap: 12px;
    padding: 14px 20px;
    border-bottom: 1px solid
        rgba(var(--v-border-color), var(--v-border-opacity));
}

.sr-row:last-child {
    border-bottom: 0;
}

.sr-row-ghost {
    min-height: 74px;
    pointer-events: none;
}

.sr-row.sr-row-noitem {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 138px;
    padding: 24px;
    text-align: center;
}

.sr-noitem-cell {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
    width: 100%;
    max-width: 460px;
}

.sr-noitem-copy {
    width: 100%;
}

.sr-noitem-copy b {
    display: block;
    font-size: 16px;
    line-height: 1.2;
}

.sr-noitem-copy span {
    display: block;
    margin-top: 4px;
    color: rgb(var(--v-theme-secondary));
    font-size: 14px;
    line-height: 1.35;
}

.sr-row-noitem .sr-add {
    height: 40px;
    margin-left: 0;
}

.sr-row-head {
    padding: 10px 20px;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-size: 12px;
    font-weight: 800;
    line-height: 1.2;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}

.sr-row-item {
    transition: background 0.12s;
}

.sr-row-item:hover {
    background: var(--sr-hover);
}

.sr-row-item.is-unsaved {
    background: #eaf5ff;
    box-shadow: inset 4px 0 #1670b7;
}

.sr-row-item.is-unsaved:hover {
    background: #dceeff;
}

.sr-name-title {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
}

.sr-unsaved-chip {
    display: inline-flex;
    align-items: center;
    min-height: 20px;
    padding: 2px 7px;
    background: #cfe7fa;
    color: #124d7a;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.04em;
}

.sr-name {
    min-width: 0;
}

.sr-name b {
    display: block;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.2;
    word-break: break-word;
}

.sr-name span {
    display: -webkit-box;
    overflow: hidden;
    margin-top: 4px;
    color: rgb(var(--v-theme-secondary));
    font-size: 12.5px;
    line-height: 1.35;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
}

.sr-code-cell {
    min-width: 0;
}

.sr-code {
    display: inline-block;
    max-width: 100%;
    padding: 3px 9px;
    border-radius: 0;
    background: var(--sr-field);
    color: rgb(var(--v-theme-secondary));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.sr-code-in {
    width: 100%;
    max-width: 220px;
    height: 32px;
    padding: 0 9px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    outline: none;
    background: var(--sr-field);
    color: rgb(var(--v-theme-on-surface));
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 12.5px;
    transition:
        border-color 0.15s,
        box-shadow 0.15s;
}

.sr-code-in:focus {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 3px rgba(var(--v-theme-primary), 0.16);
}

.sr-code-in::placeholder {
    color: rgb(var(--v-theme-secondary));
    opacity: 0.75;
}

.sr-req {
    display: flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
    color: rgb(var(--v-theme-secondary));
    font-size: 13px;
    font-weight: 600;
}

.sr-on {
    color: #1b7a3d;
}

.sr-tg {
    position: relative;
    flex: none;
    width: 44px;
    height: 26px;
    padding: 0;
    border: 0;
    border-radius: 0;
    background: #8b95aa;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.26);
    cursor: pointer;
    transition:
        background 0.2s,
        box-shadow 0.2s;
}

.sr-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    box-sizing: border-box;
    width: 20px;
    height: 20px;
    border: 1px solid rgba(0, 0, 0, 0.14);
    border-radius: 0;
    background: #f3f4f6;
    box-shadow:
        0 1px 2px rgba(0, 0, 0, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.65);
    content: "";
    transition: transform 0.2s;
}

.sr-tg[aria-checked="true"] {
    background: #1b7a3d;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.sr-tg[aria-checked="true"]::after {
    transform: translateX(18px);
}

.sr-actions {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}

.sr-ib {
    display: grid;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 0;
    background: transparent;
    color: rgb(var(--v-theme-secondary));
    cursor: pointer;
    place-items: center;
    transition:
        background 0.15s,
        border-color 0.15s,
        color 0.15s;
}

.sr-ib-edit {
    border-color: rgba(184, 110, 0, 0.35);
    color: #b86e00;
}

.sr-ib-edit:hover {
    border-color: rgba(184, 110, 0, 0.52);
    background: rgba(184, 110, 0, 0.12);
}

.sr-ib-delete {
    border-color: rgba(198, 40, 40, 0.28);
    color: #c62828;
}

.sr-ib-delete:hover {
    border-color: rgba(198, 40, 40, 0.45);
    background: rgba(198, 40, 40, 0.1);
}

html.dark .sr-page {
    --sr-field: #1c2645;
    --sr-hover: #1d2745;
}

html.dark .sr-row-item.is-unsaved {
    background: #182d40;
    box-shadow: inset 4px 0 #6db8f0;
}

html.dark .sr-row-item.is-unsaved:hover {
    background: #203a50;
}

html.dark .sr-unsaved-chip {
    background: #244966;
    color: #c8e7ff;
}

html.dark .sr-card {
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}

html.dark .sr-menu {
    box-shadow: 0 18px 40px -12px rgba(0, 0, 0, 0.65);
}

html.dark .sr-info {
    background: rgba(var(--v-theme-primary), 0.14);
}

html.dark .sr-tg[aria-checked="true"] {
    background: #3fbf6f;
}

html.dark .sr-on {
    color: #3fbf6f;
}

html.dark .sr-ib-edit {
    border-color: rgba(255, 191, 71, 0.4);
    color: #ffbf47;
}

html.dark .sr-ib-edit:hover {
    border-color: rgba(255, 191, 71, 0.65);
    background: rgba(255, 191, 71, 0.12);
}

html.dark .sr-ib-delete {
    border-color: rgba(255, 138, 128, 0.35);
    color: #ff8a80;
}

html.dark .sr-ib-delete:hover {
    border-color: rgba(255, 138, 128, 0.6);
    background: rgba(255, 138, 128, 0.12);
}

@media (min-width: 1200px) {
    .sr-card-hd {
        padding: 20px 28px;
    }

    .sr-row {
        padding: 16px 28px;
    }

    .sr-row-head {
        padding: 12px 28px;
    }

    .sr-name b {
        font-size: 16px;
    }

    .sr-code-in {
        max-width: 240px;
    }
}

@media (max-width: 720px) {
    .sr-card-hd {
        flex-wrap: wrap;
    }

    .sr-hd-actions {
        width: 100%;
        margin-left: 0;
        flex-direction: column;
    }

    .sr-previous,
    .sr-overview,
    .sr-add {
        width: 100%;
        margin-left: 0;
    }

    .sr-previous-item {
        align-items: stretch;
        flex-direction: column;
    }

    .sr-loading {
        min-height: 244px;
    }

    .sr-row-head,
    .sr-row-ghost {
        display: none;
    }

    .sr-row {
        grid-template-columns: 1fr auto;
        grid-template-areas:
            "name actions"
            "code code"
            "reqr requ";
        row-gap: 10px;
    }

    .sr-name {
        grid-area: name;
    }

    .sr-code-cell {
        grid-area: code;
    }

    .sr-req-r {
        grid-area: reqr;
    }

    .sr-req-u {
        grid-area: requ;
    }

    .sr-actions {
        grid-area: actions;
        align-self: start;
    }

    .sr-code-in {
        max-width: none;
    }
}

@media (max-width: 520px) {
    .sr-step-tx b {
        font-size: 15px;
    }

    .sr-step-n {
        width: 40px;
        height: 40px;
    }

    .sr-count {
        padding: 3px 8px;
        font-size: 11px;
    }

    .sr-option {
        gap: 10px;
        padding: 8px;
    }

    .sr-option-n {
        width: 36px;
        height: 36px;
    }

    .sr-row {
        padding: 14px 20px;
    }

    .sr-req {
        font-size: 12.5px;
    }
}

/* ---- Add requirement modal (design mockup port) ---- */
.req-card {
    display: flex;
    flex-direction: column;
    max-height: 90vh;
    overflow: hidden;
}

.req-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 14px;
}

.req-badge {
    flex: none;
}

.req-hd-t {
    flex: 1 1 auto;
    min-width: 0;
}

.req-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}

.req-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
    overflow-wrap: anywhere;
    word-break: break-word;
}

.req-x {
    margin-left: auto;
    flex: none;
}

.req-form {
    display: flex;
    flex: 1 1 auto;
    flex-direction: column;
    min-height: 0;
}

.req-bd {
    flex: 1 1 auto;
    min-height: 0;
    padding: 4px 24px 10px;
    overflow-y: auto;
}

.req-f {
    margin-bottom: 18px;
}

.req-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}

.req-required {
    color: rgb(var(--v-theme-error));
}

.req-opt {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}

.req-help {
    margin: 6px 2px 0;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

.req-code-ro {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 12px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 12px;
}

.req-code-ro span {
    flex: none;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}

.req-code-ro code {
    min-width: 0;
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 13px;
    overflow-wrap: anywhere;
}

.req-error {
    margin: 6px 2px 0;
    font-size: 12.5px;
    font-weight: 600;
    color: rgb(var(--v-theme-error));
}

.req-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}

.req-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}

.req-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(0, 94, 237, 0.18);
}

.req-in :deep(.v-field--error) {
    background: rgb(var(--v-theme-surface));
}

.req-in-area :deep(.v-field) {
    min-height: 96px;
}

.req-in-area :deep(textarea) {
    padding-top: 12px;
    line-height: 1.45;
}

.req-in-mono :deep(input) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14.5px;
}

.req-sec {
    margin: 0;
}

.req-sec-t {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 0 0 12px;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}

.req-sec-t::after {
    content: "";
    flex: 1;
    height: 1px;
    background: rgba(var(--v-border-color), var(--v-border-opacity));
}

.req-rule {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 10px;
    padding: 12px 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}

.req-rule-ic {
    display: grid;
    flex: none;
    width: 38px;
    height: 38px;
    border-radius: 10px;
    color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.12);
    place-items: center;
}

.req-rule-copy {
    min-width: 0;
}

.req-rule-copy b {
    display: block;
    font-size: 14.5px;
}

.req-rule-copy span {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

.req-tg {
    position: relative;
    flex: none;
    width: 48px;
    height: 28px;
    margin-left: auto;
    padding: 0;
    border: 0;
    border-radius: 99px;
    background: #8b95aa;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.26);
    cursor: pointer;
    transition:
        background 0.2s,
        box-shadow 0.2s;
}

.req-tg::after {
    position: absolute;
    top: 3px;
    left: 3px;
    box-sizing: border-box;
    width: 22px;
    height: 22px;
    border: 1px solid rgba(0, 0, 0, 0.14);
    border-radius: 50%;
    background: #f3f4f6;
    box-shadow:
        0 1px 2px rgba(0, 0, 0, 0.28),
        inset 0 1px 0 rgba(255, 255, 255, 0.65);
    content: "";
    transition: transform 0.2s;
}

.req-tg[aria-checked="true"] {
    background: #1b7a3d;
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.req-tg[aria-checked="true"]::after {
    transform: translateX(20px);
}

.req-tg:focus-visible {
    outline: 3px solid rgba(var(--v-theme-primary), 0.28);
    outline-offset: 2px;
}

.req-carry {
    --cr-blue: rgb(var(--v-theme-primary));
    --cr-blue-d: rgba(var(--v-theme-primary), 0.85);
    --cr-blue-bg: rgba(var(--v-theme-primary), 0.12);
    --cr-ink: rgb(var(--v-theme-on-surface));
    --cr-muted: rgb(var(--v-theme-secondary));
    --cr-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --cr-field: #f4f6fb;
    --cr-panel: #fff;
    --cr-ring: rgba(var(--v-theme-primary), 0.28);
    color: var(--cr-ink);
}

.req-carry .cr-card {
    border: 1.5px solid var(--cr-line);
    border-radius: 16px;
    background: var(--cr-panel);
    overflow: hidden;
    transition: border-color 0.2s;
}

.req-carry .cr-card[data-on="true"] {
    border-color: var(--cr-blue);
}

.req-carry .cr-head {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px;
}

.req-carry .cr-ic {
    width: 38px;
    height: 38px;
    border-radius: 10px;
    background: var(--cr-blue-bg);
    color: var(--cr-blue);
    display: grid;
    place-items: center;
    flex: none;
}

.req-carry .cr-ic svg {
    width: 20px;
    height: 20px;
}

.req-carry .cr-head b {
    display: block;
    font-size: 14.5px;
    font-weight: 700;
}

.req-carry .cr-d {
    display: block;
    font-size: 12.5px;
    color: var(--cr-muted);
    margin-top: 2px;
    line-height: 1.4;
}

.req-carry .cr-sw {
    margin-left: auto;
    width: 48px;
    height: 28px;
    min-width: 48px;
    padding: 0;
    border: 0;
    border-radius: 99px;
    background: #8b95aa;
    position: relative;
    flex: none;
    cursor: pointer;
    transition: background 0.2s;
}

.req-carry .cr-sw::after {
    content: "";
    position: absolute;
    top: 3px;
    left: 3px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
    transition: transform 0.2s;
}

.req-carry .cr-sw[aria-checked="true"] {
    background: #1b7a3d;
}

.req-carry .cr-sw[aria-checked="true"]::after {
    transform: translateX(20px);
}

.req-carry .cr-sw:disabled {
    opacity: 0.45;
    cursor: not-allowed;
}

.req-carry .cr-sw:focus-visible {
    outline: 3px solid var(--cr-ring);
    outline-offset: 2px;
}

.req-carry .cr-panel {
    padding: 0 14px 16px;
    border-top: 1px solid var(--cr-line);
    background: var(--cr-field);
    animation: cr-in 0.2s ease-out;
}

@keyframes cr-in {
    from {
        opacity: 0;
        transform: translateY(-4px);
    }
    to {
        opacity: 1;
        transform: none;
    }
}

.req-carry .cr-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
    padding-top: 14px;
}

.req-carry .cr-f label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    font-weight: 600;
    margin: 0 0 6px;
}

.req-carry .cr-tag {
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: var(--cr-blue);
    background: var(--cr-blue-bg);
    border-radius: 99px;
    padding: 2px 8px;
}

.req-carry .cr-sel {
    position: relative;
}

.req-carry .cr-sel select {
    width: 100%;
    height: 46px;
    border: 1.5px solid var(--cr-line);
    border-radius: 12px;
    background: var(--cr-panel);
    color: var(--cr-ink);
    font: inherit;
    font-size: 14px;
    font-weight: 600;
    padding: 0 38px 0 12px;
    appearance: none;
    -webkit-appearance: none;
    cursor: pointer;
    text-overflow: ellipsis;
}

.req-carry .cr-sel select:hover:not(:disabled) {
    border-color: #aab4cc;
}

.req-carry .cr-sel select:focus {
    outline: none;
    border-color: var(--cr-blue);
    box-shadow: 0 0 0 4px var(--cr-ring);
}

.req-carry .cr-sel select:disabled {
    background: transparent;
    border-style: dashed;
    color: var(--cr-muted);
    cursor: not-allowed;
    opacity: 1;
}

.req-carry .cr-sel svg {
    position: absolute;
    right: 12px;
    top: 50%;
    width: 18px;
    height: 18px;
    transform: translateY(-50%);
    color: var(--cr-muted);
    pointer-events: none;
}

.req-carry .cr-wrap {
    overflow-x: auto;
    padding: 16px 2px 10px;
    margin: 0 -2px;
}

.req-carry .cr-track {
    display: flex;
    align-items: center;
    list-style: none;
    margin: 0;
    padding: 0;
    width: max-content;
}

.req-carry .cr-n {
    display: flex;
    align-items: center;
}

.req-carry .cr-n + .cr-n::before {
    content: "";
    width: 12px;
    height: 3px;
    background: var(--cr-line);
    flex: none;
    transition: background 0.2s;
}

.req-carry .cr-n[data-link="1"]::before {
    background: var(--cr-blue);
}

.req-carry .cr-n button {
    width: 34px;
    height: 34px;
    border-radius: 10px;
    border: 1.5px solid var(--cr-line);
    background: var(--cr-panel);
    color: var(--cr-muted);
    font: inherit;
    font-size: 13px;
    font-weight: 800;
    padding: 0;
    cursor: pointer;
    display: grid;
    place-items: center;
    transition:
        background 0.15s,
        color 0.15s,
        border-color 0.15s,
        transform 0.1s;
}

.req-carry .cr-n button:hover:not([aria-disabled="true"]) {
    border-color: var(--cr-blue);
    color: var(--cr-blue);
}

.req-carry .cr-n button[aria-disabled="true"] {
    cursor: default;
}

.req-carry .cr-n[data-in="1"] button {
    background: var(--cr-blue);
    border-color: var(--cr-blue);
    color: #fff;
}

.req-carry .cr-n[data-in="1"] button:hover:not([aria-disabled="true"]) {
    background: var(--cr-blue-d);
    color: #fff;
}

.req-carry .cr-n[data-end="1"] button,
.req-carry .cr-n[data-start="1"] button {
    box-shadow: 0 0 0 3px var(--cr-ring);
}

.req-carry .cr-n button:focus-visible {
    outline: 3px solid var(--cr-ring);
    outline-offset: 2px;
}

.req-carry .cr-sum {
    margin: 0;
    font-size: 14px;
    line-height: 1.45;
}

.req-carry .cr-sum b {
    color: var(--cr-blue);
}

.req-carry .cr-hint {
    margin: 4px 0 0;
    font-size: 12.5px;
    color: var(--cr-muted);
    line-height: 1.45;
}

html.dark .req-carry {
    --cr-blue: #93c5fd;
    --cr-blue-d: #bfdbfe;
    --cr-blue-bg: rgba(147, 197, 253, 0.14);
    --cr-field: #1c2645;
    --cr-panel: #232b45;
    --cr-ring: rgba(147, 197, 253, 0.28);
}

html.dark .req-carry .cr-sw[aria-checked="true"] {
    background: #3fbf6f;
}

html.dark .req-carry .cr-n[data-in="1"] button,
html.dark .req-carry .cr-n[data-in="1"] button:hover:not([aria-disabled="true"]) {
    color: #0e1424;
}

@media (max-width: 420px) {
    .req-carry .cr-grid {
        grid-template-columns: 1fr;
    }
}

.req-ft {
    flex: none;
    gap: 10px;
    justify-content: flex-end;
    padding: 16px 24px max(20px, env(safe-area-inset-bottom, 0px));
}

.req-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}

.req-b-pri {
    min-width: 150px;
}

html.dark .req-in :deep(.v-field) {
    background: #232b45;
}

html.dark .req-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}

html.dark .req-rule-ic {
    background: rgba(147, 197, 253, 0.14);
    color: #93c5fd;
}

html.dark .req-tg[aria-checked="true"] {
    background: #3fbf6f;
}

@media (max-width: 520px) {
    :global(.req-dialog-content) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }

    :global(.req-dialog-content .req-card) {
        max-height: 94vh;
        border-radius: 24px 24px 0 0 !important;
    }

    .req-ft {
        flex-direction: column-reverse;
    }

    .req-b {
        width: 100%;
    }
}
</style>
