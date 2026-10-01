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
//
// Explicit component imports (not strings): `<component :is>` resolves
// against these objects, so the field inputs work regardless of template
// auto-import scanning.
import { VSelect, VSwitch, VTextField, VTextarea } from 'vuetify/components'

defineProps({
    fields: { type: Array, default: () => [] },
    form: { type: Object, required: true },
});

function componentFor(type) {
    switch (type) {
        case "textarea": return VTextarea;
        case "select": return VSelect;
        case "multiselect": return VSelect;
        case "boolean": return VSwitch;
        default: return VTextField;
    }
}

function inputTypeFor(type) {
    if (type === "number" || type === "currency") return "number";
    if (type === "date") return "date";
    return "text";
}
</script>
