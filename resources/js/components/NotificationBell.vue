<template>
    <!-- App-bar bell: worked out from the data the user can already see
         (new arrivals at their step, items near or past the time limit).
         "Seen" is remembered in this browser only; nothing is stored. -->
    <template v-if="mode">
        <v-menu v-model="open" location="bottom end" :close-on-content-click="false" max-width="400">
            <template #activator="{ props: menuProps }">
                <button
                    v-bind="menuProps"
                    type="button"
                    class="bell-btn"
                    :aria-label="unseen ? `Notifications, ${unseen} new` : 'Notifications'"
                    v-tooltip="'Notifications'"
                >
                    <v-badge :model-value="unseen > 0" :content="unseen > 99 ? '99+' : unseen" color="error" floating>
                        <v-icon size="21" color="#c7d7ff">{{ unseen ? "mdi-bell-ring-outline" : "mdi-bell-outline" }}</v-icon>
                    </v-badge>
                </button>
            </template>

            <v-card rounded="0" class="bell-card">
                <v-card-title class="d-flex align-center pa-3 lgu-head">
                    <v-icon color="#005EED" class="mr-2">mdi-bell-outline</v-icon>
                    <span class="text-subtitle-1 font-weight-bold">Notifications</span>
                    <v-spacer />
                    <v-btn icon="mdi-refresh" variant="text" size="small" :loading="loading" aria-label="Refresh" @click="load" />
                </v-card-title>
                <v-divider />
                <div v-if="!items.length" class="pa-6 text-center text-medium-emphasis">
                    <v-icon size="36" class="mb-2">mdi-bell-check-outline</v-icon>
                    <div>{{ loading ? "Checking…" : "Nothing needs your attention right now." }}</div>
                </div>
                <v-list v-else density="compact" class="py-0 bell-list">
                    <v-list-item
                        v-for="n in items.slice(0, 30)"
                        :key="n.key"
                        :class="{ 'is-unseen': !seenAtOpen.has(n.key) }"
                        @click="go(n)"
                    >
                        <template #prepend>
                            <v-avatar size="30" :color="KIND[n.kind].color" variant="tonal" class="mr-1">
                                <v-icon size="17">{{ KIND[n.kind].icon }}</v-icon>
                            </v-avatar>
                        </template>
                        <v-list-item-title class="font-weight-bold text-body-2">
                            {{ n.ref }}<span v-if="n.title" class="text-medium-emphasis font-weight-regular"> · {{ n.title }}</span>
                        </v-list-item-title>
                        <v-list-item-subtitle class="text-caption">
                            <span :class="`text-${KIND[n.kind].color}`" class="font-weight-bold">{{ KIND[n.kind].label }}</span>
                            · {{ n.text }}
                        </v-list-item-subtitle>
                    </v-list-item>
                    <div v-if="items.length > 30" class="pa-2 text-center text-caption text-medium-emphasis">
                        and {{ items.length - 30 }} more
                    </div>
                </v-list>
            </v-card>
        </v-menu>
        <span class="bell-sep" aria-hidden="true"></span>
    </template>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { useApi } from "@/composables/useApi";
import { useAuth, userKind, canUseApprovals, isSuperadminUser, isOfficeAdminUser } from "@/composables/useAuth";
import { useSmartPoll } from "@/composables/useSmartPoll";
import { summaryApiBase } from "@/composables/useSummaryRows";
import { dueState, workingMs } from "@/utils/processColor";

const router = useRouter();
const { api } = useApi();
const { user } = useAuth();

const KIND = {
    overdue: { label: "Overdue", icon: "mdi-alert-circle", color: "error" },
    due: { label: "Due soon", icon: "mdi-clock-alert-outline", color: "warning" },
    new: { label: "New", icon: "mdi-inbox-arrow-down", color: "primary" },
};
// "New": arrived at the user's step within this window.
const NEW_MS = 2 * 86400000;
// Due/overdue change with the clock even when no data changes.
const CLOCK_MS = 2 * 60000;

// clerk: Task inbox · staff: rows waiting on their role · admin: overdue in scope.
const mode = computed(() => {
    const u = user.value;
    if (!u) return null;
    const kind = userKind(u);
    if (kind === "staff") return canUseApprovals(u) ? "clerk" : "staff";
    if (kind === "admin" && (isSuperadminUser(u) || isOfficeAdminUser(u))) return "admin";
    return null;
});

const rows = ref([]);
const loading = ref(false);
const now = ref(Date.now());
const open = ref(false);

async function allPages(url) {
    const all = [];
    let page = 1;
    let last = 1;
    do {
        const res = await api.get(url, { params: { page, per_page: 100 } });
        all.push(...(res.data?.data ?? []));
        last = res.data?.meta?.last_page ?? 1;
        page += 1;
    } while (page <= last && page <= 10);
    return all;
}

async function load() {
    if (!mode.value) return;
    loading.value = true;
    try {
        if (mode.value === "clerk") rows.value = await allPages("/api/approvals");
        else if (mode.value === "staff") rows.value = (await allPages("/api/transactions")).filter((t) => t.needs_action !== false);
        else {
            const res = await api.get(`${summaryApiBase()}/overdue`, { params: { month: "all" } });
            rows.value = res.data?.rows ?? [];
        }
        now.value = Date.now();
    } catch {
        /* keep the last list; the next poll retries */
    } finally {
        loading.value = false;
    }
}

const dur = (min) => {
    if (min < 60) return `${Math.max(1, Math.round(min))}m`;
    if (min < 1440) return `${Math.round(min / 60)}h`;
    return `${Math.round(min / 1440)}d`;
};

const items = computed(() => {
    const out = [];
    for (const t of rows.value) {
        const ref = t.reference_number || `#${t.id}`;
        if (mode.value === "admin") {
            out.push({
                key: `${t.id}:overdue:${t.entered_at}`,
                id: t.id,
                ref,
                title: t.title,
                kind: "overdue",
                text: `${dur(t.overdue_minutes || 0)} past the limit at ${t.current_step?.name || "its step"}`,
            });
            continue;
        }
        const state = dueState(t, now.value);
        const step = t.current_step?.name || "your step";
        const entered = Date.parse(t.entered_at || "");
        if (state) {
            const limit = Number(t.current_step?.sla_minutes || 0) * 60000;
            const used = workingMs(entered, now.value);
            out.push({
                key: `${t.id}:${state}:${t.entered_at}`,
                id: t.id,
                ref,
                title: t.title,
                kind: state,
                text: state === "overdue" ? `${dur((used - limit) / 60000)} past the limit at ${step}` : `${dur((limit - used) / 60000)} left at ${step}`,
            });
        } else if (Number.isFinite(entered) && now.value - entered <= NEW_MS) {
            out.push({ key: `${t.id}:new:${t.entered_at}`, id: t.id, ref, title: t.title, kind: "new", text: `arrived at ${step}` });
        }
    }
    const rank = { overdue: 0, due: 1, new: 2 };
    return out.sort((a, b) => rank[a.kind] - rank[b.kind]);
});

// ---- Seen marks (this browser only) ----
const seenKey = () => `tms.bellSeen.${user.value?.id}`;
const seen = ref(new Set());
function readSeen() {
    try {
        seen.value = new Set(JSON.parse(localStorage.getItem(seenKey()) || "[]"));
    } catch {
        seen.value = new Set();
    }
}
function markAllSeen() {
    const keys = items.value.map((n) => n.key);
    seen.value = new Set(keys);
    try {
        localStorage.setItem(seenKey(), JSON.stringify(keys.slice(0, 500)));
    } catch {
        /* storage blocked: the badge just resets on reload */
    }
}
const unseen = computed(() => items.value.filter((n) => !seen.value.has(n.key)).length);

// Highlight what was unseen when the menu opened, then mark it all seen.
const seenAtOpen = ref(new Set());
watch(open, (isOpen) => {
    if (isOpen) {
        seenAtOpen.value = new Set(seen.value);
        markAllSeen();
    }
});

function go(n) {
    open.value = false;
    router.push(mode.value === "staff" ? `/my/transactions/${n.id}` : `/transactions/${n.id}`);
}

watch(
    () => [user.value?.id, mode.value],
    () => {
        rows.value = [];
        if (!mode.value) return;
        readSeen();
        load();
    },
    { immediate: true },
);

useSmartPoll(load, { enabled: () => !!mode.value });
let clock = null;
onMounted(() => {
    clock = setInterval(() => {
        now.value = Date.now();
    }, CLOCK_MS);
});
onUnmounted(() => clearInterval(clock));
</script>

<style scoped>
/* Same look as the app bar's pill segments (AppShell .nav-seg / .nav-sep). */
.bell-btn {
    display: flex;
    align-items: center;
    align-self: stretch;
    padding: 0 14px;
    background: none;
    border: 0;
    color: inherit;
    cursor: pointer;
    transition: background-color 0.15s ease;
}
.bell-btn:hover,
.bell-btn:focus-visible {
    background: rgba(255, 255, 255, 0.14);
    outline: none;
}
.bell-sep {
    align-self: center;
    width: 1px;
    height: 18px;
    background: rgba(255, 255, 255, 0.28);
}
.bell-card {
    width: 380px;
    max-width: calc(100vw - 32px);
}
.bell-list {
    max-height: min(60vh, 460px);
    overflow-y: auto;
}
.bell-list .is-unseen {
    background: rgba(var(--v-theme-primary), 0.06);
}
</style>
