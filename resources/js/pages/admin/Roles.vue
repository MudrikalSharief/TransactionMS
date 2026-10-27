<template>
    <LoadingVeil :show="loading" label="roles" icon="mdi-shield-account" />
    <v-card rounded="0" elevation="0" class="ro-page mb-4">
        <header class="ro-hd">
            <div class="ro-badge" aria-hidden="true">
                <v-icon size="26">mdi-shield-account</v-icon>
            </div>
            <div class="ro-hd-main">
                <h1 class="ro-title">Roles</h1>
                <p class="ro-sub">
                    The roles your system uses for access and workflow
                    assignments.
                </p>
            </div>
            <div class="ro-tools">
                <div class="ro-search" role="search">
                    <v-icon class="ro-search-icon" size="19"
                        >mdi-magnify</v-icon
                    >
                    <input
                        ref="searchInput"
                        v-model="search"
                        type="search"
                        class="ro-search-input"
                        placeholder="Search code, name or description"
                        aria-label="Search roles"
                        autocomplete="off"
                    />
                    <button
                        v-if="search"
                        type="button"
                        class="ro-clear"
                        aria-label="Clear search"
                        @click="clearSearch"
                    >
                        <v-icon size="16">mdi-close</v-icon>
                    </button>
                </div>
                <button
                    type="button"
                    class="ro-add"
                    aria-label="Add role"
                    @click="openCreate"
                >
                    <v-icon size="18">mdi-plus</v-icon>
                    <span class="ro-add-label">Add role</span>
                </button>
            </div>
        </header>

        <v-alert
            v-if="error"
            type="error"
            variant="tonal"
            rounded="0"
            class="ro-alert"
        >
            {{ error }}
        </v-alert>

        <div class="ro-wrap">
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
                class="ro-table"
            >
                <template v-slot:[`item.code`]="{ item }">
                    <span class="ro-code" :title="item.code">{{
                        item.code
                    }}</span>
                </template>

                <template v-slot:[`item.name`]="{ item }">
                    <span class="ro-name" v-tooltip="item.name">{{
                        item.name
                    }}</span>
                </template>

                <template v-slot:[`item.description`]="{ item }">
                    <span class="ro-desc" :title="item.description || ''">{{
                        item.description || "—"
                    }}</span>
                </template>

                <template v-slot:[`item.actions`]="{ item }">
                    <div class="ro-actions">
                        <v-btn
                            class="ro-ib is-edit"
                            icon="mdi-pencil"
                            aria-label="Edit role"
                            v-tooltip="'Edit role'"
                            size="small"
                            variant="outlined"
                            rounded="0"
                            @click="openEdit(item)"
                        />
                        <v-btn
                            class="ro-ib is-delete"
                            icon="mdi-delete"
                            aria-label="Delete role"
                            v-tooltip="
                                item.code === 'superadmin'
                                    ? 'The superadmin role cannot be deleted'
                                    : 'Delete role'
                            "
                            size="small"
                            variant="outlined"
                            rounded="0"
                            :disabled="item.code === 'superadmin'"
                            @click="removeRow(item)"
                        />
                    </div>
                </template>

                <template #no-data>
                    <div class="ro-empty">
                        <template v-if="search.trim()">
                            <b>No matches</b> for “{{ search.trim() }}”. Try a
                            different word.
                        </template>
                        <template v-else>
                            <b>No roles yet.</b>
                            <span>
                                Use “Add role” to create the first one.
                            </span>
                        </template>
                    </div>
                </template>

                <template #body.append>
                    <tr
                        v-for="n in ghostRows"
                        :key="`ghost-${n}`"
                        class="ro-ghost"
                        aria-hidden="true"
                    >
                        <td v-for="h in headers" :key="h.key" />
                    </tr>
                </template>
            </v-data-table>
        </div>

        <footer class="ro-pg">
            <div class="ro-per">
                <span>Items per page</span>
                <span class="ro-per-box" aria-label="Items per page: 8">
                    <span>8</span>
                    <v-icon size="18" aria-hidden="true"
                        >mdi-chevron-down</v-icon
                    >
                </span>
            </div>
            <span class="ro-range">{{ rangeLabel }}</span>
            <div class="ro-pn" role="group" aria-label="Pagination">
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
            <v-card-title class="nro-hd">
                <v-avatar
                    color="primary"
                    variant="tonal"
                    rounded="lg"
                    size="44"
                    class="nro-badge"
                >
                    <v-icon color="primary">mdi-shield-account-outline</v-icon>
                </v-avatar>
                <div class="nro-hd-t">
                    <div class="nro-title">
                        {{ form.id ? "Edit Role" : "New Role" }}
                    </div>
                    <div class="nro-sub">
                        {{
                            form.id
                                ? "Update the role's details."
                                : "Define a role used for access and workflow steps."
                        }}
                    </div>
                </div>
                <v-btn
                    icon="mdi-close"
                    variant="text"
                    size="small"
                    color="grey-darken-3"
                    class="nro-x"
                    @click="dialog = false"
                />
            </v-card-title>
            <v-divider />
            <v-card-text class="nro-bd">
                <v-alert
                    v-if="dialogError"
                    type="error"
                    variant="tonal"
                    density="compact"
                    class="mb-4"
                    >{{ dialogError }}</v-alert
                >

                <div class="nro-f">
                    <label class="nro-lb" for="nro-name"
                        >Name <span class="nro-req">*</span></label
                    >
                    <v-text-field
                        id="nro-name"
                        v-model="form.name"
                        placeholder="e.g. Budget Officer"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        :error-messages="fieldErrors.name"
                        class="nro-in"
                        @update:model-value="clearFieldError('name')"
                    />
                </div>

                <div class="nro-f">
                    <label class="nro-lb" for="nro-code"
                        >Code <span class="nro-req">*</span></label
                    >
                    <v-text-field
                        id="nro-code"
                        v-model="form.code"
                        placeholder="budget_officer"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        spellcheck="false"
                        :error-messages="fieldErrors.code"
                        class="nro-in nro-mono"
                        @update:model-value="clearFieldError('code')"
                    />
                    <div v-if="!fieldErrors.code" class="nro-help">
                        Lowercase letters, numbers and underscores only.
                    </div>
                </div>

                <div class="nro-f">
                    <label class="nro-lb" for="nro-desc">Description</label>
                    <v-textarea
                        id="nro-desc"
                        v-model="form.description"
                        placeholder="What is this role used for?"
                        rows="3"
                        maxlength="1000"
                        variant="outlined"
                        density="comfortable"
                        hide-details="auto"
                        persistent-placeholder
                        :error-messages="fieldErrors.description"
                        class="nro-in"
                        @update:model-value="clearFieldError('description')"
                    />
                    <div v-if="!fieldErrors.description" class="nro-help">
                        {{ (form.description || "").length }}/1000 characters
                    </div>
                </div>
            </v-card-text>
            <v-divider />
            <v-card-actions class="nro-ft">
                <v-btn
                    variant="outlined"
                    rounded="lg"
                    class="nro-b"
                    @click="dialog = false"
                    >Cancel</v-btn
                >
                <v-btn
                    color="primary"
                    rounded="lg"
                    class="nro-b nro-b-pri"
                    :loading="saving"
                    @click="save"
                    >Save</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRoles } from "@/composables/useRoles";
import LoadingVeil from "@/components/LoadingVeil.vue";
import { toast } from "@/composables/useToast";

const { roles, loading, fetchRoles, createRole, updateRole, deleteRole } =
    useRoles();

const headers = [
    { title: "Code", key: "code", width: "16%" },
    { title: "Name", key: "name", width: "20%" },
    { title: "Description", key: "description", width: "53%" },
    { title: "", key: "actions", sortable: false, width: "11%", align: "end" },
];

const dialog = ref(false);
const saving = ref(false);
const error = ref("");
const search = ref("");
const searchInput = ref(null);
const PER_PAGE = 8;
const page = ref(1);

// Client-side search: master data is small, filter loaded rows by
// code / name / description without extra requests.
const filtered = computed(() => {
    const q = String(search.value || "")
        .trim()
        .toLowerCase();
    if (!q) return roles.value || [];
    return (roles.value || []).filter((r) =>
        [r.code, r.name, r.description].some((v) =>
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
// Keep the seven-row rhythm: fill only the remaining slots with ghosts.
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

const form = ref({ id: null, code: "", name: "", description: "" });
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

// Mirrors StoreRoleRequest/UpdateRoleRequest: lower snake_case code (≤50),
// name (≤100), description (≤1000). Duplicate codes are blocked client-side
// against the loaded roles (server enforces it too, soft-delete aware).
const CODE_RE = /^[a-z0-9_]+$/;

function validateForm() {
    const errs = {};
    const code = String(form.value.code || "").trim();
    if (!code) errs.code = "The code is required.";
    else if (!CODE_RE.test(code))
        errs.code = "Code may only contain lowercase letters, numbers and underscores.";
    else if (code.length > 50)
        errs.code = "The code may not be greater than 50 characters.";
    else if (
        (roles.value || []).some(
            (r) => r.code === code && Number(r.id) !== Number(form.value.id),
        )
    )
        errs.code = "The code has already been taken.";

    const name = String(form.value.name || "").trim();
    if (!name) errs.name = "The name is required.";
    else if (name.length > 100)
        errs.name = "The name may not be greater than 100 characters.";

    if (String(form.value.description || "").length > 1000)
        errs.description =
            "The description may not be greater than 1000 characters.";

    return errs;
}

function openCreate() {
    error.value = "";
    fieldErrors.value = {};
    dialogError.value = "";
    form.value = { id: null, code: "", name: "", description: "" };
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
    };
    dialog.value = true;
}

async function save() {
    saving.value = true;
    error.value = "";
    fieldErrors.value = {};
    dialogError.value = "";

    const errs = validateForm();
    if (Object.keys(errs).length) {
        fieldErrors.value = errs;
        saving.value = false;
        return;
    }

    try {
        const payload = {
            code: String(form.value.code || "").trim(),
            name: String(form.value.name || "").trim(),
            description: form.value.description,
        };
        if (form.value.id) {
            await updateRole(form.value.id, payload);
            toast.success(`Role “${payload.name}” updated.`);
        } else {
            await createRole(payload);
            toast.success(`Role “${payload.name}” saved.`);
        }
        dialog.value = false;
        await fetchRoles({ silent: true });
    } catch (e) {
        // Server-side validation lands under the offending field; anything else
        // (network, 403, 500) shows at the top of the dialog body.
        const serverErrs = e?.response?.data?.errors;
        if (serverErrs && typeof serverErrs === "object") {
            const first = (v) => (Array.isArray(v) ? v[0] : String(v ?? ""));
            fieldErrors.value = Object.fromEntries(
                Object.entries(serverErrs).map(([key, value]) => [
                    key,
                    first(value),
                ]),
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
        await deleteRole(item.id);
        toast.success(`Role “${item.name || item.code}” deleted.`);
        await fetchRoles({ silent: true });
    } catch (e) {
        error.value = e?.response?.data?.message || "Delete failed.";
    }
}

onMounted(() => {
    fetchRoles().catch(() => {});
});
</script>

<style scoped>
/* ==========================================================================
   Roles — sharp panel, header, table and footer
   (visual port of the Offices / Transaction Types design system)
   ========================================================================== */
.ro-page {
    --ro-ink: rgb(var(--v-theme-on-surface));
    --ro-muted: rgb(var(--v-theme-secondary));
    --ro-line: rgba(var(--v-border-color), var(--v-border-opacity));
    --ro-panel: rgb(var(--v-theme-surface));
    --ro-field: #f4f6fb;
    --ro-hover: #f3f6fc;
    --ro-blue: #005EED;
    --ro-blue-bg: #e8eeff;
    --ro-amber: #b86e00;
    --ro-amber-bg: #fff1d6;
    --ro-err: rgb(var(--v-theme-error));
    --ro-err-bg: rgba(var(--v-theme-error), 0.12);
    --ro-ring: rgba(29, 63, 174, 0.28);
    overflow: hidden;
    background: var(--ro-panel);
    border: 1px solid var(--ro-line);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
    font-variant-numeric: tabular-nums;
}
html.dark .ro-page {
    --ro-field: #1c2645;
    --ro-hover: #1d2745;
    --ro-blue: #6f8cff;
    --ro-blue-bg: #25306a;
    --ro-amber: #ffbf47;
    --ro-amber-bg: #4a3510;
    --ro-err-bg: #4a1f22;
    --ro-ring: rgba(138, 161, 255, 0.38);
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}
.ro-page button:focus-visible,
.ro-page a:focus-visible {
    outline: 3px solid var(--ro-ring);
    outline-offset: 2px;
}

/* ---- Header ---- */
.ro-hd {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 22px 28px;
    border-bottom: 3px solid var(--ro-blue);
    flex-wrap: wrap;
}
.ro-badge {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    flex: none;
    background: var(--tms-grad);
    color: #fff;
}
.ro-hd-main {
    flex: 1 1 320px;
    min-width: 0;
}
.ro-title {
    margin: 0;
    color: var(--ro-ink);
    font-size: 24px;
    font-weight: 800;
    letter-spacing: -0.015em;
    line-height: 1.2;
}
.ro-sub {
    margin: 4px 0 0;
    color: var(--ro-muted);
    font-size: 13.5px;
    font-weight: 500;
    line-height: 1.4;
}
.ro-tools {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: nowrap;
    margin-left: auto;
}
.ro-search {
    position: relative;
    flex: 0 0 320px;
    min-width: 0;
    max-width: 320px;
}
.ro-search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--ro-muted);
    pointer-events: none;
}
.ro-search-input {
    width: 100%;
    height: 46px;
    padding: 0 42px;
    border: 1.5px solid var(--ro-line);
    border-radius: 0;
    background: var(--ro-field);
    color: var(--ro-ink);
    font: inherit;
    font-size: 14.5px;
    font-weight: 500;
    transition:
        border-color 0.15s,
        box-shadow 0.15s,
        background 0.15s;
}
.ro-search-input::placeholder {
    color: var(--ro-muted);
    opacity: 0.9;
}
.ro-search-input:hover {
    border-color: rgba(var(--v-border-color), 0.8);
}
.ro-search-input:focus {
    outline: none;
    border-color: var(--ro-blue);
    background: var(--ro-panel);
    box-shadow: 0 0 0 4px var(--ro-ring);
}
.ro-search-input::-webkit-search-cancel-button {
    display: none;
}
.ro-clear {
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
    color: var(--ro-muted);
    cursor: pointer;
}
.ro-clear:hover {
    background: var(--ro-line);
}
.ro-add {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: 46px;
    padding: 0 20px;
    flex: none;
    border: 1.5px solid var(--ro-blue);
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
.ro-add:hover {
    filter: brightness(0.94);
}

/* ---- Alerts + table shell ---- */
.ro-alert {
    margin: 16px 28px 0 !important;
    border-radius: 0 !important;
}
.ro-wrap {
    min-width: 0;
    padding: 20px 28px 0;
}
.ro-table {
    --v-table-row-height: var(--tms-row);
    --v-table-header-height: 44px;
    width: 100%;
    min-width: 0;
    background: transparent !important;
}
.ro-table :deep(.v-table__wrapper) {
    overflow-x: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--ro-muted) var(--ro-field);
}
.ro-table :deep(.v-table__wrapper::-webkit-scrollbar) {
    width: 10px;
    height: 10px;
}
.ro-table :deep(.v-table__wrapper::-webkit-scrollbar-track) {
    background: var(--ro-field);
}
.ro-table :deep(.v-table__wrapper::-webkit-scrollbar-thumb) {
    border: 2px solid var(--ro-field);
    background: var(--ro-muted);
}
.ro-table :deep(table) {
    width: 100%;
    min-width: 900px;
    border-collapse: collapse;
    table-layout: fixed;
}
.ro-table :deep(thead th.v-data-table__th) {
    height: 44px;
    padding: 0 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--ro-line) !important;
    border-radius: 0 !important;
    background: var(--ro-field) !important;
    color: var(--ro-muted) !important;
    font-size: 12px !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-align: left;
    text-transform: uppercase;
    white-space: nowrap;
}
.ro-table :deep(thead th.v-data-table__th .v-data-table-header__content) {
    color: var(--ro-muted) !important;
    font-weight: 800 !important;
    letter-spacing: 0.06em !important;
    text-transform: uppercase;
}
.ro-table :deep(thead th.v-data-table__th .v-icon) {
    color: var(--ro-muted) !important;
    opacity: 0.65;
}
.ro-table :deep(thead th.v-data-table__th:last-child) {
    padding-left: 8px !important;
    text-align: right;
}
.ro-table :deep(tbody td:last-child) {
    padding-left: 8px !important;
}
.ro-table :deep(tbody td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border: 0 !important;
    border-bottom: 1px solid var(--ro-line) !important;
    border-radius: 0 !important;
    color: var(--ro-ink);
    font-size: 14.5px;
    vertical-align: middle;
}
.ro-table :deep(tbody tr:not(.ro-ghost):hover) {
    background: var(--ro-hover) !important;
}
.ro-table :deep(tbody tr.ro-ghost) {
    pointer-events: none;
}
.ro-table :deep(tbody tr.ro-ghost td) {
    height: var(--tms-row);
    padding: 8px 14px !important;
    border-bottom: 1px solid var(--ro-line) !important;
}
.ro-table :deep(.v-data-table-rows-no-data td) {
    height: var(--tms-row) !important;
    padding: 0 !important;
    border-bottom: 1px solid var(--ro-line) !important;
}
.ro-empty {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
    min-height: var(--tms-row);
    padding: 0 14px;
    color: var(--ro-muted);
    font-size: 14px;
    font-weight: 500;
    text-align: center;
}
.ro-empty b {
    color: var(--ro-ink);
}

/* ---- Cells ---- */
.ro-code {
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    padding: 4px 9px;
    background: var(--ro-field);
    color: var(--ro-muted);
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 12.5px;
    text-overflow: ellipsis;
    vertical-align: middle;
    white-space: nowrap;
}
.ro-name {
    display: block;
    max-width: 100%;
    overflow: hidden;
    color: var(--ro-ink);
    font-size: 15px;
    font-weight: 600;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.ro-desc {
    display: -webkit-box;
    max-width: 100%;
    color: var(--ro-muted);
    line-height: 1.35;
    /* Two lines at most so one long description cannot make the row (and the
       whole card) taller than the other tabs; the full text is on hover. */
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    overflow-wrap: anywhere;
}
.ro-actions {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}
.ro-ib {
    width: 40px !important;
    min-width: 40px !important;
    height: 40px !important;
    padding: 0 !important;
    border: 1.5px solid var(--ro-line) !important;
    border-radius: 0 !important;
    background: transparent !important;
    color: var(--ro-muted) !important;
    box-shadow: none !important;
}
.ro-ib :deep(.v-icon) {
    font-size: 18px !important;
}
.ro-ib.is-edit {
    border-color: var(--ro-amber-bg) !important;
    color: var(--ro-amber) !important;
}
.ro-ib.is-edit:hover {
    background: var(--ro-amber-bg) !important;
}
.ro-ib.is-delete {
    border-color: var(--ro-err-bg) !important;
    color: var(--ro-err) !important;
}
.ro-ib.is-delete:hover {
    background: var(--ro-err-bg) !important;
}
.ro-ib:disabled {
    opacity: 0.45 !important;
}

/* ---- Footer ---- */
.ro-pg {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 20px;
    padding: 16px 28px 20px;
    color: var(--ro-muted);
    font-size: 14px;
    flex-wrap: wrap;
}
.ro-per {
    display: flex;
    align-items: center;
    gap: 10px;
}
.ro-per-box {
    display: inline-flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    min-width: 76px;
    height: 40px;
    padding: 0 8px 0 12px;
    border: 1.5px solid var(--ro-line);
    background: var(--ro-panel);
    color: var(--ro-ink);
    font-weight: 700;
}
.ro-per-box :deep(.v-icon) {
    color: var(--ro-muted);
}
.ro-range {
    color: var(--ro-ink);
    font-weight: 700;
}
.ro-pn {
    display: flex;
    gap: 4px;
}
.ro-pn button {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    padding: 0;
    border: 1.5px solid var(--ro-line);
    border-radius: 0;
    background: var(--ro-panel);
    color: var(--ro-ink);
    cursor: pointer;
}
.ro-pn button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

@media (max-width: 900px) {
    .ro-tools {
        flex: 1 1 100%;
        margin-left: 0;
    }
    .ro-search {
        flex: 1 1 100%;
        max-width: none;
    }
}
@media (max-width: 760px) {
    .ro-hd {
        padding: 18px 16px;
    }
    .ro-title {
        font-size: 20px;
    }
    .ro-wrap {
        padding: 16px 16px 0;
    }
    .ro-pg {
        justify-content: center;
        padding: 16px;
    }
}
@media (max-width: 520px) {
    .ro-add {
        padding: 0 16px;
    }
    .ro-add-label {
        display: none;
    }
}
</style>

<style scoped>
/* ---- New / Edit Role modal ---- */
/* Header: tinted badge + title + subtitle + close. */
.nro-hd {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 22px 24px 16px;
}
.nro-badge {
    flex: none;
}
.nro-hd-t {
    min-width: 0;
}
.nro-title {
    font-size: 20px;
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.25;
}
.nro-sub {
    margin-top: 3px;
    font-size: 14px;
    color: rgb(var(--v-theme-secondary));
}
.nro-x {
    margin-left: auto;
    flex: none;
}

/* Body: label / field / help rhythm, scrolling inside the dialog. */
.nro-bd {
    padding: 18px 24px 8px;
}
.nro-f {
    margin-bottom: 18px;
}
.nro-lb {
    display: block;
    margin-bottom: 7px;
    font-size: 14px;
    font-weight: 600;
}
.nro-req {
    color: rgb(var(--v-theme-error));
}
.nro-help {
    margin: 6px 2px 0;
    font-size: 12.5px;
    color: rgb(var(--v-theme-secondary));
}

/* Fields: 48px tall, radius 12, tinted fill, soft focus ring. */
.nro-in :deep(.v-field) {
    min-height: 48px;
    border-radius: 12px;
    background: #f4f6fb;
}
.nro-in :deep(.v-field__outline) {
    --v-field-border-width: 1.5px;
}
.nro-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(0, 94, 237, 0.18);
}
.nro-mono :deep(input) {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 14.5px;
}

/* Footer: ghost Cancel + primary Save, stacked on phones. */
.nro-ft {
    gap: 10px;
    padding: 16px 24px 20px;
}
.nro-b {
    height: 46px;
    padding: 0 22px;
    font-weight: 700;
    text-transform: none;
}
.nro-b-pri {
    min-width: 120px;
}
@media (max-width: 520px) {
    .nro-ft {
        flex-direction: column-reverse;
    }
    .nro-b {
        width: 100%;
    }
}

/* Dark theme (html.dark is toggled by AppShell for pixivDark). */
html.dark .nro-in :deep(.v-field) {
    background: #232b45;
}
html.dark .nro-in :deep(.v-field--focused) {
    background: rgb(var(--v-theme-surface));
    box-shadow: 0 0 0 4px rgba(147, 197, 253, 0.22);
}
</style>
