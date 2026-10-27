<template>
    <div>
        <LoadingVeil
            :show="loading || resolvingSteps"
            label="workflow steps"
            icon="mdi-source-branch"
        />
        <v-card rounded="0" elevation="0" class="wf-page mb-4">
            <header class="wf-hd">
                <div class="wf-badge" aria-hidden="true">
                    <v-icon size="26">mdi-source-branch</v-icon>
                </div>
                <div class="wf-hd-main">
                    <h1 class="wf-title">Transaction Type Steps and Routes</h1>
                    <div class="wf-sub">
                        <template v-if="selectedTypeParts.primary">
                            <b>{{ selectedTypeParts.primary }}</b>
                            <span
                                v-if="selectedTypeParts.secondary"
                                class="wf-sep"
                                >/</span
                            >
                            <b v-if="selectedTypeParts.secondary">{{
                                selectedTypeParts.secondary
                            }}</b>
                            <span v-if="selectedTypeCode" class="wf-code">{{
                                selectedTypeCode
                            }}</span>
                        </template>
                        <span v-else>Select a transaction type</span>
                    </div>
                </div>
                <div class="wf-tools">
                    <button
                        v-if="activeDef"
                        type="button"
                        class="wf-ver"
                        :aria-label="`Version: ${activeDefStatusLabel}`"
                        @click="versionDialog = true"
                    >
                        <span
                            class="wf-ver-dot"
                            :class="activeDefStatusKind"
                            aria-hidden="true"
                        />
                        <span>{{ activeDefStatusLabel }}</span>
                        <v-icon size="16" class="wf-ver-chev"
                            >mdi-chevron-down</v-icon
                        >
                    </button>
                    <v-dialog v-model="versionDialog" max-width="560">
                        <v-card rounded="0">
                            <v-card-title
                                class="d-flex align-center pa-5 lgu-head"
                            >
                                <v-avatar
                                    color="white"
                                    rounded="0"
                                    size="40"
                                    class="mr-3 lgu-head-avatar"
                                >
                                    <v-icon color="#005EED"
                                        >mdi-source-branch</v-icon
                                    >
                                </v-avatar>
                                <div>
                                    <div class="text-h6 font-weight-bold lh-1">
                                        Workflow versions
                                    </div>
                                    <div
                                        v-if="selectedTypeShortName"
                                        class="text-caption text-medium-emphasis"
                                    >
                                        {{ selectedTypeShortName }}
                                    </div>
                                </div>
                                <v-spacer />
                                <v-btn
                                    icon="mdi-close"
                                    variant="text"
                                    color="grey-darken-3"
                                    @click="versionDialog = false"
                                />
                            </v-card-title>
                            <v-card-text class="pa-4">
                                <v-list density="comfortable" class="py-0">
                                    <v-list-item
                                        v-for="d in defs || []"
                                        :key="d.id"
                                        :active="isLiveDef(d)"
                                        rounded="0"
                                        class="mb-1"
                                    >
                                        <v-list-item-title
                                            class="font-weight-bold d-flex align-center flex-wrap ga-2"
                                        >
                                            <span>v{{ d.version }}</span>
                                            <span
                                                v-if="d.name"
                                                class="status-dot"
                                                style="background: #000"
                                                aria-hidden="true"
                                            />
                                            <span
                                                v-if="d.name"
                                                class="text-primary"
                                                >{{ d.name }}</span
                                            >
                                            <span
                                                class="text-medium-emphasis font-weight-medium"
                                                >|</span
                                            >
                                            <span
                                                v-if="d.published_at"
                                                class="text-medium-emphasis font-weight-medium"
                                                >{{
                                                    fmtLiveDate(d.published_at)
                                                }}</span
                                            >
                                            <span
                                                v-else-if="d.status === 'draft'"
                                                class="text-medium-emphasis font-weight-medium"
                                                >publish first to go live</span
                                            >
                                        </v-list-item-title>
                                        <template #append>
                                            <v-chip
                                                v-if="isLiveDef(d)"
                                                color="primary"
                                                variant="flat"
                                                rounded="0"
                                                size="x-small"
                                                class="font-weight-bold"
                                            >
                                                ACTIVE
                                            </v-chip>
                                            <v-btn
                                                v-else-if="
                                                    d.status === 'published'
                                                "
                                                size="x-small"
                                                variant="outlined"
                                                color="primary"
                                                rounded="0"
                                                class="font-weight-bold"
                                                v-tooltip="
                                                    'Make this version live for new transactions'
                                                "
                                                @click="
                                                    versionDialog = false;
                                                    askMakeLive(d);
                                                "
                                            >
                                                SELECT VERSION
                                            </v-btn>
                                            <v-btn
                                                v-else-if="d.status === 'draft'"
                                                size="x-small"
                                                variant="flat"
                                                color="success"
                                                rounded="0"
                                                class="font-weight-bold"
                                                v-tooltip="
                                                    'Publish this draft as the live version for new transactions'
                                                "
                                                @click="
                                                    versionDialog = false;
                                                    publishDraft(d);
                                                "
                                            >
                                                PUBLISH
                                            </v-btn>
                                        </template>
                                    </v-list-item>
                                </v-list>
                            </v-card-text>
                            <v-divider />
                            <v-card-actions class="justify-end">
                                <v-btn
                                    variant="text"
                                    @click="versionDialog = false"
                                    >Close</v-btn
                                >
                            </v-card-actions>
                        </v-card>
                    </v-dialog>
                    <v-btn
                        class="wf-tool-btn"
                        variant="outlined"
                        prepend-icon="mdi-arrow-left"
                        @click="$router.push('/admin/transaction-types')"
                    >
                        Back
                    </v-btn>
                    <v-btn
                        v-if="stagingDirty"
                        class="wf-tool-btn wf-tool-danger"
                        variant="outlined"
                        prepend-icon="mdi-undo"
                        v-tooltip="
                            'Drop all staged edits and show the last saved state'
                        "
                        @click="discardStaged"
                    >
                        Discard
                    </v-btn>
                    <v-btn
                        class="wf-save"
                        variant="flat"
                        color="primary"
                        prepend-icon="mdi-content-save-plus-outline"
                        :disabled="!stagingDirty"
                        v-tooltip="
                            stagingDirty
                                ? 'Persist staged edits: overwrite the draft or create a new version'
                                : activeDef?.status === 'draft'
                                  ? 'No staged changes — use Publish to publish this draft'
                                  : 'No staged changes to save'
                        "
                        @click="openSaveDialog"
                    >
                        Save version
                        <span v-if="stagingDirty" class="wf-unsaved"
                            >UNSAVED</span
                        >
                    </v-btn>
                    <v-btn
                        v-if="activeDef?.status === 'draft' && !stagingDirty"
                        class="wf-tool-btn wf-publish"
                        variant="flat"
                        color="success"
                        prepend-icon="mdi-upload"
                        :disabled="saving"
                        v-tooltip="
                            'Publish this saved draft as the live version for new transactions'
                        "
                        @click="publishDraft(activeDef)"
                    >
                        Publish
                    </v-btn>
                </div>
            </header>

            <v-card-text class="wf-body pa-0">
                <v-alert
                    v-if="error"
                    type="error"
                    variant="tonal"
                    rounded="0"
                    class="wf-alert"
                >
                    {{ error }}
                </v-alert>
                <Transition name="wf-notice">
                    <div v-if="notice" class="wf-notice-wrap">
                        <v-alert
                            type="success"
                            variant="tonal"
                            rounded="0"
                            class="wf-alert"
                        >
                            {{ notice }}
                        </v-alert>
                    </div>
                </Transition>
                <v-alert
                    v-if="!selectedTypeId && !loading && queryResolved"
                    type="warning"
                    variant="tonal"
                    rounded="0"
                    class="wf-alert"
                >
                    No transaction type selected. Pick one below, or go to
                    <b>Transaction Types</b> and open <b>Steps</b> for one
                    transaction type.
                </v-alert>
                <v-select
                    v-if="
                        !selectedTypeId &&
                        !loading &&
                        queryResolved &&
                        (types || []).length
                    "
                    :model-value="null"
                    :items="typePickerOptions"
                    item-title="label"
                    item-value="id"
                    label="Select transaction type"
                    density="compact"
                    hide-details
                    class="wf-type-select"
                    @update:model-value="onPickType"
                />

                <template v-if="selectedTypeId">
                    <v-tabs
                        v-model="wfTab"
                        color="primary"
                        density="comfortable"
                        hide-slider
                        class="wf-tabs"
                    >
                        <v-tab :value="0">
                            <span>Steps</span>
                            <span class="wf-count">{{
                                flatStepRows.length
                            }}</span>
                            <span
                                v-if="stepsDirty"
                                class="wf-dirty"
                                title="Unsaved step changes"
                                aria-label="Unsaved step changes"
                            />
                        </v-tab>
                        <v-tab :value="1">
                            <span>Routes</span>
                            <span class="wf-count">{{
                                sortedRoutes.length
                            }}</span>
                            <span
                                v-if="routesDirty"
                                class="wf-dirty"
                                title="Unsaved route changes"
                                aria-label="Unsaved route changes"
                            />
                        </v-tab>
                    </v-tabs>

                    <v-alert
                        v-if="
                            !activeDef && !loading && !resolvingSteps && !error
                        "
                        type="info"
                        variant="tonal"
                        density="compact"
                        rounded="0"
                        class="wf-alert"
                    >
                        No workflow version yet. Add your first step, then press
                        <b>Save version</b> — this creates version 1 as a draft.
                    </v-alert>

                    <v-window v-model="wfTab" class="wf-window">
                        <v-window-item :value="0">
                            <div class="wf-section-head">
                                <div>
                                    <h2>Steps ({{ flatStepRows.length }})</h2>
                                    <p>
                                        The stages a transaction passes through,
                                        in order.
                                    </p>
                                </div>
                                <v-btn
                                    class="wf-add-btn"
                                    color="primary"
                                    variant="flat"
                                    prepend-icon="mdi-plus"
                                    :disabled="!selectedTypeId"
                                    @click="clickAddStep"
                                >
                                    Add step
                                </v-btn>
                            </div>

                            <div class="wf-table-stage">
                                <div
                                    v-if="
                                        !loading &&
                                        !resolvingSteps &&
                                        !flatStepRows.length
                                    "
                                    class="wf-empty"
                                >
                                    <img
                                        :src="mascotEmptyUrl"
                                        alt="No steps yet"
                                        width="180"
                                        class="wf-empty-art"
                                    />
                                    <p class="wf-empty-title">No steps yet.</p>
                                    <p class="wf-empty-text">
                                        Add the first stage of this transaction
                                        workflow.
                                    </p>
                                    <v-btn
                                        class="wf-add-btn"
                                        color="primary"
                                        variant="flat"
                                        prepend-icon="mdi-plus"
                                        @click="clickAddStep"
                                    >
                                        Add step
                                    </v-btn>
                                </div>

                                <v-data-table
                                    v-show="
                                        flatStepRows.length &&
                                        !loading &&
                                        !resolvingSteps
                                    "
                                    v-model:page="stepPage"
                                    :items="flatStepRows"
                                    :headers="stepHeaders"
                                    item-key="id"
                                    :row-props="stepRowProps"
                                    density="compact"
                                    :items-per-page="STEP_PAGE_SIZE"
                                    :items-per-page-options="[STEP_PAGE_SIZE]"
                                    :hide-default-footer="!flatStepRows.length"
                                    hover
                                    class="wf-table"
                                >
                                    <template
                                        v-slot:[`item.order_number`]="{ item }"
                                    >
                                        <span class="wf-num">{{
                                            item._num
                                        }}</span>
                                    </template>
                                    <template v-slot:[`item.name`]="{ item }">
                                        <div
                                            class="wf-name"
                                            :style="
                                                item._depth
                                                    ? {
                                                          paddingLeft: `${item._depth * 22}px`,
                                                      }
                                                    : undefined
                                            "
                                        >
                                            <v-icon
                                                v-if="item._depth > 0"
                                                size="15"
                                                class="wf-sub-icon"
                                                >mdi-subdirectory-arrow-right</v-icon
                                            >
                                            <span
                                                class="wf-name-text"
                                                :title="item.name"
                                                >{{ item.name }}</span
                                            >
                                            <v-chip
                                                v-if="isTmpRow(item)"
                                                size="x-small"
                                                class="wf-step-unsaved-chip"
                                            >
                                                UNSAVED
                                            </v-chip>
                                        </div>
                                        <div
                                            v-if="item.parent_name"
                                            class="wf-parent-note"
                                            :style="{
                                                paddingLeft: `${item._depth * 22 + 21}px`,
                                            }"
                                        >
                                            sub of {{ item.parent_name }}
                                        </div>
                                    </template>
                                    <template v-slot:[`item.stage`]="{ item }">
                                        <span
                                            class="wf-stage"
                                            :title="stageLabel(item.stage)"
                                            >{{ stageLabel(item.stage) }}</span
                                        >
                                    </template>
                                    <template
                                        v-slot:[`item.sla_minutes`]="{ item }"
                                    >
                                        <span
                                            class="wf-sla"
                                            :title="`${item.sla_minutes ?? 0} min`"
                                        >
                                            {{
                                                formatSlaMinutes(
                                                    item.sla_minutes,
                                                )
                                            }}
                                        </span>
                                    </template>
                                    <template
                                        v-slot:[`item.office_id`]="{ item }"
                                    >
                                        <span
                                            v-if="officeName(item)"
                                            class="wf-office"
                                            :title="officeName(item)"
                                        >
                                            <img
                                                v-if="officeIcon(officeOf(item))"
                                                class="wf-office-icon"
                                                :src="officeIcon(officeOf(item))"
                                                :alt="`${officeName(item)} icon`"
                                            />
                                            <span
                                                v-else
                                                class="wf-office-icon-ph"
                                                aria-label="No office icon"
                                            >
                                                ?
                                            </span>
                                            <span class="wf-office-text">{{
                                                officeName(item)
                                            }}</span>
                                        </span>
                                        <span
                                            v-else
                                            class="wf-office is-dynamic"
                                            >User’s office</span
                                        >
                                    </template>
                                    <template
                                        v-slot:[`item.is_end_user`]="{ item }"
                                    >
                                        <div class="wf-eu">
                                            <button
                                                type="button"
                                                class="wf-tg"
                                                role="switch"
                                                :aria-checked="
                                                    item.is_end_user
                                                        ? 'true'
                                                        : 'false'
                                                "
                                                :aria-label="`Toggle end user for ${item.name}`"
                                                @click="
                                                    toggleEndUser(
                                                        item,
                                                        !item.is_end_user,
                                                    )
                                                "
                                            ></button>
                                            <span
                                                :class="{
                                                    'is-on': item.is_end_user,
                                                }"
                                                >{{
                                                    item.is_end_user
                                                        ? "Yes"
                                                        : "No"
                                                }}</span
                                            >
                                        </div>
                                    </template>
                                    <template
                                        v-slot:[`item.role_ids`]="{ item }"
                                    >
                                        <div class="wf-roles">
                                            <span
                                                v-for="r in roleNames(item)"
                                                :key="r"
                                                class="wf-role"
                                                :title="r"
                                                >{{ r }}</span
                                            >
                                            <span
                                                v-if="!roleNames(item).length"
                                                class="wf-muted"
                                                >—</span
                                            >
                                        </div>
                                    </template>
                                    <template v-slot:[`item.flags`]="{ item }">
                                        <div class="wf-flags">
                                            <span
                                                v-if="item.is_start"
                                                class="wf-flag is-start"
                                                >Start</span
                                            >
                                            <span
                                                v-if="item.is_end"
                                                class="wf-flag is-end"
                                                >End</span
                                            >
                                            <span
                                                v-if="
                                                    !item.is_start &&
                                                    !item.is_end
                                                "
                                                class="wf-muted"
                                                >—</span
                                            >
                                        </div>
                                    </template>

                                    <template
                                        v-slot:[`item.actions`]="{ item }"
                                    >
                                        <div class="wf-actions">
                                            <v-btn
                                                class="wf-icon-btn"
                                                icon="mdi-clipboard-check-outline"
                                                aria-label="Requirements"
                                                v-tooltip="
                                                    isTmpRow(item)
                                                        ? 'Save version first — new steps get requirements after their first save'
                                                        : 'Requirements'
                                                "
                                                size="small"
                                                variant="outlined"
                                                :disabled="isTmpRow(item)"
                                                @click="
                                                    goStepRequirements(item)
                                                "
                                            />
                                            <v-btn
                                                class="wf-icon-btn"
                                                icon="mdi-text-box-outline"
                                                aria-label="Step data"
                                                v-tooltip="'Step data'"
                                                size="small"
                                                variant="outlined"
                                                @click="goStepData(item)"
                                            />
                                            <v-btn
                                                class="wf-icon-btn is-edit"
                                                icon="mdi-pencil"
                                                aria-label="Edit step"
                                                v-tooltip="'Edit step'"
                                                size="small"
                                                variant="outlined"
                                                @click="editStep(item)"
                                            />
                                            <v-btn
                                                class="wf-icon-btn is-delete"
                                                icon="mdi-delete"
                                                aria-label="Delete step"
                                                v-tooltip="'Delete step'"
                                                size="small"
                                                variant="outlined"
                                                @click="deleteStep(item)"
                                            />
                                        </div>
                                    </template>
                                </v-data-table>

                                <div
                                    v-if="loading || resolvingSteps"
                                    class="wf-table-loading"
                                >
                                    <v-skeleton-loader type="table-thead" />
                                    <v-skeleton-loader
                                        type="table-tbody"
                                        class="mt-2"
                                    />
                                    <TableLoader
                                        compact
                                        label="steps"
                                        icon="mdi-source-branch"
                                    />
                                </div>
                            </div>
                        </v-window-item>
                        <v-window-item :value="1">
                            <div class="wf-section-head">
                                <div>
                                    <h2>Routes ({{ sortedRoutes.length }})</h2>
                                    <p>
                                        Allowed transitions between the steps
                                        above.
                                    </p>
                                </div>
                                <v-btn
                                    class="wf-add-btn"
                                    color="primary"
                                    variant="flat"
                                    prepend-icon="mdi-plus"
                                    :disabled="!selectedTypeId"
                                    @click="clickAddRoute"
                                >
                                    Add route
                                </v-btn>
                            </div>

                            <div class="wf-table-stage">
                                <div
                                    v-if="
                                        !loading &&
                                        !resolvingSteps &&
                                        !sortedRoutes.length
                                    "
                                    class="wf-empty"
                                >
                                    <img
                                        :src="mascotEmptyUrl"
                                        alt="No routes yet"
                                        width="180"
                                        class="wf-empty-art"
                                    />
                                    <p class="wf-empty-title">No routes yet.</p>
                                    <p class="wf-empty-text">
                                        Connect two steps to define how a
                                        transaction moves.
                                    </p>
                                    <v-btn
                                        class="wf-add-btn"
                                        color="primary"
                                        variant="flat"
                                        prepend-icon="mdi-plus"
                                        @click="clickAddRoute"
                                    >
                                        Add route
                                    </v-btn>
                                </div>

                                <v-data-table
                                    v-show="
                                        sortedRoutes.length &&
                                        !loading &&
                                        !resolvingSteps
                                    "
                                    v-model:page="routePage"
                                    :items="sortedRoutes"
                                    :headers="routeHeaders"
                                    item-key="id"
                                    density="compact"
                                    :items-per-page="ROUTE_PAGE_SIZE"
                                    :items-per-page-options="[ROUTE_PAGE_SIZE]"
                                    :hide-default-footer="!sortedRoutes.length"
                                    hover
                                    class="wf-table"
                                >
                                    <template
                                        v-slot:[`item.from_step_id`]="{ item }"
                                    >
                                        <span
                                            class="wf-route-step"
                                            :class="{
                                                'is-deleted': stepLabel(
                                                    item.from_step_id,
                                                ).deleted,
                                            }"
                                            :title="
                                                stepLabel(item.from_step_id)
                                                    .text
                                            "
                                        >
                                            {{
                                                stepLabel(item.from_step_id)
                                                    .text
                                            }}
                                        </span>
                                    </template>
                                    <template
                                        v-slot:[`item.to_step_id`]="{ item }"
                                    >
                                        <span
                                            class="wf-route-step"
                                            :class="{
                                                'is-to': !stepLabel(
                                                    item.to_step_id,
                                                ).deleted,
                                                'is-deleted': stepLabel(
                                                    item.to_step_id,
                                                ).deleted,
                                            }"
                                            :title="
                                                stepLabel(item.to_step_id).text
                                            "
                                        >
                                            {{
                                                stepLabel(item.to_step_id).text
                                            }}
                                        </span>
                                    </template>
                                    <template
                                        v-slot:[`item.action_code`]="{ item }"
                                    >
                                        <span
                                            class="wf-action-code"
                                            :class="{
                                                'is-return':
                                                    item.is_return_route,
                                            }"
                                        >
                                            {{ item.action_code || "—" }}
                                        </span>
                                    </template>
                                    <template
                                        v-slot:[`item.route_group`]="{ item }"
                                    >
                                        <span
                                            v-if="item.route_group"
                                            class="wf-group-tag"
                                            >{{ item.route_group }}</span
                                        >
                                        <span v-else class="wf-muted">—</span>
                                    </template>
                                    <template
                                        v-slot:[`item.required_approvals_count`]="{
                                            item,
                                        }"
                                    >
                                        <span
                                            v-if="item.required_approvals_count"
                                            class="wf-approvals"
                                            >{{
                                                item.required_approvals_count
                                            }}</span
                                        >
                                        <span v-else class="wf-muted">—</span>
                                    </template>
                                    <template
                                        v-slot:[`item.condition_expression`]="{
                                            item,
                                        }"
                                    >
                                        <code
                                            v-if="
                                                pretty(
                                                    item.condition_expression,
                                                )
                                            "
                                            class="wf-condition"
                                            :title="
                                                pretty(
                                                    item.condition_expression,
                                                )
                                            "
                                            >{{
                                                pretty(
                                                    item.condition_expression,
                                                )
                                            }}</code
                                        >
                                        <span v-else class="wf-muted">—</span>
                                    </template>

                                    <template
                                        v-slot:[`item.actions`]="{ item }"
                                    >
                                        <div class="wf-actions">
                                            <v-btn
                                                class="wf-icon-btn is-edit"
                                                icon="mdi-pencil"
                                                aria-label="Edit route"
                                                v-tooltip="'Edit route'"
                                                size="small"
                                                variant="outlined"
                                                @click="editRoute(item)"
                                            />
                                            <v-btn
                                                class="wf-icon-btn is-delete"
                                                icon="mdi-delete"
                                                aria-label="Delete route"
                                                v-tooltip="'Delete route'"
                                                size="small"
                                                variant="outlined"
                                                @click="deleteRoute(item)"
                                            />
                                        </div>
                                    </template>
                                </v-data-table>

                                <div
                                    v-if="loading || resolvingSteps"
                                    class="wf-table-loading"
                                >
                                    <v-skeleton-loader type="table-thead" />
                                    <v-skeleton-loader
                                        type="table-tbody"
                                        class="mt-2"
                                    />
                                    <TableLoader
                                        compact
                                        label="routes"
                                        icon="mdi-source-branch"
                                    />
                                </div>
                            </div>
                        </v-window-item>
                    </v-window>
                </template>
            </v-card-text>
        </v-card>

        <!-- Step Dialog -->
        <v-dialog v-model="stepDialog" max-width="620" scrollable>
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title class="stp-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="stp-badge"
                    >
                        <v-icon>mdi-source-branch</v-icon>
                    </v-avatar>
                    <div class="stp-hd-t">
                        <div class="stp-title">
                            {{ stepForm.id ? "Edit Step" : "New Step" }}
                        </div>
                        <div class="stp-sub">
                            {{
                                stepForm.id
                                    ? "Update this step's details, SLA and routing."
                                    : "Add a step to the workflow and set how long it should take."
                            }}
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        color="grey-darken-3"
                        class="stp-x"
                        @click="stepDialog = false"
                    />
                </v-card-title>
                <v-divider />
                <v-card-text class="stp-bd">
                    <v-alert
                        v-if="stepError"
                        type="error"
                        variant="tonal"
                        density="compact"
                        class="mb-4"
                    >
                        {{ stepError }}
                    </v-alert>

                    <div class="stp-sec">
                        <h3 class="stp-sec-t">Basics</h3>
                        <div class="stp-g">
                            <div class="stp-f">
                                <label class="stp-lb" for="stp-order"
                                    >Order #</label
                                >
                                <v-text-field
                                    id="stp-order"
                                    v-model="stepForm.order_number"
                                    type="number"
                                    min="1"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details="auto"
                                    :error-messages="stepErrors.order_number"
                                    class="stp-in"
                                    @update:model-value="
                                        clearStepError('order_number')
                                    "
                                />
                            </div>
                            <div class="stp-f">
                                <label class="stp-lb" for="stp-parent"
                                    >Parent step</label
                                >
                                <v-select
                                    id="stp-parent"
                                    v-model="stepForm.parent_id"
                                    :items="parentStepItems"
                                    item-title="label"
                                    item-value="id"
                                    placeholder="None (top level)"
                                    variant="outlined"
                                    density="comfortable"
                                    persistent-placeholder
                                    clearable
                                    hide-details="auto"
                                    class="stp-in"
                                />
                                <div
                                    v-if="!parentStepOptions.length"
                                    class="stp-help"
                                >
                                    No steps yet — save this as the first
                                    top-level step, then nest others under it.
                                </div>
                            </div>
                        </div>
                        <div class="stp-g2">
                            <div class="stp-f">
                                <label class="stp-lb" for="stp-name"
                                    >Name <span class="stp-req">*</span></label
                                >
                                <v-text-field
                                    id="stp-name"
                                    v-model="stepForm.name"
                                    placeholder="e.g. Submit PR to OCT"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details="auto"
                                    persistent-placeholder
                                    :error-messages="stepErrors.name"
                                    class="stp-in"
                                    @update:model-value="clearStepError('name')"
                                />
                            </div>
                            <div class="stp-f">
                                <label class="stp-lb" for="stp-stage"
                                    >Stage</label
                                >
                                <v-text-field
                                    id="stp-stage"
                                    v-model="stepForm.stage"
                                    placeholder="e.g. Planning"
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details="auto"
                                    persistent-placeholder
                                    class="stp-in"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="stp-sec">
                        <h3 class="stp-sec-t">SLA duration</h3>
                        <SlaDurationInput
                            :key="slaInputKey"
                            v-model="slaMinutes"
                            :max-days="SLA_MAX_DAYS"
                            :max-total="SLA_MAX_TOTAL"
                        />
                    </div>

                    <div class="stp-sec">
                        <h3 class="stp-sec-t">Flow</h3>
                        <div class="stp-g2">
                            <div class="stp-sw">
                                <div>
                                    <div class="stp-sw-t">Start step</div>
                                    <div class="stp-sw-d">
                                        First step in the workflow
                                    </div>
                                </div>
                                <v-spacer />
                                <v-switch
                                    v-model="stepForm.is_start"
                                    color="success"
                                    density="compact"
                                    hide-details
                                    inset
                                    class="stp-sw-tg"
                                />
                            </div>
                            <div class="stp-sw">
                                <div>
                                    <div class="stp-sw-t">End step</div>
                                    <div class="stp-sw-d">
                                        Completes the workflow
                                    </div>
                                </div>
                                <v-spacer />
                                <v-switch
                                    v-model="stepForm.is_end"
                                    color="success"
                                    density="compact"
                                    hide-details
                                    inset
                                    class="stp-sw-tg"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="stp-sec">
                        <h3 class="stp-sec-t">Routing</h3>
                        <div class="stp-f">
                            <label class="stp-lb" for="stp-office"
                                >Assigned Office</label
                            >
                            <v-select
                                id="stp-office"
                                v-model="stepOffice"
                                :items="officeOptions"
                                item-title="label"
                                item-value="id"
                                :item-props="officeItemProps"
                                variant="outlined"
                                density="comfortable"
                                hide-details="auto"
                                :error-messages="stepErrors.office_id"
                                class="stp-in stp-offices"
                            >
                                <template #selection="{ item }">
                                    <span class="stp-office-selection">
                                        <img
                                            v-if="item.raw.icon"
                                            class="stp-office-chip-icon"
                                            :src="item.raw.icon"
                                            :alt="`${item.raw.label} icon`"
                                        />
                                        <span>{{ item.raw.label }}</span>
                                    </span>
                                </template>
                                <template #item="{ props: itemProps, item }">
                                    <v-list-item v-bind="itemProps">
                                        <template #prepend>
                                            <img
                                                v-if="item.raw.icon"
                                                class="stp-office-option-icon"
                                                :src="item.raw.icon"
                                                :alt="`${item.raw.label} icon`"
                                            />
                                            <span
                                                v-else
                                                class="stp-office-option-icon-placeholder"
                                                aria-label="No office icon"
                                            >
                                                ?
                                            </span>
                                        </template>
                                    </v-list-item>
                                </template>
                            </v-select>
                            <div
                                v-if="stepForm.office_id == null"
                                class="stp-help stp-help-user-office"
                            >
                                <v-icon size="14" color="info" class="mr-1"
                                    >mdi-information-outline</v-icon
                                >
                                <strong>User's Office</strong> means the
                                Originating Office — the office of the user who
                                created the transaction. Only users in that
                                office with the selected roles can handle this
                                step.
                            </div>
                            <div v-else class="stp-help">
                                Only users in this office can
                                {{
                                    stepForm.is_end
                                        ? "complete"
                                        : "receive, work on, or send"
                                }}
                                this step.
                            </div>
                        </div>
                        <span class="stp-lb">Roles allowed for this step</span>
                        <div class="stp-roles">
                            <button
                                v-for="r in roleOptions"
                                :key="r.id"
                                type="button"
                                class="stp-role"
                                :class="{ 'is-on': isRoleOn(r.id) }"
                                :aria-pressed="
                                    isRoleOn(r.id) ? 'true' : 'false'
                                "
                                @click="toggleRole(r.id)"
                            >
                                {{ r.label }}
                            </button>
                        </div>
                    </div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="stp-ft">
                    <v-btn
                        variant="outlined"
                        rounded="lg"
                        class="stp-b"
                        @click="stepDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn
                        color="primary"
                        rounded="lg"
                        class="stp-b stp-b-pri"
                        :loading="saving"
                        @click="saveStep"
                        >Save</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Route Dialog (design mockup port) -->
        <v-dialog v-model="routeDialog" max-width="640" scrollable>
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title class="stp-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="stp-badge"
                    >
                        <v-icon>mdi-transit-connection-variant</v-icon>
                    </v-avatar>
                    <div class="stp-hd-t">
                        <div class="stp-title">
                            {{ routeForm.id ? "Edit Route" : "New Route" }}
                        </div>
                        <div class="stp-sub">
                            Connect one step to the next and choose what
                            triggers it.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        color="grey-darken-3"
                        class="stp-x"
                        @click="routeDialog = false"
                    />
                </v-card-title>
                <v-divider />
                <v-card-text class="stp-bd">
                    <v-alert
                        v-if="routeError"
                        type="error"
                        variant="tonal"
                        density="compact"
                        class="mb-4"
                    >
                        {{ routeError }}
                    </v-alert>
                    <div class="stp-sec">
                        <div class="rt-ft2">
                            <div
                                class="stp-f"
                                :class="{
                                    bad: !!routeFieldErrors.from_step_id,
                                }"
                            >
                                <label class="stp-lb" for="rt-from"
                                    >From step
                                    <span class="stp-req">*</span></label
                                >
                                <v-select
                                    id="rt-from"
                                    v-model="routeForm.from_step_id"
                                    :items="fromStepOptions"
                                    item-title="label"
                                    item-value="id"
                                    placeholder="Select a step"
                                    variant="outlined"
                                    density="comfortable"
                                    persistent-placeholder
                                    hide-details="auto"
                                    :error="!!routeFieldErrors.from_step_id"
                                    class="stp-in"
                                    @update:model-value="onRouteFieldChange"
                                />
                                <div class="rt-em">
                                    {{ routeFieldErrors.from_step_id }}
                                </div>
                            </div>
                            <div class="rt-arrow" aria-hidden="true">
                                <v-icon>mdi-arrow-right</v-icon>
                            </div>
                            <div
                                class="stp-f"
                                :class="{ bad: !!routeFieldErrors.to_step_id }"
                            >
                                <label class="stp-lb" for="rt-to"
                                    >To step
                                    <span class="stp-req">*</span></label
                                >
                                <v-select
                                    id="rt-to"
                                    v-model="routeForm.to_step_id"
                                    :items="toStepOptions"
                                    item-title="label"
                                    item-value="id"
                                    placeholder="Select a step"
                                    variant="outlined"
                                    density="comfortable"
                                    persistent-placeholder
                                    hide-details="auto"
                                    :error="!!routeFieldErrors.to_step_id"
                                    class="stp-in"
                                    @update:model-value="onRouteFieldChange"
                                />
                                <div class="rt-em">
                                    {{ routeFieldErrors.to_step_id }}
                                </div>
                            </div>
                        </div>
                        <div class="rt-info">
                            <v-icon size="18">mdi-information-outline</v-icon>
                            <span
                                >Routes are forward-only. Going back is done by
                                jumping to a visited station, which is recorded
                                as Returned.</span
                            >
                        </div>
                    </div>

                    <div class="stp-sec">
                        <span class="stp-lb"
                            >Action <span class="stp-req">*</span></span
                        >
                        <div class="rt-acts" role="group" aria-label="Action">
                            <button
                                v-for="a in routeActionPills"
                                :key="a.key"
                                type="button"
                                class="rt-pill"
                                :class="{
                                    'is-on': routeAction === a.key,
                                    'is-rej': a.rej,
                                }"
                                :aria-pressed="
                                    routeAction === a.key ? 'true' : 'false'
                                "
                                @click="setRouteAction(a.key)"
                            >
                                {{ a.label }}
                            </button>
                        </div>
                        <div v-if="routeAction === '__other'" class="rt-cw">
                            <v-text-field
                                id="rt-cc"
                                ref="routeCustomInput"
                                v-model="routeCustomCode"
                                placeholder="custom_action_code"
                                variant="outlined"
                                density="comfortable"
                                hide-details="auto"
                                autocomplete="off"
                                spellcheck="false"
                                aria-label="Custom action code"
                                :error="!!routeFieldErrors.action_code"
                                class="stp-in rt-in-mono"
                                @update:model-value="onRouteFieldChange"
                            />
                            <div
                                v-if="routeFieldErrors.action_code"
                                class="rt-em"
                                style="display: block"
                            >
                                {{ routeFieldErrors.action_code }}
                            </div>
                        </div>
                        <div class="stp-help">
                            {{ routeActionHelp[routeAction] }}
                        </div>
                    </div>

                    <div class="stp-sec">
                        <button
                            class="rt-adv"
                            type="button"
                            :aria-expanded="routeAdvanced ? 'true' : 'false'"
                            @click="routeAdvanced = !routeAdvanced"
                        >
                            Advanced options
                            <small>Lane, approvals, condition</small>
                            <v-icon
                                class="rt-adv-i"
                                :class="{ 'is-open': routeAdvanced }"
                                >mdi-chevron-down</v-icon
                            >
                        </button>
                        <div v-show="routeAdvanced" class="rt-advp">
                            <div class="stp-g2" style="margin-bottom: 14px">
                                <div class="stp-f">
                                    <label class="stp-lb" for="rt-lane"
                                        >Route group / lane
                                        <span class="stp-opt"
                                            >(optional)</span
                                        ></label
                                    >
                                    <v-text-field
                                        id="rt-lane"
                                        v-model="routeForm.route_group"
                                        placeholder="e.g. main"
                                        variant="outlined"
                                        density="comfortable"
                                        persistent-placeholder
                                        hide-details="auto"
                                        class="stp-in"
                                    />
                                </div>
                                <div class="stp-f">
                                    <label class="stp-lb" for="rt-apv"
                                        >Required approvals
                                        <span class="stp-opt"
                                            >(optional)</span
                                        ></label
                                    >
                                    <v-text-field
                                        id="rt-apv"
                                        v-model="
                                            routeForm.required_approvals_count
                                        "
                                        type="number"
                                        min="1"
                                        inputmode="numeric"
                                        placeholder="e.g. 2"
                                        variant="outlined"
                                        density="comfortable"
                                        persistent-placeholder
                                        hide-details="auto"
                                        class="stp-in"
                                    />
                                </div>
                            </div>
                            <div class="stp-f" style="margin: 0">
                                <div class="rt-jh">
                                    <label class="stp-lb" for="rt-json"
                                        >Condition expression
                                        <span class="stp-opt"
                                            >(optional JSON)</span
                                        ></label
                                    >
                                    <button
                                        class="rt-link"
                                        type="button"
                                        @click="insertConditionExample"
                                    >
                                        Insert example
                                    </button>
                                </div>
                                <v-textarea
                                    id="rt-json"
                                    v-model="
                                        routeForm.condition_expression_json
                                    "
                                    rows="5"
                                    spellcheck="false"
                                    placeholder='{">=":[{"var":"fields.amount"},50000]}'
                                    variant="outlined"
                                    density="comfortable"
                                    hide-details="auto"
                                    class="stp-in rt-in-mono"
                                />
                                <div class="rt-jv" :class="routeJsonState.cls">
                                    {{ routeJsonState.text }}
                                </div>
                            </div>
                        </div>
                    </div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="stp-ft">
                    <v-btn
                        variant="outlined"
                        rounded="lg"
                        class="stp-b"
                        @click="routeDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn
                        color="primary"
                        rounded="lg"
                        class="stp-b stp-b-pri"
                        :loading="saving"
                        @click="saveRoute"
                        >Save route</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Save staged workflow content -->
        <v-dialog
            v-model="saveDialog"
            max-width="620"
            scrollable
            content-class="sv-dialog"
        >
            <v-card rounded="xl" class="sv-card" style="overflow: hidden">
                <v-card-title class="stp-hd">
                    <v-avatar
                        color="primary"
                        variant="tonal"
                        rounded="lg"
                        size="44"
                        class="stp-badge"
                    >
                        <v-icon>mdi-content-save-outline</v-icon>
                    </v-avatar>
                    <div class="stp-hd-t">
                        <div class="stp-title">
                            {{ activeDef ? "Save version" : "Save version 1" }}
                        </div>
                        <div class="stp-sub">
                            Review your staged changes and choose how to save
                            them.
                        </div>
                    </div>
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        size="small"
                        class="stp-x"
                        aria-label="Close save dialog"
                        @click="saveDialog = false"
                    />
                </v-card-title>
                <v-divider />
                <v-card-text class="stp-bd">
                    <v-alert
                        v-if="saveError"
                        type="error"
                        variant="tonal"
                        density="compact"
                        closable
                        class="mb-4"
                        @click:close="saveError = ''"
                    >
                        {{ saveError }}
                    </v-alert>

                    <div class="sv-sum">
                        <div class="sv-sum-copy">
                            <template v-if="stagedChangeTotal">
                                Saving applies the staged changes below in one
                                atomic step. Nothing is written until you
                                confirm.
                            </template>
                            <template v-else>
                                No staged content changes. This save will only
                                update the version details or publish the
                                current draft.
                            </template>
                            <template v-if="!activeDef"
                                >Your first Save creates version 1 as a
                                draft.</template
                            >
                        </div>
                        <div class="sv-chips">
                            <v-menu
                                v-for="chip in stagedCounts"
                                :key="chip.key"
                                open-on-hover
                                open-on-focus
                                :open-delay="120"
                                :close-delay="180"
                                :close-on-content-click="false"
                                location="bottom"
                                offset="8"
                            >
                                <template #activator="{ props: menuProps }">
                                    <button
                                        v-bind="menuProps"
                                        type="button"
                                        class="sv-chip"
                                        :class="{ 'is-zero': !chip.count }"
                                        :aria-label="`${chip.label}: ${chip.count} change${chip.count === 1 ? '' : 's'}. Show details.`"
                                    >
                                        <span class="sv-chip-n">{{
                                            chip.count
                                        }}</span>
                                        <span>{{ chip.label }}</span>
                                    </button>
                                </template>
                                <v-card
                                    class="sv-pop"
                                    rounded="lg"
                                    elevation="8"
                                >
                                    <div class="sv-pop-h">
                                        <span>{{ chip.label }}</span>
                                        <span class="sv-pop-count">
                                            {{ chip.count }} change{{
                                                chip.count === 1 ? "" : "s"
                                            }}
                                        </span>
                                    </div>
                                    <div
                                        v-if="chip.items.length"
                                        class="sv-pop-list"
                                    >
                                        <div
                                            v-for="(item, idx) in chip.items"
                                            :key="`${chip.key}-${idx}`"
                                            class="sv-pop-item"
                                        >
                                            <span
                                                class="sv-pop-dot"
                                                :class="`is-${item.kind}`"
                                            ></span>
                                            <div class="sv-pop-body">
                                                <div class="sv-pop-label">
                                                    <span class="sv-pop-kind">
                                                        {{
                                                            changeKindLabel(
                                                                item.kind,
                                                            )
                                                        }}
                                                    </span>
                                                    {{ item.label }}
                                                </div>
                                                <div
                                                    v-if="item.changes.length"
                                                    class="sv-pop-changes"
                                                >
                                                    <div
                                                        v-for="(
                                                            change, ci
                                                        ) in item.changes"
                                                        :key="`${change.field}-${ci}`"
                                                        class="sv-pop-change"
                                                    >
                                                        <span
                                                            class="sv-pop-field"
                                                        >
                                                            {{ change.label }}:
                                                        </span>
                                                        <span
                                                            class="sv-pop-val"
                                                            :title="
                                                                changeValueTitle(
                                                                    change,
                                                                    change.from,
                                                                )
                                                            "
                                                        >
                                                            {{
                                                                formatChangeValue(
                                                                    change,
                                                                    change.from,
                                                                )
                                                            }}
                                                        </span>
                                                        <span
                                                            class="sv-pop-arrow"
                                                            >→</span
                                                        >
                                                        <span
                                                            class="sv-pop-val"
                                                            :title="
                                                                changeValueTitle(
                                                                    change,
                                                                    change.to,
                                                                )
                                                            "
                                                        >
                                                            {{
                                                                formatChangeValue(
                                                                    change,
                                                                    change.to,
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div v-else class="sv-pop-empty">
                                        No changes in this group.
                                    </div>
                                </v-card>
                            </v-menu>
                        </div>
                    </div>

                    <section class="stp-sec sv-sec">
                        <h3 class="stp-sec-t">How to save</h3>
                        <div class="sv-opts">
                            <label
                                class="sv-opt"
                                :class="{ 'is-on': saveMode === 'overwrite' }"
                            >
                                <input
                                    v-model="saveMode"
                                    class="sv-opt-input"
                                    type="radio"
                                    name="sv-save-mode"
                                    value="overwrite"
                                />
                                <span
                                    class="sv-radio"
                                    aria-hidden="true"
                                ></span>
                                <span class="sv-opt-body">
                                    <span class="sv-opt-title">
                                        {{
                                            activeDef
                                                ? isLiveDef(activeDef)
                                                    ? "Overwrite live version"
                                                    : "Overwrite current draft"
                                                : "Save as draft version 1"
                                        }}
                                        <span
                                            class="sv-tag"
                                            :class="
                                                activeDef &&
                                                isLiveDef(activeDef)
                                                    ? 'sv-tag-live'
                                                    : 'sv-tag-draft'
                                            "
                                        >
                                            {{
                                                activeDef &&
                                                isLiveDef(activeDef)
                                                    ? "Publishes live"
                                                    : "Stays draft"
                                            }}
                                        </span>
                                    </span>
                                    <span class="sv-opt-desc">
                                        {{
                                            activeDef
                                                ? isLiveDef(activeDef)
                                                    ? "Updates the running workflow in place and publishes automatically. The old version is kept."
                                                    : "Updates the open draft in place. The version number stays the same."
                                                : "Creates version 1 as a draft. It is not live until you publish it."
                                        }}
                                    </span>
                                </span>
                            </label>
                            <label
                                class="sv-opt"
                                :class="{ 'is-on': saveMode === 'create-new' }"
                            >
                                <input
                                    v-model="saveMode"
                                    class="sv-opt-input"
                                    type="radio"
                                    name="sv-save-mode"
                                    value="create-new"
                                />
                                <span
                                    class="sv-radio"
                                    aria-hidden="true"
                                ></span>
                                <span class="sv-opt-body">
                                    <span class="sv-opt-title">
                                        {{
                                            activeDef
                                                ? "Create new version"
                                                : "Create version 1 and publish"
                                        }}
                                        <span class="sv-tag sv-tag-live"
                                            >Published live</span
                                        >
                                    </span>
                                    <span class="sv-opt-desc">
                                        {{
                                            activeDef
                                                ? "Publishes a new version immediately. The old version is kept."
                                                : "Publishes version 1 immediately. A start and end step are required."
                                        }}
                                    </span>
                                </span>
                            </label>
                        </div>
                        <div
                            v-if="
                                saveMode === 'create-new' ||
                                (saveMode === 'overwrite' &&
                                    isLiveDef(activeDef))
                            "
                            class="sv-warn"
                        >
                            <v-icon size="18" color="warning"
                                >mdi-alert-outline</v-icon
                            >
                            <span>
                                {{
                                    saveMode === "create-new"
                                        ? "This goes live immediately for everyone who uses this workflow."
                                        : "Overwriting the live version goes live immediately for everyone who uses this workflow."
                                }}
                            </span>
                        </div>
                    </section>

                    <section class="stp-sec sv-sec">
                        <h3 class="stp-sec-t">Details</h3>
                        <div class="stp-f">
                            <label class="stp-lb" for="sv-name">
                                Version name
                                <span class="stp-opt">
                                    {{
                                        saveMode === "create-new"
                                            ? "(required)"
                                            : activeDef
                                              ? "(optional rename)"
                                              : "(optional)"
                                    }}
                                </span>
                            </label>
                            <v-text-field
                                id="sv-name"
                                v-model="saveName"
                                placeholder="e.g. Holiday rush flow"
                                maxlength="200"
                                counter
                                variant="outlined"
                                density="comfortable"
                                class="stp-in"
                                autofocus
                            />
                        </div>
                        <div class="stp-f" style="margin-bottom: 0">
                            <label class="stp-lb" for="sv-notes">
                                Notes
                                <span class="stp-opt">(optional)</span>
                            </label>
                            <v-textarea
                                id="sv-notes"
                                v-model="saveNotes"
                                rows="3"
                                placeholder="Why is this version changing?"
                                hint="Saved with this version so others can see why it changed."
                                persistent-hint
                                variant="outlined"
                                density="comfortable"
                                class="stp-in"
                            />
                        </div>
                    </section>
                </v-card-text>
                <v-divider />
                <v-card-actions class="stp-ft justify-end">
                    <v-btn
                        variant="outlined"
                        rounded="lg"
                        class="stp-b"
                        @click="saveDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn
                        color="primary"
                        rounded="lg"
                        class="stp-b stp-b-pri"
                        :loading="saving"
                        :disabled="
                            saveMode === 'create-new' && !saveName.trim()
                        "
                        @click="confirmSave"
                    >
                        {{ saveSubmitLabel }}
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Switch live version -->
        <v-dialog v-model="liveDialog" max-width="640">
            <v-card rounded="xl" style="overflow: hidden">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar
                        color="white"
                        rounded="0"
                        size="40"
                        class="mr-3 lgu-head-avatar"
                    >
                        <v-icon color="#005EED">mdi-swap-horizontal</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold"
                        >SWITCH LIVE VERSION?</span
                    >
                    <v-spacer />
                    <v-btn
                        icon="mdi-close"
                        variant="text"
                        color="grey-darken-3"
                        @click="liveDialog = false"
                    />
                </v-card-title>
                <v-card-text class="pa-12 text-center">
                    <div style="height: 16px" aria-hidden="true" />
                    <div class="d-flex align-center justify-center ga-4 mb-10">
                        <v-chip
                            rounded="0"
                            size="x-large"
                            color="grey-darken-3"
                            variant="tonal"
                            class="font-weight-bold"
                            style="
                                font-size: 1.5rem;
                                height: 60px;
                                padding: 0 28px;
                            "
                        >
                            v{{ currentDef?.version ?? "—" }}
                        </v-chip>
                        <v-icon color="primary" size="56"
                            >mdi-chevron-double-right</v-icon
                        >
                        <v-chip
                            rounded="0"
                            size="x-large"
                            color="primary"
                            variant="flat"
                            class="font-weight-bold"
                            style="
                                font-size: 1.5rem;
                                height: 60px;
                                padding: 0 28px;
                            "
                        >
                            v{{ liveTarget?.version }}
                        </v-chip>
                    </div>
                    <div class="text-subtitle-2 font-weight-bold">
                        CONFIRM TO CHANGE VERSION
                    </div>
                    <v-alert
                        type="info"
                        variant="tonal"
                        density="compact"
                        class="mt-3"
                    >
                        New transactions will use v{{ liveTarget?.version }}.
                        Running transactions stay on their version. Old versions
                        are kept.
                    </v-alert>
                </v-card-text>
                <v-divider />
                <v-card-actions
                    class="d-flex justify-space-between px-6 pt-6 pb-6"
                >
                    <v-btn
                        variant="text"
                        color="grey-darken-3"
                        rounded="0"
                        size="large"
                        style="width: 40%"
                        @click="liveDialog = false"
                        >Cancel</v-btn
                    >
                    <v-divider
                        vertical
                        :thickness="2"
                        class="align-self-stretch"
                    />
                    <v-btn
                        color="primary"
                        rounded="0"
                        size="large"
                        style="width: 40%"
                        :loading="saving"
                        @click="confirmMakeLive"
                        >Switch</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- End-of-workflow footer: same deep-blue bar as the dashboard foot. -->
        <v-sheet
            v-if="selectedTypeId"
            color="#1A1F2B"
            rounded="0"
            class="pa-4 mt-6 d-flex align-center justify-center ga-3 text-center"
        >
            <v-avatar
                color="white"
                rounded="0"
                size="52"
                class="lgu-head-avatar"
            >
                <v-icon color="#005EED" size="32">mdi-flag-checkered</v-icon>
            </v-avatar>
            <v-divider
                vertical
                :thickness="2"
                color="white"
                opacity="0.6"
                style="height: 48px"
            />
            <div class="text-left">
                <div class="text-h6 font-weight-bold text-white lh-1">
                    END OF WORKFLOW
                </div>
            </div>
        </v-sheet>

        <!-- Route save feedback (design mockup toast). -->
        <AppToast ref="routeToast" />
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
import { useWorkflows } from "@/composables/useWorkflows";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import { useRoles } from "@/composables/useRoles";
import { useOffices } from "@/composables/useOffices";
import { officeIcon } from "@/utils/officeIcons";
import TableLoader from "@/components/TableLoader.vue";
import mascotEmptyUrl from "@/assets/mascots/mascot-empty.jpg";
import LoadingVeil from "@/components/LoadingVeil.vue";
import AppToast from "@/components/AppToast.vue";
import SlaDurationInput from "@/components/SlaDurationInput.vue";
import {
    wfStatusColor,
    wfStatusIcon,
    wfStatusLabel,
} from "@/utils/workflowStatus";

const { defs, loading, fetchDefinitions, createDraft, publish, makeLive } =
    useWorkflows();

// Staging: every step/route dialog writes to the working copy only —
// nothing reaches the network until Save version (bulk apply).
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import { confirm } from "@/composables/useConfirm";
const staging = useWorkflowStaging();
// Def id the working copy was seeded from (bulk target hint for sub-pages).
const stagingSourceDefId = ref(null);

function seedFromActiveDef() {
    const t = selectedTypeId.value;
    if (!t) return;
    const d = activeDef.value;
    // Seed even when the type has no version yet: the empty bucket is the
    // working copy the first staged step lands in.
    stagingSourceDefId.value = d?.id ?? null;
    staging.seedSteps(t, d?.id ?? null, d?.updated_at ?? null, d?.steps || []);
    staging.seedRoutes(t, d?.routes || []);
}

const stagingBucket = computed(() =>
    selectedTypeId.value
        ? staging.buckets.get(String(selectedTypeId.value))
        : null,
);
// Tables always render the working copy once seeded (dirty or not); before
// the first seed they fall back to the loaded definition.
const tableSteps = computed(() => {
    const b = stagingBucket.value;
    if (b && (b.dirty || b.sourceDefId != null)) return b.steps;
    return activeDef.value?.steps || [];
});
const tableRoutes = computed(() => {
    const b = stagingBucket.value;
    if (b && (b.dirty || b.sourceDefId != null)) return b.routes;
    return activeDef.value?.routes || [];
});
const stagingDirty = computed(() => !!stagingBucket.value?.dirty);
// Per-tab unsaved dots: steps/routes table edits only (sub-page edits
// keep the global dirty flag). Cleared with the bucket on save/discard.
const stepsDirty = computed(() => !!stagingBucket.value?.stepsDirty);
const routesDirty = computed(() => !!stagingBucket.value?.routesDirty);
// Steps/Routes tab state (panes stay mounted, so paging survives switches).
const wfTab = ref(0);
// Tmp rows (unsaved) carry string ids — no sub-page configuration yet.
const isTmpRow = (item) => typeof item?.id === "string";
const stepRowProps = ({ item }) => ({
    class: isTmpRow(item) ? "wf-step-unsaved-row" : "",
});

function discardStaged() {
    if (!selectedTypeId.value) return;
    staging.discard(selectedTypeId.value);
    error.value = "";
    notice.value = "Staged changes discarded — showing the last saved state.";
    seedFromActiveDef();
}

const { items: types, fetchAll: fetchTypes } = useTransactionTypes();
const { roles, fetchRoles } = useRoles();
const { items: offices, fetchAll: fetchOffices } = useOffices();

const selectedTypeId = ref(null);
const activeDef = ref(null);
// True once the initial URL query has been reconciled (after lookups).
const queryResolved = ref(false);
const error = ref("");
const notice = ref("");
const NOTICE_TIMEOUT_MS = 5000;
let noticeTimer = null;

watch(notice, (message) => {
    if (noticeTimer) {
        clearTimeout(noticeTimer);
        noticeTimer = null;
    }
    if (!message) return;
    noticeTimer = setTimeout(() => {
        notice.value = "";
        noticeTimer = null;
    }, NOTICE_TIMEOUT_MS);
});

onBeforeUnmount(() => {
    if (noticeTimer) clearTimeout(noticeTimer);
});

const saving = ref(false);
const route = useRoute();
const router = useRouter();

const guideSections = [
    {
        title: "TRANSACTION TYPES",
        rows: [
            {
                term: "TRANSACTION TYPE",
                text: "CURRENT = LIVE FLOW, DRAFT = EDITABLE, PREVIOUS = RETIRED",
            },
            {
                term: "STATUS",
                text: "DRAFT = EDITABLE, PUBLISHED = LIVE, ARCHIVED = RETIRED",
            },
            { term: "NAME", text: "TRANSACTION TYPE LABEL" },
        ],
    },
    {
        title: "STEPS",
        rows: [
            { term: "FLAGS", text: "START = FIRST STEP, END = FINAL STEP" },
            { term: "SLA (MIN)", text: "TARGET MINUTES TO FINISH THE STEP" },
            { term: "STAGE", text: "WHICH OFFICE / PHASE HANDLES IT" },
        ],
    },
    {
        title: "ROUTES",
        rows: [
            {
                term: "FROM → TO",
                text: "FORWARD ONLY: WHICH STEP MOVES TO WHICH ON AN ACTION",
            },
            {
                term: "GOING BACK",
                text: "JUMP TO A VISITED STATION (RECORDED AS RETURNED)",
            },
        ],
    },
];

const roleOptions = computed(
    () =>
        (roles.value || [])
            .filter(
                (r) =>
                    !["end_user", "admin", "superadmin"].includes(r.code),
            )
            .map((r) => ({ id: r.id, label: `${r.name}` })), // use ${r.code} to show Role Code
);

const nonSelectableStepRoleIds = computed(
    () =>
        new Set(
            (roles.value || [])
                .filter((r) => ["admin", "superadmin"].includes(r.code))
                .map((r) => Number(r.id)),
        ),
);

function selectableStepRoleIds(roleIds) {
    return (roleIds || [])
        .map(Number)
        .filter((id) => !nonSelectableStepRoleIds.value.has(id));
}

// UI-only value for the explicit User's Office row. The stored step office
// stays null so every existing rule keeps treating blank as the origin office.
const USER_OFFICE = "__user_office__";

const officeOptions = computed(() => [
    { id: USER_OFFICE, label: "User's Office" },
    ...(offices.value || []).map((o) => ({
        id: o.id,
        label: `${o.name}`,
        icon: officeIcon(o),
    })),
]);

function officeItemProps(item) {
    return item?.id === USER_OFFICE
        ? { subtitle: "The office that created the transaction" }
        : {};
}

const roleNameById = computed(() => {
    const m = new Map();
    for (const r of roles.value || []) m.set(Number(r.id), r.name || r.code);
    return m;
});

const endUserRoleId = computed(() => {
    const found = (roles.value || []).find((r) => r.code === "end_user");
    return found ? Number(found.id) : null;
});

const officeNameById = computed(() => {
    const m = new Map();
    for (const o of offices.value || []) m.set(Number(o.id), o.name || o.code);
    return m;
});

// The ids are the truth: a staged edit changes office_id / role_ids but the
// row keeps the loaded `office` / `roles` objects, so read the ids first and
// use the objects only as a fallback (e.g. an office missing from the list).
function officeName(item) {
    if (item?.office_id == null) return "";
    const byId = officeNameById.value.get(Number(item.office_id));
    if (byId) return byId;
    return Number(item?.office?.id) === Number(item.office_id) ? item.office.name || "" : "";
}

// The office object for a step row (for its icon): ids are the truth, the
// embedded `office` object is only a fallback.
function officeOf(item) {
    if (item?.office_id == null) return null;
    const byId = (offices.value || []).find((o) => Number(o.id) === Number(item.office_id));
    if (byId) return byId;
    return Number(item?.office?.id) === Number(item.office_id) ? item.office : null;
}

// Stages are stored as codes (end_user, gso, city_admin …). Present the
// readable label in the table instead of the raw database value.
const STAGE_LABELS = {
    end_user: "End user",
    gso: "GSO",
    city_admin: "City Admin",
    cadmin: "City Admin",
    city_treasurer: "City Treasurer",
    cto: "CTO",
    cbo: "CBO",
    bac_paad: "BAC-PAAD",
    hr: "HR",
    accounting: "Accounting",
};

function stageLabel(value) {
    const raw = String(value ?? "").trim();
    if (!raw) return "—";
    if (STAGE_LABELS[raw.toLowerCase()]) return STAGE_LABELS[raw.toLowerCase()];
    return raw
        .replace(/[_-]+/g, " ")
        .replace(/\b\w/g, (char) => char.toUpperCase());
}

function roleNames(item) {
    const hiddenId = endUserRoleId.value;
    if (!Array.isArray(item?.role_ids) && Array.isArray(item?.roles) && item.roles.length)
        return item.roles
            .filter((r) => r.code !== "end_user" && Number(r.id) !== hiddenId)
            .map((r) => r.name || r.code);
    return (item?.role_ids || [])
        .map(Number)
        .filter((id) => id !== hiddenId)
        .map((id) => roleNameById.value.get(id) || `#${id}`);
}

// Header breadcrumb: split names such as "Procurement : IT Equipment" into
// two bold crumbs. Names without a colon remain a single crumb.
const selectedTypeParts = computed(() => {
    const t = (types.value || []).find(
        (x) => Number(x.id) === Number(selectedTypeId.value),
    );
    const raw = String(t?.name || t?.code || "").trim();
    const sep = raw.indexOf(":");
    if (sep === -1) return { primary: raw, secondary: "" };
    return {
        primary: raw.slice(0, sep).trim(),
        secondary: raw.slice(sep + 1).trim(),
    };
});

const selectedTypeCode = computed(() => {
    const t = (types.value || []).find(
        (x) => Number(x.id) === Number(selectedTypeId.value),
    );
    return String(t?.code || "").trim();
});

// Modal subtitle: bare type name (no code duplication).
const selectedTypeShortName = computed(() => {
    const t = (types.value || []).find(
        (x) => Number(x.id) === Number(selectedTypeId.value),
    );
    return t ? t.name : "";
});

const activeDefStatusLabel = computed(() => {
    const d = activeDef.value;
    if (!d) return "";
    if (d.status === "draft") return "Draft";
    return isLiveDef(d) ? "Current version" : "Previous";
});

const activeDefStatusKind = computed(() => {
    const d = activeDef.value;
    if (!d) return "";
    if (d.status === "draft") return "is-draft";
    return isLiveDef(d) ? "is-live" : "is-prev";
});

const typePickerOptions = computed(() =>
    (types.value || []).map((t) => ({
        id: Number(t.id),
        label: `${t.name} (${t.code})`,
    })),
);

function onPickType(id) {
    const nid = Number(id);
    if (!nid || Number.isNaN(nid)) return;
    router.replace({ path: "/admin/workflows", query: { type: nid } });
}

const stepOptions = computed(() =>
    flatStepRows.value.map((s) => ({
        id: s.id,
        label: `${s._num}. ${s.name} `,
    })),
);

// Route dialog: From and To can never be the same step — each dropdown
// hides the other's selection. Since routes are forward-only, the To
// dropdown additionally hides every step ordered before the From step
// (equal-order steps stay selectable, matching the backend rule).
const fromStepOptions = computed(() =>
    stepOptions.value.filter(
        (o) => String(o.id) !== String(routeForm.value.to_step_id),
    ),
);
const toStepOptions = computed(() => {
    const fromKey = String(routeForm.value.from_step_id ?? "");
    const toKey = String(routeForm.value.to_step_id ?? "");
    const fromOrder =
        fromKey !== "" ? stepOrderOf(routeForm.value.from_step_id) : NaN;
    return stepOptions.value.filter((o) => {
        if (String(o.id) === fromKey) return false;
        // Keep the current pick in the list so v-select can resolve its
        // label; without it the selected value renders as a raw id number.
        if (String(o.id) === toKey) return true;
        if (!Number.isNaN(fromOrder)) {
            const order = stepOrderOf(o.id);
            if (!Number.isNaN(order) && order < fromOrder) return false;
        }
        return true;
    });
});

function stepOrderOf(id) {
    return Number(
        (activeDef.value?.steps || tableSteps.value || []).find(
            (s) => String(s.id) === String(id),
        )?.order_number ?? NaN,
    );
}

// Client-side mirror of the backend route guards (forward-only, no
// self-loops, no duplicate From → To). The API re-validates everything.
function routeClientError() {
    const from = routeForm.value.from_step_id;
    const to = routeForm.value.to_step_id;
    if (from == null || from === "" || to == null || to === "")
        return "Select both From Step and To Step.";
    if (String(from) === String(to))
        return "From and To cannot be the same step.";
    const fromOrder = stepOrderOf(from);
    const toOrder = stepOrderOf(to);
    if (Number.isNaN(fromOrder) || Number.isNaN(toOrder))
        return "Both steps must belong to this workflow.";
    if (toOrder < fromOrder)
        return `Routes must move forward: Step ${fromOrder} → Step ${toOrder} is not allowed.`;
    const clash = (activeDef.value?.routes || tableRoutes.value || []).find(
        (r) =>
            String(r.from_step_id) === String(from) &&
            String(r.to_step_id) === String(to) &&
            String(r.id) !== String(routeForm.value.id) &&
            String(r.client_id ?? r.id) !==
                String(routeForm.value.client_id ?? routeForm.value.id),
    );
    if (clash)
        return "This route already exists (same From → To), regardless of action.";
    return "";
}

// Hierarchy: flat step rows → depth-first tree → flat display rows
// with dotted numbers (1, 1.1, 1.2, 2…). Editable afterwards.
const flatStepRows = computed(() => {
    const list = tableSteps.value || [];
    const byId = new Map(list.map((s) => [s.id, s]));
    const byParent = new Map();
    for (const s of list) {
        const key = s.parent_id ?? 0;
        if (!byParent.has(key)) byParent.set(key, []);
        byParent.get(key).push(s);
    }
    for (const arr of byParent.values()) {
        arr.sort(
            (a, b) =>
                (Number(a.order_number) || 0) - (Number(b.order_number) || 0),
        );
    }
    const out = [];
    const walk = (parentKey, depth, prefix) => {
        for (const s of byParent.get(parentKey) || []) {
            const num = prefix
                ? `${prefix}.${s.order_number}`
                : `${s.order_number}`;
            out.push({
                ...s,
                _depth: depth,
                _num: num,
                parent_name: s.parent_id
                    ? (byId.get(s.parent_id)?.name ?? null)
                    : null,
            });
            walk(s.id, depth + 1, num);
        }
    };
    walk(0, 0, "");
    for (const s of list) {
        if (
            s.parent_id &&
            !byId.has(s.parent_id) &&
            !out.some((r) => r.id === s.id)
        ) {
            out.push({
                ...s,
                _depth: 0,
                _num: `${s.order_number}`,
                parent_name: null,
            });
        }
    }
    return out;
});

function descendantsOfStep(id) {
    const ids = new Set([id]);
    let grew = true;
    while (grew) {
        grew = false;
        for (const s of tableSteps.value || []) {
            if (s.parent_id && ids.has(s.parent_id) && !ids.has(s.id)) {
                ids.add(s.id);
                grew = true;
            }
        }
    }
    return ids;
}

// Routes table: forward-only, ordered start→end by station order.
// Reads the working copy (tableRoutes / tableSteps, which fall back to the
// loaded definition before seeding) so staged route edits show at once.
const sortedRoutes = computed(() => {
    const orderOf = (id) =>
        Number(
            (tableSteps.value || []).find(
                (s) => String(s.id) === String(id),
            )?.order_number ?? 9999,
        );
    return [...(tableRoutes.value || [])].sort(
        (a, b) => {
            return (
                orderOf(a.from_step_id) - orderOf(b.from_step_id) ||
                orderOf(a.to_step_id) - orderOf(b.to_step_id)
            );
        },
    );
});

// Fixed page size (7) keeps both tables on the same pagination rhythm.
const STEP_PAGE_SIZE = 7;
const ROUTE_PAGE_SIZE = 7;
const stepPage = ref(1);
const routePage = ref(1);
// True while the selected type's definitions resolve (cold or warm cache).
// Skeletons key off this — not just `loading` — so cached instant-paint
// never flashes the wrong "no workflow" state while a type switch settles.
const resolvingSteps = ref(false);

// Keep the current page valid when rows are added/removed.
watch([flatStepRows, sortedRoutes], () => {
    const maxStep = Math.max(
        1,
        Math.ceil(flatStepRows.value.length / STEP_PAGE_SIZE),
    );
    if (stepPage.value > maxStep) stepPage.value = maxStep;
    const maxRoute = Math.max(
        1,
        Math.ceil(sortedRoutes.value.length / ROUTE_PAGE_SIZE),
    );
    if (routePage.value > maxRoute) routePage.value = maxRoute;
});

// Route endpoints as names: id → "1 · Create PR" (dotted for sub-steps).
// Missing step (deleted) announces itself instead of rendering blank.
// String comparison: staged tmp rows carry string ids (never NaN-matched).
function stepLabel(id) {
    const s = flatStepRows.value.find((x) => String(x.id) === String(id));
    if (!s) return { text: `#${id} (deleted)`, deleted: true };
    return { text: `${s._num} · ${s.name}`, deleted: false };
}

// Parent picker: every step except self + own sub-steps (would cycle).
const parentStepOptions = computed(() => {
    const banned = stepForm.value.id
        ? descendantsOfStep(stepForm.value.id)
        : new Set();
    return flatStepRows.value
        .filter((s) => !banned.has(s.id))
        .map((s) => ({ id: s.id, label: `${s._num}. ${s.name}` }));
});

// The design's picker offers an explicit top-level row instead of relying on
// an empty selection (clearing still maps to `null`).
const parentStepItems = computed(() => [
    { id: null, label: "None (top level)" },
    ...parentStepOptions.value,
]);

const stepHeaders = [
    { title: "#", key: "order_number", width: "4%" },
    { title: "Name", key: "name", width: "22%" },
    { title: "Stage", key: "stage", width: "10%" },
    { title: "SLA", key: "sla_minutes", width: "4.5%" },
    {
        title: "Assigned office",
        key: "office_id",
        sortable: false,
        width: "15%",
    },
    { title: "End user", key: "is_end_user", sortable: false, width: "8%" },
    { title: "Roles", key: "role_ids", sortable: false, width: "9.5%" },
    { title: "Flags", key: "flags", sortable: false, width: "8%" },
    { title: "", key: "actions", sortable: false, width: "19%", align: "end" },
];

const routeHeaders = [
    { title: "From", key: "from_step_id", width: "23%" },
    { title: "To", key: "to_step_id", width: "23%" },
    { title: "Action", key: "action_code", width: "9%" },
    { title: "Group", key: "route_group", width: "8%" },
    { title: "Approvals", key: "required_approvals_count", width: "9%" },
    {
        title: "Condition",
        key: "condition_expression",
        sortable: false,
        width: "18%",
    },
    { title: "", key: "actions", sortable: false, width: "10%", align: "end" },
];

function pretty(obj) {
    if (!obj) return "";
    try {
        return JSON.stringify(obj);
    } catch {
        return String(obj);
    }
}

watch(selectedTypeId, async (id) => {
    // Clear first so the previous type's tables never linger while the new
    // type loads (the skeleton state keeps the container size stable).
    activeDef.value = null;
    stagingSourceDefId.value = null;
    stepPage.value = 1;
    routePage.value = 1;
    wfTab.value = 0;
    if (!id) {
        return;
    }
    error.value = "";
    // Always veil while resolving: activeDef is cleared above and only
    // restored after the network settles, so skipping this on warm cache
    // exposes the wrong "no workflow" state for the whole request.
    resolvingSteps.value = true;
    try {
        await fetchDefinitions(id);
        selectEffective();
        seedFromActiveDef();
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to load transaction types.";
        activeDef.value = null;
    } finally {
        resolvingSteps.value = false;
    }
});

// Latest = live. Effective editor target: the open draft if any,
// otherwise the latest published. Everything older is history.
const draftDef = computed(
    () => (defs.value || []).find((d) => d.status === "draft") || null,
);

const publishedDefs = computed(() =>
    (defs.value || []).filter((d) => d.status === "published"),
);

// Live-flagged version wins; fallback to the highest published version
// for rows predating the backfill.
const currentDef = computed(
    () =>
        (defs.value || []).find((d) => d.is_live) ||
        publishedDefs.value[0] ||
        null,
);

function fmtLiveDate(iso) {
    if (!iso) return "N/A";
    return new Date(iso).toLocaleDateString("en-PH", {
        timeZone: "Asia/Manila",
        month: "short",
        day: "numeric",
        year: "numeric",
    });
}

const liveDialog = ref(false);
const liveTarget = ref(null);

function askMakeLive(d) {
    error.value = "";
    notice.value = "";
    liveTarget.value = d;
    liveDialog.value = true;
}

// Publish the open draft (saved, no staged edits). A draft that still has
// staged edits must be saved as a new live version instead, so the staged
// rows and the publish happen atomically.
async function publishDraft(d) {
    if (!d || d.status !== "draft") return;
    error.value = "";
    notice.value = "";
    if (stagingDirty.value && Number(activeDef.value?.id) === Number(d.id)) {
        notice.value =
            "You have staged edits. Use Save version and choose 'Create new version' to publish them.";
        return;
    }
    const ok = await confirm({
        title: "Publish this draft?",
        message: `Publish v${d.version} as the live version? New transactions will use it; running transactions stay on their current version.`,
        confirmLabel: "Publish",
        tone: "success",
    });
    if (!ok) return;
    saving.value = true;
    try {
        await publish(d.id, {});
        await fetchDefinitions(selectedTypeId.value);
        selectEffective();
        notice.value = `v${d.version} published - new transactions will use it.`;
    } catch (e) {
        error.value = e?.response?.data?.message || "Publishing failed.";
    } finally {
        saving.value = false;
    }
}

async function confirmMakeLive() {
    if (!liveTarget.value) return;
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await makeLive(liveTarget.value.id);
        liveDialog.value = false;
        liveTarget.value = null;
        await fetchDefinitions(selectedTypeId.value);
        selectEffective();
        notice.value =
            "Live version switched — new transactions use it. Old versions kept.";
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Switching live version failed.";
        liveDialog.value = false;
    } finally {
        saving.value = false;
    }
}

function isLiveDef(def) {
    return (
        !!def &&
        def.status === "published" &&
        currentDef.value &&
        Number(currentDef.value.id) === Number(def.id)
    );
}

const historyDefs = computed(() =>
    (defs.value || []).filter(
        (d) => !activeDef.value || Number(d.id) !== Number(activeDef.value.id),
    ),
);

function selectEffective() {
    activeDef.value =
        draftDef.value || currentDef.value || defs.value[0] || null;
}

// Staged editing: dialogs mutate the working copy only. Nothing reaches
// the network until Save version (bulk apply). No draft is created, no
// publish attempted — the viewed/working rows ARE the edit target.
function workingRouteFor(route) {
    if (!route) return route;
    const rows = tableRoutes.value || [];
    const byId = rows.find((r) => String(r.id) === String(route.id));
    if (byId) return byId;
    const stepsOf = (id) =>
        (tableSteps.value || []).find((s) => String(s.id) === String(id))?.code;
    const from = stepsOf(route.from_step_id);
    const to = stepsOf(route.to_step_id);
    return (
        rows.find((r) => {
            const rf = (tableSteps.value || []).find(
                (s) => String(s.id) === String(r.from_step_id),
            )?.code;
            const rt = (tableSteps.value || []).find(
                (s) => String(s.id) === String(r.to_step_id),
            )?.code;
            return (
                rf === from && rt === to && r.action_code === route.action_code
            );
        }) || route
    );
}

async function viewDef(def) {
    if (!def) return;
    const t = selectedTypeId.value;
    // Tables render the working copy; viewing history while staged would
    // show one version and edit another — confirm first (staging survives
    // a "view anyway", reseed only happens when clean).
    if (t && staging.isDirty(t)) {
        const viewAnyway = await confirm({
            title: "View this version?",
            message:
                "You have unsaved staged changes. View this version anyway? Your staged edits stay until you Save or Discard.",
            confirmLabel: "View anyway",
            cancelLabel: "Stay",
        });
        if (!viewAnyway) return;
    }
    selectEffective();
    return activeDef.value;
}

// Publish the working draft. A flow missing start/end stays a draft
// with a plain message instead of an error (mid-construction state).
async function goLive() {
    await fetchDefinitions(selectedTypeId.value);
    selectEffective();
    try {
        await publish(activeDef.value.id, {});
        await fetchDefinitions(selectedTypeId.value);
        selectEffective();
        notice.value = "Saved — live for new transactions.";
    } catch (e) {
        const msg = e?.response?.data?.message || "";
        if (e?.response?.status === 422 && /start step|end step/i.test(msg)) {
            notice.value =
                "Saved as draft — add a start and an end step to go live.";
        } else {
            throw e;
        }
    }
}

// Add Step: staged into the working copy only — the draft is created (or
// reused) server-side by apply-staged when you press Save version.
async function clickAddStep() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        openStepDialog();
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function clickAddRoute() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        openRouteDialog();
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

function stepInDraft(oldSteps, item) {
    // Clones preserve codes (unique per flow): map the viewed step to
    // its draft twin so edits always land on the draft.
    const code =
        (oldSteps || []).find((s) => Number(s.id) === Number(item?.id))?.code ||
        item?.code;
    return (
        (activeDef.value?.steps || []).find((s) => code && s.code === code) ||
        item
    );
}

async function editStep(item) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        // Reopen the working copy's row when there is one, so staged edits
        // (roles, office, ...) show again instead of the last saved values.
        const key = String(item?.client_id ?? item?.id);
        const staged = (stagingBucket.value?.steps || []).find((s) => String(s.client_id ?? s.id) === key);
        const oldSteps = activeDef.value?.steps || [];
        openStepDialog(staged || stepInDraft(oldSteps, item));
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function goStepFields(item) {
    error.value = "";
    notice.value = "";
    try {
        const oldSteps = activeDef.value?.steps || [];
        const fresh = stepInDraft(oldSteps, item);
        const q = selectedTypeId.value
            ? { type: Number(selectedTypeId.value) }
            : {};
        router.push({
            path: `/admin/workflows/${activeDef.value.id}/steps/${fresh.id}/fields`,
            query: q,
        });
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to open step fields.";
    }
}

function liveEditableTarget() {
    // Requirements/step data apply to running papers immediately, so
    // open them on the published transaction type — not an open draft clone.
    return currentDef.value || activeDef.value;
}

function stepOnDef(def, item) {
    return (
        (def?.steps || []).find((s) => s.code && s.code === item?.code) || item
    );
}

async function goStepRequirements(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value
            ? { type: Number(selectedTypeId.value) }
            : {};
        router.push({
            path: `/admin/workflows/${target.id}/steps/${fresh.id}/requirements`,
            query: q,
        });
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to open step requirements.";
    }
}

async function goStepData(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value
            ? { type: Number(selectedTypeId.value) }
            : {};
        router.push({
            path: `/admin/workflows/${target.id}/steps/${fresh.id}/step-data`,
            query: q,
        });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step data.";
    }
}

function routeInDraft(oldSteps, route) {
    // Routes have no codes: match by endpoint step codes + action.
    const oldCode = (id) =>
        (oldSteps || []).find((s) => Number(s.id) === Number(id))?.code;
    const newCode = (id) =>
        (activeDef.value?.steps || []).find((s) => Number(s.id) === Number(id))
            ?.code;
    const from = oldCode(route?.from_step_id);
    const to = oldCode(route?.to_step_id);
    return (
        (activeDef.value?.routes || []).find(
            (r) =>
                newCode(r.from_step_id) === from &&
                newCode(r.to_step_id) === to &&
                r.action_code === route?.action_code,
        ) || route
    );
}

async function editRoute(route) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        // Reopen the working copy's row when there is one, so staged edits
        // show again instead of the last saved values.
        const key = String(route?.client_id ?? route?.id);
        const staged = (stagingBucket.value?.routes || []).find((r) => String(r.client_id ?? r.id) === key);
        const oldSteps = activeDef.value?.steps || [];
        openRouteDialog(staged || routeInDraft(oldSteps, route));
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

// Save version: overwrite the open draft in place, or persist the staged
// content as a brand-new live version. Old versions are always kept.
const saveDialog = ref(false);
const saveName = ref("");
const saveNotes = ref("");
// Overwrite = persist staged edits onto the open draft. Editing the live
// version publishes automatically (new version, old kept); editing a draft
// keeps it a draft. Create new = persist + publish as a new live version.
const saveMode = ref("overwrite");
// Dialog-scoped feedback so save errors are visible inside the modal
// instead of on the page banner behind it.
const saveError = ref("");

// The chips show what this save changes, compared with the seeded source
// snapshots. Requirements includes both definition edits and step bindings.
const stagedChangeDetails = computed(() =>
    staging.changedDetails(selectedTypeId.value),
);
const stagedCounts = computed(() => {
    const details = stagedChangeDetails.value;
    return [
        {
            key: "steps",
            label: "Steps",
            count: details.steps.length,
            items: details.steps,
        },
        {
            key: "routes",
            label: "Routes",
            count: details.routes.length,
            items: details.routes,
        },
        {
            key: "requirements",
            label: "Requirements",
            count: details.requirements.length,
            items: details.requirements,
        },
        {
            key: "checklists",
            label: "Checklists",
            count: details.checklists.length,
            items: details.checklists,
        },
        {
            key: "fields",
            label: "Field assignments",
            count: details.fields.length,
            items: details.fields,
        },
    ];
});
const stagedChangeTotal = computed(() =>
    stagedCounts.value.reduce((total, chip) => total + chip.count, 0),
);

function changeKindLabel(kind) {
    return kind === "added"
        ? "Added"
        : kind === "removed"
          ? "Removed"
          : "Updated";
}

function truncateChangeValue(text, max = 64) {
    const value = String(text);
    return value.length > max ? `${value.slice(0, max - 1)}…` : value;
}

function detailStepName(id) {
    if (id == null || id === "") return "None";
    const rows = [
        ...(tableSteps.value || []),
        ...(activeDef.value?.steps || []),
    ];
    const found = rows.find(
        (step) =>
            String(step.id) === String(id) ||
            (step.client_id != null && String(step.client_id) === String(id)),
    );
    return found?.name || `#${id}`;
}

const stagedReqNameById = computed(() => {
    const map = new Map();
    const bucket = stagingBucket.value;
    for (const def of [
        ...(bucket?.sourceReqDefs || []),
        ...(bucket?.reqDefs || []),
    ]) {
        const label = def?.name || def?.code;
        if (!label) continue;
        if (def?.id != null) map.set(String(def.id), label);
        if (def?.client_id != null) map.set(String(def.client_id), label);
    }
    // Bindings and checklist rows carry their requirement name too, which
    // keeps old → new labels readable even when the catalog was not loaded.
    const linkedRows = [
        ...Object.values(bucket?.sourceBindings || {}),
        ...Object.values(bucket?.bindings || {}),
        ...Object.values(bucket?.sourceChecklist || {}),
        ...Object.values(bucket?.checklist || {}),
    ].flat();
    for (const row of linkedRows) {
        const key =
            row?.requirement_definition_id ??
            row?.req_key ??
            row?.requirement_key;
        const label = row?.name || row?.code;
        if (key == null || !label || map.has(String(key))) continue;
        map.set(String(key), label);
    }
    return map;
});

function formatChangeValue(change, value) {
    if (change.field === "required_override") {
        return value === true
            ? "Required"
            : value === false
              ? "Optional"
              : "Default";
    }
    if (value == null || value === "") return "None";
    switch (change.field) {
        case "office":
            return (
                officeNameById.value.get(Number(value)) || `Office #${value}`
            );
        case "roles": {
            const ids = Array.isArray(value) ? value : [];
            if (!ids.length) return "None";
            return ids
                .map((id) => roleNameById.value.get(Number(id)) || `#${id}`)
                .join(", ");
        }
        case "parent":
        case "from":
        case "to":
            return detailStepName(value);
        case "requirement":
            return (
                stagedReqNameById.value.get(String(value)) ||
                `Requirement #${value}`
            );
        case "is_start":
        case "is_end":
        case "is_return_route":
        case "is_required":
        case "is_upload_required":
        case "is_active":
            return value ? "Yes" : "No";
        case "sla_minutes":
            return `${value} min`;
        case "condition_expression":
            return truncateChangeValue(value, 52);
        default:
            return truncateChangeValue(value, 64);
    }
}

function changeValueTitle(change, value) {
    if (change.field === "required_override")
        return formatChangeValue(change, value);
    if (value == null || value === "") return "None";
    if (
        [
            "condition_expression",
            "description",
            "name",
            "label",
            "code",
            "route_group",
            "stage",
        ].includes(change.field)
    ) {
        return String(value);
    }
    return formatChangeValue(change, value);
}

const saveSubmitLabel = computed(() => {
    if (saveMode.value === "create-new") {
        return activeDef.value ? "Publish new version" : "Publish version 1";
    }
    if (isLiveDef(activeDef.value)) return "Save & publish";
    return activeDef.value ? "Save draft" : "Create draft";
});

function openSaveDialog() {
    const def = activeDef.value;
    // A clean draft can still be published as a new version; only block when
    // there is neither an existing version nor anything staged.
    if (!stagingDirty.value && !def) {
        notice.value =
            "Nothing staged — no changes to save yet. Edit steps, routes, requirements, checklists, or fields first.";
        return;
    }
    error.value = "";
    notice.value = "";
    saveError.value = "";
    saveMode.value = "overwrite";
    saveName.value = def?.name ?? selectedTypeShortName.value ?? "";
    saveNotes.value = "";
    saveDialog.value = true;
}

async function confirmSave() {
    const typeId = selectedTypeId.value;
    if (!typeId) return;
    let defId = stagingSourceDefId.value;
    const name = saveName.value.trim();
    if (saveMode.value === "create-new" && !name) {
        saveError.value = "Give the new version a name first.";
        return;
    }
    saveError.value = "";
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        // First save for a type with no version: mint the empty draft shell,
        // then apply the staged content against it. createDraft is idempotent
        // (one-draft-max), so a retry after a failed apply is safe.
        if (!defId) {
            const created = await createDraft({
                transaction_type_id: Number(typeId),
                clone_latest_published: true,
            });
            defId = created?.id ?? null;
            if (!defId)
                throw new Error("Could not create the first workflow version.");
            stagingSourceDefId.value = defId;
        }
        const { data: saved, meta } = await staging.saveAll(typeId, defId, {
            mode: saveMode.value,
            name: saveMode.value === "create-new" ? name : name || undefined,
            notes: saveNotes.value.trim() || undefined,
        });
        saveDialog.value = false;
        await fetchDefinitions(typeId);
        selectEffective();
        seedFromActiveDef();
        if (meta?.published) {
            notice.value = `Saved as v${saved.version} "${saved.name}" — now live. Old versions kept.`;
        } else if (meta?.message) {
            notice.value = meta.message;
        } else {
            notice.value =
                "Saved to the open draft — not live yet. Press Publish (or save as a new version) when ready.";
        }
    } catch (e) {
        saveError.value =
            e?.response?.data?.message ||
            e?.response?.data?.errors?.name?.[0] ||
            (e?.response?.status === 409
                ? "Someone saved while you were editing. Reload to get the latest, then re-apply your changes."
                : "Saving the staged changes failed.");
    } finally {
        saving.value = false;
    }
}

// Steps
const stepDialog = ref(false);
const stepForm = ref({});
// Bridge the explicit dropdown row to the stored null / office-id value.
const stepOffice = computed({
    get: () =>
        stepForm.value.office_id == null
            ? USER_OFFICE
            : stepForm.value.office_id,
    set: (value) => {
        stepForm.value.office_id = value === USER_OFFICE ? null : value;
    },
});
// Dialog-scoped feedback: field problems render under their inputs, anything
// else (staged-save guards) shows at the top of the dialog body instead of
// the page banner behind it.
const stepError = ref("");
const stepErrors = ref({});

function clearStepError(key) {
    if (!stepErrors.value[key]) return;
    const next = { ...stepErrors.value };
    delete next[key];
    stepErrors.value = next;
}

function isRoleOn(id) {
    return (stepForm.value.role_ids || []).map(Number).includes(Number(id));
}

function toggleRole(id) {
    const cur = (stepForm.value.role_ids || []).map(Number);
    const n = Number(id);
    stepForm.value.role_ids = cur.includes(n)
        ? cur.filter((x) => x !== n)
        : [...cur, n];
}

function roleIdsWithEndUser(roleIds, isEndUser) {
    const next = (roleIds || []).map(Number);
    const endUserRoleId = Number(
        (roles.value || []).find((r) => r.code === "end_user")?.id,
    );
    if (!endUserRoleId) return next;
    const at = next.indexOf(endUserRoleId);
    if (isEndUser && at === -1) next.push(endUserRoleId);
    if (!isEndUser && at !== -1) next.splice(at, 1);
    return next;
}

function toggleEndUser(item, value) {
    if (!selectedTypeId.value) return;
    if (!stagingBucket.value || stagingBucket.value.sourceDefId == null)
        seedFromActiveDef();
    error.value = "";
    const staged = staging.upsertStep(selectedTypeId.value, {
        id: item.id,
        is_end_user: !!value,
        role_ids: roleIdsWithEndUser(
            item.role_ids ?? item.roles?.map?.((r) => r.id),
            value,
        ),
    });
    if (!staged.changed) {
        notice.value = "Toggle reverted — this step matches the saved version.";
        return;
    }
    notice.value = value
        ? "End user station staged — press Save version to persist it."
        : "End user toggle staged off — press Save version to persist it.";
}

// SLA duration: total minutes stay the single value sent to the backend.
// The shared input handles the mockup's presets and custom day/hour/minute
// fields; this page keeps the strict 30-day total cap.
const SLA_MAX_DAYS = 30;
const SLA_MAX_TOTAL = SLA_MAX_DAYS * 24 * 60; // 43200
const slaMinutes = ref(60);
// Bumping the key remounts the input so preset/custom state is rebuilt from
// the step being opened instead of leaking from the previous edit.
const slaInputKey = ref(0);

const slaOverLimit = computed(
    () => Number(slaMinutes.value || 0) > SLA_MAX_TOTAL,
);

function minutesToSla(total) {
    const t = Math.max(0, Number(total || 0));
    const days = Math.floor(t / 1440);
    const rest = t - days * 1440;
    const h = String(Math.floor(rest / 60)).padStart(2, "0");
    const min = String(rest % 60).padStart(2, "0");
    return { days, time: `${h}:${min}` };
}

function formatSlaMinutes(total) {
    const { days, time } = minutesToSla(total);
    const [h, m] = time.split(":").map(Number);
    const parts = [];
    if (days) parts.push(`${days}d`);
    if (h) parts.push(`${h}h`);
    if (m) parts.push(`${m}m`);
    return parts.length ? parts.join(" ") : "0m";
}

function openStepDialog(step = null) {
    error.value = "";
    stepError.value = "";
    stepErrors.value = {};
    const storedSla = Number(step?.sla_minutes ?? 60);
    slaMinutes.value = Number.isFinite(storedSla)
        ? Math.max(0, Math.trunc(storedSla))
        : 60;
    slaInputKey.value += 1;
    if (step) {
        stepForm.value = {
            id: step.id,
            client_id: step.client_id ?? null,
            code: step.code ?? null,
            order_number: step.order_number,
            parent_id: step.parent_id ?? null,
            name: step.name,
            stage: step.stage ?? "",
            office_id: step.office_id ?? null,
            is_start: !!step.is_start,
            is_end: !!step.is_end,
            is_end_user: !!step.is_end_user,
            role_ids: selectableStepRoleIds(
                step.role_ids ?? step.roles?.map?.((r) => r.id) ?? [],
            ),
        };
    } else {
        const topLevel = (tableSteps.value || []).filter((s) => !s.parent_id);
        stepForm.value = {
            id: null,
            order_number: (topLevel.length || 0) + 1,
            parent_id: null,
            name: "",
            stage: "",
            office_id: null,
            is_start: false,
            is_end: false,
            is_end_user: false,
            // Clerk is the universal staff role (any step, limited by the
            // step's office), so new steps start with it ticked.
            role_ids: (roles.value || []).filter((r) => r.code === "clerk").map((r) => Number(r.id)),
        };
    }
    stepDialog.value = true;
}

function saveStep() {
    // Staged: no network, no draft creation, no publish. The row lands in
    // the working copy (new rows get a tmp id) until Save version.
    error.value = "";
    notice.value = "";
    stepError.value = "";
    stepErrors.value = {};
    if (!selectedTypeId.value) {
        stepError.value = "Pick a transaction type first.";
        return;
    }
    const name = String(stepForm.value.name || "").trim();
    const order = Number(stepForm.value.order_number);
    const errs = {};
    if (!name) errs.name = "Enter a step name.";
    if (!Number.isFinite(order) || order < 1)
        errs.order_number = "Order must be 1 or higher.";
    if (Object.keys(errs).length) {
        stepErrors.value = errs;
        return;
    }
    if (slaOverLimit.value) return;
    const staged = staging.upsertStep(selectedTypeId.value, {
        id: stepForm.value.id ?? undefined,
        client_id: stepForm.value.client_id ?? undefined,
        code: stepForm.value.code ?? null,
        parent_id: stepForm.value.parent_id ?? null,
        order_number: order,
        name,
        stage: stepForm.value.stage || null,
        office_id: stepForm.value.office_id ?? null,
        sla_minutes: slaMinutes.value,
        is_start: !!stepForm.value.is_start,
        is_end: !!stepForm.value.is_end,
        is_end_user: !!stepForm.value.is_end_user,
        role_ids: selectableStepRoleIds(stepForm.value.role_ids),
    });
    stepDialog.value = false;
    if (staged.changed) {
        notice.value = activeDef.value
            ? "Step staged — press Save version to persist it."
            : "Step staged — press Save version to create version 1 and persist it.";
    }
}

function deleteStep(step) {
    // Staged removal (undo via Discard). Occupancy guards run at Save time.
    error.value = "";
    notice.value = "";
    if (!selectedTypeId.value) return;
    staging.removeStep(selectedTypeId.value, step?.id ?? step?.client_id);
    notice.value = "Step removal staged — press Save version to persist it.";
}

// Routes
const routeDialog = ref(false);
const versionDialog = ref(false);
const routeForm = ref({});
// Dialog-scoped error: route guard/API failures show inside the modal,
// not on the page above the steps table.
const routeError = ref("");

// Route action (design mockup): preset pills plus a validated "Other" code.
// Editing a route whose stored code is not a preset opens on Other with the
// code prefilled, so nothing is silently rewritten on save.
const ROUTE_ACTION_KEYS = ["submit", "approve", "reject"];
const routeActionPills = [
    { key: "submit", label: "Submit" },
    { key: "approve", label: "Approve" },
    { key: "reject", label: "Reject", rej: true },
    { key: "__other", label: "Other" },
];
const routeActionHelp = {
    submit: "Sent when the user submits this step.",
    approve: "Sent when an approver approves this step.",
    reject: "Sent when an approver rejects this step.",
    __other: "Use a lowercase code, such as escalate.",
};
const CUSTOM_ACTION_RE = /^[a-z][a-z0-9_]*$/;
const CONDITION_EXAMPLE = '{">=":[{"var":"fields.amount"},50000]}';
const routeAction = ref("submit");
const routeCustomCode = ref("");
const routeAdvanced = ref(false);
// Field-level messages render under their inputs (mockup style); cross-field
// guard failures land in `routeError` under the From → To row.
const routeFieldErrors = ref({});
const routeCustomInput = ref(null);
const routeToast = ref(null);

const routeJsonState = computed(() => {
    const v = String(routeForm.value.condition_expression_json || "").trim();
    if (!v) {
        return {
            cls: "n",
            text: "Stored as JSON. Leave empty if the route always applies.",
        };
    }
    try {
        JSON.parse(v);
        return { cls: "ok", text: "Valid JSON" };
    } catch (e) {
        return {
            cls: "no",
            text:
                "Invalid JSON: " +
                String(e?.message || "").replace(/^JSON\.parse: /, ""),
        };
    }
});

function onRouteFieldChange() {
    routeError.value = "";
    routeFieldErrors.value = {
        from_step_id: "",
        to_step_id: "",
        action_code: "",
    };
}

function setRouteAction(key) {
    routeAction.value = key;
    routeFieldErrors.value = { ...routeFieldErrors.value, action_code: "" };
    if (key === "__other") nextTick(() => routeCustomInput.value?.focus?.());
}

function insertConditionExample() {
    routeForm.value.condition_expression_json = CONDITION_EXAMPLE;
}

function openRouteDialog(route = null) {
    error.value = "";
    routeError.value = "";
    routeFieldErrors.value = {
        from_step_id: "",
        to_step_id: "",
        action_code: "",
    };
    routeAdvanced.value = false;
    if (route) {
        routeForm.value = {
            id: route.id,
            client_id: route.client_id ?? null,
            from_step_id: route.from_step_id,
            to_step_id: route.to_step_id,
            action_code: route.action_code,
            route_group: route.route_group ?? "",
            required_approvals_count: route.required_approvals_count ?? "",
            condition_expression_json: route.condition_expression
                ? JSON.stringify(route.condition_expression, null, 2)
                : "",
        };
        // Preset codes select their pill; anything else opens on Other with
        // the stored code prefilled (never silently rewritten).
        if (ROUTE_ACTION_KEYS.includes(route.action_code)) {
            routeAction.value = route.action_code;
            routeCustomCode.value = "";
        } else {
            routeAction.value = "__other";
            routeCustomCode.value = route.action_code || "";
        }
        // Surface advanced content on open when the route already has any.
        routeAdvanced.value = !!(
            route.route_group ||
            route.required_approvals_count ||
            route.condition_expression
        );
    } else {
        routeForm.value = {
            id: null,
            from_step_id: null,
            to_step_id: null,
            action_code: "submit",
            route_group: "",
            required_approvals_count: "",
            condition_expression_json: "",
        };
        routeAction.value = "submit";
        routeCustomCode.value = "";
    }
    routeDialog.value = true;
}

function saveRoute() {
    // Staged: no network, no draft creation, no publish.
    error.value = "";
    routeError.value = "";
    notice.value = "";
    routeFieldErrors.value = {
        from_step_id: "",
        to_step_id: "",
        action_code: "",
    };
    if (!selectedTypeId.value) {
        error.value = "Pick a transaction type first.";
        return;
    }

    // Resolve the action code from the pills (custom "Other" validates).
    const code =
        routeAction.value === "__other"
            ? routeCustomCode.value.trim()
            : routeAction.value;

    // Field-level guards first (design shows them under the inputs).
    const errs = {};
    if (
        routeForm.value.from_step_id == null ||
        routeForm.value.from_step_id === ""
    )
        errs.from_step_id = "Choose a starting step.";
    if (routeForm.value.to_step_id == null || routeForm.value.to_step_id === "")
        errs.to_step_id = "Choose a destination step.";
    if (!code) errs.action_code = "Enter a custom action code.";
    else if (routeAction.value === "__other" && !CUSTOM_ACTION_RE.test(code))
        errs.action_code = "Use a lowercase code, such as escalate.";
    if (Object.keys(errs).length) {
        routeFieldErrors.value = errs;
        return;
    }

    // Cross-field guard (backend + staging service re-validate):
    // forward-only, no self-loops, no duplicate From → To.
    const guard = routeClientError();
    if (guard) {
        routeError.value = guard;
        return;
    }

    let cond = null;
    if (routeForm.value.condition_expression_json?.trim()) {
        try {
            cond = JSON.parse(routeForm.value.condition_expression_json);
        } catch {
            routeAdvanced.value = true;
            routeError.value = "Condition must be valid JSON.";
            return;
        }
    }

    const staged = staging.upsertRoute(selectedTypeId.value, {
        id: routeForm.value.id ?? undefined,
        client_id: routeForm.value.client_id ?? undefined,
        from_step_id: routeForm.value.from_step_id,
        to_step_id: routeForm.value.to_step_id,
        action_code: code,
        // Return routes are retired: routes are forward-only.
        is_return_route: false,
        route_group: routeForm.value.route_group || null,
        required_approvals_count: routeForm.value.required_approvals_count
            ? Number(routeForm.value.required_approvals_count)
            : null,
        condition_expression: cond,
    });
    routeDialog.value = false;
    if (staged.changed) {
        const msg = activeDef.value
            ? "Route staged — press Save version to persist it."
            : "Route staged — press Save version to create version 1 and persist it.";
        notice.value = msg;
        routeToast.value?.show(msg);
    }
}

function deleteRoute(route) {
    // Staged removal (undo via Discard).
    error.value = "";
    notice.value = "";
    if (!selectedTypeId.value) return;
    staging.removeRoute(selectedTypeId.value, route?.id ?? route?.client_id);
    notice.value = "Route removal staged — press Save version to persist it.";
}

function applyTypeFromQuery() {
    const deepType = Number(route.query.type);
    if (
        deepType &&
        (types.value || []).some((t) => Number(t.id) === deepType)
    ) {
        if (Number(selectedTypeId.value) !== deepType)
            selectedTypeId.value = deepType;
    } else {
        // Isolated per-type viewing: no type in the URL means nothing
        // selected. Reach this page via Transaction Types → Steps.
        selectedTypeId.value = null;
        loading.value = false;
    }
    queryResolved.value = true;
}

watch(
    () => route.query.type,
    () => applyTypeFromQuery(),
);

onMounted(async () => {
    // Lookups run in parallel (each paints cache first); the query-derived
    // selection applies once the batch settles.
    await Promise.allSettled([fetchTypes(), fetchRoles(), fetchOffices()]);
    applyTypeFromQuery();
});
</script>

<style scoped>
/* ==========================================================================
   Transaction Type Steps and Routes — page shell, tabs and data tables
   (visual port of the supplied "Transaction Type Steps and Routes" mockup)
   ========================================================================== */
.wf-page {
    --wf-ink: rgb(var(--v-theme-on-surface));
    --wf-muted: rgb(var(--v-theme-secondary));
    --wf-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --wf-field: #f4f6fb;
    --wf-hover: #f3f6fc;
    --wf-blue: #005EED;
    --wf-blue-bg: #e8eeff;
    --wf-ok: #1b7a3d;
    --wf-ok-bg: #e3f5ea;
    --wf-new-bg: #eaf5ff;
    --wf-new-accent: #1670b7;
    --wf-new-chip-bg: #cfe7fa;
    --wf-new-chip-ink: #124d7a;
    --wf-amber: #b86e00;
    --wf-amber-bg: #fff1d6;
    --wf-err: rgb(var(--v-theme-error));
    --wf-err-bg: rgba(var(--v-theme-error), 0.12);
    --wf-ring: rgba(29, 63, 174, 0.28);
    background: rgb(var(--v-theme-surface));
    border: 1px solid var(--wf-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}
html.dark .wf-page {
    --wf-field: #1c2645;
    --wf-hover: #1d2745;
    --wf-blue: #6f8cff;
    --wf-blue-bg: #25306a;
    --wf-ok: #3fbf6f;
    --wf-ok-bg: #16382a;
    --wf-new-bg: #182d40;
    --wf-new-accent: #6db8f0;
    --wf-new-chip-bg: #244966;
    --wf-new-chip-ink: #c8e7ff;
    --wf-amber: #ffbf47;
    --wf-amber-bg: #4a3510;
    --wf-err-bg: #4a1f22;
    --wf-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
.wf-page button:focus-visible,
.wf-page :deep(.v-btn:focus-visible) {
    outline: 3px solid var(--wf-ring);
    outline-offset: 2px;
}

/* ---- Header ---- */
.wf-hd {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 22px 28px;
    border-bottom: 3px solid var(--wf-blue);
    flex-wrap: wrap;
}
.wf-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--wf-blue);
    color: #fff;
}
.wf-hd-main {
    flex: 1 1 320px;
    min-width: 0;
}
.wf-title {
    margin: 0;
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
    color: var(--wf-ink);
}
.wf-sub {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    margin-top: 5px;
    font-size: 13.5px;
    font-weight: 500;
    color: var(--wf-muted);
}
.wf-sub b {
    color: var(--wf-ink);
    font-weight: 700;
}
.wf-sep {
    opacity: 0.5;
}
.wf-code {
    padding: 3px 8px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 12px;
}
.wf-tools {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin-left: auto;
}
.wf-ver {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    height: 42px;
    padding: 0 12px 0 14px;
    border: 1.5px solid var(--wf-line);
    background: rgb(var(--v-theme-surface));
    color: var(--wf-ink);
    font: inherit;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.15s;
}
.wf-ver:hover {
    background: var(--wf-hover);
}
.wf-ver-dot {
    display: block;
    width: 8px;
    height: 8px;
    flex: none;
    background: var(--wf-ok);
}
.wf-ver-dot.is-draft {
    background: var(--wf-amber);
}
.wf-ver-dot.is-prev {
    background: var(--wf-muted);
}
.wf-ver-chev {
    color: var(--wf-muted);
}
.wf-tool-btn,
.wf-save,
.wf-publish {
    height: 42px !important;
    padding: 0 16px !important;
    border-radius: 0 !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    letter-spacing: 0 !important;
    text-transform: none !important;
    box-shadow: none !important;
}
.wf-tool-btn {
    border: 1.5px solid var(--wf-line) !important;
    background: rgb(var(--v-theme-surface)) !important;
    color: var(--wf-ink) !important;
}
.wf-tool-btn:hover {
    background: var(--wf-hover) !important;
}
.wf-tool-danger {
    color: var(--wf-err) !important;
    border-color: var(--wf-err-bg) !important;
}
.wf-tool-danger:hover {
    background: var(--wf-err-bg) !important;
}
.wf-save {
    border: 1.5px solid transparent !important;
    background: var(--wf-blue) !important;
    color: #fff !important;
}
.wf-save.v-btn--disabled {
    background: var(--wf-field) !important;
    color: var(--wf-muted) !important;
}
.wf-publish {
    border: 1.5px solid transparent !important;
}
.wf-unsaved {
    display: inline-flex;
    margin-left: 8px;
    padding: 3px 7px;
    background: rgba(var(--v-theme-warning), 0.18);
    color: var(--wf-amber);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.04em;
}

/* ---- Alerts + type picker ---- */
.wf-body {
    padding: 0 !important;
}
.wf-alert {
    margin: 16px 28px 0 !important;
    border-radius: 0 !important;
}
.wf-notice-wrap {
    display: grid;
    grid-template-rows: 1fr;
    margin: 16px 28px 0;
}
.wf-notice-wrap :deep(.wf-alert) {
    min-height: 0;
    margin: 0 !important;
}
.wf-notice-enter-active,
.wf-notice-leave-active {
    overflow: hidden;
    transition:
        grid-template-rows 0.28s ease,
        opacity 0.18s ease,
        margin-top 0.28s ease;
}
.wf-notice-enter-from,
.wf-notice-leave-to {
    grid-template-rows: 0fr;
    margin-top: 0;
    opacity: 0;
}
.wf-type-select {
    max-width: 520px;
    margin: 18px 28px 0;
}
.wf-type-select :deep(.v-field) {
    border-radius: 0 !important;
}

/* ---- Tabs ---- */
.wf-tabs {
    height: 54px;
    padding: 0 28px;
    border-bottom: 1px solid var(--wf-line);
}
.wf-tabs :deep(.v-tab) {
    min-width: 0;
    height: 54px;
    padding: 0 18px;
    border-radius: 0;
    color: var(--wf-muted);
    font-size: 13.5px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    transition:
        background 0.15s,
        color 0.15s;
}
.wf-tabs :deep(.v-tab:hover) {
    color: var(--wf-ink);
    background: var(--wf-hover);
}
.wf-tabs :deep(.v-tab[aria-selected="true"]) {
    color: var(--wf-blue);
    box-shadow: inset 0 -3px 0 var(--wf-blue);
}
.wf-count {
    margin-left: 10px;
    padding: 2px 9px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0;
}
.wf-tabs :deep(.v-tab[aria-selected="true"]) .wf-count {
    background: var(--wf-blue);
    color: #fff;
}
.wf-dirty {
    display: inline-block;
    width: 7px;
    height: 7px;
    margin-left: 7px;
    border-radius: 50%;
    background: var(--wf-amber);
}

/* ---- Window / section heading ---- */
.wf-window {
    min-height: 520px;
}
.wf-section-head {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 22px 28px 16px;
    flex-wrap: wrap;
}
.wf-section-head h2 {
    margin: 0;
    color: var(--wf-ink);
    font-size: 18px;
    font-weight: 800;
    line-height: 1.25;
}
.wf-section-head p {
    margin: 2px 0 0;
    color: var(--wf-muted);
    font-size: 13px;
}
.wf-add-btn {
    height: 44px !important;
    margin-left: auto;
    padding: 0 20px !important;
    border-radius: 0 !important;
    background: var(--wf-blue) !important;
    color: #fff !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    letter-spacing: 0 !important;
    text-transform: none !important;
    box-shadow: none !important;
}
.wf-add-btn.v-btn--disabled {
    background: var(--wf-field) !important;
    color: var(--wf-muted) !important;
}

/* ---- Table frame ---- */
.wf-table-stage {
    padding: 0 28px;
}
.wf-table {
    background: transparent;
    color: var(--wf-ink);
}
.wf-page .wf-table {
    --v-table-header-height: 40px;
    --v-table-row-height: 74px;
}
.wf-table :deep(.v-table__wrapper) {
    min-height: 410px;
    overflow-x: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--wf-line) transparent;
}
.wf-table :deep(.v-table__wrapper::-webkit-scrollbar) {
    width: 8px;
    height: 8px;
}
.wf-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
    background: var(--wf-field);
}
.wf-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
    background: var(--wf-line);
}
.wf-table :deep(.v-table__wrapper > table) {
    width: 100%;
    min-width: 1120px;
    table-layout: fixed;
}
.wf-table :deep(thead tr th.v-data-table__th) {
    height: 40px;
    padding: 9px 12px;
    background: var(--wf-field) !important;
    border-bottom: 1px solid var(--wf-line) !important;
    color: var(--wf-muted) !important;
    font-size: 12px !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    white-space: nowrap;
}
.wf-table :deep(thead tr th.v-data-table__th .v-data-table-header__content) {
    color: var(--wf-muted) !important;
    font-weight: 800;
}
.wf-table :deep(thead tr th.v-data-table__th:first-child),
.wf-table :deep(tbody tr td:first-child) {
    padding-left: 16px;
    width: 64px;
}
.wf-table :deep(thead tr th.v-data-table__th:last-child),
.wf-table :deep(tbody tr td:last-child) {
    padding-right: 16px;
    text-align: right;
}
.wf-table :deep(tbody tr td) {
    height: 74px;
    padding: 14px 12px;
    border-bottom: 1px solid var(--wf-line) !important;
    color: var(--wf-ink);
    font-size: 14px;
    vertical-align: middle;
}
.wf-table :deep(tbody tr:hover) {
    background: var(--wf-hover) !important;
}
.wf-table :deep(tbody tr) {
    transition: background 0.12s;
}

.wf-table :deep(tbody tr.wf-step-unsaved-row > td) {
    background: var(--wf-new-bg);
}

.wf-table :deep(tbody tr.wf-step-unsaved-row:hover > td) {
    background: color-mix(in srgb, var(--wf-new-bg) 76%, var(--wf-new-accent)) !important;
}

.wf-table :deep(tbody tr.wf-step-unsaved-row > td:first-child) {
    box-shadow: inset 4px 0 var(--wf-new-accent);
}

/* ---- Steps cells ---- */
.wf-num {
    display: inline-grid;
    place-items: center;
    min-width: 32px;
    height: 32px;
    padding: 0 4px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-size: 13px;
    font-weight: 800;
}
.wf-name {
    display: flex;
    align-items: center;
    min-width: 0;
    color: var(--wf-ink);
    font-size: 14.5px;
    font-weight: 600;
    letter-spacing: -0.005em;
}
.wf-sub-icon {
    margin-right: 4px;
    flex: none;
    color: var(--wf-muted);
}
.wf-name-text {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.wf-step-unsaved-chip {
    height: 20px;
    flex: none;
    margin-left: 8px;
    background: var(--wf-new-chip-bg);
    color: var(--wf-new-chip-ink);
    font-size: 10px;
    font-weight: 800;
}
.wf-parent-note {
    margin-top: 3px;
    overflow: hidden;
    color: var(--wf-muted);
    font-size: 12.5px;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.wf-stage {
    display: block;
    color: var(--wf-muted);
    font-size: 12.5px;
    font-weight: 500;
    line-height: 1.25;
    overflow-wrap: break-word;
    white-space: normal;
}
.wf-sla {
    color: var(--wf-ink);
    font-size: 15px;
    font-weight: 700;
    white-space: nowrap;
}
.wf-office {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    max-width: 100%;
    padding: 5px 10px;
    background: var(--wf-blue-bg);
    color: var(--wf-blue);
    font-size: 13px;
    font-weight: 700;
    line-height: 1.25;
    text-align: left;
}
.wf-office-icon {
    width: 22px;
    height: 22px;
    flex: none;
    object-fit: contain;
}
.wf-office-icon-ph {
    display: inline-flex;
    width: 22px;
    height: 22px;
    flex: none;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    border: 2px solid #7b8495;
    border-radius: 50%;
    background: #f3f5f8;
    color: #596579;
    font-size: 15px;
    font-weight: 700;
    line-height: 1;
}
.wf-office-text {
    min-width: 0;
    overflow-wrap: anywhere;
}
.wf-office.is-dynamic {
    border: 1.5px dashed var(--wf-line);
    background: none;
    color: var(--wf-muted);
    font-weight: 600;
}
.wf-eu {
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--wf-muted);
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
}
.wf-eu .is-on {
    color: var(--wf-ok);
}
.wf-tg {
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
.wf-tg::after {
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
.wf-tg[aria-checked="true"] {
    background: var(--wf-ok);
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}
.wf-tg[aria-checked="true"]::after {
    transform: translateX(18px);
}
.wf-tg:disabled {
    opacity: 0.55;
    cursor: wait;
}
.wf-roles {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
}
.wf-role {
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    padding: 4px 9px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-size: 12px;
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
}
/* The roles column carries the only wide free-text chip in the table;
   reclaim a little padding so names such as City Administrator stay whole. */
.wf-table :deep(thead tr th:nth-child(7)),
.wf-table :deep(tbody tr td:nth-child(7)) {
    padding-left: 8px;
    padding-right: 8px;
}
.wf-flags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}
.wf-flag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 10px;
    background: var(--wf-ok-bg);
    color: var(--wf-ok);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.04em;
    text-transform: uppercase;
}
.wf-flag::before {
    content: "";
    width: 7px;
    height: 7px;
    flex: none;
    background: currentColor;
}
.wf-flag.is-end {
    background: var(--wf-blue-bg);
    color: var(--wf-blue);
}
.wf-muted {
    color: var(--wf-muted);
}
.wf-actions {
    display: flex;
    flex-wrap: nowrap;
    min-width: max-content;
    justify-content: flex-end;
    gap: 4px;
}
.wf-icon-btn {
    width: 40px !important;
    min-width: 40px !important;
    height: 40px !important;
    padding: 0 !important;
    border: 1.5px solid var(--wf-line) !important;
    border-radius: 0 !important;
    background: transparent !important;
    color: var(--wf-muted) !important;
    box-shadow: none !important;
}
.wf-icon-btn :deep(.v-icon) {
    font-size: 18px !important;
}
.wf-icon-btn:hover {
    background: var(--wf-hover) !important;
    color: var(--wf-ink) !important;
}
.wf-icon-btn.is-edit {
    border-color: var(--wf-amber-bg) !important;
    color: var(--wf-amber) !important;
}
.wf-icon-btn.is-edit:hover {
    background: var(--wf-amber-bg) !important;
}
.wf-icon-btn.is-delete {
    border-color: var(--wf-err-bg) !important;
    color: var(--wf-err) !important;
}
.wf-icon-btn.is-delete:hover {
    background: var(--wf-err-bg) !important;
}
.wf-icon-btn.v-btn--disabled {
    opacity: 0.4;
}

/* ---- Routes cells ---- */
.wf-route-step {
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    padding: 4px 8px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-size: 12.5px;
    font-weight: 700;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.wf-route-step.is-to {
    background: var(--wf-blue-bg);
    color: var(--wf-blue);
}
.wf-route-step.is-deleted {
    background: var(--wf-err-bg);
    color: var(--wf-err);
}
.wf-action-code {
    color: var(--wf-ink);
    font-family: inherit;
    font-size: 14.5px;
    font-weight: 600;
    letter-spacing: -0.005em;
    text-transform: capitalize;
}
.wf-action-code.is-return {
    color: var(--wf-amber);
}
.wf-group-tag {
    display: inline-block;
    padding: 4px 8px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
}
.wf-approvals {
    display: inline-grid;
    place-items: center;
    min-width: 28px;
    height: 26px;
    background: var(--wf-field);
    color: var(--wf-ink);
    font-size: 12.5px;
    font-weight: 800;
}
.wf-condition {
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    padding: 4px 7px;
    background: var(--wf-field);
    color: var(--wf-muted);
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 11.5px;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* ---- Empty / loading ---- */
.wf-empty {
    display: flex;
    min-height: 321px;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40px 16px;
    text-align: center;
}
.wf-empty-art {
    width: 180px;
    height: auto;
    margin-bottom: 14px;
    border-radius: 0 !important;
}
.wf-empty-title {
    margin: 0;
    color: var(--wf-ink);
    font-size: 16px;
    font-weight: 800;
}
.wf-empty-text {
    margin: 4px 0 0;
    color: var(--wf-muted);
    font-size: 13.5px;
}
.wf-empty .wf-add-btn {
    margin: 20px 0 0;
}
.wf-table-loading {
    padding-top: 4px;
}

/* ---- Footer / pagination ---- */
.wf-table :deep(.v-data-table-footer) {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 20px;
    flex-wrap: wrap;
    padding: 16px 0 20px;
    color: var(--wf-muted);
    font-size: 14px;
}
.wf-table :deep(.v-data-table-footer__items-per-page) {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-right: auto;
}
.wf-table :deep(.v-data-table-footer__items-per-page > span) {
    font-size: 14px;
}
.wf-table :deep(.v-data-table-footer__info) {
    color: var(--wf-ink);
    font-size: 14px;
    font-weight: 700;
}
.wf-table :deep(.v-data-table-footer__pagination) {
    display: flex;
    gap: 4px;
    margin-left: 0;
}
.wf-table :deep(.v-data-table-footer__pagination .v-btn) {
    width: 40px !important;
    min-width: 40px !important;
    height: 40px !important;
    border: 1.5px solid var(--wf-line);
    border-radius: 0 !important;
    background: transparent !important;
    color: var(--wf-muted) !important;
    box-shadow: none !important;
}
.wf-table :deep(.v-data-table-footer__pagination .v-btn:hover) {
    background: var(--wf-hover) !important;
    color: var(--wf-ink) !important;
}
.wf-table :deep(.v-data-table-footer__pagination .v-btn .v-icon) {
    font-size: 18px;
}
.wf-table :deep(.v-data-table-footer__items-per-page .v-field) {
    min-height: 40px;
    border-radius: 0 !important;
    font-size: 14px;
    font-weight: 700;
}
.wf-table :deep(.v-data-table-footer__items-per-page .v-field__outline__start),
.wf-table :deep(.v-data-table-footer__items-per-page .v-field__outline__end),
.wf-table :deep(.v-data-table-footer__items-per-page .v-field__outline__notch) {
    border-radius: 0 !important;
}
.wf-table :deep(.v-data-table-footer__items-per-page .v-field__input) {
    min-height: 40px;
    padding-top: 0;
    padding-bottom: 0;
}

/* ---- Responsive ---- */
@media (max-width: 960px) {
    .wf-title {
        font-size: 22px;
    }
    .wf-tools {
        width: 100%;
        margin-left: 0;
    }
}
@media (max-width: 720px) {
    .wf-hd {
        gap: 12px;
        padding: 18px 16px;
    }
    .wf-badge {
        width: 46px;
        height: 46px;
    }
    .wf-title {
        font-size: 20px;
    }
    .wf-sub {
        font-size: 12.5px;
    }
    .wf-hd-main {
        flex: 1 1 200px;
    }
    .wf-tools {
        gap: 8px;
    }
    .wf-ver {
        flex: 1 1 auto;
        justify-content: center;
    }
    .wf-tool-btn,
    .wf-save,
    .wf-publish {
        flex: 1 1 auto;
    }
    .wf-alert {
        margin: 14px 16px 0 !important;
    }
    .wf-notice-wrap {
        margin: 14px 16px 0;
    }
    .wf-type-select {
        max-width: none;
        margin: 16px 16px 0;
    }
    .wf-tabs {
        height: 54px;
        padding: 0 16px;
        overflow-x: auto;
    }
    .wf-window {
        min-height: 0;
    }
    .wf-section-head {
        align-items: flex-start;
        padding: 18px 16px 14px;
    }
    .wf-section-head > div:first-child {
        flex: 1 1 100%;
    }
    .wf-section-head .wf-add-btn {
        width: 100%;
        margin-left: 0;
        justify-content: center;
    }
    .wf-table-stage {
        padding: 0 16px;
    }
    .wf-table :deep(.v-table__wrapper) {
        min-height: 0;
    }
    .wf-table :deep(.v-data-table-footer) {
        justify-content: center;
        gap: 12px;
        padding: 14px 0 18px;
    }
    .wf-table :deep(.v-data-table-footer__items-per-page) {
        width: 100%;
        justify-content: center;
        margin-right: 0;
    }
    .wf-table :deep(.v-data-table-footer__info) {
        order: 2;
    }
    .wf-table :deep(.v-data-table-footer__pagination) {
        order: 3;
        width: 100%;
        justify-content: center;
    }
}
@media (prefers-reduced-motion: reduce) {
    .wf-page *,
    .wf-page *::before,
    .wf-page *::after {
        transition: none !important;
    }
}

/* ---- New / Edit Step modal (design mockup port) ---- */
/* Header: tinted badge + title + subtitle + close. */
.stp-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 16px;
}
.stp-badge {
    flex: none;
}
.stp-hd-t {
    min-width: 0;
}
.stp-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}
.stp-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}
.stp-x {
    margin-left: auto;
    flex: none;
}

/* Body: titled sections, label / field / help rhythm. */
.stp-bd {
    padding: 18px 24px 8px;
}
.stp-sec {
    margin-bottom: 22px;
}
.stp-sec-t {
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
.stp-sec-t::after {
    content: "";
    flex: 1;
    height: 1px;
    background: rgba(var(--v-border-color), var(--v-border-opacity));
}
.stp-g {
    display: grid;
    gap: 14px;
    grid-template-columns: 110px 1fr;
}
.stp-g2 {
    display: grid;
    gap: 14px;
    grid-template-columns: 1fr 1fr;
}
.stp-g + .stp-g2 {
    margin-top: 14px;
}
.stp-f {
    min-width: 0;
    margin-bottom: 14px;
}
.stp-g .stp-f,
.stp-g2 .stp-f {
    margin-bottom: 0;
}
.stp-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}
.stp-req {
    color: rgb(var(--v-theme-error));
}
.stp-help {
    margin: 6px 2px 0;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}
.stp-help-user-office {
    color: rgb(var(--v-theme-info));
    font-weight: 500;
}
.stp-help-user-office .v-icon {
    vertical-align: -2px;
}

/* Fields: 48px tall, radius 12, tinted fill, soft focus ring. */
.stp-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}
.stp-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}
.stp-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(0, 94, 237, 0.18);
}

/* Assigned Office picker: icon + text, mirroring the transaction types
   modal (selection chip rows and prepend-icon option rows). */
.stp-offices :deep(.v-list-item-title) {
    font-weight: 700;
}
.stp-office-selection {
    display: inline-flex;
    align-items: center;
    gap: 0;
}
.stp-office-selection span:last-child {
    font-size: 15px;
    font-weight: 600;
}
.stp-office-chip-icon {
    width: 22px;
    height: 22px;
    margin-inline-end: 8px;
    object-fit: contain;
}
.stp-office-option-icon {
    width: 36px;
    height: 36px;
    flex: none;
    margin-inline-end: 10px;
    object-fit: contain;
}
.stp-office-option-icon-placeholder {
    display: inline-flex;
    width: 36px;
    height: 36px;
    flex: none;
    margin-inline-end: 10px;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    border: 2px solid #7b8495;
    border-radius: 50%;
    background: #f3f5f8;
    color: #596579;
    font-size: 21px;
    font-weight: 700;
    line-height: 1;
}

/* Flow: switch rows side by side. */
.stp-sw {
    display: flex;
    align-items: center;
    gap: 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
    padding: 12px 14px;
}
.stp-sw-t {
    font-size: 14.5px;
    font-weight: 700;
}
.stp-sw-d {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}
.stp-sw-tg {
    flex: none;
}

/* Routing: role pills wrap instead of scrolling off-screen. */
.stp-roles {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}
.stp-role {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    height: 38px;
    padding: 0 14px 0 12px;
    border-radius: 99px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    background: none;
    color: inherit;
    font: inherit;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition:
        background 0.15s,
        border-color 0.15s,
        color 0.15s;
}
.stp-role::before {
    content: "";
    width: 16px;
    height: 16px;
    flex: none;
    border-radius: 50%;
    border: 2px solid rgba(var(--v-border-color), var(--v-border-opacity));
    transition:
        border-color 0.15s,
        background-color 0.15s;
}
.stp-role:hover {
    background: rgba(var(--v-theme-primary), 0.06);
}
.stp-role.is-on {
    background: rgba(var(--v-theme-primary), 0.12);
    border-color: rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-primary));
}
.stp-role.is-on::before {
    border-color: rgb(var(--v-theme-primary));
    background: rgb(var(--v-theme-primary))
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='m4 8.5 2.8 2.8L12 5.5' fill='none' stroke='%23fff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E")
        center/100%;
}

/* Footer: ghost Cancel + primary Save, stacked on phones. */
.stp-ft {
    gap: 10px;
    padding: 16px 24px 20px;
}
.stp-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}
.stp-b-pri {
    min-width: 120px;
}
@media (max-width: 560px) {
    .stp-g,
    .stp-g2 {
        grid-template-columns: 1fr;
    }
    .stp-ft {
        flex-direction: column-reverse;
    }
    .stp-b {
        width: 100%;
    }
}

/* ---- New / Edit Route modal (design mockup port) ---- */
/* From → To side by side with an arrow between; stacks on phones. */
.rt-ft2 {
    display: grid;
    grid-template-columns: 1fr 44px 1fr;
    gap: 10px;
    align-items: start;
}
.rt-ft2 .stp-f {
    margin-bottom: 0;
}
.rt-arrow {
    width: 44px;
    height: 44px;
    margin-top: 30px;
    border-radius: 50%;
    display: grid;
    place-items: center;
    background: rgba(var(--v-theme-primary), 0.12);
    color: rgb(var(--v-theme-primary));
}
.rt-em {
    display: none;
    margin: 6px 2px 0;
    font-size: 12.5px;
    font-weight: 600;
    color: rgb(var(--v-theme-error));
}
.rt-ft2 .stp-f.bad .rt-em {
    display: block;
}
.rt-info {
    display: flex;
    gap: 10px;
    align-items: flex-start;
    margin-top: 12px;
    padding: 12px 14px;
    border-radius: 12px;
    background: rgba(var(--v-theme-primary), 0.08);
    font-size: 13px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
}
.rt-info :deep(.v-icon) {
    color: rgb(var(--v-theme-primary));
    margin-top: 1px;
}

/* Action: preset pills + custom code. */
.rt-acts {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}
.rt-pill {
    height: 40px;
    padding: 0 18px;
    border-radius: 99px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    background: none;
    color: inherit;
    font: inherit;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition:
        background 0.15s,
        border-color 0.15s,
        color 0.15s;
}
.rt-pill:hover {
    background: rgba(var(--v-theme-primary), 0.06);
}
.rt-pill.is-on {
    background: rgb(var(--v-theme-primary));
    border-color: rgb(var(--v-theme-primary));
    color: #fff;
}
.rt-pill.is-rej.is-on {
    background: rgb(var(--v-theme-error));
    border-color: rgb(var(--v-theme-error));
}
.rt-cw {
    margin-top: 10px;
}
.rt-in-mono :deep(input),
.rt-in-mono :deep(textarea) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14px;
}

/* Advanced: collapsible box (Lane, approvals, condition JSON). */
.rt-adv {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 10px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    background: none;
    color: inherit;
    border-radius: 14px;
    padding: 12px 14px;
    text-align: left;
    font: inherit;
    font-weight: 700;
    font-size: 14.5px;
    cursor: pointer;
}
.rt-adv:hover {
    background: rgba(var(--v-theme-primary), 0.04);
}
.rt-adv small {
    margin-left: 2px;
    font-size: 12.5px;
    font-weight: 500;
    color: rgb(var(--v-theme-secondary));
}
.rt-adv-i {
    margin-left: auto;
    color: rgb(var(--v-theme-secondary));
    transition: transform 0.2s;
}
.rt-adv-i.is-open {
    transform: rotate(180deg);
}
.rt-advp {
    padding: 16px 2px 0;
}
.rt-jh {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 7px;
}
.rt-jh .stp-lb {
    margin: 0;
}
.rt-link {
    border: 0;
    background: none;
    color: rgb(var(--v-theme-primary));
    font: inherit;
    font-size: 13px;
    font-weight: 700;
    padding: 4px 6px;
    border-radius: 8px;
    cursor: pointer;
}
.rt-link:hover {
    background: rgba(var(--v-theme-primary), 0.1);
}
.rt-jv {
    margin: 6px 2px 0;
    font-size: 12.5px;
    font-weight: 600;
    min-height: 18px;
}
.rt-jv.ok {
    color: rgb(var(--v-theme-success));
}
.rt-jv.no {
    color: rgb(var(--v-theme-error));
}
.rt-jv.n {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}
.stp-opt {
    color: rgb(var(--v-theme-secondary));
    font-weight: 500;
}

/* ---- Save version modal ---- */
.sv-card {
    max-height: 90vh;
}
.sv-sum {
    padding: 14px 16px;
    border: 1px solid rgba(var(--v-theme-primary), 0.12);
    border-radius: 14px;
    background: rgba(var(--v-theme-primary), 0.06);
}
.sv-sum-copy {
    font-size: 13px;
    line-height: 1.5;
    color: rgb(var(--v-theme-secondary));
}
.sv-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 12px;
}
.sv-chip {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    min-height: 30px;
    padding: 0 11px 0 6px;
    border: 1px solid rgba(var(--v-theme-primary), 0.18);
    border-radius: 99px;
    background: rgb(var(--v-theme-surface));
    color: rgb(var(--v-theme-on-surface));
    font: inherit;
    font-size: 12.5px;
    font-weight: 700;
    line-height: 1.2;
    text-align: left;
    cursor: pointer;
    appearance: none;
    transition:
        border-color 0.15s,
        background 0.15s,
        box-shadow 0.15s;
}
.sv-chip:hover {
    border-color: rgba(var(--v-theme-primary), 0.45);
    background: rgba(var(--v-theme-primary), 0.07);
}
.sv-chip:focus-visible {
    outline: 2px solid rgb(var(--v-theme-primary));
    outline-offset: 2px;
}
.sv-chip-n {
    display: inline-grid;
    place-items: center;
    min-width: 22px;
    height: 22px;
    padding: 0 6px;
    border-radius: 99px;
    background: rgba(var(--v-theme-primary), 0.14);
    color: rgb(var(--v-theme-primary));
    font-size: 11.5px;
    font-weight: 800;
}
.sv-chip.is-zero {
    opacity: 0.45;
    border-color: rgba(var(--v-border-color), var(--v-border-opacity));
}
.sv-chip.is-zero .sv-chip-n {
    background: rgba(var(--v-border-color), 0.08);
    color: rgb(var(--v-theme-secondary));
}

/* Chip detail popovers: what changed, with old → new values. */
.sv-pop {
    width: min(360px, calc(100vw - 32px));
    padding: 14px;
    border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}
.sv-pop-h {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 10px;
    font-size: 14px;
    font-weight: 800;
}
.sv-pop-count {
    flex: none;
    font-size: 11.5px;
    font-weight: 700;
    color: rgb(var(--v-theme-secondary));
    white-space: nowrap;
}
.sv-pop-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
    max-height: min(300px, 45vh);
    padding-right: 2px;
    overflow-y: auto;
    overscroll-behavior: contain;
}
.sv-pop-item {
    display: flex;
    align-items: flex-start;
    gap: 9px;
}
.sv-pop-dot {
    flex: none;
    width: 8px;
    height: 8px;
    margin-top: 5px;
    border-radius: 50%;
    background: rgb(var(--v-theme-primary));
}
.sv-pop-dot.is-added {
    background: rgb(var(--v-theme-success));
}
.sv-pop-dot.is-updated {
    background: rgb(var(--v-theme-warning));
}
.sv-pop-dot.is-removed {
    background: rgb(var(--v-theme-error));
}
.sv-pop-body {
    min-width: 0;
}
.sv-pop-label {
    font-size: 13px;
    font-weight: 700;
    line-height: 1.4;
    overflow-wrap: anywhere;
}
.sv-pop-kind {
    margin-right: 6px;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-secondary));
}
.sv-pop-changes {
    display: flex;
    flex-direction: column;
    gap: 3px;
    margin-top: 5px;
}
.sv-pop-change {
    font-size: 12px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
    overflow-wrap: anywhere;
}
.sv-pop-field {
    margin-right: 3px;
    font-weight: 700;
    color: rgb(var(--v-theme-on-surface));
}
.sv-pop-val {
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.sv-pop-arrow {
    margin: 0 5px;
    color: rgb(var(--v-theme-secondary));
}
.sv-pop-empty {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}
.sv-sec {
    margin-top: 22px;
}
.sv-opts {
    display: grid;
    gap: 10px;
}
.sv-opt {
    position: relative;
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
    cursor: pointer;
    transition:
        border-color 0.15s,
        background 0.15s,
        box-shadow 0.15s;
}
.sv-opt:hover {
    background: rgba(var(--v-theme-primary), 0.04);
}
.sv-opt.is-on {
    border-color: rgb(var(--v-theme-primary));
    background: rgba(var(--v-theme-primary), 0.07);
    box-shadow: 0 0 0 3px rgba(var(--v-theme-primary), 0.1);
}
.sv-opt:focus-within {
    box-shadow: 0 0 0 4px rgba(var(--v-theme-primary), 0.18);
}
.sv-opt-input {
    position: absolute;
    width: 1px;
    height: 1px;
    margin: -1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0 0 0 0);
    white-space: nowrap;
    border: 0;
}
.sv-radio {
    flex: none;
    width: 20px;
    height: 20px;
    margin-top: 1px;
    border: 2px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 50%;
    background: rgb(var(--v-theme-surface));
    transition:
        border-color 0.15s,
        box-shadow 0.15s;
}
.sv-opt.is-on .sv-radio {
    border-color: rgb(var(--v-theme-primary));
    box-shadow: inset 0 0 0 4px rgb(var(--v-theme-surface));
    background: rgb(var(--v-theme-primary));
}
.sv-opt-body {
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
}
.sv-opt-title {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    font-size: 14.5px;
    font-weight: 800;
    line-height: 1.3;
}
.sv-opt-desc {
    font-size: 12.5px;
    line-height: 1.45;
    color: rgb(var(--v-theme-secondary));
}
.sv-tag {
    display: inline-flex;
    align-items: center;
    height: 20px;
    padding: 0 8px;
    border-radius: 99px;
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.02em;
    text-transform: uppercase;
}
.sv-tag-draft {
    background: rgba(var(--v-theme-warning), 0.14);
    color: rgb(var(--v-theme-warning));
}
.sv-tag-live {
    background: rgba(var(--v-theme-success), 0.14);
    color: rgb(var(--v-theme-success));
}
.sv-warn {
    display: flex;
    align-items: flex-start;
    gap: 9px;
    margin-top: 10px;
    padding: 11px 13px;
    border: 1px solid rgba(var(--v-theme-warning), 0.28);
    border-radius: 12px;
    background: rgba(var(--v-theme-warning), 0.1);
    color: rgb(var(--v-theme-warning));
    font-size: 12.5px;
    font-weight: 600;
    line-height: 1.45;
}
.sv-warn :deep(.v-icon) {
    flex: none;
    margin-top: 1px;
}
@media (max-width: 600px) {
    :global(.sv-dialog) {
        position: fixed !important;
        inset: auto 0 0 0 !important;
        width: 100% !important;
        max-width: 100% !important;
        margin: 0 !important;
    }
    :global(.sv-dialog .v-card) {
        max-height: 92vh;
        border-radius: 24px 24px 0 0 !important;
    }
}

/* Dark theme (html.dark is toggled by AppShell for pixivDark). */
html.dark .stp-in :deep(.v-field) {
    background: #232b45;
}
html.dark .stp-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}
html.dark .stp-sec-t::after,
html.dark .stp-sw,
html.dark .stp-role {
    border-color: rgba(255, 255, 255, 0.16);
}
html.dark .stp-role.is-on::before {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath d='m4 8.5 2.8 2.8L12 5.5' fill='none' stroke='%230e1424' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
}

/* Route modal: dark borders + pill text on dark. */
html.dark .rt-adv,
html.dark .rt-pill {
    border-color: rgba(255, 255, 255, 0.16);
}
html.dark .rt-pill.is-on {
    color: #0e1424;
}

/* Route modal: stack From → To on phones and turn the arrow downward. */
@media (max-width: 560px) {
    .rt-ft2 {
        grid-template-columns: 1fr;
    }
    .rt-arrow {
        margin: 0 auto;
        transform: rotate(90deg);
    }
}
</style>
