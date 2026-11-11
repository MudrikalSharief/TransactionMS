<template>
    <div class="pm-file" :class="{ 'is-linked': linked }">
        <span class="pm-ext" :class="extClass">{{ extLabel }}</span>
        <div class="pm-fi">
            <b :title="title">{{ title }}</b>
            <small>{{ subtitle }}</small>
            <span v-if="label" class="pm-tag o">{{ label }}</span>
            <span v-if="linked" class="pm-tag o">Linked</span>
            <span v-if="oldFile" class="pm-tag o">Old file</span>
        </div>
        <a
            v-if="viewUrl"
            class="pm-ib"
            :href="viewUrl"
            target="_blank"
            rel="noopener"
            :title="`View ${title}`"
            @click.stop
        >
            <v-icon size="18">mdi-eye-outline</v-icon>
        </a>
        <slot name="actions" />
        <button
            v-if="canRemove"
            type="button"
            class="pm-ib d"
            :title="removeTitle"
            :disabled="disabled"
            @click.stop="emit('delete')"
        >
            <v-progress-circular v-if="deleting" size="16" indeterminate />
            <v-icon v-else size="18">{{ linked ? 'mdi-link-off' : 'mdi-trash-can-outline' }}</v-icon>
        </button>
    </div>
</template>

<script setup>
// One file row in the redesigned proceed-modal lists. Presentation only:
// AttachmentList owns eligibility (linked/old/locked) and the delete flow.
defineProps({
    title: { type: String, default: '' },
    subtitle: { type: String, default: '' },
    extLabel: { type: String, default: 'FILE' },
    extClass: { type: String, default: '' },
    // Optional batch/label tag shown under the filename.
    label: { type: String, default: '' },
    viewUrl: { type: String, default: '' },
    linked: { type: Boolean, default: false },
    oldFile: { type: Boolean, default: false },
    canRemove: { type: Boolean, default: false },
    removeTitle: { type: String, default: 'Remove file' },
    deleting: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
})

const emit = defineEmits(['delete'])
</script>
