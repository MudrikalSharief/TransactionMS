<template>
    <!-- Preview of the tracking slip; Print sends exactly this page to the
         printer (or "Save as PDF"). -->
    <v-dialog :model-value="modelValue" max-width="720" scrollable @update:model-value="(v) => emit('update:modelValue', v)">
        <v-card rounded="0">
            <v-card-title class="d-flex align-center pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                    <v-icon color="#005EED">mdi-printer-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">Tracking slip</span>
                <v-spacer />
                <v-btn icon="mdi-close" variant="text" color="grey-darken-3" aria-label="Close" @click="close" />
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-0 slip-stage">
                <div v-if="building" class="d-flex flex-column align-center justify-center pa-12 text-medium-emphasis">
                    <v-progress-circular indeterminate color="primary" class="mb-3" />
                    Preparing the slip…
                </div>
                <v-alert v-else-if="error" type="error" variant="tonal" rounded="0" class="ma-4">{{ error }}</v-alert>
                <iframe v-else-if="html" :srcdoc="html" title="Tracking slip preview" class="slip-frame" />
            </v-card-text>
            <v-divider />
            <v-card-actions class="d-flex justify-space-between px-6 py-4">
                <span class="text-caption text-medium-emphasis">Prints on A5. Choose "Save as PDF" to keep a copy.</span>
                <div class="d-flex ga-2">
                    <v-btn variant="text" color="grey-darken-3" rounded="0" @click="close">Close</v-btn>
                    <v-btn color="primary" variant="flat" rounded="0" prepend-icon="mdi-printer" :disabled="!html" :loading="printing" @click="print">
                        Print
                    </v-btn>
                </div>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { ref, watch } from "vue";
import { buildSlipHtml, printHtml } from "@/utils/trackingSlip";

const props = defineProps({
    modelValue: { type: Boolean, default: false },
    tx: { type: Object, default: null },
    printedBy: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const html = ref("");
const building = ref(false);
const printing = ref(false);
const error = ref("");

// Build the slip each time the dialog opens (current step may have moved).
watch(
    () => props.modelValue,
    async (open) => {
        if (!open || !props.tx) return;
        building.value = true;
        error.value = "";
        html.value = "";
        try {
            html.value = await buildSlipHtml(props.tx, { printedBy: props.printedBy });
        } catch {
            error.value = "The slip could not be prepared. Please try again.";
        } finally {
            building.value = false;
        }
    },
);

async function print() {
    printing.value = true;
    try {
        await printHtml(html.value);
    } catch {
        error.value = "Printing could not start. Please try again.";
    } finally {
        printing.value = false;
    }
}

function close() {
    emit("update:modelValue", false);
}
</script>

<style scoped>
.slip-stage {
    background: #e9edf3;
}
.slip-frame {
    display: block;
    width: 100%;
    height: min(70vh, 560px);
    border: 0;
    background: #e9edf3;
}
</style>
