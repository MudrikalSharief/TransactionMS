<template>
    <TrackBackdrop :quiet="active" />
    <div class="finder" :class="active ? 'is-active' : 'is-idle'">
        <!-- Heading folds away once a search is under way -->
        <div class="lead">
            <div class="lead-inner">
                <!-- The welcome screen's pair, small: city seal and system
                     emblem joined by the same gold link. -->
                <div class="marks">
                    <img class="seal" :src="'/zamboanga-seal.png'" alt="City of Zamboanga seal" width="60" height="60" />
                    <span class="marks-tie" aria-hidden="true"><i></i></span>
                    <img
                        class="tms"
                        :src="'/tms-logo-128.png'"
                        alt="Transaction Management System emblem"
                        width="60"
                        height="62"
                    />
                </div>
                <div class="eyebrow">Transaction tracker</div>
                <h1 class="title">Where is your document?</h1>
                <p class="sub">
                    Type a keyword (a name, reference number, transaction type or office) and follow
                    each transaction from office to office.
                </p>
            </div>
        </div>

        <form class="bar" role="search" @submit.prevent="searchNow">
            <label class="bar-icon" for="track-search" aria-hidden="true">
                <v-icon>mdi-magnify</v-icon>
            </label>
            <input
                id="track-search"
                ref="inputEl"
                v-model="query"
                type="search"
                name="q"
                placeholder="Name, reference number, type or office"
                autocomplete="off"
                autocapitalize="none"
                spellcheck="false"
                aria-label="Search your transactions"
                autofocus
            />
            <button v-if="query" type="button" class="bar-clear" aria-label="Clear search" @click="clear">
                <v-icon>mdi-close</v-icon>
            </button>
            <button type="submit" class="bar-go" :disabled="!query.trim()">
                <span v-if="loading" class="spin" aria-hidden="true"></span>
                <span v-else>Track</span>
            </button>
        </form>

        <p v-if="!active" class="note">
            <v-icon size="16">mdi-eye-outline</v-icon>
            Viewer access: you follow progress only. Files are never shown.
        </p>

        <v-expand-transition>
            <div v-if="active" class="results">
                <v-alert v-if="error" type="error" variant="tonal" rounded="0" class="mb-3">{{ error }}</v-alert>

                <v-card rounded="0" elevation="1" class="lgu-card">
                    <v-card-title class="d-flex align-center pa-4 results-head">
                        <v-avatar color="white" rounded="0" size="36" class="mr-3 results-avatar">
                            <v-icon color="#005EED" size="22">mdi-map-marker-path</v-icon>
                        </v-avatar>
                        <span class="text-subtitle-1 font-weight-bold">
                            {{ loading && !searched ? "Searching…" : resultsLabel }}
                        </span>
                    </v-card-title>
                    <v-card-text class="pa-4">
                        <v-data-table
                            v-if="items.length"
                            :items="items"
                            :headers="headers"
                            item-key="id"
                            density="compact"
                            :items-per-page="25"
                            :sort-by="[{ key: 'created_at', order: 'desc' }]"
                            hover
                            class="lgu-table"
                            @click:row="(_, row) => open(row.item)"
                        >
                            <template v-slot:[`item.reference_number`]="{ item }">
                                <v-chip color="grey-darken-3" variant="tonal" rounded="0" size="small" class="font-weight-bold">
                                    {{ item.reference_number || `#${item.id}` }}
                                </v-chip>
                            </template>
                            <template v-slot:[`item.title`]="{ item }">
                                <span class="font-weight-bold">{{ item.title || "N/A" }}</span>
                            </template>
                            <template v-slot:[`item.type`]="{ item }">
                                <v-chip color="info" variant="tonal" rounded="0" size="small">
                                    <v-icon start size="small">mdi-tag-outline</v-icon>
                                    {{ item.transaction_type?.name || item.transaction_type_name || "N/A" }}
                                </v-chip>
                            </template>
                            <template v-slot:[`item.status`]="{ item }">
                                <v-chip :color="item.is_done ? 'success' : 'warning'" variant="tonal" rounded="0" size="small">
                                    <v-icon start size="small">{{ item.is_done ? "mdi-check-circle-outline" : "mdi-progress-clock" }}</v-icon>
                                    {{ item.is_done ? "Completed" : "In process" }}
                                </v-chip>
                            </template>
                            <template v-slot:[`item.current_step`]="{ item }">
                                <v-menu open-on-hover location="end" open-delay="250">
                                    <template #activator="{ props }">
                                        <v-chip
                                            :color="stepColor(item.current_step)"
                                            variant="tonal"
                                            rounded="0"
                                            size="small"
                                            v-bind="props"
                                        >
                                            <v-icon start size="small">{{ stepIcon(item.current_step) }}</v-icon>
                                            {{ item.current_step?.name || item.current_step?.code || "Unassigned" }}
                                        </v-chip>
                                    </template>
                                    <StepProgress
                                        :steps="item.workflow_steps"
                                        :current-step-id="item.current_step?.id"
                                        :current-step-code="item.current_step?.code"
                                        :title="item.current_step?.name || item.current_step?.code || 'Unassigned'"
                                    />
                                </v-menu>
                            </template>
                            <template v-slot:[`item.created_at`]="{ item }">
                                <div class="font-weight-bold">{{ fmtDate(item.created_at) }}</div>
                                <div class="text-caption text-medium-emphasis">{{ timeAgo(item.created_at) }}</div>
                            </template>
                            <template #bottom>
                                <div v-if="meta.lastPage > 1" class="d-flex justify-center py-3">
                                    <v-pagination v-model="page" :length="meta.lastPage" :total-visible="5" density="compact" @update:model-value="goToPage" />
                                </div>
                            </template>
                        </v-data-table>

                        <div v-else-if="searched && !loading" class="empty">
                            <v-icon size="40" color="grey">mdi-file-search-outline</v-icon>
                            <div class="font-weight-bold mt-2">Nothing found for “{{ shownQuery }}”</div>
                            <div class="text-caption text-medium-emphasis">
                                Try a name, a reference number, a transaction type or an office.
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </div>
        </v-expand-transition>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useSmartPoll } from "@/composables/useSmartPoll";
import StepProgress from "@/components/StepProgress.vue";
import TrackBackdrop from "@/components/track/TrackBackdrop.vue";

const router = useRouter();
const { api } = useApi();

const inputEl = ref(null);
const query = ref("");
const shownQuery = ref("");
const items = ref([]);
const loading = ref(false);
const searched = ref(false);
const error = ref("");
const page = ref(1);
const meta = ref({ total: 0, lastPage: 1 });

// Nothing is listed until the viewer searches: no search, no table.
const active = computed(() => query.value.trim().length > 0);

const headers = [
    { title: "Reference", key: "reference_number" },
    { title: "Title", key: "title" },
    { title: "Transaction Type", key: "type", sortable: false },
    { title: "Status", key: "status", sortable: false },
    { title: "Current Step", key: "current_step", sortable: false },
    { title: "Created At", key: "created_at" },
];

const resultsLabel = computed(() => {
    const n = meta.value.total || items.value.length;
    if (!searched.value) return "Searching…";
    return n === 1 ? "1 transaction found" : `${n} transactions found`;
});

let seq = 0;
async function fetchRows({ silent = false } = {}) {
    const q = query.value.trim();
    if (!q) return;
    const mine = ++seq;
    if (!silent) loading.value = true;
    try {
        const res = await api.get("/api/viewer/transactions", {
            params: { q, page: page.value, per_page: 25 },
        });
        if (mine !== seq) return; // a newer search is already running
        items.value = res.data?.data ?? [];
        meta.value = {
            total: res.data?.meta?.total ?? items.value.length,
            lastPage: res.data?.meta?.last_page ?? 1,
        };
        shownQuery.value = q;
        searched.value = true;
        error.value = "";
    } catch (e) {
        if (mine !== seq) return;
        error.value = e?.response?.data?.message || "Search failed. Please try again.";
    } finally {
        if (mine === seq) loading.value = false;
    }
}

function searchNow() {
    clearTimeout(timer);
    page.value = 1;
    fetchRows();
}

let timer = null;
watch(query, (v) => {
    clearTimeout(timer);
    if (!v.trim()) {
        seq++; // drop any in-flight search
        items.value = [];
        searched.value = false;
        loading.value = false;
        error.value = "";
        return;
    }
    timer = setTimeout(() => {
        page.value = 1;
        fetchRows();
    }, 450);
});

function clear() {
    query.value = "";
    inputEl.value?.focus();
}

function goToPage(p) {
    page.value = p;
    fetchRows();
}

// The reference travels along: it is what unlocks a transaction the
// viewer did not create.
function open(tx) {
    router.push({ path: `/track/${tx.id}`, query: tx.reference_number ? { ref: tx.reference_number } : {} });
}

function stepColor(step) {
    if (!step) return "grey";
    if (step.is_end) return "success";
    if (step.is_start) return "teal";
    return "primary";
}

function stepIcon(step) {
    if (!step) return "mdi-help-circle-outline";
    if (step.is_end) return "mdi-flag-checkered";
    if (step.is_start) return "mdi-play";
    return "mdi-dots-horizontal-circle-outline";
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

function timeAgo(iso) {
    if (!iso) return "";
    const s = Math.max(0, (Date.now() - new Date(iso).getTime()) / 1000);
    if (s < 60) return "just now";
    if (s < 3600) return `${Math.floor(s / 60)}m ago`;
    if (s < 86400) return `${Math.floor(s / 3600)}h ago`;
    if (s < 86400 * 30) return `${Math.floor(s / 86400)}d ago`;
    return fmtDate(iso);
}

onMounted(() => inputEl.value?.focus());

// Keep an open result list fresh without touching the search box.
useSmartPoll(() => {
    if (active.value && searched.value) return fetchRows({ silent: true });
});
</script>

<style scoped>
.finder {
    position: relative;
    z-index: 1;
    max-width: 980px;
    margin: 0 auto;
    transition: padding-top 0.5s cubic-bezier(0.2, 0.7, 0.2, 1);
}
/* Idle: the bar sits in the middle of the screen. */
.finder.is-idle {
    padding-top: max(4vh, calc(50vh - 250px));
}
.finder.is-active {
    padding-top: 0;
}

.lead {
    display: grid;
    grid-template-rows: 1fr;
    text-align: center;
    transition: grid-template-rows 0.45s cubic-bezier(0.2, 0.7, 0.2, 1), opacity 0.3s ease, margin 0.45s ease;
    margin-bottom: 28px;
}
.lead-inner {
    overflow: hidden;
    min-height: 0;
}
.is-active .lead {
    grid-template-rows: 0fr;
    opacity: 0;
    margin-bottom: 0;
}

.marks {
    display: flex;
    align-items: flex-start;
    justify-content: center;
    gap: 0;
    margin: 0 auto 14px;
}
.seal {
    display: block;
    width: 60px;
    height: 60px;
    /* The welcome screen's seal flies into this one (view transition). */
    view-transition-name: city-seal;
}
.tms {
    display: block;
    width: 60px;
    height: 62px;
    object-fit: contain;
    /* ...and the system emblem into this one. */
    view-transition-name: tms-emblem;
}
/* The same gold link as on the welcome screen, in miniature. */
.marks-tie {
    position: relative;
    width: 34px;
    height: 60px;
    flex: none;
}
.marks-tie::before {
    content: "";
    position: absolute;
    left: 4px;
    right: 4px;
    top: 29.5px;
    height: 1px;
    background: linear-gradient(90deg, transparent, #c9a24b 30%, #c9a24b 70%, transparent);
}
.marks-tie i {
    position: absolute;
    left: 50%;
    top: 30px;
    width: 6px;
    height: 6px;
    margin: -3px 0 0 -3px;
    background: #c9a24b;
    transform: rotate(45deg);
}
.eyebrow {
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.3em;
    text-transform: uppercase;
    color: rgb(var(--v-theme-primary));
}
.title {
    margin: 8px 0 10px;
    font-family: 'Iowan Old Style', 'Palatino Linotype', Palatino, 'Book Antiqua', Georgia, serif;
    font-size: clamp(30px, 5vw, 46px);
    font-weight: 600;
    line-height: 1.1;
    letter-spacing: -0.01em;
    color: rgb(var(--v-theme-on-surface));
}
.sub {
    margin: 0 auto;
    max-width: 52ch;
    font-size: 15.5px;
    line-height: 1.5;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}

/* The bar: square, ruled in the app's blue, like a counter window. */
.bar {
    display: flex;
    align-items: stretch;
    height: 64px;
    background: rgb(var(--v-theme-surface));
    border: 2px solid rgb(var(--v-theme-primary));
    box-shadow: 0 14px 30px -18px rgba(30, 64, 175, 0.55);
    transition: box-shadow 0.2s ease;
}
.bar:focus-within {
    box-shadow: 0 0 0 4px rgba(30, 64, 175, 0.2), 0 14px 30px -18px rgba(30, 64, 175, 0.55);
}
.bar-icon {
    display: grid;
    place-items: center;
    width: 60px;
    flex: none;
    background: rgb(var(--v-theme-primary));
    color: #ffffff;
    cursor: text;
}
.bar-icon .v-icon {
    font-size: 28px;
}
.bar input {
    flex: 1;
    min-width: 0;
    border: 0;
    outline: 0;
    background: transparent;
    padding: 0 16px;
    font: inherit;
    font-size: 19px;
    font-weight: 600;
    color: rgb(var(--v-theme-on-surface));
}
.bar input::placeholder {
    font-weight: 500;
    color: rgba(var(--v-theme-on-surface), 0.45);
}
.bar input::-webkit-search-cancel-button {
    display: none;
}
.bar-clear {
    width: 44px;
    border: 0;
    background: transparent;
    color: rgba(var(--v-theme-on-surface), 0.55);
    cursor: pointer;
}
.bar-clear:hover {
    color: rgb(var(--v-theme-on-surface));
}
.bar-go {
    min-width: 108px;
    border: 0;
    padding: 0 22px;
    background: rgb(var(--v-theme-primary));
    color: #ffffff;
    font: inherit;
    font-size: 15px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    cursor: pointer;
    display: grid;
    place-items: center;
}
.bar-go:disabled {
    opacity: 0.45;
    cursor: not-allowed;
}
.bar-go:hover:not(:disabled) {
    filter: brightness(0.9);
}
.spin {
    width: 18px;
    height: 18px;
    border: 2.5px solid rgba(255, 255, 255, 0.4);
    border-top-color: #ffffff;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}
@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

.note {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin: 16px 0 0;
    font-size: 13px;
    color: rgba(var(--v-theme-on-surface), var(--v-medium-emphasis-opacity));
}

.results {
    margin-top: 22px;
}
.results-head {
    background: transparent;
    border-bottom: 4px solid rgb(var(--v-theme-primary));
    border-image: var(--tms-grad-h) 1;
}
.results-avatar {
    border: 2px solid rgb(var(--v-theme-primary));
}
.empty {
    text-align: center;
    padding: 36px 12px;
}

@media (max-width: 600px) {
    .bar {
        height: 56px;
    }
    .bar-icon {
        width: 48px;
    }
    .bar input {
        font-size: 16px;
    }
    .bar-go {
        min-width: 80px;
        padding: 0 14px;
    }
}
@media (prefers-reduced-motion: reduce) {
    .finder,
    .lead {
        transition: none;
    }
}
</style>
