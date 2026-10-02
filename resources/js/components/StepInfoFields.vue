<template>
    <v-row v-if="(fields || []).length">
        <v-col v-for="row in fields" :key="row.definition.id" cols="12" md="6">
            <component
                :is="componentFor(row.definition.type)"
                v-model="form[row.definition.code]"
                :label="row.definition.name + (row.definition.required ? ' *' : '')"
                :items="row.definition.options || []"
                :multiple="row.definition.type === 'multiselect'"
                :type="inputTypeFor(row.definition.type)"
                clearable
            />
        </v-col>
    </v-row>
</template>

<script setup>
// Shared station-info inputs. `form` is the page's single recording object
// (mutated in place), so page card and modals always show the same draft.
defineProps({
    fields: { type: Array, default: () => [] },
    form: { type: Object, required: true },
});

function componentFor(type) {
    switch (type) {
        case "textarea": return "v-textarea";
        case "select": return "v-select";
        case "multiselect": return "v-select";
        case "boolean": return "v-switch";
        default: return "v-text-field";
    }
}

function inputTypeFor(type) {
    if (type === "number" || type === "currency") return "number";
    if (type === "date") return "date";
    return "text";
}
</script>
