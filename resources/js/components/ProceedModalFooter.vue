<template>
    <div class="pm-ftr">
        <div class="pm-msg" :class="ready ? 'ok' : 'no'">
            <v-icon size="17">{{ ready ? 'mdi-check-circle-outline' : 'mdi-alert-circle-outline' }}</v-icon>
            <span class="pm-lbl">{{ statusText }}</span>
            <span v-if="!ready" class="pm-chips">
                <button
                    v-for="task in visibleTasks"
                    :key="task.label"
                    type="button"
                    class="pm-chip"
                    :title="`Go to ${task.label}`"
                    @click="focusTask(task)"
                >{{ task.label }}</button>
                <span v-if="hiddenTaskCount > 0" class="pm-lbl">+{{ hiddenTaskCount }} more</span>
            </span>
        </div>
        <div class="pm-actions">
            <button
                v-if="showCancel"
                type="button"
                class="pm-btn ghost"
                :disabled="cancelDisabled || busy"
                @click="emit('cancel')"
            >{{ cancelLabel }}</button>
            <button
                v-if="showBack"
                type="button"
                class="pm-btn ghost"
                :disabled="backDisabled || busy"
                @click="emit('back')"
            >{{ backLabel }}</button>
            <button
                v-if="showNext"
                type="button"
                class="pm-btn ghost"
                :disabled="nextDisabled || busy"
                @click="emit('next')"
            >{{ nextLabel }}</button>
            <button
                v-if="showPrimary"
                type="button"
                class="pm-btn pri"
                :class="primaryTone"
                :disabled="primaryDisabled || busy"
                @click="emit('primary')"
            >
                <span v-if="busy" class="pm-spinner" aria-hidden="true"></span>
                {{ busy && busyLabel ? busyLabel : primaryLabel }}
            </button>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'

// Redesigned proceed-modal footer: readiness line + jumpable task chips on
// the left, Cancel / Back / Next / primary action on the right. The parent
// owns gating, so no rule is duplicated here.
const props = defineProps({
    tasks: { type: Array, default: () => [] },
    busy: { type: Boolean, default: false },
    busyLabel: { type: String, default: '' },
    primaryLabel: { type: String, default: 'Proceed' },
    // '', 'warn', 'success', 'resend'
    primaryTone: { type: String, default: '' },
    primaryDisabled: { type: Boolean, default: false },
    showPrimary: { type: Boolean, default: true },
    showCancel: { type: Boolean, default: true },
    showBack: { type: Boolean, default: false },
    showNext: { type: Boolean, default: false },
    cancelLabel: { type: String, default: 'Cancel' },
    backLabel: { type: String, default: 'Back' },
    nextLabel: { type: String, default: 'Next' },
    nextDisabled: { type: Boolean, default: false },
    backDisabled: { type: Boolean, default: false },
    cancelDisabled: { type: Boolean, default: false },
    maxChips: { type: Number, default: 4 },
})

const emit = defineEmits(['cancel', 'back', 'next', 'primary'])

const cleanTasks = computed(() => {
    const seen = new Set()
    const out = []
    for (const raw of (props.tasks || [])) {
        // Parents may pass a plain label or { label, page, kind } so the
        // footer can flip wizard pages and target the right section.
        const label = String(
            raw && typeof raw === 'object' ? raw.label : raw || '',
        ).trim()
        if (!label) continue
        const key = label.toLowerCase()
        if (seen.has(key)) continue
        seen.add(key)
        out.push({
            label,
            page: raw && typeof raw === 'object' ? String(raw.page || '') : '',
            kind: raw && typeof raw === 'object' ? String(raw.kind || '') : '',
        })
    }
    return out
})

const ready = computed(() => cleanTasks.value.length === 0)
const visibleTasks = computed(() => cleanTasks.value.slice(0, props.maxChips))
const hiddenTaskCount = computed(() => Math.max(0, cleanTasks.value.length - props.maxChips))

const statusText = computed(() => {
    const n = cleanTasks.value.length
    if (!n) return 'Everything is ready'
    return n === 1 ? '1 task remaining' : `${n} tasks remaining`
})

// Chips scroll the modal body to the matching incomplete item. Sections in
// the wizard carry data-pm-task="<label>"; the nearest scrollable ancestor
// handles the actual scrolling.
function taskNodes(root, wanted) {
    return [...root.querySelectorAll('[data-pm-task]')].filter((node) =>
        String(node.getAttribute('data-pm-task') || '')
            .split('|')
            .some((part) => part.trim().toLowerCase() === wanted),
    )
}

// Requirement rows carry the same label on the tick row and the upload card.
// Prefer the first visible match that still needs action so a "missing file"
// chip lands on its upload card instead of the tick row that was just
// checked. Returns false while the item sits on the hidden wizard page.
function revealTask(root, wanted, kind = '') {
    const visible = taskNodes(root, wanted).filter((node) => node.offsetParent !== null)
    if (!visible.length) return false
    // The parent tags each task with the section that produced it. A row
    // can appear as both a tick and an upload card with the same name;
    // jumping to the right one avoids landing on an already-completed row.
    const selectors = {
        check: '.pm-check',
        tick: '.pm-check',
        upload: '.pm-upload',
        field: '.pm-field',
    }
    const selector = selectors[kind]
    const preferred = selector ? visible.filter((node) => node.matches(selector)) : []
    const pool = preferred.length ? preferred : visible
    const match = pool.find((node) => {
        if (node.matches('.pm-check')) {
            return !node.querySelector('input[type="checkbox"]')?.checked
        }
        if (node.matches('.pm-upload')) {
            return !node.classList.contains('is-ok')
        }
        return true
    }) || pool[0]
    match.scrollIntoView({ behavior: 'smooth', block: 'center' })
    match.classList.add('pm-flash')
    window.setTimeout(() => match.classList.remove('pm-flash'), 1200)
    return true
}

function focusTask(task) {
    if (typeof document === 'undefined') return
    const root = document.querySelector('.pm-dialog')
    if (!root) return
    const label = task && typeof task === 'object' ? task.label : task
    const pageHint = task && typeof task === 'object' ? String(task.page || '') : ''
    const kind = task && typeof task === 'object' ? String(task.kind || '') : ''
    const wanted = String(label || '').trim().toLowerCase()
    if (!wanted) return
    if (revealTask(root, wanted, kind)) return

    const matches = taskNodes(root, wanted)
    const body = root.querySelector('.pm-body')
    // The parent declares the page for items the lazy window has not
    // rendered yet (e.g. step-data fields); otherwise read it from the
    // hidden DOM node.
    const targetPage = pageHint
        || matches[0]?.closest('[data-pm-page]')?.getAttribute('data-pm-page')
        || ''
    const activePage = [...root.querySelectorAll('.pm-wizard [data-pm-page]')]
        .find((node) => node.offsetParent !== null)
        ?.getAttribute('data-pm-page')
        || ''

    if (targetPage && activePage && targetPage !== activePage) {
        // Drive the same Back/Next actions as the footer, then retry once
        // the page (and its lazy content) is visible.
        emit(targetPage === '1' ? 'back' : 'next')
        let tries = 0
        const retry = () => {
            if (revealTask(root, wanted, kind)) return
            tries += 1
            if (tries < 15) {
                window.setTimeout(retry, 200)
            } else {
                body?.scrollTo({ top: body.scrollHeight, behavior: 'smooth' })
            }
        }
        window.setTimeout(retry, 300)
        return
    }
    if (matches.length) {
        body?.scrollTo({ top: body.scrollHeight, behavior: 'smooth' })
        return
    }
    body?.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>
