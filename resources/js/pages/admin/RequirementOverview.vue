<template>
    <div class="ro-page">
        <v-alert
            v-if="error"
            type="error"
            variant="tonal"
            density="compact"
            class="mb-4"
        >
            {{ error }}
        </v-alert>

        <WorkflowPageHeader
            icon="mdi-view-column-outline"
            title="Requirement Overview"
            subtitle="See what each step asks for, and which requirements carry over to the next step."
            read-only
            @back="goBack"
        />

        <div class="ro-shell" aria-live="polite">
            <div v-if="loading" class="ro-loading">
                <TableLoader
                    compact
                    label="requirement overview"
                    icon="mdi-view-column-outline"
                />
            </div>

            <template v-else>
                <div class="ro-bar">
                    <div class="ro-stat">
                        <b>{{ overview.columns.length }}</b>
                        <span>steps</span>
                    </div>
                    <div class="ro-stat">
                        <b>{{ overview.requirementCount }}</b>
                        <span>requirements</span>
                    </div>
                    <div class="ro-stat">
                        <b>{{ overview.carriedCount }}</b>
                        <span>carried over</span>
                    </div>

                    <div class="ro-legend" aria-label="Legend">
                        <span class="ro-legend-item">
                            <svg
                                class="ro-lk"
                                viewBox="0 0 34 12"
                                aria-hidden="true"
                            >
                                <path d="M0 6h34" />
                            </svg>
                            Same requirement in the next step
                        </span>
                        <span class="ro-tag ro-tag-r">Required</span>
                        <span class="ro-tag ro-tag-u">
                            <v-icon size="12" aria-hidden="true"
                                >mdi-paperclip</v-icon
                            >
                            Upload required
                        </span>
                    </div>
                </div>

                <div v-if="!overview.columns.length" class="ro-empty">
                    <v-icon size="36" class="ro-empty-ic"
                        >mdi-view-column-outline</v-icon
                    >
                    <b>{{
                        error ? "Couldn't load the overview" : "No steps in this workflow"
                    }}</b>
                    <span>
                        {{
                            error
                                ? "Check the error above, then try again."
                                : "Add steps in Workflows to see their requirements here."
                        }}
                    </span>
                    <button
                        v-if="error"
                        type="button"
                        class="ro-retry"
                        @click="loadPage"
                    >
                        Retry
                    </button>
                </div>

                <div
                    v-else
                    id="ro-board"
                    ref="boardEl"
                    class="ro-board"
                    tabindex="0"
                    aria-label="Requirements by step. Scroll sideways to see all steps."
                    @scroll.passive="updateViewport"
                >
                    <div ref="colsEl" class="ro-cols">
                        <svg
                            ref="linesEl"
                            class="ro-lines"
                            aria-hidden="true"
                        ></svg>

                        <section
                            v-for="column in overview.columns"
                            :key="column.id"
                            class="ro-step"
                            :aria-label="`Step ${column.stepNumber}: ${column.name}`"
                        >
                            <div class="ro-step-hd">
                                <span class="ro-step-n">{{
                                    column.stepNumber
                                }}</span>
                                <div class="ro-step-t">
                                    <small>Step {{ column.stepNumber }}</small>
                                    <b>{{ column.name }}</b>
                                </div>
                            </div>

                            <div class="ro-list">
                                <template v-if="column.reqs.length">
                                    <div
                                        v-for="req in column.reqs"
                                        :id="req.domId"
                                        :key="req.key"
                                        class="ro-req"
                                        :class="{
                                            'is-link': !!req.color,
                                            'is-unsaved': req.isUnsaved,
                                        }"
                                        :style="
                                            req.color
                                                ? { '--ro-cc': req.color }
                                                : null
                                        "
                                    >
                                        <div class="ro-req-n">
                                            {{ req.name }}
                                            <span
                                                v-if="req.isUnsaved"
                                                class="ro-req-unsaved"
                                            >
                                                UNSAVED
                                            </span>
                                        </div>
                                        <span class="ro-req-c">{{
                                            req.code || "—"
                                        }}</span>
                                        <div class="ro-tags">
                                            <span
                                                class="ro-tag"
                                                :class="
                                                    req.is_required
                                                        ? 'ro-tag-r'
                                                        : 'ro-tag-o'
                                                "
                                            >
                                                {{
                                                    req.is_required
                                                        ? "Required"
                                                        : "Optional"
                                                }}
                                            </span>
                                            <span
                                                v-if="req.is_upload_required"
                                                class="ro-tag ro-tag-u"
                                            >
                                                <v-icon
                                                    size="12"
                                                    aria-hidden="true"
                                                    >mdi-paperclip</v-icon
                                                >
                                                Upload required
                                            </span>
                                        </div>
                                    </div>
                                </template>
                                <p v-else class="ro-none">
                                    No requirements for this step
                                </p>
                            </div>
                        </section>
                    </div>
                </div>

                <div
                    v-show="!fits && overview.columns.length"
                    class="ro-mm"
                >
                    <div class="ro-mm-h">
                        <span>Minimap</span>
                        <small>{{ minimapText }}</small>
                    </div>
                    <div
                        ref="miniEl"
                        class="ro-mm-b"
                        :class="{ 'is-drag': dragging }"
                        role="scrollbar"
                        aria-controls="ro-board"
                        aria-orientation="horizontal"
                        aria-valuemin="0"
                        aria-valuemax="100"
                        :aria-valuenow="scrollPercent"
                        aria-label="Board position. Drag or use the arrow keys to move."
                        tabindex="0"
                        @pointerdown="onMiniPointerDown"
                        @pointermove="onMiniPointerMove"
                        @pointerup="onMiniPointerUp"
                        @pointercancel="onMiniPointerUp"
                        @keydown="onMiniKeydown"
                    >
                        <svg
                            ref="miniSvgEl"
                            class="ro-mm-svg"
                            aria-hidden="true"
                        ></svg>
                        <div ref="viewportEl" class="ro-vp"></div>
                    </div>
                </div>
            </template>
        </div>
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
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import TableLoader from "@/components/TableLoader.vue";
import WorkflowPageHeader from "@/components/WorkflowPageHeader.vue";

const route = useRoute();
const router = useRouter();
const { api } = useApi();

const workflowDefinitionId = computed(() => Number(route.params.workflowId));
const stepIdFromUrl = computed(() => Number(route.params.stepId));

const returnTypeId = ref(null);
const typeId = computed(() => {
    const q = Number(route.query.type);
    if (Number.isFinite(q) && q > 0) return q;
    const t = Number(returnTypeId.value);
    return Number.isFinite(t) && t > 0 ? t : null;
});

const { items: requirementDefs, fetchAll: fetchReqs } =
    useRequirementDefinitions();
const staging = useWorkflowStaging();

const steps = ref([]);
const loading = ref(true);
const error = ref("");

const bucket = computed(() =>
    typeId.value ? staging.buckets.get(String(typeId.value)) : null,
);

const catalogById = computed(() => {
    const map = new Map();
    for (const def of requirementDefs.value || []) {
        if (def?.id != null) map.set(String(def.id), def);
    }
    return map;
});

const stagedDefsById = computed(() => {
    const map = new Map();
    for (const def of bucket.value?.reqDefs || []) {
        if (def?.client_id != null) map.set(String(def.client_id), def);
        if (def?.id != null) map.set(String(def.id), def);
    }
    return map;
});

function hasOwn(obj, key) {
    return Object.prototype.hasOwnProperty.call(obj, key);
}

function sourceDef(key) {
    return stagedDefsById.value.get(key) || catalogById.value.get(key) || null;
}

function normalizeStagedRow(row, idx) {
    // Names/labels for staged rows: staged defs first, then the server
    // catalog, then whatever the binding row itself carries.
    const key = String(
        row.req_key ??
            row.requirement_definition_id ??
            row.id ??
            `row-${idx}`,
    );
    const src = sourceDef(key) || {};
    return {
        key,
        name: src.name ?? row.name ?? "",
        code: row.code ?? src.code ?? "",
        is_required: row.is_required ?? true,
        is_upload_required:
            row.is_upload_required ?? row.is_required ?? true,
        display_order: Number(row.display_order ?? idx),
        seq: idx,
    };
}

const columns = computed(() => {
    const sourceSteps = [...(steps.value || [])].sort((a, b) => {
        const ao = Number(a.order_number ?? 0);
        const bo = Number(b.order_number ?? 0);
        return ao - bo || Number(a.id ?? 0) - Number(b.id ?? 0);
    });
    const bucketValue = bucket.value;
    const removed = new Set(
        (bucketValue?.removedReqIds || []).map((id) => String(id)),
    );
    const bindings = bucketValue?.bindings || {};

    return sourceSteps.map((step, index) => {
        const stepKey = String(step.id);
        const serverRows = [];
        let seq = 0;

        for (const def of requirementDefs.value || []) {
            const assignment = (def.steps || []).find(
                (assigned) => String(assigned.id) === stepKey,
            );
            if (!assignment) continue;

            const src = stagedDefsById.value.get(String(def.id)) || def;
            const pivot = assignment.pivot_meta || {};
            serverRows.push({
                key: String(def.id),
                name: src.name ?? def.name ?? "",
                code: src.code ?? def.code ?? "",
                is_required: pivot.is_required ?? true,
                is_upload_required:
                    pivot.is_upload_required ??
                    pivot.is_required ??
                    true,
                display_order: Number(pivot.display_order ?? 0),
                seq: seq++,
            });
        }

        // Prefer already-staged rows so unsaved edits on the Step Requirements
        // page are reflected here without a save or a per-step fetch.
        const stagedRows = hasOwn(bindings, stepKey)
            ? (bindings[stepKey] || []).map((row, rowIndex) => {
                  const normalized = normalizeStagedRow(row, rowIndex);
                  const sourceRows = bucketValue?.sourceBindings?.[stepKey];
                  const existedInSource =
                      Array.isArray(sourceRows) &&
                      sourceRows.some(
                          (sourceRow) =>
                              String(
                                  sourceRow.req_key ??
                                      sourceRow.requirement_definition_id ??
                                      sourceRow.id,
                              ) === normalized.key,
                      );
                  return {
                      ...normalized,
                      isUnsaved:
                          !Number.isFinite(Number(normalized.key)) ||
                          (Array.isArray(sourceRows) && !existedInSource),
                  };
              })
            : null;

        const rows = (stagedRows || serverRows)
            .filter((row) => !removed.has(row.key))
            .sort(
                (a, b) =>
                    a.display_order - b.display_order ||
                    a.seq - b.seq ||
                    a.name.localeCompare(b.name),
            );

        const seen = new Set();
        const reqs = rows.filter((row) => {
            if (!row.key || seen.has(row.key)) return false;
            seen.add(row.key);
            return true;
        });

        const stepNumber =
            Number(step.order_number) > 0
                ? Number(step.order_number)
                : index + 1;

        return {
            id: `step-${step.id}`,
            stepId: step.id,
            stepNumber,
            name: step.name || `Step ${stepNumber}`,
            reqs,
        };
    });
});

const overview = computed(() => {
    const cols = columns.value.map((column, columnIndex) => ({
        ...column,
        reqs: column.reqs.map((req, reqIndex) => ({
            ...req,
            domId: `ro-r-${columnIndex}-${reqIndex}`,
            color: null,
        })),
    }));

    const colorByKey = new Map();
    let nextColor = 0;
    const links = [];

    for (let i = 0; i < cols.length - 1; i += 1) {
        const nextByKey = new Map(
            cols[i + 1].reqs.map((req) => [req.key, req]),
        );
        for (const req of cols[i].reqs) {
            const next = nextByKey.get(req.key);
            if (!next) continue;

            if (!colorByKey.has(req.key)) {
                colorByKey.set(req.key, nextColor++ % 6);
            }

            links.push({
                a: req.domId,
                b: next.domId,
                colorIndex: colorByKey.get(req.key),
            });
        }
    }

    for (const column of cols) {
        for (const req of column.reqs) {
            if (colorByKey.has(req.key)) {
                req.color = `var(--ro-c${colorByKey.get(req.key)})`;
            }
        }
    }

    const uniqueKeys = new Set();
    for (const column of cols) {
        for (const req of column.reqs) uniqueKeys.add(req.key);
    }

    return {
        columns: cols,
        links,
        carriedCount: colorByKey.size,
        requirementCount: uniqueKeys.size,
    };
});

const boardEl = ref(null);
const colsEl = ref(null);
const linesEl = ref(null);
const miniEl = ref(null);
const miniSvgEl = ref(null);
const viewportEl = ref(null);

const fits = ref(true);
const dragging = ref(false);
const minimapText = ref("");
const scrollPercent = ref(0);

let disposed = false;
let loadToken = 0;
let refreshFrame = 0;
let resizeObserver = null;

function apiError(reason, fallback) {
    return (
        reason?.response?.data?.message ||
        reason?.message ||
        fallback
    );
}

async function loadPage() {
    const token = ++loadToken;
    const wid = workflowDefinitionId.value;

    if (!Number.isFinite(wid) || wid <= 0) {
        error.value = "Invalid workflow.";
        loading.value = false;
        return;
    }

    loading.value = true;
    error.value = "";
    fits.value = true;
    dragging.value = false;
    minimapText.value = "";
    scrollPercent.value = 0;
    steps.value = [];
    requirementDefs.value = [];
    returnTypeId.value = null;

    try {
        const [requirementsResult, stepsResult, definitionResult] =
            await Promise.allSettled([
                fetchReqs(wid),
                api.get(`/api/admin/workflow-definitions/${wid}/steps`),
                api.get(`/api/admin/workflow-definitions/${wid}`),
            ]);

        if (token !== loadToken || disposed) return;

        if (stepsResult.status === "fulfilled") {
            const payload =
                stepsResult.value.data?.data ?? stepsResult.value.data;
            steps.value = Array.isArray(payload) ? payload : [];
        } else {
            error.value = apiError(
                stepsResult.reason,
                "Failed to load workflow steps.",
            );
        }

        if (requirementsResult.status === "rejected") {
            const message = apiError(
                requirementsResult.reason,
                "Failed to load requirements.",
            );
            error.value = error.value ? `${error.value} ${message}` : message;
        }

        if (definitionResult.status === "fulfilled") {
            const def =
                definitionResult.value.data?.data ??
                definitionResult.value.data;
            const tid = Number(def?.transaction_type_id);
            if (Number.isFinite(tid) && tid > 0) returnTypeId.value = tid;
        }
    } finally {
        if (token === loadToken && !disposed) {
            loading.value = false;
            await nextTick();
            observeCols();
            scheduleRefresh();
        }
    }
}

function observeCols() {
    if (resizeObserver) {
        resizeObserver.disconnect();
        resizeObserver = null;
    }
    if (!colsEl.value || !("ResizeObserver" in window)) return;
    resizeObserver = new ResizeObserver(scheduleRefresh);
    resizeObserver.observe(colsEl.value);
}

function scheduleRefresh() {
    if (disposed || refreshFrame) return;
    refreshFrame = requestAnimationFrame(() => {
        refreshFrame = 0;
        refreshOverview();
    });
}

async function refreshOverview() {
    await nextTick();
    if (disposed) return;

    const board = boardEl.value;
    if (!board) {
        fits.value = true;
        return;
    }

    const overflows = board.scrollWidth > board.clientWidth + 1;
    fits.value = !overflows;
    await nextTick();
    if (disposed) return;

    drawConnectors();
    if (!overflows) return;

    drawMinimap();
    updateViewport();
}

function drawConnectors() {
    const cols = colsEl.value;
    const svg = linesEl.value;
    if (!cols || !svg) {
        if (svg) svg.innerHTML = "";
        return;
    }

    const base = cols.getBoundingClientRect();
    svg.setAttribute("width", String(cols.scrollWidth));
    svg.setAttribute("height", String(cols.scrollHeight));

    let out = "";
    for (const link of overview.value.links) {
        const a = document.getElementById(link.a);
        const b = document.getElementById(link.b);
        if (!a || !b) continue;

        const ar = a.getBoundingClientRect();
        const br = b.getBoundingClientRect();
        const x1 = ar.right - base.left;
        const y1 = ar.top + ar.height / 2 - base.top;
        const x2 = br.left - base.left;
        const y2 = br.top + br.height / 2 - base.top;
        const dx = (x2 - x1) / 2;
        const color = `var(--ro-c${link.colorIndex})`;

        out += `<path d="M${x1} ${y1} C${x1 + dx} ${y1},${x2 - dx} ${y2},${x2} ${y2}" style="stroke:${color}"/>`;
        out += `<rect x="${x1 - 4}" y="${y1 - 4}" width="8" height="8" style="fill:${color}"/>`;
        out += `<rect x="${x2 - 4}" y="${y2 - 4}" width="8" height="8" style="fill:${color}"/>`;
    }
    svg.innerHTML = out;
}

function drawMinimap() {
    const board = boardEl.value;
    const cols = colsEl.value;
    const mini = miniEl.value;
    const svg = miniSvgEl.value;
    if (!board || !cols || !mini || !svg) return;

    const W = board.scrollWidth;
    const H = board.scrollHeight;
    const mw = mini.clientWidth;
    const mh = mini.clientHeight;
    if (!W || !H || !mw || !mh) return;

    const base = board.getBoundingClientRect();
    const sx = mw / W;
    const sy = mh / H;
    const pos = (el) => {
        const r = el.getBoundingClientRect();
        return {
            x: (r.left - base.left + board.scrollLeft) * sx,
            y: (r.top - base.top + board.scrollTop) * sy,
            w: r.width * sx,
            h: r.height * sy,
        };
    };

    let out = "";
    cols.querySelectorAll(".ro-step").forEach((step, index) => {
        const p = pos(step);
        out += `<rect x="${p.x}" y="${p.y}" width="${p.w}" height="${p.h}" style="fill:var(--ro-panel);stroke:var(--ro-line)" stroke-width="1"/>`;
        if (p.w > 16) {
            out += `<text x="${p.x + p.w / 2}" y="${p.y + 10}" text-anchor="middle" font-size="9" font-weight="800" style="fill:var(--ro-muted)">${index + 1}</text>`;
        }
    });

    cols.querySelectorAll(".ro-req").forEach((req) => {
        const p = pos(req);
        const color =
            req.style.getPropertyValue("--ro-cc").trim() || "var(--ro-line)";
        out += `<rect x="${p.x + 1}" y="${p.y}" width="${Math.max(1, p.w - 2)}" height="${Math.max(1.5, p.h)}" style="fill:${color}" opacity=".9"/>`;
    });

    for (const link of overview.value.links) {
        const a = document.getElementById(link.a);
        const b = document.getElementById(link.b);
        if (!a || !b) continue;

        const pa = pos(a);
        const pb = pos(b);
        const x1 = pa.x + pa.w;
        const y1 = pa.y + pa.h / 2;
        const x2 = pb.x;
        const y2 = pb.y + pb.h / 2;
        const dx = (x2 - x1) / 2;

        out += `<path d="M${x1} ${y1} C${x1 + dx} ${y1},${x2 - dx} ${y2},${x2} ${y2}" fill="none" stroke-width="1.5" style="stroke:var(--ro-c${link.colorIndex})"/>`;
    }

    svg.setAttribute("viewBox", `0 0 ${mw} ${mh}`);
    svg.innerHTML = out;
}

function updateViewport() {
    const board = boardEl.value;
    const cols = colsEl.value;
    const mini = miniEl.value;
    const vp = viewportEl.value;
    if (!board || !mini || !vp) return;

    const W = board.scrollWidth;
    const mw = mini.clientWidth;

    if (!fits.value && W > 0 && mw > 0) {
        vp.style.width = `${Math.min(mw, (board.clientWidth / W) * mw)}px`;
        vp.style.left = `${(board.scrollLeft / W) * mw}px`;
    } else {
        vp.style.width = "0px";
    }

    const boardRect = board.getBoundingClientRect();
    const visible = [];
    if (cols) {
        cols.querySelectorAll(".ro-step").forEach((step, index) => {
            const rect = step.getBoundingClientRect();
            if (
                rect.right > boardRect.left + 8 &&
                rect.left < boardRect.right - 8
            ) {
                visible.push(index + 1);
            }
        });
    }

    const total = overview.value.columns.length;
    minimapText.value = !visible.length
        ? ""
        : visible.length === total
          ? `All ${total} steps in view`
          : `Showing steps ${visible[0]}${visible.length > 1 ? `–${visible[visible.length - 1]}` : ""} of ${total}`;

    const max = W - board.clientWidth;
    scrollPercent.value =
        max > 0 ? Math.round((board.scrollLeft / max) * 100) : 0;
}

function jumpToPointer(clientX) {
    const board = boardEl.value;
    const mini = miniEl.value;
    if (!board || !mini) return;

    const rect = mini.getBoundingClientRect();
    if (!rect.width) return;

    const max = Math.max(0, board.scrollWidth - board.clientWidth);
    const target =
        ((clientX - rect.left) / rect.width) * board.scrollWidth -
        board.clientWidth / 2;
    board.scrollLeft = Math.max(0, Math.min(max, target));
}

function onMiniPointerDown(event) {
    if (event.pointerType === "mouse" && event.button !== 0) return;
    dragging.value = true;
    miniEl.value?.setPointerCapture?.(event.pointerId);
    miniEl.value?.focus?.();
    jumpToPointer(event.clientX);
}

function onMiniPointerMove(event) {
    if (!dragging.value) return;
    jumpToPointer(event.clientX);
}

function onMiniPointerUp(event) {
    dragging.value = false;
    const mini = miniEl.value;
    if (mini?.hasPointerCapture?.(event.pointerId)) {
        mini.releasePointerCapture(event.pointerId);
    }
}

function scrollBehavior() {
    if (typeof window === "undefined") return "auto";
    return window.matchMedia?.("(prefers-reduced-motion: reduce)").matches
        ? "auto"
        : "smooth";
}

function onMiniKeydown(event) {
    const board = boardEl.value;
    if (!board) return;

    const behavior = scrollBehavior();
    if (event.key === "ArrowRight") {
        event.preventDefault();
        board.scrollBy({ left: 300, behavior });
    } else if (event.key === "ArrowLeft") {
        event.preventDefault();
        board.scrollBy({ left: -300, behavior });
    } else if (event.key === "Home") {
        event.preventDefault();
        board.scrollTo({ left: 0, behavior });
    } else if (event.key === "End") {
        event.preventDefault();
        board.scrollTo({ left: board.scrollWidth, behavior });
    }
}

function goBack() {
    const wid = workflowDefinitionId.value;
    const sid = stepIdFromUrl.value;

    if (Number.isFinite(wid) && wid > 0 && Number.isFinite(sid) && sid > 0) {
        router.push({
            name: "admin.step-requirements",
            params: { workflowId: wid, stepId: sid },
            query: route.query,
        });
    } else if (Number.isFinite(wid) && wid > 0) {
        router.push({
            name: "admin.workflow-requirements",
            params: { workflowId: wid },
            query: route.query,
        });
    } else {
        router.push("/admin/workflows");
    }
}

watch(overview, scheduleRefresh, { flush: "post" });

watch(workflowDefinitionId, () => {
    loadPage();
});

onMounted(async () => {
    window.addEventListener("resize", scheduleRefresh);
    document.fonts?.ready?.then(scheduleRefresh).catch(() => {});
    await loadPage();
});

onBeforeUnmount(() => {
    disposed = true;
    loadToken += 1;
    window.removeEventListener("resize", scheduleRefresh);
    if (refreshFrame) cancelAnimationFrame(refreshFrame);
    resizeObserver?.disconnect();
    resizeObserver = null;
});
</script>

<style scoped>
.ro-page {
    --ro-bg: #eef2f9;
    --ro-panel: #fff;
    --ro-ink: #14213d;
    --ro-muted: #5b6780;
    --ro-line: #d5dbe8;
    --ro-field: #f4f6fb;
    --ro-hover: #f3f6fc;
    --ro-blue: #1d3fae;
    --ro-blue-d: #142d82;
    --ro-blue-bg: #e8eeff;
    --ro-err: #c62828;
    --ro-err-bg: #fde8e8;
    --ro-c0: #1d3fae;
    --ro-c1: #c77700;
    --ro-c2: #1b7a3d;
    --ro-c3: #a6288f;
    --ro-c4: #0e7490;
    --ro-c5: #b42318;
    --ro-ring: rgba(29, 63, 174, 0.28);
    width: auto;
    max-width: none;
    margin: 0 -24px;
    padding: 0 clamp(16px, 3vw, 48px) 16px;
    background: var(--ro-bg);
    color: var(--ro-ink);
    font-variant-numeric: tabular-nums;
}

.ro-page :deep(.v-alert) {
    border-radius: 0;
}

.ro-page :deep(.v-btn) {
    border-radius: 0;
}

.ro-shell {
    border: 1px solid var(--ro-line);
    background: var(--ro-panel);
    box-shadow: 0 10px 30px -18px rgba(20, 33, 61, 0.3);
}

.ro-loading {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 380px;
    padding: 16px 0;
}

.ro-bar {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px 28px;
    padding: 16px 28px;
    border-bottom: 1px solid var(--ro-line);
    background: var(--ro-field);
}

.ro-stat {
    display: flex;
    align-items: baseline;
    gap: 8px;
    color: var(--ro-muted);
    font-size: 13px;
    font-weight: 600;
}

.ro-stat b {
    color: var(--ro-ink);
    font-size: 20px;
    font-weight: 800;
}

.ro-legend {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px 18px;
    margin-left: auto;
    color: var(--ro-muted);
    font-size: 12.5px;
    font-weight: 600;
}

.ro-legend-item {
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.ro-lk {
    width: 34px;
    height: 12px;
    flex: none;
}

.ro-lk path {
    fill: none;
    stroke: var(--ro-c0);
    stroke-width: 2.5;
}

.ro-mm {
    padding: 14px 28px 16px;
    border-top: 1px solid var(--ro-line);
    background: var(--ro-panel);
}

.ro-mm-h {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 8px;
}

.ro-mm-h span {
    color: var(--ro-muted);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.ro-mm-h small {
    color: var(--ro-muted);
    font-size: 12.5px;
    font-weight: 600;
}

.ro-mm-b {
    position: relative;
    height: 88px;
    overflow: hidden;
    border: 1.5px solid var(--ro-line);
    background: var(--ro-field);
    cursor: grab;
    touch-action: none;
    user-select: none;
}

.ro-mm-b.is-drag {
    cursor: grabbing;
}

.ro-mm-svg {
    position: absolute;
    inset: 0;
    display: block;
    width: 100%;
    height: 100%;
}

.ro-vp {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    width: 0;
    border: 2px solid var(--ro-blue);
    background: color-mix(in srgb, var(--ro-blue) 16%, transparent);
    pointer-events: none;
}

.ro-board {
    overflow-x: auto;
    padding: 28px;
    scrollbar-width: thin;
}

.ro-board:focus-visible,
.ro-mm-b:focus-visible {
    outline: 3px solid var(--ro-ring);
    outline-offset: 2px;
}

.ro-cols {
    position: relative;
    display: flex;
    align-items: stretch;
    gap: 84px;
    width: max-content;
    min-width: 100%;
}

.ro-lines {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 0;
    overflow: visible;
    pointer-events: none;
}

.ro-lines path {
    fill: none;
    stroke-width: 2.5;
}

.ro-lines rect {
    stroke: none;
}

.ro-step {
    position: relative;
    z-index: 1;
    display: flex;
    flex: none;
    flex-direction: column;
    width: 300px;
    border: 1.5px solid var(--ro-line);
    background: var(--ro-panel);
}

.ro-step-hd {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px;
    border-bottom: 1.5px solid var(--ro-line);
    background: var(--ro-field);
}

.ro-step-n {
    display: grid;
    place-items: center;
    width: 38px;
    height: 38px;
    flex: none;
    background: var(--ro-blue);
    color: #fff;
    font-size: 15px;
    font-weight: 800;
}

.ro-step-t {
    min-width: 0;
}

.ro-step-t small {
    display: block;
    color: var(--ro-muted);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.ro-step-t b {
    display: block;
    font-size: 15px;
    font-weight: 700;
    line-height: 1.25;
    overflow-wrap: anywhere;
}

.ro-list {
    display: flex;
    flex: 1;
    flex-direction: column;
    gap: 10px;
    padding: 14px;
}

.ro-req {
    --ro-cc: var(--ro-line);
    padding: 11px 12px;
    border: 1.5px solid var(--ro-line);
    border-left: 4px solid var(--ro-line);
    background: var(--ro-panel);
}

.ro-req.is-link {
    border-left-color: var(--ro-cc);
}

.ro-req.is-unsaved {
    border-color: #b7d9f4;
    border-left-color: #1670b7;
    background: #eaf5ff;
}

.ro-req.is-unsaved.is-link {
    border-left-color: var(--ro-cc);
}

.ro-req-unsaved {
    display: inline-flex;
    margin-left: 8px;
    padding: 2px 6px;
    background: #cfe7fa;
    color: #124d7a;
    font-size: 9px;
    font-weight: 800;
    letter-spacing: 0.04em;
    vertical-align: middle;
}

.ro-req-n {
    color: var(--ro-ink);
    font-size: 14px;
    font-weight: 700;
    line-height: 1.3;
    overflow-wrap: anywhere;
}

.ro-req-c {
    display: inline-block;
    margin-top: 6px;
    padding: 2px 7px;
    background: var(--ro-field);
    color: var(--ro-muted);
    font-family: ui-monospace, Menlo, Consolas, monospace;
    font-size: 11.5px;
    overflow-wrap: anywhere;
}

.ro-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin-top: 9px;
}

.ro-tag {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 3px 8px;
    font-size: 11.5px;
    font-weight: 800;
    letter-spacing: 0.02em;
}

.ro-tag-r {
    background: var(--ro-err-bg);
    color: var(--ro-err);
}

.ro-tag-o {
    background: var(--ro-field);
    color: var(--ro-muted);
}

.ro-tag-u {
    background: var(--ro-blue-bg);
    color: var(--ro-blue);
}

.ro-none {
    margin: 0;
    padding: 22px 8px;
    border: 1.5px dashed var(--ro-line);
    color: var(--ro-muted);
    font-size: 13px;
    text-align: center;
}

.ro-empty {
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    min-height: 280px;
    padding: 48px 24px;
    text-align: center;
}

.ro-empty-ic {
    margin-bottom: 12px;
    color: var(--ro-blue);
}

.ro-empty b {
    font-size: 17px;
    font-weight: 800;
}

.ro-empty span {
    max-width: 460px;
    margin-top: 5px;
    color: var(--ro-muted);
    font-size: 14px;
    line-height: 1.4;
}

.ro-retry {
    height: 40px;
    margin-top: 18px;
    padding: 0 18px;
    border: 1.5px solid var(--ro-blue);
    border-radius: 0;
    background: transparent;
    color: var(--ro-blue);
    font: inherit;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
}

.ro-retry:hover {
    background: var(--ro-blue-bg);
}

.ro-retry:focus-visible {
    outline: 3px solid var(--ro-ring);
    outline-offset: 2px;
}

html.dark .ro-page {
    --ro-bg: #0e1424;
    --ro-panel: #161e36;
    --ro-ink: #eef2fb;
    --ro-muted: #9aa7c4;
    --ro-line: #2b3558;
    --ro-field: #1c2645;
    --ro-hover: #1d2745;
    --ro-blue: #6f8cff;
    --ro-blue-d: #8aa1ff;
    --ro-blue-bg: #25306a;
    --ro-err: #ff8a80;
    --ro-err-bg: #4a1f22;
    --ro-c0: #7f9bff;
    --ro-c1: #ffb347;
    --ro-c2: #4cd080;
    --ro-c3: #e27bd0;
    --ro-c4: #4cc3dd;
    --ro-c5: #ff8a80;
    --ro-ring: rgba(138, 161, 255, 0.38);
}

html.dark .ro-req.is-unsaved {
    border-color: #385b76;
    border-left-color: #6db8f0;
    background: #182d40;
}

html.dark .ro-req.is-unsaved.is-link {
    border-left-color: var(--ro-cc);
}

html.dark .ro-req-unsaved {
    background: #244966;
    color: #c8e7ff;
}

html.dark .ro-shell {
    box-shadow: 0 10px 30px -18px rgba(0, 0, 0, 0.65);
}

@media (max-width: 760px) {
    .ro-bar {
        padding: 14px 16px;
    }

    .ro-legend {
        margin-left: 0;
    }

    .ro-mm {
        padding: 12px 16px 14px;
    }

    .ro-board {
        padding: 20px 16px;
    }

    .ro-cols {
        gap: 64px;
    }

    .ro-step {
        width: 264px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .ro-page *,
    .ro-page *::before,
    .ro-page *::after {
        transition: none !important;
        scroll-behavior: auto !important;
    }
}
</style>
