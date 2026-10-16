<template>
    <div>
        <v-alert v-if="dirty" type="warning" variant="tonal" density="compact" class="mb-3">
            Unsaved staged changes — nothing is saved until you press Save
            version. (Kept until you save, discard, or reload the page.)
        </v-alert>
        <div v-if="dirty" class="d-flex ga-2 mb-3">
            <v-btn variant="text" color="error" rounded="0" @click="onDiscard">
                Discard
            </v-btn>
            <v-btn color="grey-darken-3" rounded="0" @click="saveDialog = true">
                Save version
                <v-chip size="x-small" color="warning" variant="flat" class="ml-2 font-weight-bold">UNSAVED</v-chip>
            </v-btn>
        </div>
        <v-alert v-if="saveError" type="error" variant="tonal" density="compact" class="mb-3">
            {{ saveError }}
        </v-alert>

        <v-dialog v-model="saveDialog" max-width="500">
            <v-card rounded="0">
                <v-card-title>Save version</v-card-title>
                <v-divider />
                <v-card-text>
                    <div class="text-caption text-medium-emphasis mb-3">
                        Persists everything you staged in one atomic save.
                        Nothing was written yet.
                    </div>
                    <v-radio-group v-model="saveMode" label="How to save?" density="compact">
                        <v-radio label="Overwrite current draft (stays draft, same version)" value="overwrite" />
                        <v-radio label="Create new version (published live, old kept)" value="create-new" />
                    </v-radio-group>
                    <v-text-field
                        v-model="saveName"
                        :label="saveMode === 'create-new' ? 'Version name (required)' : 'Version name (optional rename)'"
                        placeholder="e.g. Holiday rush flow"
                        maxlength="200"
                        counter
                        autofocus
                    />
                    <v-textarea
                        v-model="saveNotes"
                        label="Notes (optional)"
                        rows="2"
                    />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" @click="saveDialog = false">Cancel</v-btn>
                    <v-btn
                        color="grey-darken-3"
                        rounded="0"
                        :loading="saving"
                        :disabled="saveMode === 'create-new' && !saveName.trim()"
                        @click="confirmSave"
                    >
                        Save
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { useWorkflowStaging } from "@/composables/useWorkflowStaging";

const props = defineProps({
    typeId: { type: [Number, null], default: null },
    defId: { type: [Number, null], default: null },
});
const emit = defineEmits(["saved", "discarded"]);

const staging = useWorkflowStaging();
const dirty = computed(() => (props.typeId ? staging.isDirty(props.typeId) : false));

const saveDialog = ref(false);
const saveMode = ref("overwrite");
const saveName = ref("");
const saveNotes = ref("");
const saving = ref(false);
const saveError = ref("");

function onDiscard() {
    if (!props.typeId) return;
    staging.discard(props.typeId);
    saveError.value = "";
    emit("discarded");
}

async function confirmSave() {
    if (!props.typeId || !props.defId) return;
    const name = saveName.value.trim();
    if (saveMode.value === "create-new" && !name) {
        saveError.value = "Give the new version a name first.";
        return;
    }
    saveError.value = "";
    saving.value = true;
    try {
        const { meta } = await staging.saveAll(props.typeId, props.defId, {
            mode: saveMode.value,
            name: saveMode.value === "create-new" ? name : name || undefined,
            notes: saveNotes.value.trim() || undefined,
        });
        saveDialog.value = false;
        saveName.value = "";
        saveNotes.value = "";
        emit("saved", meta);
    } catch (e) {
        saveError.value =
            e?.response?.data?.message ||
            (e?.response?.status === 409
                ? "Someone saved while you were editing. Reload to get the latest, then re-apply your changes."
                : "Saving the staged changes failed.");
    } finally {
        saving.value = false;
    }
}
</script>
