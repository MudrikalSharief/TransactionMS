<template>
    <!-- Hover card (not tooltip): stays open while the cursor is on the
    dark detail card, so moving off the node onto the card won't
    dismiss it. -->
    <v-menu
        :disabled="!hasExtra"
        location="bottom"
        max-width="420"
        open-on-hover
        open-on-focus
        open-delay="150"
        close-delay="150"
        :close-on-content-click="false"
    >
        <template #activator="{ props }">
            <div
                v-bind="props"
                class="d-flex flex-column align-center flex-shrink-0 station-node"
                style="width: 110px"
                :data-node="dataNode"
            >
                <v-avatar
                    :color="avatarColor"
                    size="42"
                >
                    <v-icon
                        v-if="isLast"
                        :color="state === 'upcoming' ? 'grey-darken-1' : state === 'passed' ? 'grey-darken-3' : 'white'"
                        size="26"
                    >
                        mdi-check
                    </v-icon>
                    <span
                        v-else
                        class="font-weight-bold"
                        :class="avatarTextClass"
                        style="font-size: 1.1rem"
                    >
                        {{ index + 1 }}
                    </span>
                </v-avatar>
                <div
                    class="text-caption text-center mt-1 step-label"
                    :class="state === 'current' ? 'font-weight-bold' : 'text-medium-emphasis'"
                    :title="(s.name || s.code || `Step ${index + 1}`) + (s.code && s.name ? ` (${s.code})` : '')"
                >
                    {{ s.name || s.code || `Step ${index + 1}` }}
                </div>
                <v-chip
                    v-if="state === 'current'"
                    color="primary"
                    variant="tonal"
                    rounded="0"
                    size="small"
                    class="mt-3 font-weight-bold"
                >
                    You are Here
                </v-chip>
            </div>
        </template>
        <v-card class="hover-card" theme="dark" role="dialog" :aria-label="`Step ${stepNumber} details`">
            <!-- Section A: header -->
            <div class="hover-sec">
                <div class="hover-toprow">
                    <span class="hover-steplabel">Step {{ stepNumber }}</span>
                    <span class="hover-badge" :class="`hover-badge-${badgeKind}`"><v-icon size="x-small" aria-hidden="true">mdi-check</v-icon>{{ badgeText }}</span>
                </div>
                <div class="hover-title">{{ titleText }}</div>
                <div class="hover-assigned">
                    {{ viewer ? 'Office' : 'Assigned office' }}: <b>{{ assignedOfficeLabel }}</b>
                </div>
                <div v-if="showCallout" class="hover-callout">
                    <v-icon size="small" color="#7ab7ff" aria-hidden="true">mdi-information-outline</v-icon>
                    <span>{{ hintText }}</span>
                </div>
            </div>
            <div v-if="showChecklistSection && move" class="hover-div" />
            <!-- Section B: checklist -->
            <div v-if="showChecklistSection" class="hover-sec">
                <div class="hover-sec-head"><span>Requirements</span><span v-if="hasChecklist">{{ doneCount }} of {{ totalCount }} done</span></div>
                <div v-if="hasChecklist" class="hover-panel">
                    <div v-for="row in checklistRows" :key="row.key" class="hover-item">
                        <div class="hover-item-row">
                            <span class="hover-dot" :class="{ done: row.done }"><v-icon v-if="row.done" size="x-small" aria-hidden="true">mdi-check</v-icon></span>
                            <span class="hover-item-label">{{ row.label }}</span>
                            <span v-if="row.owner" class="hover-item-owner">{{ row.owner }}</span>
                        </div>
                        <div v-if="row.files.length" class="hover-chips">
                            <div v-for="f in row.files" :key="f.id" class="hover-filewrap">
                                <a
                                    :href="f.url"
                                    target="_blank"
                                    rel="noopener"
                                    class="hover-chip"
                                >
                                    <v-icon size="x-small" color="#f0716b" aria-hidden="true">mdi-file-document-outline</v-icon>
                                    <span class="hover-chip-name">{{ f.name }}</span>
                                    <span class="hover-chip-size">{{ f.size }}</span>
                                    <v-icon size="x-small" aria-hidden="true">mdi-eye-outline</v-icon>
                                </a>
                                <div v-if="f.from" class="hover-from">{{ f.from }}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-else class="hover-muted">No checklist items.</div>
                <div v-if="filesHidden" class="hover-muted">
                    Files from this step are not shown. You can only open files from the previous step.
                </div>
                <template v-if="moveLevelFiles.length">
                    <div class="hover-files-label">Files</div>
                    <div class="hover-chips">
                        <div v-for="f in moveLevelFiles" :key="f.id" class="hover-filewrap">
                            <a
                                :href="f.url"
                                target="_blank"
                                rel="noopener"
                                class="hover-chip"
                            >
                                <v-icon size="x-small" color="#f0716b" aria-hidden="true">mdi-file-document-outline</v-icon>
                                <span class="hover-chip-name">{{ f.name }}</span>
                                <span class="hover-chip-size">{{ f.size }}</span>
                                <v-icon size="x-small" aria-hidden="true">mdi-eye-outline</v-icon>
                            </a>
                            <div v-if="f.from" class="hover-from">{{ f.from }}</div>
                        </div>
                    </div>
                </template>
            </div>
            <div v-if="showChecklistSection && move" class="hover-div" />
            <!-- Section C: moved (or creation for self-loop runs) -->
            <div v-if="move" class="hover-sec">
                <div class="hover-moved-head"><span>{{ isSelfLoop ? 'Created' : 'Moved' }}</span><span v-if="moveAction" class="hover-act" :class="moveAction.cls">{{ moveAction.text }}</span></div>
                <div v-if="!isSelfLoop" class="hover-trans">
                    <span class="hover-pill hover-pill-from">{{ moveFrom }}</span>
                    <v-icon size="small" aria-hidden="true">mdi-arrow-right</v-icon>
                    <span class="hover-pill hover-pill-to">{{ moveTo }}</span>
                </div>
                <!-- Viewers see the time only, no office badge or name. -->
                <div class="hover-meta">
                    <template v-if="!viewer">
                        <span class="hover-avatar">{{ avatarLetter }}</span>
                        <span class="hover-by">{{ moveBy }}</span>
                    </template>
                    <span class="hover-at" :title="moveAtFull">{{ viewer ? moveAt : `· ${moveAt}` }}</span>
                </div>
                <div v-if="moveRemarks" class="hover-remarks">“{{ moveRemarks }}”</div>
            </div>
        </v-card>
    </v-menu>
</template>

<script setup>
import { computed } from 'vue'
import { fileViewUrl } from '@/composables/useFileView'

const props = defineProps({
    s: { type: Object, required: true },
    index: { type: Number, required: true },
    state: { type: String, default: 'upcoming' },
    isLast: { type: Boolean, default: false },
    detail: { type: Object, default: null },
    move: { type: Object, default: null },
    dataNode: { type: [Number, String, null], default: null },
    viewer: { type: Boolean, default: false },
})

// purple = current, green = visited behind, pale blue = already passed ahead.
const avatarColor = computed(() => {
    if (props.state === 'done') return 'success';
    if (props.state === 'current') return 'primary';
    if (props.state === 'passed') return '#BFDBFE';
    return 'grey-lighten-2';
});
const avatarTextClass = computed(() => {
    if (props.state === 'upcoming') return 'text-grey-darken-1';
    if (props.state === 'passed') return 'text-grey-darken-3';
    return 'text-white';
});

const hasExtra = computed(() =>
    !!props.detail || !!props.move || props.state !== 'upcoming',
);

const stepNumber = computed(() => props.s?.order_number ?? (props.index + 1));
const titleText = computed(() => props.s?.name || props.s?.code || `Step ${props.index + 1}`);
const assignedOfficeLabel = computed(() => {
    const office = props.s?.office;
    return office?.name || office?.code || "User's Office";
});

const badgeText = computed(() => {
    if (props.state === 'current') return 'Current';
    if (props.state === 'done') return 'Done';
    if (props.state === 'passed') return 'Passed';
    return 'Upcoming';
});
const badgeKind = computed(() => {
    if (props.state === 'current') return 'blue';
    if (props.state === 'upcoming') return 'grey';
    return 'green';
});

const hintText = computed(() => {
    if (props.state === 'current') return 'In progress — this is where the paper sits.';
    if (props.state === 'done') return 'Passed — you can go back here from Available Actions.';
    if (props.state === 'passed') return 'This step is already complete. Continue forward, step by step, to return here.';
    return 'Not reached yet.';
});
const showCallout = computed(() => props.state !== 'upcoming');

function formatSize(b) {
    const n = Number(b || 0);
    if (n < 1024) return `${n} B`;
    if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
    return `${(n / 1024 / 1024).toFixed(1)} MB`;
}

function formatDate(iso) {
    if (!iso) return '';
    const d = new Date(iso);
    if (isNaN(d)) return String(iso);
    const parts = new Intl.DateTimeFormat(undefined, {
        month: 'short', day: 'numeric', year: 'numeric',
        hour: 'numeric', minute: '2-digit', hour12: true,
        timeZone: 'Asia/Manila',
    }).formatToParts(d);
    const get = (t) => parts.find((p) => p.type === t)?.value || '';
    return `${get('month')} ${get('day')}, ${get('year')}, ${get('hour')}:${get('minute')} ${get('dayPeriod')} PHT`;
}

function toFileChip(a) {
    const src = a?.source_step || null;
    return {
        id: a?.id ?? a?.original_name,
        name: a?.original_name || a?.label || 'File',
        size: formatSize(a?.size_bytes),
        url: fileViewUrl(a),
        from: src ? `from Step ${src.order_number} · ${src.name || src.code || ''}`.trim() : '',
    };
}

const checklistRows = computed(() => {
    const reqs = props.detail?.requirements || [];
    return reqs.map((r, i) => ({
        key: r?.definition?.id ?? `${props.s?.id}-${i}`,
        label: r?.definition?.name || r?.definition?.code || 'Item',
        done: !!r?.checked,
        owner: r?.checked_by?.name || '',
        files: (r?.attachments || []).map(toFileChip),
    }));
});
const hasChecklist = computed(() => checklistRows.value.length > 0);
const showChecklistSection = computed(() => !!props.detail);
const doneCount = computed(() => checklistRows.value.filter((r) => r.done).length);
const totalCount = computed(() => checklistRows.value.length);

const moveLevelFiles = computed(() => (props.detail?.attachments || []).map(toFileChip));
// Step file rule: the server leaves out files of steps the user may not
// open (only the previous step). Say so when this step has files at all.
const filesHidden = computed(
    () =>
        props.detail?.files_visible === false &&
        (props.detail?.requirements || []).some((r) => Number(r?.attachment_count || 0) > 0),
);

const moveFrom = computed(() => {
    const s = props.move?.from_step;
    const name = s?.name || s?.code || '—';
    return s?.order_number != null && s?.order_number !== '' ? `${s.order_number}. ${name}` : name;
});
const moveTo = computed(() => {
    const s = props.move?.to_step;
    const name = s?.name || s?.code || '—';
    return s?.order_number != null && s?.order_number !== '' ? `${s.order_number}. ${name}` : name;
});
const moveBy = computed(() => props.move?.performed_by?.name || '—');
const moveAt = computed(() => formatDate(props.move?.performed_at));
const moveAtFull = computed(() => props.move?.performed_at || '');
const moveRemarks = computed(() => String(props.move?.remarks || '').trim());
// Creation runs loop back onto their own station (from == to): rendered
// as "Created", never as a from → to move.
const isSelfLoop = computed(() => {
    const f = props.move?.from_step?.id ?? props.move?.from_step_id;
    const t = props.move?.to_step?.id ?? props.move?.to_step_id;
    return f !== undefined && f !== null && String(f) === String(t);
});
const moveAction = computed(() => {
    const c = String(props.move?.action_code || '').trim().toLowerCase();
    if (!c) return null;
    if (c === 'return') return { text: 'Returned', cls: 'hover-act-return' };
    if (c === 'resend') return { text: 'Resent', cls: 'hover-act-resend' };
    if (c === 'create') return { text: 'Created', cls: 'hover-act-created' };
    return { text: c.charAt(0).toUpperCase() + c.slice(1), cls: 'hover-act-other' };
});
const avatarLetter = computed(() => String(moveBy.value || '?').trim().charAt(0).toUpperCase() || '?');
</script>

<style scoped>
.hover-card {
    font-family: Figtree, 'Helvetica Neue', Arial, sans-serif;
    width: min(400px, calc(100vw - 16px));
    background: #1f2125 !important;
    background-color: #1f2125 !important;
    color-scheme: dark;
    border: 1px solid #34373d;
    border-radius: 14px;
    box-shadow: 0 18px 48px rgba(0, 0, 0, 0.5);
    color: #ececee;
    overflow: hidden;
    animation: hover-in 120ms ease;
}
@media (prefers-reduced-motion: reduce) {
    .hover-card { animation: none; }
}
@keyframes hover-in {
    from { opacity: 0; transform: translateY(4px); }
    to { opacity: 1; transform: translateY(0); }
}
.hover-sec { padding: 14px 20px; }
.hover-sec:first-child { padding: 18px 20px 14px; }
.hover-sec:last-child { padding-bottom: 18px; }
.hover-div { height: 1px; background: #2e3136; }
.hover-toprow {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 8px;
}
.hover-steplabel {
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca0a8;
}
.hover-badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    font-weight: 600;
    padding: 4px 10px;
    border-radius: 999px;
}
.hover-badge-green {
    color: #6fd8a6;
    background: rgba(76, 195, 138, 0.14);
}
.hover-badge-blue {
    color: #7ab7ff;
    background: rgba(122, 183, 255, 0.14);
}
.hover-badge-grey {
    color: #c4c8d0;
    background: #2a2d33;
}
.hover-title {
    font-size: 18px;
    font-weight: 700;
    line-height: 1.3;
    color: #ffffff;
    overflow-wrap: break-word;
}
.hover-assigned {
    margin-top: 5px;
    font-size: 12.5px;
    color: #9ca0a8;
}
.hover-assigned b {
    color: #ececee;
    font-weight: 600;
}
.hover-callout {
    display: flex;
    gap: 8px;
    align-items: flex-start;
    background: #272b33;
    border-radius: 10px;
    padding: 10px 12px;
    margin-top: 10px;
    font-size: 13px;
    line-height: 1.45;
    color: #ececee;
}
.hover-sec-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca0a8;
    margin-bottom: 8px;
}
.hover-sec-label {
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca0a8;
    margin-bottom: 8px;
}
.hover-muted { font-size: 13px; color: #9ca0a8; }
.hover-panel {
    background: #25282d;
    border: 1px solid #2e3136;
    border-radius: 10px;
    padding: 12px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.hover-item { display: flex; flex-direction: column; gap: 6px; }
.hover-item-row { display: flex; align-items: center; gap: 10px; }
.hover-dot {
    flex: 0 0 auto;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    border: 1.5px solid #9ca0a8;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: #1f2125;
}
.hover-dot.done {
    background: #4cc38a;
    border-color: #4cc38a;
    color: #1f2125;
}
.hover-item-label {
    flex: 1 1 auto;
    font-size: 14px;
    font-weight: 600;
    color: #ffffff;
    overflow-wrap: anywhere;
}
.hover-item-owner { font-size: 12px; color: #9ca0a8; }
.hover-chips { display: flex; flex-direction: column; gap: 6px; margin-left: 30px; }
.hover-files-label + .hover-chips { margin-left: 0; }
.hover-filewrap { display: flex; flex-direction: column; gap: 2px; }
.hover-from { font-size: 11px; color: #9ca0a8; margin-left: 2px; }
.hover-chip {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #1b1d21;
    border: 1px solid #34373d;
    border-radius: 8px;
    padding: 6px 8px;
    text-decoration: none;
    font-size: 13px;
}
.hover-chip-name {
    flex: 1 1 auto;
    color: #7ab7ff;
    font-weight: 600;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.hover-chip:hover .hover-chip-name { color: #a6cfff; }
.hover-chip-size { color: #9ca0a8; font-size: 12px; }
.hover-chip .v-icon:last-child { color: #9ca0a8; }
.hover-files-label {
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca0a8;
    margin: 8px 0 6px;
}
.hover-trans { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.hover-moved-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: #9ca0a8;
    margin-bottom: 8px;
}
.hover-act {
    font-size: 11px;
    font-weight: 700;
    text-transform: none;
    letter-spacing: 0;
    padding: 2px 10px;
    border-radius: 999px;
}
.hover-act-return { color: #fbbf24; background: rgba(251, 191, 36, 0.14); }
.hover-act-resend { color: #c4b5fd; background: rgba(196, 181, 253, 0.14); }
.hover-act-created { color: #c4c8d0; background: #2a2d33; }
.hover-act-other { color: #7ab7ff; background: rgba(122, 183, 255, 0.14); }
.hover-pill {
    font-size: 12px;
    padding: 4px 10px;
    border-radius: 6px;
}
.hover-pill-from { background: #2a2d33; color: #c4c8d0; }
.hover-pill-to { background: #2d3a52; color: #ffffff; font-weight: 700; }
.hover-meta { display: flex; align-items: center; gap: 8px; font-size: 13px; }
.hover-avatar {
    flex: 0 0 auto;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background: #3b4a6b;
    color: #dbe6ff;
    font-size: 12px;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}
.hover-by { color: #ececee; font-weight: 600; }
.hover-at { color: #9ca0a8; }
.hover-remarks { margin-top: 6px; font-size: 13px; color: #c4c8d0; font-style: italic; }
.station-node { border-radius: 8px; }
.step-label {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.35;
    overflow-wrap: break-word;
    font-size: 0.85rem;
}
</style>
