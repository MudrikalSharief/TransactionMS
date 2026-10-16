<template>
    <v-dialog v-model="dialog.open" max-width="480" persistent>
        <v-card rounded="0">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="warning" variant="tonal" rounded="0" size="40" class="mr-3">
                    <v-icon color="warning">mdi-alert-outline</v-icon>
                </v-avatar>
                <span class="text-h6 font-weight-bold">{{ dialog.title }}</span>
            </v-card-title>
            <v-divider />
            <v-card-text class="pa-5 text-body-2">
                {{ dialog.message }}
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end ga-2">
                <v-btn variant="text" @click="cancel">{{ dialog.cancelLabel }}</v-btn>
                <v-btn
                    :color="dialog.tone === 'danger' ? 'error' : 'grey-darken-3'"
                    rounded="0"
                    @click="confirm(true)"
                >{{ dialog.confirmLabel }}</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { useConfirmDialog } from "@/composables/useConfirm";

const { dialog, confirm, cancel } = useConfirmDialog();
</script>
