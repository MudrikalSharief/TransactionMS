<template>
    <template v-if="(fields || []).length">
        <div v-if="modern" class="pm-field-grid pm-form">
            <div
                v-for="row in fields"
                :key="row.definition.id"
                class="pm-field"
                :data-pm-task="row.definition.name"
            >
                <div class="pm-field-head">
                    <label>{{ row.definition.name }}</label>
                    <span v-if="row.definition.required" class="pm-tag w">Required</span>
                </div>
                <component
                    :is="componentFor(row.definition.type)"
                    v-model="form[row.definition.code]"
                    :items="row.definition.options || []"
                    :multiple="row.definition.type === 'multiselect'"
                    :type="inputTypeFor(row.definition.type)"
                    :error="isEmpty(row)"
                    :error-messages="isEmpty(row) ? ['* required'] : []"
                    variant="outlined"
                    density="comfortable"
                    hide-details="auto"
                    clearable
                />
            </div>
        </div>
        <v-row v-else>
            <v-col v-for="row in fields" :key="row.definition.id" cols="12" md="6">
                <component
                    :is="componentFor(row.definition.type)"
                    v-model="form[row.definition.code]"
                    :label="row.definition.name + (row.definition.required ? ' *' : '')"
                    :items="row.definition.options || []"
                    :multiple="row.definition.type === 'multiselect'"
                    :type="inputTypeFor(row.definition.type)"
                    :error="isEmpty(row)"
                    :error-messages="isEmpty(row) ? ['* required'] : []"
                    clearable
                />
            </v-col>
        </v-row>
    </template>
</template>

<script setup>
// Shared station-info inputs. `form` is the page's single recording object
// (mutated in place), so page card and modals always show the same draft.
const props = defineProps({
    fields: { type: Array, default: () => [] },
    form: { type: Object, required: true },
    // Redesigned proceed-modal layout: labels above comfortable inputs in a
    // single-column stack instead of a two-column Vuetify grid.
    modern: { type: Boolean, default: false },
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

function isEmpty(row) {
    if (!row?.definition?.required) return false;
    const v = props.form?.[row.definition.code];
    return v === null || v === undefined || v === "" || (Array.isArray(v) && v.length === 0);
}
</script>
