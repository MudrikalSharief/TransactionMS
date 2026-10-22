<template>
    <div>
        <template v-if="inlineActions">
            <v-alert v-if="dirty" type="warning" variant="tonal" density="compact" class="mb-3">
                Unsaved staged changes — nothing is saved until you press Save
                version. (Kept until you save, discard, or reload the page.)
            </v-alert>
            <div v-if="dirty" class="d-flex ga-2 mb-3">
                <v-btn variant="text" color="error" rounded="0" @click="onDiscard">
                    Discard
                </v-btn>
                <v-btn color="grey-darken-3" rounded="0" @click="openSaveDialog">
                    Save version
                    <v-chip size="x-small" color="warning" variant="flat" class="ml-2 font-weight-bold">UNSAVED</v-chip>
                </v-btn>
            </div>
        </template>

        <SaveVersionDialog
            v-model="saveDialog"
            :type-id="typeId"
            :def-id="defId"
            @saved="onSaved"
        />
    </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";
import SaveVersionDialog from "@/components/SaveVersionDialog.vue";

const props = defineProps({
    typeId: { type: [Number, null], default: null },
    defId: { type: [Number, null], default: null },
    inlineActions: { type: Boolean, default: true },
});
const emit = defineEmits(["saved", "discarded"]);

const staging = useWorkflowStaging();
const dirty = computed(() => (props.typeId ? staging.isDirty(props.typeId) : false));

const saveDialog = ref(false);

function openSaveDialog() {
    saveDialog.value = true;
}

function onDiscard() {
    if (!props.typeId) return;
    staging.discard(props.typeId);
    emit("discarded");
}

function onSaved(payload) {
    emit("saved", payload?.meta ?? payload);
}

defineExpose({ openSaveDialog, discard: onDiscard });
</script>
