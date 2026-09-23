<template>
    <v-dialog :model-value="open" max-width="520" @update:model-value="(v) => emit('update:open', v)">
        <v-card rounded="0">
            <v-card-title class="pa-5">
                <div class="text-h6 font-weight-bold">{{ title }}</div>
                <div v-if="message" class="text-caption text-medium-emphasis font-weight-bold mt-1">
                    {{ message }}
                </div>
            </v-card-title>
            <v-divider />
            <v-card-actions class="justify-end ga-2">
                <v-btn variant="text" :disabled="saving" @click="emit('update:open', false)">Cancel</v-btn>
                <v-btn
                    :color="confirmColor"
                    rounded="0"
                    :loading="saving"
                    :disabled="saving"
                    @click="emit('confirm')"
                >{{ confirmLabel }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
defineProps({
    open: { type: Boolean, default: false },
    title: { type: String, default: 'Are you sure?' },
    message: { type: String, default: '' },
    confirmLabel: { type: String, default: 'Confirm' },
    confirmColor: { type: String, default: 'grey-darken-3' },
    saving: { type: Boolean, default: false },
})

const emit = defineEmits(['update:open', 'confirm'])
</script>
