<template>
    <div class="guide-panel pa-3 px-5">
        <div class="font-weight-bold mb-1">{{ title }}</div>
        <div v-if="horizontal" class="d-flex flex-wrap align-start" style="gap: 8px 24px">
            <div v-for="(sec, si) in sections" :key="si" style="flex: 1 1 200px; min-width: 0">
                <div class="guide-sec text-caption font-weight-bold mb-1">
                    {{ sec.title }}
                </div>
                <div class="d-flex flex-wrap" style="gap: 4px 14px">
                    <span
                        v-for="(row, ri) in sec.rows"
                        :key="ri"
                        class="d-inline-flex align-center text-caption"
                    >
                        <span v-if="row.dot" class="guide-dot mr-1 flex-shrink-0" :style="{ background: row.dot }" />
                        <span><b v-if="row.term">{{ row.term }} - </b>{{ row.text }}</span>
                    </span>
                </div>
            </div>
        </div>
        <table v-else class="guide-tbl">
            <tbody>
                <template v-for="(sec, si) in sections" :key="si">
                    <tr>
                        <td colspan="2" class="guide-sec text-caption font-weight-bold">
                            {{ sec.title }}
                        </td>
                    </tr>
                    <tr v-for="(row, ri) in sec.rows" :key="ri">
                        <td class="guide-c1">
                            <span v-if="row.dot" class="guide-dot" :style="{ background: row.dot }" />
                        </td>
                        <td class="guide-c2 text-caption">
                            <b v-if="row.term">{{ row.term }} - </b>{{ row.text }}
                        </td>
                    </tr>
                </template>
            </tbody>
        </table>
    </div>
</template>

<script setup>
// sections: [{ title, rows: [{ dot?, term?, text }] }]
defineProps({
    title: { type: String, default: 'Guide' },
    sections: { type: Array, default: () => [] },
    horizontal: { type: Boolean, default: false },
})
</script>

<style scoped>
.guide-panel {
    background: #f8fafc;
    border-bottom: 1px solid #e2e8f0;
    color: #1e293b;
}
.guide-tbl {
    width: 100%;
    border-collapse: collapse;
}
.guide-tbl td {
    padding: 2px 8px 2px 0;
    vertical-align: middle;
}
.guide-sec {
    color: #64748b;
    padding-top: 6px !important;
}
.guide-c1 {
    width: 26px;
}
</style>
