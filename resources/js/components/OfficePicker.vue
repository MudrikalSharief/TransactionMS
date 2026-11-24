<template>
    <v-menu
        v-model="menuOpen"
        location="bottom end"
        offset="6"
        :close-on-content-click="false"
    >
        <template #activator="{ props: activatorProps }">
            <button
                v-bind="activatorProps"
                type="button"
                class="topsteps-month chart-office-chip"
                aria-haspopup="listbox"
                :aria-expanded="menuOpen ? 'true' : 'false'"
                :aria-controls="panelId"
                :title="summary"
            >
                <span v-if="selectedSeal" class="office-seal chart-office-seal" aria-hidden="true">
                    <img v-if="selectedSeal.icon" :src="selectedSeal.icon" alt="" />
                    <span v-else>{{ selectedSeal.initials }}</span>
                </span>
                <v-icon v-else size="16">mdi-office-building-outline</v-icon>
                <span>{{ summary }}</span>
                <v-icon size="16">mdi-chevron-down</v-icon>
            </button>
        </template>
        <v-card
            :id="panelId"
            class="office-panel"
            rounded="lg"
            elevation="8"
            role="dialog"
            :aria-label="single ? 'Choose an office' : 'Choose offices'"
        >
            <div class="office-panel-head">
                <input
                    ref="searchEl"
                    v-model="search"
                    class="office-search"
                    type="search"
                    placeholder="Search by name or abbreviation"
                    aria-label="Search offices"
                />
                <button
                    v-if="!single"
                    type="button"
                    class="office-clear"
                    @click="clear"
                >
                    Show all offices
                </button>
            </div>
            <div
                class="office-grid"
                role="listbox"
                aria-label="Offices"
                :aria-multiselectable="single ? 'false' : 'true'"
            >
                <button
                    v-for="o in filteredOptions"
                    :key="o.value"
                    type="button"
                    class="office-card"
                    :class="{ 'is-selected': modelValue.includes(o.value) }"
                    role="option"
                    :aria-selected="modelValue.includes(o.value) ? 'true' : 'false'"
                    :aria-label="o.office?.name || o.title"
                    v-tooltip="o.office?.name || o.title"
                    @click="toggle(o.value)"
                    @mouseenter="hover = o"
                    @mouseleave="hover = null"
                    @focus="hover = o"
                    @blur="hover = null"
                >
                    <span class="office-seal" aria-hidden="true">
                        <img v-if="o.icon" :src="o.icon" alt="" />
                        <span v-else>{{ o.initials }}</span>
                    </span>
                    <span class="office-card-abbr">{{ o.code }}</span>
                </button>
                <div v-if="!filteredOptions.length" class="office-no-match">
                    No offices match “{{ search }}”. Try the abbreviation.
                </div>
            </div>
            <div class="office-panel-foot">
                <template v-if="hover">
                    <b>{{ hover.code }}</b> · {{ hover.office?.name || hover.title }}
                </template>
                <template v-else-if="selected.length">
                    Selected: <b>{{ selected.map((o) => o.code).join(', ') }}</b>
                </template>
                <template v-else>
                    Hover or focus an office to see its full name.
                </template>
            </div>
        </v-card>
    </v-menu>
</template>

<script setup>
import { computed, nextTick, ref, useId, watch } from 'vue'
import { officeIcon } from '@/utils/officeIcons'

const props = defineProps({
    // Selected office IDs. Office heads always pass exactly one.
    modelValue: { type: Array, default: () => [] },
    offices: { type: Array, default: () => [] },
    single: { type: Boolean, default: false },
    // Shown when nothing is selected and this picker is single-select.
    fallbackLabel: { type: String, default: '' },
})
const emit = defineEmits(['update:modelValue'])

const panelId = useId()
const menuOpen = ref(false)
const search = ref('')
const searchEl = ref(null)
const hover = ref(null)

function officeInitials(office) {
    const code = String(office?.code || '').trim()
    if (code) return code.slice(0, 2).toUpperCase()
    return (
        String(office?.name || '?')
            .trim()
            .split(/\s+/)
            .slice(0, 2)
            .map((part) => part[0] || '')
            .join('')
            .toUpperCase() || '?'
    )
}

const options = computed(() =>
    [...props.offices]
        .sort((a, b) => String(a.name).localeCompare(String(b.name)))
        .map((o) => ({
            title: o.code ? `${o.name} (${o.code})` : o.name,
            value: o.id,
            code: o.code || o.name,
            office: o,
            icon: officeIcon(o),
            initials: officeInitials(o),
        })),
)
const selected = computed(() =>
    options.value.filter((o) => props.modelValue.includes(o.value)),
)
const selectedSeal = computed(() => selected.value[0] || null)
const summary = computed(() => {
    if (props.single) {
        return selected.value[0]?.code || props.fallbackLabel || 'No office assigned'
    }
    const codes = selected.value.map((o) => o.code)
    if (!codes.length) return 'All offices'
    return codes.length <= 2 ? codes.join(', ') : `${codes.length} offices`
})
const filteredOptions = computed(() => {
    const q = search.value.trim().toLowerCase()
    if (!q) return options.value
    return options.value.filter((o) =>
        `${o.code} ${o.office?.name || ''}`.toLowerCase().includes(q),
    )
})

function toggle(id) {
    if (props.single) {
        emit('update:modelValue', [id])
        menuOpen.value = false
        return
    }
    const next = new Set(props.modelValue)
    if (next.has(id)) next.delete(id)
    else next.add(id)
    emit('update:modelValue', [...next])
}

function clear() {
    if (props.single) return
    emit('update:modelValue', [])
}

watch(menuOpen, async (open) => {
    search.value = ''
    hover.value = null
    if (!open) return
    await nextTick()
    searchEl.value?.focus()
})
watch(search, () => {
    hover.value = null
})
</script>
