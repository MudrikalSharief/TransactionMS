<template>
    <v-dialog v-model="open" max-width="560">
        <v-card class="pm-dialog pm-pick-dialog" flat>
            <div class="pm-pick-hd">
                <span class="pm-pick-badge">
                    <v-icon size="22">mdi-history</v-icon>
                </span>
                <div class="pm-pick-ht">
                    <h2>Select a file from <em>{{ stepLabel }}</em></h2>
                    <p>Reuse a file without uploading it again.</p>
                </div>
                <button
                    type="button"
                    class="pm-close"
                    aria-label="Close"
                    :disabled="savingId !== null"
                    @click="close"
                >
                    <v-icon size="19">mdi-close</v-icon>
                </button>
            </div>

            <div class="pm-pick-tools">
                <div class="pm-pick-search">
                    <v-icon size="18" class="pm-pick-search-icon">mdi-magnify</v-icon>
                    <input
                        ref="searchRef"
                        v-model="query"
                        type="search"
                        placeholder="Search by file name, requirement or uploader"
                        aria-label="Search files"
                        autocomplete="off"
                    />
                    <button
                        v-if="query"
                        type="button"
                        class="pm-pick-clear"
                        aria-label="Clear search"
                        @click="clearSearch"
                    >
                        <v-icon size="15">mdi-close</v-icon>
                    </button>
                </div>
                <div class="pm-pick-chips" role="group" aria-label="Show">
                    <button
                        v-for="chip in chips"
                        :key="chip.key"
                        type="button"
                        class="pm-pick-chip"
                        :class="{ 'is-active': filter === chip.key }"
                        :aria-pressed="filter === chip.key ? 'true' : 'false'"
                        @click="filter = chip.key"
                    >
                        {{ chip.label }} <b>{{ chip.count }}</b>
                    </button>
                </div>
            </div>

            <div class="pm-body pm-pick-body">
                <div v-if="error" class="pm-alert">
                    <v-icon size="17">mdi-alert-circle-outline</v-icon>
                    {{ error }}
                </div>

                <template v-if="displayedReq.length || displayedExtra.length">
                    <div v-if="displayedReq.length" class="pm-pick-group">
                        <div class="pm-pick-gh">Requirement files</div>
                        <div class="pm-pick-list">
                            <ProceedFileRow
                                v-for="f in displayedReq"
                                :key="f.id"
                                :title="f.original_name"
                                :subtitle="`${formatSize(f.size_bytes)} · ${uploaderFor(f)}`"
                                :ext-label="extLabel(f)"
                                :ext-class="extClass(f)"
                                :label="tagFor(f)"
                                :view-url="fileViewUrl(f)"
                            >
                                <template #actions>
                                    <button
                                        type="button"
                                        class="pm-pick-use"
                                        :disabled="savingId !== null"
                                        :aria-label="`Use ${f.original_name}`"
                                        :title="`Link this file to your step`"
                                        @click="emit('use', f)"
                                    >
                                        <v-progress-circular
                                            v-if="savingId === f.id"
                                            size="15"
                                            width="2"
                                            indeterminate
                                        />
                                        <v-icon v-else size="15">mdi-link-variant</v-icon>
                                        {{ savingId === f.id ? 'Linking…' : 'Use file' }}
                                    </button>
                                </template>
                            </ProceedFileRow>
                        </div>
                    </div>

                    <div v-if="displayedExtra.length" class="pm-pick-group">
                        <div class="pm-pick-gh">Additional files</div>
                        <div class="pm-pick-list">
                            <ProceedFileRow
                                v-for="f in displayedExtra"
                                :key="f.id"
                                :title="f.original_name"
                                :subtitle="`${formatSize(f.size_bytes)} · ${uploaderFor(f)}`"
                                :ext-label="extLabel(f)"
                                :ext-class="extClass(f)"
                                :label="tagFor(f)"
                                :view-url="fileViewUrl(f)"
                            >
                                <template #actions>
                                    <button
                                        type="button"
                                        class="pm-pick-use"
                                        :disabled="savingId !== null"
                                        :aria-label="`Use ${f.original_name}`"
                                        :title="`Link this file to your step`"
                                        @click="emit('use', f)"
                                    >
                                        <v-progress-circular
                                            v-if="savingId === f.id"
                                            size="15"
                                            width="2"
                                            indeterminate
                                        />
                                        <v-icon v-else size="15">mdi-link-variant</v-icon>
                                        {{ savingId === f.id ? 'Linking…' : 'Use file' }}
                                    </button>
                                </template>
                            </ProceedFileRow>
                        </div>
                    </div>
                </template>

                <div v-else class="pm-pick-empty">
                    <b>No files found</b>
                    <template v-if="query.trim()"> for “{{ query.trim() }}”</template>.
                    <br />Try a different word or filter.
                </div>

                <div class="pm-pick-note">
                    <v-icon size="18">mdi-information</v-icon>
                    <span>
                        Linked files stay owned by <b>{{ stepLabel }}</b>. You can remove the link from
                        your step, but deleting the file in {{ stepLabel }} removes it everywhere, and
                        this requirement shows as missing again.
                    </span>
                </div>
            </div>

            <div class="pm-pick-ftr">
                <span class="pm-pick-sum">Select one file to link</span>
                <button
                    type="button"
                    class="pm-btn ghost"
                    :disabled="savingId !== null"
                    @click="close"
                >Close</button>
            </div>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, nextTick, ref, watch } from 'vue'
import { fileViewUrl } from '@/composables/useFileView'
import ProceedFileRow from '@/components/ProceedFileRow.vue'

const open = defineModel('open', { default: false })
const props = defineProps({
    files: { type: Array, default: () => [] },
    stepLabel: { type: String, default: '' },
    savingId: { type: [Number, String], default: null },
    error: { type: String, default: '' },
})
const emit = defineEmits(['use'])

const query = ref('')
const filter = ref('all')
const searchRef = ref(null)

watch(open, (isOpen) => {
    if (!isOpen) return
    query.value = ''
    filter.value = 'all'
    nextTick(() => searchRef.value?.focus())
})

const isAdditional = (f) => !f?.requirement_definition_id
const reqAll = computed(() => (props.files || []).filter((f) => !isAdditional(f)))
const extraAll = computed(() => (props.files || []).filter(isAdditional))

const chips = computed(() => [
    { key: 'all', label: 'All', count: (props.files || []).length },
    { key: 'req', label: 'Requirements', count: reqAll.value.length },
    { key: 'extra', label: 'Additional', count: extraAll.value.length },
])

const searched = computed(() => {
    const q = String(query.value || '').trim().toLowerCase()
    if (!q) return props.files || []
    return (props.files || []).filter((f) => {
        const hay = [
            f.original_name,
            f.label,
            f.requirement?.name,
            f.requirement?.code,
            f.uploader?.name,
            f.uploaded_by?.name,
        ].filter(Boolean).join(' ').toLowerCase()
        return hay.includes(q)
    })
})

const displayedReq = computed(() =>
    filter.value === 'extra' ? [] : searched.value.filter((f) => !isAdditional(f)),
)
const displayedExtra = computed(() =>
    filter.value === 'req' ? [] : searched.value.filter(isAdditional),
)

function tagFor(f) {
    if (isAdditional(f)) return f.label || 'Additional'
    return f.requirement?.name || f.requirement?.code || 'Requirement'
}

function uploaderFor(f) {
    return f.uploader?.name || f.uploaded_by?.name || '—'
}

function formatSize(b) {
    const n = Number(b || 0)
    if (n < 1024) return `${n} B`
    if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`
    return `${(n / 1024 / 1024).toFixed(1)} MB`
}

function extOf(f) {
    const name = String(f?.original_name || '')
    const ext = (name.split('.').pop() || '').toLowerCase()
    return ext && ext !== name.toLowerCase() ? ext : ''
}

function extLabel(f) {
    const ext = extOf(f)
    return ext ? ext.slice(0, 4).toUpperCase() : 'FILE'
}

function extClass(f) {
    const ext = extOf(f)
    if (ext === 'pdf') return 'pdf'
    if (['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'svg'].includes(ext)) return 'img'
    if (['doc', 'docx', 'odt', 'rtf'].includes(ext)) return 'doc'
    if (['xls', 'xlsx', 'ods', 'csv'].includes(ext)) return 'xls'
    return ''
}

function clearSearch() {
    query.value = ''
    nextTick(() => searchRef.value?.focus())
}

function close() {
    if (props.savingId !== null) return
    open.value = false
}
</script>
