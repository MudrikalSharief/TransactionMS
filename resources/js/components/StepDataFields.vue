<template>
    <template v-if="(stepData || []).length">
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

<script setup>
// Text values collected per step visit (e.g. receipt number).
// Bound object is keyed by definition code; the parent sends it as
// `step_data` on Proceed. Renders nothing when the step has no definitions.
const form = defineModel('form', { default: () => ({}) })

defineProps({
    // tx.current_step_data — [{definition{id,code,display_name,is_required,display_order,min_length,max_length}, value, history}]
    stepData: { type: Array, default: () => [] },
    saving: { type: Boolean, default: false },
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
</script>
