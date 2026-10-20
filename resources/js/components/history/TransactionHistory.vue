<template>
    <v-card :rounded="bare ? undefined : '0'" :elevation="bare ? 0 : 1" :class="bare ? 'history-bare' : 'lgu-card mb-4'">
        <v-card-title class="d-flex align-center flex-wrap pa-5 ga-3">
            <template v-if="!bare">
            <v-avatar color="grey-darken-3" rounded="0" size="36" class="mr-1">
                <v-icon color="white" size="20">mdi-history</v-icon>
            </v-avatar>
            <div class="mr-4">
                <div class="text-h6 font-weight-bold lh-1">Transaction History</div>
                <div class="text-caption text-medium-emphasis">Track every action and movement made on this transaction.</div>
            </div>
            <v-spacer />
            </template>
            <v-select
                v-model="actionFilter"
                :items="actionOptions"
                item-title="label"
                item-value="value"
                label="All Actions"
                density="compact"
                variant="outlined"
                rounded="0"
                hide-details
                clearable
                style="max-width: 190px"
            />
            <v-text-field
                v-model="search"
                label="Search history..."
                prepend-inner-icon="mdi-magnify"
                density="compact"
                variant="outlined"
                rounded="0"
                hide-details
                clearable
                style="max-width: 230px"
            />
        </v-card-title>
        <v-divider />
        <v-card-text class="pa-0">
            <div v-if="loading" class="pa-4">
                <v-skeleton-loader v-for="n in 5" :key="n" type="table-row" class="mb-2" />
            </div>

            <div v-else-if="!filtered.length" class="text-center pa-8">
                <img :src="mascotEmptyUrl" alt="No history yet" width="180" class="mb-3" style="border-radius: 18px" />
                <div class="font-weight-bold">No transaction history yet.</div>
            </div>

            <!-- Desktop table -->
            <div v-else class="d-none d-md-block">
                <v-table hover density="comfortable" class="lgu-table history-table">
                    <thead>
                        <tr>
                            <th class="text-left">Step</th>
                            <th class="text-left">Movement</th>
                            <th class="text-left">Action</th>
                            <th class="text-left">Performed By</th>
                            <th class="text-left">Date &amp; Time</th>
                            <th class="text-left">SLA</th>
                            <th class="text-left">Status</th>
                            <th class="text-right" style="width: 48px"><span class="sr-only">Details</span></th>
                        </tr>
                    </thead>
                    <tbody>
                        <template v-for="(run, idx) in filtered" :key="run.id">
                            <tr class="history-row" @click="toggle(run.id)">
                                <td>
                                    <v-avatar
                                        size="32"
                                        color="white"
                                        :class="idx === 0 ? 'history-step-latest font-weight-bold' : 'history-step-ring font-weight-bold'"
                                    >
                                        {{ stepLabelOf(run, filtered.length - idx) }}
                                    </v-avatar>
                                </td>
                                <td>
                                    <div class="font-weight-medium">
                                        {{ movementOf(run).from }}
                                        <template v-if="movementOf(run).to"> → {{ movementOf(run).to }}</template>
                                    </div>
                                    <div v-if="movementOf(run).sub" class="text-caption text-medium-emphasis">{{ movementOf(run).sub }}</div>
                                </td>
                                <td>
                                    <v-chip size="small" variant="tonal" rounded="0" :color="getActionConfig(run.action_code).color">
                                        <v-icon start size="small">{{ getActionConfig(run.action_code).icon }}</v-icon>
                                        {{ getActionConfig(run.action_code).label }}
                                    </v-chip>
                                </td>
                                <td>
                                    <div class="d-flex align-center ga-2">
                                        <v-avatar size="30" color="grey-lighten-3" class="font-weight-bold text-caption text-grey-darken-3">
                                            {{ getUserInitials(run.performed_by?.name) }}
                                        </v-avatar>
                                        <div>
                                            <div class="text-body-2 font-weight-medium lh-1">{{ run.performed_by?.name || '—' }}</div>
                                            <div v-if="userRoleText(run.performed_by)" class="text-caption text-medium-emphasis">{{ userRoleText(run.performed_by) }}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="text-body-2 text-no-wrap">{{ formatHistoryDate(mainTimestamp(run)) }}</div>
                                </td>
                                <td>
                                    <div class="font-weight-medium text-no-wrap">{{ slaMain(run) }}</div>
                                    <div class="text-caption text-medium-emphasis">{{ slaCaption(run) }}</div>
                                </td>
                                <td>
                                    <v-chip size="small" variant="tonal" :color="getStatusConfig(run).color" class="font-weight-medium">
                                        <span :class="['status-dot mr-1', getStatusConfig(run).dot]" />
                                        {{ getStatusConfig(run).label }}
                                    </v-chip>
                                </td>
                                <td class="text-right">
                                    <v-btn
                                        :icon="isOpen(run.id) ? 'mdi-chevron-up' : 'mdi-chevron-down'"
                                        size="small"
                                        variant="text"
                                        color="grey-darken-3"
                                        :aria-expanded="isOpen(run.id)"
                                        aria-label="View history details"
                                        @click.stop="toggle(run.id)"
                                    />
                                </td>
                            </tr>
                            <tr v-if="isOpen(run.id)" :key="`d-${run.id}`" class="history-details-row">
                                <td colspan="8" class="history-details-cell">
                                    <v-row dense>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">From Step</div>
                                            <div class="history-value">{{ detailStepText(run.from_step) }}</div>
                                        </v-col>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">To Step</div>
                                            <div class="history-value">{{ detailStepText(run.to_step) }}</div>
                                        </v-col>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">From User</div>
                                            <div class="history-value">{{ run.performed_by?.name || '—' }}<span v-if="userRoleText(run.performed_by)" class="text-medium-emphasis"> · {{ userRoleText(run.performed_by) }}</span></div>
                                        </v-col>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">To User</div>
                                            <div class="history-value">{{ run.received_by?.name || '—' }}<span v-if="userRoleText(run.received_by)" class="text-medium-emphasis"> · {{ userRoleText(run.received_by) }}</span></div>
                                        </v-col>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">Released</div>
                                            <div class="history-value">{{ formatHistoryDate(run.released_at || run.performed_at) }}</div>
                                        </v-col>
                                        <v-col cols="12" sm="6">
                                            <div class="history-label">Received</div>
                                            <div class="history-value">{{ run.received_at ? formatHistoryDate(run.received_at) : 'Pending' }}</div>
                                        </v-col>
                                        <v-col cols="12">
                                            <div class="history-label">Remarks</div>
                                            <div class="history-value">{{ run.remarks || 'No remarks provided.' }}</div>
                                        </v-col>
                                        <v-col cols="12">
                                            <div class="history-label mb-2">Attachments</div>
                                            <AttachmentList
                                                v-if="(run.attachments || []).length"
                                                :items="run.attachments || []"
                                                :tx-id="txId"
                                                :is-admin="isAdmin"
                                                :show-details="false"
                                                @deleted="emit('deleted', $event)"
                                            />
                                            <div v-else class="text-caption text-medium-emphasis">No files attached.</div>
                                        </v-col>
                                    </v-row>
                                </td>
                            </tr>
                        </template>
                    </tbody>
                </v-table>
            </div>

            <!-- Mobile cards -->
            <div v-if="!loading && filtered.length" class="d-block d-md-none pa-3">
                <v-card
                    v-for="(run, idx) in filtered"
                    :key="`m-${run.id}`"
                    variant="outlined"
                    rounded="0"
                    class="mb-3"
                >
                    <v-card-text class="pa-3" @click="toggle(run.id)">
                        <div class="d-flex align-center justify-space-between mb-2">
                            <div class="d-flex align-center ga-2">
                                <v-avatar
                                    size="28"
                                    color="white"
                                    :class="idx === 0 ? 'history-step-latest font-weight-bold text-caption' : 'history-step-ring font-weight-bold text-caption'"
                                >
                                    {{ stepLabelOf(run, filtered.length - idx) }}
                                </v-avatar>
                                <v-chip size="small" variant="tonal" :color="getStatusConfig(run).color" class="font-weight-medium">
                                    <span :class="['status-dot mr-1', getStatusConfig(run).dot]" />
                                    {{ getStatusConfig(run).label }}
                                </v-chip>
                            </div>
                            <v-btn
                                :icon="isOpen(run.id) ? 'mdi-chevron-up' : 'mdi-chevron-down'"
                                size="x-small"
                                variant="text"
                                color="grey-darken-3"
                                :aria-expanded="isOpen(run.id)"
                                aria-label="View history details"
                                @click.stop="toggle(run.id)"
                            />
                        </div>
                        <div class="font-weight-bold">{{ movementOf(run).from }}<template v-if="movementOf(run).to"> → {{ movementOf(run).to }}</template></div>
                        <div v-if="movementOf(run).sub" class="text-caption text-medium-emphasis">{{ movementOf(run).sub }}</div>
                        <div class="mt-2">
                            <v-chip size="small" variant="tonal" rounded="0" :color="getActionConfig(run.action_code).color">
                                <v-icon start size="small">{{ getActionConfig(run.action_code).icon }}</v-icon>
                                {{ getActionConfig(run.action_code).label }}
                            </v-chip>
                        </div>
                        <div class="d-flex align-center ga-2 mt-2">
                            <v-avatar size="28" color="grey-lighten-3" class="font-weight-bold text-caption text-grey-darken-3">
                                {{ getUserInitials(run.performed_by?.name) }}
                            </v-avatar>
                            <div>
                                <div class="text-body-2 font-weight-medium lh-1">{{ run.performed_by?.name || '—' }}</div>
                                <div v-if="userRoleText(run.performed_by)" class="text-caption text-medium-emphasis">{{ userRoleText(run.performed_by) }}</div>
                            </div>
                        </div>
                        <div class="text-caption text-medium-emphasis mt-2">{{ formatHistoryDate(mainTimestamp(run)) }}</div>
                        <div class="mt-1">
                            <span class="text-caption text-medium-emphasis">SLA </span>
                            <span class="font-weight-medium text-body-2">{{ slaMain(run) }}</span>
                        </div>
                        <v-expand-transition>
                            <div v-if="isOpen(run.id)" class="mt-3 pt-3 history-mobile-details" @click.stop>
                                <div class="history-label">From Step</div>
                                <div class="history-value mb-2">{{ detailStepText(run.from_step) }}</div>
                                <div class="history-label">To Step</div>
                                <div class="history-value mb-2">{{ detailStepText(run.to_step) }}</div>
                                <div class="history-label">From User</div>
                                <div class="history-value mb-2">{{ run.performed_by?.name || '—' }}<span v-if="userRoleText(run.performed_by)" class="text-medium-emphasis"> · {{ userRoleText(run.performed_by) }}</span></div>
                                <div class="history-label">To User</div>
                                <div class="history-value mb-2">{{ run.received_by?.name || '—' }}<span v-if="userRoleText(run.received_by)" class="text-medium-emphasis"> · {{ userRoleText(run.received_by) }}</span></div>
                                <div class="history-label">Released</div>
                                <div class="history-value mb-2">{{ formatHistoryDate(run.released_at || run.performed_at) }}</div>
                                <div class="history-label">Received</div>
                                <div class="history-value mb-2">{{ run.received_at ? formatHistoryDate(run.received_at) : 'Pending' }}</div>
                                <div class="history-label">Remarks</div>
                                <div class="history-value mb-2">{{ run.remarks || 'No remarks provided.' }}</div>
                                <div class="history-label mb-2">Attachments</div>
                                <AttachmentList
                                    v-if="(run.attachments || []).length"
                                    :items="run.attachments || []"
                                    :tx-id="txId"
                                    :is-admin="isAdmin"
                                    :show-details="false"
                                    @deleted="emit('deleted', $event)"
                                />
                                <div v-else class="text-caption text-medium-emphasis">No files attached.</div>
                            </div>
                        </v-expand-transition>
                    </v-card-text>
                </v-card>
            </div>
        </v-card-text>
    </v-card>
</template>

<script setup>
import { ref, computed } from 'vue';
import AttachmentList from '@/components/AttachmentList.vue';
import mascotEmptyUrl from '@/assets/mascots/mascot-empty.jpg';
import {
    formatHistoryDate,
    formatMinutes,
    getActionConfig,
    getStatusConfig,
    getUserInitials,
    mainTimestamp,
    movementOf,
    stepLabelOf,
    detailStepText,
    userRoleText,
} from '@/utils/history';

const props = defineProps({
    runs: { type: Array, default: () => [] },
    loading: { type: Boolean, default: false },
    txId: { type: [Number, String], default: null },
    isAdmin: { type: Boolean, default: false },
    // Bare mode: melt into a parent tab pane (no outer chrome/title),
    // keeping the filter + search toolbar above the same content.
    bare: { type: Boolean, default: false },
});
const emit = defineEmits(['deleted']);

const actionFilter = ref(null);
const search = ref('');
const openIds = ref(new Set());

function toggle(id) {
    const next = new Set(openIds.value);
    if (next.has(id)) next.delete(id);
    else next.add(id);
    openIds.value = next;
}
function isOpen(id) {
    return openIds.value.has(id);
}

const actionOptions = computed(() => {
    const seen = new Map();
    for (const r of (props.runs || [])) {
        const cfg = getActionConfig(r?.action_code);
        if (!seen.has(cfg.code)) seen.set(cfg.code, cfg.label);
    }
    return [...seen.entries()].map(([value, label]) => ({ value, label }));
});

const filtered = computed(() => {
    let rows = [...(props.runs || [])];
    if (actionFilter.value) {
        rows = rows.filter((r) => String(r?.action_code || '').toLowerCase() === String(actionFilter.value).toLowerCase());
    }
    const q = String(search.value || '').trim().toLowerCase();
    if (q) {
        rows = rows.filter((r) => {
            const hay = [
                r?.action_code,
                getActionConfig(r?.action_code).label,
                r?.remarks,
                r?.performed_by?.name,
                r?.received_by?.name,
                movementOf(r).from,
                movementOf(r).to,
                detailStepText(r?.from_step),
                detailStepText(r?.to_step),
            ].filter(Boolean).join(' ').toLowerCase();
            return hay.includes(q);
        });
    }
    return rows;
});

function slaMain(run) {
    const actual = run?.sla_actual_minutes;
    const est = run?.duration_estimated_minutes ?? run?.sla_minutes_snapshot;
    const a = actual == null ? '—' : formatMinutes(actual);
    return `${a} / ${formatMinutes(est)}`;
}
function slaCaption(run) {
    if (run?.received_at == null) return 'Awaiting receipt';
    return 'Actual / Allowed';
}
</script>

<style scoped>
.history-table thead th {
    background: #f8fafc;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: #64748b;
    padding: 12px 16px;
    white-space: nowrap;
}
.history-table tbody td {
    padding: 16px;
    vertical-align: middle;
}
.history-row {
    cursor: pointer;
    transition: background-color 0.15s ease;
}
.history-row:hover {
    background: rgba(248, 250, 252, 0.7);
}
.history-step-ring {
    border: 1px solid rgba(30, 64, 175, 0.45);
    color: rgb(var(--v-theme-primary));
}
/* Latest row: header-icon language — white fill, primary number + ring. */
.history-step-latest {
    border: 2px solid rgb(var(--v-theme-primary));
    color: rgb(var(--v-theme-primary));
    box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.12);
}
.history-details-cell {
    background: rgba(248, 250, 252, 0.7);
    border-top: 1px solid #f1f5f9;
    padding: 20px !important;
}
.history-label {
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: #94a3b8;
    margin-bottom: 2px;
}
.history-value {
    font-size: 14px;
    color: #334155;
}
.history-mobile-details {
    border-top: 1px solid #f1f5f9;
}
.status-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    display: inline-block;
}
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
}
/* Bare mode (inside tab pane): no card surface of its own. */
.history-bare {
    background-color: transparent;
}
</style>
