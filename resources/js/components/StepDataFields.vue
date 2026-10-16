<template>
    <template v-if="(stepData || []).length">
        <template v-if="modern">
            <div v-for="(row, i) in (stepData || [])" :key="row.definition.id" class="mb-4">
                <div class="text-h6 font-weight-bold mb-1">
                    <template v-if="numbered">Step {{ startNumber + i }}: </template>{{ row.definition.display_name }}
                    <v-chip v-if="row.definition.is_required" size="small" variant="tonal" color="error" rounded="pill" class="ml-2">Required</v-chip>
                </div>
                <div v-if="hintFor(row)" class="text-body-2 text-medium-emphasis mb-2">{{ hintFor(row) }}</div>
                <v-text-field
                    :model-value="form[row.definition.code] ?? ''"
                    variant="outlined"
                    density="comfortable"
                    :disabled="saving"
                    hide-details="auto"
                    @update:model-value="(v) => setValue(row.definition.code, v)"
                />
                <div v-if="statusFor(row).text" class="text-body-2 mt-1" :class="statusFor(row).ok ? 'text-success' : 'text-error'">
                    {{ statusFor(row).text }}
                </div>
            </div>
        </template>
        <template v-else>
            <div class="text-subtitle-2 font-weight-bold mb-2">Step data</div>
            <div v-for="row in (stepData || [])" :key="row.definition.id" class="mb-2">
                <v-text-field
                    :model-value="form[row.definition.code] ?? ''"
                    :label="`${row.definition.display_name}${row.definition.is_required ? ' *' : ''}`"
                    :hint="hint(row)"
                    persistent-hint
                    :counter="row.definition.max_length || undefined"
                    :maxlength="row.definition.max_length || undefined"
                    variant="outlined"
                    density="compact"
                    :disabled="saving"
                    @update:model-value="(v) => setValue(row.definition.code, v)"
                />
            </div>
            <v-divider class="my-3" />
        </template>
    </template>
</template>

<script setup>
// Text values collected per step visit (e.g. receipt number).
// Bound object is keyed by definition code; the parent sends it as
// `step_data` on Proceed. Renders nothing when the step has no definitions.
// `modern` renders bare inputs with per-row headers, hints and live
// validation lines (proceed modal redesign); `numbered` prefixes headers
// with "Step N:" starting at `startNumber` (single-page first-step layout).
const form = defineModel('form', { default: () => ({}) })

defineProps({
    // tx.current_step_data — [{definition{id,code,display_name,type,is_required,display_order,min_length,max_length}, value, history}]
    stepData: { type: Array, default: () => [] },
    saving: { type: Boolean, default: false },
    modern: { type: Boolean, default: false },
    numbered: { type: Boolean, default: false },
    startNumber: { type: Number, default: 1 },
})

function setValue(code, v) {
    form.value = { ...(form.value || {}), [code]: v }
}

function hint(row) {
    const d = row.definition || {}
    const parts = []
    if (d.is_required) parts.push('Required')
    if (d.min_length != null) parts.push(`min ${d.min_length}`)
    if (d.max_length != null) parts.push(`max ${d.max_length}`)
    return parts.join(' · ')
}

function unitFor(d) {
    return ['number', 'numeric', 'digits', 'integer', 'decimal', 'currency'].includes(String(d?.type || '').toLowerCase())
        ? 'numbers'
        : 'characters'
}

// Guide hint under the header ("Type 10 to 15 numbers."). Mirrors the
// backend bounds (TransactionEngine::validateStepData).
function hintFor(row) {
    const d = row.definition || {}
    const unit = unitFor(d)
    if (d.min_length != null && d.max_length != null) return `Type ${d.min_length} to ${d.max_length} ${unit}.`
    if (d.min_length != null) return `Type at least ${d.min_length} ${unit}.`
    if (d.max_length != null) return `Up to ${d.max_length} ${unit}.`
    return ''
}

// Live validation line under the input. Messages mirror the backend so
// what the user sees is what Proceed will enforce.
function statusFor(row) {
    const d = row.definition || {}
    const v = form.value?.[d.code]
    const len = String(v ?? '').length
    const unit = unitFor(d)
    if (v === null || v === undefined || String(v) === '') {
        return d.is_required ? { ok: false, text: 'This field is required.' } : { ok: true, text: '' }
    }
    if (d.min_length != null && len < Number(d.min_length)) {
        return { ok: false, text: `${d.display_name} must be at least ${d.min_length} ${unit}.` }
    }
    if (d.max_length != null && len > Number(d.max_length)) {
        return { ok: false, text: `${d.display_name} may not exceed ${d.max_length} ${unit}.` }
    }
    if (d.min_length != null || d.max_length != null) {
        return { ok: true, text: `Good. ${len} ${unit}.` }
    }
    return { ok: true, text: '' }
}
</script>
