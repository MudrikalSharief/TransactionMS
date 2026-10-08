<template>
    <div>
        <LoadingVeil :show="loading || resolvingSteps" label="workflow steps" icon="mdi-source-branch" />
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                    <v-icon color="#1E40AF">mdi-source-branch</v-icon>
                </v-avatar>
                <div>
                    <span class="text-h6 font-weight-bold">TRANSACTION TYPE STEPS AND ROUTES</span>
                    <div v-if="selectedTypeName" class="text-caption text-medium-emphasis font-weight-bold">{{ selectedTypeName }}</div>
                    <div v-else class="text-caption text-medium-emphasis">Select a transaction type</div>
                </div>
                <v-spacer />
                <div class="d-flex gap-2 align-center">
                    <v-chip
                        v-if="activeDef"
                        rounded="0"
                        size="small"
                        variant="tonal"
                        :color="activeDef.status === 'published' ? 'primary' : activeDef.status === 'draft' ? 'warning' : 'grey'"
                        class="font-weight-bold"
                        append-icon="mdi-menu-down"
                        style="cursor: pointer"
                        @click="versionDialog = true"
                    >
                        {{ activeDef.status === "draft" ? "Draft" : isLiveDef(activeDef) ? "Current version" : "Previous" }}
                    </v-chip>
                    <v-dialog v-model="versionDialog" max-width="560">
                        <v-card rounded="0">
                            <v-card-title class="d-flex align-center pa-5 lgu-head">
                                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                                    <v-icon color="#1E40AF">mdi-source-branch</v-icon>
                                </v-avatar>
                                <div>
                                    <div class="text-h6 font-weight-bold lh-1">Workflow versions</div>
                                    <div v-if="selectedTypeShortName" class="text-caption text-medium-emphasis">{{ selectedTypeShortName }}</div>
                                </div>
                                <v-spacer />
                                <v-btn icon="mdi-close" variant="text" color="grey-darken-3" @click="versionDialog = false" />
                            </v-card-title>
                            <v-card-text class="pa-4">
                                <v-list density="comfortable" class="py-0">
                                    <v-list-item
                                        v-for="d in (defs || [])"
                                        :key="d.id"
                                        :active="isLiveDef(d)"
                                        rounded="0"
                                        class="mb-1"
                                    >
                                        <v-list-item-title class="font-weight-bold d-flex align-center flex-wrap ga-2">
                                            <span>v{{ d.version }}</span>
                                            <span v-if="d.name" class="status-dot" style="background: #000" aria-hidden="true" />
                                            <span v-if="d.name" class="text-primary">{{ d.name }}</span>
                                            <span class="text-medium-emphasis font-weight-medium">|</span>
                                            <span v-if="d.published_at" class="text-medium-emphasis font-weight-medium">{{ fmtLiveDate(d.published_at) }}</span>
                                            <span v-else-if="d.status === 'draft'" class="text-medium-emphasis font-weight-medium">publish first to go live</span>
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
                                                v-else-if="d.status === 'published'"
                                                size="x-small"
                                                variant="outlined"
                                                color="primary"
                                                rounded="0"
                                                class="font-weight-bold"
                                                v-tooltip="'Make this version live for new transactions'"
                                                @click="versionDialog = false; askMakeLive(d)"
                                            >
                                                SELECT VERSION
                                            </v-btn>
                                        </template>
                                    </v-list-item>
                                </v-list>
                            </v-card-text>
                            <v-divider />
                            <v-card-actions class="justify-end">
                                <v-btn variant="text" @click="versionDialog = false">Close</v-btn>
                            </v-card-actions>
                        </v-card>
                    </v-dialog>
                    <v-btn
                        variant="text"
                        color="grey-darken-3"
                        prepend-icon="mdi-arrow-left"
                        @click="$router.push('/admin/transaction-types')"
                    >
                        Back
                    </v-btn>
                    <v-btn
                        v-if="stagingDirty"
                        variant="text"
                        color="error"
                        rounded="0"
                        size="small"
                        prepend-icon="mdi-undo"
                        v-tooltip="'Drop all staged edits and show the last saved state'"
                        @click="discardStaged"
                    >
                        Discard
                    </v-btn>
                    <v-btn
                        variant="outlined"
                        color="grey-darken-3"
                        rounded="0"
                        size="small"
                        prepend-icon="mdi-content-save-plus-outline"
                        :disabled="!activeDef"
                        v-tooltip="stagingDirty ? 'Persist staged edits: overwrite the draft or create a new version' : 'Save version (enabled once you stage an edit)'"
                        @click="openSaveDialog"
                    >
                        Save version
                        <v-chip v-if="stagingDirty" size="x-small" color="warning" variant="flat" class="ml-2 font-weight-bold">UNSAVED</v-chip>
                    </v-btn>
                </div>
            </v-card-title>

            <v-divider />

            <v-card-text class="pa-4">
                <v-alert v-if="error" type="error" variant="tonal" class="mb-3">
                    {{ error }}
                </v-alert>
                <v-alert v-if="notice" type="success" variant="tonal" class="mb-3">
                    {{ notice }}
                </v-alert>
                <v-alert
                    v-if="!selectedTypeId && !loading && queryResolved"
                    type="warning"
                    variant="tonal"
                    rounded="0"
                    class="mb-3"
                >
                    No transaction type selected. Pick one below, or go to
                    <b>Transaction Types</b> and open <b>Steps</b> for one transaction type.
                </v-alert>
                <v-select
                    v-if="!selectedTypeId && !loading && queryResolved && (types || []).length"
                    :model-value="null"
                    :items="typePickerOptions"
                    item-title="label"
                    item-value="id"
                    label="Select transaction type"
                    density="compact"
                    class="mb-3"
                    @update:model-value="onPickType"
                />

                <template v-if="!activeDef && (selectedTypeId || bootSkeleton)">
                    <v-tabs v-model="wfTab" color="primary" density="comfortable" class="wf-type-tabs">
                        <v-tab :value="0" class="font-weight-bold" style="color: rgb(var(--v-theme-primary))">
                            Steps
                            <v-chip size="x-small" variant="tonal" color="grey-darken-3" class="ml-2">{{ flatStepRows.length }}</v-chip>
                        </v-tab>
                        <v-tab :value="1" class="font-weight-bold" style="color: rgb(var(--v-theme-primary))">
                            Routes
                            <v-chip size="x-small" variant="tonal" color="grey-darken-3" class="ml-2">{{ sortedRoutes.length }}</v-chip>
                        </v-tab>
                    </v-tabs>
                    <v-divider />
                    <v-window v-model="wfTab" class="wf-tabs-window">
                        <v-window-item :value="0">
                    <div class="d-flex align-center mb-2 mt-4">
                        <div class="text-subtitle-1 font-weight-bold">Steps ({{ flatStepRows.length }})</div>
                        <v-spacer />
                        <v-btn
                            color="primary"
                            rounded="0"
                            prepend-icon="mdi-plus"
                            :loading="saving"
                            @click="clickAddStep"
                        >
                            Add Step
                        </v-btn>
                    </div>
                    <div class="d-flex flex-column" style="min-height: 510px">
                        <template v-if="loading || resolvingSteps">
                            <v-skeleton-loader type="table-thead" />
                            <v-skeleton-loader type="table-tbody" class="mt-2" />
                            <TableLoader compact label="steps" icon="mdi-source-branch" style="flex: 1 1 auto" />
                        </template>
                        <div v-else class="text-center pa-6 d-flex flex-column align-center justify-center" style="min-height: 320px">
                            <img :src="mascotEmptyUrl" alt="No workflow yet" width="180" class="mb-3" style="border-radius: 18px" />
                            <div class="font-weight-bold">No workflow yet.</div>
                            <v-btn color="primary" rounded="0" prepend-icon="mdi-plus" class="mt-3" @click="clickAddStep">Add Step</v-btn>
                        </div>
                    </div>
                        </v-window-item>
                        <v-window-item :value="1">
                    <div class="d-flex align-center mb-2 mt-4">
                        <div class="text-subtitle-1 font-weight-bold">WORKFLOW ROUTES ({{ sortedRoutes.length }})</div>
                    </div>
                    <div class="d-flex flex-column" style="min-height: 510px">
                        <template v-if="loading || resolvingSteps">
                            <v-skeleton-loader type="table-thead" />
                            <v-skeleton-loader type="table-tbody" class="mt-2" />
                            <TableLoader compact label="routes" icon="mdi-source-branch" style="flex: 1 1 auto" />
                        </template>
                        <div v-else class="text-center pa-6 d-flex flex-column align-center justify-center" style="min-height: 320px">
                            <img :src="mascotEmptyUrl" alt="No routes yet" width="180" class="mb-3" style="border-radius: 18px" />
                            <div class="font-weight-bold">No routes yet.</div>
                        </div>
                    </div>
                        </v-window-item>
                    </v-window>
                </template>

                <template v-if="activeDef">

                <v-tabs v-model="wfTab" color="primary" density="comfortable" class="wf-type-tabs">
                    <v-tab :value="0" class="font-weight-bold" style="color: rgb(var(--v-theme-primary))">
                        Steps
                        <v-chip size="x-small" variant="tonal" color="grey-darken-3" class="ml-2">{{ flatStepRows.length }}</v-chip>
                        <v-icon v-if="stepsDirty" size="10" color="warning" class="ml-1" title="Unsaved step changes">mdi-circle</v-icon>
                    </v-tab>
                    <v-tab :value="1" class="font-weight-bold" style="color: rgb(var(--v-theme-primary))">
                        Routes
                        <v-chip size="x-small" variant="tonal" color="grey-darken-3" class="ml-2">{{ sortedRoutes.length }}</v-chip>
                        <v-icon v-if="routesDirty" size="10" color="warning" class="ml-1" title="Unsaved route changes">mdi-circle</v-icon>
                    </v-tab>
                </v-tabs>
                <v-divider />
                <v-window v-model="wfTab" class="wf-tabs-window">
                    <v-window-item :value="0">
                <div class="d-flex align-center mb-2 mt-4">
                    <div class="text-subtitle-1 font-weight-bold">Steps ({{ flatStepRows.length }})</div>
                    <v-spacer />
                    <v-btn
                        color="primary"
                        rounded="0"
                        prepend-icon="mdi-plus"
                        :disabled="!selectedTypeId"
                        @click="clickAddStep"
                    >
                        Add Step
                    </v-btn>
                </div>
                <div class="d-flex flex-column" style="min-height: 510px">
                <div v-if="!loading && !resolvingSteps && activeDef && !flatStepRows.length" class="text-center pa-6 d-flex flex-column align-center justify-center" style="min-height: 320px">
                        <img :src="mascotEmptyUrl" alt="No steps yet" width="180" class="mb-3" style="border-radius: 18px" />
                    <div class="font-weight-bold">No steps yet.</div>
                    <v-btn color="primary" rounded="0" prepend-icon="mdi-plus" class="mt-3" @click="clickAddStep">Add Step</v-btn>
                </div>
                <v-data-table
                    v-show="flatStepRows.length && !loading && !resolvingSteps"
                    v-model:page="stepPage"
                    :items="flatStepRows"
                    :headers="stepHeaders"
                    item-key="id"
                    density="compact"
                    height="330"
                    fixed-header
                    :items-per-page="STEP_PAGE_SIZE"
                    :items-per-page-options="[STEP_PAGE_SIZE]"
                    hover
                    class="lgu-table table-pages"
                >
                    <template v-slot:[`item.order_number`]="{ item }">
                        <v-chip rounded="0" size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
                            {{ item._num }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.name`]="{ item }">
                        <div class="d-flex align-center" :style="`padding-left: ${item._depth * 28}px`">
                            <v-icon v-if="item._depth > 0" size="small" color="grey" class="mr-1">mdi-subdirectory-arrow-right</v-icon>
                            <span class="font-weight-medium">{{ item.name }}</span>
                        </div>
                        <div v-if="item.parent_name" class="text-caption text-medium-emphasis" :style="`padding-left: ${item._depth * 28 + 22}px`">
                            sub of {{ item.parent_name }}
                        </div>
                    </template>
                    <template v-slot:[`item.sla_minutes`]="{ item }">
                        <v-chip
                            rounded="0"
                            size="small"
                            variant="tonal"
                            color="grey-darken-3"
                            class="font-weight-bold"
                            :title="`${item.sla_minutes ?? 0} min`"
                        >
                            {{ formatSlaMinutes(item.sla_minutes) }}
                        </v-chip>
                        <div class="text-caption text-medium-emphasis">{{ item.sla_minutes ?? 0 }} min</div>
                    </template>
                    <template v-slot:[`item.office_id`]="{ item }">
                        <v-chip
                            v-if="officeName(item)"
                            rounded="0"
                            size="small"
                            variant="tonal"
                            color="primary"
                            class="font-weight-bold"
                        >
                            {{ officeName(item) }}
                        </v-chip>
                        <span v-else class="text-medium-emphasis">—</span>
                    </template>
                    <template v-slot:[`item.role_ids`]="{ item }">
                        <div class="d-flex flex-wrap ga-1">
                            <v-chip
                                v-for="r in roleNames(item)"
                                :key="r"
                                rounded="0"
                                size="x-small"
                                variant="tonal"
                                color="grey-darken-3"
                                class="font-weight-bold"
                            >
                                {{ r }}
                            </v-chip>
                            <span v-if="!roleNames(item).length" class="text-medium-emphasis">—</span>
                        </div>
                    </template>
                    <template v-slot:[`item.flags`]="{ item }">
                        <v-chip
                            v-if="item.is_start"
                            rounded="0"
                            size="small"
                            variant="tonal"
                            color="success"
                            class="mr-1"
                            ><v-icon start size="small">mdi-play-circle</v-icon>start</v-chip
                        >
                        <v-chip v-if="item.is_end" rounded="0" size="small" variant="tonal" color="info"
                            ><v-icon start size="small">mdi-stop-circle</v-icon>end</v-chip
                        >
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn
                                icon="mdi-clipboard-list-outline"
                                v-tooltip="isTmpRow(item) ? 'Save version first — new steps get requirements after their first save' : 'Requirements'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                :disabled="isTmpRow(item)"
                                @click="goStepRequirements(item)"
                            />
                            <v-btn
                                icon="mdi-text-box-outline"
                                v-tooltip="'Step data'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                @click="goStepData(item)"
                            />
                            <v-btn
                                icon="mdi-clipboard-check-outline"
                                v-tooltip="isTmpRow(item) ? 'Save version first — new steps get a checklist after their first save' : 'Checklist'"
                                size="small"
                                variant="outlined"
                                color="info"
                                :disabled="isTmpRow(item)"
                                @click="goStepChecklist(item)"
                            />
                            <v-btn
                                icon="mdi-pencil"
                                v-tooltip="'Edit step'"
                                size="small"
                                variant="outlined"
                                color="warning"
                                @click="editStep(item)"
                            />
                            <v-btn
                                icon="mdi-delete"
                                v-tooltip="'Delete step'"
                                size="small"
                                variant="outlined"
                                color="error"
                                @click="deleteStep(item)"
                            />
                        </div>
                    </template>
                    <template #[`body.append`]>
                        <tr v-for="n in stepFillerCount" :key="`step-skel-${n}`" class="skel-fill">
                            <td :colspan="stepHeaders.length">&nbsp;</td>
                        </tr>
                    </template>
                </v-data-table>
                <template v-if="loading || resolvingSteps">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" class="mt-2" />
                    <TableLoader compact label="steps" icon="mdi-source-branch" style="flex: 1 1 auto" />
                </template>
                </div>
                    </v-window-item>
                    <v-window-item :value="1">
                <div class="d-flex align-center mb-2 mt-4">
                    <div class="text-subtitle-1 font-weight-bold">WORKFLOW ROUTES ({{ sortedRoutes.length }})</div>
                    <v-spacer />
                    <v-btn
                        color="primary"
                        rounded="0"
                        prepend-icon="mdi-plus"
                        :disabled="!selectedTypeId"
                        @click="clickAddRoute"
                    >
                        Add Route
                    </v-btn>
                </div>
                <div class="d-flex flex-column" style="min-height: 510px">
                <div v-if="!loading && !resolvingSteps && activeDef && !sortedRoutes.length" class="text-center pa-6 d-flex flex-column align-center justify-center" style="min-height: 320px">
                    <img :src="mascotEmptyUrl" alt="No routes yet" width="180" class="mb-3" style="border-radius: 18px" />
                    <div class="font-weight-bold">No routes yet.</div>
                </div>
                <v-data-table
                    v-show="sortedRoutes.length && !loading && !resolvingSteps"
                    v-model:page="routePage"
                    :items="sortedRoutes"
                    :headers="routeHeaders"
                    item-key="id"
                    density="compact"
                    height="330"
                    fixed-header
                    :items-per-page="ROUTE_PAGE_SIZE"
                    :items-per-page-options="[ROUTE_PAGE_SIZE]"
                    hover
                    class="lgu-table table-pages"
                >
                    <template v-slot:[`item.from_step_id`]="{ item }">
                        <v-chip
                            rounded="0"
                            size="x-small"
                            variant="tonal"
                            :color="stepLabel(item.from_step_id).deleted ? 'error' : 'grey-darken-3'"
                            class="font-weight-bold route-step-chip"
                            :title="stepLabel(item.from_step_id).text"
                        >
                            {{ stepLabel(item.from_step_id).text }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.to_step_id`]="{ item }">
                        <v-chip
                            rounded="0"
                            size="x-small"
                            variant="tonal"
                            :color="stepLabel(item.to_step_id).deleted ? 'error' : 'primary'"
                            class="font-weight-bold route-step-chip"
                            :title="stepLabel(item.to_step_id).text"
                        >
                            {{ stepLabel(item.to_step_id).text }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.condition_expression`]="{ item }">
                        <code
                            class="route-cond"
                            :title="pretty(item.condition_expression) || 'No condition'"
                            >{{ pretty(item.condition_expression) || "—" }}</code
                        >
                    </template>

                    <template v-slot:[`item.actions`]="{ item }">
                        <div class="d-flex ga-3 justify-end">
                            <v-btn
                                icon="mdi-pencil"
                                v-tooltip="'Edit route'"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                @click="editRoute(item)"
                            />
                            <v-btn
                                icon="mdi-delete"
                                v-tooltip="'Delete route'"
                                size="small"
                                variant="outlined"
                                color="error"
                                @click="deleteRoute(item)"
                            />
                        </div>
                    </template>
                    <template #[`body.append`]>
                        <tr v-for="n in routeFillerCount" :key="`route-skel-${n}`" class="skel-fill">
                            <td :colspan="routeHeaders.length">&nbsp;</td>
                        </tr>
                    </template>
                </v-data-table>
                <template v-if="loading || resolvingSteps">
                    <v-skeleton-loader type="table-thead" />
                    <v-skeleton-loader type="table-tbody" class="mt-2" />
                    <TableLoader compact label="routes" icon="mdi-source-branch" style="flex: 1 1 auto" />
                </template>
                </div>
                    </v-window-item>
                </v-window>
                </template>
            </v-card-text>
        </v-card>

        <!-- Step Dialog -->
        <v-dialog v-model="stepDialog" max-width="800">
            <v-card rounded="0">
                <v-card-title>{{
                    stepForm.id ? "Edit Step" : "New Step"
                }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-text-field
                        v-model="stepForm.order_number"
                        type="number"
                        label="Order #"
                    />
                    <v-select
                        v-model="stepForm.parent_id"
                        :items="parentStepOptions"
                        item-title="label"
                        item-value="id"
                        label="Parent step (empty = top level)"
                        :hint="!parentStepOptions.length ? 'No steps yet — save this as the first top-level step, then nest others under it.' : ''"
                        persistent-hint
                        clearable
                    />
                    <v-text-field v-model="stepForm.name" label="Name" />
                    <v-text-field
                        v-model="stepForm.stage"
                        label="Stage"
                        placeholder="e.g. Planning"
                    />
                    <div class="mb-1">
                        <div class="text-subtitle-2 font-weight-bold">SLA Duration</div>
                        <div class="text-caption text-medium-emphasis">Tap the clock to pick hours/minutes, set days separately. No manual typing.</div>
                    </div>
                    <div class="d-flex align-center flex-wrap ga-2 mb-2">
                        <v-chip rounded="0" size="small" variant="tonal" color="grey-darken-3" class="font-weight-bold">
                            {{ slaHuman }} = {{ slaTotal }} min
                        </v-chip>
                        <v-chip-group class="pa-0 ma-0">
                            <v-chip
                                v-for="p in slaPresets"
                                :key="p.label"
                                rounded="0"
                                size="small"
                                variant="outlined"
                                color="grey-darken-3"
                                class="font-weight-bold"
                                @click="applySlaPreset(p)"
                            >
                                {{ p.label }}
                            </v-chip>
                        </v-chip-group>
                    </div>
                    <v-row dense>
                        <v-col cols="12" sm="4">
                            <div class="d-flex align-center ga-1">
                                <v-btn icon="mdi-minus" size="small" variant="outlined" color="grey-darken-3" :disabled="slaDays <= 0" @click="slaDays = Math.max(0, Number(slaDays || 0) - 1)" />
                                <v-text-field
                                    :model-value="slaDays"
                                    label="Days (0-30)"
                                    type="number"
                                    readonly
                                    hide-spin-buttons
                                    density="compact"
                                    class="text-center"
                                    @update:model-value="() => {}"
                                />
                                <v-btn icon="mdi-plus" size="small" variant="outlined" color="grey-darken-3" :disabled="slaDays >= SLA_MAX_DAYS" @click="slaDays = Math.min(SLA_MAX_DAYS, Number(slaDays || 0) + 1)" />
                            </div>
                            <v-slider v-model="slaDays" :min="0" :max="SLA_MAX_DAYS" :step="1" density="compact" hide-details color="grey-darken-3" />
                        </v-col>
                        <v-col cols="12" sm="8">
                            <v-menu v-model="slaTimeMenu" :close-on-content-click="false" location="bottom">
                                <template #activator="{ props }">
                                    <v-text-field
                                        :model-value="slaTimeDisplay"
                                        label="Hours : Minutes (tap clock)"
                                        prepend-inner-icon="mdi-clock-outline"
                                        readonly
                                        v-bind="props"
                                    />
                                </template>
                                <v-card rounded="0">
                                    <v-time-picker v-model="slaTime" format="24hr" />
                                    <v-divider />
                                    <v-card-actions class="justify-end">
                                        <v-btn variant="text" @click="slaTimeMenu = false">Done</v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-menu>
                        </v-col>
                    </v-row>
                    <v-alert v-if="slaError" type="error" variant="tonal" density="compact" class="mb-2">
                        {{ slaError }}
                    </v-alert>
                    <v-switch v-model="stepForm.is_start" label="Is Start" />
                    <v-switch v-model="stepForm.is_end" label="Is End" />

                    <v-select
                        v-model="stepForm.office_id"
                        :items="officeOptions"
                        item-title="label"
                        item-value="id"
                        label="Destination Office"
                        hint="The office this step will be sent to"
                        persistent-hint
                        clearable
                    />

                    <v-select
                        v-model="stepForm.role_ids"
                        :items="roleOptions"
                        item-title="label"
                        item-value="id"
                        label="Roles allowed for this step"
                        multiple
                        chips
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="stepDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="saveStep"
                        >Save</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Route Dialog -->
        <v-dialog v-model="routeDialog" max-width="900">
            <v-card rounded="0">
                <v-card-title>{{
                    routeForm.id ? "Edit Route" : "New Route"
                }}</v-card-title>
                <v-divider />
                <v-card-text>
                    <v-alert v-if="routeError" type="error" variant="tonal" density="compact" class="mb-3">
                        {{ routeError }}
                    </v-alert>
                    <v-select
                        v-model="routeForm.from_step_id"
                        :items="fromStepOptions"
                        item-title="label"
                        item-value="id"
                        label="From Step"
                        @update:model-value="routeError = ''"
                    />
                    <v-select
                        v-model="routeForm.to_step_id"
                        :items="toStepOptions"
                        item-title="label"
                        item-value="id"
                        label="To Step"
                        @update:model-value="routeError = ''"
                    />
                    <v-text-field
                        v-model="routeForm.action_code"
                        label="Action Code (submit/approve/reject)"
                        hint="Routes are forward-only. Going back is done via jump to a visited station (recorded as Returned)."
                        persistent-hint
                    />
                    <v-text-field
                        v-model="routeForm.route_group"
                        label="Route Group / Lane (optional)"
                    />
                    <v-text-field
                        v-model="routeForm.required_approvals_count"
                        type="number"
                        label="Required approvals (optional)"
                    />

                    <v-textarea
                        v-model="routeForm.condition_expression_json"
                        label="Condition Expression JSON (optional, JSON logic-ish)"
                        rows="6"
                        :hint="conditionHint"
                        persistent-hint
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="routeDialog = false"
                        >Cancel</v-btn
                    >
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" @click="saveRoute"
                        >Save</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Save as new live version -->
        <v-dialog v-model="saveDialog" max-width="500">
            <v-card rounded="0">
                <v-card-title>Save version</v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-caption text-medium-emphasis mb-3">
                        Persists everything you staged (steps, routes, requirements,
                        checklists, field assignments) in one atomic save. Nothing
                        was written yet.
                    </div>
                    <v-radio-group v-model="saveMode" label="How to save?" density="compact">
                        <v-radio label="Overwrite current draft (stays draft, same version)" value="overwrite" />
                        <v-radio label="Create new version (published live, old kept)" value="create-new" />
                    </v-radio-group>
                    <v-text-field
                        v-model="saveName"
                        :label="saveMode === 'create-new' ? 'Version name (required)' : 'Version name (optional rename)'"
                        placeholder="e.g. Holiday rush flow"
                        maxlength="200"
                        counter
                        autofocus
                    />
                    <v-textarea
                        v-model="saveNotes"
                        label="Notes (optional)"
                        rows="2"
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="saveDialog = false">Cancel</v-btn>
                    <v-btn color="grey-darken-3" rounded="0" :loading="saving" :disabled="saveMode === 'create-new' && !saveName.trim()" @click="confirmSave">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Switch live version -->
        <v-dialog v-model="liveDialog" max-width="640">
            <v-card rounded="0">
                <v-card-title class="d-flex align-center pa-5 lgu-head">
                    <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                        <v-icon color="#1E40AF">mdi-swap-horizontal</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">SWITCH LIVE VERSION?</span>
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" color="grey-darken-3" @click="liveDialog = false" />
                </v-card-title>
                <v-card-text class="pa-12 text-center">
                    <div style="height: 16px" aria-hidden="true" />
                    <div class="d-flex align-center justify-center ga-4 mb-10">
                        <v-chip rounded="0" size="x-large" color="grey-darken-3" variant="tonal" class="font-weight-bold" style="font-size: 1.5rem; height: 60px; padding: 0 28px;">
                            v{{ currentDef?.version ?? "—" }}
                        </v-chip>
                        <v-icon color="primary" size="56">mdi-chevron-double-right</v-icon>
                        <v-chip rounded="0" size="x-large" color="primary" variant="flat" class="font-weight-bold" style="font-size: 1.5rem; height: 60px; padding: 0 28px;">
                            v{{ liveTarget?.version }}
                        </v-chip>
                    </div>
                    <div class="text-subtitle-2 font-weight-bold">CONFIRM TO CHANGE VERSION</div>
                </v-card-text>
                <v-divider />
                <v-card-actions class="d-flex justify-space-between px-6 pt-6 pb-6">
                    <v-btn variant="text" color="grey-darken-3" rounded="0" size="large" style="width: 40%" @click="liveDialog = false">Cancel</v-btn>
                    <v-divider vertical :thickness="2" class="align-self-stretch" />
                    <v-btn color="primary" rounded="0" size="large" style="width: 40%" :loading="saving" @click="confirmMakeLive">Switch</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- End-of-workflow footer: same deep-blue bar as the dashboard foot. -->
        <v-sheet v-if="selectedTypeId" color="#1E3A8A" rounded="0" class="pa-4 mt-6 d-flex align-center justify-center ga-3 text-center">
            <v-avatar color="white" rounded="0" size="52" class="lgu-head-avatar">
                <v-icon color="#1E40AF" size="32">mdi-flag-checkered</v-icon>
            </v-avatar>
            <v-divider vertical :thickness="2" color="white" opacity="0.6" style="height: 48px" />
            <div class="text-left">
                <div class="text-h6 font-weight-bold text-white lh-1">END OF WORKFLOW</div>
            </div>
        </v-sheet>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useWorkflows } from "@/composables/useWorkflows";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import { useRoles } from "@/composables/useRoles";
import { useOffices } from "@/composables/useOffices";
import TableLoader from '@/components/TableLoader.vue';
import mascotEmptyUrl from '@/assets/mascots/mascot-empty.jpg';
import LoadingVeil from '@/components/LoadingVeil.vue';
import { wfStatusColor, wfStatusIcon, wfStatusLabel } from '@/utils/workflowStatus';

const {
    defs,
    loading,
    fetchDefinitions,
    makeLive,
} = useWorkflows();

// Staging: every step/route dialog writes to the working copy only —
// nothing reaches the network until Save version (bulk apply).
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import { confirm } from "@/composables/useConfirm";
const staging = useWorkflowStaging();
// Def id the working copy was seeded from (bulk target hint for sub-pages).
const stagingSourceDefId = ref(null);

function seedFromActiveDef() {
    const t = selectedTypeId.value;
    const d = activeDef.value;
    if (!t || !d) return;
    staging.seedSteps(t, d.id, d.updated_at ?? null, d.steps || []);
    staging.seedRoutes(t, d.routes || []);
    stagingSourceDefId.value = d.id;
}

const stagingBucket = computed(() =>
    selectedTypeId.value ? staging.buckets.get(String(selectedTypeId.value)) : null,
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
// Before that, a ?type= deep-link renders skeleton shells — never the
// "no type selected" empty state and never a blank card.
const queryResolved = ref(false);
const bootSkeleton = computed(() => !queryResolved.value && !!route.query.type);
const error = ref("");
const notice = ref("");
const saving = ref(false);
const route = useRoute();
const router = useRouter();

const guideSections = [
    {
        title: "TRANSACTION TYPES",
        rows: [
            { term: "TRANSACTION TYPE", text: "CURRENT = LIVE FLOW, DRAFT = EDITABLE, PREVIOUS = RETIRED" },
            { term: "STATUS", text: "DRAFT = EDITABLE, PUBLISHED = LIVE, ARCHIVED = RETIRED" },
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
            { term: "FROM → TO", text: "FORWARD ONLY: WHICH STEP MOVES TO WHICH ON AN ACTION" },
            { term: "GOING BACK", text: "JUMP TO A VISITED STATION (RECORDED AS RETURNED)" },
        ],
    },
];
const conditionHint =
    'Store as JSON (not PHP). Example: {">=":[{"var":"fields.amount"},50000]}';

const roleOptions = computed(
    () => (roles.value || []).map((r) => ({ id: r.id, label: `${r.name}` })), // use ${r.code} to show Role Code
);

const officeOptions = computed(
    () => (offices.value || []).map((o) => ({ id: o.id, label: `${o.name}` })),
);

const roleNameById = computed(() => {
    const m = new Map();
    for (const r of (roles.value || [])) m.set(Number(r.id), r.name || r.code);
    return m;
});

const officeNameById = computed(() => {
    const m = new Map();
    for (const o of (offices.value || [])) m.set(Number(o.id), o.name || o.code);
    return m;
});

function officeName(item) {
    if (item?.office?.name) return item.office.name;
    if (item?.office_id == null) return "";
    return officeNameById.value.get(Number(item.office_id)) || "";
}

function roleNames(item) {
    if (Array.isArray(item?.roles) && item.roles.length)
        return item.roles.map((r) => r.name || r.code);
    return (item?.role_ids || []).map(
        (id) => roleNameById.value.get(Number(id)) || `#${id}`,
    );
}

const selectedTypeName = computed(() => {
    const t = (types.value || []).find((x) => Number(x.id) === Number(selectedTypeId.value));
    return t ? `${t.name} (${t.code})` : "";
});

// Modal subtitle: bare type name (no code duplication).
const selectedTypeShortName = computed(() => {
    const t = (types.value || []).find((x) => Number(x.id) === Number(selectedTypeId.value));
    return t ? t.name : "";
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
    stepOptions.value.filter((o) => String(o.id) !== String(routeForm.value.to_step_id)),
);
const toStepOptions = computed(() => {
    const fromKey = String(routeForm.value.from_step_id ?? '');
    const fromOrder = fromKey !== '' ? stepOrderOf(routeForm.value.from_step_id) : NaN;
    return stepOptions.value.filter((o) => {
        if (String(o.id) === fromKey) return false;
        if (String(o.id) === String(routeForm.value.to_step_id)) return false;
        if (!Number.isNaN(fromOrder)) {
            const order = stepOrderOf(o.id);
            if (!Number.isNaN(order) && order < fromOrder) return false;
        }
        return true;
    });
});

function stepOrderOf(id) {
    return Number(
        ((activeDef.value?.steps || tableSteps.value || []).find((s) => String(s.id) === String(id))?.order_number ?? NaN),
    );
}

// Client-side mirror of the backend route guards (forward-only, no
// self-loops, no duplicate From → To). The API re-validates everything.
function routeClientError() {
    const from = routeForm.value.from_step_id;
    const to = routeForm.value.to_step_id;
    if (from == null || from === '' || to == null || to === '') return "Select both From Step and To Step.";
    if (String(from) === String(to)) return "From and To cannot be the same step.";
    const fromOrder = stepOrderOf(from);
    const toOrder = stepOrderOf(to);
    if (Number.isNaN(fromOrder) || Number.isNaN(toOrder)) return "Both steps must belong to this workflow.";
    if (toOrder < fromOrder) return `Routes must move forward: Step ${fromOrder} → Step ${toOrder} is not allowed.`;
    const clash = (activeDef.value?.routes || tableRoutes.value || []).find(
        (r) =>
            String(r.from_step_id) === String(from) &&
            String(r.to_step_id) === String(to) &&
            String(r.id) !== String(routeForm.value.id) &&
            String(r.client_id ?? r.id) !== String(routeForm.value.client_id ?? routeForm.value.id),
    );
    if (clash) return "This route already exists (same From → To), regardless of action.";
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
        arr.sort((a, b) => (Number(a.order_number) || 0) - (Number(b.order_number) || 0));
    }
    const out = [];
    const walk = (parentKey, depth, prefix) => {
        for (const s of (byParent.get(parentKey) || [])) {
            const num = prefix ? `${prefix}.${s.order_number}` : `${s.order_number}`;
            out.push({
                ...s,
                _depth: depth,
                _num: num,
                parent_name: s.parent_id ? byId.get(s.parent_id)?.name ?? null : null,
            });
            walk(s.id, depth + 1, num);
        }
    };
    walk(0, 0, "");
    for (const s of list) {
        if (s.parent_id && !byId.has(s.parent_id) && !out.some((r) => r.id === s.id)) {
            out.push({ ...s, _depth: 0, _num: `${s.order_number}`, parent_name: null });
        }
    }
    return out;
});

function descendantsOfStep(id) {
    const ids = new Set([id]);
    let grew = true;
    while (grew) {
        grew = false;
        for (const s of (tableSteps.value || [])) {
            if (s.parent_id && ids.has(s.parent_id) && !ids.has(s.id)) {
                ids.add(s.id);
                grew = true;
            }
        }
    }
    return ids;
}

// Routes table: forward-only, ordered start→end by station order.
const sortedRoutes = computed(() => {
    const orderOf = (id) =>
        Number((activeDef.value?.steps || tableSteps.value || []).find((s) => String(s.id) === String(id))?.order_number ?? 9999);
    return [...(activeDef.value?.routes || tableRoutes.value || [])].sort((a, b) => {
        return orderOf(a.from_step_id) - orderOf(b.from_step_id) || orderOf(a.to_step_id) - orderOf(b.to_step_id);
    });
});

// Fixed page size (7) keeps both tables the same height; short last pages
// are padded with skeleton rows so the footer never jumps.
const STEP_PAGE_SIZE = 7;
const ROUTE_PAGE_SIZE = 7;
const stepPage = ref(1);
const routePage = ref(1);
// True while the selected type's definitions resolve (cold or warm cache).
// Skeletons key off this — not just `loading` — so cached instant-paint
// never flashes the wrong "no workflow" state while a type switch settles.
const resolvingSteps = ref(false);

const stepFillerCount = computed(() => {
    if (loading.value) return 0;
    const total = flatStepRows.value.length;
    if (!total) return 0;
    const rest = total - (stepPage.value - 1) * STEP_PAGE_SIZE;
    return STEP_PAGE_SIZE - Math.min(Math.max(rest, 0), STEP_PAGE_SIZE);
});

const routeFillerCount = computed(() => {
    if (loading.value) return 0;
    const total = sortedRoutes.value.length;
    if (!total) return 0;
    const rest = total - (routePage.value - 1) * ROUTE_PAGE_SIZE;
    return ROUTE_PAGE_SIZE - Math.min(Math.max(rest, 0), ROUTE_PAGE_SIZE);
});

// Keep the current page valid when rows are added/removed.
watch([flatStepRows, sortedRoutes], () => {
    const maxStep = Math.max(1, Math.ceil(flatStepRows.value.length / STEP_PAGE_SIZE));
    if (stepPage.value > maxStep) stepPage.value = maxStep;
    const maxRoute = Math.max(1, Math.ceil(sortedRoutes.value.length / ROUTE_PAGE_SIZE));
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
    const banned = stepForm.value.id ? descendantsOfStep(stepForm.value.id) : new Set();
    return flatStepRows.value
        .filter((s) => !banned.has(s.id))
        .map((s) => ({ id: s.id, label: `${s._num}. ${s.name}` }));
});

const stepHeaders = [
    { title: "#", key: "order_number" },
    { title: "Code", key: "code" },
    { title: "Name", key: "name" },
    { title: "Stage", key: "stage" },
    { title: "SLA (min)", key: "sla_minutes" },
    { title: "Destination Office", key: "office_id", sortable: false },
    { title: "Roles", key: "role_ids", sortable: false },
    { title: "Flags", key: "flags", sortable: false },
    { title: "", key: "actions", sortable: false },
];

const routeHeaders = [
    { title: "From", key: "from_step_id" },
    { title: "To", key: "to_step_id" },
    { title: "Action", key: "action_code" },
    { title: "Group", key: "route_group" },
    { title: "Req Approvals", key: "required_approvals_count" },
    { title: "Condition", key: "condition_expression", sortable: false },
    { title: "", key: "actions", sortable: false },
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
        error.value = e?.response?.data?.message || "Failed to load transaction types.";
        activeDef.value = null;
    } finally {
        resolvingSteps.value = false;
    }
});

// Latest = live. Effective editor target: the open draft if any,
// otherwise the latest published. Everything older is history.
const draftDef = computed(() => (defs.value || []).find((d) => d.status === "draft") || null);

const publishedDefs = computed(() =>
    (defs.value || []).filter((d) => d.status === "published"),
);

// Live-flagged version wins; fallback to the highest published version
// for rows predating the backfill.
const currentDef = computed(
    () => (defs.value || []).find((d) => d.is_live) || publishedDefs.value[0] || null,
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
        notice.value = "Live version switched — new transactions use it. Old versions kept.";
    } catch (e) {
        error.value = e?.response?.data?.message || "Switching live version failed.";
        liveDialog.value = false;
    } finally {
        saving.value = false;
    }
}

function isLiveDef(def) {
    return !!def && def.status === "published" && currentDef.value && Number(currentDef.value.id) === Number(def.id);
}

const historyDefs = computed(() =>
    (defs.value || []).filter((d) => !activeDef.value || Number(d.id) !== Number(activeDef.value.id)),
);

function selectEffective() {
    activeDef.value = draftDef.value || currentDef.value || defs.value[0] || null;
}

// Staged editing: dialogs mutate the working copy only. Nothing reaches
// the network until Save version (bulk apply). No draft is created, no
// publish attempted — the viewed/working rows ARE the edit target.
function workingRowFor(item) {
    // Viewing a history version while staging: map by code onto the working
    // copy so edits land on staged rows, never on the viewed snapshot.
    if (!item) return item;
    const code = item.code;
    const hit = (tableSteps.value || []).find((s) => code && s.code === code);
    return hit || item;
}

function stepRouteTarget(item) {
    // Sub-pages address rows by id; the working copy is the single scope,
    // so map history-viewed rows onto it by code first.
    const row = workingRowFor(item);
    if (!row?.id || isTmpRow(row) || !stagingSourceDefId.value) return null;
    return { defId: stagingSourceDefId.value, stepId: row.id };
}

function goStepChecklist(item) {
    error.value = "";
    notice.value = "";
    const target = stepRouteTarget(item);
    if (!target) return;
    const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
    router.push({ path: `/admin/workflows/${target.defId}/steps/${target.stepId}/checklist`, query: q });
}

function workingRouteFor(route) {
    if (!route) return route;
    const rows = tableRoutes.value || [];
    const byId = rows.find((r) => String(r.id) === String(route.id));
    if (byId) return byId;
    const stepsOf = (id) => (tableSteps.value || []).find((s) => String(s.id) === String(id))?.code;
    const from = stepsOf(route.from_step_id);
    const to = stepsOf(route.to_step_id);
    return (
        rows.find((r) => {
            const rf = (tableSteps.value || []).find((s) => String(s.id) === String(r.from_step_id))?.code;
            const rt = (tableSteps.value || []).find((s) => String(s.id) === String(r.to_step_id))?.code;
            return rf === from && rt === to && r.action_code === route.action_code;
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
            message: "You have unsaved staged changes. View this version anyway? Your staged edits stay until you Save or Discard.",
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
            notice.value = "Saved as draft — add a start and an end step to go live.";
        } else {
            throw e;
        }
    }
}

// Add Step: reuse the open draft (one-draft-max, enforced server-side
// too); create one only if none exists. Then open the step form.
async function clickAddStep() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await ensureDraft();
        openStepDialog();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function clickAddRoute() {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        await ensureDraft();
        openRouteDialog();
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

function stepInDraft(oldSteps, item) {
    // Clones preserve codes (unique per flow): map the viewed step to
    // its draft twin so edits always land on the draft.
    const code = (oldSteps || []).find((s) => Number(s.id) === Number(item?.id))?.code || item?.code;
    return (
        (activeDef.value?.steps || []).find((s) => code && s.code === code) || item
    );
}

async function editStep(item) {
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        openStepDialog(stepInDraft(oldSteps, item));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare step form.";
    } finally {
        saving.value = false;
    }
}

async function goStepFields(item) {
    error.value = "";
    notice.value = "";
    try {
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        const fresh = stepInDraft(oldSteps, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${activeDef.value.id}/steps/${fresh.id}/fields`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step fields.";
    }
}

function liveEditableTarget() {
    // Requirements/step data apply to running papers immediately, so
    // open them on the published transaction type — not an open draft clone.
    return currentDef.value || activeDef.value;
}

function stepOnDef(def, item) {
    return (def?.steps || []).find((s) => s.code && s.code === item?.code) || item;
}

async function goStepRequirements(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${target.id}/steps/${fresh.id}/requirements`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step requirements.";
    }
}

async function goStepData(item) {
    error.value = "";
    notice.value = "";
    try {
        const target = liveEditableTarget();
        if (!target?.id || !item?.id) return;
        const fresh = stepOnDef(target, item);
        const q = selectedTypeId.value ? { type: Number(selectedTypeId.value) } : {};
        router.push({ path: `/admin/workflows/${target.id}/steps/${fresh.id}/step-data`, query: q });
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to open step data.";
    }
}

function routeInDraft(oldSteps, route) {
    // Routes have no codes: match by endpoint step codes + action.
    const oldCode = (id) => (oldSteps || []).find((s) => Number(s.id) === Number(id))?.code;
    const newCode = (id) => (activeDef.value?.steps || []).find((s) => Number(s.id) === Number(id))?.code;
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
        const oldSteps = activeDef.value?.steps || [];
        await ensureDraft();
        openRouteDialog(routeInDraft(oldSteps, route));
    } catch (e) {
        error.value = e?.response?.data?.message || "Failed to prepare route form.";
    } finally {
        saving.value = false;
    }
}

// Save version: names what you are viewing and stores it as a brand-new
// live version (steps + routes cloned). Press again with another name
// for another live version — old ones are always kept.
const saveDialog = ref(false);
const saveName = ref("");
const saveNotes = ref("");
// Overwrite = persist staged edits onto the open draft (stays draft, same
// version). Create new = persist + publish as a new live version.
const saveMode = ref("overwrite");

function openSaveDialog() {
    const def = activeDef.value;
    if (!def) return;
    if (!stagingDirty.value) {
        notice.value = "Nothing staged — no changes to save yet. Edit steps, routes, requirements, checklists, or fields first.";
        return;
    }
    error.value = "";
    notice.value = "";
    saveMode.value = "overwrite";
    saveName.value = def.name ?? "";
    saveNotes.value = "";
    saveDialog.value = true;
}

async function confirmSave() {
    const typeId = selectedTypeId.value;
    const defId = stagingSourceDefId.value;
    if (!typeId || !defId) return;
    const name = saveName.value.trim();
    if (saveMode.value === "create-new" && !name) {
        error.value = "Give the new version a name first.";
        return;
    }
    error.value = "";
    notice.value = "";
    saving.value = true;
    try {
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
            notice.value = "Saved to the open draft — not live yet. Use Make live (or save as a new version) when ready.";
        }
    } catch (e) {
        error.value =
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

// SLA duration picker (picker-only, up to 30 days).
// Backend still stores total minutes (integer >= 0);
// the clock dial is reinterpreted as HH:MM duration + Days.
const SLA_MAX_DAYS = 30;
const SLA_MAX_TOTAL = SLA_MAX_DAYS * 24 * 60; // 43200
const slaDays = ref(0);
const slaTime = ref("01:00");
const slaTimeMenu = ref(false);
const slaPresets = [
    { label: "30m", days: 0, time: "00:30" },
    { label: "2h", days: 0, time: "02:00" },
    { label: "8h", days: 0, time: "08:00" },
    { label: "1d", days: 1, time: "00:00" },
    { label: "3d", days: 3, time: "00:00" },
    { label: "7d", days: 7, time: "00:00" },
];

function parseSlaTime(t) {
    const m = String(t || "00:00").match(/^(\d{1,2}):(\d{1,2})/);
    if (!m) return { h: 0, min: 0 };
    return {
        h: Math.min(23, Math.max(0, Number(m[1] || 0))),
        min: Math.min(59, Math.max(0, Number(m[2] || 0))),
    };
}

function minutesToSla(total) {
    const t = Math.max(0, Number(total || 0));
    const days = Math.floor(t / 1440);
    const rest = t - days * 1440;
    const h = String(Math.floor(rest / 60)).padStart(2, "0");
    const min = String(rest % 60).padStart(2, "0");
    return { days, time: `${h}:${min}` };
}

const slaTotal = computed(() => {
    const { h, min } = parseSlaTime(slaTime.value);
    return Number(slaDays.value || 0) * 1440 + h * 60 + min;
});

const slaTimeDisplay = computed(() => {
    const { h, min } = parseSlaTime(slaTime.value);
    return `${String(h).padStart(2, "0")}:${String(min).padStart(2, "0")}`;
});

const slaHuman = computed(() => {
    const d = Number(slaDays.value || 0);
    const { h, min } = parseSlaTime(slaTime.value);
    const parts = [];
    if (d) parts.push(`${d}d`);
    if (h) parts.push(`${h}h`);
    if (min) parts.push(`${min}m`);
    return parts.length ? parts.join(" ") : "0m";
});

const slaError = computed(() => {
    if (Number(slaDays.value || 0) < 0 || Number(slaDays.value || 0) > SLA_MAX_DAYS)
        return `Days must be 0-${SLA_MAX_DAYS}.`;
    if (slaTotal.value > SLA_MAX_TOTAL)
        return `Max SLA is 30 days (${SLA_MAX_TOTAL} min).`;
    return "";
});

function applySlaPreset(p) {
    slaDays.value = p.days;
    slaTime.value = p.time;
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
    const init = minutesToSla(step?.sla_minutes ?? 60);
    slaDays.value = Math.min(SLA_MAX_DAYS, init.days);
    slaTime.value = init.time;
    slaTimeMenu.value = false;
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
            sla_minutes: step.sla_minutes ?? 0,
            is_start: !!step.is_start,
            is_end: !!step.is_end,
            role_ids: [...(step.role_ids ?? step.roles?.map?.((r) => r.id) ?? [])],
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
            sla_minutes: 60,
            is_start: false,
            is_end: false,
            role_ids: [],
        };
    }
    stepDialog.value = true;
}

function saveStep() {
    // Staged: no network, no draft creation, no publish. The row lands in
    // the working copy (new rows get a tmp id) until Save version.
    error.value = "";
    notice.value = "";
    if (slaError.value) {
        error.value = slaError.value;
        return;
    }
    if (!selectedTypeId.value) {
        error.value = "Pick a transaction type first.";
        return;
    }
    staging.upsertStep(selectedTypeId.value, {
        id: stepForm.value.id ?? undefined,
        client_id: stepForm.value.client_id ?? undefined,
        code: stepForm.value.code ?? null,
        parent_id: stepForm.value.parent_id ?? null,
        order_number: Number(stepForm.value.order_number),
        name: stepForm.value.name,
        stage: stepForm.value.stage || null,
        office_id: stepForm.value.office_id ?? null,
        sla_minutes: slaTotal.value,
        is_start: !!stepForm.value.is_start,
        is_end: !!stepForm.value.is_end,
        role_ids: (stepForm.value.role_ids || []).map(Number),
    });
    stepDialog.value = false;
    notice.value = "Step staged — press Save version to persist it.";
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

function openRouteDialog(route = null) {
    error.value = "";
    routeError.value = "";
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
    }
    routeDialog.value = true;
}

function saveRoute() {
    // Staged: no network, no draft creation, no publish.
    error.value = "";
    routeError.value = "";
    notice.value = "";
    if (!selectedTypeId.value) {
        error.value = "Pick a transaction type first.";
        return;
    }
    // Instant client guard (backend + staging service re-validate):
    // forward-only, no self-loops, no duplicate From → To.
    const guard = routeClientError();
    if (guard) {
        routeError.value = guard;
        return;
    }
    let cond = null;
    try {
        if (routeForm.value.condition_expression_json?.trim()) {
            cond = JSON.parse(routeForm.value.condition_expression_json);
        }
    } catch {
        routeError.value = "Condition must be valid JSON.";
        return;
    }

    staging.upsertRoute(selectedTypeId.value, {
        id: routeForm.value.id ?? undefined,
        client_id: routeForm.value.client_id ?? undefined,
        from_step_id: routeForm.value.from_step_id,
        to_step_id: routeForm.value.to_step_id,
        action_code: routeForm.value.action_code,
        // Return routes are retired: routes are forward-only.
        is_return_route: false,
        route_group: routeForm.value.route_group || null,
        required_approvals_count: routeForm.value.required_approvals_count
            ? Number(routeForm.value.required_approvals_count)
            : null,
        condition_expression: cond,
    });
    routeDialog.value = false;
    notice.value = "Route staged — press Save version to persist it.";
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
    if (deepType && (types.value || []).some((t) => Number(t.id) === deepType)) {
        if (Number(selectedTypeId.value) !== deepType) selectedTypeId.value = deepType;
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
/* Tabbed Steps/Routes: panes keep their own min-height stages, and the
   window reserves the tallest footprint so switching never shifts. */
.wf-tabs-window {
    min-height: 580px;
}
.skel-fill td {
    height: 38px;
    background: #fff;
}
html.dark .skel-fill td {
    background: #1e1e2e;
}
</style>
