<template>
    <LoadingVeil
        :show="loading"
        label="transaction types"
        icon="mdi-format-list-bulleted-type"
    />
    <v-card rounded="0" elevation="0" class="tt-page mb-4">
        <header class="tt-hd">
            <div class="tt-badge" aria-hidden="true">
                <v-icon size="26">mdi-format-list-bulleted</v-icon>
            </div>
            <div class="tt-hd-main">
                <h1 class="tt-title">Transaction Types</h1>
                <p class="tt-sub">
                    The kinds of transactions your offices can start, and the
                    steps each one follows.
                </p>
            </div>
            <div class="tt-tools">
                <div class="tt-search" role="search">
                    <v-icon class="tt-search-icon" size="19"
                        >mdi-magnify</v-icon
                    >
                    <input
                        ref="searchInput"
                        v-model="search"
                        type="search"
                        class="tt-search-input"
                        placeholder="Search code, name or description"
                        aria-label="Search transaction types"
                        autocomplete="off"
                    />
                    <button
                        v-if="search"
                        type="button"
                        class="tt-clear"
                        aria-label="Clear search"
                        @click="clearSearch"
                    >
                        <v-icon size="16">mdi-close</v-icon>
                    </button>
                </div>
                <button
                    v-if="canManage"
                    type="button"
                    class="tt-add"
                    aria-label="Add transaction type"
                    @click="openCreate"
                >
                    <v-icon size="18">mdi-plus</v-icon>
                    <span class="tt-add-label">Add transaction type</span>
                </button>
            </div>
        </header>

        <v-alert
            v-if="error"
            type="error"
            variant="tonal"
            rounded="0"
            class="tt-alert"
        >
            {{ error }}
        </v-alert>

        <div class="tt-wrap">
            <v-data-table
                v-show="!loading"
                v-model:page="page"
                :items="filtered"
                :headers="headers"
                :loading="loading"
                item-key="id"
                :items-per-page="PER_PAGE"
                :hide-default-footer="true"
                hover
                class="tt-table"
            >
                <template v-slot:[`item.code`]="{ item }">
                    <span class="tt-code" :title="item.code">{{
                        item.code
                    }}</span>
                </template>

                <template v-slot:[`item.name`]="{ item }">
                    <span class="tt-name" v-tooltip="item.name">{{
                        item.name
                    }}</span>
                </template>

                <template v-slot:[`item.description`]="{ item }">
                    <span class="tt-desc" :title="item.description || ''">{{
                        item.description || "—"
                    }}</span>
                </template>

                <template v-slot:[`item.steps`]="{ item }">
                    <v-progress-circular
                        v-if="stepsLoading && !stepsOf(item)"
                        indeterminate
                        size="16"
                        width="2"
                        color="primary"
                    />
                    <button
                        v-else-if="stepsOf(item)"
                        type="button"
                        class="tt-steps"
                        :class="{ 'is-static': !isSuperadmin }"
                        :disabled="!isSuperadmin"
                        :title="`Open workflow steps for ${item.name || item.code}`"
                        @click="goSteps(item)"
                    >
                        <v-icon size="15">mdi-format-list-bulleted</v-icon>
                        {{ stepsOf(item).count }}
                        {{ stepsOf(item).count === 1 ? "step" : "steps" }}
                    </button>
                    <button
                        v-else-if="isSuperadmin"
                        type="button"
                        class="tt-steps is-empty"
                        title="Add first step"
                        @click="goSteps(item)"
                    >
                        <v-icon size="15">mdi-plus</v-icon>
                        Add step
                    </button>
                    <span v-else class="tt-dash">—</span>
                </template>

                <template v-slot:[`item.offices`]="{ item }">
                    <div v-if="(item.offices || []).length" class="tt-offices">
                        <span
                            v-for="o in item.offices"
                            :key="o.id"
                            class="tt-office is-specific"
                            v-tooltip="o.name"
                            :aria-label="o.name"
                        >
                            <img
                                v-if="officeIcon(o)"
                                class="tt-office-icon"
                                :src="officeIcon(o)"
                                :alt="`${o.name} icon`"
                            />
                            <span
                                v-else
                                class="tt-office-icon-placeholder"
                                aria-label="No office icon"
                            >
                                ?
                            </span>
                            <span class="tt-office-text">{{ o.code }}</span>
                        </span>
                    </div>
                    <span
                        v-else
                        class="tt-office"
                        v-tooltip="'Available to every office'"
                    >
                        <img
                            class="tt-office-icon"
                            :src="anyOfficeIcon"
                            alt="Zamboanga City seal"
                        />
                        <span class="tt-office-text">Any Office</span>
                    </span>
                </template>

                <template v-slot:[`item.is_active`]="{ item }">
                    <v-menu open-on-hover location="end" open-delay="250">
                        <template #activator="{ props }">
                            <button
                                type="button"
                                class="tt-status"
                                :class="{ 'is-off': !item.is_active }"
                                v-bind="props"
                                :title="`Workflow versions for ${item.name || item.code}`"
                            >
                                <span
                                    class="tt-status-dot"
                                    aria-hidden="true"
                                />
                                {{ item.is_active ? "Active" : "Inactive" }}
                            </button>
                        </template>
                        <v-card
                            rounded="0"
                            min-width="340"
                            max-width="420"
                            class="tt-vermenu"
                        >
                            <v-card-title
                                class="text-subtitle-2 font-weight-bold pa-3"
                            >
                                Workflow versions · {{ item.name || item.code }}
                                <div
                                    class="text-caption text-medium-emphasis font-weight-medium"
                                >
                                    New transactions use the live version · old
                                    versions are kept
                                </div>
                            </v-card-title>
                            <v-divider />
                            <v-list density="compact" class="py-1">
                                <v-list-item v-if="!defsOf(item).length">
                                    <v-list-item-title
                                        class="text-medium-emphasis"
                                        >No workflow yet</v-list-item-title
                                    >
                                    <v-list-item-subtitle
                                        >Open Steps to create version
                                        1</v-list-item-subtitle
                                    >
                                </v-list-item>
                                <v-list-item
                                    v-for="d in defsOf(item)"
                                    :key="d.id"
                                    :active="isLiveDef(d, item)"
                                    rounded="0"
                                >
                                    <template #prepend>
                                        <v-icon
                                            :color="wfStatusColor(d.status)"
                                            size="small"
                                            >{{
                                                wfStatusIcon(d.status)
                                            }}</v-icon
                                        >
                                    </template>
                                    <v-list-item-title class="font-weight-bold">
                                        v{{ d.version
                                        }}<span v-if="d.name">
                                            · {{ d.name }}</span
                                        >
                                        · {{ (d.steps || []).length }} steps
                                        <v-chip
                                            v-if="isLiveDef(d, item)"
                                            color="success"
                                            variant="flat"
                                            rounded="0"
                                            size="x-small"
                                            class="ml-1 font-weight-bold"
                                        >
                                            ACTIVE
                                        </v-chip>
                                    </v-list-item-title>
                                    <v-list-item-subtitle>
                                        {{ wfStatusLabel(d.status)
                                        }}<span v-if="d.published_at">
                                            ·
                                            {{ fmtDate(d.published_at) }}</span
                                        ><span v-else-if="d.status === 'draft'">
                                            · publish first to go live</span
                                        >
                                    </v-list-item-subtitle>
                                    <template #append>
                                        <v-btn
                                            v-if="
                                                d.status === 'published' &&
                                                !isLiveDef(d, item)
                                            "
                                            size="x-small"
                                            variant="outlined"
                                            color="grey-darken-3"
                                            rounded="0"
                                            class="font-weight-bold"
                                            v-tooltip="
                                                'Make this version live for new transactions'
                                            "
                                            @click="askMakeLive(item, d)"
                                        >
                                            Make live
                                        </v-btn>
                                        <v-btn
                                            icon="mdi-eye"
                                            v-tooltip="'View steps'"
                                            size="x-small"
                                            variant="text"
                                            rounded="0"
                                            color="primary"
                                            @click="goSteps(item)"
                                        />
                                    </template>
                                </v-list-item>
                            </v-list>
                        </v-card>
                    </v-menu>
                </template>

                <template v-slot:[`item.actions`]="{ item }">
                    <div v-if="canManage" class="tt-actions">
                        <v-btn
                            class="tt-ib is-edit"
                            icon="mdi-pencil"
                            aria-label="Edit transaction type"
                            v-tooltip="'Edit transaction type'"
                            size="small"
                            variant="outlined"
                            rounded="0"
                            @click="openEdit(item)"
                        />
                        <v-btn
                            class="tt-ib is-delete"
                            icon="mdi-delete"
                            aria-label="Delete transaction type"
                            v-tooltip="'Delete transaction type'"
                            size="small"
                            variant="outlined"
                            rounded="0"
                            @click="removeRow(item)"
                        />
                    </div>
                </template>

                <template #no-data>
                    <div class="tt-empty">
                        <template v-if="search.trim()">
                            <b>No matches</b> for “{{ search.trim() }}”. Try a
                            different word.
                        </template>
                        <template v-else>
                            <b>No transaction types yet.</b>
                            <span v-if="canManage">
                                Use “Add transaction type” to create the first
                                one.
                            </span>
                        </template>
                    </div>
                </template>

                <template #body.append>
                    <tr
                        v-for="n in ghostRows"
                        :key="`ghost-${n}`"
                        class="tt-ghost"
                        aria-hidden="true"
                    >
                        <td v-for="h in headers" :key="h.key" />
                    </tr>
                </template>
            </v-data-table>
        </div>

        <footer class="tt-pg">
            <div class="tt-per">
                <span>Items per page</span>
                <span class="tt-per-box" aria-label="Items per page: 8">
                    <span>8</span>
                    <v-icon size="18" aria-hidden="true"
                        >mdi-chevron-down</v-icon
                    >
                </span>
            </div>
            <span class="tt-range">{{ rangeLabel }}</span>
            <div class="tt-pn" role="group" aria-label="Pagination">
                <button
                    type="button"
                    :disabled="page <= 1"
                    aria-label="First page"
                    @click="goPage(1)"
                >
                    <v-icon size="18">mdi-page-first</v-icon>
                </button>
                <button
                    type="button"
                    :disabled="page <= 1"
                    aria-label="Previous page"
                    @click="goPage(page - 1)"
                >
                    <v-icon size="18">mdi-chevron-left</v-icon>
                </button>
                <button
                    type="button"
                    :disabled="page >= pageCount"
                    aria-label="Next page"
                    @click="goPage(page + 1)"
                >
                    <v-icon size="18">mdi-chevron-right</v-icon>
                </button>
                <button
                    type="button"
                    :disabled="page >= pageCount"
                    aria-label="Last page"
                    @click="goPage(pageCount)"
                >
                    <v-icon size="18">mdi-page-last</v-icon>
                </button>
            </div>
        </footer>
    </v-card>

    <v-dialog v-model="dialog" max-width="560" scrollable>
        <v-card rounded="xl" style="overflow: hidden">
            <v-card-title class="ntt-hd">
                <v-avatar
                    color="primary"
                    variant="tonal"
                    rounded="lg"
                    size="44"
                    class="ntt-badge"
                >
                    <v-icon color="primary"
                        >mdi-file-document-plus-outline</v-icon
                    >
                </v-avatar>
                <div class="ntt-hd-t">
                    <div class="ntt-title">
                        {{
                            form.id
                                ? "Edit Transaction Type"
                                : "New Transaction Type"
                        }}
                    </div>
                    <div class="ntt-sub">
                        {{
                            form.id
                                ? "Update the details and which offices can use it."
                                : "Define a transaction and choose which offices can use it."
                        }}
                    </div>
                </div>
                <v-btn
                    icon="mdi-close"
                    variant="text"
                    size="small"
                    color="grey-darken-3"
                    class="ntt-x"
                    @click="dialog = false"
                />
            </v-card-title>
            <v-divider />
            <v-card-text class="ntt-bd">
                <v-alert
                    v-if="dialogError"
                    type="error"
                    variant="tonal"
                    density="compact"
                    class="mb-4"
                    >{{ dialogError }}</v-alert
                >

                <div class="ntt-f">
                    <label class="ntt-lb" for="ntt-name"
                        >Name <span class="ntt-req">*</span></label
                    >
                    <v-text-field
                        id="ntt-name"
                        v-model="form.name"
                        placeholder="e.g. Purchase Request"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        :error-messages="fieldErrors.name"
                        class="ntt-in"
                        @update:model-value="clearFieldError('name')"
                    />
                </div>

                <div class="ntt-f">
                    <label class="ntt-lb" for="ntt-code"
                        >Code <span class="ntt-req">*</span></label
                    >
                    <v-text-field
                        id="ntt-code"
                        v-model="form.code"
                        placeholder="purchase_request"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        spellcheck="false"
                        :error-messages="fieldErrors.code"
                        class="ntt-in ntt-mono"
                        @update:model-value="clearFieldError('code')"
                    />
                    <div v-if="!fieldErrors.code" class="ntt-help">
                        Lowercase letters, numbers and underscores only.
                    </div>
                </div>

                <div class="ntt-f">
                    <label class="ntt-lb" for="ntt-desc">Description</label>
                    <v-textarea
                        id="ntt-desc"
                        v-model="form.description"
                        placeholder="What is this transaction used for?"
                        rows="3"
                        maxlength="200"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        :error-messages="fieldErrors.description"
                        class="ntt-in"
                        @update:model-value="clearFieldError('description')"
                    />
                    <div v-if="!fieldErrors.description" class="ntt-help">
                        {{ (form.description || "").length }}/200 characters
                    </div>
                </div>

                <div class="ntt-f">
                    <label class="ntt-lb" for="ntt-offices">Allowed Office</label>
                    <v-select
                        v-if="isSuperadmin"
                        id="ntt-offices"
                        :model-value="form.office_ids[0] ?? ALL_OFFICES"
                        @update:model-value="setSelectedOffice"
                        :items="officeOptions"
                        item-title="title"
                        item-value="id"
                        :item-props="officeItemProps"
                        placeholder="Select office"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        :error-messages="fieldErrors.office_ids"
                        class="ntt-in ntt-offices"
                    >
                        <template #selection="{ item }">
                            <span class="ntt-office-selection">
                                <img
                                    v-if="item.raw.icon"
                                    class="ntt-office-chip-icon"
                                    :src="item.raw.icon"
                                    :alt="item.title === 'Any Office' ? 'Zamboanga City seal' : `${item.raw.subtitle} icon`"
                                />
                                <span
                                    v-else
                                    class="ntt-office-chip-icon-placeholder"
                                    aria-label="No office icon"
                                >
                                    ?
                                </span>
                                <span>{{ item.title }}</span>
                            </span>
                        </template>
                        <template #item="{ props: itemProps, item }">
                            <v-list-item v-bind="itemProps">
                                <template #prepend>
                                    <img
                                        v-if="item.raw.icon"
                                        class="ntt-office-option-icon"
                                        :src="item.raw.icon"
                                        :alt="`${item.raw.subtitle} icon`"
                                    />
                                    <span
                                        v-else
                                        class="ntt-office-option-icon-placeholder"
                                        aria-label="No office icon"
                                    >
                                        ?
                                    </span>
                                </template>
                            </v-list-item>
                        </template>
                    </v-select>
                    <v-alert
                        v-else
                        type="info"
                        variant="tonal"
                        density="compact"
                        class="mb-0"
                    >
                        Available to:
                        <b>{{
                            auth.user.value?.office?.name || "your office"
                        }}</b>
                        <div class="text-caption">
                            Office admins manage their own office's types;
                            clearing the list keeps your office assigned.
                        </div>
                    </v-alert>
                    <div
                        v-if="isSuperadmin && !fieldErrors.office_ids"
                        class="ntt-help"
                    >
                        Any Office means every office may create this type.
                    </div>
                </div>

                <div class="ntt-sw">
                    <div>
                        <div class="ntt-sw-t">{{ form.is_active ? "Active" : "Inactive" }}</div>
                        <div class="ntt-sw-d">
                            {{
                                form.is_active
                                    ? "Available for new requests"
                                    : "Hidden from new requests"
                            }}
                        </div>
                    </div>
                    <v-spacer />
                    <v-switch
                        v-model="form.is_active"
                        color="success"
                        density="compact"
                        hide-details
                        inset
                        class="ntt-sw-tg"
                    />
                </div>
            </v-card-text>
            <v-divider />
            <v-card-actions class="ntt-ft">
                <v-btn
                    variant="outlined"
                    rounded="lg"
                    class="ntt-b"
                    @click="dialog = false"
                    >Cancel</v-btn
                >
                <v-btn
                    color="primary"
                    rounded="lg"
                    class="ntt-b ntt-b-pri"
                    :loading="saving"
                    @click="save"
                    >Save</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>

    <v-dialog v-model="liveDialog" max-width="500">
        <v-card rounded="xl" style="overflow: hidden">
            <v-card-title>Switch live version?</v-card-title>
            <v-divider />
            <v-card-text>
                Change live from
                <b>v{{ liveFrom?.version ?? "—" }}</b> to
                <b>v{{ liveTarget?.version }}</b>
                for <b>{{ liveType?.name || liveType?.code }}</b
                >?
                <v-alert
                    type="info"
                    variant="tonal"
                    density="compact"
                    class="mt-3"
                >
                    New transactions will use v{{ liveTarget?.version }}.
                    Running transactions stay on their version. Old versions are
                    kept.
                </v-alert>
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end">
                <v-btn variant="text" @click="liveDialog = false">Cancel</v-btn>
                <v-btn
                    color="grey-darken-3"
                    rounded="0"
                    :loading="switching"
                    @click="confirmMakeLive"
                    >Switch</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useAuth, isOfficeAdminUser } from "@/composables/useAuth";
import { useTransactionTypes } from "@/composables/useTransactionTypes";
import { useWorkflows } from "@/composables/useWorkflows";
import { useOffices } from "@/composables/useOffices";
import {
    wfStatusColor,
    wfStatusIcon,
    wfStatusLabel,
} from "@/utils/workflowStatus";
import LoadingVeil from "@/components/LoadingVeil.vue";
import { anyOfficeIcon, officeIcon } from "@/utils/officeIcons";

const router = useRouter();
const auth = useAuth();
const { items, loading, fetchAll, create, update, remove } =
    useTransactionTypes();
const {
    defs,
    loading: defsLoading,
    fetchDefinitions,
    makeLive,
} = useWorkflows();
const { items: offices, fetchAll: fetchOffices } = useOffices();

const isSuperadmin = computed(() =>
    (auth.user.value?.roles ?? []).some((r) => r.code === "superadmin"),
);
const isOfficeAdmin = computed(() => isOfficeAdminUser(auth.user.value));
const canManage = computed(() => isSuperadmin.value || isOfficeAdmin.value);

// "Any Office" is the always-present first row. Storing no office rows means
// every office may use the type (see CreateTransactionRequest + the index
// filter). The sentinel is UI-only: save() strips it back to an empty list.
// Rows are two-line (code over full name): the chip shows `title` (the office
// code, or "Any Office"), the dropdown row adds `subtitle` (full name).
const ALL_OFFICES = "__all__";
const officeOptions = computed(() => [
    {
        id: ALL_OFFICES,
        title: "Any Office",
        subtitle: "Available to every office",
        icon: anyOfficeIcon,
    },
    ...(offices.value || []).map((o) => ({
        id: o.id,
        title: o.code || o.name,
        subtitle: o.name,
        icon: officeIcon(o),
    })),
]);
// Only `subtitle` is injected — Vuetify keeps item-title as the row title.
const officeItemProps = (item) => ({ subtitle: item.subtitle });

const headers = [
    { title: "Code", key: "code", width: "17%" },
    { title: "Name", key: "name", width: "18.5%" },
    { title: "Description", key: "description", width: "19%" },
    { title: "Allowed Office", key: "offices", sortable: false, width: "16.5%" },
    { title: "Status", key: "is_active", width: "9%" },
    { title: "Steps", key: "steps", sortable: false, width: "9%" },
    { title: "", key: "actions", sortable: false, width: "10%", align: "end" },
];

// Latest workflow version per type → its ordered 1-2-3 steps,
// same steps logic as offices (just versioned per type).
const latestByType = computed(() => {
    const map = {};
    for (const d of defs.value || []) {
        const tid = d.transaction_type_id;
        if (!map[tid] || Number(d.version) > Number(map[tid].version))
            map[tid] = d;
    }
    return map;
});

function stepsOf(item) {
    // Live version's steps (what new transactions follow); fallback to
    // the latest version when nothing is live yet.
    const d = liveDefOf(item) || latestByType.value[item.id];
    if (!d) return null;
    return {
        version: d.version,
        status: d.status,
        count: (d.steps || []).length,
    };
}

// All workflow versions for a type, newest first — shown in the
// Status-chip hover menu so live can be switched from and to.
function defsOf(item) {
    return (defs.value || [])
        .filter((d) => Number(d.transaction_type_id) === Number(item.id))
        .sort((a, b) => Number(b.version) - Number(a.version));
}

// Live version: the is_live flag wins; fallback to the highest
// published version for rows predating the backfill.
function liveDefOf(item) {
    const list = defsOf(item);
    return (
        list.find((d) => d.is_live) ||
        list
            .filter((d) => d.status === "published")
            .sort((a, b) => Number(b.version) - Number(a.version))[0] ||
        null
    );
}

function isLiveDef(d, item) {
    const live = liveDefOf(item);
    return !!live && Number(live.id) === Number(d.id);
}

function fmtDate(iso) {
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
const liveFrom = ref(null);
const liveType = ref(null);
const switching = ref(false);

function askMakeLive(item, d) {
    error.value = "";
    liveType.value = item;
    liveTarget.value = d;
    liveFrom.value = liveDefOf(item);
    liveDialog.value = true;
}

async function confirmMakeLive() {
    if (!liveTarget.value) return;
    switching.value = true;
    error.value = "";
    try {
        await makeLive(liveTarget.value.id);
        liveDialog.value = false;
        liveTarget.value = null;
        await fetchDefinitions();
    } catch (e) {
        error.value =
            e?.response?.data?.message || "Switching live version failed.";
        liveDialog.value = false;
    } finally {
        switching.value = false;
    }
}

const stepsLoading = computed(() => defsLoading.value);

function goSteps(item) {
    if (!isSuperadmin.value) return;
    router.push(`/admin/workflows?type=${item.id}`);
}

const dialog = ref(false);
const saving = ref(false);
const error = ref("");
const search = ref("");
const searchInput = ref(null);
const PER_PAGE = 8;
const page = ref(1);

// Client-side search: master data is small, filter loaded rows by
// code / name / description / office without extra requests.
const filtered = computed(() => {
    const q = String(search.value || "")
        .trim()
        .toLowerCase();
    if (!q) return items.value || [];
    return (items.value || []).filter((t) =>
        [
            t.code,
            t.name,
            t.description,
            (t.offices || []).map((o) => o.name).join(" "),
        ].some((v) =>
            String(v || "")
                .toLowerCase()
                .includes(q),
        ),
    );
});

const pageCount = computed(() =>
    Math.max(1, Math.ceil(filtered.value.length / PER_PAGE)),
);
const pageStart = computed(() =>
    filtered.value.length ? (page.value - 1) * PER_PAGE + 1 : 0,
);
const pageEnd = computed(() =>
    Math.min(page.value * PER_PAGE, filtered.value.length),
);
const rangeLabel = computed(() =>
    filtered.value.length
        ? `${pageStart.value}–${pageEnd.value} of ${filtered.value.length}`
        : "0 of 0",
);
// Keep the seven-row rhythm from the mockup: one empty row plus six ghosts
// when there are no results, otherwise fill only the remaining slots.
const ghostRows = computed(() => {
    const used = filtered.value.length
        ? Math.max(0, pageEnd.value - pageStart.value + 1)
        : 1;
    return Math.max(0, PER_PAGE - used);
});

function goPage(next) {
    page.value = Math.min(pageCount.value, Math.max(1, Number(next) || 1));
}

function clearSearch() {
    search.value = "";
    searchInput.value?.focus();
}

watch(search, () => {
    page.value = 1;
});
watch(
    () => filtered.value.length,
    (length) => {
        if (page.value > Math.ceil(length / PER_PAGE)) {
            page.value = Math.max(1, Math.ceil(length / PER_PAGE));
        }
    },
);

const form = ref({
    id: null,
    code: "",
    name: "",
    description: "",
    office_ids: [ALL_OFFICES],
    is_active: true,
});
// 422 field errors render under their inputs; `dialogError` holds anything
// that isn't field-specific (the page-level alert sits behind the dialog).
const fieldErrors = ref({});
const dialogError = ref("");

function clearFieldError(key) {
    if (!fieldErrors.value[key]) return;
    const next = { ...fieldErrors.value };
    delete next[key];
    fieldErrors.value = next;
}

function setSelectedOffice(value) {
    form.value.office_ids = [value ?? ALL_OFFICES];
    clearFieldError("office_ids");
}

// Stored office ids, or the ALL sentinel when the type has none.
function officeIdsOf(item) {
    const ids = (
        item.office_ids ??
        (item.offices || []).map((o) => o.id) ??
        []
    ).slice();
    return ids.length ? ids : [ALL_OFFICES];
}

function openCreate() {
    error.value = "";
    fieldErrors.value = {};
    dialogError.value = "";
    form.value = {
        id: null,
        code: "",
        name: "",
        description: "",
        office_ids: [ALL_OFFICES],
        is_active: true,
    };
    dialog.value = true;
}

function openEdit(item) {
    error.value = "";
    fieldErrors.value = {};
    dialogError.value = "";
    form.value = {
        id: item.id,
        code: item.code,
        name: item.name,
        description: item.description ?? "",
        office_ids: officeIdsOf(item),
        is_active: !!item.is_active,
    };
    dialog.value = true;
}

async function save() {
    saving.value = true;
    error.value = "";
    fieldErrors.value = {};
    dialogError.value = "";
    try {
        const payload = {
            code: form.value.code,
            name: form.value.name,
            description: form.value.description,
            is_active: form.value.is_active,
        };
        // Superadmin picks the offices; office admins keep their office's
        // existing assignments (backend enforces their office stays included).
        // Any Office is stored as "no office rows" — the sentinel is UI-only.
        if (isSuperadmin.value) {
            payload.office_ids = (form.value.office_ids || []).filter(
                (v) => v !== ALL_OFFICES,
            );
        }

        if (form.value.id) await update(form.value.id, payload);
        else await create(payload);

        dialog.value = false;
        await fetchAll();
    } catch (e) {
        // Server-side validation lands under the offending field; anything else
        // (network, 403, 500) shows at the top of the dialog body.
        const errs = e?.response?.data?.errors;
        if (errs && typeof errs === "object") {
            const first = (v) => (Array.isArray(v) ? v[0] : String(v ?? ""));
            fieldErrors.value = Object.fromEntries(
                Object.entries(errs).map(([key, value]) => [key, first(value)]),
            );
        } else {
            dialogError.value = e?.response?.data?.message || "Save failed.";
        }
    } finally {
        saving.value = false;
    }
}

async function removeRow(item) {
    error.value = "";
    try {
        await remove(item.id);
        await fetchAll();
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete failed.";
    }
}

onMounted(() => {
    // Independent lookups: run in parallel so one slow endpoint never blocks
    // the others. Each paints cache first, then revalidates silently.
    fetchAll().catch(() => {});
    fetchDefinitions().catch(() => {});
    fetchOffices().catch(() => {});
});
</script>

<style scoped>
/* ==========================================================================
   Transaction Types — sharp panel, header, table and footer
   (visual port of the supplied "Transaction Types" mockup)
   ========================================================================== */
.tt-page {
    --tt-ink: rgb(var(--v-theme-on-surface));
    --tt-muted: rgb(var(--v-theme-secondary));
    --tt-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --tt-panel: rgb(var(--v-theme-surface));
    --tt-field: #f4f6fb;
    --tt-hover: #f3f6fc;
    --tt-blue: #005EED;
    --tt-blue-bg: #e8eeff;
    --tt-ok: #1b7a3d;
    --tt-ok-bg: #e3f5ea;
    --tt-amber: #b86e00;
    --tt-amber-bg: #fff1d6;
    --tt-err: rgb(var(--v-theme-error));
    --tt-err-bg: rgba(var(--v-theme-error), 0.12);
    --tt-ring: rgba(29, 63, 174, 0.28);
    overflow: hidden;
    background: var(--tt-panel);
    border: 1px solid var(--tt-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}
html.dark .tt-page {
    --tt-field: #1c2645;
    --tt-hover: #1d2745;
    --tt-blue: #6f8cff;
    --tt-blue-bg: #25306a;
    --tt-ok: #3fbf6f;
    --tt-ok-bg: #16382a;
    --tt-amber: #ffbf47;
    --tt-amber-bg: #4a3510;
    --tt-err-bg: #4a1f22;
    --tt-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
.tt-page button:focus-visible,
.tt-page a:focus-visible {
    outline: 3px solid var(--tt-ring);
    outline-offset: 2px;
}

/* ---- Header ---- */
.tt-hd {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 22px 28px;
    border-bottom: 3px solid var(--tt-blue);
    flex-wrap: wrap;
}
.tt-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--tms-grad);
    color: #fff;
}
.tt-hd-main {
    flex: 1 1 320px;
    min-width: 0;
}
.tt-title {
    margin: 0;
    color: var(--tt-ink);
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}
.tt-sub {
    margin: 4px 0 0;
    color: var(--tt-muted);
    font-size: 13.5px;
    font-weight: 500;
    line-height: 1.4;
}
.tt-tools {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: nowrap;
    margin-left: auto;
}
.tt-search {
    position: relative;
    flex: 0 0 320px;
    min-width: 0;
    max-width: 320px;
}
.tt-search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--tt-muted);
    pointer-events: none;
}
.tt-search-input {
    width: 100%;
    height: 46px;
    padding: 0 42px;
    border: 1.5px solid var(--tt-line);
    border-radius: 0;
    background: var(--tt-field);
    color: var(--tt-ink);
    font: inherit;
    font-size: 14.5px;
    font-weight: 500;
    transition:
        border-color 0.15s,
        box-shadow 0.15s,
        background 0.15s;
}
.tt-search-input::placeholder {
    color: var(--tt-muted);
    opacity: 0.9;
}
.tt-search-input:hover {
    border-color: rgba(var(--v-border-color), 0.8);
}
.tt-search-input:focus {
    outline: none;
    border-color: var(--tt-blue);
    background: var(--tt-panel);
    box-shadow: 0 0 0 4px var(--tt-ring);
}
.tt-search-input::-webkit-search-cancel-button {
    display: none;
}
.tt-clear {
    position: absolute;
    right: 6px;
    top: 50%;
    display: grid;
    place-items: center;
    width: 34px;
    height: 34px;
    padding: 0;
    transform: translateY(-50%);
    border: 0;
    border-radius: 0;
    background: none;
    color: var(--tt-muted);
    cursor: pointer;
}
.tt-clear:hover {
    background: var(--tt-line);
}
.tt-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: 46px;
    padding: 0 20px;
    flex: none;
    border: 1.5px solid var(--tt-blue);
    border-radius: 0;
    background: var(--tms-grad);
    color: #fff;
    font: inherit;
    font-size: 14.5px;
    font-weight: 700;
    white-space: nowrap;
    cursor: pointer;
    transition: filter 0.15s;
}
.tt-add:hover {
    filter: brightness(0.94);
}

/* ---- Alerts + table shell ---- */
.tt-alert {
    margin: 16px 28px 0 !important;
    border-radius: 0 !important;
}
.tt-wrap {
    min-width: 0;
    padding: 20px 28px 0;
}
.tt-table {
    --v-table-row-height: var(--tms-row);
    --v-table-header-height: 44px;
    width: 100%;
    min-width: 0;
    background: transparent !important;
}
.tt-table :deep(.v-table__wrapper) {
    overflow-x: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--tt-muted) var(--tt-field);
}
.tt-table :deep(.v-table__wrapper::-webkit-scrollbar) {
    width: 10px;
    height: 10px;
}
.tt-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
    background: var(--tt-field);
}
.tt-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
    border: 2px solid var(--tt-field);
    background: var(--tt-muted);
}
.tt-table :deep(table) {
    width: 100%;
    min-width: 1100px;
    border-collapse: collapse;
    table-layout: fixed;
}
.tt-table :deep(thead th.v-data-table__th) {
    height: 44px;
    padding: 0 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--tt-line) !important;
    border-radius: 0 !important;
    background: var(--tt-field) !important;
    color: var(--tt-muted) !important;
    font-size: 12px !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-align: left;
    text-transform: uppercase;
    white-space: nowrap;
}
.tt-table :deep(thead th.v-data-table__th .v-data-table-header__content) {
    color: var(--tt-muted) !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-transform: uppercase;
}
.tt-table :deep(thead th.v-data-table__th .v-icon) {
    color: var(--tt-muted) !important;
    opacity: 0.65;
}
.tt-table :deep(thead th.v-data-table__th:last-child) {
    padding-left: 8px !important;
    text-align: right;
}
.tt-table :deep(tbody td:last-child) {
    padding-left: 8px !important;
}
.tt-table :deep(tbody td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--tt-line) !important;
    border-radius: 0 !important;
    color: var(--tt-ink);
    font-size: 14.5px;
    vertical-align: middle;
}
.tt-table :deep(tbody tr:not(.tt-ghost):hover) {
    background: var(--tt-hover) !important;
}
.tt-table :deep(tbody tr.tt-ghost) {
    pointer-events: none;
}
.tt-table :deep(tbody tr.tt-ghost td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border-bottom: 1px solid var(--tt-line) !important;
}
.tt-table :deep(.v-data-table-rows-no-data td) {
    height: var(--tms-row) !important;
    padding: 0 !important;
    border-bottom: 1px solid var(--tt-line) !important;
}
.tt-empty {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    min-height: var(--tms-row);
    padding: 0 14px;
    color: var(--tt-muted);
    font-size: 14px;
    font-weight: 500;
    text-align: center;
}
.tt-empty b {
    color: var(--tt-ink);
}

/* ---- Cells ---- */
.tt-code {
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    padding: 4px 9px;
    background: var(--tt-field);
    color: var(--tt-muted);
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 12.5px;
    text-overflow: ellipsis;
    vertical-align: middle;
    white-space: nowrap;
}
.tt-name {
    display: block;
    max-width: 100%;
    overflow: hidden;
    color: var(--tt-ink);
    font-size: 15px;
    font-weight: 600;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.tt-desc {
    display: block;
    max-width: 100%;
    color: var(--tt-muted);
    white-space: normal; /* wrap: full description is always visible */
    overflow-wrap: anywhere;
}
.tt-dash {
    color: var(--tt-muted);
}
.tt-steps {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 5px 10px;
    border: 0;
    border-radius: 0;
    background: var(--tt-blue-bg);
    color: var(--tt-blue);
    font: inherit;
    font-size: 13px;
    font-weight: 700;
    white-space: nowrap;
    cursor: pointer;
}
.tt-steps.is-static,
.tt-steps:disabled {
    cursor: default;
}
.tt-steps.is-empty {
    border: 1px solid var(--tt-line);
    background: transparent;
    color: var(--tt-muted);
}
.tt-offices {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
    min-width: 0;
}
.tt-office {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    max-width: 100%;
    min-width: 0;
    padding: 5px 10px;
    background: var(--tt-field);
    color: var(--tt-muted);
    font-size: 13px;
    font-weight: 600;
    text-align: left;
}
.tt-office-icon {
    width: 24px;
    height: 24px;
    flex: none;
    object-fit: contain;
}
.tt-office-text {
    min-width: 0;
    line-height: 1.35;
    overflow-wrap: anywhere;
    white-space: normal;
}
.tt-office-icon-placeholder {
    display: inline-flex;
    width: 24px;
    height: 24px;
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
.tt-office.is-specific {
    background: var(--tt-blue-bg);
    color: var(--tt-blue);
    font-weight: 700;
}
.tt-status {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 5px 11px;
    border: 0;
    border-radius: 0;
    background: var(--tt-ok-bg);
    color: var(--tt-ok);
    font: inherit;
    font-size: 12.5px;
    font-weight: 700;
    white-space: nowrap;
    cursor: pointer;
}
.tt-status.is-off {
    background: var(--tt-field);
    color: var(--tt-muted);
}
.tt-status-dot {
    width: 7px;
    height: 7px;
    flex: none;
    background: currentColor;
}
.tt-actions {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}

/* Workflow-version menu: reserve the action column and keep long version
   names from running underneath the Make live / view buttons. */
.tt-vermenu :deep(.v-list-item__content) {
    min-width: 0;
}
.tt-vermenu :deep(.v-list-item-title),
.tt-vermenu :deep(.v-list-item-subtitle) {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.tt-vermenu :deep(.v-list-item__append) {
    flex-shrink: 0;
    padding-left: 8px;
}
.tt-ib {
    width: 40px !important;
    min-width: 40px !important;
    height: 40px !important;
    padding: 0 !important;
    border: 1.5px solid var(--tt-line) !important;
    border-radius: 0 !important;
    background: transparent !important;
    color: var(--tt-muted) !important;
    box-shadow: none !important;
}
.tt-ib :deep(.v-icon) {
    font-size: 18px !important;
}
.tt-ib.is-edit {
    border-color: var(--tt-amber-bg) !important;
    color: var(--tt-amber) !important;
}
.tt-ib.is-edit:hover {
    background: var(--tt-amber-bg) !important;
}
.tt-ib.is-delete {
    border-color: var(--tt-err-bg) !important;
    color: var(--tt-err) !important;
}
.tt-ib.is-delete:hover {
    background: var(--tt-err-bg) !important;
}

/* ---- Footer ---- */
.tt-pg {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 20px;
    padding: 16px 28px 20px;
    color: var(--tt-muted);
    font-size: 14px;
    flex-wrap: wrap;
}
.tt-per {
    display: flex;
    align-items: center;
    gap: 10px;
}
.tt-per-box {
    display: inline-flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    min-width: 76px;
    height: 40px;
    padding: 0 8px 0 12px;
    border: 1.5px solid var(--tt-line);
    background: var(--tt-panel);
    color: var(--tt-ink);
    font-weight: 700;
}
.tt-per-box :deep(.v-icon) {
    color: var(--tt-muted);
}
.tt-range {
    color: var(--tt-ink);
    font-weight: 700;
}
.tt-pn {
    display: flex;
    gap: 4px;
}
.tt-pn button {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid var(--tt-line);
    border-radius: 0;
    background: var(--tt-panel);
    color: var(--tt-ink);
    cursor: pointer;
}
.tt-pn button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

@media (max-width: 900px) {
    .tt-tools {
        flex: 1 1 100%;
        margin-left: 0;
    }
    .tt-search {
        flex: 1 1 100%;
        max-width: none;
    }
}
@media (max-width: 760px) {
    .tt-hd {
        padding: 18px 16px;
    }
    .tt-title {
        font-size: 20px;
    }
    .tt-wrap {
        padding: 16px 16px 0;
    }
    .tt-pg {
        justify-content: center;
        padding: 16px;
    }
}
@media (max-width: 520px) {
    .tt-add {
        padding: 0 16px;
    }
    .tt-add-label {
        display: none;
    }
}
</style>

<style scoped>
/* ---- New / Edit Transaction Type modal (design mockup port) ---- */
/* Header: tinted badge + title + subtitle + close. */
.ntt-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 16px;
}
.ntt-badge {
    flex: none;
}
.ntt-hd-t {
    min-width: 0;
}
.ntt-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}
.ntt-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}
.ntt-x {
    margin-left: auto;
    flex: none;
}

/* Body: label / field / help rhythm, scrolling inside the dialog. */
.ntt-bd {
    padding: 18px 24px 8px;
}
.ntt-f {
    margin-bottom: 18px;
}
.ntt-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}
.ntt-req {
    color: rgb(var(--v-theme-error));
}
.ntt-help {
    margin: 6px 2px 0;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

/* Fields: 48px tall, radius 12, tinted fill, soft focus ring. */
.ntt-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}
.ntt-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}
.ntt-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(0, 94, 237, 0.18);
}
.ntt-mono :deep(input) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14.5px;
}

/* Offices: two-line option rows (code over full name). */
.ntt-offices :deep(.v-list-item-title) {
    font-weight: 700;
}
.ntt-offices :deep(.v-list-item-subtitle) {
    font-size: 12.5px;
    white-space: normal;
}
.ntt-office-chip-icon {
    width: 22px;
    height: 22px;
    margin-inline-end: 8px;
    object-fit: contain;
}
.ntt-office-selection {
    display: inline-flex;
    align-items: center;
    gap: 0;
}
.ntt-office-selection > span:last-child {
    font-size: 15px;
    font-weight: 600;
}
.ntt-office-chip-icon-placeholder {
    display: inline-flex;
    width: 22px;
    height: 22px;
    flex: none;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    margin-inline-end: 8px;
    border: 2px solid #7b8495;
    border-radius: 50%;
    background: #f3f5f8;
    color: #596579;
    font-size: 14px;
    font-weight: 700;
    line-height: 1;
}
.ntt-office-option-icon {
    width: 36px;
    height: 36px;
    flex: none;
    margin-inline-end: 10px;
    object-fit: contain;
}
.ntt-office-option-icon-placeholder {
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

/* Active: bordered row, subtitle tracks the switch. */
.ntt-sw {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 6px;
    padding: 8px 14px;
    border: 1.5px solid rgba(var(--v-border-color), var(--v-border-opacity));
    border-radius: 14px;
}
.ntt-sw-t {
    font-size: 14.5px;
    font-weight: 700;
}
.ntt-sw-d {
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}
.ntt-sw-tg {
    flex: none;
}

/* Footer: ghost Cancel + primary Save, stacked on phones. */
.ntt-ft {
    gap: 10px;
    padding: 16px 24px 20px;
}
.ntt-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}
.ntt-b-pri {
    min-width: 120px;
}
@media (max-width: 520px) {
    .ntt-ft {
        flex-direction: column-reverse;
    }
    .ntt-b {
        width: 100%;
    }
}

/* Dark theme (html.dark is toggled by AppShell for pixivDark). */
html.dark .ntt-in :deep(.v-field) {
    background: #232b45;
}
html.dark .ntt-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}
html.dark .ntt-sw {
    border-color: rgba(255, 255, 255, 0.16);
}
</style>
